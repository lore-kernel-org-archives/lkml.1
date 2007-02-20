Return-Path: <linux-kernel-owner+w=401wt.eu-S1030299AbXBTRLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbXBTRLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030312AbXBTRLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:11:47 -0500
Received: from [81.2.110.250] ([81.2.110.250]:37842 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030299AbXBTRLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:11:46 -0500
Date: Tue, 20 Feb 2007 18:15:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libata: Use new id_to_dma_mode function to tidy reporting
 in more drivers (minimally tested)
Message-ID: <20070220181503.18f55e17@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_it821x.c linux-2.6.20-mm2/drivers/ata/pata_it821x.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_it821x.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_it821x.c	2007-02-20 14:22:10.000000000 +0000
@@ -503,10 +503,12 @@
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
 			if (dma_enabled & (1 << (5 + i))) {
+				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
 				dev->flags &= ~ATA_DFLAG_PIO;
 			} else {
+				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 				dev->xfer_mode = XFER_PIO_0;
 				dev->xfer_shift = ATA_SHIFT_PIO;
 				dev->flags |= ATA_DFLAG_PIO;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/ata_generic.c linux-2.6.20-mm2/drivers/ata/ata_generic.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/ata_generic.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/ata_generic.c	2007-02-20 13:42:50.000000000 +0000
@@ -90,10 +90,10 @@
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
 			if (dma_enabled & (1 << (5 + i))) {
-				dev->xfer_mode = XFER_MW_DMA_0;
-				dev->xfer_shift = ATA_SHIFT_MWDMA;
+				ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
 				dev->flags &= ~ATA_DFLAG_PIO;
 			} else {
+				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 				dev->xfer_mode = XFER_PIO_0;
 				dev->xfer_shift = ATA_SHIFT_PIO;
 				dev->flags |= ATA_DFLAG_PIO;
