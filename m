Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbXHaXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbXHaXLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXHaXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:11:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38869 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbXHaXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:11:10 -0400
Date: Sat, 1 Sep 2007 00:19:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_via: write errors on PATA drive connected to VT6421
Message-ID: <20070901001906.16c4db60@the-village.bc.nu>
In-Reply-To: <200709010055.22200.linux@rainbow-software.org>
References: <200708202242.07290.linux@rainbow-software.org>
	<20070821132731.6bf10b50@the-village.bc.nu>
	<200709010055.22200.linux@rainbow-software.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007 00:55:21 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> Hello,
> I think that I've found and fixed the problem. There is a copy/paste bug in 
> vt6421_set_dma_mode() function which causes wrong values to be written to 
> PATA_UDMA_TIMING register.
> 
> 
> This patch fixes a copy/paste bug that breaks DMA modes on VT6421 PATA port.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.22.3-orig/drivers/ata/sata_via.c	2007-09-01 00:40:22.000000000 +0200
> +++ linux-2.6.22.3-router2/drivers/ata/sata_via.c	2007-09-01 00:10:40.000000000 +0200
> @@ -370,7 +370,7 @@
>  {
>  	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
>  	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
> -	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->pio_mode - XFER_UDMA_0]);
> +	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
>  }
>  
>  static const unsigned int svia_bar_sizes[] = {

Acked-by: Alan Cox <alan@redhat.com>

