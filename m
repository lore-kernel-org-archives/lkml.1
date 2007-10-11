Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbXJKHZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbXJKHZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXJKHZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:25:22 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:42844 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXJKHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:25:21 -0400
Date: Thu, 11 Oct 2007 09:25:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <200710101722.21126.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0710110923470.23818@anakin>
References: <200710101722.21126.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Rip out hardwired cross compiler name assumption that only m68k makes.
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> When you cross compile, you have to set the prefix CROSS_COMPILE to your
> cross compiler prefix.  You need to do this for all targets (arm, mips, ppc,
> x86-64 on x86, etc).  This is not specific to m68k, and this value is
> supplied _to_ the build, not supplied _by_ the build.
> 
> The build shouldn't unconditionally overwrite the existing value of this
> variable with one it makes up.  It has no idea what I called my cross compiler.

The build does not unconditionally overwrite the existing value of this
variable. You can specify the name of your cross compiler like this:

    make CROSS_COMPILE=m68k-linux-

BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.

>  arch/m68k/Makefile |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff -r 79f0ea1e0e70 arch/m68k/Makefile
> --- a/arch/m68k/Makefile	Tue Oct 09 21:00:40 2007 +0000
> +++ b/arch/m68k/Makefile	Wed Oct 10 17:02:17 2007 -0500
> @@ -13,17 +13,10 @@
>  # Copyright (C) 1994 by Hamish Macdonald
>  #
>  
> -# test for cross compiling
> -COMPILE_ARCH = $(shell uname -m)
> -
>  # override top level makefile
>  AS += -m68020
>  LDFLAGS := -m m68kelf
>  LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
> -ifneq ($(COMPILE_ARCH),$(ARCH))
> -	# prefix for cross-compiling binaries
> -	CROSS_COMPILE = m68k-linux-gnu-
> -endif
>  
>  ifdef CONFIG_SUN3
>  LDFLAGS_vmlinux = -N

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
