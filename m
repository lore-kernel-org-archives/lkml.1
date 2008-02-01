Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYBAIqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYBAIqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYBAIqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:46:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48354 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYBAIqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:46:44 -0500
Date: Fri, 1 Feb 2008 09:46:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU 06/06]: modify Makefiles to support common coldfire directory
Message-ID: <20080201084645.GA10969@uranus.ravnborg.org>
References: <200802010737.m117bueB022713@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802010737.m117bueB022713@goober>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

On Fri, Feb 01, 2008 at 05:37:56PM +1000, Greg Ungerer wrote:
> Modify Makefiles to support separate coldfire platform directory.
> 
> Currently the common ColdFire CPU family code sits in the
> arch/m68knommu/platform/5307 directory. This is confusing, the files
> containing this common code are in no way specific to the 5307 ColdFire.
> Create an arch/m68knommu/platform/coldfire directory to contain this
> common code. Other m68knommu CPU varients do not need use this code
> though, so it doesn't make sense to move it to arch/m68knommu/kernel.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org
> 
> 
> diff -Naurp linux-2.6.24/arch/m68knommu/Makefile linux-2.6.24.1/arch/m68knommu/Makefile
> --- linux-2.6.24/arch/m68knommu/Makefile	2008-01-25 08:58:37.000000000 +1000
> +++ linux-2.6.24.1/arch/m68knommu/Makefile	2008-01-31 17:04:07.000000000 +1000
> @@ -61,17 +61,17 @@ MODEL := $(model-y)
>  # for the selected cpu. ONLY need to define this for the non-base member
>  # of the family.
>  #
> -cpuclass-$(CONFIG_M5206)	:= 5307
> -cpuclass-$(CONFIG_M5206e)	:= 5307
> -cpuclass-$(CONFIG_M520x)	:= 5307
> -cpuclass-$(CONFIG_M523x)	:= 5307
> -cpuclass-$(CONFIG_M5249)	:= 5307
> -cpuclass-$(CONFIG_M527x)	:= 5307
> -cpuclass-$(CONFIG_M5272)	:= 5307
> -cpuclass-$(CONFIG_M528x)	:= 5307
> -cpuclass-$(CONFIG_M5307)	:= 5307
> -cpuclass-$(CONFIG_M532x)	:= 5307
> -cpuclass-$(CONFIG_M5407)	:= 5307
> +cpuclass-$(CONFIG_M5206)	:= coldfire
> +cpuclass-$(CONFIG_M5206e)	:= coldfire
> +cpuclass-$(CONFIG_M520x)	:= coldfire
> +cpuclass-$(CONFIG_M523x)	:= coldfire
> +cpuclass-$(CONFIG_M5249)	:= coldfire
> +cpuclass-$(CONFIG_M527x)	:= coldfire
> +cpuclass-$(CONFIG_M5272)	:= coldfire
> +cpuclass-$(CONFIG_M528x)	:= coldfire
> +cpuclass-$(CONFIG_M5307)	:= coldfire
> +cpuclass-$(CONFIG_M532x)	:= coldfire
> +cpuclass-$(CONFIG_M5407)	:= coldfire

I would suggest to alwyas descend into coldfire/ and
in the coldfire/Makefile decide what to build.
For some models thats nothing but thats OK.

>  cpuclass-$(CONFIG_M68328)	:= 68328
>  cpuclass-$(CONFIG_M68EZ328)	:= 68328
>  cpuclass-$(CONFIG_M68VZ328)	:= 68328
> diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/Makefile linux-2.6.24.1/arch/m68knommu/platform/5307/Makefile
> --- linux-2.6.24/arch/m68knommu/platform/5307/Makefile	2008-01-25 08:58:37.000000000 +1000
> +++ linux-2.6.24.1/arch/m68knommu/platform/5307/Makefile	2008-01-31 16:35:54.000000000 +1000
> @@ -16,17 +16,5 @@ ifdef CONFIG_FULLDEBUG
>  EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
>  endif

Please use:
asflags-y := -DDEBUGGER_COMPATIBLE_CACHE=1

I know you did not change that line - but wanted to comment it anyway.

> diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/Makefile linux-2.6.24.1/arch/m68knommu/platform/coldfire/Makefile
> --- linux-2.6.24/arch/m68knommu/platform/coldfire/Makefile	1970-01-01 10:00:00.000000000 +1000
> +++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/Makefile	2008-01-31 16:35:13.000000000 +1000
> @@ -0,0 +1,32 @@
> +#
> +# Makefile for the m68knommu kernel.
> +#
> +
> +#
> +# If you want to play with the HW breakpoints then you will
> +# need to add define this,  which will give you a stack backtrace
> +# on the console port whenever a DBG interrupt occurs. You have to
> +# set up you HW breakpoints to trigger a DBG interrupt:
> +#
> +# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> +# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +#
> +
> +ifdef CONFIG_FULLDEBUG
> +AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
> +endif

Please use:
asflags-$(CONFIG_FULL_DEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1

> +
> +obj-$(CONFIG_COLDFIRE)	+= dma.o entry.o vectors.o
> +obj-$(CONFIG_M5206)	+= timers.o
> +obj-$(CONFIG_M5206e)	+= timers.o
> +obj-$(CONFIG_M520x)	+= pit.o
> +obj-$(CONFIG_M523x)	+= pit.o
> +obj-$(CONFIG_M5249)	+= timers.o
> +obj-$(CONFIG_M527x)	+= pit.o
> +obj-$(CONFIG_M5272)	+= timers.o
> +obj-$(CONFIG_M528x)	+= pit.o
> +obj-$(CONFIG_M5307)	+= timers.o
> +obj-$(CONFIG_M532x)	+= timers.o
> +obj-$(CONFIG_M5407)	+= timers.o
> +
> +extra-y := head.o

	Sam
