% Scientific reports paper submisson Fig. 1a
% Pinv-Recon demonstration for generic 1D, 2D, 3D cases

addpath('../dependencies/')

%===
% 1D
%===
N.mtx=2048;
Rx=single(linspace(-0.5,0.5,N.mtx));
Kx=single(N.mtx*(rand((1.5*N.mtx)^1,1)-0.5));
% 2D Modified Shepp-Logan Phantom
BILD=phantom('Modified Shepp-Logan',N.mtx);
BILD(BILD>0.6)=0.6; BILD=single(BILD/0.6);

tic,
ENCODE=exp(1i*2*pi*(Kx*Rx(:)')); toc, 
EHE=ENCODE'*ENCODE; toc, % overdetermined / least-squares
tic, EigVal=eig(EHE); toc, 
lambda=1e-3*maxEig(EHE); toc, % -> lambda to be optimized
[L,flag]=chol(EHE+lambda*eye(size(EHE)),'lower'); toc, 
invL=inv(L); toc, clear L; iEHE=invL'*invL; toc, clear invL;
RECON=iEHE*ENCODE'; toc, 
reconBILD=RECON*(ENCODE*BILD(:,N.mtx/2));

figure(123), W=1/3; W2=0.16;
subplot('position',[0*W+0.03,2*W+0.03,W-0.06,W-0.06]);
plot(Kx(1:4:end),32*(rand(length(Kx(1:4:end)),1)-0.5),'.k','MarkerSize',0.2);  xlabel('k_x','FontSize',16,'HorizontalAlignment','center','VerticalAlignment','bottom'); 
set(gca,'Color','none','XColor','k','YColor','none','Box','off','XAxisLocation','origin');
set(gca,'xtick',-N.mtx/2:N.mtx/2:N.mtx/2,'ytick',[],'FontSize',16); grid off
axis([N.mtx/2*[-1.2,1.2,-1,1]]); 
subplot('position',[0.5*W-W2/2,1*W+0.03,W2,0.9*W-0.06]);
plot(flip(EigVal/max(EigVal)),'-k','LineWidth',3); axis([1,length(EigVal),1e-3,1]);
set(gca,'YScale','log','XTick',[1 N.mtx/2 N.mtx],'XTickLabel',{'1','1024','2048\newline=2048^1'},'YTick',10.^(-3:0),'FontSize',16);
grid on, grid off, grid on, ylabel('Eigenvalues','FontSize',16);
subplot('position',[0.5*W-0.12,0*W+0.06,0.24,0.9*W-0.07]);
imagesc(repmat(BILD(N.mtx/2,:),[32,1])); axis image, colormap gray; grid off
set(gca,'xtick',[1,N.mtx/2,N.mtx],'XTickLabel',{'-0.5','0','+0.5'},'ytick',[],'FontSize',16);
xlabel('x','FontSize',16);

%===
% 2D
%===
N.mtx=128;
xi=single(linspace(-0.5,0.5,N.mtx));
[Rx,Ry]=ndgrid(xi,xi);
K=single(N.mtx*(rand((1.5*N.mtx)^2,2)-0.5));
Kx=K(:,1); Ky=K(:,2); 

% 2D Modified Shepp-Logan Phantom
BILD=phantom('Modified Shepp-Logan',N.mtx);
BILD(BILD>0.6)=0.6; BILD=single(BILD/0.6);

tic,
ENCODE=exp(1i*2*pi*(Kx*Rx(:)'+Ky*Ry(:)')); toc, 
EHE=ENCODE'*ENCODE; toc, % overdetermined / least-squares
tic, EigVal=eig(EHE); toc, 
lambda=1e-3*maxEig(EHE); toc, % -> lambda to be optimized
[L,flag]=chol(EHE+lambda*eye(size(EHE)),'lower'); toc, 
invL=inv(L); toc, clear L; iEHE=invL'*invL; toc, clear invL;
RECON=iEHE*ENCODE'; toc, 

BILD1=RECON*(ENCODE*BILD(:));
reconBILD=reshape(abs(BILD1),N.mtx*[1,1]);

figure(123), W=1/3;
subplot('position',[1*W+0.03,2*W+0.03,W-0.06,W-0.06]);
plot(Kx(1:4:end),Ky(1:4:end),'.k','MarkerSize',0.05); 
axis image, axis(76.8*[-1 1 -1 1]); xlabel('k_x','FontSize',16); ylabel('k_y','FontSize',16);
set(gca,'xtick',[-64:64:64],'ytick',[-64:64:64],'FontSize',16);
grid on,
subplot('position',[1.5*W-W2/2,1*W+0.03,W2,0.9*W-0.06]);
plot(flip(EigVal/max(EigVal)),'-k','LineWidth',3); axis([1,length(EigVal),1e-3,1]);
set(gca,'YScale','log','XTick',[1 8192 16384],'XTickLabel',{'1','8192','16384\newline=128^2'},'YTick',10.^(-3:0),'FontSize',16);
grid on, grid off, grid on, ylabel('Eigenvalues','FontSize',16);
subplot('position',[1*W+0.03,0*W+0.06,W-0.06,0.9*W-0.07]);
imagesc(xi,xi,(BILD),[0,1]); axis image, axis(0.5*[-1 1 -1 1]); colormap(gray)
set(gca,'xtick',[-0.5:0.5:0.5],'Xticklabel',{'-0.5','0','+0.5'},...
        'ytick',[-0.5:0.5:0.5],'Yticklabel',{'-0.5','0','+0.5'},'FontSize',16);
xlabel('x','FontSize',16); ylabel('y','FontSize',16);

%%
%===
% 3D
%===
N.mtx=48;
xi=single(linspace(-0.5,0.5,N.mtx));
[Rx,Ry,Rz]=ndgrid(xi,xi,xi);
K=single(N.mtx*(rand((1.5*N.mtx)^3,3)-0.5));
Kx=K(:,1); Ky=K(:,2); Kz=K(:,3);

% 3D Modified Shepp-Logan Phantom
BILD=phantom3d('Modified Shepp-Logan',N.mtx);
BILD(BILD>0.6)=0.6; BILD=single(BILD/0.6);

tic,
ENCODE=exp(1i*2*pi*(Kx*Rx(:)'+Ky*Ry(:)'+Kz*Rz(:)')); toc, 
EHE=ENCODE'*ENCODE; toc, % overdetermined / least-squares
tic, EigVal=eig(EHE); toc, 
lambda=1e-3*maxEig(EHE); toc, % -> lambda to be optimized
[L,flag]=chol(EHE+lambda*eye(size(EHE)),'lower'); toc, 
invL=inv(L); toc, clear L; iEHE=invL'*invL; toc, clear invL;
RECON=iEHE*ENCODE'; toc, 

BILD1=RECON*(ENCODE*BILD(:));
reconBILD=reshape(abs(BILD1),N.mtx*[1,1,1]);

figure(123), W=1/3; W2=0.16
subplot('position',[2*W+0.03,2*W+0.03,W-0.06,W-0.06]);
plot3(Kx(1:16:end),Ky(1:16:end),Kz(1:16:end),'.k','MarkerSize',0.05);  xlabel('k_x','FontSize',16); ylabel('k_y','FontSize',16);  zlabel('k_z','FontSize',16); 
set(gca,'xtick',[-24:24:24],'ytick',[-24:24:24],'ztick',[-24:24:24],'FontSize',16);
axis image, axis(28.8*[-1 1 -1 1 -1 1]); grid on, box on,
subplot('position',[2.5*W-W2/2,1*W+0.03,W2,0.9*W-0.06]);
plot(flip(EigVal/max(EigVal)),'-k','LineWidth',3); axis([1,length(EigVal),1e-3,1]);
set(gca,'YScale','log','XTick',[1 55296 110592],'XTickLabel',{'1' '55296' '110592\newline=48^3'},....
    'YTick',10.^(-3:0),'FontSize',16); ylabel('Eigenvalues','FontSize',16);
grid on, grid off, grid on,
subplot('position',[2*W+0.03,0*W+0.045,W-0.06,W-0.07]);
h=slice(xi,xi,xi,BILD,xi(round(N.mtx/2)),xi(round(N.mtx/2)),xi(round(N.mtx/2)));
set(h,'EdgeColor','none'); set(gca,'Color','none','FontSize',16); view(136,24)
xlabel('x','FontSize',16); ylabel('y','FontSize',16);  zlabel('z','FontSize',16); axis image, grid off, 
axis(0.5*[-1 1 -1 1 -1 1]); box on,
colormap gray
