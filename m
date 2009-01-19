Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZASORb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZASORb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZASOOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49200 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZASOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jMMb9+IwQgsFkS8FAnw6dOKXHZwyglGaoaM/17v4pxaUY6EhaLNYMhnVkS4dmB9WzW
         5lX+wYbIY9PHUSyP8D4fNJmUP8fjfETBwScQpd7KLg7sAaeyi3yDZIbkq7KYFNLmB6IR
         9D4egp4HmSySYTitq7goU5CkIFUuWM2lYRXPo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:14:43 +0100
Message-Id: <20090119141443.27613.89085.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/12] ide: remove no longer needed IDE_HFLAG[_FORCE]_LEGACY_IRQS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove no longer needed IDE_HFLAG[_FORCE]_LEGACY_IRQS

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/atiixp.c          |    3 +--
 drivers/ide/ide-pci-generic.c |    4 +---
 drivers/ide/piix.c            |   11 +----------
 drivers/ide/serverworks.c     |    9 ++-------
 drivers/ide/sis5513.c         |    2 +-
 drivers/ide/slc90e66.c        |    1 -
 drivers/ide/via82cxxx.c       |   10 ----------
 include/linux/ide.h           |    4 ----
 8 files changed, 6 insertions(+), 38 deletions(-)

Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -142,7 +142,6 @@ static const struct ide_port_info atiixp
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.port_ops	= &atiixp_port_ops,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -151,7 +150,7 @@ static const struct ide_port_info atiixp
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
 		.port_ops	= &atiixp_port_ops,
-		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
Index: b/drivers/ide/ide-pci-generic.c
===================================================================
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -33,8 +33,6 @@ static int ide_generic_all;		/* Set to c
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
 
-#define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
-
 #define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
 		.name		= DRV_NAME, \
@@ -61,7 +59,7 @@ static const struct ide_port_info generi
 	/*  2: SAMURAI / HT6565 / HINT_IDE */
 	DECLARE_GENERIC_PCI_DEV(0),
 	/*  3: UM8673F / UM8886A / UM8886BF */
-	DECLARE_GENERIC_PCI_DEV(IDE_HFLAGS_UMC),
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_DMA),
 	/*  4: VIA_IDE / OPTI621V / Piccolo010{2,3,5} */
 	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_AUTODMA),
 
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -318,19 +318,12 @@ static const struct ide_port_ops ich_por
 	.cable_detect		= piix_cable_detect,
 };
 
-#ifndef CONFIG_IA64
- #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
-#else
- #define IDE_HFLAGS_PIIX 0
-#endif
-
 #define DECLARE_PIIX_DEV(udma) \
 	{						\
 		.name		= DRV_NAME,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &piix_port_ops,	\
-		.host_flags	= IDE_HFLAGS_PIIX,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
 		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
@@ -344,7 +337,6 @@ static const struct ide_port_ops ich_por
 		.init_hwif	= init_hwif_piix, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &ich_port_ops, \
-		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
 		.mwdma_mask	= ATA_MWDMA12_ONLY, \
@@ -360,8 +352,7 @@ static const struct ide_port_info piix_p
 		 */
 		.name		= DRV_NAME,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
-		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA |
-				  IDE_HFLAGS_PIIX,
+		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA,
 		.pio_mask	= ATA_PIO4,
 		/* This is a painful system best to let it self tune for now */
 	},
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -353,14 +353,11 @@ static const struct ide_port_ops svwks_p
 	.cable_detect		= svwks_cable_detect,
 };
 
-#define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
-
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0: OSB4 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &osb4_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
@@ -369,7 +366,6 @@ static const struct ide_port_info server
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -378,7 +374,6 @@ static const struct ide_port_info server
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -387,7 +382,7 @@ static const struct ide_port_info server
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -396,7 +391,7 @@ static const struct ide_port_info server
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -563,7 +563,7 @@ static const struct ide_port_info sis551
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
+	.host_flags	= IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 };
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -136,7 +136,6 @@ static const struct ide_port_info slc90e
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
 	.mwdma_mask	= ATA_MWDMA12_ONLY,
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -443,16 +443,6 @@ static int __devinit via_init_one(struct
 	if ((via_config->flags & VIA_NO_UNMASK) == 0)
 		d.host_flags |= IDE_HFLAG_UNMASK_IRQS;
 
-#ifdef CONFIG_PPC_CHRP
-	if (machine_is(chrp) && _chrp_type == _CHRP_Pegasos)
-		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
-#endif
-
-#ifdef CONFIG_AMIGAONE
-	if (machine_is(amigaone))
-		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
-#endif
-
 	d.udma_mask = via_config->udma_mask;
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1347,10 +1347,6 @@ enum {
 	IDE_HFLAG_ERROR_STOPS_FIFO	= (1 << 19),
 	/* serialize ports */
 	IDE_HFLAG_SERIALIZE		= (1 << 20),
-	/* use legacy IRQs */
-	IDE_HFLAG_LEGACY_IRQS		= (1 << 21),
-	/* force use of legacy IRQs */
-	IDE_HFLAG_FORCE_LEGACY_IRQS	= (1 << 22),
 	/* host is TRM290 */
 	IDE_HFLAG_TRM290		= (1 << 23),
 	/* use 32-bit I/O ops */
