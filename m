Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYAAK2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYAAK2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYAAK16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:27:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34958 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYAAK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:27:58 -0500
Date: Tue, 1 Jan 2008 11:27:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch 6/8] FRV: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101102759.GF28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101073645.GG2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101073645.GG2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:36:45PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all frv Makefiles.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/arch/frv/boot/Makefile b/arch/frv/boot/Makefile
> index dc6f038..d93f768 100644
> --- a/arch/frv/boot/Makefile
> +++ b/arch/frv/boot/Makefile
> @@ -10,7 +10,7 @@
>  
>  targets := Image zImage bootpImage
>  
> -SYSTEM	=$(TOPDIR)/$(LINUX)
> +SYSTEM	=$(objtree)/$(LINUX)
>  
>  ZTEXTADDR	 = 0x02080000
>  PARAMS_PHYS	 = 0x0207c000
> @@ -45,7 +45,7 @@ zImage:	$(CONFIGURE) compressed/$(LINUX)
>  bootpImage: bootp/bootp
>  	$(OBJCOPY) -O binary -R .note -R .comment -S bootp/bootp $@
>  
> -compressed/$(LINUX): $(TOPDIR)/$(LINUX) dep
> +compressed/$(LINUX): $(objtree)/$(LINUX) dep
>  	@$(MAKE) -C compressed $(LINUX)
>  
>  bootp/bootp: zImage initrd
> @@ -59,10 +59,10 @@ initrd:
>  # installation
>  #
>  install: $(CONFIGURE) Image
> -	sh ./install.sh $(KERNELRELEASE) Image $(TOPDIR)/System.map "$(INSTALL_PATH)"
> +	sh ./install.sh $(KERNELRELEASE) Image $(objtree)/System.map "$(INSTALL_PATH)"
>  
>  zinstall: $(CONFIGURE) zImage
> -	sh ./install.sh $(KERNELRELEASE) zImage $(TOPDIR)/System.map "$(INSTALL_PATH)"
> +	sh ./install.sh $(KERNELRELEASE) zImage $(objtree)/System.map "$(INSTALL_PATH)"

In this file we can just drop use of $(TOPDIR) since this is our
current directory anyway.

	Sam
