Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYABVx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYABVx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759266AbYABVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:53:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54992 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYABVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:53:11 -0500
Date: Wed, 2 Jan 2008 22:53:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm] compat_binfmt_elf Kconfig
Message-ID: <20080102215311.GA12558@uranus.ravnborg.org>
References: <20071223183920.GA13976@elte.hu> <20071223211603.3FFB126F8E7@magilla.localdomain> <20071230163614.GB1384@elte.hu> <20080102044157.A5CC526F99F@magilla.localdomain> <20080102111431.GD14731@elte.hu> <20080102191030.GA11217@uranus.ravnborg.org> <20080102210831.9F80426F9A0@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102210831.9F80426F9A0@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:08:31PM -0800, Roland McGrath wrote:
> This patch should go in immediately after:
> 
> 	commit 5e45efc63e33ee2bae9ff4d500b53d3bf86d2b48
> 	Author: Roland McGrath <roland@redhat.com>
> 
> 	    compat_binfmt_elf
> 
> Thanks,
> Roland
> 
> ---
> [PATCH] compat_binfmt_elf Kconfig
> 
> This adds Kconfig and Makefile bits to build fs/compat_binfmt_elf.c,
> just added.  Each arch that wants to use this file needs to add a
> "select COMPAT_BINFMT_ELF" line in its Kconfig bits that enable COMPAT.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  fs/Kconfig.binfmt |    4 ++++
>  fs/Makefile       |    1 +
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index d4fc609..0000000 100644  
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -23,6 +23,10 @@ config BINFMT_ELF
>  	  ld.so (check the file <file:Documentation/Changes> for location and
>  	  latest version).
>  
> +config COMPAT_BINFMT_ELF
> +	bool
> +	depends on COMPAT && MMU
> +
>  config BINFMT_ELF_FDPIC
>  	bool "Kernel support for FDPIC ELF binaries"
>  	default y
> diff --git a/fs/Makefile b/fs/Makefile
> index 500cf15..0000000 100644  
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc
>  obj-y				+= binfmt_script.o
>  
>  obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
> +obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
>  obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
>  obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
>  obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o

You totally missed the point of having selectable features noted
by a config symbol named "HAVE_*".
When you see such a "HAVE_*" you know it is supposed to be selected
and thus you need to be much more careful about the dependencies.

And my patch was purely a cooked up example btw and not at all tested.
Should have been clear about that.

	Sam

