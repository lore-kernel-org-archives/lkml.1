Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZEKSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZEKSfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZEKSfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:35:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36805 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbZEKSfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:35:04 -0400
Message-ID: <4A086FCF.5090907@garzik.org>
Date: Mon, 11 May 2009 14:34:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: =?ISO-8859-15?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB9758.3020506@garzik.org> <20090420173526.GA7935@ime.usp.br> <200904202231.25670.bzolnier@gmail.com>
In-Reply-To: <200904202231.25670.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_pdc202xx_old: fix UDMA33 handling
> 
> The original driver doesn't use 66 MHz clock for UDMA33.
> 
> [ The alternative solution would be to adjust UDMA33 timings
>   for 66 MHz clock but I think that it is safer to stick with
>   old & tested behavior for now. ]
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_pdc202xx_old.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: b/drivers/ata/pata_pdc202xx_old.c
> ===================================================================
> --- a/drivers/ata/pata_pdc202xx_old.c
> +++ b/drivers/ata/pata_pdc202xx_old.c
> @@ -2,7 +2,7 @@
>   * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
>   *			  (C) 2005 Red Hat Inc
>   *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
> - *			  (C) 2007 Bartlomiej Zolnierkiewicz
> + *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
>   *
>   * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
>   *
> @@ -158,7 +158,7 @@ static void pdc2026x_bmdma_start(struct 
>  	u32 len;
>  
>  	/* Check we keep host level locking here */
> -	if (adev->dma_mode >= XFER_UDMA_2)
> +	if (adev->dma_mode > XFER_UDMA_2)
>  		iowrite8(ioread8(clock) | sel66, clock);
>  	else
>  		iowrite8(ioread8(clock) & ~sel66, clock);
> @@ -212,7 +212,7 @@ static void pdc2026x_bmdma_stop(struct a
>  		iowrite8(ioread8(clock) & ~sel66, clock);
>  	}
>  	/* Flip back to 33Mhz for PIO */
> -	if (adev->dma_mode >= XFER_UDMA_2)
> +	if (adev->dma_mode > XFER_UDMA_2)
>  		iowrite8(ioread8(clock) & ~sel66, clock);


applied

