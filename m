Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYKPIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYKPIAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYKPIAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:00:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:21715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYKPIAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:00:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Axcn0xF84P+bhh+IRFVaMBum26xo03yBq8qj7PSYKlEpnN75IV/G7UPwVrTsKmN+lQ
         aQqCvmXETLxnrhc29EyRRJG47Bnk1/riByzsdYJozpjK63ERHphV0qgN9oGLDQ+nOVWo
         Dct4SD1QfDEXnCqMsazSzGQYVnGQPonCFbPCk=
Date: Sun, 16 Nov 2008 11:03:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: viro@ZenIV.linux.org.uk, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: Immortal CONFIG_DEBUG_INFO=y
Message-ID: <20081116080344.GA31296@x200.localdomain>
References: <20081116074201.GA27921@x200.localdomain> <20081116074948.GA32670@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116074948.GA32670@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 08:49:48AM +0100, Sam Ravnborg wrote:
> On Sun, Nov 16, 2008 at 10:42:01AM +0300, Alexey Dobriyan wrote:
> > As known to everybody doing fat builds, banning DEBUG_INFO=y is mandatory,
> > otherwise build is slower and takes much more disk space. And to not
> > accidently enable it, banning it in kconfig:
> > 
> > 	@@ -475,7 +475,7 @@ config DEBUG_BUGVERBOSE
> > 	 
> > 	 config DEBUG_INFO
> > 	 	bool "Compile the kernel with debug info"
> > 	-	depends on DEBUG_KERNEL
> > 	+	depends on DEBUG_KERNEL && DISABLED
> > 	 	help
> > 	           If you say Y here the resulting kernel image will include
> > 	 	  debugging info resulting in a larger kernel image.
> > 
> > This works pretty well -- allmodconfig generates config without DEBUG_INFO and
> > so on, defconfigs also regenerated without it, even if original one in arch/
> > has DEBUG_INFO enabled and so on. Trick also works for other options, like,
> > KALLSYMS_EXTRA_PASS.
> > 
> > Except one case:
> > 
> > 	make ARCH=sh magicpanelr2_defconfig
> > 
> > DEBUG_INFO survives to .config and resulting build runs with -g.
> 
> Because that defconfig does:
> CONFIG_SH_KGDB=y
> 
> and SH_KGDB does:
> 	select DEBUG_INFO

Indeed, thank you for explanation!

> Instead of editing the Kconfig file you should use the KCONFIG_ALLCONFIG trick.

It's not reliable.

The very same select will select DEBUG_INFO as usual.
