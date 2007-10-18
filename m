Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXJRWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXJRWw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXJRWuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:50:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5966 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763523AbXJRWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=KBpUD2wb9vpX7gPHx7SzlQsVIxIj9nZ3q8NgANFFfN9yKwP2Ss3whB3ucF8i6diuCA7oJLsljEZ+0PYiT1U0OI2jyvMQ1051feCnxcN+pXZLYvhLoKdu2QHak2AM5A0nyMaha6cnY6F5vLi0Y8tOvWspFRIO9VWvfDcx3Gq1YRY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates (part 4)
Date: Fri, 19 Oct 2007 00:53:55 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710190053.55450.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

* fix cs5535 and siimage 2.6.23 regression resulting in out-of-bound
  array access if there are drives on the secondary interface
  (Benjamin Herrenschmidt <benh@kernel.crashing.org>)

* more host drivers are switched to always tune PIO: alim15x3, cs5520,
  cy82c693, opti621 and triflex

* a lot of small cleanups/improvements (which accumulated result in
  ~450 LOC less in the IDE land)

PS There is still one more update to go.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/arm/icside.c       |    1 -
 drivers/ide/cris/ide-cris.c    |    1 +
 drivers/ide/ide-disk.c         |    8 +-
 drivers/ide/ide-dma.c          |   12 +-
 drivers/ide/ide-io.c           |    3 +-
 drivers/ide/ide-probe.c        |    3 +-
 drivers/ide/ide.c              |    4 -
 drivers/ide/mips/au1xxx-ide.c  |    3 -
 drivers/ide/pci/aec62xx.c      |   97 ++++------
 drivers/ide/pci/alim15x3.c     |   30 ++--
 drivers/ide/pci/amd74xx.c      |   31 ++--
 drivers/ide/pci/atiixp.c       |   21 +--
 drivers/ide/pci/cmd64x.c       |   85 +++------
 drivers/ide/pci/cs5520.c       |   31 +---
 drivers/ide/pci/cs5530.c       |   18 +--
 drivers/ide/pci/cs5535.c       |   15 +-
 drivers/ide/pci/cy82c693.c     |   18 +--
 drivers/ide/pci/generic.c      |  148 +++++-----------
 drivers/ide/pci/hpt34x.c       |   56 +++----
 drivers/ide/pci/hpt366.c       |  376 +++++++++++++++++-----------------------
 drivers/ide/pci/it8213.c       |   16 +--
 drivers/ide/pci/it821x.c       |   22 +--
 drivers/ide/pci/jmicron.c      |   12 +-
 drivers/ide/pci/ns87415.c      |    6 +-
 drivers/ide/pci/opti621.c      |   26 +--
 drivers/ide/pci/pdc202xx_new.c |  201 +++++++--------------
 drivers/ide/pci/pdc202xx_old.c |  135 +++++---------
 drivers/ide/pci/piix.c         |  167 ++++++++-----------
 drivers/ide/pci/rz1000.c       |    3 +-
 drivers/ide/pci/sc1200.c       |   19 +--
 drivers/ide/pci/scc_pata.c     |   26 +--
 drivers/ide/pci/serverworks.c  |   86 ++++------
 drivers/ide/pci/sgiioc4.c      |   11 +-
 drivers/ide/pci/siimage.c      |   35 ++---
 drivers/ide/pci/sis5513.c      |   14 +--
 drivers/ide/pci/sl82c105.c     |   12 +-
 drivers/ide/pci/slc90e66.c     |   17 +--
 drivers/ide/pci/tc86c001.c     |   26 +--
 drivers/ide/pci/triflex.c      |   12 +-
 drivers/ide/pci/trm290.c       |    9 +-
 drivers/ide/pci/via82cxxx.c    |   28 ++--
 drivers/ide/ppc/pmac.c         |    1 -
 drivers/ide/setup-pci.c        |   68 +++++---
 include/linux/ide.h            |   58 ++++---
 44 files changed, 760 insertions(+), 1211 deletions(-)


Auke Kok (2):
      amd74xx: Omit PCI_REVISION_ID read
      cmd64x: Use dev->revision

Bartlomiej Zolnierkiewicz (32):
      siimage: bump driver version
      ide: add DECLARE_GENERIC_PCI_DEV() macro to generic IDE PCI host driver
      ide: add IDE_HFLAG_NO_ATAPI_DMA host flag
      ide: add IDE_HFLAG_BOOTABLE host flag
      ide: add IDE_HFLAG_NO_{DMA,AUTODMA} host flags
      ide: remove ->init_setup_dma from ide_pci_device_t (take 2)
      ide: add IDE_HFLAG_NO_LBA48 and IDE_HFLAG_NO_LBA48_DMA host flags
      pdc202xx_old: remove broken SWDMA support
      ide: add ->mwdma_mask and ->swdma_mask to ide_pci_device_t (take 2)
      ide: use pci_dev->revision
      ide: use I/O ops directly part #2 (take 2)
      aec62xx: remove ->init_setup
      cmd64x: remove ->init_setup
      hpt366: remove ->init_setup
      pdc202xx_new: remove ->init_setup
      pdc202xx_old: remove ->init_setup
      scc_pata: remove ->init_setup
      serverworks: remove ->init_setup
      ide: remove .init_setup from ide_pci_device_t
      aec62xx: no need to disable UDMA in ->init_hwif method for ATP850UF
      pdc202xx_new: add DECLARE_PDCNEW_DEV() macro
      pdc202xx_old: add DECLARE_PDC2026X_DEV() macro
      piix: add DECLARE_ICH_DEV() macro
      ide: add IDE_HFLAG_ERROR_STOPS_FIFO host flag
      ide: add IDE_HFLAG_SERIALIZE host flag
      ide: add IDE_HFLAG_LEGACY_IRQS host flag
      alim15x3: always tune PIO
      cs5520: always tune PIO
      cy82c693: always tune PIO
      opti621: always tune PIO
      triflex: always tune PIO
      ide: set drive->autotune in ide_pci_setup_ports()

Benjamin Herrenschmidt (3):
      ide: Add ide_get_paired_drive() helper
      ide: Fix siimage driver accessing beyond array boundary
      ide: Fix cs5535 driver accessing beyond array boundary


diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index e4875ce..3af33fb 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -415,7 +415,6 @@ static void icside_dma_lost_irq(ide_drive_t *drive)
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	hwif->atapi_dma		= 1;
 	hwif->mwdma_mask	= 7; /* MW0..2 */
 	hwif->swdma_mask	= 7; /* SW0..2 */
 
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 06c75f1..9a96a10 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -805,6 +805,7 @@ init_e100_ide (void)
 		hwif->dma_host_on = &cris_dma_on;
 		hwif->dma_off_quietly = &cris_dma_off;
 		hwif->cbl = ATA_CBL_PATA40;
+		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		hwif->pio_mask = ATA_PIO4,
 		hwif->drives[0].autotune = 1;
 		hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 92177ca..2722d91 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -169,7 +169,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 
 	nsectors.all		= (u16) rq->nr_sectors;
 
-	if (hwif->no_lba48_dma && lba48 && dma) {
+	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
 		if (block + rq->nr_sectors > 1ULL << 28)
 			dma = 0;
 		else
@@ -856,7 +856,7 @@ static int set_lba_addressing(ide_drive_t *drive, int arg)
 
 	drive->addressing =  0;
 
-	if (HWIF(drive)->no_lba48)
+	if (drive->hwif->host_flags & IDE_HFLAG_NO_LBA48)
 		return 0;
 
 	if (!idedisk_supports_lba48(drive->id))
@@ -889,6 +889,7 @@ static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
 
 static void idedisk_setup (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 	unsigned long long capacity;
 
@@ -909,7 +910,6 @@ static void idedisk_setup (ide_drive_t *drive)
 	(void)set_lba_addressing(drive, 1);
 
 	if (drive->addressing == 1) {
-		ide_hwif_t *hwif = HWIF(drive);
 		int max_s = 2048;
 
 		if (max_s > hwif->rqsize)
@@ -932,7 +932,7 @@ static void idedisk_setup (ide_drive_t *drive)
 		drive->capacity64 = 1ULL << 28;
 	}
 
-	if (drive->hwif->no_lba48_dma && drive->addressing) {
+	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && drive->addressing) {
 		if (drive->capacity64 > 1ULL << 28) {
 			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode will"
 					 " be used for accessing sectors > %u\n",
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index bc57ce6..80b4f17 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -338,8 +338,10 @@ static int config_drive_for_dma (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 
-	if (drive->media != ide_disk && hwif->atapi_dma == 0)
-		return 0;
+	if (drive->media != ide_disk) {
+		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
+			return -1;
+	}
 
 	/*
 	 * Enable DMA on any drive that has
@@ -726,8 +728,10 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 	int x, i;
 	u8 mode = 0;
 
-	if (drive->media != ide_disk && hwif->atapi_dma == 0)
-		return 0;
+	if (drive->media != ide_disk) {
+		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
+			return 0;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(xfer_mode_bases); i++) {
 		if (req_mode < xfer_mode_bases[i])
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index ec835e3..5c8b008 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -484,7 +484,8 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		}
 	}
 
-	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ && hwif->err_stops_fifo == 0)
+	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
+	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
 		try_to_flush_leftover_data(drive);
 
 	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3c945d6..e294c74 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -951,7 +951,8 @@ static int ide_init_queue(ide_drive_t *drive)
 	blk_queue_segment_boundary(q, 0xffff);
 
 	if (!hwif->rqsize) {
-		if (hwif->no_lba48 || hwif->no_lba48_dma)
+		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
+		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
 			hwif->rqsize = 256;
 		else
 			hwif->rqsize = 65536;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 5b09066..961e6c8 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -134,8 +134,6 @@ static void init_hwif_data(ide_hwif_t *hwif, unsigned int index)
 
 	hwif->bus_state	= BUSSTATE_ON;
 
-	hwif->atapi_dma = 0;		/* disable all atapi dma */ 
-
 	init_completion(&hwif->gendev_rel_comp);
 
 	default_hwif_iops(hwif);
@@ -379,7 +377,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 
 	hwif->pio_mask			= tmp_hwif->pio_mask;
 
-	hwif->atapi_dma			= tmp_hwif->atapi_dma;
 	hwif->ultra_mask		= tmp_hwif->ultra_mask;
 	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
 	hwif->swdma_mask		= tmp_hwif->swdma_mask;
@@ -440,7 +437,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 
 	hwif->mmio			= tmp_hwif->mmio;
 	hwif->rqsize			= tmp_hwif->rqsize;
-	hwif->no_lba48			= tmp_hwif->no_lba48;
 
 #ifndef CONFIG_BLK_DEV_IDECS
 	hwif->irq			= tmp_hwif->irq;
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 47c035a..2f322d7 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -699,9 +699,6 @@ static int au_ide_probe(struct device *dev)
 	hwif->dma_host_on		= &auide_dma_host_on;
 	hwif->dma_lost_irq		= &auide_dma_lost_irq;
 	hwif->ide_dma_on                = &auide_dma_on;
-
-	hwif->atapi_dma                 = 1;
-
 #else /* !CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA */
 	hwif->channel                   = 0;
 	hwif->hold                      = 1;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 3a4c2c2..b3dc12a 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.25	Aug 1, 2007
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.26	Sep 1, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
@@ -184,34 +184,23 @@ static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const ch
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 reg54 = 0,  mask	= hwif->channel ? 0xf0 : 0x0f;
-	unsigned long flags;
 
 	hwif->set_pio_mode = &aec_set_pio_mode;
 
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
-		if(hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
+	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		hwif->set_dma_mode = &aec6210_set_mode;
-	} else
+	else
 		hwif->set_dma_mode = &aec6260_set_mode;
 
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ultra_mask = hwif->cds->udma_mask;
-	hwif->mwdma_mask = 0x07;
-
 	hwif->dma_lost_irq	= &aec62xx_dma_lost_irq;
 
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
-		spin_lock_irqsave(&ide_lock, flags);
-		pci_read_config_byte (dev, 0x54, &reg54);
-		pci_write_config_byte(dev, 0x54, (reg54 & ~mask));
-		spin_unlock_irqrestore(&ide_lock, flags);
-	} else if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
+	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
+		return;
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
 
 		pci_read_config_byte(hwif->pci_dev, 0x49, &ata66);
@@ -220,73 +209,53 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	}
 }
 
-static int __devinit init_setup_aec62xx(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_aec6x80(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	unsigned long dma_base = pci_resource_start(dev, 4);
-
-	if (inb(dma_base + 2) & 0x10) {
-		d->name = (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R) ?
-			  "AEC6880R" : "AEC6880";
-		d->udma_mask = 0x7f; /* udma0-6 */
-	}
-
-	return ide_setup_pci_device(dev, d);
-}
-
 static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "AEC6210",
-		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x07, /* udma0-2 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA2,
 	},{	/* 1 */
 		.name		= "AEC6260",
-		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.autodma	= NOAUTODMA,
-		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x1f, /* udma0-4 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA4,
 	},{	/* 2 */
 		.name		= "AEC6260R",
-		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-		.bootable	= NEVER_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x1f, /* udma0-4 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA4,
 	},{	/* 3 */
 		.name		= "AEC6280",
-		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	},{	/* 4 */
 		.name		= "AEC6280R",
-		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	}
 };
 
@@ -304,9 +273,21 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
  
 static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d = aec62xx_chipsets[id->driver_data];
+	ide_pci_device_t d;
+	u8 idx = id->driver_data;
+
+	d = aec62xx_chipsets[idx];
+
+	if (idx == 3 || idx == 4) {
+		unsigned long dma_base = pci_resource_start(dev, 4);
+
+		if (inb(dma_base + 2) & 0x10) {
+			d.name = (idx == 4) ? "AEC6880R" : "AEC6880";
+			d.udma_mask = ATA_UDMA6;
+		}
+	}
 
-	return d.init_setup(dev, &d);
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id aec62xx_pci_tbl[] = {
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 31d4e50..8ee2b48 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.26	Jul 14 2007
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.27	Aug 27 2007
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -665,34 +665,29 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->udma_filter = &ali_udma_filter;
 
 	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
-	hwif->no_lba48_dma = (m5229_revision <= 0xC4) ? 1 : 0;
+	if (m5229_revision <= 0xC4)
+		hwif->host_flags |= IDE_HFLAG_NO_LBA48_DMA;
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	/*
 	 * check in ->init_dma guarantees m5229_revision >= 0x20 here
 	 */
 
-	if (m5229_revision > 0x20)
-		hwif->atapi_dma = 1;
+	if (m5229_revision == 0x20)
+		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 
 	if (m5229_revision <= 0x20)
 		hwif->ultra_mask = 0x00; /* no udma */
 	else if (m5229_revision < 0xC2)
-		hwif->ultra_mask = 0x07; /* udma0-2 */
+		hwif->ultra_mask = ATA_UDMA2;
 	else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
-		hwif->ultra_mask = 0x1f; /* udma0-4 */
+		hwif->ultra_mask = ATA_UDMA4;
 	else if (m5229_revision == 0xC4)
-		hwif->ultra_mask = 0x3f; /* udma0-5 */
+		hwif->ultra_mask = ATA_UDMA5;
 	else
-		hwif->ultra_mask = 0x7f; /* udma0-6 */
-
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
+		hwif->ultra_mask = ATA_UDMA6;
 
 	hwif->dma_setup = &ali15x3_dma_setup;
 
@@ -776,9 +771,10 @@ static ide_pci_device_t ali15x3_chipset __devinitdata = {
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
+	.swdma_mask	= ATA_SWDMA2,
+	.mwdma_mask	= ATA_MWDMA2,
 };
 
 /**
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 3bf3d93..7cafefb 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -233,7 +233,6 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
  * Print the boot message.
  */
 
-	pci_read_config_byte(dev, PCI_REVISION_ID, &t);
 	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
 		amd_chipset->name, pci_name(dev), dev->revision,
 		amd_dma[fls(amd_config->udma_mask) - 1]);
@@ -254,18 +253,14 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 	for (i = 0; i < 2; i++) {
 		hwif->drives[i].io_32bit = 1;
 		hwif->drives[i].unmask = 1;
-		hwif->drives[i].autotune = 1;
 	}
 
 	if (!hwif->dma_base)
 		return;
 
-        hwif->atapi_dma = 1;
-
 	hwif->ultra_mask = amd_config->udma_mask;
-	hwif->mwdma_mask = 0x07;
-	if ((amd_config->flags & AMD_BAD_SWDMA) == 0)
-		hwif->swdma_mask = 0x07;
+	if (amd_config->flags & AMD_BAD_SWDMA)
+		hwif->swdma_mask = 0x00;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		if ((amd_80w >> hwif->channel) & 1)
@@ -280,13 +275,14 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
-		.autodma	= AUTODMA,				\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
-		.bootable	= ON_BOARD,				\
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
-				| IDE_HFLAG_PIO_NO_DOWNGRADE		\
-				| IDE_HFLAG_POST_SET_MODE,		\
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |		\
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |		\
+				  IDE_HFLAG_POST_SET_MODE |		\
+				  IDE_HFLAG_BOOTABLE,			\
 		.pio_mask	= ATA_PIO5,				\
+		.swdma_mask	= ATA_SWDMA2,				\
+		.mwdma_mask	= ATA_MWDMA2,				\
 	}
 
 #define DECLARE_NV_DEV(name_str)					\
@@ -294,13 +290,14 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
-		.autodma	= AUTODMA,				\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
-		.bootable	= ON_BOARD,				\
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
-				| IDE_HFLAG_PIO_NO_DOWNGRADE		\
-				| IDE_HFLAG_POST_SET_MODE,		\
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |		\
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |		\
+				  IDE_HFLAG_POST_SET_MODE |		\
+				  IDE_HFLAG_BOOTABLE,			\
 		.pio_mask	= ATA_PIO5,				\
+		.swdma_mask	= ATA_SWDMA2,				\
+		.mwdma_mask	= ATA_MWDMA2,				\
 	}
 
 static ide_pci_device_t amd74xx_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 446900d..3078430 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -172,21 +172,12 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	u8 ch = hwif->channel;
 	struct pci_dev *pdev = hwif->pci_dev;
 
-	if (!hwif->irq)
-		hwif->irq = ch ? 15 : 14;
-
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
 
 	if (!hwif->dma_base)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x3f;
-	hwif->mwdma_mask = 0x07;
-
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
 
 	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
@@ -203,18 +194,20 @@ static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
 		.name		= "ATIIXP",
 		.init_hwif	= init_hwif_atiixp,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	},{	/* 1 */
 		.name		= "SB600_PATA",
 		.init_hwif	= init_hwif_atiixp,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
- 		.bootable	= ON_BOARD,
- 		.host_flags	= IDE_HFLAG_SINGLE,
+ 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
  	},
 };
 
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index f3d3bde..adee2ef 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -439,11 +439,8 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 	u8 mrdmode = 0;
 
 	if (dev->device == PCI_DEVICE_ID_CMD_646) {
-		u8 rev = 0;
 
-		pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
-
-		switch (rev) {
+		switch (dev->revision) {
 		case 0x07:
 		case 0x05:
 			printk("%s: UltraDMA capable\n", name);
@@ -505,22 +502,13 @@ static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
 static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 rev			= 0;
-
-	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
 
 	hwif->set_pio_mode = &cmd64x_set_pio_mode;
 	hwif->set_dma_mode = &cmd64x_set_dma_mode;
 
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
-	hwif->atapi_dma  = 1;
-	hwif->mwdma_mask = 0x07;
-	hwif->ultra_mask = hwif->cds->udma_mask;
-
 	/*
 	 * UltraDMA only supported on PCI646U and PCI646U2, which
 	 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
@@ -533,7 +521,7 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	 *
 	 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
 	 */
-	if (dev->device == PCI_DEVICE_ID_CMD_646 && rev < 5)
+	if (dev->device == PCI_DEVICE_ID_CMD_646 && dev->revision < 5)
 		hwif->ultra_mask = 0x00;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
@@ -548,10 +536,10 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 		break;
 	case PCI_DEVICE_ID_CMD_646:
 		hwif->chipset = ide_cmd646;
-		if (rev == 0x01) {
+		if (dev->revision == 0x01) {
 			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
 			break;
-		} else if (rev >= 0x03)
+		} else if (dev->revision >= 0x03)
 			goto alt_irq_bits;
 		/* fall thru */
 	default:
@@ -561,80 +549,61 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	}
 }
 
-static int __devinit init_setup_cmd64x(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_cmd646(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	/*
-	 * The original PCI0646 didn't have the primary channel enable bit,
-	 * it appeared starting with PCI0646U (i.e. revision ID 3).
-	 */
-	if (dev->revision < 3)
-		d->enablebits[0].reg = 0;
-
-	return ide_setup_pci_device(dev, d);
-}
-
 static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
-		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
 	},{	/* 1 */
 		.name		= "CMD646",
-		.init_setup	= init_setup_cmd646,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
-		.udma_mask	= 0x07, /* udma0-2 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA2,
 	},{	/* 2 */
 		.name		= "CMD648",
-		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
-		.udma_mask	= 0x1f, /* udma0-4 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA4,
 	},{	/* 3 */
 		.name		= "CMD649",
-		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
-		.udma_mask	= 0x3f, /* udma0-5 */
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	}
 };
 
-/*
- * We may have to modify enablebits for PCI0646, so we'd better pass
- * a local copy of the ide_pci_device_t structure down the call chain...
- */
 static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d = cmd64x_chipsets[id->driver_data];
+	ide_pci_device_t d;
+	u8 idx = id->driver_data;
+
+	d = cmd64x_chipsets[idx];
+
+	/*
+	 * The original PCI0646 didn't have the primary channel enable bit,
+	 * it appeared starting with PCI0646U (i.e. revision ID 3).
+	 */
+	if (idx == 1 && dev->revision < 3)
+		d.enablebits[0].reg = 0;
 
-	return d.init_setup(dev, &d);
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id cmd64x_pci_tbl[] = {
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index a8bf494..aa98e81 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -106,18 +106,6 @@ static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /*
- *	We provide a callback for our nonstandard DMA location
- */
-
-static void __devinit cs5520_init_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwif_t *hwif)
-{
-	unsigned long bmide = pci_resource_start(dev, 2);	/* Not the usual 4 */
-	if(hwif->mate && hwif->mate->dma_base)	/* Second channel at primary + 8 */
-		bmide += 8;
-	ide_setup_dma(hwif, bmide, 8);
-}
-
-/*
  *	We wrap the DMA activate to set the vdma flag. This is needed
  *	so that the IDE DMA layer issues PIO not DMA commands over the
  *	DMA channel
@@ -125,6 +113,7 @@ static void __devinit cs5520_init_setup_dma(struct pci_dev *dev, ide_pci_device_
  
 static int cs5520_dma_on(ide_drive_t *drive)
 {
+	/* ATAPI is harder so leave it for now */
 	drive->vdma = 1;
 	return 0;
 }
@@ -134,29 +123,21 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &cs5520_set_pio_mode;
 	hwif->set_dma_mode = &cs5520_set_dma_mode;
 
-	if (hwif->dma_base == 0) {
-		hwif->drives[1].autotune = hwif->drives[0].autotune = 1;
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->ide_dma_on = &cs5520_dma_on;
-
-	/* ATAPI is harder so leave it for now */
-	hwif->atapi_dma = 0;
-	hwif->ultra_mask = 0;
-	hwif->swdma_mask = 0;
-	hwif->mwdma_mask = 0;
 }
 
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
-		.init_setup_dma = cs5520_init_setup_dma,	\
 		.init_hwif	= init_hwif_cs5520,		\
-		.autodma	= AUTODMA,			\
-		.bootable	= ON_BOARD,			\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_VDMA,		\
+				  IDE_HFLAG_CS5520 |		\
+				  IDE_HFLAG_VDMA |		\
+				  IDE_HFLAG_NO_ATAPI_DMA |	\
+				  IDE_HFLAG_BOOTABLE,		\
 		.pio_mask	= ATA_PIO4,			\
 	}
 
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 0d23b8a..ba0c6eb 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -245,9 +245,6 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	unsigned long basereg;
 	u32 d0_timings;
 
-	if (hwif->mate)
-		hwif->serialized = hwif->mate->serialized = 1;
-
 	hwif->set_pio_mode = &cs5530_set_pio_mode;
 	hwif->set_dma_mode = &cs5530_set_dma_mode;
 
@@ -258,16 +255,9 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	if (CS5530_BAD_PIO(inl(basereg + 8)))
 		outl(cs5530_pio_timings[(d0_timings >> 31) & 1][0], basereg + 8);
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x07;
-	hwif->mwdma_mask = 0x07;
-
 	hwif->udma_filter = cs5530_udma_filter;
 }
 
@@ -275,10 +265,12 @@ static ide_pci_device_t cs5530_chipset __devinitdata = {
 	.name		= "CS5530",
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_SERIALIZE |
+			  IDE_HFLAG_POST_SET_MODE |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
-	.host_flags	= IDE_HFLAG_POST_SET_MODE,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA2,
 };
 
 static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index e4891a1..5ac82ff 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -84,7 +84,7 @@ static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 
 	/* Set the PIO timings */
 	if ((speed & XFER_MODE) == XFER_PIO) {
-		ide_drive_t *pair = &drive->hwif->drives[drive->dn ^ 1];
+		ide_drive_t *pair = ide_get_paired_drive(drive);
 		u8 cmd, pioa;
 
 		cmd = pioa = speed - XFER_PIO_0;
@@ -180,25 +180,20 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
-	hwif->drives[1].autotune = hwif->drives[0].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x1F;
-	hwif->mwdma_mask = 0x07;
-
 	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
 }
 
 static ide_pci_device_t cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA4,
 };
 
 static int __devinit cs5535_init_one(struct pci_dev *dev,
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index c498ecf..efc20bd 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cy82c693.c		Version 0.40	Sep. 10, 2002
+ * linux/drivers/ide/pci/cy82c693.c		Version 0.41	Aug 27, 2007
  *
  *  Copyright (C) 1998-2000 Andreas S. Krebs (akrebs@altavista.net), Maintainer
  *  Copyright (C) 1998-2002 Andre Hedrick <andre@linux-ide.org>, Integrator
@@ -431,15 +431,8 @@ static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 	hwif->chipset = ide_cy82c693;
 	hwif->set_pio_mode = &cy82c693_set_pio_mode;
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	if (hwif->dma_base == 0)
 		return;
-	}
-
-	hwif->atapi_dma = 1;
-	hwif->mwdma_mask = 0x04;
-	hwif->swdma_mask = 0x04;
 
 	hwif->ide_dma_on = &cy82c693_ide_dma_on;
 }
@@ -461,10 +454,11 @@ static ide_pci_device_t cy82c693_chipset __devinitdata = {
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.swdma_mask	= ATA_SWDMA2_ONLY,
+	.mwdma_mask	= ATA_MWDMA2_ONLY,
 };
 
 static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index cce6311..5116583 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -65,119 +65,65 @@ static void __devinit init_hwif_generic (ide_hwif_t *hwif)
 		default:
 			break;
 	}
-
-	if (!(hwif->dma_base))
-		return;
-
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 }
 
-#if 0
-	/* Logic to add back later on */
-
-	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
-		ide_pci_device_t *unknown = unknown_chipset;
-		init_setup_unknown(dev, unknown);
-		return 1;
+#define DECLARE_GENERIC_PCI_DEV(name_str, dma_setting) \
+	{ \
+		.name		= name_str, \
+		.init_hwif	= init_hwif_generic, \
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
+				  dma_setting | \
+				  IDE_HFLAG_BOOTABLE, \
+		.swdma_mask	= ATA_SWDMA2, \
+		.mwdma_mask	= ATA_MWDMA2, \
+		.udma_mask	= ATA_UDMA6, \
 	}
-	return 0;
-#endif	
 
 static ide_pci_device_t generic_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "Unknown",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 1 */
+	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
+
+	{	/* 1 */
 		.name		= "NS87410",
 		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-        },{	/* 2 */
-		.name		= "SAMURAI",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 3 */
-		.name		= "HT6565",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 4 */
-		.name		= "UM8673F",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 5 */
-		.name		= "UM8886A",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 6 */
-		.name		= "UM8886BF",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 7 */
-		.name		= "HINT_IDE",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 8 */
-		.name		= "VIA_IDE",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NOAUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 9 */
-		.name		= "OPTI621V",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NOAUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 10 */
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+				  IDE_HFLAG_BOOTABLE,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+	},
+
+	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI",	0),
+	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565",	0),
+	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAG_NO_DMA),
+	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAG_NO_DMA),
+	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAG_NO_DMA),
+	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE",	0),
+	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE",	IDE_HFLAG_NO_AUTODMA),
+	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V",	IDE_HFLAG_NO_AUTODMA),
+
+	{	/* 10 */
 		.name		= "VIA8237SATA",
 		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 11 */
-		.name 		= "Piccolo0102",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NOAUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 12 */
-		.name 		= "Piccolo0103",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NOAUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 13 */
-		.name 		= "Piccolo0105",
-		.init_hwif	= init_hwif_generic,
-		.autodma	= NOAUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-	},{	/* 14 */
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+				  IDE_HFLAG_OFF_BOARD,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+	},
+
+	/* 11 */ DECLARE_GENERIC_PCI_DEV("Piccolo0102",	IDE_HFLAG_NO_AUTODMA),
+	/* 12 */ DECLARE_GENERIC_PCI_DEV("Piccolo0103",	IDE_HFLAG_NO_AUTODMA),
+	/* 13 */ DECLARE_GENERIC_PCI_DEV("Piccolo0105",	IDE_HFLAG_NO_AUTODMA),
+
+	{	/* 14 */
 		.name		= "Revolution",
 		.init_hwif	= init_hwif_generic,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+				  IDE_HFLAG_OFF_BOARD,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
 	}
 };
 
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 44ac0e2..67af1a7 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -125,49 +125,45 @@ static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev, const cha
 
 static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 {
-	u16 pcicmd = 0;
-
 	hwif->set_pio_mode = &hpt34x_set_pio_mode;
 	hwif->set_dma_mode = &hpt34x_set_mode;
+}
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
-	pci_read_config_word(hwif->pci_dev, PCI_COMMAND, &pcicmd);
-
-	if (!hwif->dma_base)
-		return;
-
+static ide_pci_device_t hpt34x_chipsets[] __devinitdata = {
+	{ /* 0 */
+		.name		= "HPT343",
+		.init_chipset	= init_chipset_hpt34x,
+		.init_hwif	= init_hwif_hpt34x,
+		.extra		= 16,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_NO_AUTODMA,
+		.pio_mask	= ATA_PIO5,
+	},
+	{ /* 1 */
+		.name		= "HPT345",
+		.init_chipset	= init_chipset_hpt34x,
+		.init_hwif	= init_hwif_hpt34x,
+		.extra		= 16,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_NO_AUTODMA |
+				  IDE_HFLAG_OFF_BOARD,
+		.pio_mask	= ATA_PIO5,
 #ifdef CONFIG_HPT34X_AUTODMA
-	if ((pcicmd & PCI_COMMAND_MEMORY) == 0)
-		return;
-
-	hwif->ultra_mask = 0x07;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA2,
 #endif
-}
-
-static ide_pci_device_t hpt34x_chipset __devinitdata = {
-	.name		= "HPT34X",
-	.init_chipset	= init_chipset_hpt34x,
-	.init_hwif	= init_hwif_hpt34x,
-	.autodma	= NOAUTODMA,
-	.bootable	= NEVER_BOARD,
-	.extra		= 16,
-	.pio_mask	= ATA_PIO5,
+	}
 };
 
 static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &hpt34x_chipset;
-	static char *chipset_names[] = {"HPT343", "HPT345"};
+	ide_pci_device_t *d;
 	u16 pcicmd = 0;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 
-	d->name = chipset_names[(pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0];
-	d->bootable = (pcicmd & PCI_COMMAND_MEMORY) ? OFF_BOARD : NEVER_BOARD;
+	d = &hpt34x_chipsets[(pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0];
 
 	return ide_setup_pci_device(dev, d);
 }
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index fcb21dd..18f5b7d 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,9 +1,10 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.14	Oct 1, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.20	Oct 1, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
+ * Portions Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
  *
  * Thanks to HighPoint Technologies for their assistance, and hardware.
@@ -393,8 +394,9 @@ enum ata_clock {
  */
 
 struct hpt_info {
+	char *chip_name;	/* Chip name */
 	u8 chip_type;		/* Chip type */
-	u8 max_ultra;		/* Max. UltraDMA mode allowed */
+	u8 udma_mask;		/* Allowed UltraDMA modes mask. */
 	u8 dpll_clk;		/* DPLL clock in MHz */
 	u8 pci_clk;		/* PCI  clock in MHz */
 	u32 **settings; 	/* Chipset settings table */
@@ -432,78 +434,89 @@ static u32 *hpt37x_settings[NUM_ATA_CLOCKS] = {
 };
 
 static struct hpt_info hpt36x __devinitdata = {
+	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
-	.max_ultra	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? 4 : 3) : 2,
+	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
 	.dpll_clk	= 0,	/* no DPLL */
 	.settings	= hpt36x_settings
 };
 
 static struct hpt_info hpt370 __devinitdata = {
+	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
-	.max_ultra	= HPT370_ALLOW_ATA100_5 ? 5 : 4,
+	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt370a __devinitdata = {
+	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
-	.max_ultra	= HPT370_ALLOW_ATA100_5 ? 5 : 4,
+	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt374 __devinitdata = {
+	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
-	.max_ultra	= 5,
+	.udma_mask	= ATA_UDMA5,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372 __devinitdata = {
+	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
-	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 55,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372a __devinitdata = {
+	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
-	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt302 __devinitdata = {
+	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
-	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371 __devinitdata = {
+	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
-	.max_ultra	= HPT371_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372n __devinitdata = {
+	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
-	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt302n __devinitdata = {
+	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
-	.max_ultra	= HPT302_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371n __devinitdata = {
+	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
-	.max_ultra	= HPT371_ALLOW_ATA133_6 ? 6 : 5,
+	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
@@ -676,12 +689,11 @@ static int hpt3xx_quirkproc(ide_drive_t *drive)
 
 static void hpt3xx_intrproc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-
 	if (drive->quirk_list)
 		return;
+
 	/* drives in the quirk_list may not like intr setups/cleanups */
-	hwif->OUTB(drive->ctl | 2, IDE_CONTROL_REG);
+	outb(drive->ctl | 2, IDE_CONTROL_REG);
 }
 
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
@@ -709,8 +721,8 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 				enable_irq (hwif->irq);
 		}
 	} else
-		hwif->OUTB(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-			   IDE_CONTROL_REG);
+		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
+		     IDE_CONTROL_REG);
 }
 
 /*
@@ -750,9 +762,9 @@ static void hpt370_irq_timeout(ide_drive_t *drive)
 	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
 
 	/* get DMA command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_command);
 	/* stop DMA */
-	hwif->OUTB(dma_cmd & ~0x1, hwif->dma_command);
+	outb(dma_cmd & ~0x1, hwif->dma_command);
 	hpt370_clear_engine(drive);
 }
 
@@ -767,12 +779,12 @@ static void hpt370_ide_dma_start(ide_drive_t *drive)
 static int hpt370_ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8  dma_stat		= hwif->INB(hwif->dma_status);
+	u8  dma_stat		= inb(hwif->dma_status);
 
 	if (dma_stat & 0x01) {
 		/* wait a little */
 		udelay(20);
-		dma_stat = hwif->INB(hwif->dma_status);
+		dma_stat = inb(hwif->dma_status);
 		if (dma_stat & 0x01)
 			hpt370_irq_timeout(drive);
 	}
@@ -833,34 +845,32 @@ static int hpt374_ide_dma_end(ide_drive_t *drive)
 
 static void hpt3xxn_set_clock(ide_hwif_t *hwif, u8 mode)
 {
-	u8 scr2 = hwif->INB(hwif->dma_master + 0x7b);
+	u8 scr2 = inb(hwif->dma_master + 0x7b);
 
 	if ((scr2 & 0x7f) == mode)
 		return;
 
 	/* Tristate the bus */
-	hwif->OUTB(0x80, hwif->dma_master + 0x73);
-	hwif->OUTB(0x80, hwif->dma_master + 0x77);
+	outb(0x80, hwif->dma_master + 0x73);
+	outb(0x80, hwif->dma_master + 0x77);
 
 	/* Switch clock and reset channels */
-	hwif->OUTB(mode, hwif->dma_master + 0x7b);
-	hwif->OUTB(0xc0, hwif->dma_master + 0x79);
+	outb(mode, hwif->dma_master + 0x7b);
+	outb(0xc0, hwif->dma_master + 0x79);
 
 	/*
 	 * Reset the state machines.
 	 * NOTE: avoid accidentally enabling the disabled channels.
 	 */
-	hwif->OUTB(hwif->INB(hwif->dma_master + 0x70) | 0x32,
-		   hwif->dma_master + 0x70);
-	hwif->OUTB(hwif->INB(hwif->dma_master + 0x74) | 0x32,
-		   hwif->dma_master + 0x74);
+	outb(inb(hwif->dma_master + 0x70) | 0x32, hwif->dma_master + 0x70);
+	outb(inb(hwif->dma_master + 0x74) | 0x32, hwif->dma_master + 0x74);
 
 	/* Complete reset */
-	hwif->OUTB(0x00, hwif->dma_master + 0x79);
+	outb(0x00, hwif->dma_master + 0x79);
 
 	/* Reconnect channels to bus */
-	hwif->OUTB(0x00, hwif->dma_master + 0x73);
-	hwif->OUTB(0x00, hwif->dma_master + 0x77);
+	outb(0x00, hwif->dma_master + 0x73);
+	outb(0x00, hwif->dma_master + 0x77);
 }
 
 /**
@@ -1139,7 +1149,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		  * Select 66 MHz DPLL clock only if UltraATA/133 mode is
 		  * supported/enabled, use 50 MHz DPLL clock otherwise...
 		  */
-		if (info->max_ultra == 6) {
+		if (info->udma_mask == ATA_UDMA6) {
 			dpll_clk = 66;
 			clock = ATA_CLOCK_66MHZ;
 		} else if (dpll_clk) {	/* HPT36x chips don't have DPLL */
@@ -1291,14 +1301,9 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	if (new_mcr != old_mcr)
 		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
 
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ultra_mask = hwif->cds->udma_mask;
-	hwif->mwdma_mask = 0x07;
-
 	/*
 	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
 	 * address lines to access an external EEPROM.  To read valid
@@ -1354,7 +1359,7 @@ static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
 	u8 dma_new	= 0, dma_old	= 0;
 	unsigned long flags;
 
-	dma_old = hwif->INB(dmabase + 2);
+	dma_old = inb(dmabase + 2);
 
 	local_irq_save(flags);
 
@@ -1365,60 +1370,26 @@ static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
 	if (masterdma & 0x30)	dma_new |= 0x20;
 	if ( slavedma & 0x30)	dma_new |= 0x40;
 	if (dma_new != dma_old)
-		hwif->OUTB(dma_new, dmabase + 2);
+		outb(dma_new, dmabase + 2);
 
 	local_irq_restore(flags);
 
 	ide_setup_dma(hwif, dmabase, 8);
 }
 
-static int __devinit init_setup_hpt374(struct pci_dev *dev, ide_pci_device_t *d)
+static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
 {
-	struct pci_dev *dev2;
-
-	if (PCI_FUNC(dev->devfn) & 1)
-		return -ENODEV;
-
-	pci_set_drvdata(dev, &hpt374);
-
-	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
-		int ret;
-
-		pci_set_drvdata(dev2, &hpt374);
-
-		if (dev2->irq != dev->irq) {
-			/* FIXME: we need a core pci_set_interrupt() */
-			dev2->irq = dev->irq;
-			printk(KERN_WARNING "%s: PCI config space interrupt "
-			       "fixed.\n", d->name);
-		}
-		ret = ide_setup_pci_devices(dev, dev2, d);
-		if (ret < 0)
-			pci_dev_put(dev2);
-		return ret;
+	if (dev2->irq != dev->irq) {
+		/* FIXME: we need a core pci_set_interrupt() */
+		dev2->irq = dev->irq;
+		printk(KERN_INFO "HPT374: PCI config space interrupt fixed\n");
 	}
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_hpt372n(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	pci_set_drvdata(dev, &hpt372n);
-
-	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_hpt371(struct pci_dev *dev, ide_pci_device_t *d)
+static void __devinit hpt371_init(struct pci_dev *dev)
 {
-	struct hpt_info *info;
 	u8 mcr1 = 0;
 
-	if (dev->revision > 1) {
-		d->name = "HPT371N";
-
-		info = &hpt371n;
-	} else
-		info = &hpt371;
-
 	/*
 	 * HPT371 chips physically have only one channel, the secondary one,
 	 * but the primary channel registers do exist!  Go figure...
@@ -1428,194 +1399,102 @@ static int __devinit init_setup_hpt371(struct pci_dev *dev, ide_pci_device_t *d)
 	pci_read_config_byte(dev, 0x50, &mcr1);
 	if (mcr1 & 0x04)
 		pci_write_config_byte(dev, 0x50, mcr1 & ~0x04);
-
-	pci_set_drvdata(dev, info);
-
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_hpt372a(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	struct hpt_info *info;
-
-	if (dev->revision > 1) {
-		d->name = "HPT372N";
-
-		info = &hpt372n;
-	} else
-		info = &hpt372a;
-	pci_set_drvdata(dev, info);
-
-	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_hpt302(struct pci_dev *dev, ide_pci_device_t *d)
+static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 {
-	struct hpt_info *info;
-
-	if (dev->revision > 1) {
-		d->name = "HPT302N";
+	u8 mcr1 = 0, pin1 = 0, pin2 = 0;
 
-		info = &hpt302n;
-	} else
-		info = &hpt302;
-	pci_set_drvdata(dev, info);
-
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	struct pci_dev *dev2;
-	u8 rev = dev->revision;
-	static char   *chipset_names[] = { "HPT366", "HPT366",  "HPT368",
-					   "HPT370", "HPT370A", "HPT372",
-					   "HPT372N" };
-	static struct hpt_info *info[] = { &hpt36x,  &hpt36x,  &hpt36x,
-					   &hpt370,  &hpt370a, &hpt372,
-					   &hpt372n  };
-
-	if (PCI_FUNC(dev->devfn) & 1)
-		return -ENODEV;
+	/*
+	 * Now we'll have to force both channels enabled if
+	 * at least one of them has been enabled by BIOS...
+	 */
+	pci_read_config_byte(dev, 0x50, &mcr1);
+	if (mcr1 & 0x30)
+		pci_write_config_byte(dev, 0x50, mcr1 | 0x30);
 
-	switch (rev) {
-	case 0:
-	case 1:
-	case 2:
-		/*
-		 * HPT36x chips have one channel per function and have
-		 * both channel enable bits located differently and visible
-		 * to both functions -- really stupid design decision... :-(
-		 * Bit 4 is for the primary channel, bit 5 for the secondary.
-		 */
-		d->host_flags |= IDE_HFLAG_SINGLE;
-		d->enablebits[0].mask = d->enablebits[0].val = 0x10;
+	pci_read_config_byte(dev,  PCI_INTERRUPT_PIN, &pin1);
+	pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 
-		d->udma_mask = HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ?
-			       ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2;
-		break;
-	case 3:
-	case 4:
-		d->udma_mask = HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4;
-		break;
-	default:
-		rev = 6;
-		/* fall thru */
-	case 5:
-	case 6:
-		d->udma_mask = HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5;
-		break;
+	if (pin1 != pin2 && dev->irq == dev2->irq) {
+		printk(KERN_INFO "HPT36x: onboard version of chipset, "
+				 "pin1=%d pin2=%d\n", pin1, pin2);
+		return 1;
 	}
 
-	d->name = chipset_names[rev];
-
-	pci_set_drvdata(dev, info[rev]);
-
-	if (rev > 2)
-		goto init_single;
-
-	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
-		u8  mcr1 = 0, pin1 = 0, pin2 = 0;
-		int ret;
-
-		pci_set_drvdata(dev2, info[rev]);
-
-		/*
-		 * Now we'll have to force both channels enabled if
-		 * at least one of them has been enabled by BIOS...
-		 */
-		pci_read_config_byte(dev, 0x50, &mcr1);
-		if (mcr1 & 0x30)
-			pci_write_config_byte(dev, 0x50, mcr1 | 0x30);
-
-		pci_read_config_byte(dev,  PCI_INTERRUPT_PIN, &pin1);
-		pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
-		if (pin1 != pin2 && dev->irq == dev2->irq) {
-			d->bootable = ON_BOARD;
-			printk("%s: onboard version of chipset, pin1=%d pin2=%d\n",
-			       d->name, pin1, pin2);
-		}
-		ret = ide_setup_pci_devices(dev, dev2, d);
-		if (ret < 0)
-			pci_dev_put(dev2);
-		return ret;
-	}
-init_single:
-	return ide_setup_pci_device(dev, d);
+	return 0;
 }
 
 static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 	{	/* 0 */
-		.name		= "HPT366",
-		.init_setup	= init_setup_hpt366,
+		.name		= "HPT36x",
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.bootable	= OFF_BOARD,
+		/*
+		 * HPT36x chips have one channel per function and have
+		 * both channel enable bits located differently and visible
+		 * to both functions -- really stupid design decision... :-(
+		 * Bit 4 is for the primary channel, bit 5 for the secondary.
+		 */
+		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_SINGLE |
+				  IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
 		.name		= "HPT372A",
-		.init_setup	= init_setup_hpt372a,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
-		.bootable	= OFF_BOARD,
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 2 */
 		.name		= "HPT302",
-		.init_setup	= init_setup_hpt302,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
-		.bootable	= OFF_BOARD,
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 3 */
 		.name		= "HPT371",
-		.init_setup	= init_setup_hpt371,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
-		.bootable	= OFF_BOARD,
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 4 */
 		.name		= "HPT374",
-		.init_setup	= init_setup_hpt374,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
-		.bootable	= OFF_BOARD,
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 5 */
 		.name		= "HPT372N",
-		.init_setup	= init_setup_hpt372n,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
-		.bootable	= OFF_BOARD,
 		.extra		= 240,
+		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 	}
 };
 
@@ -1626,16 +1505,77 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
  *
  *	Called when the PCI registration layer (or the IDE initialization)
  *	finds a device matching our IDE device tables.
- *
- *	NOTE: since we'll have to modify some fields of the ide_pci_device_t
- *	structure depending on the chip's revision, we'd better pass a local
- *	copy down the call chain...
  */
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t d = hpt366_chipsets[id->driver_data];
+	struct hpt_info *info = NULL;
+	struct pci_dev *dev2 = NULL;
+	ide_pci_device_t d;
+	u8 idx = id->driver_data;
+	u8 rev = dev->revision;
+
+	if ((idx == 0 || idx == 4) && (PCI_FUNC(dev->devfn) & 1))
+		return -ENODEV;
+
+	switch (idx) {
+	case 0:
+		if (rev < 3)
+			info = &hpt36x;
+		else {
+			static struct hpt_info *hpt37x_info[] =
+				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
+
+			info = hpt37x_info[min_t(u8, rev, 6) - 3];
+			idx++;
+		}
+		break;
+	case 1:
+		info = (rev > 1) ? &hpt372n : &hpt372a;
+		break;
+	case 2:
+		info = (rev > 1) ? &hpt302n : &hpt302;
+		break;
+	case 3:
+		hpt371_init(dev);
+		info = (rev > 1) ? &hpt371n : &hpt371;
+		break;
+	case 4:
+		info = &hpt374;
+		break;
+	case 5:
+		info = &hpt372n;
+		break;
+	}
+
+	d = hpt366_chipsets[idx];
+
+	d.name = info->chip_name;
+	d.udma_mask = info->udma_mask;
+
+	pci_set_drvdata(dev, info);
+
+	if (info == &hpt36x || info == &hpt374)
+		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
+
+	if (dev2) {
+		int ret;
+
+		pci_set_drvdata(dev2, info);
+
+		if (info == &hpt374)
+			hpt374_init(dev, dev2);
+		else {
+			if (hpt36x_init(dev, dev2))
+				d.host_flags |= IDE_HFLAG_BOOTABLE;
+		}
+
+		ret = ide_setup_pci_devices(dev, dev2, &d);
+		if (ret < 0)
+			pci_dev_put(dev2);
+		return ret;
+	}
 
-	return d.init_setup(dev, &d);
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id hpt366_pci_tbl[] = {
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 24a71d0..dfbe605 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -170,17 +170,9 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	hwif->set_dma_mode = &it8213_set_dma_mode;
 	hwif->set_pio_mode = &it8213_set_pio_mode;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x06;
-	hwif->swdma_mask = 0x04;
-
 	pci_read_config_byte(hwif->pci_dev, 0x42, &reg42h);
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
@@ -192,11 +184,13 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	{						\
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_it8213,	\
-		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}}, \
-		.bootable	= ON_BOARD,		\
-		.host_flags	= IDE_HFLAG_SINGLE,	\
+		.host_flags	= IDE_HFLAG_SINGLE |	\
+				  IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
+		.swdma_mask	= ATA_SWDMA2_ONLY,	\
+		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
+		.udma_mask	= ATA_UDMA6,		\
 	}
 
 static ide_pci_device_t it8213_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index f3391a8..ec45b72 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -544,12 +544,10 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 
 	ide_set_hwifdata(hwif, idev);
 
-	hwif->atapi_dma = 1;
-
 	pci_read_config_byte(hwif->pci_dev, 0x50, &conf);
-	if(conf & 1) {
+	if (conf & 1) {
 		idev->smart = 1;
-		hwif->atapi_dma = 0;
+		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		/* Long I/O's although allowed in LBA48 space cause the
 		   onboard firmware to enter the twighlight zone */
 		hwif->rqsize = 256;
@@ -570,10 +568,10 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	 */
 
 	pci_read_config_byte(hwif->pci_dev, 0x08, &conf);
-	if(conf == 0x10) {
+	if (conf == 0x10) {
 		idev->timing10 = 1;
-		hwif->atapi_dma = 0;
-		if(!idev->smart)
+		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
+		if (idev->smart == 0)
 			printk(KERN_WARNING "it821x: Revision 0x10, workarounds activated.\n");
 	}
 
@@ -587,14 +585,11 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
+	hwif->ultra_mask = ATA_UDMA6;
+	hwif->mwdma_mask = ATA_MWDMA2;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_it821x(hwif);
@@ -638,9 +633,8 @@ static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const cha
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_it821x,	\
 		.init_hwif	= init_hwif_it821x,	\
-		.autodma	= AUTODMA,		\
-		.bootable	= ON_BOARD,		\
 		.fixup	 	= it821x_fixups,	\
+		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
 	}
 
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index bb893ff..2eeff67 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -111,16 +111,9 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &jmicron_set_pio_mode;
 	hwif->set_dma_mode = &jmicron_set_dma_mode;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_jmicron(hwif);
 }
@@ -128,10 +121,11 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 static ide_pci_device_t jmicron_chipset __devinitdata = {
 	.name		= "JMB",
 	.init_hwif	= init_hwif_jmicron,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.pio_mask	= ATA_PIO5,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA6,
 };
 
 /**
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index a8cd50a..d21b589 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -266,9 +266,9 @@ static ide_pci_device_t ns87415_chipset __devinitdata = {
 	.init_iops	= init_iops_ns87415,
 #endif
 	.init_hwif	= init_hwif_ns87415,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+			  IDE_HFLAG_NO_ATAPI_DMA |
+			  IDE_HFLAG_BOOTABLE,
 };
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 250662e..3573ffe 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/opti621.c		Version 0.7	Sept 10, 2002
+ *  linux/drivers/ide/pci/opti621.c		Version 0.8	Aug 27, 2007
  *
  *  Copyright (C) 1996-1998  Linus Torvalds & authors (see below)
  */
@@ -57,9 +57,6 @@
  * There is a 25/33MHz switch in configuration
  * register, but driver is written for use at any frequency which get
  * (use idebus=xx to select PCI bus speed).
- * Use hda=autotune and hdb=autotune for automatical tune of the PIO modes.
- * If you get strange results, do not use this and set PIO manually
- * by hdparm.
  *
  * Version 0.1, Nov 8, 1996
  * by Jaromir Koutek, for 2.1.8. 
@@ -332,32 +329,27 @@ static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 	hwif->drives[1].drive_data = PIO_DONT_KNOW;
 
 	hwif->set_pio_mode = &opti621_set_pio_mode;
-
-	if (!(hwif->dma_base))
-		return;
-
-	hwif->atapi_dma = 1;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 }
 
 static ide_pci_device_t opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO3,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO3,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
 	}
 };
 
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 8704b6f..d1e7823 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -332,16 +332,12 @@ static long __devinit detect_pll_input_clock(unsigned long dma_base)
 static void __devinit apple_kiwi_init(struct pci_dev *pdev)
 {
 	struct device_node *np = pci_device_to_OF_node(pdev);
-	unsigned int class_rev = 0;
 	u8 conf;
 
 	if (np == NULL || !of_device_is_compatible(np, "kiwi-root"))
 		return;
 
-	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
-
-	if (class_rev >= 0x03) {
+	if (pdev->revision >= 0x03) {
 		/* Setup chip magic config stuff (from darwin) */
 		pci_read_config_byte (pdev, 0x40, &conf);
 		pci_write_config_byte(pdev, 0x40, (conf | 0x01));
@@ -475,32 +471,76 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->quirkproc = &pdcnew_quirkproc;
 	hwif->resetproc = &pdcnew_reset;
 
-	hwif->err_stops_fifo = 1;
-
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma  = 1;
-
-	hwif->ultra_mask = hwif->cds->udma_mask;
-	hwif->mwdma_mask = 0x07;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = pdcnew_cable_detect(hwif);
 }
 
-static int __devinit init_setup_pdcnew(struct pci_dev *dev, ide_pci_device_t *d)
+static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 {
-	return ide_setup_pci_device(dev, d);
+	struct pci_dev *dev2;
+
+	dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 2,
+						PCI_FUNC(dev->devfn)));
+	if (dev2 &&
+	    dev2->vendor == dev->vendor &&
+	    dev2->device == dev->device) {
+
+		if (dev2->irq != dev->irq) {
+			dev2->irq = dev->irq;
+			printk(KERN_INFO "PDC20270: PCI config space "
+					 "interrupt fixed\n");
+		}
+
+		return dev2;
+	}
+
+	return NULL;
 }
 
-static int __devinit init_setup_pdc20270(struct pci_dev *dev, ide_pci_device_t *d)
+#define DECLARE_PDCNEW_DEV(name_str, udma) \
+	{ \
+		.name		= name_str, \
+		.init_chipset	= init_chipset_pdcnew, \
+		.init_hwif	= init_hwif_pdc202new, \
+		.host_flags	= IDE_HFLAG_POST_SET_MODE | \
+				  IDE_HFLAG_ERROR_STOPS_FIFO | \
+				  IDE_HFLAG_OFF_BOARD, \
+		.pio_mask	= ATA_PIO4, \
+		.mwdma_mask	= ATA_MWDMA2, \
+		.udma_mask	= udma, \
+	}
+
+static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
+	/* 0 */ DECLARE_PDCNEW_DEV("PDC20268", ATA_UDMA5),
+	/* 1 */ DECLARE_PDCNEW_DEV("PDC20269", ATA_UDMA6),
+	/* 2 */ DECLARE_PDCNEW_DEV("PDC20270", ATA_UDMA5),
+	/* 3 */ DECLARE_PDCNEW_DEV("PDC20271", ATA_UDMA6),
+	/* 4 */ DECLARE_PDCNEW_DEV("PDC20275", ATA_UDMA6),
+	/* 5 */ DECLARE_PDCNEW_DEV("PDC20276", ATA_UDMA6),
+	/* 6 */ DECLARE_PDCNEW_DEV("PDC20277", ATA_UDMA6),
+};
+
+/**
+ *	pdc202new_init_one	-	called when a pdc202xx is found
+ *	@dev: the pdc202new device
+ *	@id: the matching pci id
+ *
+ *	Called when the PCI registration layer (or the IDE initialization)
+ *	finds a device matching our IDE device tables.
+ */
+ 
+static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	ide_pci_device_t *d;
 	struct pci_dev *bridge = dev->bus->self;
+	u8 idx = id->driver_data;
+
+	d = &pdcnew_chipsets[idx];
 
-	if (bridge != NULL &&
+	if (idx == 2 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_DEC &&
 	    bridge->device == PCI_DEVICE_ID_DEC_21150) {
 		struct pci_dev *dev2;
@@ -508,133 +548,26 @@ static int __devinit init_setup_pdc20270(struct pci_dev *dev, ide_pci_device_t *
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
 
-		dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 2,
-							PCI_FUNC(dev->devfn)));
-		if (dev2 != NULL &&
-		    dev2->vendor == dev->vendor &&
-		    dev2->device == dev->device) {
-			int ret;
-
-			if (dev2->irq != dev->irq) {
-				dev2->irq = dev->irq;
+		dev2 = pdc20270_get_dev2(dev);
 
-				printk(KERN_WARNING "%s: PCI config space "
-				       "interrupt fixed.\n", d->name);
-			}
-
-			ret = ide_setup_pci_devices(dev, dev2, d);
+		if (dev2) {
+			int ret = ide_setup_pci_devices(dev, dev2, d);
 			if (ret < 0)
 				pci_dev_put(dev2);
 			return ret;
 		}
 	}
-	return ide_setup_pci_device(dev, d);
-}
 
-static int __devinit init_setup_pdc20276(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	struct pci_dev *bridge = dev->bus->self;
-
-	if (bridge != NULL &&
+	if (idx == 5 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
-	   (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
-	    bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-
-		printk(KERN_INFO "%s: attached to I2O RAID controller, "
-				 "skipping.\n", d->name);
+	    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
+	     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
+		printk(KERN_INFO "PDC20276: attached to I2O RAID controller, "
+				 "skipping\n");
 		return -ENODEV;
 	}
-	return ide_setup_pci_device(dev, d);
-}
-
-static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "PDC20268",
-		.init_setup	= init_setup_pdcnew,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 1 */
-		.name		= "PDC20269",
-		.init_setup	= init_setup_pdcnew,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x7f, /* udma0-6*/
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 2 */
-		.name		= "PDC20270",
-		.init_setup	= init_setup_pdc20270,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 3 */
-		.name		= "PDC20271",
-		.init_setup	= init_setup_pdcnew,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x7f, /* udma0-6*/
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 4 */
-		.name		= "PDC20275",
-		.init_setup	= init_setup_pdcnew,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x7f, /* udma0-6*/
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 5 */
-		.name		= "PDC20276",
-		.init_setup	= init_setup_pdc20276,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x7f, /* udma0-6*/
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	},{	/* 6 */
-		.name		= "PDC20277",
-		.init_setup	= init_setup_pdcnew,
-		.init_chipset	= init_chipset_pdcnew,
-		.init_hwif	= init_hwif_pdc202new,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x7f, /* udma0-6*/
-		.host_flags	= IDE_HFLAG_POST_SET_MODE,
-	}
-};
 
-/**
- *	pdc202new_init_one	-	called when a pdc202xx is found
- *	@dev: the pdc202new device
- *	@id: the matching pci id
- *
- *	Called when the PCI registration layer (or the IDE initialization)
- *	finds a device matching our IDE device tables.
- */
- 
-static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	ide_pci_device_t *d = &pdcnew_chipsets[id->driver_data];
-
-	return d->init_setup(dev, d);
+	return ide_setup_pci_device(dev, d);
 }
 
 static const struct pci_device_id pdc202new_pci_tbl[] = {
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index e1d2337..2930612 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.51	Jul 27, 2007
+ *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.52	Aug 27, 2007
  *
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
@@ -97,9 +97,6 @@ static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
 		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
 		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;
-		case XFER_SW_DMA_2:	TB = 0x60; TC = 0x05; break;
-		case XFER_SW_DMA_1:	TB = 0x80; TC = 0x06; break;
-		case XFER_SW_DMA_0:	TB = 0xC0; TC = 0x0B; break;
 		case XFER_PIO_4:	TA = 0x01; TB = 0x04; break;
 		case XFER_PIO_3:	TA = 0x02; TB = 0x06; break;
 		case XFER_PIO_2:	TA = 0x03; TB = 0x08; break;
@@ -320,18 +317,9 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246)
 		hwif->resetproc = &pdc202xx_reset;
 
-	hwif->err_stops_fifo = 1;
-
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ultra_mask = hwif->cds->udma_mask;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
-	hwif->atapi_dma = 1;
-
 	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
@@ -377,8 +365,8 @@ static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
 	ide_setup_dma(hwif, dmabase, 8);
 }
 
-static int __devinit init_setup_pdc202ata4(struct pci_dev *dev,
-					   ide_pci_device_t *d)
+static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
+					   const char *name)
 {
 	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE) {
 		u8 irq = 0, irq2 = 0;
@@ -388,90 +376,44 @@ static int __devinit init_setup_pdc202ata4(struct pci_dev *dev,
 		if (irq != irq2) {
 			pci_write_config_byte(dev,
 				(PCI_INTERRUPT_LINE)|0x80, irq);     /* 0xbc */
-			printk(KERN_INFO "%s: pci-config space interrupt "
-				"mirror fixed.\n", d->name);
+			printk(KERN_INFO "%s: PCI config space interrupt "
+					 "mirror fixed\n", name);
 		}
 	}
-	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_pdc20265(struct pci_dev *dev,
-					 ide_pci_device_t *d)
-{
-	if ((dev->bus->self) &&
-	    (dev->bus->self->vendor == PCI_VENDOR_ID_INTEL) &&
-	    ((dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960) ||
-	     (dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960RM))) {
-		printk(KERN_INFO "ide: Skipping Promise PDC20265 "
-			"attached to I2O RAID controller.\n");
-		return -ENODEV;
+#define DECLARE_PDC2026X_DEV(name_str, udma) \
+	{ \
+		.name		= name_str, \
+		.init_chipset	= init_chipset_pdc202xx, \
+		.init_hwif	= init_hwif_pdc202xx, \
+		.init_dma	= init_dma_pdc202xx, \
+		.extra		= 48, \
+		.host_flags	= IDE_HFLAG_ERROR_STOPS_FIFO | \
+				  IDE_HFLAG_OFF_BOARD, \
+		.pio_mask	= ATA_PIO4, \
+		.mwdma_mask	= ATA_MWDMA2, \
+		.udma_mask	= udma, \
 	}
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_pdc202xx(struct pci_dev *dev,
-					 ide_pci_device_t *d)
-{
-	return ide_setup_pci_device(dev, d);
-}
 
 static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "PDC20246",
-		.init_setup	= init_setup_pdc202ata4,
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
 		.extra		= 16,
+		.host_flags	= IDE_HFLAG_ERROR_STOPS_FIFO |
+				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x07, /* udma0-2 */
-	},{	/* 1 */
-		.name		= "PDC20262",
-		.init_setup	= init_setup_pdc202ata4,
-		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.extra		= 48,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x1f, /* udma0-4 */
-	},{	/* 2 */
-		.name		= "PDC20263",
-		.init_setup	= init_setup_pdc202ata4,
-		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.extra		= 48,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x1f, /* udma0-4 */
-	},{	/* 3 */
-		.name		= "PDC20265",
-		.init_setup	= init_setup_pdc20265,
-		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.extra		= 48,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
-	},{	/* 4 */
-		.name		= "PDC20267",
-		.init_setup	= init_setup_pdc202xx,
-		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-		.extra		= 48,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= 0x3f, /* udma0-5 */
-	}
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA2,
+	},
+
+	/* 1 */ DECLARE_PDC2026X_DEV("PDC20262", ATA_UDMA4),
+	/* 2 */ DECLARE_PDC2026X_DEV("PDC20263", ATA_UDMA4),
+	/* 3 */ DECLARE_PDC2026X_DEV("PDC20265", ATA_UDMA5),
+	/* 4 */ DECLARE_PDC2026X_DEV("PDC20267", ATA_UDMA5),
 };
 
 /**
@@ -485,9 +427,28 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
  
 static int __devinit pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &pdc202xx_chipsets[id->driver_data];
+	ide_pci_device_t *d;
+	u8 idx = id->driver_data;
+
+	d = &pdc202xx_chipsets[idx];
+
+	if (idx < 3)
+		pdc202ata4_fixup_irq(dev, d->name);
+
+	if (idx == 3) {
+		struct pci_dev *bridge = dev->bus->self;
 
-	return d->init_setup(dev, d);
+		if (bridge &&
+		    bridge->vendor == PCI_VENDOR_ID_INTEL &&
+		    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
+		     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
+			printk(KERN_INFO "ide: Skipping Promise PDC20265 "
+				"attached to I2O RAID controller\n");
+			return -ENODEV;
+		}
+	}
+
+	return ide_setup_pci_device(dev, d);
 }
 
 static const struct pci_device_id pdc202xx_pci_tbl[] = {
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index a8dd0c0..ec0c6e9 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.53	Aug 9, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.54	Sep 5, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -254,53 +254,20 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	piix_is_ichx	-	check if ICHx
- *	@dev: PCI device to check
- *
- *	returns 1 if ICHx, 0 otherwise.
- */
-static int piix_is_ichx(struct pci_dev *dev)
-{
-        switch (dev->device) {
-		case PCI_DEVICE_ID_INTEL_82801EB_1:
-		case PCI_DEVICE_ID_INTEL_82801AA_1:
-		case PCI_DEVICE_ID_INTEL_82801AB_1:
-		case PCI_DEVICE_ID_INTEL_82801BA_8:
-		case PCI_DEVICE_ID_INTEL_82801BA_9:
-		case PCI_DEVICE_ID_INTEL_82801CA_10:
-		case PCI_DEVICE_ID_INTEL_82801CA_11:
-		case PCI_DEVICE_ID_INTEL_82801DB_1:
-		case PCI_DEVICE_ID_INTEL_82801DB_10:
-		case PCI_DEVICE_ID_INTEL_82801DB_11:
-		case PCI_DEVICE_ID_INTEL_82801EB_11:
-		case PCI_DEVICE_ID_INTEL_82801E_11:
-		case PCI_DEVICE_ID_INTEL_ESB_2:
-		case PCI_DEVICE_ID_INTEL_ICH6_19:
-		case PCI_DEVICE_ID_INTEL_ICH7_21:
-		case PCI_DEVICE_ID_INTEL_ESB2_18:
-		case PCI_DEVICE_ID_INTEL_ICH8_6:
-			return 1;
-	}
-
-	return 0;
-}
-
-/**
- *	init_chipset_piix	-	set up the PIIX chipset
+ *	init_chipset_ich	-	set up the ICH chipset
  *	@dev: PCI device to set up
  *	@name: Name of the device
  *
- *	Initialize the PCI device as required. For the PIIX this turns
- *	out to be nice and simple
+ *	Initialize the PCI device as required.  For the ICH this turns
+ *	out to be nice and simple.
  */
 
-static unsigned int __devinit init_chipset_piix (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_ich(struct pci_dev *dev, const char *name)
 {
-	if (piix_is_ichx(dev)) {
-		unsigned int extra = 0;
-		pci_read_config_dword(dev, 0x54, &extra);
-		pci_write_config_dword(dev, 0x54, extra|0x400);
-	}
+	u32 extra = 0;
+
+	pci_read_config_dword(dev, 0x54, &extra);
+	pci_write_config_dword(dev, 0x54, extra | 0x400);
 
 	return 0;
 }
@@ -318,9 +285,9 @@ static void piix_dma_clear_irq(ide_drive_t *drive)
 	u8 dma_stat;
 
 	/* clear the INTR & ERROR bits */
-	dma_stat = hwif->INB(hwif->dma_status);
+	dma_stat = inb(hwif->dma_status);
 	/* Should we force the bit as well ? */
-	hwif->OUTB(dma_stat, hwif->dma_status);
+	outb(dma_stat, hwif->dma_status);
 }
 
 struct ich_laptop {
@@ -374,35 +341,12 @@ static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 {
-#ifndef CONFIG_IA64
-	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
-#endif /* CONFIG_IA64 */
-
-	if (hwif->pci_dev->device == PCI_DEVICE_ID_INTEL_82371MX) {
-		/* This is a painful system best to let it self tune for now */
-		return;
-	}
-
 	hwif->set_pio_mode = &piix_set_pio_mode;
 	hwif->set_dma_mode = &piix_set_dma_mode;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
-	/* ICHx need to clear the bmdma status for all interrupts */
-	if (piix_is_ichx(hwif->pci_dev))
-		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
-
-	hwif->atapi_dma = 1;
-
-	hwif->ultra_mask = hwif->cds->udma_mask;
-	hwif->mwdma_mask = 0x06;
-	hwif->swdma_mask = 0x04;
-
 	if (hwif->ultra_mask & 0x78) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = piix_cable_detect(hwif);
@@ -412,21 +356,49 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
 
+static void __devinit init_hwif_ich(ide_hwif_t *hwif)
+{
+	init_hwif_piix(hwif);
+
+	/* ICHx need to clear the BMDMA status for all interrupts */
+	if (hwif->dma_base)
+		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
+}
+
+#ifndef CONFIG_IA64
+ #define IDE_HFLAGS_PIIX (IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE)
+#else
+ #define IDE_HFLAGS_PIIX IDE_HFLAG_BOOTABLE
+#endif
+
 #define DECLARE_PIIX_DEV(name_str, udma) \
 	{						\
 		.name		= name_str,		\
-		.init_chipset	= init_chipset_piix,	\
 		.init_hwif	= init_hwif_piix,	\
-		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
-		.bootable	= ON_BOARD,		\
+		.host_flags	= IDE_HFLAGS_PIIX,	\
 		.pio_mask	= ATA_PIO4,		\
+		.swdma_mask	= ATA_SWDMA2_ONLY,	\
+		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
 		.udma_mask	= udma,			\
 	}
 
+#define DECLARE_ICH_DEV(name_str, udma) \
+	{ \
+		.name		= name_str, \
+		.init_chipset	= init_chipset_ich, \
+		.init_hwif	= init_hwif_ich, \
+		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
+		.host_flags	= IDE_HFLAGS_PIIX, \
+		.pio_mask	= ATA_PIO4, \
+		.swdma_mask	= ATA_SWDMA2_ONLY, \
+		.mwdma_mask	= ATA_MWDMA12_ONLY, \
+		.udma_mask	= udma, \
+	}
+
 static ide_pci_device_t piix_pci_info[] __devinitdata = {
-	/*  0 */ DECLARE_PIIX_DEV("PIIXa", 0x00),	/* no udma */
-	/*  1 */ DECLARE_PIIX_DEV("PIIXb", 0x00),	/* no udma */
+	/*  0 */ DECLARE_PIIX_DEV("PIIXa",	0x00),	/* no udma */
+	/*  1 */ DECLARE_PIIX_DEV("PIIXb",	0x00),	/* no udma */
 
 	/*  2 */
 	{	/*
@@ -435,36 +407,35 @@ static ide_pci_device_t piix_pci_info[] __devinitdata = {
 		 * of the bit 14 of the IDETIM register at offset 0x6c
 		 */
 		.name		= "MPIIX",
-		.init_hwif	= init_hwif_piix,
-		.autodma	= NODMA,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_ISA_PORTS,
+		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA |
+				  IDE_HFLAGS_PIIX,
 		.pio_mask	= ATA_PIO4,
+		/* This is a painful system best to let it self tune for now */
 	},
 
-	/*  3 */ DECLARE_PIIX_DEV("PIIX3", 0x00),	/* no udma */
-	/*  4 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
-	/*  5 */ DECLARE_PIIX_DEV("ICH0",  0x07),	/* udma0-2 */
-	/*  6 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
-	/*  7 */ DECLARE_PIIX_DEV("ICH",   0x1f),	/* udma0-4 */
-	/*  8 */ DECLARE_PIIX_DEV("PIIX4", 0x1f),	/* udma0-4 */
-	/*  9 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
-	/* 10 */ DECLARE_PIIX_DEV("ICH2",  0x3f),	/* udma0-5 */
-	/* 11 */ DECLARE_PIIX_DEV("ICH2M", 0x3f),	/* udma0-5 */
-	/* 12 */ DECLARE_PIIX_DEV("ICH3M", 0x3f),	/* udma0-5 */
-	/* 13 */ DECLARE_PIIX_DEV("ICH3",  0x3f),	/* udma0-5 */
-	/* 14 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
-	/* 15 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
-	/* 16 */ DECLARE_PIIX_DEV("C-ICH", 0x3f),	/* udma0-5 */
-	/* 17 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
-	/* 18 */ DECLARE_PIIX_DEV("ICH5-SATA", 0x3f),	/* udma0-5 */
-	/* 19 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
-	/* 20 */ DECLARE_PIIX_DEV("ICH6",  0x3f),	/* udma0-5 */
-	/* 21 */ DECLARE_PIIX_DEV("ICH7",  0x3f),	/* udma0-5 */
-	/* 22 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
-	/* 23 */ DECLARE_PIIX_DEV("ESB2",  0x3f),	/* udma0-5 */
-	/* 24 */ DECLARE_PIIX_DEV("ICH8M", 0x3f),	/* udma0-5 */
+	/*  3 */ DECLARE_PIIX_DEV("PIIX3",	0x00),	/* no udma */
+	/*  4 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
+	/*  5 */ DECLARE_ICH_DEV("ICH0",	ATA_UDMA2),
+	/*  6 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
+	/*  7 */ DECLARE_ICH_DEV("ICH",		ATA_UDMA4),
+	/*  8 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA4),
+	/*  9 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
+	/* 10 */ DECLARE_ICH_DEV("ICH2",	ATA_UDMA5),
+	/* 11 */ DECLARE_ICH_DEV("ICH2M",	ATA_UDMA5),
+	/* 12 */ DECLARE_ICH_DEV("ICH3M",	ATA_UDMA5),
+	/* 13 */ DECLARE_ICH_DEV("ICH3",	ATA_UDMA5),
+	/* 14 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
+	/* 15 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
+	/* 16 */ DECLARE_ICH_DEV("C-ICH",	ATA_UDMA5),
+	/* 17 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
+	/* 18 */ DECLARE_ICH_DEV("ICH5-SATA",	ATA_UDMA5),
+	/* 19 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
+	/* 20 */ DECLARE_ICH_DEV("ICH6",	ATA_UDMA5),
+	/* 21 */ DECLARE_ICH_DEV("ICH7",	ATA_UDMA5),
+	/* 22 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
+	/* 23 */ DECLARE_ICH_DEV("ESB2",	ATA_UDMA5),
+	/* 24 */ DECLARE_ICH_DEV("ICH8M",	ATA_UDMA5),
 };
 
 /**
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 3f506e8..dd2583e 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -52,8 +52,7 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 static ide_pci_device_t rz1000_chipset __devinitdata = {
 	.name		= "RZ100x",
 	.init_hwif	= init_hwif_rz1000,
-	.autodma	= NODMA,
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_NO_DMA | IDE_HFLAG_BOOTABLE,
 };
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 54c5c98..b2423e0 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -362,33 +362,26 @@ static int sc1200_resume (struct pci_dev *dev)
  */
 static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 {
-	if (hwif->mate)
-		hwif->serialized = hwif->mate->serialized = 1;
-
 	hwif->set_pio_mode = &sc1200_set_pio_mode;
 	hwif->set_dma_mode = &sc1200_set_dma_mode;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->udma_filter = sc1200_udma_filter;
 	hwif->ide_dma_end   = &sc1200_ide_dma_end;
-
-        hwif->atapi_dma = 1;
-        hwif->ultra_mask = 0x07;
-        hwif->mwdma_mask = 0x07;
 }
 
 static ide_pci_device_t sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
 	.init_hwif	= init_hwif_sc1200,
-	.autodma	= AUTODMA,
-	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_ABUSE_DMA_MODES | IDE_HFLAG_POST_SET_MODE,
+	.host_flags	= IDE_HFLAG_SERIALIZE |
+			  IDE_HFLAG_POST_SET_MODE |
+			  IDE_HFLAG_ABUSE_DMA_MODES |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA2,
 };
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index bd4c1d3..ae9b503 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -472,7 +472,7 @@ static u8 scc_udma_filter(ide_drive_t *drive)
 	if ((drive->media != ide_disk) && (mask & 0xE0)) {
 		printk(KERN_INFO "%s: limit %s to UDMA4\n",
 		       SCC_PATA_NAME, drive->name);
-		mask = 0x1F;
+		mask = ATA_UDMA4;
 	}
 
 	return mask;
@@ -683,17 +683,10 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
 	hwif->udma_filter = scc_udma_filter;
 
-	hwif->drives[0].autotune = IDE_TUNE_AUTO;
-	hwif->drives[1].autotune = IDE_TUNE_AUTO;
-
-	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN) {
-		hwif->ultra_mask = 0x7f; /* 133MHz */
-	} else {
-		hwif->ultra_mask = 0x3f; /* 100MHz */
-	}
-	hwif->mwdma_mask = 0x00;
-	hwif->swdma_mask = 0x00;
-	hwif->atapi_dma = 1;
+	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN)
+		hwif->ultra_mask = ATA_UDMA6; /* 133MHz */
+	else
+		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 
 	/* we support 80c cable only. */
 	hwif->cbl = ATA_CBL_PATA80;
@@ -702,12 +695,10 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 #define DECLARE_SCC_DEV(name_str)			\
   {							\
       .name		= name_str,			\
-      .init_setup	= init_setup_scc,		\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
-      .autodma	= AUTODMA,				\
-      .bootable	= ON_BOARD,				\
-      .host_flags	= IDE_HFLAG_SINGLE,		\
+      .host_flags	= IDE_HFLAG_SINGLE |		\
+			  IDE_HFLAG_BOOTABLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
 
@@ -727,7 +718,8 @@ static ide_pci_device_t scc_chipsets[] __devinitdata = {
 static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	ide_pci_device_t *d = &scc_chipsets[id->driver_data];
-	return d->init_setup(dev, d);
+
+	return init_setup_scc(dev, d);
 }
 
 /**
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index d3ffc52..a3d880e 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -360,23 +360,10 @@ static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 {
-	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
-
 	hwif->set_pio_mode = &svwks_set_pio_mode;
 	hwif->set_dma_mode = &svwks_set_dma_mode;
 	hwif->udma_filter = &svwks_udma_filter;
 
-	hwif->atapi_dma = 1;
-
-	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE)
-		hwif->ultra_mask = 0x3f;
-
-	hwif->mwdma_mask = 0x07;
-
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -386,72 +373,49 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	}
 }
 
-static int __devinit init_setup_svwks (struct pci_dev *dev, ide_pci_device_t *d)
-{
-	return ide_setup_pci_device(dev, d);
-}
-
-static int __devinit init_setup_csb6 (struct pci_dev *dev, ide_pci_device_t *d)
-{
-	if (!(PCI_FUNC(dev->devfn) & 1)) {
-		d->bootable = NEVER_BOARD;
-		if (dev->resource[0].start == 0x01f1)
-			d->bootable = ON_BOARD;
-	}
-
-	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE ||
-	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2) &&
-	    (!(PCI_FUNC(dev->devfn) & 1)))
-		d->host_flags |= IDE_HFLAG_SINGLE;
-	else
-		d->host_flags &= ~IDE_HFLAG_SINGLE;
-
-	return ide_setup_pci_device(dev, d);
-}
-
 static ide_pci_device_t serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "SvrWks OSB4",
-		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
 	},{	/* 1 */
 		.name		= "SvrWks CSB5",
-		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	},{	/* 2 */
 		.name		= "SvrWks CSB6",
-		.init_setup	= init_setup_csb6,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	},{	/* 3 */
 		.name		= "SvrWks CSB6",
-		.init_setup	= init_setup_csb6,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_SINGLE |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	},{	/* 4 */
 		.name		= "SvrWks HT1000",
-		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_SINGLE |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 	}
 };
 
@@ -466,9 +430,21 @@ static ide_pci_device_t serverworks_chipsets[] __devinitdata = {
  
 static int __devinit svwks_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &serverworks_chipsets[id->driver_data];
+	ide_pci_device_t d;
+	u8 idx = id->driver_data;
+
+	d = serverworks_chipsets[idx];
+
+	if (idx == 2 || idx == 3) {
+		if ((PCI_FUNC(dev->devfn) & 1) == 0) {
+			if (pci_resource_start(dev, 0) != 0x01f1)
+				d.host_flags &= ~IDE_HFLAG_BOOTABLE;
+			d.host_flags |= IDE_HFLAG_SINGLE;
+		} else
+			d.host_flags &= ~IDE_HFLAG_SINGLE;
+	}
 
-	return d->init_setup(dev, d);
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id svwks_pci_tbl[] = {
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 9a9474f..5af74ea 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -592,8 +592,7 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->mwdma_mask = 0x04;
+	hwif->mwdma_mask = ATA_MWDMA2_ONLY;
 
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
@@ -692,14 +691,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 static unsigned int __devinit
 pci_init_sgiioc4(struct pci_dev *dev)
 {
-	unsigned int class_rev;
 	int ret;
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
 	printk(KERN_INFO "%s: IDE controller at PCI slot %s, revision %d\n",
-			 DRV_NAME, pci_name(dev), class_rev);
-	if (class_rev < IOC4_SUPPORTED_FIRMWARE_REV) {
+			 DRV_NAME, pci_name(dev), dev->revision);
+
+	if (dev->revision < IOC4_SUPPORTED_FIRMWARE_REV) {
 		printk(KERN_ERR "Skipping %s IDE controller in slot %s: "
 				"firmware is obsolete - please upgrade to "
 				"revision46 or higher\n",
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 85d0afd..689786d 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.16	Jul 13 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.17	Oct 18 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -180,7 +180,7 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
-	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
+	ide_drive_t *pair	= ide_get_paired_drive(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
@@ -640,13 +640,9 @@ static unsigned int setup_mmio_siimage (struct pci_dev *dev, const char *name)
 
 static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev, const char *name)
 {
-	u32 class_rev	= 0;
-	u8 tmpbyte	= 0;
-	u8 BA5_EN	= 0;
+	u8 rev = dev->revision, tmpbyte = 0, BA5_EN = 0;
 
-        pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-        class_rev &= 0xff;
-	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (class_rev) ? 1 : 255);	
+	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
 
 	pci_read_config_byte(dev, 0x8A, &BA5_EN);
 	if ((BA5_EN & 0x01) || (pci_resource_start(dev, 5))) {
@@ -825,19 +821,14 @@ static void __devinit siimage_fixup(ide_hwif_t *hwif)
 
 static void __devinit init_iops_siimage(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= hwif->pci_dev;
-	u32 class_rev		= 0;
-
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
-	
 	hwif->hwif_data = NULL;
 
 	/* Pessimal until we finish probing */
 	hwif->rqsize = 15;
 
-	if (pci_get_drvdata(dev) == NULL)
+	if (pci_get_drvdata(hwif->pci_dev) == NULL)
 		return;
+
 	init_mmio_iops_siimage(hwif);
 }
 
@@ -891,16 +882,11 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		}
 	}
 
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
-
-	if (!is_sata(hwif))
-		hwif->atapi_dma = 1;
+	if (is_sata(hwif))
+		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_siimage(hwif);
@@ -919,9 +905,10 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		.init_iops	= init_iops_siimage,	\
 		.init_hwif	= init_hwif_siimage,	\
 		.fixup		= siimage_fixup,	\
-		.autodma	= AUTODMA,		\
-		.bootable	= ON_BOARD,		\
+		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
+		.mwdma_mask	= ATA_MWDMA2,		\
+		.udma_mask	= ATA_UDMA6,		\
 	}
 
 static ide_pci_device_t siimage_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 5a54e2e..c1d280b 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -564,25 +564,16 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 {
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
 
-	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
-
 	hwif->set_pio_mode = &sis_set_pio_mode;
 	hwif->set_dma_mode = &sis_set_dma_mode;
 
 	if (chipset_family >= ATA_133)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-
 	hwif->ultra_mask = udma_rates[chipset_family];
-	hwif->mwdma_mask = 0x07;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_sis5513(hwif);
@@ -592,10 +583,11 @@ static ide_pci_device_t sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
-	.autodma	= NOAUTODMA,
 	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA |
+			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
 };
 
 static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 771efb8..0dce459 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -368,12 +368,6 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	hwif->drives[0].io_32bit = hwif->drives[1].io_32bit = 1;
 	hwif->drives[0].unmask   = hwif->drives[1].unmask   = 1;
 
-	/*
-	 * We always autotune PIO,  this is done before DMA is checked,
-	 * so there's no risk of accidentally disabling DMA
-	 */
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -388,8 +382,7 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->atapi_dma  = 1;
-	hwif->mwdma_mask = 0x07;
+	hwif->mwdma_mask = ATA_MWDMA2;
 
 	hwif->ide_dma_on		= &sl82c105_ide_dma_on;
 	hwif->dma_off_quietly		= &sl82c105_dma_off_quietly;
@@ -405,9 +398,8 @@ static ide_pci_device_t sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
 	.init_hwif	= init_hwif_sl82c105,
-	.autodma	= NOAUTODMA,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_NO_AUTODMA | IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
 };
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index fa8df6d..4f22dff 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -133,25 +133,14 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 	u8 reg47 = 0;
 	u8 mask = hwif->channel ? 0x01 : 0x02;  /* bit0:Primary */
 
-	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
-
 	hwif->set_pio_mode = &slc90e66_set_pio_mode;
 	hwif->set_dma_mode = &slc90e66_set_dma_mode;
 
 	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
 
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
-
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x1f;
-	hwif->mwdma_mask = 0x06;
-	hwif->swdma_mask = 0x04;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		/* bit[0(1)]: 0:80, 1:40 */
 		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
@@ -160,10 +149,12 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 static ide_pci_device_t slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
-	.autodma	= AUTODMA,
 	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.swdma_mask	= ATA_SWDMA2_ONLY,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
+	.udma_mask	= ATA_UDMA4,
 };
 
 static int __devinit slc90e66_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index de62db5..631506e 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -1,5 +1,5 @@
 /*
- * drivers/ide/pci/tc86c001.c	Version 1.00	Dec 12, 2006
+ * drivers/ide/pci/tc86c001.c	Version 1.01	Sep 5, 2007
  *
  * Copyright (C) 2002 Toshiba Corporation
  * Copyright (C) 2005-2006 MontaVista Software, Inc. <source@mvista.com>
@@ -17,7 +17,7 @@ static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
-	u16 mode, scr		= hwif->INW(scr_port);
+	u16 mode, scr		= inw(scr_port);
 
 	switch (speed) {
 		case XFER_UDMA_4:	mode = 0x00c0; break;
@@ -65,7 +65,7 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_status);
 
 	/* Restore a higher level driver's expiry handler first. */
 	hwgroup->expiry	= expiry;
@@ -73,7 +73,7 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 	if ((dma_stat & 5) == 1) {	/* DMA active and no interrupt */
 		unsigned long sc_base	= hwif->config_data;
 		unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-		u8 dma_cmd		= hwif->INB(hwif->dma_command);
+		u8 dma_cmd		= inb(hwif->dma_command);
 
 		printk(KERN_WARNING "%s: DMA interrupt possibly stuck, "
 		       "attempting recovery...\n", drive->name);
@@ -135,7 +135,7 @@ static int tc86c001_busproc(ide_drive_t *drive, int state)
 	u16 scr1;
 
 	/* System Control 1 Register bit 11 (ATA Hard Reset) read */
-	scr1 = hwif->INW(sc_base + 0x00);
+	scr1 = inw(sc_base + 0x00);
 
 	switch (state) {
 		case BUSSTATE_ON:
@@ -165,7 +165,7 @@ static int tc86c001_busproc(ide_drive_t *drive, int state)
 static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 {
 	unsigned long sc_base	= pci_resource_start(hwif->pci_dev, 5);
-	u16 scr1		= hwif->INW(sc_base + 0x00);;
+	u16 scr1		= inw(sc_base + 0x00);
 
 	/* System Control 1 Register bit 15 (Soft Reset) set */
 	outw(scr1 |  0x8000, sc_base + 0x00);
@@ -184,8 +184,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 
 	hwif->busproc	= &tc86c001_busproc;
 
-	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
-
 	if (!hwif->dma_base)
 		return;
 
@@ -198,10 +196,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	/* Sector Count Register limit */
 	hwif->rqsize	 = 0xffff;
 
-	hwif->atapi_dma  = 1;
-	hwif->ultra_mask = 0x1f;
-	hwif->mwdma_mask = 0x07;
-
 	hwif->dma_start 	= &tc86c001_dma_start;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
@@ -209,7 +203,7 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 		 * System Control  1 Register bit 13 (PDIAGN):
 		 * 0=80-pin cable, 1=40-pin cable
 		 */
-		scr1 = hwif->INW(sc_base + 0x00);
+		scr1 = inw(sc_base + 0x00);
 		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
 }
@@ -228,10 +222,10 @@ static ide_pci_device_t tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
-	.autodma	= AUTODMA,
-	.bootable	= OFF_BOARD,
-	.host_flags	= IDE_HFLAG_SINGLE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD,
 	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA4,
 };
 
 static int __devinit tc86c001_init_one(struct pci_dev *dev,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 4075c90..30b52f6 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -100,22 +100,16 @@ static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 {
 	hwif->set_pio_mode = &triflex_set_pio_mode;
 	hwif->set_dma_mode = &triflex_set_mode;
-
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->atapi_dma  = 1;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 }
 
 static ide_pci_device_t triflex_device __devinitdata = {
 	.name		= "TRIFLEX",
 	.init_hwif	= init_hwif_triflex,
-	.autodma	= AUTODMA,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
+	.swdma_mask	= ATA_SWDMA2,
+	.mwdma_mask	= ATA_MWDMA2,
 };
 
 static int __devinit triflex_init_one(struct pci_dev *dev, 
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index e3d943a..140d486 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -250,7 +250,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	u8 reg = 0;
 	struct pci_dev *dev = hwif->pci_dev;
 
-	hwif->no_lba48 = 1;
 	hwif->chipset = ide_trm290;
 	cfgbase = pci_resource_start(dev, 4);
 	if ((dev->class & 5) && cfgbase) {
@@ -324,11 +323,13 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 static ide_pci_device_t trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
-	.autodma	= NOAUTODMA,
-	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
-	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 #endif
+			  IDE_HFLAG_NO_AUTODMA |
+			  IDE_HFLAG_BOOTABLE |
+			  IDE_HFLAG_NO_LBA48,
 };
 
 static int __devinit trm290_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index b25fb65..c8022a9 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -437,17 +437,12 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 	for (i = 0; i < 2; i++) {
 		hwif->drives[i].io_32bit = 1;
 		hwif->drives[i].unmask = (vdev->via_config->flags & VIA_NO_UNMASK) ? 0 : 1;
-		hwif->drives[i].autotune = 1;
 	}
 
 	if (!hwif->dma_base)
 		return;
 
-	hwif->atapi_dma = 1;
-
 	hwif->ultra_mask = vdev->via_config->udma_mask;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = via82cxxx_cable_detect(hwif);
@@ -458,24 +453,27 @@ static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
 		.name		= "VP_IDE",
 		.init_chipset	= init_chipset_via82cxxx,
 		.init_hwif	= init_hwif_via82cxxx,
-		.autodma	= NOAUTODMA,
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
-				| IDE_HFLAG_PIO_NO_DOWNGRADE
-				| IDE_HFLAG_POST_SET_MODE,
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |
+				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_NO_AUTODMA |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
 		.name		= "VP_IDE",
 		.init_chipset	= init_chipset_via82cxxx,
 		.init_hwif	= init_hwif_via82cxxx,
-		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x00,0x00,0x00}},
-		.bootable	= ON_BOARD,
-		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
-				| IDE_HFLAG_PIO_NO_DOWNGRADE
-				| IDE_HFLAG_POST_SET_MODE,
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |
+				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
+		.swdma_mask	= ATA_SWDMA2,
+		.mwdma_mask	= ATA_MWDMA2,
 	}
 };
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 1d25a34..c554793 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1780,7 +1780,6 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->dma_timeout = &ide_dma_timeout;
 	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
 
-	hwif->atapi_dma = 1;
 	switch(pmif->kind) {
 		case controller_sh_ata6:
 			hwif->ultra_mask = pmif->cable_80 ? 0x7f : 0x07;
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 3d101f7..fff567b 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -147,6 +147,7 @@ static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_get_or_set_dma_base		-	setup BMIBA
+ *	@d: IDE pci device data
  *	@hwif: Interface
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
@@ -154,7 +155,7 @@ static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
  *	and enforce IDE simplex rules.
  */
 
-static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
+static unsigned long ide_get_or_set_dma_base(ide_pci_device_t *d, ide_hwif_t *hwif)
 {
 	unsigned long	dma_base = 0;
 	struct pci_dev	*dev = hwif->pci_dev;
@@ -165,14 +166,15 @@ static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
 	if (hwif->mate && hwif->mate->dma_base) {
 		dma_base = hwif->mate->dma_base - (hwif->channel ? 0 : 8);
 	} else {
-		dma_base = pci_resource_start(dev, 4);
-		if (!dma_base) {
-			printk(KERN_ERR "%s: dma_base is invalid\n",
-					hwif->cds->name);
-		}
+		u8 baridx = (d->host_flags & IDE_HFLAG_CS5520) ? 2 : 4;
+
+		dma_base = pci_resource_start(dev, baridx);
+
+		if (dma_base == 0)
+			printk(KERN_ERR "%s: DMA base is invalid\n", d->name);
 	}
 
-	if (dma_base) {
+	if ((d->host_flags & IDE_HFLAG_CS5520) == 0 && dma_base) {
 		u8 simplex_stat = 0;
 		dma_base += hwif->channel ? 8 : 0;
 
@@ -183,13 +185,13 @@ static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
 			case PCI_DEVICE_ID_CMD_643:
 			case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
 			case PCI_DEVICE_ID_REVOLUTION:
-				simplex_stat = hwif->INB(dma_base + 2);
-				hwif->OUTB((simplex_stat&0x60),(dma_base + 2));
-				simplex_stat = hwif->INB(dma_base + 2);
+				simplex_stat = inb(dma_base + 2);
+				outb(simplex_stat & 0x60, dma_base + 2);
+				simplex_stat = inb(dma_base + 2);
 				if (simplex_stat & 0x80) {
 					printk(KERN_INFO "%s: simplex device: "
-						"DMA forced\n",
-						hwif->cds->name);
+							 "DMA forced\n",
+							 d->name);
 				}
 				break;
 			default:
@@ -212,8 +214,8 @@ static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
  */
 					if (hwif->mate && hwif->mate->dma_base) {
 						printk(KERN_INFO "%s: simplex device: "
-							"DMA disabled\n",
-							hwif->cds->name);
+								 "DMA disabled\n",
+								 d->name);
 						dma_base = 0;
 					}
 				}
@@ -360,6 +362,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d,
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
+	u8 bootable = (d->host_flags & IDE_HFLAG_BOOTABLE) ? 1 : 0;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		/*  Possibly we should fail if these checks report true */
@@ -380,7 +383,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d,
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
 	}
-	if ((hwif = ide_match_hwif(base, d->bootable, d->name)) == NULL)
+	if ((hwif = ide_match_hwif(base, bootable, d->name)) == NULL)
 		return NULL;	/* no room in ide_hwifs[] */
 	if (hwif->io_ports[IDE_DATA_OFFSET] != base ||
 	    hwif->io_ports[IDE_CONTROL_OFFSET] != (ctl | 2)) {
@@ -427,12 +430,13 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
 static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwif_t *hwif)
 {
 	u16 pcicmd;
+
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 
-	if ((d->autodma == AUTODMA) ||
+	if ((d->host_flags & IDE_HFLAG_NO_AUTODMA) == 0 ||
 	    ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	     (dev->class & 0x80))) {
-		unsigned long dma_base = ide_get_or_set_dma_base(hwif);
+		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
 		if (dma_base && !(pcicmd & PCI_COMMAND_MASTER)) {
 			/*
  			 * Set up BM-DMA capability
@@ -474,7 +478,6 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
 static int ide_setup_pci_controller(struct pci_dev *dev, ide_pci_device_t *d, int noisy, int *config)
 {
 	int ret;
-	u32 class_rev;
 	u16 pcicmd;
 
 	if (noisy)
@@ -497,10 +500,9 @@ static int ide_setup_pci_controller(struct pci_dev *dev, ide_pci_device_t *d, in
 		printk(KERN_INFO "%s: device enabled (Linux)\n", d->name);
 	}
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
 	if (noisy)
-		printk(KERN_INFO "%s: chipset revision %d\n", d->name, class_rev);
+		printk(KERN_INFO "%s: chipset revision %d\n",
+				 d->name, dev->revision);
 out:
 	return ret;
 }
@@ -557,17 +559,27 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 		if (d->init_iops)
 			d->init_iops(hwif);
 
-		if (d->autodma == NODMA)
-			goto bypass_legacy_dma;
-
-		if(d->init_setup_dma)
-			d->init_setup_dma(dev, d, hwif);
-		else
+		if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
 			ide_hwif_setup_dma(dev, d, hwif);
-bypass_legacy_dma:
+
+		if ((d->host_flags & IDE_HFLAG_LEGACY_IRQS) && hwif->irq == 0)
+			hwif->irq = port ? 15 : 14;
+
 		hwif->host_flags = d->host_flags;
 		hwif->pio_mask = d->pio_mask;
 
+		if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
+
+		if (hwif->dma_base) {
+			hwif->swdma_mask = d->swdma_mask;
+			hwif->mwdma_mask = d->mwdma_mask;
+			hwif->ultra_mask = d->udma_mask;
+		}
+
+		hwif->drives[0].autotune = 1;
+		hwif->drives[1].autotune = 1;
+
 		if (d->init_hwif)
 			/* Call chipset-specific routine
 			 * for each enabled hwif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e39ee2f..19db0a4 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -685,7 +685,6 @@ typedef struct hwif_s {
 
 	u8 pio_mask;
 
-	u8 atapi_dma;	/* host supports atapi_dma */
 	u8 ultra_mask;
 	u8 mwdma_mask;
 	u8 swdma_mask;
@@ -797,12 +796,9 @@ typedef struct hwif_s {
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
-	unsigned	no_lba48   : 1; /* 1 = cannot do LBA48 */
-	unsigned	no_lba48_dma : 1; /* 1 = cannot do LBA48 DMA */
 	unsigned	auto_poll  : 1; /* supports nop auto-poll */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	no_io_32bit : 1; /* 1 = can not do 32-bit IO ops */
-	unsigned	err_stops_fifo : 1; /* 1=data FIFO is cleared by an error */
 	unsigned	mmio       : 1; /* host uses MMIO */
 
 	struct device	gendev;
@@ -1211,19 +1207,6 @@ extern void default_hwif_iops(ide_hwif_t *);
 extern void default_hwif_mmiops(ide_hwif_t *);
 extern void default_hwif_transport(ide_hwif_t *);
 
-#define ON_BOARD		1
-#define NEVER_BOARD		0
-
-#ifdef CONFIG_BLK_DEV_OFFBOARD
-#  define OFF_BOARD		ON_BOARD
-#else /* CONFIG_BLK_DEV_OFFBOARD */
-#  define OFF_BOARD		NEVER_BOARD
-#endif /* CONFIG_BLK_DEV_OFFBOARD */
-
-#define NODMA 0
-#define NOAUTODMA 1
-#define AUTODMA 2
-
 typedef struct ide_pci_enablebit_s {
 	u8	reg;	/* byte pci reg holding the enable-bit */
 	u8	mask;	/* mask to isolate the enable-bit */
@@ -1258,24 +1241,48 @@ enum {
 	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
 	/* host uses VDMA */
 	IDE_HFLAG_VDMA			= (1 << 11),
+	/* ATAPI DMA is unsupported */
+	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
+	/* set if host is a "bootable" controller */
+	IDE_HFLAG_BOOTABLE		= (1 << 13),
+	/* host doesn't support DMA */
+	IDE_HFLAG_NO_DMA		= (1 << 14),
+	/* check if host is PCI IDE device before allowing DMA */
+	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* host is CS5510/CS5520 */
+	IDE_HFLAG_CS5520		= (1 << 16),
+	/* no LBA48 */
+	IDE_HFLAG_NO_LBA48		= (1 << 17),
+	/* no LBA48 DMA */
+	IDE_HFLAG_NO_LBA48_DMA		= (1 << 18),
+	/* data FIFO is cleared by an error */
+	IDE_HFLAG_ERROR_STOPS_FIFO	= (1 << 19),
+	/* serialize ports */
+	IDE_HFLAG_SERIALIZE		= (1 << 20),
+	/* use legacy IRQs */
+	IDE_HFLAG_LEGACY_IRQS		= (1 << 21),
 };
 
+#ifdef CONFIG_BLK_DEV_OFFBOARD
+# define IDE_HFLAG_OFF_BOARD	IDE_HFLAG_BOOTABLE
+#else
+# define IDE_HFLAG_OFF_BOARD	0
+#endif
+
 typedef struct ide_pci_device_s {
 	char			*name;
-	int			(*init_setup)(struct pci_dev *, struct ide_pci_device_s *);
-	void			(*init_setup_dma)(struct pci_dev *, struct ide_pci_device_s *, ide_hwif_t *);
 	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	void			(*init_dma)(ide_hwif_t *, unsigned long);
 	void			(*fixup)(ide_hwif_t *);
-	u8			autodma;
 	ide_pci_enablebit_t	enablebits[2];
-	u8			bootable;
 	unsigned int		extra;
 	struct ide_pci_device_s	*next;
-	u16			host_flags;
+	u32			host_flags;
 	u8			pio_mask;
+	u8			swdma_mask;
+	u8			mwdma_mask;
 	u8			udma_mask;
 } ide_pci_device_t;
 
@@ -1454,4 +1461,11 @@ static inline int hwif_to_node(ide_hwif_t *hwif)
 	return dev ? pcibus_to_node(dev->bus) : -1;
 }
 
+static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+
+	return &hwif->drives[(drive->dn ^ 1) & 1];
+}
+
 #endif /* _IDE_H */
