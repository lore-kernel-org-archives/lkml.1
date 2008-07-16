Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbYGPPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbYGPPWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbYGPPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:19:26 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:39562 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689AbYGPPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:19:24 -0400
Date: Wed, 16 Jul 2008 17:19:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>,
       Michael Schmitz <schmitz@zirkon.biophys.uni-duesseldorf.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-stable@linux-mips.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/MIPS Development <linux-mips@linux-mips.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: MIPS toolchain
In-Reply-To: <20080716120224.GA6061@linux-mips.org>
Message-ID: <Pine.LNX.4.64.0807161716290.7399@anakin>
References: <487DA40C.6010405@movial.fi> <20080716104533.GA7198@linux-mips.org>
 <487DD559.3020802@movial.fi> <20080716120224.GA6061@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Ralf Baechle wrote:
> Crosscompiling on a Fedora 9 machine running gcc 4.3.0 as its host compiler
> and gcc 3.4.6 for the mips-linux target results in the following build
> error:
> 
> $ make malta_defconfig
> $ make
> cc1: error: unrecognized command line option "-fno-stack-protector"
> scripts/kconfig/conf -s arch/mips/Kconfig
> cc1: error: unrecognized command line option "-fno-stack-protector"
> 
> The arch Makefile is included too late so the host compiler is feature
> tested, not the crosscompiler as intended and thus the Makefile applies
> adds -fno-stack-protector to crosscompiler's flags which fails for gcc
> 3.4.6.  The bug was introduced by e06b8b98da071f7dd78fb7822991694288047df0
> in 2.6.25; 35bb5b1e0e84cfa1a8906f7e6a77f391ff315791 did add more flags
> testing before the arch Makefile inclusion.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> diff --git a/Makefile b/Makefile
> index bfde079..312fcaa 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -509,6 +509,8 @@ else
>  KBUILD_CFLAGS	+= -O2
>  endif
>  
> +include $(srctree)/arch/$(SRCARCH)/Makefile
> +
>  ifneq (CONFIG_FRAME_WARN,0)
>  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
> @@ -517,8 +519,6 @@ endif
>  # Arch Makefiles may override this setting
>  KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
>  
> -include $(srctree)/arch/$(SRCARCH)/Makefile
> -
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else

Thank you!

Michael Schmitz also saw this problem, but we never found what caused
it...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
