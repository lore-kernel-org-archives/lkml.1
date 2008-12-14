Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYLNTxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYLNTxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYLNTxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:53:23 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:60771 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYLNTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:53:22 -0500
Date: Sun, 14 Dec 2008 20:53:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] remove linux/hardirq.h from asm-generic/local.h
In-Reply-To: <20081214133941.GA18035@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0812142050280.5936@anakin>
References: <20081214133941.GA18035@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008, Russell King wrote:
> While looking at reducing the amount of architecture namespace pollution
> in the generic kernel, I found that asm/irq.h is included in the vast
> majority of compilations on ARM (around 650 files.)
> 
> Since asm/irq.h includes a sub-architecture include file on ARM, this
> causes a negative impact on the ccache's ability to re-use the build
> results from other sub-architectures, so we have a desire to reduce
> the dependencies on asm/irq.h.
> 
> It turns out that a major cause of this is the needless include of
> linux/hardirq.h into asm-generic/local.h.  The patch below removes this
> include, resulting in some 250 to 300 files (around half) of the kernel
> then omitting asm/irq.h.
> 
> My test builds still succeed, provided two ARM files are fixed
> (arch/arm/kernel/traps.c and arch/arm/mm/fault.c) - so there may be
> negative impacts for this on other architectures.

I gave it a try on m68k/atari_defconfig, but no ill effects.

> Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
> asm/local.h, so this patch can be viewed as bringing the generic version
> into line with the x86 version.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
> index 33d7d04..43c0b81 100644
> --- a/include/asm-generic/local.h
> +++ b/include/asm-generic/local.h
> @@ -2,7 +2,6 @@
>  #define _ASM_GENERIC_LOCAL_H
>  
>  #include <linux/percpu.h>
> -#include <linux/hardirq.h>
>  #include <asm/atomic.h>
>  #include <asm/types.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
