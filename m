Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYHDFDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYHDFDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYHDFDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:03:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:5125 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYHDFDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cUU8AniAdMvXJxQZmow0s75LZH2W2HASyMPSjeVO/Zcstc2ITnwOjpilInyXq3/gVA
         RVYZ0MGg/czVjqZ+y/tSaNsk4KY5tGWB8WXQLEJCQKOdxnSd+7Uz+qxhROnyJSPYYe1M
         tLCwNSOFdNUMpkOlHV6jSkwA4otveolLReHbk=
Message-ID: <88652ca70808032203t39eef690of589bdef15dc2618@mail.gmail.com>
Date: Sun, 3 Aug 2008 22:03:35 -0700
From: "Bob van Manen" <bobm75@gmail.com>
To: "Satish Eerpini" <eerpini@gmail.com>
Subject: Re: Kernel Installer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satish,

I don't know much about the kernel build process, so I don't know
whether it would work or not.

But you could try running make with the -n option first to see the
commands that are going to be executed.  That way you can figure out
how many files are going to be compiled.

I hope that works for you.

Regards,

bob

On Sun, Aug 3, 2008 at 1:50 PM, Satish Eerpini <eerpini@gmail.com> wrote:
> Hello everyone , :
>
> i have been writing a kernel installer which may make the kernel
> installation process a lot more easier for noobs , (don ask me why
> noobs would like to compile a kernel) ,  but atleast till they learn
> to do it the good way !
>
> i have written some code which is below , well i am stuck at one thing , ...
> once the .config file is set , is there any method to compute the
> exact no of files that are going to be compiled ??
> lack of this knowledge is clearly visible in the use of a "while(1)"
> in the code below :
>
>
>
>
> #include <stdio.h>
>
>
> int main(int argc, char * argv[]) {
>
>    char buf[100],syscommand[100];
>    FILE *fp;
>    int i=0,j=0,k=0,l=0;
>    int checking_done=0;
>    strcpy(buf,"\0");
>
>    fflush(stdout);
>
>    strcpy(syscommand,"make -C ");
>    if(argc==2){
>        strcat(syscommand,argv[1]);
>    }
>    else{
>
>        printf("The program accepts the kernel source \n directory as
> the single argument.\n Please provide necessary arguments\n");
>        return ;
>    }
>
>
>
>    printf("\n\n\t\t\t\t\t\t Kernel Installer V1.0\n\n ");
>
>
>    fp= popen(syscommand,"r");
>    do{
>
>        fscanf(fp,"%s",buf);
>
>            if(checking_done!=1){
>
>                if(strcmp(buf,"CHK")==0){
>                    fscanf(fp,"%s",buf);
>                        printf("\rChecking file : %-30s\t\n",buf);
>
>
>                }
>                if(strcmp(buf,"CALL")==0){
>                    fscanf(fp,"%s",buf);
>
>                    printf("\rCalling script : %s\t\n",buf);
>
>                }
>            }
>
>            if(strcmp(buf,"LD")==0){
>                fscanf(fp,"%s",buf);
>
>
>                printf("\rLinking File : %s\t",buf);
>                l++;
>                checking_done=1;
>
>            }
>
>            if(strcmp(buf,"CC")==0){
>                fscanf(fp,"%s",buf);
>                if(strcmp(buf,"[M]")==0){
>                    fscanf(fp,"%s",buf);
>                    printf("\rCompiling module (%-4d files, %-4d
> modules compiled): %-60s\t",i,l,buf);
>                    l++;
>                }
>                else
>                    printf("\rCompiling        (%-4d files, %-4d
> modules compiled) : %-60s\t",i,l,buf);
>                i++;
>
>                switch(i%4){
>                    case 0:
>                        printf(" | ");
>                        break;
>                    case 1:
>                        printf(" / ");
>                        break;
>                    case 2:
>                        printf(" - ");
>                        break;
>                    case 3:
>                        printf(" \\ ");
>                        break;
>                }
>                for(k=0;k<j;k++)
>                    printf("=");
>                printf(">");
>
>                if((i%100)==0 && i!=0){
>                    j++;
>                }
>
>                checking_done=1;
>
>            }
>        fflush(stdout);
>        }while(1);
>    pclose(fp);
>
>    return 0;
>
> }
>
> there is some more work that i remain to add, like being able to start
> from the kernel source , that is just provide the path to the archive
> and it does everything else and so on ,
> but for now i am stuck here !
>
> Thanks
> Satish
>
> --
> http://satish.playdrupal.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
