Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZBBHta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZBBHta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZBBHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:49:19 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:55617 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZBBHtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:49:18 -0500
Date: Mon, 2 Feb 2009 08:49:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
In-Reply-To: <20090201174916.19144.11318.sendpatchset@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0902020847410.11930@anakin>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
 <20090201174916.19144.11318.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: include <asm/ide.h> only when needed
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-io-std.c |    7 +++++++
>  drivers/ide/tx4938ide.c  |    2 ++
>  drivers/ide/tx4939ide.c  |    2 ++
>  include/linux/ide.h      |    7 -------
>  4 files changed, 11 insertions(+), 7 deletions(-)
> 
> Index: b/drivers/ide/ide-io-std.c
> ===================================================================
> --- a/drivers/ide/ide-io-std.c
> +++ b/drivers/ide/ide-io-std.c
> @@ -2,6 +2,13 @@
>  #include <linux/kernel.h>
>  #include <linux/ide.h>
>  
> +#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
> +    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
> +#include <asm/ide.h>
> +#else
> +#include <asm-generic/ide_iops.h>
> +#endif
> +
>  /*
>   *	Conventional PIO operations for ATA devices
>   */
> Index: b/drivers/ide/tx4938ide.c
> ===================================================================
> --- a/drivers/ide/tx4938ide.c
> +++ b/drivers/ide/tx4938ide.c
> @@ -15,6 +15,8 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +
> +#include <asm/ide.h>

Did you try checkpatch.pl?

    [...]

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -193,13 +193,6 @@ static inline void ide_std_init_ports(hw
>  	hw->io_ports.ctl_addr = ctl_addr;
>  }
>  
> -#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
> -    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
> -#include <asm/ide.h>
> -#else
> -#include <asm-generic/ide_iops.h>
> -#endif
> -
>  #define MAX_HWIFS	10
>  
>  /*

As checkpatch.pl complains about any include of asm/*.h where the corresponding
linux/*.h exists, this `fix' is incompatible with it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
