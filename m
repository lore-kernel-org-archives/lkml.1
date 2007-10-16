Return-Path: <linux-kernel-owner+w=401wt.eu-S936084AbXJPUvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936084AbXJPUvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965455AbXJPUuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:50:10 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:8607 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936070AbXJPUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JGhXQwQA/pm1r7vyUh0/bZqLKlTg5QOz236aAP9Pp3V8HCEwOAa+ER0scvfZYzdRg0qat3R7EKXVolK5+WgU/Riz3t6HQIZAHH94ObMfDRJJXfggVd/mRF/ZEeq5ibaW7AJ71fsmsg/XLIwRPbOoJxkirJXhWUtkGM3KJ4IBCsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates (part 3)
Date: Tue, 16 Oct 2007 22:50:20 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710162250.21647.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


New week, new IDE updates...

* fix serverworks UDMA regression
  (Tony Battersby <tonyb@cybernetics.com>)

* fix some host drivers to always tune PIO: hpt366, sis5513,
  aec62xx, slc90e66, ide-cris, cs5530 and sc1200

* DMA setup fixes for sis5513 and atiixp host drivers

* additional id string for ide-cs
  (Kristoffer Ericson <kristoffer.ericson@gmail.com>)

* common DMA tuning code for all host drivers: cuts ~700 LOC from
  IDE code and allows addition of "hdx=nodma" kernel parameter
  (per device DMA disable)

* and other changes...


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide.txt          |    6 +-
 drivers/ide/Kconfig            |   18 --
 drivers/ide/arm/icside.c       |   17 --
 drivers/ide/cris/ide-cris.c    |   15 +--
 drivers/ide/ide-dma.c          |   77 ++++---
 drivers/ide/ide-io.c           |    4 +-
 drivers/ide/ide-iops.c         |    4 +-
 drivers/ide/ide-lib.c          |   15 --
 drivers/ide/ide-probe.c        |   16 +--
 drivers/ide/ide.c              |   19 +-
 drivers/ide/legacy/ide-cs.c    |   12 +-
 drivers/ide/mips/au1xxx-ide.c  |   38 ++--
 drivers/ide/pci/aec62xx.c      |   36 +---
 drivers/ide/pci/alim15x3.c     |   34 +---
 drivers/ide/pci/amd74xx.c      |  197 +++---------------
 drivers/ide/pci/atiixp.c       |   93 +-------
 drivers/ide/pci/cmd64x.c       |   27 +--
 drivers/ide/pci/cs5520.c       |   25 +--
 drivers/ide/pci/cs5530.c       |   45 +----
 drivers/ide/pci/cs5535.c       |   28 +---
 drivers/ide/pci/cy82c693.c     |   12 +-
 drivers/ide/pci/generic.c      |   57 +++--
 drivers/ide/pci/hpt34x.c       |   28 +--
 drivers/ide/pci/hpt366.c       |   41 +---
 drivers/ide/pci/it8213.c       |   84 +-------
 drivers/ide/pci/it821x.c       |   50 +----
 drivers/ide/pci/jmicron.c      |   32 +---
 drivers/ide/pci/ns87415.c      |   11 +-
 drivers/ide/pci/opti621.c      |   14 +-
 drivers/ide/pci/pdc202xx_new.c |   37 +---
 drivers/ide/pci/pdc202xx_old.c |   32 +---
 drivers/ide/pci/piix.c         |  125 +++--------
 drivers/ide/pci/rz1000.c       |    6 +-
 drivers/ide/pci/sc1200.c       |   30 +--
 drivers/ide/pci/scc_pata.c     |   33 +---
 drivers/ide/pci/serverworks.c  |   33 +---
 drivers/ide/pci/sgiioc4.c      |   22 +--
 drivers/ide/pci/siimage.c      |   42 +----
 drivers/ide/pci/sis5513.c      |  462 ++++++++--------------------------------
 drivers/ide/pci/sl82c105.c     |   22 +--
 drivers/ide/pci/slc90e66.c     |   67 ++-----
 drivers/ide/pci/tc86c001.c     |   21 +--
 drivers/ide/pci/triflex.c      |   21 +--
 drivers/ide/pci/trm290.c       |   10 +-
 drivers/ide/pci/via82cxxx.c    |   37 +---
 drivers/ide/ppc/pmac.c         |   34 +---
 drivers/ide/setup-pci.c        |   48 +----
 include/linux/ide.h            |   11 +-
 48 files changed, 449 insertions(+), 1699 deletions(-)


Adrian Bunk (2):
      ide: unexport ide_tune_dma
      ide: unexport noautodma

Bartlomiej Zolnierkiewicz (29):
      hpt366: always tune PIO
      sis5513: DMA setup fixes
      sis5513: always tune PIO
      aec62xx: always tune PIO
      slc90e66: always tune PIO
      ide-cris: always tune PIO
      cs5530: always tune PIO
      sc1200: always tune PIO
      atiixp: DMA setup fixes
      it8213/piix/slc90e66: remove {it8213,piix,slc90e66}_dma_2_pio()
      au1xxx-ide: use ide_tune_dma()
      ide: remove drive->init_speed zeroing
      ide: remove ide_use_fast_pio()
      cs5530/sc1200: add PIO autotune fallback to ->ide_dma_check
      sl82c105: add PIO autotune fallback to ->ide_dma_check
      ide-cris: add PIO autotune fallback to ->ide_dma_check
      ide-pmac: add PIO autotune fallback to ->ide_dma_check
      ide: remove ->ide_dma_check (take 2)
      it8213/piix/slc90e66: "de-couple" PIO and UDMA modes
      sis5513: clear prefetch and postwrite for ATAPI devices
      ide: use PCI_VDEVICE() macro
      ide: remove CONFIG_BLK_DEV_IDEDMA_FORCED
      ide: remove "idex=dma" kernel parameter
      ide: remove hwif->autodma and drive->autodma
      ide: add "hdx=nodma" kernel parameter
      ide: remove CONFIG_IDEDMA_ONLYDISK
      sis5513: remove /proc/ide/sis
      amd74xx/via82cxxx: don't initialize drive->dn
      amd74xx: remove /proc/ide/amd74xx

Kristoffer Ericson (1):
      ide-cs: Add additional id string (corsair, 1GB)

Tony Battersby (1):
      ide: fix serverworks.c UDMA regression


diff --git a/Documentation/ide.txt b/Documentation/ide.txt
index 3bb9f9c..1d50f23 100644
--- a/Documentation/ide.txt
+++ b/Documentation/ide.txt
@@ -242,6 +242,8 @@ Summary of ide driver parameters for kernel command line
 			  and quite likely to cause trouble with
 			  older/odd IDE drives.
 
+ "hdx=nodma"		: disallow DMA
+
  "hdx=swapdata"		: when the drive is a disk, byte swap all data
 
  "hdx=bswap"		: same as above..........
@@ -278,8 +280,6 @@ Summary of ide driver parameters for kernel command line
  "idex=four"		: four drives on idex and ide(x^1) share same ports
 			
  "idex=reset"		: reset interface after probe
- 
- "idex=dma"		: automatically configure/use DMA if possible.
 
  "idex=ata66"		: informs the interface that it has an 80c cable
 			  for chipsets that are ATA-66 capable, but the
@@ -288,8 +288,6 @@ Summary of ide driver parameters for kernel command line
 
  "ide=reverse"		: formerly called to pci sub-system, but now local.
 
- "ide=nodma"		: disable DMA globally for the IDE subsystem.
-
 The following are valid ONLY on ide0, which usually corresponds
 to the first ATA interface found on the particular host, and the defaults for
 the base,ctl ports must not be altered.
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8982c09..6d9fd92 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -435,24 +435,6 @@ config BLK_DEV_IDEDMA_PCI
 	bool
 	select BLK_DEV_IDEPCI
 
-config BLK_DEV_IDEDMA_FORCED
-	bool "Force enable legacy 2.0.X HOSTS to use DMA"
-	depends on BLK_DEV_IDEDMA_PCI
-	help
-	  This is an old piece of lost code from Linux 2.0 Kernels.
-
-	  Generally say N here.
-
-# TODO: remove it
-config IDEDMA_ONLYDISK
-	bool "Enable DMA only for disks "
-	depends on BLK_DEV_IDEDMA_PCI
-	help
-	  This is used if you know your ATAPI Devices are going to fail DMA
-	  Transfers.
-
-	  Generally say N here.
-
 config BLK_DEV_AEC62XX
 	tristate "AEC62XX chipset support"
 	select BLK_DEV_IDEDMA_PCI
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index bd1f5b6..e4875ce 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -309,14 +309,6 @@ static int icside_dma_on(ide_drive_t *drive)
 	return 0;
 }
 
-static int icside_dma_check(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return -1;
-}
-
 static int icside_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -423,8 +415,6 @@ static void icside_dma_lost_irq(ide_drive_t *drive)
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	printk("    %s: SG-DMA", hwif->name);
-
 	hwif->atapi_dma		= 1;
 	hwif->mwdma_mask	= 7; /* MW0..2 */
 	hwif->swdma_mask	= 7; /* SW0..2 */
@@ -432,9 +422,7 @@ static void icside_dma_init(ide_hwif_t *hwif)
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 	hwif->set_dma_mode	= icside_set_dma_mode;
-	hwif->autodma		= 1;
 
-	hwif->ide_dma_check	= icside_dma_check;
 	hwif->dma_host_off	= icside_dma_host_off;
 	hwif->dma_off_quietly	= icside_dma_off_quietly;
 	hwif->dma_host_on	= icside_dma_host_on;
@@ -446,11 +434,6 @@ static void icside_dma_init(ide_hwif_t *hwif)
 	hwif->ide_dma_test_irq	= icside_dma_test_irq;
 	hwif->dma_timeout	= icside_dma_timeout;
 	hwif->dma_lost_irq	= icside_dma_lost_irq;
-
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-
-	printk(" capable%s\n", hwif->autodma ? ", auto-enable" : "");
 }
 #else
 #define icside_dma_init(hwif)	(0)
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index c306c9f..06c75f1 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -664,7 +664,6 @@ cris_ide_inb(unsigned long reg)
 	return (unsigned char)cris_ide_inw(reg);
 }
 
-static int cris_dma_check (ide_drive_t *drive);
 static int cris_dma_end (ide_drive_t *drive);
 static int cris_dma_setup (ide_drive_t *drive);
 static void cris_dma_exec_cmd (ide_drive_t *drive, u8 command);
@@ -792,7 +791,6 @@ init_e100_ide (void)
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
 		hwif->atapi_output_bytes = &cris_atapi_output_bytes;
-		hwif->ide_dma_check = &cris_dma_check;
 		hwif->ide_dma_end = &cris_dma_end;
 		hwif->dma_setup = &cris_dma_setup;
 		hwif->dma_exec_cmd = &cris_dma_exec_cmd;
@@ -808,11 +806,10 @@ init_e100_ide (void)
 		hwif->dma_off_quietly = &cris_dma_off;
 		hwif->cbl = ATA_CBL_PATA40;
 		hwif->pio_mask = ATA_PIO4,
+		hwif->drives[0].autotune = 1;
+		hwif->drives[1].autotune = 1;
 		hwif->ultra_mask = cris_ultra_mask;
 		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
-		hwif->autodma = 1;
-		hwif->drives[0].autodma = 1;
-		hwif->drives[1].autodma = 1;
 	}
 
 	/* Reset pulse */
@@ -1018,14 +1015,6 @@ static ide_startstop_t cris_dma_intr (ide_drive_t *drive)
  * the caller should revert to PIO for the current request.
  */
 
-static int cris_dma_check(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return -1;
-}
-
 static int cris_dma_end(ide_drive_t *drive)
 {
 	drive->waiting_for_dma = 0;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a4cbbba..bc57ce6 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -338,35 +338,30 @@ static int config_drive_for_dma (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 
-	/* consult the list of known "bad" drives */
-	if (__ide_dma_bad_drive(drive))
-		return -1;
-
 	if (drive->media != ide_disk && hwif->atapi_dma == 0)
-		return -1;
+		return 0;
 
-	if ((id->capability & 1) && drive->autodma) {
-		/*
-		 * Enable DMA on any drive that has
-		 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
-		 */
-		if ((id->field_valid & 4) && ((id->dma_ultra >> 8) & 0x7f))
-			return 0;
-		/*
-		 * Enable DMA on any drive that has mode2 DMA
-		 * (multi or single) enabled
-		 */
-		if (id->field_valid & 2)	/* regular DMA */
-			if ((id->dma_mword & 0x404) == 0x404 ||
-			    (id->dma_1word & 0x404) == 0x404)
-				return 0;
-
-		/* Consult the list of known "good" drives */
-		if (ide_dma_good_drive(drive))
-			return 0;
-	}
+	/*
+	 * Enable DMA on any drive that has
+	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
+	 */
+	if ((id->field_valid & 4) && ((id->dma_ultra >> 8) & 0x7f))
+		return 1;
+
+	/*
+	 * Enable DMA on any drive that has mode2 DMA
+	 * (multi or single) enabled
+	 */
+	if (id->field_valid & 2)	/* regular DMA */
+		if ((id->dma_mword & 0x404) == 0x404 ||
+		    (id->dma_1word & 0x404) == 0x404)
+			return 1;
+
+	/* Consult the list of known "good" drives */
+	if (ide_dma_good_drive(drive))
+		return 1;
 
-	return -1;
+	return 0;
 }
 
 /**
@@ -627,6 +622,8 @@ static int __ide_dma_test_irq(ide_drive_t *drive)
 			drive->name, __FUNCTION__);
 	return 0;
 }
+#else
+static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 int __ide_dma_bad_drive (ide_drive_t *drive)
@@ -758,17 +755,20 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 EXPORT_SYMBOL_GPL(ide_find_dma_mode);
 
-int ide_tune_dma(ide_drive_t *drive)
+static int ide_tune_dma(ide_drive_t *drive)
 {
 	u8 speed;
 
-	if ((drive->id->capability & 1) == 0 || drive->autodma == 0)
+	if (noautodma || drive->nodma || (drive->id->capability & 1) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
 	if (__ide_dma_bad_drive(drive))
 		return 0;
 
+	if (drive->hwif->host_flags & IDE_HFLAG_TRUST_BIOS_FOR_DMA)
+		return config_drive_for_dma(drive);
+
 	speed = ide_max_dma_mode(drive);
 
 	if (!speed)
@@ -783,7 +783,22 @@ int ide_tune_dma(ide_drive_t *drive)
 	return 1;
 }
 
-EXPORT_SYMBOL_GPL(ide_tune_dma);
+static int ide_dma_check(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	int vdma = (hwif->host_flags & IDE_HFLAG_VDMA)? 1 : 0;
+
+	if (!vdma && ide_tune_dma(drive))
+		return 0;
+
+	/* TODO: always do PIO fallback */
+	if (hwif->host_flags & IDE_HFLAG_TRUST_BIOS_FOR_DMA)
+		return -1;
+
+	ide_set_max_pio(drive);
+
+	return vdma ? 0 : -1;
+}
 
 void ide_dma_verbose(ide_drive_t *drive)
 {
@@ -842,7 +857,7 @@ int ide_set_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	int rc;
 
-	rc = hwif->ide_dma_check(drive);
+	rc = ide_dma_check(drive);
 
 	switch(rc) {
 	case -1: /* DMA needs to be disabled */
@@ -1019,8 +1034,6 @@ void ide_setup_dma (ide_hwif_t *hwif, unsigned long dma_base, unsigned int num_p
 		hwif->ide_dma_on = &__ide_dma_on;
 	if (!hwif->dma_host_on)
 		hwif->dma_host_on = &ide_dma_host_on;
-	if (!hwif->ide_dma_check)
-		hwif->ide_dma_check = &config_drive_for_dma;
 	if (!hwif->dma_setup)
 		hwif->dma_setup = &ide_dma_setup;
 	if (!hwif->dma_exec_cmd)
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 04273d3..ec835e3 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -219,11 +219,11 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 
 	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
 		/*
-		 * Right now, all we do is call hwif->ide_dma_check(drive),
+		 * Right now, all we do is call ide_set_dma(drive),
 		 * we could be smarter and check for current xfer_speed
 		 * in struct drive etc...
 		 */
-		if (drive->hwif->ide_dma_check == NULL)
+		if (drive->hwif->ide_dma_on == NULL)
 			break;
 		drive->hwif->dma_off_quietly(drive);
 		/*
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index aa73883..d4d790f 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -776,7 +776,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 //		msleep(50);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (hwif->ide_dma_check)	 /* check if host supports DMA */
+	if (hwif->ide_dma_on)	/* check if host supports DMA */
 		hwif->dma_host_off(drive);
 #endif
 
@@ -830,7 +830,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (speed >= XFER_SW_DMA_0)
 		hwif->dma_host_on(drive);
-	else if (hwif->ide_dma_check)	/* check if host supports DMA */
+	else if (hwif->ide_dma_on)	/* check if host supports DMA */
 		hwif->dma_off_quietly(drive);
 #endif
 
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 0e2562f..af86433 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -96,21 +96,6 @@ static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 	return min(speed, mode);
 }
 
-int ide_use_fast_pio(ide_drive_t *drive)
-{
-	struct hd_driveid *id = drive->id;
-
-	if ((id->capability & 1) && drive->autodma)
-		return 1;
-
-	if ((id->capability & 8) || (id->field_valid & 2))
-		return 1;
-
-	return 0;
-}
-
-EXPORT_SYMBOL_GPL(ide_use_fast_pio);
-
 /*
  * Standard (generic) timings for PIO modes, from ATA2 specification.
  * These timings are for access to the IDE data port register *only*.
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 34b1fb6..3c945d6 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -835,16 +835,7 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 
 			drive->nice1 = 1;
 
-			/*
-			 * MAJOR HACK BARF :-/
-			 *
-			 * FIXME: chipsets own this cruft!
-			 */
-			/*
-			 * Move here to prevent module loading clashing.
-			 */
-	//		drive->autodma = hwif->autodma;
-			if (hwif->ide_dma_check) {
+			if (hwif->ide_dma_on) {
 				/*
 				 * Force DMAing for the beginning of the check.
 				 * Some chipsets appear to do interesting
@@ -852,10 +843,7 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 				 *   PARANOIA!!!
 				 */
 				hwif->dma_off_quietly(drive);
-#ifdef CONFIG_IDEDMA_ONLYDISK
-				if (drive->media == ide_disk)
-#endif
-					ide_set_dma(drive);
+				ide_set_dma(drive);
 			}
 		}
 	}
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 5c0e407..5b09066 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -100,8 +100,6 @@ static int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
 
 int noautodma = 0;
 
-EXPORT_SYMBOL(noautodma);
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 int ide_noacpi = 0;
 int ide_noacpitfs = 1;
@@ -418,7 +416,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->dma_exec_cmd		= tmp_hwif->dma_exec_cmd;
 	hwif->dma_start			= tmp_hwif->dma_start;
 	hwif->ide_dma_end		= tmp_hwif->ide_dma_end;
-	hwif->ide_dma_check		= tmp_hwif->ide_dma_check;
 	hwif->ide_dma_on		= tmp_hwif->ide_dma_on;
 	hwif->dma_off_quietly		= tmp_hwif->dma_off_quietly;
 	hwif->ide_dma_test_irq		= tmp_hwif->ide_dma_test_irq;
@@ -461,7 +458,6 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->select_data		= tmp_hwif->select_data;
 	hwif->extra_base		= tmp_hwif->extra_base;
 	hwif->extra_ports		= tmp_hwif->extra_ports;
-	hwif->autodma			= tmp_hwif->autodma;
 
 	hwif->hwif_data			= tmp_hwif->hwif_data;
 }
@@ -823,7 +819,7 @@ int set_using_dma(ide_drive_t *drive, int arg)
 	if (!drive->id || !(drive->id->capability & 1))
 		goto out;
 
-	if (hwif->ide_dma_check == NULL)
+	if (hwif->ide_dma_on == NULL)
 		goto out;
 
 	err = -EBUSY;
@@ -1276,7 +1272,7 @@ static int __init ide_setup(char *s)
 	if (!strcmp(s, "ide=nodma")) {
 		printk(" : Prevented DMA\n");
 		noautodma = 1;
-		return 1;
+		goto obsolete_option;
 	}
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
@@ -1310,7 +1306,7 @@ static int __init ide_setup(char *s)
 	 */
 	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
 		const char *hd_words[] = {
-			"none", "noprobe", "nowerr", "cdrom", "minus5",
+			"none", "noprobe", "nowerr", "cdrom", "nodma",
 			"autotune", "noautotune", "minus8", "swapdata", "bswap",
 			"noflush", "remap", "remap63", "scsi", NULL };
 		unit = s[2] - 'a';
@@ -1338,6 +1334,9 @@ static int __init ide_setup(char *s)
 				drive->ready_stat = 0;
 				hwif->noprobe = 0;
 				goto done;
+			case -5: /* nodma */
+				drive->nodma = 1;
+				goto done;
 			case -6: /* "autotune" */
 				drive->autotune = IDE_TUNE_AUTO;
 				goto obsolete_option;
@@ -1399,7 +1398,7 @@ static int __init ide_setup(char *s)
 		 */
 		static const char *ide_words[] = {
 			"noprobe", "serialize", "minus3", "minus4",
-			"reset", "dma", "ata66", "minus8", "minus9",
+			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
 		hw = s[3] - '0';
@@ -1478,6 +1477,7 @@ static int __init ide_setup(char *s)
 			case -10: /* minus10 */
 			case -9: /* minus9 */
 			case -8: /* minus8 */
+			case -6:
 			case -4:
 			case -3:
 				goto bad_option;
@@ -1492,9 +1492,6 @@ static int __init ide_setup(char *s)
 #else
 				goto bad_hwif;
 #endif
-			case -6: /* dma */
-				hwif->autodma = 1;
-				goto obsolete_option;
 			case -5: /* "reset" */
 				hwif->reset = 1;
 				goto obsolete_option;
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 4cdb519..e8e360c 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -28,7 +28,7 @@
     and other provisions required by the GPL.  If you do not delete
     the provisions above, a recipient may use your version of this
     file under either the MPL or the GPL.
-    
+
 ======================================================================*/
 
 #include <linux/module.h>
@@ -327,13 +327,13 @@ failed:
     After a card is removed, ide_release() will unregister the net
     device, and release the PCMCIA configuration.  If the device is
     still open, this will be postponed until it is closed.
-    
+
 ======================================================================*/
 
 void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    
+
     DEBUG(0, "ide_release(0x%p)\n", link);
 
     if (info->ndev) {
@@ -353,11 +353,12 @@ void ide_release(struct pcmcia_device *link)
     stuff to run after an event is received.  A CARD_REMOVAL event
     also sets some flags to discourage the ide drivers from
     talking to the ports.
-    
+
 ======================================================================*/
 
 static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
+	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
@@ -366,7 +367,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
- 	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
+	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
@@ -384,6 +385,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("FREECOM", "PCCARD-IDE", 0x5714cbf7, 0x48e0ab8e),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "FLASH", 0xf4f43949, 0x9eb86aae),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
+	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 892d08f..47c035a 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -351,11 +351,18 @@ static int auide_dma_setup(ide_drive_t *drive)
 	return 0;
 }
 
-static int auide_dma_check(ide_drive_t *drive)
+static u8 auide_mdma_filter(ide_drive_t *drive)
 {
-	u8 speed = ide_max_dma_mode(drive);
+	/*
+	 * FIXME: ->white_list and ->black_list are based on completely bogus
+	 * ->ide_dma_check implementation which didn't set neither the host
+	 * controller timings nor the device for the desired transfer mode.
+	 *
+	 * They should be either removed or 0x00 MWDMA mask should be
+	 * returned for devices on the ->black_list.
+	 */
 
-	if( dbdma_init_done == 0 ){
+	if (dbdma_init_done == 0) {
 		auide_hwif.white_list = ide_in_drive_list(drive->id,
 							  dma_white_list);
 		auide_hwif.black_list = ide_in_drive_list(drive->id,
@@ -366,22 +373,11 @@ static int auide_dma_check(ide_drive_t *drive)
 	}
 
 	/* Is the drive in our DMA black list? */
-
-	if ( auide_hwif.black_list ) {
-		drive->using_dma = 0;
-
-		/* Borrowed the warning message from ide-dma.c */
-
+	if (auide_hwif.black_list)
 		printk(KERN_WARNING "%s: Disabling DMA for %s (blacklisted)\n",
-		       drive->name, drive->id->model);	       
-	}
-	else
-		drive->using_dma = 1;
-
-	if (drive->autodma && (speed & XFER_MODE) != XFER_PIO)
-		return 0;
+				    drive->name, drive->id->model);
 
-	return -1;
+	return drive->hwif->mwdma_mask;
 }
 
 static int auide_dma_test_irq(ide_drive_t *drive)
@@ -692,7 +688,8 @@ static int au_ide_probe(struct device *dev)
 	hwif->dma_off_quietly		= &auide_dma_off_quietly;
 	hwif->dma_timeout		= &auide_dma_timeout;
 
-	hwif->ide_dma_check             = &auide_dma_check;
+	hwif->mdma_filter		= &auide_mdma_filter;
+
 	hwif->dma_exec_cmd              = &auide_dma_exec_cmd;
 	hwif->dma_start                 = &auide_dma_start;
 	hwif->ide_dma_end               = &auide_dma_end;
@@ -703,19 +700,14 @@ static int au_ide_probe(struct device *dev)
 	hwif->dma_lost_irq		= &auide_dma_lost_irq;
 	hwif->ide_dma_on                = &auide_dma_on;
 
-	hwif->autodma                   = 1;
-	hwif->drives[0].autodma         = hwif->autodma;
-	hwif->drives[1].autodma         = hwif->autodma;
 	hwif->atapi_dma                 = 1;
 
 #else /* !CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA */
-	hwif->autodma                   = 0;
 	hwif->channel                   = 0;
 	hwif->hold                      = 1;
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
-	hwif->drives[0].autodma         = 0;
 	hwif->drives[0].autotune        = 1;    /* 1=autotune, 2=noautotune, 0=default */
 #endif
 	hwif->drives[0].no_io_32bit     = 1;   
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index d6cb2d5..3a4c2c2 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.24	May 24, 2007
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.25	Aug 1, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
@@ -141,17 +141,6 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	drive->hwif->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static void aec62xx_dma_lost_irq (ide_drive_t *drive)
 {
 	switch (HWIF(drive)->pci_dev->device) {
@@ -207,15 +196,14 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	} else
 		hwif->set_dma_mode = &aec6260_set_mode;
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check	= &aec62xx_config_drive_xfer_rate;
 	hwif->dma_lost_irq	= &aec62xx_dma_lost_irq;
 
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
@@ -230,10 +218,6 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 
 		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static int __devinit init_setup_aec62xx(struct pci_dev *dev, ide_pci_device_t *d)
@@ -325,12 +309,12 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
 	return d.init_setup(dev, &d);
 }
 
-static struct pci_device_id aec62xx_pci_tbl[] = {
-	{ PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_ATP850UF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_ATP860,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },
-	{ PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_ATP860R,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2 },
-	{ PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_ATP865,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3 },
-	{ PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_ATP865R,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4 },
+static const struct pci_device_id aec62xx_pci_tbl[] = {
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP850UF), 0 },
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP860),   1 },
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP860R),  2 },
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP865),   3 },
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP865R),  4 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, aec62xx_pci_tbl);
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 0b83443..31d4e50 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -437,26 +437,6 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	ali15x3_config_drive_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Configure a drive for DMA operation. If DMA is not possible we
- *	drop the drive into PIO mode instead.
- */
-
-static int ali15x3_config_drive_for_dma(ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
-/**
  *	ali15x3_dma_setup	-	begin a DMA phase
  *	@drive:	target device
  *
@@ -680,7 +660,6 @@ static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
  
 static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
 	hwif->set_pio_mode = &ali_set_pio_mode;
 	hwif->set_dma_mode = &ali_set_dma_mode;
 	hwif->udma_filter = &ali_udma_filter;
@@ -715,17 +694,10 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-	hwif->ide_dma_check = &ali15x3_config_drive_for_dma;
 	hwif->dma_setup = &ali15x3_dma_setup;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_ali15x3(hwif);
-
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 /**
@@ -836,9 +808,9 @@ static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_dev
 }
 
 
-static struct pci_device_id alim15x3_pci_tbl[] = {
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5228, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+static const struct pci_device_id alim15x3_pci_tbl[] = {
+	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5229), 0 },
+	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5228), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, alim15x3_pci_tbl);
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 6ff4089..3bf3d93 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.23
+ * Version 2.24
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -28,9 +28,6 @@
 
 #include "ide-timing.h"
 
-#define DISPLAY_AMD_TIMINGS
-
-#define AMD_IDE_ENABLE		(0x00 + amd_config->base)
 #define AMD_IDE_CONFIG		(0x01 + amd_config->base)
 #define AMD_CABLE_DETECT	(0x02 + amd_config->base)
 #define AMD_DRIVE_TIMING	(0x08 + amd_config->base)
@@ -88,118 +85,6 @@ static char *amd_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 static unsigned char amd_cyc2udma[] = { 6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7 };
 
 /*
- * AMD /proc entry.
- */
-
-#ifdef CONFIG_IDE_PROC_FS
-
-#include <linux/stat.h>
-#include <linux/proc_fs.h>
-
-static u8 amd74xx_proc;
-
-static unsigned char amd_udma2cyc[] = { 4, 6, 8, 10, 3, 2, 1, 15 };
-static unsigned long amd_base;
-static struct pci_dev *bmide_dev;
-extern int (*amd74xx_display_info)(char *, char **, off_t, int); /* ide-proc.c */
-
-#define amd_print(format, arg...) p += sprintf(p, format "\n" , ## arg)
-#define amd_print_drive(name, format, arg...)\
-	p += sprintf(p, name); for (i = 0; i < 4; i++) p += sprintf(p, format, ## arg); p += sprintf(p, "\n");
-
-static int amd74xx_get_info(char *buffer, char **addr, off_t offset, int count)
-{
-	int speed[4], cycle[4], setup[4], active[4], recover[4], den[4],
-		 uen[4], udma[4], active8b[4], recover8b[4];
-	struct pci_dev *dev = bmide_dev;
-	unsigned int v, u, i;
-	unsigned short c, w;
-	unsigned char t;
-	int len;
-	char *p = buffer;
-
-	amd_print("----------AMD BusMastering IDE Configuration----------------");
-
-	amd_print("Driver Version:                     2.13");
-	amd_print("South Bridge:                       %s", pci_name(bmide_dev));
-
-	amd_print("Revision:                           IDE %#x", dev->revision);
-	amd_print("Highest DMA rate:                   UDMA%s", amd_dma[fls(amd_config->udma_mask) - 1]);
-
-	amd_print("BM-DMA base:                        %#lx", amd_base);
-	amd_print("PCI clock:                          %d.%dMHz", amd_clock / 1000, amd_clock / 100 % 10);
-	
-	amd_print("-----------------------Primary IDE-------Secondary IDE------");
-
-	pci_read_config_byte(dev, AMD_IDE_CONFIG, &t);
-	amd_print("Prefetch Buffer:       %10s%20s", (t & 0x80) ? "yes" : "no", (t & 0x20) ? "yes" : "no");
-	amd_print("Post Write Buffer:     %10s%20s", (t & 0x40) ? "yes" : "no", (t & 0x10) ? "yes" : "no");
-
-	pci_read_config_byte(dev, AMD_IDE_ENABLE, &t);
-	amd_print("Enabled:               %10s%20s", (t & 0x02) ? "yes" : "no", (t & 0x01) ? "yes" : "no");
-
-	c = inb(amd_base + 0x02) | (inb(amd_base + 0x0a) << 8);
-	amd_print("Simplex only:          %10s%20s", (c & 0x80) ? "yes" : "no", (c & 0x8000) ? "yes" : "no");
-
-	amd_print("Cable Type:            %10s%20s", (amd_80w & 1) ? "80w" : "40w", (amd_80w & 2) ? "80w" : "40w");
-
-	if (!amd_clock)
-                return p - buffer;
-
-	amd_print("-------------------drive0----drive1----drive2----drive3-----");
-
-	pci_read_config_byte(dev, AMD_ADDRESS_SETUP, &t);
-	pci_read_config_dword(dev, AMD_DRIVE_TIMING, &v);
-	pci_read_config_word(dev, AMD_8BIT_TIMING, &w);
-	pci_read_config_dword(dev, AMD_UDMA_TIMING, &u);
-
-	for (i = 0; i < 4; i++) {
-		setup[i]     = ((t >> ((3 - i) << 1)) & 0x3) + 1;
-		recover8b[i] = ((w >> ((1 - (i >> 1)) << 3)) & 0xf) + 1;
-		active8b[i]  = ((w >> (((1 - (i >> 1)) << 3) + 4)) & 0xf) + 1;
-		active[i]    = ((v >> (((3 - i) << 3) + 4)) & 0xf) + 1;
-		recover[i]   = ((v >> ((3 - i) << 3)) & 0xf) + 1;
-
-		udma[i] = amd_udma2cyc[((u >> ((3 - i) << 3)) & 0x7)];
-		uen[i]  = ((u >> ((3 - i) << 3)) & 0x40) ? 1 : 0;
-		den[i]  = (c & ((i & 1) ? 0x40 : 0x20) << ((i & 2) << 2));
-
-		if (den[i] && uen[i] && udma[i] == 1) {
-			speed[i] = amd_clock * 3;
-			cycle[i] = 666666 / amd_clock;
-			continue;
-		}
-
-		if (den[i] && uen[i] && udma[i] == 15) {
-			speed[i] = amd_clock * 4;
-			cycle[i] = 500000 / amd_clock;
-			continue;
-		}
-
-		speed[i] = 4 * amd_clock / ((den[i] && uen[i]) ? udma[i] : (active[i] + recover[i]) * 2);
-		cycle[i] = 1000000 * ((den[i] && uen[i]) ? udma[i] : (active[i] + recover[i]) * 2) / amd_clock / 2;
-	}
-
-	amd_print_drive("Transfer Mode: ", "%10s", den[i] ? (uen[i] ? "UDMA" : "DMA") : "PIO");
-
-	amd_print_drive("Address Setup: ", "%8dns", 1000000 * setup[i] / amd_clock);
-	amd_print_drive("Cmd Active:    ", "%8dns", 1000000 * active8b[i] / amd_clock);
-	amd_print_drive("Cmd Recovery:  ", "%8dns", 1000000 * recover8b[i] / amd_clock);
-	amd_print_drive("Data Active:   ", "%8dns", 1000000 * active[i] / amd_clock);
-	amd_print_drive("Data Recovery: ", "%8dns", 1000000 * recover[i] / amd_clock);
-	amd_print_drive("Cycle Time:    ", "%8dns", cycle[i]);
-	amd_print_drive("Transfer Rate: ", "%4d.%dMB/s", speed[i] / 1000, speed[i] / 100 % 10);
-
-	/* hoping p - buffer is less than 4K... */
-	len = (p - buffer) - offset;
-	*addr = buffer + offset;
-	
-	return len > count ? count : len;
-}
-
-#endif
-
-/*
  * amd_set_speed() writes timing values to the chipset registers
  */
 
@@ -264,16 +149,6 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-static int amd74xx_ide_dma_check(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
 /*
  * The initialization callback. Here we determine the IDE chip type
  * and initialize its drive independent registers.
@@ -363,19 +238,6 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
 		amd_chipset->name, pci_name(dev), dev->revision,
 		amd_dma[fls(amd_config->udma_mask) - 1]);
 
-/*
- * Register /proc/ide/amd74xx entry
- */
-
-#if defined(DISPLAY_AMD_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-        if (!amd74xx_proc) {
-                amd_base = pci_resource_start(dev, 4);
-                bmide_dev = dev;
-		ide_pci_create_host_proc("amd74xx", amd74xx_get_info);
-                amd74xx_proc = 1;
-        }
-#endif /* DISPLAY_AMD_TIMINGS && CONFIG_IDE_PROC_FS */
-
 	return dev->irq;
 }
 
@@ -386,8 +248,6 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 	if (hwif->irq == 0) /* 0 is bogus but will do for now */
 		hwif->irq = pci_get_legacy_ide_irq(hwif->pci_dev, hwif->channel);
 
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->set_dma_mode = &amd_set_drive;
 
@@ -395,7 +255,6 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		hwif->drives[i].io_32bit = 1;
 		hwif->drives[i].unmask = 1;
 		hwif->drives[i].autotune = 1;
-		hwif->drives[i].dn = hwif->channel * 2 + i;
 	}
 
 	if (!hwif->dma_base)
@@ -414,12 +273,6 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		else
 			hwif->cbl = ATA_CBL_PATA40;
 	}
-
-        hwif->ide_dma_check = &amd74xx_ide_dma_check;
-        if (!noautodma)
-                hwif->autodma = 1;
-        hwif->drives[0].autodma = hwif->autodma;
-        hwif->drives[1].autodma = hwif->autodma;
 }
 
 #define DECLARE_AMD_DEV(name_str)					\
@@ -489,34 +342,34 @@ static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_
 	return ide_setup_pci_device(dev, amd_chipset);
 }
 
-static struct pci_device_id amd74xx_pci_tbl[] = {
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_COBRA_7401,		PCI_ANY_ID, PCI_ANY_ID, 0, 0,  0 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_VIPER_7409,		PCI_ANY_ID, PCI_ANY_ID, 0, 0,  1 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_VIPER_7411,		PCI_ANY_ID, PCI_ANY_ID, 0, 0,  2 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_OPUS_7441,		PCI_ANY_ID, PCI_ANY_ID, 0, 0,  3 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8111_IDE,		PCI_ANY_ID, PCI_ANY_ID, 0, 0,  4 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0,  5 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0,  6 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0,  7 },
+static const struct pci_device_id amd74xx_pci_tbl[] = {
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_COBRA_7401),		 0 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7409),		 1 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7411),		 2 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_OPUS_7441),		 3 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_8111_IDE),		 4 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE),	 6 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE),	 7 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA,	PCI_ANY_ID, PCI_ANY_ID, 0, 0,  8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA),	 8 },
 #endif
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0,  9 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 10 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE),	 9 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE),	10 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 11 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA),	11 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2),	12 },
 #endif
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 14 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 15 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 16 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 17 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 18 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 20 },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 21 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE,		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 22 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE),	13 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE),	14 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE),	15 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE),	16 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	17 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	18 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	19 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	20 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	21 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		22 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 0eb97f0..446900d 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/atiixp.c	Version 0.02	Jun 16 2007
+ *  linux/drivers/ide/pci/atiixp.c	Version 0.03	Aug 3 2007
  *
  *  Copyright (C) 2003 ATI Inc. <hyu@ati.com>
  *  Copyright (C) 2004,2007 Bartlomiej Zolnierkiewicz
@@ -47,43 +47,6 @@ static int save_mdma_mode[4];
 
 static DEFINE_SPINLOCK(atiixp_lock);
 
-/**
- *	atiixp_dma_2_pio		-	return the PIO mode matching DMA
- *	@xfer_rate: transfer speed
- *
- *	Returns the nearest equivalent PIO timing for the PIO or DMA
- *	mode requested by the controller.
- */
-
-static u8 atiixp_dma_2_pio(u8 xfer_rate) {
-	switch(xfer_rate) {
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-		case XFER_MW_DMA_2:
-		case XFER_PIO_4:
-			return 4;
-		case XFER_MW_DMA_1:
-		case XFER_PIO_3:
-			return 3;
-		case XFER_SW_DMA_2:
-		case XFER_PIO_2:
-			return 2;
-		case XFER_MW_DMA_0:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-		case XFER_PIO_SLOW:
-		default:
-			return 0;
-	}
-}
-
 static void atiixp_dma_host_on(ide_drive_t *drive)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
@@ -169,7 +132,9 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
 	u32 tmp32;
 	u16 tmp16;
-	u8 pio;
+
+	if (speed < XFER_MW_DMA_0)
+		return;
 
 	spin_lock_irqsave(&atiixp_lock, flags);
 
@@ -191,34 +156,6 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	}
 
 	spin_unlock_irqrestore(&atiixp_lock, flags);
-
-	if (speed >= XFER_SW_DMA_0)
-		pio = atiixp_dma_2_pio(speed);
-	else
-		pio = speed - XFER_PIO_0;
-
-	atiixp_set_pio_mode(drive, pio);
-}
-
-/**
- *	atiixp_dma_check	-	set up an IDE device
- *	@drive: IDE drive to configure
- *
- *	Set up the ATIIXP interface for the best available speed on this
- *	interface, preferring DMA to PIO.
- */
-
-static int atiixp_dma_check(ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
 }
 
 /**
@@ -238,7 +175,6 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 	if (!hwif->irq)
 		hwif->irq = ch ? 15 : 14;
 
-	hwif->autodma = 0;
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
 	hwif->drives[0].autotune = 1;
@@ -249,8 +185,7 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x3f;
-	hwif->mwdma_mask = 0x06;
-	hwif->swdma_mask = 0x04;
+	hwif->mwdma_mask = 0x07;
 
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
 
@@ -261,12 +196,6 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 
 	hwif->dma_host_on = &atiixp_dma_host_on;
 	hwif->dma_host_off = &atiixp_dma_host_off;
-	hwif->ide_dma_check = &atiixp_dma_check;
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[1].autodma = hwif->autodma;
-	hwif->drives[0].autodma = hwif->autodma;
 }
 
 
@@ -303,12 +232,12 @@ static int __devinit atiixp_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &atiixp_pci_info[id->driver_data]);
 }
 
-static struct pci_device_id atiixp_pci_tbl[] = {
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP200_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id atiixp_pci_tbl[] = {
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP200_IDE), 0 },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP300_IDE), 0 },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), 0 },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), 1 },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index d50f15e..f3d3bde 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -330,17 +330,6 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		(void) pci_write_config_byte(dev, pciU, regU);
 }
 
-static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static int cmd648_ide_dma_end (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -547,8 +536,6 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	if (dev->device == PCI_DEVICE_ID_CMD_646 && rev < 5)
 		hwif->ultra_mask = 0x00;
 
-	hwif->ide_dma_check = &cmd64x_config_drive_for_dma;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_cmd64x(hwif);
 
@@ -572,10 +559,6 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 		hwif->ide_dma_test_irq	= &cmd64x_ide_dma_test_irq;
 		break;
 	}
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static int __devinit init_setup_cmd64x(struct pci_dev *dev, ide_pci_device_t *d)
@@ -654,11 +637,11 @@ static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_devic
 	return d.init_setup(dev, &d);
 }
 
-static struct pci_device_id cmd64x_pci_tbl[] = {
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_CMD_643, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_CMD_646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_CMD_648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_CMD_649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
+static const struct pci_device_id cmd64x_pci_tbl[] = {
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_643), 0 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_646), 1 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_648), 2 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_649), 3 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, cmd64x_pci_tbl);
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index fbce900..a8bf494 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -105,15 +105,6 @@ static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	cs5520_set_pio_mode(drive, 0);
 }
 
-static int cs5520_config_drive_xfer_rate(ide_drive_t *drive)
-{
-	/* Tune the drive for PIO modes up to PIO 4 */	
-	ide_set_max_pio(drive);
-
-	/* Then tell the core to use DMA operations */
-	return 0;
-}
-
 /*
  *	We provide a callback for our nonstandard DMA location
  */
@@ -148,7 +139,6 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->ide_dma_check = &cs5520_config_drive_xfer_rate;
 	hwif->ide_dma_on = &cs5520_dma_on;
 
 	/* ATAPI is harder so leave it for now */
@@ -156,12 +146,6 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 	hwif->ultra_mask = 0;
 	hwif->swdma_mask = 0;
 	hwif->mwdma_mask = 0;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 #define DECLARE_CS_DEV(name_str)				\
@@ -171,7 +155,8 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 		.init_hwif	= init_hwif_cs5520,		\
 		.autodma	= AUTODMA,			\
 		.bootable	= ON_BOARD,			\
-		.host_flags	= IDE_HFLAG_ISA_PORTS,		\
+		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
+				  IDE_HFLAG_VDMA,		\
 		.pio_mask	= ATA_PIO4,			\
 	}
 
@@ -233,9 +218,9 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	return 0;
 }
 
-static struct pci_device_id cs5520_pci_tbl[] = {
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5510, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5520, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+static const struct pci_device_id cs5520_pci_tbl[] = {
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), 0 },
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5520), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, cs5520_pci_tbl);
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index e412157..0d23b8a 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.74	Jul 28 2007
+ * linux/drivers/ide/pci/cs5530.c		Version 0.76	Aug 3 2007
  *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
@@ -104,22 +104,6 @@ out:
 	return mask;
 }
 
-/**
- *	cs5530_config_dma	-	set DMA/UDMA mode
- *	@drive: drive to tune
- *
- *	cs5530_config_dma() handles setting of DMA/UDMA mode
- *	for both the chipset and drive.
- */
-
-static int cs5530_config_dma(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return 1;
-}
-
 static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	unsigned long basereg;
@@ -260,7 +244,6 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 {
 	unsigned long basereg;
 	u32 d0_timings;
-	hwif->autodma = 0;
 
 	if (hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
@@ -270,20 +253,13 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 
 	basereg = CS5530_BASEREG(hwif);
 	d0_timings = inl(basereg + 0);
-	if (CS5530_BAD_PIO(d0_timings)) {
-		/* PIO timings not initialized? */
+	if (CS5530_BAD_PIO(d0_timings))
 		outl(cs5530_pio_timings[(d0_timings >> 31) & 1][0], basereg + 0);
-		if (!hwif->drives[0].autotune)
-			hwif->drives[0].autotune = 1;
-			/* needs autotuning later */
-	}
-	if (CS5530_BAD_PIO(inl(basereg + 8))) {
-		/* PIO timings not initialized? */
+	if (CS5530_BAD_PIO(inl(basereg + 8)))
 		outl(cs5530_pio_timings[(d0_timings >> 31) & 1][0], basereg + 8);
-		if (!hwif->drives[1].autotune)
-			hwif->drives[1].autotune = 1;
-			/* needs autotuning later */
-	}
+
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
 
 	if (hwif->dma_base == 0)
 		return;
@@ -293,11 +269,6 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x07;
 
 	hwif->udma_filter = cs5530_udma_filter;
-	hwif->ide_dma_check = &cs5530_config_dma;
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t cs5530_chipset __devinitdata = {
@@ -315,8 +286,8 @@ static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &cs5530_chipset);
 }
 
-static struct pci_device_id cs5530_pci_tbl[] = {
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id cs5530_pci_tbl[] = {
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_IDE), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, cs5530_pci_tbl);
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 2578657..e4891a1 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -157,19 +157,6 @@ static void cs5535_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int cs5535_dma_check(ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
 {
 	u8 bit;
@@ -190,8 +177,6 @@ static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
  */
 static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
@@ -200,18 +185,11 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->ide_dma_check = &cs5535_dma_check;
-
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x1F;
 	hwif->mwdma_mask = 0x07;
 
 	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
-
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[1].autodma = hwif->drives[0].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t cs5535_chipset __devinitdata = {
@@ -229,10 +207,8 @@ static int __devinit cs5535_init_one(struct pci_dev *dev,
 	return ide_setup_pci_device(dev, &cs5535_chipset);
 }
 
-static struct pci_device_id cs5535_pci_tbl[] =
-{
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_IDE, PCI_ANY_ID,
-		PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id cs5535_pci_tbl[] = {
+	{ PCI_VDEVICE(NS, PCI_DEVICE_ID_NS_CS5535_IDE), 0 },
 	{ 0, },
 };
 
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index dc27802..c498ecf 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -428,8 +428,6 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
  */
 static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
-
 	hwif->chipset = ide_cy82c693;
 	hwif->set_pio_mode = &cy82c693_set_pio_mode;
 
@@ -444,10 +442,6 @@ static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 	hwif->swdma_mask = 0x04;
 
 	hwif->ide_dma_on = &cy82c693_ide_dma_on;
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static __devinitdata ide_hwif_t *primary;
@@ -469,7 +463,7 @@ static ide_pci_device_t cy82c693_chipset __devinitdata = {
 	.init_hwif	= init_hwif_cy82c693,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_SINGLE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	.pio_mask	= ATA_PIO4,
 };
 
@@ -489,8 +483,8 @@ static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_dev
 	return ret;
 }
 
-static struct pci_device_id cy82c693_pci_tbl[] = {
-	{ PCI_VENDOR_ID_CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id cy82c693_pci_tbl[] = {
+	{ PCI_VDEVICE(CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, cy82c693_pci_tbl);
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 48caa46..cce6311 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -73,11 +73,6 @@ static void __devinit init_hwif_generic (ide_hwif_t *hwif)
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 #if 0
@@ -97,77 +92,92 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 1 */
 		.name		= "NS87410",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
         },{	/* 2 */
 		.name		= "SAMURAI",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 3 */
 		.name		= "HT6565",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 4 */
 		.name		= "UM8673F",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 5 */
 		.name		= "UM8886A",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 6 */
 		.name		= "UM8886BF",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 7 */
 		.name		= "HINT_IDE",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 8 */
 		.name		= "VIA_IDE",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 9 */
 		.name		= "OPTI621V",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 10 */
 		.name		= "VIA8237SATA",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 11 */
 		.name 		= "Piccolo0102",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 12 */
 		.name 		= "Piccolo0103",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 13 */
 		.name 		= "Piccolo0105",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 14 */
 		.name		= "Revolution",
 		.init_hwif	= init_hwif_generic,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	}
 };
 
@@ -226,25 +236,28 @@ out:
 	return ret;
 }
 
-static struct pci_device_id generic_pci_tbl[] = {
-	{ PCI_VENDOR_ID_NS,     PCI_DEVICE_ID_NS_87410,            PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_PCTECH, PCI_DEVICE_ID_PCTECH_SAMURAI_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_HOLTEK, PCI_DEVICE_ID_HOLTEK_6565,         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_UMC,    PCI_DEVICE_ID_UMC_UM8673F,         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{ PCI_VENDOR_ID_UMC,    PCI_DEVICE_ID_UMC_UM8886A,         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
-	{ PCI_VENDOR_ID_UMC,    PCI_DEVICE_ID_UMC_UM8886BF,        PCI_ANY_ID, PCI_ANY_ID, 0, 0, 6},
-	{ PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE,    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 7},
-	{ PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561,          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 8},
-	{ PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558,         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 9},
+static const struct pci_device_id generic_pci_tbl[] = {
+	{ PCI_VDEVICE(NS,	PCI_DEVICE_ID_NS_87410),		 1 },
+	{ PCI_VDEVICE(PCTECH,	PCI_DEVICE_ID_PCTECH_SAMURAI_IDE),	 2 },
+	{ PCI_VDEVICE(HOLTEK,	PCI_DEVICE_ID_HOLTEK_6565),		 3 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8673F),		 4 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886A),		 5 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886BF),		 6 },
+	{ PCI_VDEVICE(HINT,	PCI_DEVICE_ID_HINT_VXPROII_IDE),	 7 },
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_82C561),		 8 },
+	{ PCI_VDEVICE(OPTI,	PCI_DEVICE_ID_OPTI_82C558),		 9 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237_SATA,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 10},
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		10 },
 #endif
-	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO,     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 11},
-	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
-	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13},
-	{ PCI_VENDOR_ID_NETCELL,PCI_DEVICE_ID_REVOLUTION,          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 14},
-	/* Must come last. If you add entries adjust this table appropriately and the init_one code */
-	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 0},
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		11 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	12 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	13 },
+	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		14 },
+	/*
+	 * Must come last.  If you add entries adjust
+	 * this table and generic_chipsets[] appropriately.
+	 */
+	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, generic_pci_tbl);
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 218852a..44ac0e2 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -80,19 +80,6 @@ static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	hpt34x_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static int hpt34x_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return -1;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 /*
  * If the BIOS does not set the IO base addaress to XX00, 343 will fail.
  */
@@ -140,8 +127,6 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 {
 	u16 pcicmd = 0;
 
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &hpt34x_set_pio_mode;
 	hwif->set_dma_mode = &hpt34x_set_mode;
 
@@ -154,16 +139,13 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 		return;
 
 #ifdef CONFIG_HPT34X_AUTODMA
+	if ((pcicmd & PCI_COMMAND_MEMORY) == 0)
+		return;
+
 	hwif->ultra_mask = 0x07;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 #endif
-
-	hwif->ide_dma_check = &hpt34x_config_drive_xfer_rate;
-	if (!noautodma)
-		hwif->autodma = (pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t hpt34x_chipset __devinitdata = {
@@ -190,8 +172,8 @@ static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, d);
 }
 
-static struct pci_device_id hpt34x_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id hpt34x_pci_tbl[] = {
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT343), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, hpt34x_pci_tbl);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 8812a9b..fcb21dd 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.13	Sep 29, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.14	Oct 1, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -713,19 +713,6 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 			   IDE_CONTROL_REG);
 }
 
-static int hpt366_config_drive_xfer_rate(ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 /*
  * This is specific to the HPT366 UDMA chipset
  * by HighPoint|Triones Technologies, Inc.
@@ -1304,10 +1291,10 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	if (new_mcr != old_mcr)
 		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
@@ -1349,8 +1336,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
-	hwif->ide_dma_check		= &hpt366_config_drive_xfer_rate;
-
 	if (chip_type >= HPT374) {
 		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
 		hwif->ide_dma_end	= &hpt374_ide_dma_end;
@@ -1360,10 +1345,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 		hwif->dma_timeout	= &hpt370_dma_timeout;
 	} else
 		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
@@ -1657,13 +1638,13 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	return d.init_setup(dev, &d);
 }
 
-static struct pci_device_id hpt366_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT372, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT302, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT371, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT374, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{ PCI_VENDOR_ID_TTI, PCI_DEVICE_ID_TTI_HPT372N, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
+static const struct pci_device_id hpt366_pci_tbl[] = {
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366),  0 },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372),  1 },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT302),  2 },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT371),  3 },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT374),  4 },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372N), 5 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, hpt366_pci_tbl);
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index ecf4ce0..24a71d0 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -18,37 +18,6 @@
 #include <asm/io.h>
 
 /**
- *	it8213_dma_2_pio		-	return the PIO mode matching DMA
- *	@xfer_rate: transfer speed
- *
- *	Returns the nearest equivalent PIO timing for the DMA
- *	mode requested by the controller.
- */
-
-static u8 it8213_dma_2_pio (u8 xfer_rate) {
-	switch(xfer_rate) {
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-		case XFER_MW_DMA_2:
-			return 4;
-		case XFER_MW_DMA_1:
-			return 3;
-		case XFER_SW_DMA_2:
-			return 2;
-		case XFER_MW_DMA_0:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-		default:
-			return 0;
-	}
-}
-
-/**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
@@ -166,6 +135,9 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		} else
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 	} else {
+		const u8 mwdma_to_pio[] = { 0, 3, 4 };
+		u8 pio;
+
 		if (reg48 & u_flag)
 			pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
 		if (reg4a & a_speed)
@@ -174,38 +146,21 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 		if (reg55 & w_flag)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-	}
-
-	it8213_set_pio_mode(drive, it8213_dma_2_pio(speed));
-}
-
-/**
- *	it8213_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	Set up the drive for DMA, tune the controller and drive as
- *	required. If the drive isn't suitable for DMA or we hit
- *	other problems then we will drop down to PIO and set up
- *	PIO appropriately
- */
 
-static int it8213_config_drive_for_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
+		if (speed >= XFER_MW_DMA_0)
+			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+		else
+			pio = 2; /* only SWDMA2 is allowed */
 
-	ide_set_max_pio(drive);
-
-	return -1;
+		it8213_set_pio_mode(drive, pio);
+	}
 }
 
 /**
  *	init_hwif_it8213	-	set up hwif structs
  *	@hwif: interface to set up
  *
- *	We do the basic set up of the interface structure. The IT8212
- *	requires several custom handlers so we override the default
- *	ide DMA handlers appropriately
+ *	We do the basic set up of the interface structure.
  */
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
@@ -215,8 +170,6 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	hwif->set_dma_mode = &it8213_set_dma_mode;
 	hwif->set_pio_mode = &it8213_set_pio_mode;
 
-	hwif->autodma = 0;
-
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
@@ -230,20 +183,8 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 
 	pci_read_config_byte(hwif->pci_dev, 0x42, &reg42h);
 
-	hwif->ide_dma_check = &it8213_config_drive_for_dma;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-
-	/*
-	 *	The BIOS often doesn't set up DMA on this controller
-	 *	so we always do it.
-	 */
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 
@@ -279,9 +220,8 @@ static int __devinit it8213_init_one(struct pci_dev *dev, const struct pci_devic
 	return 0;
 }
 
-
-static struct pci_device_id it8213_pci_tbl[] = {
-	{ PCI_VENDOR_ID_ITE, 0x8213, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+static const struct pci_device_id it8213_pci_tbl[] = {
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8213), 0 },
 	{ 0, },
 };
 
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 1b69d82..f3391a8 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -416,26 +416,6 @@ static void it821x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	it821x_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	Set up the drive for DMA, tune the controller and drive as
- *	required. If the drive isn't suitable for DMA or we hit
- *	other problems then we will drop down to PIO and set up
- *	PIO appropriately
- */
-
-static int it821x_config_drive_for_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
-/**
  *	ata66_it821x	-	check for 80 pin cable
  *	@hwif: interface to check
  *
@@ -557,10 +537,11 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	struct it821x_dev *idev = kzalloc(sizeof(struct it821x_dev), GFP_KERNEL);
 	u8 conf;
 
-	if(idev == NULL) {
+	if (idev == NULL) {
 		printk(KERN_ERR "it821x: out of memory, falling back to legacy behaviour.\n");
-		goto fallback;
+		return;
 	}
+
 	ide_set_hwifdata(hwif, idev);
 
 	hwif->atapi_dma = 1;
@@ -609,29 +590,14 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
-	if (!hwif->dma_base)
-		goto fallback;
+	if (hwif->dma_base == 0)
+		return;
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check = &it821x_config_drive_for_dma;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_it821x(hwif);
-
-	/*
-	 *	The BIOS often doesn't set up DMA on this controller
-	 *	so we always do it.
-	 */
-
-	hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-	return;
-fallback:
-	hwif->autodma = 0;
-	return;
 }
 
 static void __devinit it8212_disable_raid(struct pci_dev *dev)
@@ -697,9 +663,9 @@ static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_devic
 	return 0;
 }
 
-static struct pci_device_id it821x_pci_tbl[] = {
-	{ PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8211,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8212,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id it821x_pci_tbl[] = {
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), 0 },
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), 0 },
 	{ 0, },
 };
 
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 582b4ca..bb893ff 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -100,24 +100,6 @@ static void jmicron_set_dma_mode(ide_drive_t *drive, const u8 mode)
 }
 
 /**
- *	jmicron_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	As the JMicron snoops for timings all we actually need to do is
- *	make sure we don't set an invalid mode.
- */
-
-static int jmicron_config_drive_for_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
-/**
  *	init_hwif_jmicron	-	set up hwif structs
  *	@hwif: interface to set up
  *
@@ -132,25 +114,15 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
-	if (!hwif->dma_base)
-		goto fallback;
+	if (hwif->dma_base == 0)
+		return;
 
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check = &jmicron_config_drive_for_dma;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_jmicron(hwif);
-
-	hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-	return;
-fallback:
-	hwif->autodma = 0;
-	return;
 }
 
 static ide_pci_device_t jmicron_chipset __devinitdata = {
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 465c935..a8cd50a 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -197,7 +197,6 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	u8 stat;
 #endif
 
-	hwif->autodma = 0;
 	hwif->selectproc = &ns87415_selectproc;
 
 	/*
@@ -259,11 +258,6 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	outb(0x60, hwif->dma_status);
 	hwif->dma_setup = &ns87415_ide_dma_setup;
 	hwif->ide_dma_end = &ns87415_ide_dma_end;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t ns87415_chipset __devinitdata = {
@@ -274,6 +268,7 @@ static ide_pci_device_t ns87415_chipset __devinitdata = {
 	.init_hwif	= init_hwif_ns87415,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 };
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
@@ -281,8 +276,8 @@ static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_devi
 	return ide_setup_pci_device(dev, &ns87415_chipset);
 }
 
-static struct pci_device_id ns87415_pci_tbl[] = {
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_87415, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id ns87415_pci_tbl[] = {
+	{ PCI_VDEVICE(NS, PCI_DEVICE_ID_NS_87415), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, ns87415_pci_tbl);
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 9fa0639..250662e 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -328,7 +328,6 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
  */
 static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
 	hwif->drives[0].drive_data = PIO_DONT_KNOW;
 	hwif->drives[1].drive_data = PIO_DONT_KNOW;
 
@@ -340,11 +339,6 @@ static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 	hwif->atapi_dma = 1;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t opti621_chipsets[] __devinitdata = {
@@ -355,6 +349,7 @@ static ide_pci_device_t opti621_chipsets[] __devinitdata = {
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
 		.bootable	= ON_BOARD,
 		.pio_mask	= ATA_PIO3,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	},{	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
@@ -362,6 +357,7 @@ static ide_pci_device_t opti621_chipsets[] __devinitdata = {
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
 		.bootable	= ON_BOARD,
 		.pio_mask	= ATA_PIO3,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 	}
 };
 
@@ -370,9 +366,9 @@ static int __devinit opti621_init_one(struct pci_dev *dev, const struct pci_devi
 	return ide_setup_pci_device(dev, &opti621_chipsets[id->driver_data]);
 }
 
-static struct pci_device_id opti621_pci_tbl[] = {
-	{ PCI_VENDOR_ID_OPTI, PCI_DEVICE_ID_OPTI_82C621, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_OPTI, PCI_DEVICE_ID_OPTI_82C825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+static const struct pci_device_id opti621_pci_tbl[] = {
+	{ PCI_VDEVICE(OPTI, PCI_DEVICE_ID_OPTI_82C621), 0 },
+	{ PCI_VDEVICE(OPTI, PCI_DEVICE_ID_OPTI_82C825), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, opti621_pci_tbl);
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index ad0bdcb..8704b6f 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -223,19 +223,6 @@ static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 		return ATA_CBL_PATA80;
 }
 
-static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static int pdcnew_quirkproc(ide_drive_t *drive)
 {
 	const char **list, *model = drive->id->model;
@@ -482,8 +469,6 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 
 static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &pdcnew_set_pio_mode;
 	hwif->set_dma_mode = &pdcnew_set_mode;
 
@@ -502,14 +487,8 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = pdcnew_cable_detect(hwif);
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static int __devinit init_setup_pdcnew(struct pci_dev *dev, ide_pci_device_t *d)
@@ -658,14 +637,14 @@ static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_de
 	return d->init_setup(dev, d);
 }
 
-static struct pci_device_id pdc202new_pci_tbl[] = {
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20268, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20269, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20270, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20271, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20275, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20276, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20277, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 6},
+static const struct pci_device_id pdc202new_pci_tbl[] = {
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20268), 0 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20269), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20270), 2 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20271), 3 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20275), 4 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20276), 5 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20277), 6 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202new_pci_tbl);
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 8c3e8cf..e1d2337 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -179,19 +179,6 @@ static void pdc_old_disable_66MHz_clock(ide_hwif_t *hwif)
 	outb(clock & ~(hwif->channel ? 0x08 : 0x02), clock_reg);
 }
 
-static int pdc202xx_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static int pdc202xx_quirkproc (ide_drive_t *drive)
 {
 	const char **list, *model = drive->id->model;
@@ -325,8 +312,6 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	    (dev->device == PCI_DEVICE_ID_PROMISE_20265))
 		hwif->rqsize = 256;
 
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
 	hwif->set_dma_mode = &pdc202xx_set_mode;
 
@@ -347,7 +332,6 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	hwif->swdma_mask = 0x07;
 	hwif->atapi_dma = 1;
 
-	hwif->ide_dma_check = &pdc202xx_config_drive_xfer_rate;
 	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
@@ -359,10 +343,6 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
 	} 
 	hwif->ide_dma_test_irq = &pdc202xx_old_ide_dma_test_irq;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
@@ -510,12 +490,12 @@ static int __devinit pdc202xx_init_one(struct pci_dev *dev, const struct pci_dev
 	return d->init_setup(dev, d);
 }
 
-static struct pci_device_id pdc202xx_pci_tbl[] = {
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20246, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20262, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20263, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20265, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20267, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+static const struct pci_device_id pdc202xx_pci_tbl[] = {
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20246), 0 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20262), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20263), 2 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20265), 3 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20267), 4 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202xx_pci_tbl);
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 38c91ba..a8dd0c0 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.52	Jul 14, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.53	Aug 9, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -106,37 +106,6 @@
 static int no_piix_dma;
 
 /**
- *	piix_dma_2_pio		-	return the PIO mode matching DMA
- *	@xfer_rate: transfer speed
- *
- *	Returns the nearest equivalent PIO timing for the DMA
- *	mode requested by the controller.
- */
- 
-static u8 piix_dma_2_pio (u8 xfer_rate) {
-	switch(xfer_rate) {
-		case XFER_UDMA_6:
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-		case XFER_MW_DMA_2:
-			return 4;
-		case XFER_MW_DMA_1:
-			return 3;
-		case XFER_SW_DMA_2:
-			return 2;
-		case XFER_MW_DMA_0:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-		default:
-			return 0;
-	}
-}
-
-/**
  *	piix_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
@@ -263,6 +232,9 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		} else
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 	} else {
+		const u8 mwdma_to_pio[] = { 0, 3, 4 };
+		u8 pio;
+
 		if (reg48 & u_flag)
 			pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
 		if (reg4a & a_speed)
@@ -271,30 +243,14 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
 		if (reg55 & w_flag)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-	}
 
-	piix_set_pio_mode(drive, piix_dma_2_pio(speed));
-}
-
-/**
- *	piix_config_drive_xfer_rate	-	set up an IDE device
- *	@drive: IDE drive to configure
- *
- *	Set up the PIIX interface for the best available speed on this
- *	interface, preferring DMA to PIO.
- */
- 
-static int piix_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	drive->init_speed = 0;
+		if (speed >= XFER_MW_DMA_0)
+			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+		else
+			pio = 2; /* only SWDMA2 is allowed */
 
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
+		piix_set_pio_mode(drive, pio);
+	}
 }
 
 /**
@@ -428,8 +384,6 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &piix_set_pio_mode;
 	hwif->set_dma_mode = &piix_set_dma_mode;
 
@@ -456,13 +410,6 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 
 	if (no_piix_dma)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
-
-	hwif->ide_dma_check = &piix_config_drive_xfer_rate;
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[1].autodma = hwif->autodma;
-	hwif->drives[0].autodma = hwif->autodma;
 }
 
 #define DECLARE_PIIX_DEV(name_str, udma) \
@@ -565,34 +512,34 @@ static void __devinit piix_check_450nx(void)
 		printk(KERN_WARNING "piix: A BIOS update may resolve this.\n");
 }		
 
-static struct pci_device_id piix_pci_tbl[] = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371FB_0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371FB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371MX,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371SB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 6},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 7},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82372FB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 8},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82451NX,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 9},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 10},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 11},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_11,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_11,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 14},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_11,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 15},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801E_11, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 16},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_10,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 17},
+static const struct pci_device_id piix_pci_tbl[] = {
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),   0 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),   1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX),     2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371SB_1),   3 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB),     4 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AB_1),   5 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82443MX_1),   6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AA_1),   7 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82372FB_1),   8 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82451NX),     9 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_9),  10 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_8),  11 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_10), 12 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_11), 13 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_11), 14 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_11), 15 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801E_11),  16 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_10), 17 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
- 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 18},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_1),  18 },
 #endif
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_19, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 20},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 21},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 22},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_18, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 23},
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 24},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB_2),      19 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH6_19),    20 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH7_21),    21 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  22 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    23 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     24 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 10e1ae7..3f506e8 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -61,9 +61,9 @@ static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &rz1000_chipset);
 }
 
-static struct pci_device_id rz1000_pci_tbl[] = {
-	{ PCI_VENDOR_ID_PCTECH, PCI_DEVICE_ID_PCTECH_RZ1000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_PCTECH, PCI_DEVICE_ID_PCTECH_RZ1001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id rz1000_pci_tbl[] = {
+	{ PCI_VDEVICE(PCTECH, PCI_DEVICE_ID_PCTECH_RZ1000), 0 },
+	{ PCI_VDEVICE(PCTECH, PCI_DEVICE_ID_PCTECH_RZ1001), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, rz1000_pci_tbl);
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index ee0e3f5..54c5c98 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sc1200.c		Version 0.95	Jun 16 2007
+ * linux/drivers/ide/pci/sc1200.c		Version 0.97	Aug 3 2007
  *
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
  * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
@@ -199,19 +199,6 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	}
 }
 
-/*
- * sc1200_config_dma() handles selection/setting of DMA/UDMA modes
- * for both the chipset and drive.
- */
-static int sc1200_config_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return 1;
-}
-
-
 /*  Replacement for the standard ide_dma_end action in
  *  dma_proc.
  *
@@ -377,27 +364,22 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 {
 	if (hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
-	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &sc1200_set_pio_mode;
 	hwif->set_dma_mode = &sc1200_set_dma_mode;
 
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->udma_filter = sc1200_udma_filter;
-	hwif->ide_dma_check = &sc1200_config_dma;
 	hwif->ide_dma_end   = &sc1200_ide_dma_end;
 
-	if (!noautodma)
-		hwif->autodma = 1;
-
         hwif->atapi_dma = 1;
         hwif->ultra_mask = 0x07;
         hwif->mwdma_mask = 0x07;
-
-        hwif->drives[0].autodma = hwif->autodma;
-        hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t sc1200_chipset __devinitdata = {
@@ -414,8 +396,8 @@ static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &sc1200_chipset);
 }
 
-static struct pci_device_id sc1200_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SCx200_IDE), 0},
+static const struct pci_device_id sc1200_pci_tbl[] = {
+	{ PCI_VDEVICE(NS, PCI_DEVICE_ID_NS_SCx200_IDE), 0},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, sc1200_pci_tbl);
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 67f06dd..bd4c1d3 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -284,28 +284,6 @@ static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /**
- *	scc_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	Set up the drive for DMA, tune the controller and drive as
- *	required.
- *      If the drive isn't suitable for DMA or we hit other problems
- *      then we will drop down to PIO and set up PIO appropriately.
- *      (return -1)
- */
-
-static int scc_config_drive_for_dma(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
-/**
  *	scc_ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
  *
@@ -702,7 +680,6 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->ide_dma_end = scc_ide_dma_end;
 	hwif->set_pio_mode = scc_set_pio_mode;
 	hwif->set_dma_mode = scc_set_dma_mode;
-	hwif->ide_dma_check = scc_config_drive_for_dma;
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
 	hwif->udma_filter = scc_udma_filter;
 
@@ -720,12 +697,6 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 
 	/* we support 80c cable only. */
 	hwif->cbl = ATA_CBL_PATA80;
-
-	hwif->autodma = 0;
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 #define DECLARE_SCC_DEV(name_str)			\
@@ -793,8 +764,8 @@ static void __devexit scc_remove(struct pci_dev *dev)
 	memset(ports, 0, sizeof(*ports));
 }
 
-static struct pci_device_id scc_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id scc_pci_tbl[] = {
+	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, scc_pci_tbl);
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 49ec0ac..d3ffc52 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -97,6 +97,7 @@ static u8 svwks_udma_filter(ide_drive_t *drive)
 			mode = 2;
 
 		switch(mode) {
+		case 3:	 mask = 0x3f; break;
 		case 2:	 mask = 0x1f; break;
 		case 1:	 mask = 0x07; break;
 		default: mask = 0x00; break;
@@ -195,19 +196,6 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static int svwks_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static unsigned int __devinit init_chipset_svwks (struct pci_dev *dev, const char *name)
 {
 	unsigned int reg;
@@ -386,23 +374,16 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 
 	hwif->mwdma_mask = 0x07;
 
-	hwif->autodma = 0;
-
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
 	if (!hwif->dma_base)
 		return;
 
-	hwif->ide_dma_check = &svwks_config_drive_xfer_rate;
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = ata66_svwks(hwif);
 	}
-	if (!noautodma)
-		hwif->autodma = 1;
-
-	hwif->drives[0].autodma = hwif->drives[1].autodma = 1;
 }
 
 static int __devinit init_setup_svwks (struct pci_dev *dev, ide_pci_device_t *d)
@@ -490,12 +471,12 @@ static int __devinit svwks_init_one(struct pci_dev *dev, const struct pci_device
 	return d->init_setup(dev, d);
 }
 
-static struct pci_device_id svwks_pci_tbl[] = {
-	{ PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_OSB4IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+static const struct pci_device_id svwks_pci_tbl[] = {
+	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_OSB4IDE),   0 },
+	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB5IDE),   1 },
+	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB6IDE),   2 },
+	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2),  3 },
+	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000IDE), 4 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, svwks_pci_tbl);
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index c74fef6..9a9474f 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -296,20 +296,6 @@ static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 }
 
-static int sgiioc4_ide_dma_check(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	/*
-	 * ->set_pio_mode is not implemented currently
-	 * so this is just for the completness
-	 */
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
 /* returns 1 if dma irq issued, 0 otherwise */
 static int
 sgiioc4_ide_dma_test_irq(ide_drive_t * drive)
@@ -612,7 +598,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
 	hwif->ide_dma_end = &sgiioc4_ide_dma_end;
-	hwif->ide_dma_check = &sgiioc4_ide_dma_check;
 	hwif->ide_dma_on = &sgiioc4_ide_dma_on;
 	hwif->dma_off_quietly = &sgiioc4_dma_off_quietly;
 	hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
@@ -689,12 +674,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	hwif->autodma = 0;
-
-	if (dma_base && ide_dma_sgiioc4(hwif, dma_base) == 0) {
-		hwif->autodma = 1;
-		hwif->drives[1].autodma = hwif->drives[0].autodma = 1;
-	} else
+	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base))
 		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
 				 hwif->name, DRV_NAME);
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index ce77849..85d0afd 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -311,27 +311,6 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	}
 }
 
-/**
- *	siimage_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	Set up the drive for DMA, tune the controller and drive as 
- *	required. If the drive isn't suitable for DMA or we hit
- *	other problems then we will drop down to PIO and set up
- *	PIO appropriately
- */
- 
-static int siimage_config_drive_for_dma (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 /* returns 1 if dma irq issued, 0 otherwise */
 static int siimage_io_ide_dma_test_irq (ide_drive_t *drive)
 {
@@ -894,8 +873,6 @@ static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 {
-	hwif->autodma = 0;
-	
 	hwif->resetproc = &siimage_reset;
 	hwif->set_pio_mode = &sil_set_pio_mode;
 	hwif->set_dma_mode = &sil_set_dma_mode;
@@ -925,8 +902,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	if (!is_sata(hwif))
 		hwif->atapi_dma = 1;
 
-	hwif->ide_dma_check = &siimage_config_drive_for_dma;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_siimage(hwif);
 
@@ -935,15 +910,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	} else {
 		hwif->ide_dma_test_irq = & siimage_io_ide_dma_test_irq;
 	}
-	
-	/*
-	 *	The BIOS often doesn't set up DMA on this controller
-	 *	so we always do it.
-	 */
-
-	hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 #define DECLARE_SII_DEV(name_str)			\
@@ -978,11 +944,11 @@ static int __devinit siimage_init_one(struct pci_dev *dev, const struct pci_devi
 	return ide_setup_pci_device(dev, &siimage_chipsets[id->driver_data]);
 }
 
-static struct pci_device_id siimage_pci_tbl[] = {
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_680,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id siimage_pci_tbl[] = {
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_680),    0 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_3112, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_1210SA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_3112),   1 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_1210SA), 2 },
 #endif
 	{ 0, },
 };
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index b375ee5..5a54e2e 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.27	Jul 14, 2007
+ * linux/drivers/ide/pci/sis5513.c	Version 0.31	Aug 9, 2007
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
@@ -65,8 +65,6 @@
 
 #include "ide-timing.h"
 
-#define DISPLAY_SIS_TIMINGS
-
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -193,362 +191,124 @@ static char* chipset_capability[] = {
 	"ATA 133 (1st gen)", "ATA 133 (2nd gen)"
 };
 
-#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-#include <linux/stat.h>
-#include <linux/proc_fs.h>
-
-static u8 sis_proc = 0;
-
-static struct pci_dev *bmide_dev;
-
-static char* cable_type[] = {
-	"80 pins",
-	"40 pins"
-};
+/*
+ * Configuration functions
+ */
 
-static char* recovery_time[] ={
-	"12 PCICLK", "1 PCICLK",
-	"2 PCICLK", "3 PCICLK",
-	"4 PCICLK", "5 PCICLCK",
-	"6 PCICLK", "7 PCICLCK",
-	"8 PCICLK", "9 PCICLCK",
-	"10 PCICLK", "11 PCICLK",
-	"13 PCICLK", "14 PCICLK",
-	"15 PCICLK", "15 PCICLK"
-};
+static u8 sis_ata133_get_base(ide_drive_t *drive)
+{
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u32 reg54 = 0;
 
-static char* active_time[] = {
-	"8 PCICLK", "1 PCICLCK",
-	"2 PCICLK", "3 PCICLK",
-	"4 PCICLK", "5 PCICLK",
-	"6 PCICLK", "12 PCICLK"
-};
+	pci_read_config_dword(dev, 0x54, &reg54);
 
-static char* cycle_time[] = {
-	"Reserved", "2 CLK",
-	"3 CLK", "4 CLK",
-	"5 CLK", "6 CLK",
-	"7 CLK", "8 CLK",
-	"9 CLK", "10 CLK",
-	"11 CLK", "12 CLK",
-	"13 CLK", "14 CLK",
-	"15 CLK", "16 CLK"
-};
+	return ((reg54 & 0x40000000) ? 0x70 : 0x40) + drive->dn * 4;
+}
 
-/* Generic add master or slave info function */
-static char* get_drives_info (char *buffer, u8 pos)
+static void sis_ata16_program_timings(ide_drive_t *drive, const u8 mode)
 {
-	u8 reg00, reg01, reg10, reg11; /* timing registers */
-	u32 regdw0, regdw1;
-	char* p = buffer;
-
-/* Postwrite/Prefetch */
-	if (chipset_family < ATA_133) {
-		pci_read_config_byte(bmide_dev, 0x4b, &reg00);
-		p += sprintf(p, "Drive %d:        Postwrite %s \t \t Postwrite %s\n",
-			     pos, (reg00 & (0x10 << pos)) ? "Enabled" : "Disabled",
-			     (reg00 & (0x40 << pos)) ? "Enabled" : "Disabled");
-		p += sprintf(p, "                Prefetch  %s \t \t Prefetch  %s\n",
-			     (reg00 & (0x01 << pos)) ? "Enabled" : "Disabled",
-			     (reg00 & (0x04 << pos)) ? "Enabled" : "Disabled");
-		pci_read_config_byte(bmide_dev, 0x40+2*pos, &reg00);
-		pci_read_config_byte(bmide_dev, 0x41+2*pos, &reg01);
-		pci_read_config_byte(bmide_dev, 0x44+2*pos, &reg10);
-		pci_read_config_byte(bmide_dev, 0x45+2*pos, &reg11);
-	} else {
-		u32 reg54h;
-		u8 drive_pci = 0x40;
-		pci_read_config_dword(bmide_dev, 0x54, &reg54h);
-		if (reg54h & 0x40000000) {
-			// Configuration space remapped to 0x70
-			drive_pci = 0x70;
-		}
-		pci_read_config_dword(bmide_dev, (unsigned long)drive_pci+4*pos, &regdw0);
-		pci_read_config_dword(bmide_dev, (unsigned long)drive_pci+4*pos+8, &regdw1);
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u16 t1 = 0;
+	u8 drive_pci = 0x40 + drive->dn * 2;
 
-		p += sprintf(p, "Drive %d:\n", pos);
-	}
+	const u16 pio_timings[]   = { 0x000, 0x607, 0x404, 0x303, 0x301 };
+	const u16 mwdma_timings[] = { 0x008, 0x302, 0x301 };
 
+	pci_read_config_word(dev, drive_pci, &t1);
 
-/* UDMA */
-	if (chipset_family >= ATA_133) {
-		p += sprintf(p, "                UDMA %s \t \t \t UDMA %s\n",
-			     (regdw0 & 0x04) ? "Enabled" : "Disabled",
-			     (regdw1 & 0x04) ? "Enabled" : "Disabled");
-		p += sprintf(p, "                UDMA Cycle Time    %s \t UDMA Cycle Time    %s\n",
-			     cycle_time[(regdw0 & 0xF0) >> 4],
-			     cycle_time[(regdw1 & 0xF0) >> 4]);
-	} else if (chipset_family >= ATA_33) {
-		p += sprintf(p, "                UDMA %s \t \t \t UDMA %s\n",
-			     (reg01 & 0x80) ? "Enabled" : "Disabled",
-			     (reg11 & 0x80) ? "Enabled" : "Disabled");
-
-		p += sprintf(p, "                UDMA Cycle Time    ");
-		switch(chipset_family) {
-			case ATA_33:	p += sprintf(p, cycle_time[(reg01 & 0x60) >> 5]); break;
-			case ATA_66:
-			case ATA_100a:	p += sprintf(p, cycle_time[(reg01 & 0x70) >> 4]); break;
-			case ATA_100:
-			case ATA_133a:	p += sprintf(p, cycle_time[reg01 & 0x0F]); break;
-			default:	p += sprintf(p, "?"); break;
-		}
-		p += sprintf(p, " \t UDMA Cycle Time    ");
-		switch(chipset_family) {
-			case ATA_33:	p += sprintf(p, cycle_time[(reg11 & 0x60) >> 5]); break;
-			case ATA_66:
-			case ATA_100a:	p += sprintf(p, cycle_time[(reg11 & 0x70) >> 4]); break;
-			case ATA_100:
-			case ATA_133a:  p += sprintf(p, cycle_time[reg11 & 0x0F]); break;
-			default:	p += sprintf(p, "?"); break;
-		}
-		p += sprintf(p, "\n");
-	}
+	/* clear active/recovery timings */
+	t1 &= ~0x070f;
+	if (mode >= XFER_MW_DMA_0) {
+		if (chipset_family > ATA_16)
+			t1 &= ~0x8000;	/* disable UDMA */
+		t1 |= mwdma_timings[mode - XFER_MW_DMA_0];
+	} else
+		t1 |= pio_timings[mode - XFER_PIO_0];
 
+	pci_write_config_word(dev, drive_pci, t1);
+}
 
-	if (chipset_family < ATA_133) {	/* else case TODO */
+static void sis_ata100_program_timings(ide_drive_t *drive, const u8 mode)
+{
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u8 t1, drive_pci = 0x40 + drive->dn * 2;
 
-/* Data Active */
-		p += sprintf(p, "                Data Active Time   ");
-		switch(chipset_family) {
-			case ATA_16: /* confirmed */
-			case ATA_33:
-			case ATA_66:
-			case ATA_100a: p += sprintf(p, active_time[reg01 & 0x07]); break;
-			case ATA_100:
-			case ATA_133a: p += sprintf(p, active_time[(reg00 & 0x70) >> 4]); break;
-			default: p += sprintf(p, "?"); break;
-		}
-		p += sprintf(p, " \t Data Active Time   ");
-		switch(chipset_family) {
-			case ATA_16:
-			case ATA_33:
-			case ATA_66:
-			case ATA_100a: p += sprintf(p, active_time[reg11 & 0x07]); break;
-			case ATA_100:
-			case ATA_133a: p += sprintf(p, active_time[(reg10 & 0x70) >> 4]); break;
-			default: p += sprintf(p, "?"); break;
-		}
-		p += sprintf(p, "\n");
+	/* timing bits: 7:4 active 3:0 recovery */
+	const u8 pio_timings[]   = { 0x00, 0x67, 0x44, 0x33, 0x31 };
+	const u8 mwdma_timings[] = { 0x08, 0x32, 0x31 };
 
-/* Data Recovery */
-	/* warning: may need (reg&0x07) for pre ATA66 chips */
-		p += sprintf(p, "                Data Recovery Time %s \t Data Recovery Time %s\n",
-			     recovery_time[reg00 & 0x0f], recovery_time[reg10 & 0x0f]);
-	}
+	if (mode >= XFER_MW_DMA_0) {
+		u8 t2 = 0;
 
-	return p;
-}
+		pci_read_config_byte(dev, drive_pci, &t2);
+		t2 &= ~0x80;	/* disable UDMA */
+		pci_write_config_byte(dev, drive_pci, t2);
 
-static char* get_masters_info(char* buffer)
-{
-	return get_drives_info(buffer, 0);
-}
+		t1 = mwdma_timings[mode - XFER_MW_DMA_0];
+	} else
+		t1 = pio_timings[mode - XFER_PIO_0];
 
-static char* get_slaves_info(char* buffer)
-{
-	return get_drives_info(buffer, 1);
+	pci_write_config_byte(dev, drive_pci + 1, t1);
 }
 
-/* Main get_info, called on /proc/ide/sis reads */
-static int sis_get_info (char *buffer, char **addr, off_t offset, int count)
+static void sis_ata133_program_timings(ide_drive_t *drive, const u8 mode)
 {
-	char *p = buffer;
-	int len;
-	u8 reg;
-	u16 reg2, reg3;
-
-	p += sprintf(p, "\nSiS 5513 ");
-	switch(chipset_family) {
-		case ATA_16: p += sprintf(p, "DMA 16"); break;
-		case ATA_33: p += sprintf(p, "Ultra 33"); break;
-		case ATA_66: p += sprintf(p, "Ultra 66"); break;
-		case ATA_100a:
-		case ATA_100: p += sprintf(p, "Ultra 100"); break;
-		case ATA_133a:
-		case ATA_133: p += sprintf(p, "Ultra 133"); break;
-		default: p+= sprintf(p, "Unknown???"); break;
-	}
-	p += sprintf(p, " chipset\n");
-	p += sprintf(p, "--------------- Primary Channel "
-		     "---------------- Secondary Channel "
-		     "-------------\n");
-
-/* Status */
-	pci_read_config_byte(bmide_dev, 0x4a, &reg);
-	if (chipset_family == ATA_133) {
-		pci_read_config_word(bmide_dev, 0x50, &reg2);
-		pci_read_config_word(bmide_dev, 0x52, &reg3);
-	}
-	p += sprintf(p, "Channel Status: ");
-	if (chipset_family < ATA_66) {
-		p += sprintf(p, "%s \t \t \t \t %s\n",
-			     (reg & 0x04) ? "On" : "Off",
-			     (reg & 0x02) ? "On" : "Off");
-	} else if (chipset_family < ATA_133) {
-		p += sprintf(p, "%s \t \t \t \t %s \n",
-			     (reg & 0x02) ? "On" : "Off",
-			     (reg & 0x04) ? "On" : "Off");
-	} else { /* ATA_133 */
-		p += sprintf(p, "%s \t \t \t \t %s \n",
-			     (reg2 & 0x02) ? "On" : "Off",
-			     (reg3 & 0x02) ? "On" : "Off");
-	}
-
-/* Operation Mode */
-	pci_read_config_byte(bmide_dev, 0x09, &reg);
-	p += sprintf(p, "Operation Mode: %s \t \t \t %s \n",
-		     (reg & 0x01) ? "Native" : "Compatible",
-		     (reg & 0x04) ? "Native" : "Compatible");
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	u32 t1 = 0;
+	u8 drive_pci = sis_ata133_get_base(drive), clk, idx;
 
-/* 80-pin cable ? */
-	if (chipset_family >= ATA_133) {
-		p += sprintf(p, "Cable Type:     %s \t \t \t %s\n",
-			     (reg2 & 0x01) ? cable_type[1] : cable_type[0],
-			     (reg3 & 0x01) ? cable_type[1] : cable_type[0]);
-	} else if (chipset_family > ATA_33) {
-		pci_read_config_byte(bmide_dev, 0x48, &reg);
-		p += sprintf(p, "Cable Type:     %s \t \t \t %s\n",
-			     (reg & 0x10) ? cable_type[1] : cable_type[0],
-			     (reg & 0x20) ? cable_type[1] : cable_type[0]);
-	}
+	pci_read_config_dword(dev, drive_pci, &t1);
 
-/* Prefetch Count */
-	if (chipset_family < ATA_133) {
-		pci_read_config_word(bmide_dev, 0x4c, &reg2);
-		pci_read_config_word(bmide_dev, 0x4e, &reg3);
-		p += sprintf(p, "Prefetch Count: %d \t \t \t \t %d\n",
-			     reg2, reg3);
+	t1 &= 0xc0c00fff;
+	clk = (t1 & 0x08) ? ATA_133 : ATA_100;
+	if (mode >= XFER_MW_DMA_0) {
+		t1 &= ~0x04;	/* disable UDMA */
+		idx = mode - XFER_MW_DMA_0 + 5;
 	}
+		idx = mode - XFER_PIO_0;
+	t1 |= ini_time_value[clk][idx] << 12;
+	t1 |= act_time_value[clk][idx] << 16;
+	t1 |= rco_time_value[clk][idx] << 24;
 
-	p = get_masters_info(p);
-	p = get_slaves_info(p);
-
-	len = (p - buffer) - offset;
-	*addr = buffer + offset;
+	pci_write_config_dword(dev, drive_pci, t1);
+}
 
-	return len > count ? count : len;
+static void sis_program_timings(ide_drive_t *drive, const u8 mode)
+{
+	if (chipset_family < ATA_100)		/* ATA_16/33/66/100a */
+		sis_ata16_program_timings(drive, mode);
+	else if (chipset_family < ATA_133)	/* ATA_100/133a */
+		sis_ata100_program_timings(drive, mode);
+	else					/* ATA_133 */
+		sis_ata133_program_timings(drive, mode);
 }
-#endif /* defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
-/*
- * Configuration functions
- */
-/* Enables per-drive prefetch and postwrite */
 static void config_drive_art_rwp (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-
 	u8 reg4bh		= 0;
-	u8 rw_prefetch		= (0x11 << drive->dn);
+	u8 rw_prefetch		= 0;
 
-	if (drive->media != ide_disk)
-		return;
 	pci_read_config_byte(dev, 0x4b, &reg4bh);
 
-	if ((reg4bh & rw_prefetch) != rw_prefetch)
+	if (drive->media == ide_disk)
+		rw_prefetch = 0x11 << drive->dn;
+
+	if ((reg4bh & (0x11 << drive->dn)) != rw_prefetch)
 		pci_write_config_byte(dev, 0x4b, reg4bh|rw_prefetch);
 }
 
-/* Set per-drive active and recovery time */
 static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
-
-	u8 drive_pci, test1, test2;
-
 	config_drive_art_rwp(drive);
-
-	/* In pre ATA_133 case, drives sit at 0x40 + 4*drive->dn */
-	drive_pci = 0x40;
-	/* In SiS962 case drives sit at (0x40 or 0x70) + 8*drive->dn) */
-	if (chipset_family >= ATA_133) {
-		u32 reg54h;
-		pci_read_config_dword(dev, 0x54, &reg54h);
-		if (reg54h & 0x40000000) drive_pci = 0x70;
-		drive_pci += ((drive->dn)*0x4);
-	} else {
-		drive_pci += ((drive->dn)*0x2);
-	}
-
-	/* register layout changed with newer ATA100 chips */
-	if (chipset_family < ATA_100) {
-		pci_read_config_byte(dev, drive_pci, &test1);
-		pci_read_config_byte(dev, drive_pci+1, &test2);
-
-		/* Clear active and recovery timings */
-		test1 &= ~0x0F;
-		test2 &= ~0x07;
-
-		switch(pio) {
-			case 4:		test1 |= 0x01; test2 |= 0x03; break;
-			case 3:		test1 |= 0x03; test2 |= 0x03; break;
-			case 2:		test1 |= 0x04; test2 |= 0x04; break;
-			case 1:		test1 |= 0x07; test2 |= 0x06; break;
-			case 0:		/* PIO0: register setting == X000 */
-			default:	break;
-		}
-		pci_write_config_byte(dev, drive_pci, test1);
-		pci_write_config_byte(dev, drive_pci+1, test2);
-	} else if (chipset_family < ATA_133) {
-		switch(pio) { /*		active  recovery
-						  v     v */
-			case 4:		test1 = 0x30|0x01; break;
-			case 3:		test1 = 0x30|0x03; break;
-			case 2:		test1 = 0x40|0x04; break;
-			case 1:		test1 = 0x60|0x07; break;
-			case 0:		test1 = 0x00; break;
-			default:	break;
-		}
-		pci_write_config_byte(dev, drive_pci, test1);
-	} else { /* ATA_133 */
-		u32 test3;
-		pci_read_config_dword(dev, drive_pci, &test3);
-		test3 &= 0xc0c00fff;
-		if (test3 & 0x08) {
-			test3 |= ini_time_value[ATA_133][pio] << 12;
-			test3 |= act_time_value[ATA_133][pio] << 16;
-			test3 |= rco_time_value[ATA_133][pio] << 24;
-		} else {
-			test3 |= ini_time_value[ATA_100][pio] << 12;
-			test3 |= act_time_value[ATA_100][pio] << 16;
-			test3 |= rco_time_value[ATA_100][pio] << 24;
-		}
-		pci_write_config_dword(dev, drive_pci, test3);
-	}
+	sis_program_timings(drive, XFER_PIO_0 + pio);
 }
 
 static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u32 regdw;
-	u8 drive_pci, reg;
-
-	/* See sis_set_pio_mode() for drive PCI config registers */
-	drive_pci = 0x40;
-	if (chipset_family >= ATA_133) {
-		u32 reg54h;
-		pci_read_config_dword(dev, 0x54, &reg54h);
-		if (reg54h & 0x40000000) drive_pci = 0x70;
-		drive_pci += ((drive->dn)*0x4);
-		pci_read_config_dword(dev, (unsigned long)drive_pci, &regdw);
-		/* Disable UDMA bit for non UDMA modes on UDMA chips */
-		if (speed < XFER_UDMA_0) {
-			regdw &= 0xfffffffb;
-			pci_write_config_dword(dev, (unsigned long)drive_pci, regdw);
-		}
-	
-	} else {
-		drive_pci += ((drive->dn)*0x2);
-		pci_read_config_byte(dev, drive_pci+1, &reg);
-		/* Disable UDMA bit for non UDMA modes on UDMA chips */
-		if ((speed < XFER_UDMA_0) && (chipset_family > ATA_16)) {
-			reg &= 0x7F;
-			pci_write_config_byte(dev, drive_pci+1, reg);
-		}
-	}
 
 	/* Config chip for mode */
 	switch(speed) {
@@ -560,6 +320,10 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
 			if (chipset_family >= ATA_133) {
+				u32 regdw = 0;
+				u8 drive_pci = sis_ata133_get_base(drive);
+
+				pci_read_config_dword(dev, drive_pci, &regdw);
 				regdw |= 0x04;
 				regdw &= 0xfffff00f;
 				/* check if ATA133 enable */
@@ -572,6 +336,9 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 				}
 				pci_write_config_dword(dev, (unsigned long)drive_pci, regdw);
 			} else {
+				u8 drive_pci = 0x40 + drive->dn * 2, reg = 0;
+
+				pci_read_config_byte(dev, drive_pci+1, &reg);
 				/* Force the UDMA bit on if we want to use UDMA */
 				reg |= 0x80;
 				/* clean reg cycle time bits */
@@ -586,9 +353,7 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_MW_DMA_0:
-		case XFER_SW_DMA_2:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
+			sis_program_timings(drive, speed);
 			break;
 		default:
 			BUG();
@@ -596,32 +361,12 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	}
 }
 
-static int sis5513_config_xfer_rate(ide_drive_t *drive)
-{
-	/*
-	 * TODO: always set PIO mode and remove this
-	 */
-	ide_set_max_pio(drive);
-
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
-	int drive_pci;
-	u32 reg54 = 0, regdw = 0;
+	u32 regdw = 0;
+	u8 drive_pci = sis_ata133_get_base(drive);
 
-	pci_read_config_dword(dev, 0x54, &reg54);
-	drive_pci = ((reg54 & 0x40000000) ? 0x70 : 0x40) + drive->dn * 4;
 	pci_read_config_dword(dev, drive_pci, &regdw);
 
 	/* if ATA133 disable, we should not set speed above UDMA5 */
@@ -767,14 +512,6 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 				}
 				break;
 		}
-
-#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-		if (!sis_proc) {
-			sis_proc = 1;
-			bmide_dev = dev;
-			ide_pci_create_host_proc("sis", sis_get_info);
-		}
-#endif
 	}
 
 	return 0;
@@ -827,8 +564,6 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 {
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
 
-	hwif->autodma = 0;
-
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
@@ -838,32 +573,19 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	if (chipset_family >= ATA_133)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
 
-	if (!(hwif->dma_base)) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
+
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->atapi_dma = 1;
 
 	hwif->ultra_mask = udma_rates[chipset_family];
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
-
-	if (!chipset_family)
-		return;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = ata66_sis5513(hwif);
-
-	if (chipset_family > ATA_16) {
-		hwif->ide_dma_check = &sis5513_config_xfer_rate;
-		if (!noautodma)
-			hwif->autodma = 1;
-	}
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-	return;
 }
 
 static ide_pci_device_t sis5513_chipset __devinitdata = {
@@ -881,10 +603,10 @@ static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_devi
 	return ide_setup_pci_device(dev, &sis5513_chipset);
 }
 
-static struct pci_device_id sis5513_pci_tbl[] = {
-	{ PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_5513, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_5518, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_1180, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id sis5513_pci_tbl[] = {
+	{ PCI_VDEVICE(SI, PCI_DEVICE_ID_SI_5513), 0 },
+	{ PCI_VDEVICE(SI, PCI_DEVICE_ID_SI_5518), 0 },
+	{ PCI_VDEVICE(SI, PCI_DEVICE_ID_SI_1180), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, sis5513_pci_tbl);
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 2ef26e3..771efb8 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -145,19 +145,6 @@ static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
 }
 
 /*
- * Check to see if the drive and chipset are capable of DMA mode.
- */
-static int sl82c105_ide_dma_check(ide_drive_t *drive)
-{
-	DBG(("sl82c105_ide_dma_check(drive:%s)\n", drive->name));
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return -1;
-}
-
-/*
  * The SL82C105 holds off all IDE interrupts while in DMA mode until
  * all DMA activity is completed.  Sometimes this causes problems (eg,
  * when the drive wants to report an error condition).
@@ -404,17 +391,12 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	hwif->atapi_dma  = 1;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check		= &sl82c105_ide_dma_check;
 	hwif->ide_dma_on		= &sl82c105_ide_dma_on;
 	hwif->dma_off_quietly		= &sl82c105_dma_off_quietly;
 	hwif->dma_lost_irq		= &sl82c105_dma_lost_irq;
 	hwif->dma_start			= &sl82c105_dma_start;
 	hwif->dma_timeout		= &sl82c105_dma_timeout;
 
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
-
 	if (hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
 }
@@ -434,8 +416,8 @@ static int __devinit sl82c105_init_one(struct pci_dev *dev, const struct pci_dev
 	return ide_setup_pci_device(dev, &sl82c105_chipset);
 }
 
-static struct pci_device_id sl82c105_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105), 0},
+static const struct pci_device_id sl82c105_pci_tbl[] = {
+	{ PCI_VDEVICE(WINBOND, PCI_DEVICE_ID_WINBOND_82C105), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, sl82c105_pci_tbl);
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index ebac87f..fa8df6d 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.16	Jul 14, 2007
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.18	Aug 9, 2007
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
@@ -21,27 +21,6 @@
 
 #include <asm/io.h>
 
-static u8 slc90e66_dma_2_pio (u8 xfer_rate) {
-	switch(xfer_rate) {
-		case XFER_UDMA_4:
-		case XFER_UDMA_3:
-		case XFER_UDMA_2:
-		case XFER_UDMA_1:
-		case XFER_UDMA_0:
-		case XFER_MW_DMA_2:
-			return 4;
-		case XFER_MW_DMA_1:
-			return 3;
-		case XFER_SW_DMA_2:
-			return 2;
-		case XFER_MW_DMA_0:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-		default:
-			return 0;
-	}
-}
-
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -132,26 +111,21 @@ static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			pci_write_config_word(dev, 0x4a, reg4a|u_speed);
 		}
 	} else {
+		const u8 mwdma_to_pio[] = { 0, 3, 4 };
+		u8 pio;
+
 		if (reg48 & u_flag)
 			pci_write_config_word(dev, 0x48, reg48 & ~u_flag);
 		if (reg4a & a_speed)
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
-	}
-
-	slc90e66_set_pio_mode(drive, slc90e66_dma_2_pio(speed));
-}
 
-static int slc90e66_config_drive_xfer_rate (ide_drive_t *drive)
-{
-	drive->init_speed = 0;
-
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
+		if (speed >= XFER_MW_DMA_0)
+			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+		else
+			pio = 2; /* only SWDMA2 is allowed */
 
-	return -1;
+		slc90e66_set_pio_mode(drive, pio);
+	}
 }
 
 static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
@@ -159,8 +133,6 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 	u8 reg47 = 0;
 	u8 mask = hwif->channel ? 0x01 : 0x02;  /* bit0:Primary */
 
-	hwif->autodma = 0;
-
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
@@ -169,11 +141,11 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 
 	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
+
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x1f;
@@ -183,13 +155,6 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		/* bit[0(1)]: 0:80, 1:40 */
 		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-
-	hwif->ide_dma_check = &slc90e66_config_drive_xfer_rate;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t slc90e66_chipset __devinitdata = {
@@ -206,8 +171,8 @@ static int __devinit slc90e66_init_one(struct pci_dev *dev, const struct pci_dev
 	return ide_setup_pci_device(dev, &slc90e66_chipset);
 }
 
-static struct pci_device_id slc90e66_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_EFAR, PCI_DEVICE_ID_EFAR_SLC90E66_1), 0},
+static const struct pci_device_id slc90e66_pci_tbl[] = {
+	{ PCI_VDEVICE(EFAR, PCI_DEVICE_ID_EFAR_SLC90E66_1), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, slc90e66_pci_tbl);
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 840415d..de62db5 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -162,17 +162,6 @@ static int tc86c001_busproc(ide_drive_t *drive, int state)
 	return 0;
 }
 
-static int tc86c001_config_drive_xfer_rate(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 {
 	unsigned long sc_base	= pci_resource_start(hwif->pci_dev, 5);
@@ -213,7 +202,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->ultra_mask = 0x1f;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->ide_dma_check	= &tc86c001_config_drive_xfer_rate;
 	hwif->dma_start 	= &tc86c001_dma_start;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
@@ -224,10 +212,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 		scr1 = hwif->INW(sc_base + 0x00);
 		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
 }
 
 static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
@@ -256,9 +240,8 @@ static int __devinit tc86c001_init_one(struct pci_dev *dev,
 	return ide_setup_pci_device(dev, &tc86c001_chipset);
 }
 
-static struct pci_device_id tc86c001_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_TC86C001_IDE,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id tc86c001_pci_tbl[] = {
+	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_TC86C001_IDE), 0 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, tc86c001_pci_tbl);
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 54e411d..4075c90 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -96,16 +96,6 @@ static void triflex_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	triflex_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 {
 	hwif->set_pio_mode = &triflex_set_pio_mode;
@@ -117,12 +107,6 @@ static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 	hwif->atapi_dma  = 1;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
-	hwif->ide_dma_check = &triflex_config_drive_xfer_rate;
-	
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t triflex_device __devinitdata = {
@@ -140,9 +124,8 @@ static int __devinit triflex_init_one(struct pci_dev *dev,
 	return ide_setup_pci_device(dev, &triflex_device);
 }
 
-static struct pci_device_id triflex_pci_tbl[] = {
-	{ PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_TRIFLEX_IDE,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+static const struct pci_device_id triflex_pci_tbl[] = {
+	{ PCI_VDEVICE(COMPAQ, PCI_DEVICE_ID_COMPAQ_TRIFLEX_IDE), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, triflex_pci_tbl);
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index dc4f4e2..e3d943a 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -292,9 +292,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	hwif->ide_dma_test_irq = &trm290_ide_dma_test_irq;
 
 	hwif->selectproc = &trm290_selectproc;
-	hwif->autodma = 0;		/* play it safe for now */
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 #if 1
 	{
 	/*
@@ -329,6 +326,9 @@ static ide_pci_device_t trm290_chipset __devinitdata = {
 	.init_hwif	= init_hwif_trm290,
 	.autodma	= NOAUTODMA,
 	.bootable	= ON_BOARD,
+#if 0 /* play it safe for now */
+	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+#endif
 };
 
 static int __devinit trm290_init_one(struct pci_dev *dev, const struct pci_device_id *id)
@@ -336,8 +336,8 @@ static int __devinit trm290_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &trm290_chipset);
 }
 
-static struct pci_device_id trm290_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TEKRAM, PCI_DEVICE_ID_TEKRAM_DC290, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id trm290_pci_tbl[] = {
+	{ PCI_VDEVICE(TEKRAM, PCI_DEVICE_ID_TEKRAM_DC290), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, trm290_pci_tbl);
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 479e496..b25fb65 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -197,24 +197,6 @@ static void via_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	via_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-/**
- *	via82cxxx_ide_dma_check		-	set up for DMA if possible
- *	@drive: IDE drive to set up
- *
- *	Set up the drive for the highest supported speed considering the
- *	driver, controller and cable
- */
- 
-static int via82cxxx_ide_dma_check (ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	ide_set_max_pio(drive);
-
-	return -1;
-}
-
 static struct via_isa_bridge *via_config_find(struct pci_dev **isa)
 {
 	struct via_isa_bridge *via_config;
@@ -443,8 +425,6 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
 	int i;
 
-	hwif->autodma = 0;
-
 	hwif->set_pio_mode = &via_set_pio_mode;
 	hwif->set_dma_mode = &via_set_drive;
 
@@ -458,7 +438,6 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 		hwif->drives[i].io_32bit = 1;
 		hwif->drives[i].unmask = (vdev->via_config->flags & VIA_NO_UNMASK) ? 0 : 1;
 		hwif->drives[i].autotune = 1;
-		hwif->drives[i].dn = hwif->channel * 2 + i;
 	}
 
 	if (!hwif->dma_base)
@@ -472,12 +451,6 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = via82cxxx_cable_detect(hwif);
-
-	hwif->ide_dma_check = &via82cxxx_ide_dma_check;
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
@@ -522,11 +495,11 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	return ide_setup_pci_device(dev, &via82cxxx_chipsets[id->driver_data]);
 }
 
-static struct pci_device_id via_pci_tbl[] = {
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C576_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_6410,     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_SATA_EIDE,     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+static const struct pci_device_id via_pci_tbl[] = {
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1),  0 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C586_1),  0 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410),      1 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, via_pci_tbl);
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 9e86406..1d25a34 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1421,17 +1421,12 @@ static struct macio_driver pmac_ide_macio_driver =
 	.resume		= pmac_ide_macio_resume,
 };
 
-static struct pci_device_id pmac_ide_pci_match[] = {
-	{ PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_UNI_N_ATA,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_IPID_ATA100,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_K2_ATA100,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_SH_ATA,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_IPID2_ATA,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+static const struct pci_device_id pmac_ide_pci_match[] = {
+	{ PCI_VDEVICE(APPLE, PCI_DEVICE_ID_APPLE_UNI_N_ATA),	0 },
+	{ PCI_VDEVICE(APPLE, PCI_DEVICE_ID_APPLE_IPID_ATA100),	0 },
+	{ PCI_VDEVICE(APPLE, PCI_DEVICE_ID_APPLE_K2_ATA100),	0 },
+	{ PCI_VDEVICE(APPLE, PCI_DEVICE_ID_APPLE_SH_ATA),	0 },
+	{ PCI_VDEVICE(APPLE, PCI_DEVICE_ID_APPLE_IPID2_ATA),	0 },
 	{},
 };
 
@@ -1579,19 +1574,6 @@ pmac_ide_destroy_dmatable (ide_drive_t *drive)
 }
 
 /*
- * Check what is the best DMA timing setting for the drive and
- * call appropriate functions to apply it.
- */
-static int
-pmac_ide_dma_check(ide_drive_t *drive)
-{
-	if (ide_tune_dma(drive))
-		return 0;
-
-	return -1;
-}
-
-/*
  * Prepare a DMA transfer. We build the DMA table, adjust the timings for
  * a read on KeyLargo ATA/66 and mark us as waiting for DMA completion
  */
@@ -1788,7 +1770,6 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 
 	hwif->dma_off_quietly = &ide_dma_off_quietly;
 	hwif->ide_dma_on = &__ide_dma_on;
-	hwif->ide_dma_check = &pmac_ide_dma_check;
 	hwif->dma_setup = &pmac_ide_dma_setup;
 	hwif->dma_exec_cmd = &pmac_ide_dma_exec_cmd;
 	hwif->dma_start = &pmac_ide_dma_start;
@@ -1823,9 +1804,6 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 			hwif->swdma_mask = 0x00;
 			break;
 	}
-
-	hwif->autodma = 1;
-	hwif->drives[1].autodma = hwif->drives[0].autodma = hwif->autodma;
 }
 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 1129f8c..3d101f7 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -145,27 +145,13 @@ static int ide_setup_pci_baseregs (struct pci_dev *dev, const char *name)
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-
-#ifdef CONFIG_BLK_DEV_IDEDMA_FORCED
-/*
- * Long lost data from 2.0.34 that is now in 2.0.39
- *
- * This was used in ./drivers/block/triton.c to do DMA Base address setup
- * when PnP failed.  Oh the things we forget.  I believe this was part
- * of SFF-8038i that has been withdrawn from public access... :-((
- */
-#define DEFAULT_BMIBA	0xe800	/* in case BIOS did not init it */
-#define DEFAULT_BMCRBA	0xcc00	/* VIA's default value */
-#define DEFAULT_BMALIBA	0xd400	/* ALI's default value */
-#endif /* CONFIG_BLK_DEV_IDEDMA_FORCED */
-
 /**
  *	ide_get_or_set_dma_base		-	setup BMIBA
  *	@hwif: Interface
  *
- *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space:
- *	If need be we set up the DMA base. Where a device has a partner that
- *	is already in DMA mode we check and enforce IDE simplex rules.
+ *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
+ *	Where a device has a partner that is already in DMA mode we check
+ *	and enforce IDE simplex rules.
  */
 
 static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
@@ -173,12 +159,6 @@ static unsigned long ide_get_or_set_dma_base (ide_hwif_t *hwif)
 	unsigned long	dma_base = 0;
 	struct pci_dev	*dev = hwif->pci_dev;
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_FORCED
-	int second_chance = 0;
-
-second_chance_to_dma:
-#endif /* CONFIG_BLK_DEV_IDEDMA_FORCED */
-
 	if (hwif->mmio)
 		return hwif->dma_base;
 
@@ -192,26 +172,6 @@ second_chance_to_dma:
 		}
 	}
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_FORCED
-	/* FIXME - should use pci_assign_resource surely */
-	if ((!dma_base) && (!second_chance)) {
-		unsigned long set_bmiba = 0;
-		second_chance++;
-		switch(dev->vendor) {
-			case PCI_VENDOR_ID_AL:
-				set_bmiba = DEFAULT_BMALIBA; break;
-			case PCI_VENDOR_ID_VIA:
-				set_bmiba = DEFAULT_BMCRBA; break;
-			case PCI_VENDOR_ID_INTEL:
-				set_bmiba = DEFAULT_BMIBA; break;
-			default:
-				return dma_base;
-		}
-		pci_write_config_dword(dev, 0x20, set_bmiba|1);
-		goto second_chance_to_dma;
-	}
-#endif /* CONFIG_BLK_DEV_IDEDMA_FORCED */
-
 	if (dma_base) {
 		u8 simplex_stat = 0;
 		dma_base += hwif->channel ? 8 : 0;
@@ -478,8 +438,6 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
  			 * Set up BM-DMA capability
 			 * (PnP BIOS should have done this)
  			 */
-			/* default DMA off if we had to configure it here */
-			hwif->autodma = 0;
 			pci_set_master(dev);
 			if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) || !(pcicmd & PCI_COMMAND_MASTER)) {
 				printk(KERN_ERR "%s: %s error updating PCICMD\n",
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 30a1931..e39ee2f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -576,7 +576,6 @@ typedef struct ide_drive_s {
 	select_t	select;		/* basic drive/head select reg value */
 
 	u8	keep_settings;		/* restore settings after drive reset */
-	u8	autodma;		/* device can safely use dma on host */
 	u8	using_dma;		/* disk is using dma for read/write */
 	u8	retry_pio;		/* retrying dma capable host in pio */
 	u8	state;			/* retry state */
@@ -600,6 +599,7 @@ typedef struct ide_drive_s {
 	unsigned nice0		: 1;	/* give obvious excess bandwidth */
 	unsigned nice2		: 1;	/* give a share in our own bandwidth */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
+	unsigned nodma		: 1;	/* disallow DMA */
 	unsigned autotune	: 2;	/* 0=default, 1=autotune, 2=noautotune */
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
@@ -736,7 +736,6 @@ typedef struct hwif_s {
 	void (*dma_exec_cmd)(ide_drive_t *, u8);
 	void (*dma_start)(ide_drive_t *);
 	int (*ide_dma_end)(ide_drive_t *drive);
-	int (*ide_dma_check)(ide_drive_t *drive);
 	int (*ide_dma_on)(ide_drive_t *drive);
 	void (*dma_off_quietly)(ide_drive_t *drive);
 	int (*ide_dma_test_irq)(ide_drive_t *drive);
@@ -798,7 +797,6 @@ typedef struct hwif_s {
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
-	unsigned	autodma    : 1;	/* auto-attempt using DMA at boot */
 	unsigned	no_lba48   : 1; /* 1 = cannot do LBA48 */
 	unsigned	no_lba48_dma : 1; /* 1 = cannot do LBA48 DMA */
 	unsigned	auto_poll  : 1; /* supports nop auto-poll */
@@ -1256,6 +1254,10 @@ enum {
 	IDE_HFLAG_POST_SET_MODE		= (1 << 8),
 	/* don't program host/device for the transfer mode ("smart" hosts) */
 	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
+	/* trust BIOS for programming chipset/device for DMA */
+	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
+	/* host uses VDMA */
+	IDE_HFLAG_VDMA			= (1 << 11),
 };
 
 typedef struct ide_pci_device_s {
@@ -1303,7 +1305,6 @@ static inline u8 ide_max_dma_mode(ide_drive_t *drive)
 	return ide_find_dma_mode(drive, XFER_UDMA_6);
 }
 
-int ide_tune_dma(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
 void ide_dma_verbose(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
@@ -1330,7 +1331,6 @@ extern void ide_dma_timeout(ide_drive_t *);
 #else
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
-static inline int ide_tune_dma(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
@@ -1380,7 +1380,6 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 extern char *ide_xfer_verbose(u8 xfer_rate);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
-int ide_use_fast_pio(ide_drive_t *);
 
 static inline int ide_dev_has_iordy(struct hd_driveid *id)
 {
