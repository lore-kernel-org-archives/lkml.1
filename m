Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXEIUqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXEIUqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbXEIUqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:46:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58791 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbXEIUqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:46:30 -0400
Date: Wed, 9 May 2007 22:47:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [patch 5/9] lguest: the Makefile and Kconfig
Message-ID: <20070509204725.GB10336@uranus.ravnborg.org>
References: <200705090951.l499pb6H020400@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705090951.l499pb6H020400@shell0.pdx.osdl.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 02:51:37AM -0700, akpm@linux-foundation.org wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This is the Kconfig and Makefile to allow lguest to actually be
> compiled.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/Kconfig         |    2 ++
>  drivers/Makefile        |    1 +
>  drivers/lguest/Kconfig  |   20 ++++++++++++++++++++
>  drivers/lguest/Makefile |    7 +++++++
>  4 files changed, 30 insertions(+)
> 
> diff -puN drivers/Kconfig~lguest-the-makefile-and-kconfig drivers/Kconfig
> --- a/drivers/Kconfig~lguest-the-makefile-and-kconfig
> +++ a/drivers/Kconfig
> @@ -89,4 +89,6 @@ source "drivers/auxdisplay/Kconfig"
>  source "drivers/kvm/Kconfig"
>  
>  source "drivers/uio/Kconfig"
> +
> +source "drivers/lguest/Kconfig"
>  endmenu
> diff -puN drivers/Makefile~lguest-the-makefile-and-kconfig drivers/Makefile
> --- a/drivers/Makefile~lguest-the-makefile-and-kconfig
> +++ a/drivers/Makefile
> @@ -72,6 +72,7 @@ obj-$(CONFIG_ISDN)		+= isdn/
>  obj-$(CONFIG_EDAC)		+= edac/
>  obj-$(CONFIG_MCA)		+= mca/
>  obj-$(CONFIG_EISA)		+= eisa/
> +obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
>  obj-$(CONFIG_MMC)		+= mmc/
>  obj-$(CONFIG_NEW_LEDS)		+= leds/
> diff -puN /dev/null drivers/lguest/Kconfig
> --- /dev/null
> +++ a/drivers/lguest/Kconfig
> @@ -0,0 +1,20 @@
> +config LGUEST
> +	tristate "Linux hypervisor example code"
> +	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
> +	select LGUEST_GUEST
> +	select HVC_DRIVER
> +	---help---
> +	  This is a very simple module which allows you to run
> +	  multiple instances of the same Linux kernel, using the
> +	  "lguest" command found in the Documentation/lguest directory.
> +	  Note that "lguest" is pronounced to rhyme with "fell quest",
> +	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
> +
> +	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
> +
> +config LGUEST_GUEST
> +	bool
> +	help
> +	  The guest needs code built-in, even if the host has lguest
> +	  support as a module.  The drivers are tiny, so we build them
> +	  in too.
> diff -puN /dev/null drivers/lguest/Makefile
> --- /dev/null
> +++ a/drivers/lguest/Makefile
> @@ -0,0 +1,7 @@
> +# Guest requires the paravirt_ops replacement and the bus driver.
> +obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
> +
> +# Host requires the other files, which can be a module.
> +obj-$(CONFIG_LGUEST)	+= lg.o
> +lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
> +	segments.o io.o lguest_user.o switcher.o
Please use: lg-y :=
Using -objs is no longer preferred.

	Sam

