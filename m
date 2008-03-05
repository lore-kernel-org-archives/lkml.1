Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbYCEWxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbYCEWxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbYCEWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:52:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:56383 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbYCEWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AzzYFCfSEUoQoveDQy68MVcFiT3ZTKhQX+cDqaDCXbBlZqe2tgsYhdSU1j3ubt0EkOL3mS1lEZqvTdJVI99bGh8bbvqNGP+mU4VjNIiCAgDdhF8X/sZp2JTqkO2seBDeSKUWIKLlHhraw/SMPLKJuF+WOj+M3h+mBQv1If+IM4A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: remove ->extra field from struct ide_port_info
Date: Thu, 6 Mar 2008 00:00:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060000.50990.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always setup hwif->extra_base in ide_iomio_dma() and remove
no longer needed ->extra field from struct ide_port_info.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |    3 +--
 drivers/ide/pci/hpt34x.c       |    2 --
 drivers/ide/pci/hpt366.c       |    6 ------
 drivers/ide/pci/pdc202xx_old.c |    2 --
 include/linux/ide.h            |    1 -
 5 files changed, 1 insertion(+), 13 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -850,8 +850,7 @@ static int ide_iomio_dma(ide_hwif_t *hwi
 	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
 	       hwif->name, base, base + 7);
 
-	if (hwif->cds->extra)
-		hwif->extra_base = base + (hwif->channel ? 8 : 16);
+	hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
 	return 0;
 }
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -130,7 +130,6 @@ static const struct ide_port_info hpt34x
 	{ /* 0 */
 		.name		= "HPT343",
 		.init_chipset	= init_chipset_hpt34x,
-		.extra		= 16,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
@@ -138,7 +137,6 @@ static const struct ide_port_info hpt34x
 	{ /* 1 */
 		.name		= "HPT345",
 		.init_chipset	= init_chipset_hpt34x,
-		.extra		= 16,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO5,
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1428,7 +1428,6 @@ static const struct ide_port_info hpt366
 		 * Bit 4 is for the primary channel, bit 5 for the secondary.
 		 */
 		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
@@ -1439,7 +1438,6 @@ static const struct ide_port_info hpt366
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
@@ -1450,7 +1448,6 @@ static const struct ide_port_info hpt366
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
@@ -1461,7 +1458,6 @@ static const struct ide_port_info hpt366
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
@@ -1473,7 +1469,6 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
@@ -1484,7 +1479,6 @@ static const struct ide_port_info hpt366
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.extra		= 240,
 		.port_ops	= &hpt3xx_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -358,7 +358,6 @@ static const struct ide_port_ops pdc2026
 		.init_chipset	= init_chipset_pdc202xx, \
 		.init_hwif	= init_hwif_pdc202xx, \
 		.init_dma	= init_dma_pdc202xx, \
-		.extra		= 48, \
 		.port_ops	= &pdc2026x_port_ops, \
 		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
@@ -373,7 +372,6 @@ static const struct ide_port_info pdc202
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
-		.extra		= 16,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1113,7 +1113,6 @@ struct ide_port_info {
 
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
-	u8			extra;
 	u32			host_flags;
 	u8			pio_mask;
 	u8			swdma_mask;
