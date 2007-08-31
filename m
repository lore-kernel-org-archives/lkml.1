Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXHaWy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXHaWy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXHaWyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:54:45 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:32837 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXHaWyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:54:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata_via: write errors on PATA drive connected to VT6421
Date: Sat, 1 Sep 2007 00:55:21 +0200
User-Agent: KMail/1.9.7
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708202242.07290.linux@rainbow-software.org> <20070821132731.6bf10b50@the-village.bc.nu>
In-Reply-To: <20070821132731.6bf10b50@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1248
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709010055.22200.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I think that I've found and fixed the problem. There is a copy/paste bug in 
vt6421_set_dma_mode() function which causes wrong values to be written to 
PATA_UDMA_TIMING register.


This patch fixes a copy/paste bug that breaks DMA modes on VT6421 PATA port.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.22.3-orig/drivers/ata/sata_via.c	2007-09-01 00:40:22.000000000 +0200
+++ linux-2.6.22.3-router2/drivers/ata/sata_via.c	2007-09-01 00:10:40.000000000 +0200
@@ -370,7 +370,7 @@
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
-	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->pio_mode - XFER_UDMA_0]);
+	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
 }
 
 static const unsigned int svia_bar_sizes[] = {


-- 
Ondrej Zary
