Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXGIVb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXGIVb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXGIVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:31:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:57555 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXGIVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=CU4mWoc4CVLsgz/LB3g9JNclF4LX/2wdTS+Wo4Z2nIHzWn0TaxAPpJ2IbMMgRCAhxAujThUJYtqkwaNuTVcH7bzAW6I0VdH7JWQ6Wd52GGevQNL/LjwLnoEGwxzn/lwqnFWUQ92jwLoMzM09ZbRD2bvhM9ugFjP3cW4L41RgcB0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE update
Date: Mon, 9 Jul 2007 23:46:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707092346.22505.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


First IDE update for 2.6.23 merge window:

* Fixups/cleanups all over the place (detailed changelog somewhere below).

  Thanks to all contributors!

* Support for short 40-wire cables.

  If your laptop's disk was limited to UDMA33 because of failed cable
  detection there is good chance that this update fixes the issue.

  If it still doesn't please report it.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/arm/icside.c                  |   16 +--
 drivers/ide/cris/ide-cris.c               |    2 +-
 drivers/ide/ide-cd.c                      |    6 +-
 drivers/ide/ide-cd.h                      |    2 -
 drivers/ide/ide-disk.c                    |    8 +-
 drivers/ide/ide-dma.c                     |  110 ++++++++++--------
 drivers/ide/ide-io.c                      |    4 +-
 drivers/ide/ide-iops.c                    |    8 +-
 drivers/ide/ide-probe.c                   |   10 +-
 drivers/ide/ide-proc.c                    |   34 +++---
 drivers/ide/ide-timing.h                  |   56 +---------
 drivers/ide/ide.c                         |   33 +++---
 drivers/ide/legacy/hd.c                   |    2 +-
 drivers/ide/legacy/macide.c               |   14 ---
 drivers/ide/mips/au1xxx-ide.c             |   24 ++---
 drivers/ide/pci/aec62xx.c                 |  119 ++++++-------------
 drivers/ide/pci/alim15x3.c                |   78 +++++++++-----
 drivers/ide/pci/amd74xx.c                 |  127 ++++++++++-----------
 drivers/ide/pci/atiixp.c                  |    5 +-
 drivers/ide/pci/cmd64x.c                  |  130 ++++++++--------------
 drivers/ide/pci/cs5535.c                  |    6 +-
 drivers/ide/pci/hpt366.c                  |  170 +++++++++++++++-------------
 drivers/ide/pci/it8213.c                  |    8 +-
 drivers/ide/pci/it821x.c                  |    9 +-
 drivers/ide/pci/jmicron.c                 |   20 ++--
 drivers/ide/pci/pdc202xx_new.c            |    9 +-
 drivers/ide/pci/pdc202xx_old.c            |   35 ++++--
 drivers/ide/pci/piix.c                    |   45 ++++++-
 drivers/ide/pci/scc_pata.c                |    2 +-
 drivers/ide/pci/serverworks.c             |  103 +++---------------
 drivers/ide/pci/sgiioc4.c                 |   20 ++--
 drivers/ide/pci/siimage.c                 |   18 ++--
 drivers/ide/pci/sis5513.c                 |   34 +++++-
 drivers/ide/pci/sl82c105.c                |   20 +--
 drivers/ide/pci/slc90e66.c                |    5 +-
 drivers/ide/pci/tc86c001.c                |    4 +-
 drivers/ide/pci/via82cxxx.c               |  175 +++++++++++++++++------------
 drivers/ide/ppc/pmac.c                    |   42 ++-----
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   28 +++---
 include/linux/ide.h                       |   18 ++--
 40 files changed, 733 insertions(+), 826 deletions(-)


Adrian Bunk (1):
      drivers/ide/ide-dma.c: unexport ide_set_dma

Andi Drebes (1):
      drivers/ide/legacy/hd.c: Array size calculation using sizeof replaced with ARRAY_SIZE

Bartlomiej Zolnierkiewicz (8):
      serverworks: always tune CSB6
      ide: fix pre-EIDE SWDMA support
      ide: convert ide_find_best_mode() users to use ide_max_dma_mode()
      ide: add short cables support
      piix: backport short cables support from ata_piix.c
      alim15x3: backport short cables support from pata_ali.c
      sis5513: backport short cables support from pata_sis.c
      via82cxxx: backport short cables support from pata_via.c

Junio C Hamano (3):
      ide_in_drive_list(): accept NULL as the wildcard for firmware revision
      mips au1xxx_ide.h: use NULL as firmware-revision wildcard
      ide_in_drive_list(): "ALL" is not a wildcard anymore

Matthias Kaehlcke (2):
      ide: use mutex instead of ide_cfg_sem semaphore in IDE driver
      ide: use mutex instead of ide_setting_sem semaphore in IDE driver

Robert P. J. Day (3):
      ide-cd: replace C code with call to ARRAY_SIZE() macro
      ide: remove references to the non-existent CONFIG_SCSI_EATA_DMA
      ide: remove content related to dead CONFIG_BLK_DEV_MAC_MEDIABAY config variable

Sergei Shtylyov (7):
      ide: make void and rename ide_dma_lostirq() method
      ide: make void and rename ide_dma_timeout() method
      hpt366: simplify UltraDMA filtering (take 4)
      cmd64x: init. code cleanup
      aec62xx: rework init_setup_aec6x80()
      aec62xx: remove init_dma() method (take 2)
      aec62xx: kill speedproc() method wrapper (take 2)


diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 66f8262..444a0b8 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -448,23 +448,21 @@ static int icside_dma_test_irq(ide_drive_t *drive)
 			ICS_ARCIN_V6_INTRSTAT_1)) & 1;
 }
 
-static int icside_dma_timeout(ide_drive_t *drive)
+static void icside_dma_timeout(ide_drive_t *drive)
 {
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
 	if (icside_dma_test_irq(drive))
-		return 0;
+		return;
 
-	ide_dump_status(drive, "DMA timeout",
-		HWIF(drive)->INB(IDE_STATUS_REG));
+	ide_dump_status(drive, "DMA timeout", HWIF(drive)->INB(IDE_STATUS_REG));
 
-	return icside_dma_end(drive);
+	icside_dma_end(drive);
 }
 
-static int icside_dma_lostirq(ide_drive_t *drive)
+static void icside_dma_lost_irq(ide_drive_t *drive)
 {
 	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-	return 1;
 }
 
 static void icside_dma_init(ide_hwif_t *hwif)
@@ -490,8 +488,8 @@ static void icside_dma_init(ide_hwif_t *hwif)
 	hwif->dma_start		= icside_dma_start;
 	hwif->ide_dma_end	= icside_dma_end;
 	hwif->ide_dma_test_irq	= icside_dma_test_irq;
-	hwif->ide_dma_timeout	= icside_dma_timeout;
-	hwif->ide_dma_lostirq	= icside_dma_lostirq;
+	hwif->dma_timeout	= icside_dma_timeout;
+	hwif->dma_lost_irq	= icside_dma_lost_irq;
 
 	hwif->drives[0].autodma = hwif->autodma;
 	hwif->drives[1].autodma = hwif->autodma;
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index ca0341c..886091b 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -819,7 +819,7 @@ init_e100_ide (void)
 		hwif->dma_host_off = &cris_dma_off;
 		hwif->dma_host_on = &cris_dma_on;
 		hwif->dma_off_quietly = &cris_dma_off;
-		hwif->udma_four = 0;
+		hwif->cbl = ATA_CBL_PATA40;
 		hwif->ultra_mask = cris_ultra_mask;
 		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
 		hwif->autodma = 1;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 252ab82..1486eb2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -481,7 +481,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 		else
 			printk("  Unknown Error Type: ");
 
-		if (sense->sense_key < ARY_LEN(sense_key_texts))
+		if (sense->sense_key < ARRAY_SIZE(sense_key_texts))
 			s = sense_key_texts[sense->sense_key];
 
 		printk("%s -- (Sense key=0x%02x)\n", s, sense->sense_key);
@@ -491,7 +491,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				 sense->ascq);
 			s = buf;
 		} else {
-			int lo = 0, mid, hi = ARY_LEN(sense_data_texts);
+			int lo = 0, mid, hi = ARRAY_SIZE(sense_data_texts);
 			unsigned long key = (sense->sense_key << 16);
 			key |= (sense->asc << 8);
 			if (!(sense->ascq >= 0x80 && sense->ascq <= 0xdd))
@@ -524,7 +524,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 
 		if (failed_command != NULL) {
 
-			int lo=0, mid, hi= ARY_LEN (packet_command_texts);
+			int lo=0, mid, hi= ARRAY_SIZE(packet_command_texts);
 			s = NULL;
 
 			while (hi > lo) {
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index ad1f2ed..228b29c 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -498,8 +498,6 @@ struct cdrom_info {
  * Descriptions of ATAPI error codes.
  */
 
-#define ARY_LEN(a) ((sizeof(a) / sizeof(a[0])))
-
 /* This stuff should be in cdrom.h, since it is now generic... */
 
 /* ATAPI sense keys (from table 140 of ATAPI 2.6) */
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index dc2175c..b1304a7 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1190,11 +1190,11 @@ static int idedisk_ioctl(struct inode *inode, struct file *file,
 	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1204,9 +1204,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index ead141e..5fe1d72 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -91,45 +91,45 @@
 
 static const struct drive_list_entry drive_whitelist [] = {
 
-	{ "Micropolis 2112A"	,       "ALL"		},
-	{ "CONNER CTMA 4000"	,       "ALL"		},
-	{ "CONNER CTT8000-A"	,       "ALL"		},
-	{ "ST34342A"		,	"ALL"		},
+	{ "Micropolis 2112A"	,       NULL		},
+	{ "CONNER CTMA 4000"	,       NULL		},
+	{ "CONNER CTT8000-A"	,       NULL		},
+	{ "ST34342A"		,	NULL		},
 	{ NULL			,	NULL		}
 };
 
 static const struct drive_list_entry drive_blacklist [] = {
 
-	{ "WDC AC11000H"	,	"ALL"		},
-	{ "WDC AC22100H"	,	"ALL"		},
-	{ "WDC AC32500H"	,	"ALL"		},
-	{ "WDC AC33100H"	,	"ALL"		},
-	{ "WDC AC31600H"	,	"ALL"		},
+	{ "WDC AC11000H"	,	NULL 		},
+	{ "WDC AC22100H"	,	NULL 		},
+	{ "WDC AC32500H"	,	NULL 		},
+	{ "WDC AC33100H"	,	NULL 		},
+	{ "WDC AC31600H"	,	NULL 		},
 	{ "WDC AC32100H"	,	"24.09P07"	},
 	{ "WDC AC23200L"	,	"21.10N21"	},
-	{ "Compaq CRD-8241B"	,	"ALL"		},
-	{ "CRD-8400B"		,	"ALL"		},
-	{ "CRD-8480B",			"ALL"		},
-	{ "CRD-8482B",			"ALL"		},
- 	{ "CRD-84"		,	"ALL"		},
-	{ "SanDisk SDP3B"	,	"ALL"		},
-	{ "SanDisk SDP3B-64"	,	"ALL"		},
-	{ "SANYO CD-ROM CRD"	,	"ALL"		},
-	{ "HITACHI CDR-8"	,	"ALL"		},
-	{ "HITACHI CDR-8335"	,	"ALL"		},
-	{ "HITACHI CDR-8435"	,	"ALL"		},
-	{ "Toshiba CD-ROM XM-6202B"	,	"ALL"		},
-	{ "TOSHIBA CD-ROM XM-1702BC",	"ALL"		},
-	{ "CD-532E-A"		,	"ALL"		},
-	{ "E-IDE CD-ROM CR-840",	"ALL"		},
-	{ "CD-ROM Drive/F5A",	"ALL"		},
-	{ "WPI CDD-820",		"ALL"		},
-	{ "SAMSUNG CD-ROM SC-148C",	"ALL"		},
-	{ "SAMSUNG CD-ROM SC",	"ALL"		},
-	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
-	{ "_NEC DV5800A",               "ALL"           },  
+	{ "Compaq CRD-8241B"	,	NULL 		},
+	{ "CRD-8400B"		,	NULL 		},
+	{ "CRD-8480B",			NULL 		},
+	{ "CRD-8482B",			NULL 		},
+	{ "CRD-84"		,	NULL 		},
+	{ "SanDisk SDP3B"	,	NULL 		},
+	{ "SanDisk SDP3B-64"	,	NULL 		},
+	{ "SANYO CD-ROM CRD"	,	NULL 		},
+	{ "HITACHI CDR-8"	,	NULL 		},
+	{ "HITACHI CDR-8335"	,	NULL 		},
+	{ "HITACHI CDR-8435"	,	NULL 		},
+	{ "Toshiba CD-ROM XM-6202B"	,	NULL 		},
+	{ "TOSHIBA CD-ROM XM-1702BC",	NULL 		},
+	{ "CD-532E-A"		,	NULL 		},
+	{ "E-IDE CD-ROM CR-840",	NULL 		},
+	{ "CD-ROM Drive/F5A",	NULL 		},
+	{ "WPI CDD-820",		NULL 		},
+	{ "SAMSUNG CD-ROM SC-148C",	NULL 		},
+	{ "SAMSUNG CD-ROM SC",	NULL 		},
+	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	NULL 		},
+	{ "_NEC DV5800A",               NULL            },
 	{ "SAMSUNG CD-ROM SN-124",	"N001" },
-	{ "Seagate STT20000A",		"ALL" },
+	{ "Seagate STT20000A",		NULL  },
 	{ NULL			,	NULL		}
 
 };
@@ -147,8 +147,8 @@ int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *driv
 {
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    ((strstr(id->fw_rev, drive_table->id_firmware)) ||
-		     (!strcmp(drive_table->id_firmware, "ALL"))))
+		    (!drive_table->id_firmware ||
+		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
 }
@@ -702,8 +702,22 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
 			mask = id->dma_mword & hwif->mwdma_mask;
 		break;
 	case XFER_SW_DMA_0:
-		if (id->field_valid & 2)
+		if (id->field_valid & 2) {
 			mask = id->dma_1word & hwif->swdma_mask;
+		} else if (id->tDMA) {
+			/*
+			 * ide_fix_driveid() doesn't convert ->tDMA to the
+			 * CPU endianness so we need to do it here
+			 */
+			u8 mode = le16_to_cpu(id->tDMA);
+
+			/*
+			 * if the mode is valid convert it to the mask
+			 * (the maximum allowed mode is XFER_SW_DMA_2)
+			 */
+			if (mode <= 2)
+				mask = ((2 << mode) - 1) & hwif->swdma_mask;
+		}
 		break;
 	default:
 		BUG();
@@ -847,27 +861,27 @@ int ide_set_dma(ide_drive_t *drive)
 	return rc;
 }
 
-EXPORT_SYMBOL_GPL(ide_set_dma);
-
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-int __ide_dma_lostirq (ide_drive_t *drive)
+void ide_dma_lost_irq (ide_drive_t *drive)
 {
 	printk("%s: DMA interrupt recovery\n", drive->name);
-	return 1;
 }
 
-EXPORT_SYMBOL(__ide_dma_lostirq);
+EXPORT_SYMBOL(ide_dma_lost_irq);
 
-int __ide_dma_timeout (ide_drive_t *drive)
+void ide_dma_timeout (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = HWIF(drive);
+
 	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
-	if (HWIF(drive)->ide_dma_test_irq(drive))
-		return 0;
 
-	return HWIF(drive)->ide_dma_end(drive);
+	if (hwif->ide_dma_test_irq(drive))
+		return;
+
+	hwif->ide_dma_end(drive);
 }
 
-EXPORT_SYMBOL(__ide_dma_timeout);
+EXPORT_SYMBOL(ide_dma_timeout);
 
 /*
  * Needed for allowing full modular support of ide-driver
@@ -1018,10 +1032,10 @@ void ide_setup_dma (ide_hwif_t *hwif, unsigned long dma_base, unsigned int num_p
 		hwif->ide_dma_end = &__ide_dma_end;
 	if (!hwif->ide_dma_test_irq)
 		hwif->ide_dma_test_irq = &__ide_dma_test_irq;
-	if (!hwif->ide_dma_timeout)
-		hwif->ide_dma_timeout = &__ide_dma_timeout;
-	if (!hwif->ide_dma_lostirq)
-		hwif->ide_dma_lostirq = &__ide_dma_lostirq;
+	if (!hwif->dma_timeout)
+		hwif->dma_timeout = &ide_dma_timeout;
+	if (!hwif->dma_lost_irq)
+		hwif->dma_lost_irq = &ide_dma_lost_irq;
 
 	if (hwif->chipset != ide_trm290) {
 		u8 dma_stat = hwif->INB(hwif->dma_status);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index bfe8f1b..c5b5011 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1350,7 +1350,7 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 						hwif->INB(IDE_STATUS_REG));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		(void) hwif->ide_dma_timeout(drive);
+		hwif->dma_timeout(drive);
 	}
 
 	/*
@@ -1466,7 +1466,7 @@ void ide_timer_expiry (unsigned long data)
 				startstop = handler(drive);
 			} else if (drive_is_ready(drive)) {
 				if (drive->waiting_for_dma)
-					(void) hwgroup->hwif->ide_dma_lostirq(drive);
+					hwgroup->hwif->dma_lost_irq(drive);
 				(void)ide_ack_intr(hwif);
 				printk(KERN_WARNING "%s: lost interrupt\n", drive->name);
 				startstop = handler(drive);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index f0be5f6..92578b6 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -574,7 +574,10 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 
-	if (hwif->udma_four == 0)
+	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
+		return 1;
+
+	if (hwif->cbl != ATA_CBL_PATA80)
 		goto no_80w;
 
 	/* Check for SATA but only if we are ATA5 or higher */
@@ -600,7 +603,8 @@ no_80w:
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
 			    "limiting max speed to UDMA33\n",
-			    drive->name, hwif->udma_four ? "drive" : "host");
+			    drive->name,
+			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
 	drive->udma33_warned = 1;
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index f5ce22c..cc58013 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -144,7 +144,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	local_irq_enable();
 	ide_fix_driveid(id);
 
-#if defined (CONFIG_SCSI_EATA_DMA) || defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
+#if defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
 	/*
 	 * EATA SCSI controllers do a hardware ATA emulation:
 	 * Ignore them if there is a driver for them available.
@@ -154,7 +154,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
 		goto err_misc;
 	}
-#endif /* CONFIG_SCSI_EATA_DMA || CONFIG_SCSI_EATA_PIO */
+#endif /* CONFIG_SCSI_EATA || CONFIG_SCSI_EATA_PIO */
 
 	/*
 	 *  WIN_IDENTIFY returns little-endian info,
@@ -1025,7 +1025,7 @@ static int init_irq (ide_hwif_t *hwif)
 	BUG_ON(irqs_disabled());	
 	BUG_ON(hwif == NULL);
 
-	down(&ide_cfg_sem);
+	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
 #if MAX_HWIFS > 1
 	/*
@@ -1154,7 +1154,7 @@ static int init_irq (ide_hwif_t *hwif)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
 	printk("\n");
-	up(&ide_cfg_sem);
+	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_unlink:
 	spin_lock_irq(&ide_lock);
@@ -1177,7 +1177,7 @@ out_unlink:
 	}
 	spin_unlock_irq(&ide_lock);
 out_up:
-	up(&ide_cfg_sem);
+	mutex_unlock(&ide_cfg_mtx);
 	return 1;
 }
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index ea94c9a..fc1d8ae 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -156,7 +156,7 @@ static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int d
 {
 	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	while ((*p) && strcmp((*p)->name, name) < 0)
 		p = &((*p)->next);
 	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
@@ -177,10 +177,10 @@ static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int d
 	if (auto_remove)
 		setting->auto_remove = 1;
 	*p = setting;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return 0;
 abort:
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	kfree(setting);
 	return -1;
 }
@@ -224,7 +224,7 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
  *
  *	Automatically remove all the driver specific settings for this
  *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_sem.
+ *	caller must hold ide_setting_mtx.
  */
 
 static void auto_remove_settings (ide_drive_t *drive)
@@ -269,7 +269,7 @@ static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
  *	@setting: drive setting
  *
  *	Read a drive setting and return the value. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -306,7 +306,7 @@ static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
  *	@val: value
  *
  *	Write a drive setting if it is possible. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -367,7 +367,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
  *	@drive: drive being configured
  *
  *	Add the generic parts of the system settings to the /proc files.
- *	The caller must not be holding the ide_setting_sem.
+ *	The caller must not be holding the ide_setting_mtx.
  */
 
 void ide_add_generic_settings (ide_drive_t *drive)
@@ -408,7 +408,7 @@ static int proc_ide_read_settings
 
 	proc_ide_settings_warn();
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
 	while(setting) {
@@ -428,7 +428,7 @@ static int proc_ide_read_settings
 		setting = setting->next;
 	}
 	len = out - page;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
@@ -508,16 +508,16 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 				++p;
 			}
 
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			setting = ide_find_setting_by_name(drive, name);
 			if (!setting)
 			{
-				up(&ide_setting_sem);
+				mutex_unlock(&ide_setting_mtx);
 				goto parse_error;
 			}
 			if (for_real)
 				ide_write_setting(drive, setting, val * setting->div_factor / setting->mul_factor);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	} while (!for_real++);
 	free_page((unsigned long)buf);
@@ -705,7 +705,7 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	Clean up the driver specific /proc files and IDE settings
  *	for a given drive.
  *
- *	Takes ide_setting_sem and ide_lock.
+ *	Takes ide_setting_mtx and ide_lock.
  *	Caller must hold none of the locks.
  */
 
@@ -715,10 +715,10 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 
 	ide_remove_proc_entries(drive->proc, driver->proc);
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	/*
-	 * ide_setting_sem protects the settings list
+	 * ide_setting_mtx protects the settings list
 	 * ide_lock protects the use of settings
 	 *
 	 * so we need to hold both, ide_settings_sem because we want to
@@ -726,11 +726,11 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 	 * a setting out that is being used.
 	 *
 	 * OTOH both ide_{read,write}_setting are only ever used under
-	 * ide_setting_sem.
+	 * ide_setting_mtx.
 	 */
 	auto_remove_settings(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 }
 
 EXPORT_SYMBOL(ide_proc_unregister_driver);
diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
index c0864b1..e6cb859 100644
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -102,66 +102,16 @@ static struct ide_timing ide_timing[] = {
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
 #define XFER_MODE	0xf0
-#define XFER_UDMA_133	0x48
-#define XFER_UDMA_100	0x44
-#define XFER_UDMA_66	0x42
-#define XFER_UDMA	0x40
 #define XFER_MWDMA	0x20
-#define XFER_SWDMA	0x10
 #define XFER_EPIO	0x01
 #define XFER_PIO	0x00
 
-static short ide_find_best_mode(ide_drive_t *drive, int map)
+static short ide_find_best_pio_mode(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 	short best = 0;
 
-	if (!id)
-		return XFER_PIO_SLOW;
-
-	if ((map & XFER_UDMA) && (id->field_valid & 4)) {	/* Want UDMA and UDMA bitmap valid */
-
-		if ((map & XFER_UDMA_133) == XFER_UDMA_133)
-			if ((best = (id->dma_ultra & 0x0040) ? XFER_UDMA_6 : 0)) return best;
-
-		if ((map & XFER_UDMA_100) == XFER_UDMA_100)
-			if ((best = (id->dma_ultra & 0x0020) ? XFER_UDMA_5 : 0)) return best;
-
-		if ((map & XFER_UDMA_66) == XFER_UDMA_66)
-			if ((best = (id->dma_ultra & 0x0010) ? XFER_UDMA_4 :
-                	    	    (id->dma_ultra & 0x0008) ? XFER_UDMA_3 : 0)) return best;
-
-                if ((best = (id->dma_ultra & 0x0004) ? XFER_UDMA_2 :
-                	    (id->dma_ultra & 0x0002) ? XFER_UDMA_1 :
-                	    (id->dma_ultra & 0x0001) ? XFER_UDMA_0 : 0)) return best;
-	}
-
-	if ((map & XFER_MWDMA) && (id->field_valid & 2)) {	/* Want MWDMA and drive has EIDE fields */
-
-		if ((best = (id->dma_mword & 0x0004) ? XFER_MW_DMA_2 :
-                	    (id->dma_mword & 0x0002) ? XFER_MW_DMA_1 :
-                	    (id->dma_mword & 0x0001) ? XFER_MW_DMA_0 : 0)) return best;
-	}
-
-	if (map & XFER_SWDMA) {					/* Want SWDMA */
-
- 		if (id->field_valid & 2) {			/* EIDE SWDMA */
-
-			if ((best = (id->dma_1word & 0x0004) ? XFER_SW_DMA_2 :
-      				    (id->dma_1word & 0x0002) ? XFER_SW_DMA_1 :
-				    (id->dma_1word & 0x0001) ? XFER_SW_DMA_0 : 0)) return best;
-		}
-
-		if (id->capability & 1) {			/* Pre-EIDE style SWDMA */
-
-			if ((best = (id->tDMA == 2) ? XFER_SW_DMA_2 :
-				    (id->tDMA == 1) ? XFER_SW_DMA_1 :
-				    (id->tDMA == 0) ? XFER_SW_DMA_0 : 0)) return best;
-		}
-	}
-
-
-	if ((map & XFER_EPIO) && (id->field_valid & 2)) {	/* EIDE PIO modes */
+	if (id->field_valid & 2) {	/* EIDE PIO modes */
 
 		if ((best = (drive->id->eide_pio_modes & 4) ? XFER_PIO_5 :
 			    (drive->id->eide_pio_modes & 2) ? XFER_PIO_4 :
@@ -262,7 +212,7 @@ static int ide_timing_compute(ide_drive_t *drive, short speed, struct ide_timing
  */
 
 	if ((speed & XFER_MODE) != XFER_PIO) {
-		ide_timing_compute(drive, ide_find_best_mode(drive, XFER_PIO | XFER_EPIO), &p, T, UT);
+		ide_timing_compute(drive, ide_find_best_pio_mode(drive), &p, T, UT);
 		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 0cd76bf..c948a5c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -169,7 +169,7 @@ static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
 static int idebus_parameter;	/* holds the "idebus=" parameter */
 static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
 
-DECLARE_MUTEX(ide_cfg_sem);
+DEFINE_MUTEX(ide_cfg_mtx);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
@@ -460,6 +460,8 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
 	hwif->swdma_mask		= tmp_hwif->swdma_mask;
 
+	hwif->cbl			= tmp_hwif->cbl;
+
 	hwif->chipset			= tmp_hwif->chipset;
 	hwif->hold			= tmp_hwif->hold;
 
@@ -496,8 +498,8 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->ide_dma_clear_irq		= tmp_hwif->ide_dma_clear_irq;
 	hwif->dma_host_on		= tmp_hwif->dma_host_on;
 	hwif->dma_host_off		= tmp_hwif->dma_host_off;
-	hwif->ide_dma_lostirq		= tmp_hwif->ide_dma_lostirq;
-	hwif->ide_dma_timeout		= tmp_hwif->ide_dma_timeout;
+	hwif->dma_lost_irq		= tmp_hwif->dma_lost_irq;
+	hwif->dma_timeout		= tmp_hwif->dma_timeout;
 
 	hwif->OUTB			= tmp_hwif->OUTB;
 	hwif->OUTBSYNC			= tmp_hwif->OUTBSYNC;
@@ -533,7 +535,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->extra_base		= tmp_hwif->extra_base;
 	hwif->extra_ports		= tmp_hwif->extra_ports;
 	hwif->autodma			= tmp_hwif->autodma;
-	hwif->udma_four			= tmp_hwif->udma_four;
 
 	hwif->hwif_data			= tmp_hwif->hwif_data;
 }
@@ -564,7 +565,7 @@ void ide_unregister(unsigned int index)
 {
 	ide_drive_t *drive;
 	ide_hwif_t *hwif, *g;
-	static ide_hwif_t tmp_hwif; /* protected by ide_cfg_sem */
+	static ide_hwif_t tmp_hwif; /* protected by ide_cfg_mtx */
 	ide_hwgroup_t *hwgroup;
 	int irq_count = 0, unit;
 
@@ -572,7 +573,7 @@ void ide_unregister(unsigned int index)
 
 	BUG_ON(in_interrupt());
 	BUG_ON(irqs_disabled());
-	down(&ide_cfg_sem);
+	mutex_lock(&ide_cfg_mtx);
 	spin_lock_irq(&ide_lock);
 	hwif = &ide_hwifs[index];
 	if (!hwif->present)
@@ -679,7 +680,7 @@ void ide_unregister(unsigned int index)
 
 abort:
 	spin_unlock_irq(&ide_lock);
-	up(&ide_cfg_sem);
+	mutex_unlock(&ide_cfg_mtx);
 }
 
 EXPORT_SYMBOL(ide_unregister);
@@ -817,9 +818,9 @@ EXPORT_SYMBOL(ide_register_hw);
  *	Locks for IDE setting functionality
  */
 
-DECLARE_MUTEX(ide_setting_sem);
+DEFINE_MUTEX(ide_setting_mtx);
 
-EXPORT_SYMBOL_GPL(ide_setting_sem);
+EXPORT_SYMBOL_GPL(ide_setting_mtx);
 
 /**
  *	ide_spin_wait_hwgroup	-	wait for group
@@ -1192,11 +1193,11 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 	}
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1206,9 +1207,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
@@ -1548,7 +1549,11 @@ static int __init ide_setup(char *s)
 				goto bad_option;
 			case -7: /* ata66 */
 #ifdef CONFIG_BLK_DEV_IDEPCI
-				hwif->udma_four = 1;
+				/*
+				 * Use ATA_CBL_PATA40_SHORT so drive side
+				 * cable detection is also overriden.
+				 */
+				hwif->cbl = ATA_CBL_PATA40_SHORT;
 				goto obsolete_option;
 #else
 				goto bad_hwif;
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 45ed035..661c12f 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -130,7 +130,7 @@ struct hd_i_struct {
 	
 #ifdef HD_TYPE
 static struct hd_i_struct hd_info[] = { HD_TYPE };
-static int NR_HD = ((sizeof (hd_info))/(sizeof (struct hd_i_struct)));
+static int NR_HD = ARRAY_SIZE(hd_info);
 #else
 static struct hd_i_struct hd_info[MAX_HD];
 static int NR_HD;
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index c211fc7..b557c45 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -77,15 +77,6 @@ int macide_ack_intr(ide_hwif_t* hwif)
 	return 0;
 }
 
-#ifdef CONFIG_BLK_DEV_MAC_MEDIABAY
-static void macide_mediabay_interrupt(int irq, void *dev_id)
-{
-	int state = baboon->mb_status & 0x04;
-
-	printk(KERN_INFO "macide: media bay %s detected\n", state? "removal":"insertion");
-}
-#endif
-
 /*
  * Probe for a Macintosh IDE interface
  */
@@ -128,11 +119,6 @@ void macide_init(void)
 			ide_drive_t *drive = &ide_hwifs[index].drives[0];
 			drive->capacity64 = drive->cyl*drive->head*drive->sect;
 
-#ifdef CONFIG_BLK_DEV_MAC_MEDIABAY
-			request_irq(IRQ_BABOON_2, macide_mediabay_interrupt,
-					IRQ_FLG_FAST, "mediabay",
-					macide_mediabay_interrupt);
-#endif
 		}
 		break;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index ca95e99..2e7013a 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -381,9 +381,7 @@ static int auide_dma_setup(ide_drive_t *drive)
 
 static int auide_dma_check(ide_drive_t *drive)
 {
-	u8 speed;
-
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	u8 speed = ide_max_dma_mode(drive);
 
 	if( dbdma_init_done == 0 ){
 		auide_hwif.white_list = ide_in_drive_list(drive->id,
@@ -394,7 +392,6 @@ static int auide_dma_check(ide_drive_t *drive)
 		auide_ddma_init(&auide_hwif);
 		dbdma_init_done = 1;
 	}
-#endif
 
 	/* Is the drive in our DMA black list? */
 
@@ -409,8 +406,6 @@ static int auide_dma_check(ide_drive_t *drive)
 	else
 		drive->using_dma = 1;
 
-	speed = ide_find_best_mode(drive, XFER_PIO | XFER_MWDMA);
-	
 	if (drive->autodma && (speed & XFER_MODE) != XFER_PIO)
 		return 0;
 
@@ -456,10 +451,9 @@ static void auide_dma_off_quietly(ide_drive_t *drive)
 	drive->using_dma = 0;
 }
 
-static int auide_dma_lostirq(ide_drive_t *drive)
+static void auide_dma_lost_irq(ide_drive_t *drive)
 {
 	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-	return 0;
 }
 
 static void auide_ddma_tx_callback(int irq, void *param)
@@ -489,16 +483,16 @@ static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 de
   
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 
-static int auide_dma_timeout(ide_drive_t *drive)
+static void auide_dma_timeout(ide_drive_t *drive)
 {
-//      printk("%s\n", __FUNCTION__);
+	ide_hwif_t *hwif = HWIF(drive);
 
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
-	if (HWIF(drive)->ide_dma_test_irq(drive))
-		return 0;
+	if (hwif->ide_dma_test_irq(drive))
+		return;
 
-	return HWIF(drive)->ide_dma_end(drive);
+	hwif->ide_dma_end(drive);
 }
 					
 
@@ -721,7 +715,7 @@ static int au_ide_probe(struct device *dev)
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	hwif->dma_off_quietly		= &auide_dma_off_quietly;
-	hwif->ide_dma_timeout           = &auide_dma_timeout;
+	hwif->dma_timeout		= &auide_dma_timeout;
 
 	hwif->ide_dma_check             = &auide_dma_check;
 	hwif->dma_exec_cmd              = &auide_dma_exec_cmd;
@@ -731,7 +725,7 @@ static int au_ide_probe(struct device *dev)
 	hwif->ide_dma_test_irq          = &auide_dma_test_irq;
 	hwif->dma_host_off		= &auide_dma_host_off;
 	hwif->dma_host_on		= &auide_dma_host_on;
-	hwif->ide_dma_lostirq           = &auide_dma_lostirq;
+	hwif->dma_lost_irq		= &auide_dma_lost_irq;
 	hwif->ide_dma_on                = &auide_dma_on;
 
 	hwif->autodma                   = 1;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index b173bc6..e5d0936 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.21	Apr 21, 2007
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.24	May 24, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
@@ -140,25 +140,10 @@ static int aec6260_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return(ide_config_drive_speed(drive, speed));
 }
 
-static int aec62xx_tune_chipset (ide_drive_t *drive, u8 speed)
-{
-	switch (HWIF(drive)->pci_dev->device) {
-		case PCI_DEVICE_ID_ARTOP_ATP865:
-		case PCI_DEVICE_ID_ARTOP_ATP865R:
-		case PCI_DEVICE_ID_ARTOP_ATP860:
-		case PCI_DEVICE_ID_ARTOP_ATP860R:
-			return ((int) aec6260_tune_chipset(drive, speed));
-		case PCI_DEVICE_ID_ARTOP_ATP850UF:
-			return ((int) aec6210_tune_chipset(drive, speed));
-		default:
-			return -1;
-	}
-}
-
 static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 {
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
-	(void) aec62xx_tune_chipset(drive, pio + XFER_PIO_0);
+	(void) HWIF(drive)->speedproc(drive, pio + XFER_PIO_0);
 }
 
 static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
@@ -172,12 +157,9 @@ static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
 	return -1;
 }
 
-static int aec62xx_irq_timeout (ide_drive_t *drive)
+static void aec62xx_dma_lost_irq (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
-
-	switch(dev->device) {
+	switch (HWIF(drive)->pci_dev->device) {
 		case PCI_DEVICE_ID_ARTOP_ATP860:
 		case PCI_DEVICE_ID_ARTOP_ATP860R:
 		case PCI_DEVICE_ID_ARTOP_ATP865:
@@ -186,7 +168,6 @@ static int aec62xx_irq_timeout (ide_drive_t *drive)
 		default:
 			break;
 	}
-	return 0;
 }
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
@@ -224,64 +205,46 @@ static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const ch
 
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev	= hwif->pci_dev;
+	u8 reg54 = 0,  mask	= hwif->channel ? 0xf0 : 0x0f;
+	unsigned long flags;
 
-	hwif->autodma = 0;
 	hwif->tuneproc = &aec62xx_tune_drive;
-	hwif->speedproc = &aec62xx_tune_chipset;
 
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
-		hwif->serialized = hwif->channel;
-
-	if (hwif->mate)
-		hwif->mate->serialized = hwif->serialized;
+	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
+		if(hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
+		hwif->speedproc = &aec6210_tune_chipset;
+	} else
+		hwif->speedproc = &aec6260_tune_chipset;
 
 	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+		hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 		return;
 	}
 
 	hwif->ultra_mask = hwif->cds->udma_mask;
-
-	/* atp865 and atp865r */
-	if (hwif->ultra_mask == 0x3f) {
-		/* check bit 0x10 of DMA status register */
-		if (inb(pci_resource_start(dev, 4) + 2) & 0x10)
- 			hwif->ultra_mask = 0x7f; /* udma0-6 */
-	}
-
 	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check	= &aec62xx_config_drive_xfer_rate;
-	hwif->ide_dma_lostirq	= &aec62xx_irq_timeout;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-}
-
-static void __devinit init_dma_aec62xx(ide_hwif_t *hwif, unsigned long dmabase)
-{
-	struct pci_dev *dev	= hwif->pci_dev;
+	hwif->dma_lost_irq	= &aec62xx_dma_lost_irq;
 
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
-		u8 reg54h = 0;
-		unsigned long flags;
-
 		spin_lock_irqsave(&ide_lock, flags);
-		pci_read_config_byte(dev, 0x54, &reg54h);
-		pci_write_config_byte(dev, 0x54, reg54h & ~(hwif->channel ? 0xF0 : 0x0F));
+		pci_read_config_byte (dev, 0x54, &reg54);
+		pci_write_config_byte(dev, 0x54, (reg54 & ~mask));
 		spin_unlock_irqrestore(&ide_lock, flags);
-	} else {
-		u8 ata66	= 0;
+	} else if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
+		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
+
 		pci_read_config_byte(hwif->pci_dev, 0x49, &ata66);
-	        if (!(hwif->udma_four))
-			hwif->udma_four = (ata66&(hwif->channel?0x02:0x01))?0:1;
+
+		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
 
-	ide_setup_dma(hwif, dmabase, 8);
+	if (!noautodma)
+		hwif->autodma = 1;
+	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static int __devinit init_setup_aec62xx(struct pci_dev *dev, ide_pci_device_t *d)
@@ -291,16 +254,12 @@ static int __devinit init_setup_aec62xx(struct pci_dev *dev, ide_pci_device_t *d
 
 static int __devinit init_setup_aec6x80(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	unsigned long bar4reg = pci_resource_start(dev, 4);
-
-	if (inb(bar4reg+2) & 0x10) {
-		strcpy(d->name, "AEC6880");
-		if (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R)
-			strcpy(d->name, "AEC6880R");
-	} else {
-		strcpy(d->name, "AEC6280");
-		if (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R)
-			strcpy(d->name, "AEC6280R");
+	unsigned long dma_base = pci_resource_start(dev, 4);
+
+	if (inb(dma_base + 2) & 0x10) {
+		d->name = (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R) ?
+			  "AEC6880R" : "AEC6880";
+		d->udma_mask = 0x7f; /* udma0-6 */
 	}
 
 	return ide_setup_pci_device(dev, d);
@@ -312,7 +271,6 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.init_dma	= init_dma_aec62xx,
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
@@ -323,7 +281,6 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.init_dma	= init_dma_aec62xx,
 		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= OFF_BOARD,
@@ -333,28 +290,25 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.init_dma	= init_dma_aec62xx,
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= NEVER_BOARD,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
-		.name		= "AEC6X80",
+		.name		= "AEC6280",
 		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.init_dma	= init_dma_aec62xx,
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
-		.name		= "AEC6X80R",
+		.name		= "AEC6280R",
 		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.init_dma	= init_dma_aec62xx,
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
@@ -370,13 +324,16 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
  *
  *	Called when the PCI registration layer (or the IDE initialization)
  *	finds a device matching our IDE device tables.
+ *
+ *	NOTE: since we're going to modify the 'name' field for AEC-6[26]80[R]
+ *	chips, pass a local copy of 'struct pci_device_id' down the call chain.
  */
  
 static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &aec62xx_chipsets[id->driver_data];
+	ide_pci_device_t d = aec62xx_chipsets[id->driver_data];
 
-	return d->init_setup(dev, d);
+	return d.init_setup(dev, &d);
 }
 
 static struct pci_device_id aec62xx_pci_tbl[] = {
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 27525ec..8a6b27b 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.21	2007/02/03
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.25	Jun 9 2007
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -10,6 +10,7 @@
  *  Copyright (C) 2002 Alan Cox <alan@redhat.com>
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
  *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2007 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
  *
  *  (U)DMA capable version of ali 1533/1543(C), 1535(D)
  *
@@ -36,6 +37,7 @@
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 
@@ -583,6 +585,35 @@ out:
 	return 0;
 }
 
+/*
+ *	Cable special cases
+ */
+
+static struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "HP Pavilion N5430",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "OmniBook N32N-736"),
+		},
+	},
+	{ }
+};
+
+static int ali_cable_override(struct pci_dev *pdev)
+{
+	/* Fujitsu P2000 */
+	if (pdev->subsystem_vendor == 0x10CF &&
+	    pdev->subsystem_device == 0x10AF)
+		return 1;
+
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+
+	return 0;
+}
+
 /**
  *	ata66_ali15x3	-	check for UDMA 66 support
  *	@hwif: IDE interface
@@ -594,37 +625,31 @@ out:
  *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
-static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
+static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
-	unsigned int ata66	= 0;
-	u8 cable_80_pin[2]	= { 0, 0 };
-
 	unsigned long flags;
-	u8 tmpbyte;
+	u8 cbl = ATA_CBL_PATA40, tmpbyte;
 
 	local_irq_save(flags);
 
 	if (m5229_revision >= 0xC2) {
 		/*
-		 * Ultra66 cable detection (from Host View)
-		 * m5229, 0x4a, bit0: primary, bit1: secondary 80 pin
-		 */
-		pci_read_config_byte(dev, 0x4a, &tmpbyte);
-		/*
-		 * 0x4a, bit0 is 0 => primary channel
-		 * has 80-pin (from host view)
-		 */
-		if (!(tmpbyte & 0x01)) cable_80_pin[0] = 1;
-		/*
-		 * 0x4a, bit1 is 0 => secondary channel
-		 * has 80-pin (from host view)
-		 */
-		if (!(tmpbyte & 0x02)) cable_80_pin[1] = 1;
-		/*
-		 * Allow ata66 if cable of current channel has 80 pins
+		 * m5229 80-pin cable detection (from Host View)
+		 *
+		 * 0x4a bit0 is 0 => primary channel has 80-pin
+		 * 0x4a bit1 is 0 => secondary channel has 80-pin
+		 *
+		 * Certain laptops use short but suitable cables
+		 * and don't implement the detect logic.
 		 */
-		ata66 = (hwif->channel)?cable_80_pin[1]:cable_80_pin[0];
+		if (ali_cable_override(dev))
+			cbl = ATA_CBL_PATA40_SHORT;
+		else {
+			pci_read_config_byte(dev, 0x4a, &tmpbyte);
+			if ((tmpbyte & (1 << hwif->channel)) == 0)
+				cbl = ATA_CBL_PATA80;
+		}
 	} else {
 		/*
 		 * check m1533, 0x5e, bit 1~4 == 1001 => & 00011110 = 00010010
@@ -657,7 +682,7 @@ static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
 
 	local_irq_restore(flags);
 
-	return(ata66);
+	return cbl;
 }
 
 /**
@@ -708,8 +733,9 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 		hwif->dma_setup = &ali15x3_dma_setup;
 		if (!noautodma)
 			hwif->autodma = 1;
-		if (!(hwif->udma_four))
-			hwif->udma_four = ata66_ali15x3(hwif);
+
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = ata66_ali15x3(hwif);
 	}
 	hwif->drives[0].autodma = hwif->autodma;
 	hwif->drives[1].autodma = hwif->autodma;
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index a2be65f..84ed30c 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,10 +1,11 @@
 /*
- * Version 2.16
+ * Version 2.20
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
  *
  * Copyright (c) 2000-2002 Vojtech Pavlik
+ * Copyright (c) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based on the work of:
  *      Andre Hedrick
@@ -37,11 +38,6 @@
 #define AMD_ADDRESS_SETUP	(0x0c + amd_config->base)
 #define AMD_UDMA_TIMING		(0x10 + amd_config->base)
 
-#define AMD_UDMA		0x07
-#define AMD_UDMA_33		0x01
-#define AMD_UDMA_66		0x02
-#define AMD_UDMA_100		0x03
-#define AMD_UDMA_133		0x04
 #define AMD_CHECK_SWDMA		0x08
 #define AMD_BAD_SWDMA		0x10
 #define AMD_BAD_FIFO		0x20
@@ -53,32 +49,33 @@
 
 static struct amd_ide_chip {
 	unsigned short id;
-	unsigned long base;
-	unsigned char flags;
+	u8 base;
+	u8 udma_mask;
+	u8 flags;
 } amd_ide_chips[] = {
-	{ PCI_DEVICE_ID_AMD_COBRA_7401,		0x40, AMD_UDMA_33 | AMD_BAD_SWDMA },
-	{ PCI_DEVICE_ID_AMD_VIPER_7409,		0x40, AMD_UDMA_66 | AMD_CHECK_SWDMA },
-	{ PCI_DEVICE_ID_AMD_VIPER_7411,		0x40, AMD_UDMA_100 | AMD_BAD_FIFO },
-	{ PCI_DEVICE_ID_AMD_OPUS_7441,		0x40, AMD_UDMA_100 },
-	{ PCI_DEVICE_ID_AMD_8111_IDE,		0x40, AMD_UDMA_133 | AMD_CHECK_SERENADE },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_IDE,	0x50, AMD_UDMA_100 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,	0x50, AMD_UDMA_133 },
-	{ PCI_DEVICE_ID_AMD_CS5536_IDE,			0x40, AMD_UDMA_100 },
+	{ PCI_DEVICE_ID_AMD_COBRA_7401,		 0x40, ATA_UDMA2, AMD_BAD_SWDMA },
+	{ PCI_DEVICE_ID_AMD_VIPER_7409,		 0x40, ATA_UDMA4, AMD_CHECK_SWDMA },
+	{ PCI_DEVICE_ID_AMD_VIPER_7411,		 0x40, ATA_UDMA5, AMD_BAD_FIFO },
+	{ PCI_DEVICE_ID_AMD_OPUS_7441,		 0x40, ATA_UDMA5, },
+	{ PCI_DEVICE_ID_AMD_8111_IDE,		 0x40, ATA_UDMA6, AMD_CHECK_SERENADE },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_IDE,	 0x50, ATA_UDMA5, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2,	 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE, 0x50, ATA_UDMA6, },
+	{ PCI_DEVICE_ID_AMD_CS5536_IDE,		 0x40, ATA_UDMA5, },
 	{ 0 }
 };
 
@@ -87,7 +84,7 @@ static ide_pci_device_t *amd_chipset;
 static unsigned int amd_80w;
 static unsigned int amd_clock;
 
-static char *amd_dma[] = { "MWDMA16", "UDMA33", "UDMA66", "UDMA100", "UDMA133" };
+static char *amd_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 static unsigned char amd_cyc2udma[] = { 6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7 };
 
 /*
@@ -128,7 +125,7 @@ static int amd74xx_get_info(char *buffer, char **addr, off_t offset, int count)
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &t);
 	amd_print("Revision:                           IDE %#x", t);
-	amd_print("Highest DMA rate:                   %s", amd_dma[amd_config->flags & AMD_UDMA]);
+	amd_print("Highest DMA rate:                   UDMA%s", amd_dma[fls(amd_config->udma_mask) - 1]);
 
 	amd_print("BM-DMA base:                        %#lx", amd_base);
 	amd_print("PCI clock:                          %d.%dMHz", amd_clock / 1000, amd_clock / 100 % 10);
@@ -221,12 +218,12 @@ static void amd_set_speed(struct pci_dev *dev, unsigned char dn, struct ide_timi
 	pci_write_config_byte(dev, AMD_DRIVE_TIMING + (3 - dn),
 		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
 
-	switch (amd_config->flags & AMD_UDMA) {
-		case AMD_UDMA_33:  t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-		case AMD_UDMA_66:  t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
-		case AMD_UDMA_100: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
-		case AMD_UDMA_133: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 15)]) : 0x03; break;
-		default: return;
+	switch (amd_config->udma_mask) {
+	case ATA_UDMA2: t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
+	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
+	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 15)]) : 0x03; break;
+	default: return;
 	}
 
 	pci_write_config_byte(dev, AMD_UDMA_TIMING + (3 - dn), t);
@@ -248,7 +245,7 @@ static int amd_set_drive(ide_drive_t *drive, u8 speed)
 		ide_config_drive_speed(drive, speed);
 
 	T = 1000000000 / amd_clock;
-	UT = T / min_t(int, max_t(int, amd_config->flags & AMD_UDMA, 1), 2);
+	UT = (amd_config->udma_mask == ATA_UDMA2) ? T : (T / 2);
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
@@ -277,29 +274,19 @@ static int amd_set_drive(ide_drive_t *drive, u8 speed)
 static void amd74xx_tune_drive(ide_drive_t *drive, u8 pio)
 {
 	if (pio == 255) {
-		amd_set_drive(drive, ide_find_best_mode(drive, XFER_PIO | XFER_EPIO));
+		amd_set_drive(drive, ide_find_best_pio_mode(drive));
 		return;
 	}
 
 	amd_set_drive(drive, XFER_PIO_0 + min_t(byte, pio, 5));
 }
 
-/*
- * amd74xx_dmaproc() is a callback from upper layers that can do
- * a lot, but we use it for DMA/PIO tuning only, delegating everything
- * else to the default ide_dmaproc().
- */
-
 static int amd74xx_ide_dma_check(ide_drive_t *drive)
 {
-	int w80 = HWIF(drive)->udma_four;
+	u8 speed = ide_max_dma_mode(drive);
 
-	u8 speed = ide_find_best_mode(drive,
-		XFER_PIO | XFER_EPIO | XFER_MWDMA | XFER_UDMA |
-		((amd_config->flags & AMD_BAD_SWDMA) ? 0 : XFER_SWDMA) |
-		(w80 && (amd_config->flags & AMD_UDMA) >= AMD_UDMA_66 ? XFER_UDMA_66 : 0) |
-		(w80 && (amd_config->flags & AMD_UDMA) >= AMD_UDMA_100 ? XFER_UDMA_100 : 0) |
-		(w80 && (amd_config->flags & AMD_UDMA) >= AMD_UDMA_133 ? XFER_UDMA_133 : 0));
+	if (speed == 0)
+		speed = ide_find_best_pio_mode(drive);
 
 	amd_set_drive(drive, speed);
 
@@ -334,10 +321,10 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
  * Check 80-wire cable presence.
  */
 
-	switch (amd_config->flags & AMD_UDMA) {
+	switch (amd_config->udma_mask) {
 
-		case AMD_UDMA_133:
-		case AMD_UDMA_100:
+		case ATA_UDMA6:
+		case ATA_UDMA5:
 			pci_read_config_byte(dev, AMD_CABLE_DETECT, &t);
 			pci_read_config_dword(dev, AMD_UDMA_TIMING, &u);
 			amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
@@ -349,7 +336,7 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
 				}
 			break;
 
-		case AMD_UDMA_66:
+		case ATA_UDMA4:
 			/* no host side cable detection */
 			amd_80w = 0x03;
 			break;
@@ -370,7 +357,7 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
 	if ((amd_config->flags & AMD_CHECK_SERENADE) &&
 		dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
 		dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
-			amd_config->flags = AMD_UDMA_100;
+			amd_config->udma_mask = ATA_UDMA5;
 
 /*
  * Determine the system bus clock.
@@ -395,8 +382,9 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
  */
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &t);
-	printk(KERN_INFO "%s: %s (rev %02x) %s controller\n",
-		amd_chipset->name, pci_name(dev), t, amd_dma[amd_config->flags & AMD_UDMA]);
+	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
+		amd_chipset->name, pci_name(dev), t,
+		amd_dma[fls(amd_config->udma_mask) - 1]);
 
 /*
  * Register /proc/ide/amd74xx entry
@@ -437,12 +425,19 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		return;
 
         hwif->atapi_dma = 1;
-        hwif->ultra_mask = 0x7f;
-        hwif->mwdma_mask = 0x07;
-        hwif->swdma_mask = 0x07;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (amd_80w >> hwif->channel) & 1;
+	hwif->ultra_mask = amd_config->udma_mask;
+	hwif->mwdma_mask = 0x07;
+	if ((amd_config->flags & AMD_BAD_SWDMA) == 0)
+		hwif->swdma_mask = 0x07;
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
+		if ((amd_80w >> hwif->channel) & 1)
+			hwif->cbl = ATA_CBL_PATA80;
+		else
+			hwif->cbl = ATA_CBL_PATA40;
+	}
+
         hwif->ide_dma_check = &amd74xx_ide_dma_check;
         if (!noautodma)
                 hwif->autodma = 1;
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 8ab33fa..2761510 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -264,10 +264,11 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	hwif->swdma_mask = 0x04;
 
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+
 	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
-		hwif->udma_four = 1;
+		hwif->cbl = ATA_CBL_PATA80;
 	else
-		hwif->udma_four = 0;
+		hwif->cbl = ATA_CBL_PATA40;
 
 	hwif->dma_host_on = &atiixp_dma_host_on;
 	hwif->dma_host_off = &atiixp_dma_host_off;
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 7c57dc6..8631b6c 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cmd64x.c		Version 1.47	Mar 19, 2007
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.50	May 10, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Due to massive hardware bugs, UltraDMA is only supported
@@ -52,9 +52,6 @@
 #define   ARTTIM23_DIS_RA2	0x04
 #define   ARTTIM23_DIS_RA3	0x08
 #define   ARTTIM23_INTR_CH1	0x10
-#define ARTTIM2		0x57
-#define ARTTIM3		0x57
-#define DRWTIM23	0x58
 #define DRWTIM2		0x58
 #define BRST		0x59
 #define DRWTIM3		0x5b
@@ -469,71 +466,43 @@ static int cmd646_1_ide_dma_end (ide_drive_t *drive)
 
 static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const char *name)
 {
-	u32 class_rev = 0;
 	u8 mrdmode = 0;
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
+	if (dev->device == PCI_DEVICE_ID_CMD_646) {
+		u8 rev = 0;
 
-	switch(dev->device) {
-		case PCI_DEVICE_ID_CMD_643:
-			break;
-		case PCI_DEVICE_ID_CMD_646:
-			printk(KERN_INFO "%s: chipset revision 0x%02X, ", name, class_rev);
-			switch(class_rev) {
-				case 0x07:
-				case 0x05:
-					printk("UltraDMA Capable");
-					break;
-				case 0x03:
-					printk("MultiWord DMA Force Limited");
-					break;
-				case 0x01:
-				default:
-					printk("MultiWord DMA Limited, IRQ workaround enabled");
-					break;
-				}
-			printk("\n");
-                        break;
-		case PCI_DEVICE_ID_CMD_648:
-		case PCI_DEVICE_ID_CMD_649:
+		pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
+
+		switch (rev) {
+		case 0x07:
+		case 0x05:
+			printk("%s: UltraDMA capable", name);
 			break;
+		case 0x03:
 		default:
+			printk("%s: MultiWord DMA force limited", name);
+			break;
+		case 0x01:
+			printk("%s: MultiWord DMA limited, "
+			       "IRQ workaround enabled\n", name);
 			break;
+		}
 	}
 
 	/* Set a good latency timer and cache line size value. */
 	(void) pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
 	/* FIXME: pci_set_master() to ensure a good latency timer value */
 
-	/* Setup interrupts. */
-	(void) pci_read_config_byte(dev, MRDMODE, &mrdmode);
-	mrdmode &= ~(0x30);
-	(void) pci_write_config_byte(dev, MRDMODE, mrdmode);
-
-	/* Use MEMORY READ LINE for reads.
-	 * NOTE: Although not mentioned in the PCI0646U specs,
-	 *       these bits are write only and won't be read
-	 *       back as set or not.  The PCI0646U2 specs clarify
-	 *       this point.
+	/*
+	 * Enable interrupts, select MEMORY READ LINE for reads.
+	 *
+	 * NOTE: although not mentioned in the PCI0646U specs,
+	 * bits 0-1 are write only and won't be read back as
+	 * set or not -- PCI0646U2 specs clarify this point.
 	 */
-	(void) pci_write_config_byte(dev, MRDMODE, mrdmode | 0x02);
-
-	/* Set reasonable active/recovery/address-setup values. */
-	(void) pci_write_config_byte(dev, ARTTIM0,  0x40);
-	(void) pci_write_config_byte(dev, DRWTIM0,  0x3f);
-	(void) pci_write_config_byte(dev, ARTTIM1,  0x40);
-	(void) pci_write_config_byte(dev, DRWTIM1,  0x3f);
-#ifdef __i386__
-	(void) pci_write_config_byte(dev, ARTTIM23, 0x1c);
-#else
-	(void) pci_write_config_byte(dev, ARTTIM23, 0x5c);
-#endif
-	(void) pci_write_config_byte(dev, DRWTIM23, 0x3f);
-	(void) pci_write_config_byte(dev, DRWTIM3,  0x3f);
-#ifdef CONFIG_PPC
-	(void) pci_write_config_byte(dev, UDIDETCR0, 0xf0);
-#endif /* CONFIG_PPC */
+	(void) pci_read_config_byte (dev, MRDMODE, &mrdmode);
+	mrdmode &= ~0x30;
+	(void) pci_write_config_byte(dev, MRDMODE, (mrdmode | 0x02));
 
 #if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 
@@ -548,29 +517,27 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 	return 0;
 }
 
-static unsigned int __devinit ata66_cmd64x(ide_hwif_t *hwif)
+static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
 {
-	u8 ata66 = 0, mask = (hwif->channel) ? 0x02 : 0x01;
+	struct pci_dev  *dev	= hwif->pci_dev;
+	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
 
-	switch(hwif->pci_dev->device) {
-		case PCI_DEVICE_ID_CMD_643:
-		case PCI_DEVICE_ID_CMD_646:
-			return ata66;
-		default:
-			break;
+	switch (dev->device) {
+	case PCI_DEVICE_ID_CMD_648:
+	case PCI_DEVICE_ID_CMD_649:
+ 		pci_read_config_byte(dev, BMIDECSR, &bmidecsr);
+		return (bmidecsr & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	default:
+		return ATA_CBL_PATA40;
 	}
-	pci_read_config_byte(hwif->pci_dev, BMIDECSR, &ata66);
-	return (ata66 & mask) ? 1 : 0;
 }
 
 static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
-	unsigned int class_rev;
+	u8 rev			= 0;
 
-	hwif->autodma = 0;
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xff;
+	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
 
 	hwif->tuneproc  = &cmd64x_tune_drive;
 	hwif->speedproc = &cmd64x_tune_chipset;
@@ -580,8 +547,8 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	if (!hwif->dma_base)
 		return;
 
-	hwif->atapi_dma = 1;
-
+	hwif->atapi_dma  = 1;
+	hwif->mwdma_mask = 0x07;
 	hwif->ultra_mask = hwif->cds->udma_mask;
 
 	/*
@@ -596,16 +563,15 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	 *
 	 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
 	 */
-	if (dev->device == PCI_DEVICE_ID_CMD_646 && class_rev < 5)
+	if (dev->device == PCI_DEVICE_ID_CMD_646 && rev < 5)
 		hwif->ultra_mask = 0x00;
 
-	hwif->mwdma_mask = 0x07;
-
 	hwif->ide_dma_check = &cmd64x_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_cmd64x(hwif);
 
-	switch(dev->device) {
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_cmd64x(hwif);
+
+	switch (dev->device) {
 	case PCI_DEVICE_ID_CMD_648:
 	case PCI_DEVICE_ID_CMD_649:
 	alt_irq_bits:
@@ -614,10 +580,10 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 		break;
 	case PCI_DEVICE_ID_CMD_646:
 		hwif->chipset = ide_cmd646;
-		if (class_rev == 0x01) {
+		if (rev == 0x01) {
 			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
 			break;
-		} else if (class_rev >= 0x03)
+		} else if (rev >= 0x03)
 			goto alt_irq_bits;
 		/* fall thru */
 	default:
@@ -626,11 +592,9 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 		break;
 	}
 
-
 	if (!noautodma)
 		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
+	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static int __devinit init_setup_cmd64x(struct pci_dev *dev, ide_pci_device_t *d)
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 41925c4..10f61f3 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -187,7 +187,8 @@ static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
 
 	/* if a 80 wire cable was detected */
 	pci_read_config_byte(dev, CS5535_CABLE_DETECT, &bit);
-	return (bit & 1);
+
+	return (bit & 1) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /****
@@ -212,8 +213,7 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 	hwif->ultra_mask = 0x1F;
 	hwif->mwdma_mask = 0x07;
 
-
-	hwif->udma_four = cs5535_cable_detect(hwif->pci_dev);
+	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
 
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index c33d0b0..4b6bae8 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.06	Jun 27, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.10	Jun 29, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -77,7 +77,7 @@
  *   since they may tamper with its fields
  * - prefix the driver startup messages with the real chip name
  * - claim the extra 240 bytes of I/O space for all chips
- * - optimize the rate masking/filtering and the drive list lookup code
+ * - optimize the UltraDMA filtering and the drive list lookup code
  * - use pci_get_slot() to get to the function 1 of HPT36x/374
  * - cache offset of the channel's misc. control registers (MCRs) being used
  *   throughout the driver
@@ -99,9 +99,9 @@
  *   stop duplicating it for each channel by storing the pointer in the pci_dev
  *   structure: first, at the init_setup stage, point it to a static "template"
  *   with only the chip type and its specific base DPLL frequency, the highest
- *   supported DMA mode, and the chip settings table pointer filled, then, at
- *   the init_chipset stage, allocate per-chip instance  and fill it with the
- *   rest of the necessary information
+ *   UltraDMA mode, and the chip settings table pointer filled,  then, at the
+ *   init_chipset stage, allocate per-chip instance  and fill it with the rest
+ *   of the necessary information
  * - get rid of the constant thresholds in the HPT37x PCI clock detection code,
  *   switch  to calculating  PCI clock frequency based on the chip's base DPLL
  *   frequency
@@ -112,6 +112,7 @@
  *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
  *   the register setting lists into the table indexed by the clock selected
+ * - set the correct hwif->ultra_mask for each individual chip
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -391,7 +392,7 @@ enum ata_clock {
 
 struct hpt_info {
 	u8 chip_type;		/* Chip type */
-	u8 max_mode;		/* Speeds allowed */
+	u8 max_ultra;		/* Max. UltraDMA mode allowed */
 	u8 dpll_clk;		/* DPLL clock in MHz */
 	u8 pci_clk;		/* PCI  clock in MHz */
 	u32 **settings; 	/* Chipset settings table */
@@ -430,77 +431,77 @@ static u32 *hpt37x_settings[NUM_ATA_CLOCKS] = {
 
 static struct hpt_info hpt36x __devinitdata = {
 	.chip_type	= HPT36x,
-	.max_mode	= (HPT366_ALLOW_ATA66_4 || HPT366_ALLOW_ATA66_3) ? 2 : 1,
+	.max_ultra	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? 4 : 3) : 2,
 	.dpll_clk	= 0,	/* no DPLL */
 	.settings	= hpt36x_settings
 };
 
 static struct hpt_info hpt370 __devinitdata = {
 	.chip_type	= HPT370,
-	.max_mode	= HPT370_ALLOW_ATA100_5 ? 3 : 2,
+	.max_ultra	= HPT370_ALLOW_ATA100_5 ? 5 : 4,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt370a __devinitdata = {
 	.chip_type	= HPT370A,
-	.max_mode	= HPT370_ALLOW_ATA100_5 ? 3 : 2,
+	.max_ultra	= HPT370_ALLOW_ATA100_5 ? 5 : 4,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt374 __devinitdata = {
 	.chip_type	= HPT374,
-	.max_mode	= 3,
+	.max_ultra	= 5,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372 __devinitdata = {
 	.chip_type	= HPT372,
-	.max_mode	= HPT372_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 55,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372a __devinitdata = {
 	.chip_type	= HPT372A,
-	.max_mode	= HPT372_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt302 __devinitdata = {
 	.chip_type	= HPT302,
-	.max_mode	= HPT302_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371 __devinitdata = {
 	.chip_type	= HPT371,
-	.max_mode	= HPT371_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT371_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 66,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt372n __devinitdata = {
 	.chip_type	= HPT372N,
-	.max_mode	= HPT372_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT372_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt302n __devinitdata = {
 	.chip_type	= HPT302N,
-	.max_mode	= HPT302_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT302_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371n __devinitdata = {
 	.chip_type	= HPT371N,
-	.max_mode	= HPT371_ALLOW_ATA133_6 ? 4 : 3,
+	.max_ultra	= HPT371_ALLOW_ATA133_6 ? 6 : 5,
 	.dpll_clk	= 77,
 	.settings	= hpt37x_settings
 };
@@ -523,53 +524,38 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
-	u8 chip_type		= info->chip_type;
-	u8 mode			= info->max_mode;
 	u8 mask;
 
-	switch (mode) {
-		case 0x04:
-			mask = 0x7f;
-			break;
-		case 0x03:
+	switch (info->chip_type) {
+	case HPT370A:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			return 0x1f;
+		else
+			return 0x3f;
+	case HPT370:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			mask = 0x1f;
+		else
 			mask = 0x3f;
-			if (chip_type >= HPT374)
-				break;
-			if (!check_in_drive_list(drive, bad_ata100_5))
-				goto check_bad_ata33;
-			/* fall thru */
-		case 0x02:
+		break;
+	case HPT36x:
+		if (!HPT366_ALLOW_ATA66_4 ||
+		    check_in_drive_list(drive, bad_ata66_4))
+			mask = 0x0f;
+		else
 			mask = 0x1f;
 
-			/*
-			 * CHECK ME, Does this need to be changed to HPT374 ??
-			 */
-			if (chip_type >= HPT370)
-				goto check_bad_ata33;
-			if (HPT366_ALLOW_ATA66_4 &&
-			    !check_in_drive_list(drive, bad_ata66_4))
-				goto check_bad_ata33;
-
-			mask = 0x0f;
-			if (HPT366_ALLOW_ATA66_3 &&
-			    !check_in_drive_list(drive, bad_ata66_3))
-				goto check_bad_ata33;
-			/* fall thru */
-		case 0x01:
+		if (!HPT366_ALLOW_ATA66_3 ||
+		    check_in_drive_list(drive, bad_ata66_3))
 			mask = 0x07;
-
-		check_bad_ata33:
-			if (chip_type >= HPT370A)
-				break;
-			if (!check_in_drive_list(drive, bad_ata33))
-				break;
-			/* fall thru */
-		case 0x00:
-		default:
-			mask = 0x00;
-			break;
+		break;
+	default:
+		return 0x7f;
 	}
-	return mask;
+
+	return check_in_drive_list(drive, bad_ata33) ? 0x00 : mask;
 }
 
 static u32 get_speed_setting(u8 speed, struct hpt_info *info)
@@ -737,7 +723,7 @@ static int hpt366_config_drive_xfer_rate(ide_drive_t *drive)
  * This is specific to the HPT366 UDMA chipset
  * by HighPoint|Triones Technologies, Inc.
  */
-static int hpt366_ide_dma_lostirq(ide_drive_t *drive)
+static void hpt366_dma_lost_irq(ide_drive_t *drive)
 {
 	struct pci_dev *dev = HWIF(drive)->pci_dev;
 	u8 mcr1 = 0, mcr3 = 0, scr1 = 0;
@@ -749,7 +735,7 @@ static int hpt366_ide_dma_lostirq(ide_drive_t *drive)
 		drive->name, __FUNCTION__, mcr1, mcr3, scr1);
 	if (scr1 & 0x10)
 		pci_write_config_byte(dev, 0x5a, scr1 & ~0x10);
-	return __ide_dma_lostirq(drive);
+	ide_dma_lost_irq(drive);
 }
 
 static void hpt370_clear_engine(ide_drive_t *drive)
@@ -799,10 +785,10 @@ static int hpt370_ide_dma_end(ide_drive_t *drive)
 	return __ide_dma_end(drive);
 }
 
-static int hpt370_ide_dma_timeout(ide_drive_t *drive)
+static void hpt370_dma_timeout(ide_drive_t *drive)
 {
 	hpt370_irq_timeout(drive);
-	return __ide_dma_timeout(drive);
+	ide_dma_timeout(drive);
 }
 
 /* returns 1 if DMA IRQ issued, 0 otherwise */
@@ -1150,7 +1136,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		  * Select 66 MHz DPLL clock only if UltraATA/133 mode is
 		  * supported/enabled, use 50 MHz DPLL clock otherwise...
 		  */
-		if (info->max_mode == 0x04) {
+		if (info->max_ultra == 6) {
 			dpll_clk = 66;
 			clock = ATA_CLOCK_66MHZ;
 		} else if (dpll_clk) {	/* HPT36x chips don't have DPLL */
@@ -1243,7 +1229,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	struct pci_dev	*dev		= hwif->pci_dev;
 	struct hpt_info *info		= pci_get_drvdata(dev);
 	int serialize			= HPT_SERIALIZE_IO;
-	u8  scr1 = 0, ata66		= (hwif->channel) ? 0x01 : 0x02;
+	u8  scr1 = 0, ata66		= hwif->channel ? 0x01 : 0x02;
 	u8  chip_type			= info->chip_type;
 	u8  new_mcr, old_mcr 		= 0;
 
@@ -1256,7 +1242,9 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	hwif->intrproc			= &hpt3xx_intrproc;
 	hwif->maskproc			= &hpt3xx_maskproc;
 	hwif->busproc			= &hpt3xx_busproc;
-	hwif->udma_filter		= &hpt3xx_udma_filter;
+
+	if (chip_type <= HPT370A)
+		hwif->udma_filter	= &hpt3xx_udma_filter;
 
 	/*
 	 * HPT3xxN chips have some complications:
@@ -1305,7 +1293,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->ultra_mask = 0x7f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
 	/*
@@ -1342,8 +1330,8 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	} else
 		pci_read_config_byte (dev, 0x5a, &scr1);
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (scr1 & ata66) ? 0 : 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	hwif->ide_dma_check		= &hpt366_config_drive_xfer_rate;
 
@@ -1353,9 +1341,9 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	} else if (chip_type >= HPT370) {
 		hwif->dma_start 	= &hpt370_ide_dma_start;
 		hwif->ide_dma_end	= &hpt370_ide_dma_end;
-		hwif->ide_dma_timeout	= &hpt370_ide_dma_timeout;
+		hwif->dma_timeout	= &hpt370_dma_timeout;
 	} else
-		hwif->ide_dma_lostirq	= &hpt366_ide_dma_lostirq;
+		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
 
 	if (!noautodma)
 		hwif->autodma = 1;
@@ -1503,9 +1491,35 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
 
-	if (rev > 6)
+	switch (rev) {
+	case 0:
+	case 1:
+	case 2:
+		/*
+		 * HPT36x chips have one channel per function and have
+		 * both channel enable bits located differently and visible
+		 * to both functions -- really stupid design decision... :-(
+		 * Bit 4 is for the primary channel, bit 5 for the secondary.
+		 */
+		d->channels = 1;
+		d->enablebits[0].mask = d->enablebits[0].val = 0x10;
+
+		d->udma_mask = HPT366_ALLOW_ATA66_3 ?
+			      (HPT366_ALLOW_ATA66_4 ? 0x1f : 0x0f) : 0x07;
+		break;
+	case 3:
+	case 4:
+		d->udma_mask = HPT370_ALLOW_ATA100_5 ? 0x3f : 0x1f;
+		break;
+	default:
 		rev = 6;
-		
+		/* fall thru */
+	case 5:
+	case 6:
+		d->udma_mask = HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f;
+		break;
+	}
+
 	d->name = chipset_names[rev];
 
 	pci_set_drvdata(dev, info[rev]);
@@ -1513,15 +1527,6 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 	if (rev > 2)
 		goto init_single;
 
-	/*
-	 * HPT36x chips have one channel per function and have
-	 * both channel enable bits located differently and visible
-	 * to both functions -- really stupid design decision... :-(
-	 * Bit 4 is for the primary channel, bit 5 for the secondary.
-	 */
-	d->channels = 1;
-	d->enablebits[0].mask = d->enablebits[0].val = 0x10;
-
 	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
 		u8  mcr1 = 0, pin1 = 0, pin2 = 0;
 		int ret;
@@ -1573,6 +1578,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
 		.extra		= 240
 	},{	/* 2 */
@@ -1584,6 +1590,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
+		.udma_mask	= HPT302_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
 		.extra		= 240
 	},{	/* 3 */
@@ -1595,6 +1602,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
+		.udma_mask	= HPT371_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
 		.extra		= 240
 	},{	/* 4 */
@@ -1606,6 +1614,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.channels	= 2,	/* 4 */
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
+		.udma_mask	= 0x3f,
 		.bootable	= OFF_BOARD,
 		.extra		= 240
 	},{	/* 5 */
@@ -1617,6 +1626,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.channels	= 2,	/* 4 */
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
 		.extra		= 240
 	}
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index c04a026..ff48c23 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -231,7 +231,7 @@ static int it8213_config_drive_for_dma (ide_drive_t *drive)
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
-	u8 reg42h = 0, ata66 = 0;
+	u8 reg42h = 0;
 
 	hwif->speedproc = &it8213_tune_chipset;
 	hwif->tuneproc	= &it8213_tuneproc;
@@ -250,11 +250,11 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	hwif->swdma_mask = 0x04;
 
 	pci_read_config_byte(hwif->pci_dev, 0x42, &reg42h);
-	ata66 = (reg42h & 0x02) ? 0 : 1;
 
 	hwif->ide_dma_check = &it8213_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66;
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	/*
 	 *	The BIOS often doesn't set up DMA on this controller
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 3aeb7f1..8197b65 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -491,10 +491,10 @@ static int it821x_config_drive_for_dma (ide_drive_t *drive)
  *	the needed logic onboard.
  */
 
-static unsigned int __devinit ata66_it821x(ide_hwif_t *hwif)
+static u8 __devinit ata66_it821x(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
-	return 1;
+	return ATA_CBL_PATA80;
 }
 
 /**
@@ -662,8 +662,9 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check = &it821x_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_it821x(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_it821x(hwif);
 
 	/*
 	 *	The BIOS often doesn't set up DMA on this controller
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 76ed251..a6008f6 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -25,10 +25,10 @@ typedef enum {
  *	ata66_jmicron		-	Cable check
  *	@hwif: IDE port
  *
- *	Return 1 if the cable is 80pin
+ *	Returns the cable type.
  */
 
-static int __devinit ata66_jmicron(ide_hwif_t *hwif)
+static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = hwif->pci_dev;
 
@@ -70,16 +70,17 @@ static int __devinit ata66_jmicron(ide_hwif_t *hwif)
 	{
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
-			return 0;
-		return 1;
+			return ATA_CBL_PATA40;
+		return ATA_CBL_PATA80;
 	case PORT_PATA1:
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
-			return 0;
-		return 1;
+			return ATA_CBL_PATA40;
+		return ATA_CBL_PATA80;
 	case PORT_SATA:
 		break;
 	}
-	return 1; /* Avoid bogus "control reaches end of non-void function" */
+	/* Avoid bogus "control reaches end of non-void function" */
+	return ATA_CBL_PATA80;
 }
 
 static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
@@ -159,8 +160,9 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check = &jmicron_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_jmicron(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_jmicron(hwif);
 
 	hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->autodma;
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 0765dce..ee5020d 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -225,7 +225,10 @@ static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
 
 static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 {
-	return get_indexed_reg(hwif, 0x0b) & 0x04;
+	if (get_indexed_reg(hwif, 0x0b) & 0x04)
+		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
 }
 
 static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
@@ -509,8 +512,8 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 
 	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = pdcnew_cable_detect(hwif) ? 0 : 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = pdcnew_cable_detect(hwif);
 
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 2384468..41ac4a9 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -152,8 +152,10 @@ static void pdc202xx_tune_drive(ide_drive_t *drive, u8 pio)
 static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
 {
 	u16 CIS = 0, mask = (hwif->channel) ? (1<<11) : (1<<10);
+
 	pci_read_config_word(hwif->pci_dev, 0x50, &CIS);
-	return (CIS & mask) ? 1 : 0;
+
+	return (CIS & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
 /*
@@ -267,18 +269,24 @@ somebody_else:
 	return (dma_stat & 4) == 4;	/* return 1 if INTR asserted */
 }
 
-static int pdc202xx_ide_dma_lostirq(ide_drive_t *drive)
+static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
 {
-	if (HWIF(drive)->resetproc != NULL)
-		HWIF(drive)->resetproc(drive);
-	return __ide_dma_lostirq(drive);
+	ide_hwif_t *hwif = HWIF(drive);
+
+	if (hwif->resetproc != NULL)
+		hwif->resetproc(drive);
+
+	ide_dma_lost_irq(drive);
 }
 
-static int pdc202xx_ide_dma_timeout(ide_drive_t *drive)
+static void pdc202xx_dma_timeout(ide_drive_t *drive)
 {
-	if (HWIF(drive)->resetproc != NULL)
-		HWIF(drive)->resetproc(drive);
-	return __ide_dma_timeout(drive);
+	ide_hwif_t *hwif = HWIF(drive);
+
+	if (hwif->resetproc != NULL)
+		hwif->resetproc(drive);
+
+	ide_dma_timeout(drive);
 }
 
 static void pdc202xx_reset_host (ide_hwif_t *hwif)
@@ -347,12 +355,13 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	hwif->err_stops_fifo = 1;
 
 	hwif->ide_dma_check = &pdc202xx_config_drive_xfer_rate;
-	hwif->ide_dma_lostirq = &pdc202xx_ide_dma_lostirq;
-	hwif->ide_dma_timeout = &pdc202xx_ide_dma_timeout;
+	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
+	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		if (!(hwif->udma_four))
-			hwif->udma_four = (pdc202xx_old_cable_detect(hwif)) ? 0 : 1;
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = pdc202xx_old_cable_detect(hwif);
+
 		hwif->dma_start = &pdc202xx_old_ide_dma_start;
 		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
 	} 
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 8b219dd..2e0b29e 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.47	February 8, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.50	Jun 10, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -394,14 +394,45 @@ static void piix_dma_clear_irq(ide_drive_t *drive)
 	hwif->OUTB(dma_stat, hwif->dma_status);
 }
 
-static int __devinit piix_cable_detect(ide_hwif_t *hwif)
+struct ich_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+/*
+ *	List of laptops that use short cables rather than 80 wire
+ */
+
+static const struct ich_laptop ich_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
+	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
+	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
+	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
+	/* end marker */
+	{ 0, }
+};
+
+static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *pdev = hwif->pci_dev;
+	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
 
-	pci_read_config_byte(dev, 0x54, &reg54h);
+	/* check for specials */
+	while (lap->device) {
+		if (lap->device == pdev->device &&
+		    lap->subvendor == pdev->subsystem_vendor &&
+		    lap->subdevice == pdev->subsystem_device) {
+			return ATA_CBL_PATA40_SHORT;
+		}
+		lap++;
+	}
+
+	pci_read_config_byte(pdev, 0x54, &reg54h);
 
-	return (reg54h & mask) ? 1 : 0;
+	return (reg54h & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /**
@@ -444,8 +475,8 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 	hwif->swdma_mask = 0x04;
 
 	if (hwif->ultra_mask & 0x78) {
-		if (!hwif->udma_four)
-			hwif->udma_four = piix_cable_detect(hwif);
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = piix_cable_detect(hwif);
 	}
 
 	if (no_piix_dma)
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 55bc0a3..7b87488 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -716,7 +716,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->atapi_dma = 1;
 
 	/* we support 80c cable only. */
-	hwif->udma_four = 1;
+	hwif->cbl = ATA_CBL_PATA80;
 
 	hwif->autodma = 0;
 	if (!noautodma)
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index d9c4fd1..1371b5b 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.11	Jun 2 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.20	Jun 3 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -151,84 +151,11 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	if(dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4 &&
 		drive->media == ide_disk && speed >= XFER_UDMA_0)
 			BUG();
-			
-	pci_read_config_byte(dev, drive_pci[drive->dn], &pio_timing);
-	pci_read_config_byte(dev, drive_pci2[drive->dn], &dma_timing);
+
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
 	pci_read_config_word(dev, 0x4A, &csb5_pio);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
-	/* If we are in RAID mode (eg AMI MegaIDE) then we can't it
-	   turns out trust the firmware configuration */
-
-	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
-		goto oem_setup_failed;
-
-	/* Per Specified Design by OEM, and ASIC Architect */
-	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
-	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) {
-		if (!drive->init_speed) {
-			u8 dma_stat = inb(hwif->dma_status);
-
-			if (((ultra_enable << (7-drive->dn) & 0x80) == 0x80) &&
-			    ((dma_stat & (1<<(5+unit))) == (1<<(5+unit)))) {
-				drive->current_speed = drive->init_speed = XFER_UDMA_0 + udma_modes[(ultra_timing >> (4*unit)) & ~(0xF0)];
-				return 0;
-			} else if ((dma_timing) &&
-				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
-				u8 dmaspeed;
-
-				switch (dma_timing & 0x77) {
-				case 0x20:
-					dmaspeed = XFER_MW_DMA_2;
-					break;
-				case 0x21:
-					dmaspeed = XFER_MW_DMA_1;
-					break;
-				case 0x77:
-					dmaspeed = XFER_MW_DMA_0;
-					break;
-				default:
-					goto dma_pio;
-				}
-
-				drive->current_speed = drive->init_speed = dmaspeed;
-				return 0;
-			}
-dma_pio:
-			if (pio_timing) {
-				u8 piospeed;
-
-				switch (pio_timing & 0x7f) {
-				case 0x20:
-					piospeed = XFER_PIO_4;
-					break;
-				case 0x22:
-					piospeed = XFER_PIO_3;
-					break;
-				case 0x34:
-					piospeed = XFER_PIO_2;
-					break;
-				case 0x47:
-					piospeed = XFER_PIO_1;
-					break;
-				case 0x5d:
-					piospeed = XFER_PIO_0;
-					break;
-				default:
-					goto oem_setup_failed;
-				}
-
-				drive->current_speed = drive->init_speed = piospeed;
-				return 0;
-			}
-		}
-	}
-
-oem_setup_failed:
-
-	pio_timing	= 0;
-	dma_timing	= 0;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
@@ -402,9 +329,9 @@ static unsigned int __devinit init_chipset_svwks (struct pci_dev *dev, const cha
 	return dev->irq;
 }
 
-static unsigned int __devinit ata66_svwks_svwks (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_svwks(ide_hwif_t *hwif)
 {
-	return 1;
+	return ATA_CBL_PATA80;
 }
 
 /* On Dell PowerEdge servers with a CSB5/CSB6, the top two bits
@@ -414,7 +341,7 @@ static unsigned int __devinit ata66_svwks_svwks (ide_hwif_t *hwif)
  * Bit 14 clear = primary IDE channel does not have 80-pin cable.
  * Bit 14 set   = primary IDE channel has 80-pin cable.
  */
-static unsigned int __devinit ata66_svwks_dell (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_dell(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
@@ -422,8 +349,8 @@ static unsigned int __devinit ata66_svwks_dell (ide_hwif_t *hwif)
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE ||
 	     dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE))
 		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? 1 : 0;
-	return 0;
+			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
 /* Sun Cobalt Alpine hardware avoids the 80-pin cable
@@ -432,18 +359,18 @@ static unsigned int __devinit ata66_svwks_dell (ide_hwif_t *hwif)
  *
  * WARNING: this only works on Alpine hardware!
  */
-static unsigned int __devinit ata66_svwks_cobalt (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_cobalt(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_SUN &&
 	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
 	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? 1 : 0;
-	return 0;
+			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
-static unsigned int __devinit ata66_svwks (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 
@@ -462,9 +389,9 @@ static unsigned int __devinit ata66_svwks (ide_hwif_t *hwif)
 	/* Per Specified Design by OEM, and ASIC Architect */
 	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2))
-		return 1;
+		return ATA_CBL_PATA80;
 
-	return 0;
+	return ATA_CBL_PATA40;
 }
 
 static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
@@ -495,8 +422,8 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 
 	hwif->ide_dma_check = &svwks_config_drive_xfer_rate;
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
-		if (!hwif->udma_four)
-			hwif->udma_four = ata66_svwks(hwif);
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = ata66_svwks(hwif);
 	}
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index d3185e2..d396b29 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -316,14 +316,6 @@ static void sgiioc4_dma_host_off(ide_drive_t * drive)
 	sgiioc4_clearirq(drive);
 }
 
-static int
-sgiioc4_ide_dma_lostirq(ide_drive_t * drive)
-{
-	HWIF(drive)->resetproc(drive);
-
-	return __ide_dma_lostirq(drive);
-}
-
 static void
 sgiioc4_resetproc(ide_drive_t * drive)
 {
@@ -331,6 +323,14 @@ sgiioc4_resetproc(ide_drive_t * drive)
 	sgiioc4_clearirq(drive);
 }
 
+static void
+sgiioc4_dma_lost_irq(ide_drive_t * drive)
+{
+	sgiioc4_resetproc(drive);
+
+	ide_dma_lost_irq(drive);
+}
+
 static u8
 sgiioc4_INB(unsigned long port)
 {
@@ -607,8 +607,8 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
 	hwif->dma_host_on = &sgiioc4_dma_host_on;
 	hwif->dma_host_off = &sgiioc4_dma_host_off;
-	hwif->ide_dma_lostirq = &sgiioc4_ide_dma_lostirq;
-	hwif->ide_dma_timeout = &__ide_dma_timeout;
+	hwif->dma_lost_irq = &sgiioc4_dma_lost_irq;
+	hwif->dma_timeout = &ide_dma_timeout;
 
 	hwif->INB = &sgiioc4_INB;
 }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 1a4444e..1c3e354 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -933,16 +933,17 @@ static void __devinit init_iops_siimage(ide_hwif_t *hwif)
  *	interface.
  */
 
-static unsigned int __devinit ata66_siimage(ide_hwif_t *hwif)
+static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 {
 	unsigned long addr = siimage_selreg(hwif, 0);
-	if (pci_get_drvdata(hwif->pci_dev) == NULL) {
-		u8 ata66 = 0;
+	u8 ata66 = 0;
+
+	if (pci_get_drvdata(hwif->pci_dev) == NULL)
 		pci_read_config_byte(hwif->pci_dev, addr, &ata66);
-		return (ata66 & 0x01) ? 1 : 0;
-	}
+	else
+		ata66 = hwif->INB(addr);
 
-	return (hwif->INB(addr) & 0x01) ? 1 : 0;
+	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /**
@@ -988,8 +989,9 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		hwif->atapi_dma = 1;
 
 	hwif->ide_dma_check = &siimage_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_siimage(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_siimage(hwif);
 
 	if (hwif->mmio) {
 		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index ec0adad..f875183 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.20	Mar 4, 2007
+ * linux/drivers/ide/pci/sis5513.c	Version 0.25	Jun 10, 2007
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
@@ -796,10 +796,33 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 	return 0;
 }
 
-static unsigned int __devinit ata66_sis5513 (ide_hwif_t *hwif)
+struct sis_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+static const struct sis_laptop sis_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	/* end marker */
+	{ 0, }
+};
+
+static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 {
+	struct pci_dev *pdev = hwif->pci_dev;
+	const struct sis_laptop *lap = &sis_laptop[0];
 	u8 ata66 = 0;
 
+	while (lap->device) {
+		if (lap->device == pdev->device &&
+		    lap->subvendor == pdev->subsystem_vendor &&
+		    lap->subdevice == pdev->subsystem_device)
+			return ATA_CBL_PATA40_SHORT;
+		lap++;
+	}
+
 	if (chipset_family >= ATA_133) {
 		u16 regw = 0;
 		u16 reg_addr = hwif->channel ? 0x52: 0x50;
@@ -811,7 +834,8 @@ static unsigned int __devinit ata66_sis5513 (ide_hwif_t *hwif)
 		pci_read_config_byte(hwif->pci_dev, 0x48, &reg48h);
 		ata66 = (reg48h & mask) ? 0 : 1;
 	}
-        return ata66;
+
+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
@@ -841,8 +865,8 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	if (!chipset_family)
 		return;
 
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_sis5513(hwif);
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_sis5513(hwif);
 
 	if (chipset_family > ATA_16) {
 		hwif->ide_dma_check = &sis5513_config_xfer_rate;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 7c383d9..4878798 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -195,7 +195,7 @@ static inline void sl82c105_reset_host(struct pci_dev *dev)
  * This function is called when the IDE timer expires, the drive
  * indicates that it is READY, and we were waiting for DMA to complete.
  */
-static int sl82c105_ide_dma_lostirq(ide_drive_t *drive)
+static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -222,9 +222,6 @@ static int sl82c105_ide_dma_lostirq(ide_drive_t *drive)
 	}
 
 	sl82c105_reset_host(dev);
-
-	/* __ide_dma_lostirq would return 1, so we do as well */
-	return 1;
 }
 
 /*
@@ -244,15 +241,12 @@ static void sl82c105_dma_start(ide_drive_t *drive)
 	ide_dma_start(drive);
 }
 
-static int sl82c105_ide_dma_timeout(ide_drive_t *drive)
+static void sl82c105_dma_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	DBG(("sl82c105_dma_timeout(drive:%s)\n", drive->name));
 
-	DBG(("sl82c105_ide_dma_timeout(drive:%s)\n", drive->name));
-
-	sl82c105_reset_host(dev);
-	return __ide_dma_timeout(drive);
+	sl82c105_reset_host(HWIF(drive)->pci_dev);
+	ide_dma_timeout(drive);
 }
 
 static int sl82c105_ide_dma_on(ide_drive_t *drive)
@@ -441,9 +435,9 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	hwif->ide_dma_check		= &sl82c105_ide_dma_check;
 	hwif->ide_dma_on		= &sl82c105_ide_dma_on;
 	hwif->dma_off_quietly		= &sl82c105_dma_off_quietly;
-	hwif->ide_dma_lostirq		= &sl82c105_ide_dma_lostirq;
+	hwif->dma_lost_irq		= &sl82c105_dma_lost_irq;
 	hwif->dma_start			= &sl82c105_dma_start;
-	hwif->ide_dma_timeout		= &sl82c105_ide_dma_timeout;
+	hwif->dma_timeout		= &sl82c105_dma_timeout;
 
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index c40f291..575dbbd 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -199,10 +199,9 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	if (!hwif->udma_four) {
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		/* bit[0(1)]: 0:80, 1:40 */
-		hwif->udma_four = (reg47 & mask) ? 0 : 1;
-	}
+		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	hwif->ide_dma_check = &slc90e66_config_drive_xfer_rate;
 
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index cee619b..8de1f8e 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -220,13 +220,13 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->ide_dma_check	= &tc86c001_config_drive_xfer_rate;
 	hwif->dma_start 	= &tc86c001_dma_start;
 
-	if (!hwif->udma_four) {
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		/*
 		 * System Control  1 Register bit 13 (PDIAGN):
 		 * 0=80-pin cable, 1=40-pin cable
 		 */
 		scr1 = hwif->INW(sc_base + 0x00);
-		hwif->udma_four = (scr1 & 0x2000) ? 0 : 1;
+		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
 
 	if (!noautodma)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index a508550..d21dd2e 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.38
+ * Version 3.45
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -9,6 +9,7 @@
  *   vt8235, vt8237, vt8237a
  *
  * Copyright (c) 2000-2002 Vojtech Pavlik
+ * Copyright (c) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based on the work of:
  *	Michel Aubry
@@ -33,6 +34,8 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/dmi.h>
+
 #include <asm/io.h>
 
 #ifdef CONFIG_PPC_CHRP
@@ -41,8 +44,6 @@
 
 #include "ide-timing.h"
 
-#define DISPLAY_VIA_TIMINGS
-
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
@@ -54,18 +55,12 @@
 #define VIA_ADDRESS_SETUP	0x4c
 #define VIA_UDMA_TIMING		0x50
 
-#define VIA_UDMA		0x007
-#define VIA_UDMA_NONE		0x000
-#define VIA_UDMA_33		0x001
-#define VIA_UDMA_66		0x002
-#define VIA_UDMA_100		0x003
-#define VIA_UDMA_133		0x004
-#define VIA_BAD_PREQ		0x010	/* Crashes if PREQ# till DDACK# set */
-#define VIA_BAD_CLK66		0x020	/* 66 MHz clock doesn't work correctly */
-#define VIA_SET_FIFO		0x040	/* Needs to have FIFO split set */
-#define VIA_NO_UNMASK		0x080	/* Doesn't work with IRQ unmasking on */
-#define VIA_BAD_ID		0x100	/* Has wrong vendor ID (0x1107) */
-#define VIA_BAD_AST		0x200	/* Don't touch Address Setup Timing */
+#define VIA_BAD_PREQ		0x01 /* Crashes if PREQ# till DDACK# set */
+#define VIA_BAD_CLK66		0x02 /* 66 MHz clock doesn't work correctly */
+#define VIA_SET_FIFO		0x04 /* Needs to have FIFO split set */
+#define VIA_NO_UNMASK		0x08 /* Doesn't work with IRQ unmasking on */
+#define VIA_BAD_ID		0x10 /* Has wrong vendor ID (0x1107) */
+#define VIA_BAD_AST		0x20 /* Don't touch Address Setup Timing */
 
 /*
  * VIA SouthBridge chips.
@@ -76,36 +71,37 @@ static struct via_isa_bridge {
 	u16 id;
 	u8 rev_min;
 	u8 rev_max;
-	u16 flags;
+	u8 udma_mask;
+	u8 flags;
 } via_isa_bridges[] = {
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, VIA_UDMA_100 },
-	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, VIA_UDMA_33 | VIA_SET_FIFO | VIA_BAD_PREQ },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f, VIA_UDMA_NONE | VIA_SET_FIFO },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, ATA_UDMA5, },
+	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, ATA_UDMA5, },
+	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, ATA_UDMA2, VIA_SET_FIFO | VIA_BAD_PREQ },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
 	{ NULL }
 };
 
 static unsigned int via_clock;
-static char *via_dma[] = { "MWDMA16", "UDMA33", "UDMA66", "UDMA100", "UDMA133" };
+static char *via_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 
 struct via82cxxx_dev
 {
@@ -140,12 +136,12 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 	pci_write_config_byte(dev, VIA_DRIVE_TIMING + (3 - dn),
 		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
 
-	switch (vdev->via_config->flags & VIA_UDMA) {
-		case VIA_UDMA_33:  t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-		case VIA_UDMA_66:  t = timing->udma ? (0xe8 | (FIT(timing->udma, 2, 9) - 2)) : 0x0f; break;
-		case VIA_UDMA_100: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
-		case VIA_UDMA_133: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
-		default: return;
+	switch (vdev->via_config->udma_mask) {
+	case ATA_UDMA2: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xe8 | (FIT(timing->udma, 2, 9) - 2)) : 0x0f; break;
+	case ATA_UDMA5: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA6: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
+	default: return;
 	}
 
 	pci_write_config_byte(dev, VIA_UDMA_TIMING + (3 - dn), t);
@@ -173,12 +169,12 @@ static int via_set_drive(ide_drive_t *drive, u8 speed)
 
 	T = 1000000000 / via_clock;
 
-	switch (vdev->via_config->flags & VIA_UDMA) {
-		case VIA_UDMA_33:   UT = T;   break;
-		case VIA_UDMA_66:   UT = T/2; break;
-		case VIA_UDMA_100:  UT = T/3; break;
-		case VIA_UDMA_133:  UT = T/4; break;
-		default: UT = T;
+	switch (vdev->via_config->udma_mask) {
+	case ATA_UDMA2: UT = T;   break;
+	case ATA_UDMA4: UT = T/2; break;
+	case ATA_UDMA5: UT = T/3; break;
+	case ATA_UDMA6: UT = T/4; break;
+	default:	UT = T;
 	}
 
 	ide_timing_compute(drive, speed, &t, T, UT);
@@ -208,8 +204,7 @@ static int via_set_drive(ide_drive_t *drive, u8 speed)
 static void via82cxxx_tune_drive(ide_drive_t *drive, u8 pio)
 {
 	if (pio == 255) {
-		via_set_drive(drive,
-			ide_find_best_mode(drive, XFER_PIO | XFER_EPIO));
+		via_set_drive(drive, ide_find_best_pio_mode(drive));
 		return;
 	}
 
@@ -226,16 +221,10 @@ static void via82cxxx_tune_drive(ide_drive_t *drive, u8 pio)
  
 static int via82cxxx_ide_dma_check (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
-	u16 w80 = hwif->udma_four;
+	u8 speed = ide_max_dma_mode(drive);
 
-	u16 speed = ide_find_best_mode(drive,
-		XFER_PIO | XFER_EPIO | XFER_SWDMA | XFER_MWDMA |
-		(vdev->via_config->flags & VIA_UDMA ? XFER_UDMA : 0) |
-		(w80 && (vdev->via_config->flags & VIA_UDMA) >= VIA_UDMA_66 ? XFER_UDMA_66 : 0) |
-		(w80 && (vdev->via_config->flags & VIA_UDMA) >= VIA_UDMA_100 ? XFER_UDMA_100 : 0) |
-		(w80 && (vdev->via_config->flags & VIA_UDMA) >= VIA_UDMA_133 ? XFER_UDMA_133 : 0));
+	if (speed == 0)
+		speed = ide_find_best_pio_mode(drive);
 
 	via_set_drive(drive, speed);
 
@@ -272,8 +261,8 @@ static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 {
 	int i;
 
-	switch (vdev->via_config->flags & VIA_UDMA) {
-		case VIA_UDMA_66:
+	switch (vdev->via_config->udma_mask) {
+		case ATA_UDMA4:
 			for (i = 24; i >= 0; i -= 8)
 				if (((u >> (i & 16)) & 8) &&
 				    ((u >> i) & 0x20) &&
@@ -286,7 +275,7 @@ static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 				}
 			break;
 
-		case VIA_UDMA_100:
+		case ATA_UDMA5:
 			for (i = 24; i >= 0; i -= 8)
 				if (((u >> i) & 0x10) ||
 				    (((u >> i) & 0x20) &&
@@ -298,7 +287,7 @@ static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 				}
 			break;
 
-		case VIA_UDMA_133:
+		case ATA_UDMA6:
 			for (i = 24; i >= 0; i -= 8)
 				if (((u >> i) & 0x10) ||
 				    (((u >> i) & 0x20) &&
@@ -353,7 +342,7 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
 
 	via_cable_detect(vdev, u);
 
-	if ((via_config->flags & VIA_UDMA) == VIA_UDMA_66) {
+	if (via_config->udma_mask == ATA_UDMA4) {
 		/* Enable Clk66 */
 		pci_write_config_dword(dev, VIA_UDMA_TIMING, u|0x80008);
 	} else if (via_config->flags & VIA_BAD_CLK66) {
@@ -416,16 +405,54 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
 	 */
 
 	pci_read_config_byte(isa, PCI_REVISION_ID, &t);
-	printk(KERN_INFO "VP_IDE: VIA %s (rev %02x) IDE %s "
+	printk(KERN_INFO "VP_IDE: VIA %s (rev %02x) IDE %sDMA%s "
 		"controller on pci%s\n",
 		via_config->name, t,
-		via_dma[via_config->flags & VIA_UDMA],
+		via_config->udma_mask ? "U" : "MW",
+		via_dma[via_config->udma_mask ?
+			(fls(via_config->udma_mask) - 1) : 0],
 		pci_name(dev));
 
 	pci_dev_put(isa);
 	return 0;
 }
 
+/*
+ *	Cable special cases
+ */
+
+static struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "Acer Ferrari 3400",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
+		},
+	},
+	{ }
+};
+
+static int via_cable_override(void)
+{
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+	return 0;
+}
+
+static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
+{
+	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
+
+	if (via_cable_override())
+		return ATA_CBL_PATA40_SHORT;
+
+	if ((vdev->via_80w >> hwif->channel) & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 {
 	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
@@ -454,12 +481,14 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 		return;
 
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
+
+	hwif->ultra_mask = vdev->via_config->udma_mask;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (vdev->via_80w >> hwif->channel) & 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = via82cxxx_cable_detect(hwif);
+
 	hwif->ide_dma_check = &via82cxxx_ide_dma_check;
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 45fc36f..e46f472 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -942,8 +942,8 @@ pmac_ide_tune_chipset (ide_drive_t *drive, byte speed)
 				return 1;
 		case XFER_UDMA_4:
 		case XFER_UDMA_3:
-			if (HWIF(drive)->udma_four == 0)
-				return 1;		
+			if (drive->hwif->cbl != ATA_CBL_PATA80)
+				return 1;
 		case XFER_UDMA_2:
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
@@ -1244,7 +1244,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->chipset = ide_pmac;
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET] || pmif->mediabay;
 	hwif->hold = pmif->mediabay;
-	hwif->udma_four = pmif->cable_80;
+	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->drives[0].unmask = 1;
 	hwif->drives[1].unmask = 1;
 	hwif->tuneproc = pmac_ide_tuneproc;
@@ -1821,28 +1821,11 @@ pmac_ide_dma_check(ide_drive_t *drive)
 		enable = 0;
 
 	if (enable) {
-		short mode;
-		
-		map = XFER_MWDMA;
-		if (pmif->kind == controller_kl_ata4
-		    || pmif->kind == controller_un_ata6
-		    || pmif->kind == controller_k2_ata6
-		    || pmif->kind == controller_sh_ata6) {
-			map |= XFER_UDMA;
-			if (pmif->cable_80) {
-				map |= XFER_UDMA_66;
-				if (pmif->kind == controller_un_ata6 ||
-				    pmif->kind == controller_k2_ata6 ||
-				    pmif->kind == controller_sh_ata6)
-					map |= XFER_UDMA_100;
-				if (pmif->kind == controller_sh_ata6)
-					map |= XFER_UDMA_133;
-			}
-		}
-		mode = ide_find_best_mode(drive, map);
-		if (mode & XFER_UDMA)
+		u8 mode = ide_max_dma_mode(drive);
+
+		if (mode >= XFER_UDMA_0)
 			drive->using_dma = pmac_ide_udma_enable(drive, mode);
-		else if (mode & XFER_MWDMA)
+		else if (mode >= XFER_MW_DMA_0)
 			drive->using_dma = pmac_ide_mdma_enable(drive, mode);
 		hwif->OUTB(0, IDE_CONTROL_REG);
 		/* Apply settings to controller */
@@ -2004,20 +1987,19 @@ static void pmac_ide_dma_host_on(ide_drive_t *drive)
 {
 }
 
-static int
-pmac_ide_dma_lostirq (ide_drive_t *drive)
+static void
+pmac_ide_dma_lost_irq (ide_drive_t *drive)
 {
 	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
 	volatile struct dbdma_regs __iomem *dma;
 	unsigned long status;
 
 	if (pmif == NULL)
-		return 0;
+		return;
 	dma = pmif->dma_regs;
 
 	status = readl(&dma->status);
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
-	return 0;
 }
 
 /*
@@ -2057,8 +2039,8 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->ide_dma_test_irq = &pmac_ide_dma_test_irq;
 	hwif->dma_host_off = &pmac_ide_dma_host_off;
 	hwif->dma_host_on = &pmac_ide_dma_host_on;
-	hwif->ide_dma_timeout = &__ide_dma_timeout;
-	hwif->ide_dma_lostirq = &pmac_ide_dma_lostirq;
+	hwif->dma_timeout = &ide_dma_timeout;
+	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
 
 	hwif->atapi_dma = 1;
 	switch(pmif->kind) {
diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index 8fcae21..4663e8b 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -88,26 +88,26 @@ static const struct drive_list_entry dma_white_list [] = {
 /*
  * Hitachi
  */
-        { "HITACHI_DK14FA-20"    ,       "ALL"           },
-        { "HTS726060M9AT00"      ,       "ALL"           },
+        { "HITACHI_DK14FA-20"    ,       NULL            },
+        { "HTS726060M9AT00"      ,       NULL            },
 /*
  * Maxtor
  */
-        { "Maxtor 6E040L0"      ,       "ALL"           },
-        { "Maxtor 6Y080P0"      ,       "ALL"           },
-        { "Maxtor 6Y160P0"      ,       "ALL"           },
+        { "Maxtor 6E040L0"      ,       NULL            },
+        { "Maxtor 6Y080P0"      ,       NULL            },
+        { "Maxtor 6Y160P0"      ,       NULL            },
 /*
  * Seagate
  */
-        { "ST3120026A"          ,       "ALL"           },
-        { "ST320014A"           ,       "ALL"           },
-        { "ST94011A"            ,       "ALL"           },
-        { "ST340016A"           ,       "ALL"           },
+        { "ST3120026A"          ,       NULL            },
+        { "ST320014A"           ,       NULL            },
+        { "ST94011A"            ,       NULL            },
+        { "ST340016A"           ,       NULL            },
 /*
  * Western Digital
  */
-        { "WDC WD400UE-00HCT0"  ,       "ALL"           },
-        { "WDC WD400JB-00JJC0"  ,       "ALL"           },
+        { "WDC WD400UE-00HCT0"  ,       NULL            },
+        { "WDC WD400JB-00JJC0"  ,       NULL            },
         { NULL                  ,       NULL            }
 };
 
@@ -116,9 +116,9 @@ static const struct drive_list_entry dma_black_list [] = {
 /*
  * Western Digital
  */
-        { "WDC WD100EB-00CGH0"  ,       "ALL"           },
-        { "WDC WD200BB-00AUA1"  ,       "ALL"           },
-        { "WDC AC24300L"        ,       "ALL"           },
+        { "WDC WD100EB-00CGH0"  ,       NULL            },
+        { "WDC WD200BB-00AUA1"  ,       NULL            },
+        { "WDC AC24300L"        ,       NULL            },
         { NULL                  ,       NULL            }
 };
 #endif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 1e365ac..19ab258 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -25,6 +25,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/semaphore.h>
+#include <asm/mutex.h>
 
 /******************************************************************************
  * IDE driver configuration options (play with these as desired):
@@ -685,6 +686,8 @@ typedef struct hwif_s {
 	u8 mwdma_mask;
 	u8 swdma_mask;
 
+	u8 cbl;		/* cable type */
+
 	hwif_chipset_t chipset;	/* sub-module for tuning.. */
 
 	struct pci_dev  *pci_dev;	/* for pci chipsets */
@@ -735,8 +738,8 @@ typedef struct hwif_s {
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 	void (*dma_host_on)(ide_drive_t *drive);
 	void (*dma_host_off)(ide_drive_t *drive);
-	int (*ide_dma_lostirq)(ide_drive_t *drive);
-	int (*ide_dma_timeout)(ide_drive_t *drive);
+	void (*dma_lost_irq)(ide_drive_t *drive);
+	void (*dma_timeout)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
@@ -791,7 +794,6 @@ typedef struct hwif_s {
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	autodma    : 1;	/* auto-attempt using DMA at boot */
-	unsigned	udma_four  : 1;	/* 1=ATA-66 capable, 0=default */
 	unsigned	no_lba48   : 1; /* 1 = cannot do LBA48 */
 	unsigned	no_lba48_dma : 1; /* 1 = cannot do LBA48 DMA */
 	unsigned	auto_poll  : 1; /* supports nop auto-poll */
@@ -863,7 +865,7 @@ typedef struct hwgroup_s {
 
 typedef struct ide_driver_s ide_driver_t;
 
-extern struct semaphore ide_setting_sem;
+extern struct mutex ide_setting_mtx;
 
 int set_io_32bit(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);
@@ -1304,8 +1306,8 @@ extern int __ide_dma_check(ide_drive_t *);
 extern int ide_dma_setup(ide_drive_t *);
 extern void ide_dma_start(ide_drive_t *);
 extern int __ide_dma_end(ide_drive_t *);
-extern int __ide_dma_lostirq(ide_drive_t *);
-extern int __ide_dma_timeout(ide_drive_t *);
+extern void ide_dma_lost_irq(ide_drive_t *);
+extern void ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 #else
@@ -1382,11 +1384,11 @@ extern const ide_pio_timings_t ide_pio_timings[6];
 
 
 extern spinlock_t ide_lock;
-extern struct semaphore ide_cfg_sem;
+extern struct mutex ide_cfg_mtx;
 /*
  * Structure locking:
  *
- * ide_cfg_sem and ide_lock together protect changes to
+ * ide_cfg_mtx and ide_lock together protect changes to
  * ide_hwif_t->{next,hwgroup}
  * ide_drive_t->next
  *
