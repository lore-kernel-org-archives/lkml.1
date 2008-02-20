Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbYBTJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbYBTJlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYBTJlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:41:06 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47970 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756351AbYBTJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:41:04 -0500
Date: Wed, 20 Feb 2008 10:40:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH] falconide: fix resources reservation
In-Reply-To: <200802200150.26989.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0802201039520.19893@vixen.sonytel.be>
References: <200802200150.26989.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> * Tell IDE layer to not manage resources by setting
>   hwif->mmio flag and request resources in falconide_init().
> 
> * Use request_mem_region() for resources reservation.
> 
> * Use driver name for resources reservation.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Michael Schmitz <schmitz@debian.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/legacy/falconide.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: b/drivers/ide/legacy/falconide.c
> ===================================================================
> --- a/drivers/ide/legacy/falconide.c
> +++ b/drivers/ide/legacy/falconide.c
> @@ -22,6 +22,7 @@
>  #include <asm/atariints.h>
>  #include <asm/atari_stdma.h>
>  
> +#define DRV_NAME "falconide"
>  
>      /*
>       *  Base of the IDE interface
> @@ -74,6 +75,11 @@ static int __init falconide_init(void)
>  
>  	printk(KERN_INFO "ide: Falcon IDE controller\n");
>  
> +	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
> +		printk(KERN_ERR "%s: resources busy\n");
                                 ^^
Woops, missing parameter?

pr_error()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
