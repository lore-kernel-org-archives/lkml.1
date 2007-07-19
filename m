Return-Path: <linux-kernel-owner+w=401wt.eu-S1765012AbXGSXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765012AbXGSXP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXGSXO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:14:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576AbXGSXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jolNKVo3aHlKIoJFek4zFYTw4c2cqIp651PK71qSQ3AhbFow1vf0gLv9wT7EAa4qsZiul6jNuu1tQ34DpnMH2/xEfeT7Hog91SB0E+/UaYJn67m5odHH7wDtPCa/uTNy1wDygZ+aNRx1/mgEQzPvRNYZVuuCQQV2LDI8iLquMSw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates
Date: Fri, 20 Jul 2007 01:30:32 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200130.32219.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What's in:
- host driver updates (scc_pata, atiixp, siimage, serverworks)
- various fixes for handling PIO modes
- SCSI-ioctls support for ide-floppy
- some other improvements/cleanups


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ata/pata_pcmcia.c      |    1 +
 drivers/ide/cris/ide-cris.c    |    9 +--
 drivers/ide/ide-floppy.c       |   18 +++++-
 drivers/ide/ide-io.c           |    5 +-
 drivers/ide/ide-lib.c          |   72 ++++++++++++---------
 drivers/ide/ide-timing.h       |   20 +-----
 drivers/ide/ide.c              |   86 +-----------------------
 drivers/ide/legacy/ali14xx.c   |    7 +-
 drivers/ide/legacy/dtc2278.c   |    3 +-
 drivers/ide/legacy/ht6560b.c   |   12 ++-
 drivers/ide/legacy/ide-cs.c    |    1 +
 drivers/ide/legacy/qd65xx.c    |   21 +++---
 drivers/ide/legacy/umc8672.c   |    4 +-
 drivers/ide/mips/au1xxx-ide.c  |    4 +-
 drivers/ide/pci/aec62xx.c      |   18 ++----
 drivers/ide/pci/alim15x3.c     |    5 +-
 drivers/ide/pci/amd74xx.c      |   24 ++++---
 drivers/ide/pci/atiixp.c       |   37 ++++++----
 drivers/ide/pci/cmd640.c       |   19 +++---
 drivers/ide/pci/cmd64x.c       |   21 +++---
 drivers/ide/pci/cs5520.c       |    6 +-
 drivers/ide/pci/cs5530.c       |    4 +-
 drivers/ide/pci/cs5535.c       |    9 ++-
 drivers/ide/pci/cy82c693.c     |    5 +-
 drivers/ide/pci/generic.c      |   15 ----
 drivers/ide/pci/hpt34x.c       |   17 ++----
 drivers/ide/pci/hpt366.c       |   36 ++++------
 drivers/ide/pci/it8213.c       |    7 +-
 drivers/ide/pci/it821x.c       |    8 +-
 drivers/ide/pci/jmicron.c      |    4 +-
 drivers/ide/pci/ns87415.c      |    1 -
 drivers/ide/pci/opti621.c      |    8 +-
 drivers/ide/pci/pdc202xx_new.c |   23 ++----
 drivers/ide/pci/pdc202xx_old.c |   20 ++----
 drivers/ide/pci/piix.c         |    8 +-
 drivers/ide/pci/rz1000.c       |    1 -
 drivers/ide/pci/sc1200.c       |   43 +-----------
 drivers/ide/pci/scc_pata.c     |   76 +++++++++++++++++-----
 drivers/ide/pci/serverworks.c  |  105 +++++++++++++++---------------
 drivers/ide/pci/sgiioc4.c      |    3 +-
 drivers/ide/pci/siimage.c      |  139 ++++++++++++----------------------------
 drivers/ide/pci/sis5513.c      |    4 +-
 drivers/ide/pci/sl82c105.c     |   22 ++++---
 drivers/ide/pci/slc90e66.c     |    4 +-
 drivers/ide/pci/tc86c001.c     |    7 +-
 drivers/ide/pci/triflex.c      |    4 +-
 drivers/ide/pci/trm290.c       |    1 -
 drivers/ide/pci/via82cxxx.c    |   26 ++++---
 drivers/ide/ppc/mpc8xx.c       |    5 +-
 drivers/ide/ppc/pmac.c         |   16 +++--
 drivers/ide/setup-pci.c        |   18 ++----
 include/linux/ata.h            |    9 +++
 include/linux/ide.h            |   31 ++++++---
 53 files changed, 473 insertions(+), 599 deletions(-)


Alan Cox (1):
      ide: Stop mapping ROMs

Bartlomiej Zolnierkiewicz (18):
      atiixp: PIO mode setup fixes
      siimage: PIO mode setup fixes (take 2)
      ide: make ide_get_best_pio_mode() print info if overriding PIO mode
      ide: add ide_dev_has_iordy() helper (take 4)
      ide: add ide_pci_device_t.host_flags (take 2)
      serverworks: always tune PIO
      serverworks: fix DMA
      ide: ide_start_power_step() fix WRT disabling DMA
      sc1200: remove stale Power Management code
      ide: add ide_pio_cycle_time() helper (take 2)
      ide: ide_find_best_pio_mode() fixes (take 2)
      ide: drop "PIO data" argument from ide_get_best_pio_mode()
      ide: remove ide_find_best_pio_mode()
      ide: add PIO masks
      ide-cris: handle PIO auto-tuning in tune_cris_ide()
      ide: remove stale changelog/comments/TODO from ide.c
      ide: remove stale changelog from setup-pci.c
      ide: add support for SCSI ioctls to ide-floppy

Kou Ishizaki (1):
      scc_pata.c: Workaround for errata A308 (take 2)

Kumar Gala (1):
      scc_pata: Use inline function for eieio

Marcin Juszkiewicz (1):
      PCMCIA: Add another MemoryCard to ide-cs/pata_pcmcia

Robert P. J. Day (1):
      IDE: Remove references to dead ETRAX-related variables.


diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index a56257c..6da23fe 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -382,6 +382,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 886091b..fbfea46 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -414,12 +414,6 @@ cris_ide_reset(unsigned val)
 #ifdef CONFIG_ETRAX_IDE_G27_RESET
 	REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow, 27, val);
 #endif
-#ifdef CONFIG_ETRAX_IDE_CSE1_16_RESET
-	REG_SHADOW_SET(port_cse1_addr, port_cse1_shadow, 16, val);
-#endif
-#ifdef CONFIG_ETRAX_IDE_CSP0_8_RESET
-	REG_SHADOW_SET(port_csp0_addr, port_csp0_shadow, 8, val);
-#endif
 #ifdef CONFIG_ETRAX_IDE_PB7_RESET
 	port_pb_dir_shadow = port_pb_dir_shadow |
 		IO_STATE(R_PORT_PB_DIR, dir7, output);
@@ -690,6 +684,8 @@ static void tune_cris_ide(ide_drive_t *drive, u8 pio)
 {
 	int setup, strobe, hold;
 
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+
 	switch(pio)
 	{
 		case 0:
@@ -820,6 +816,7 @@ init_e100_ide (void)
 		hwif->dma_host_on = &cris_dma_on;
 		hwif->dma_off_quietly = &cris_dma_off;
 		hwif->cbl = ATA_CBL_PATA40;
+		hwif->pio_mask = ATA_PIO4,
 		hwif->ultra_mask = cris_ultra_mask;
 		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
 		hwif->autodma = 1;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index a21f585..ae8e1a6 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -99,6 +99,8 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 
+#include <scsi/scsi_ioctl.h>
+
 #include <asm/byteorder.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -2099,7 +2101,21 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
-	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	/*
+	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
+	 * and CDROM_SEND_PACKET (legacy) ioctls
+	 */
+	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
+		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
+					bdev->bd_disk, cmd, argp);
+	else
+		err = -ENOTTY;
+
+	if (err == -ENOTTY)
+		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	return err;
 }
 
 static int idefloppy_media_changed(struct gendisk *disk)
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index f9de798..484c50e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -224,11 +224,12 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		 * we could be smarter and check for current xfer_speed
 		 * in struct drive etc...
 		 */
-		if ((drive->id->capability & 1) == 0)
-			break;
 		if (drive->hwif->ide_dma_check == NULL)
 			break;
 		drive->hwif->dma_off_quietly(drive);
+		/*
+		 * TODO: respect ->using_dma setting
+		 */
 		ide_set_dma(drive);
 		break;
 	}
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 074bb32..92a6c7b 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -249,12 +249,34 @@ static int ide_scan_pio_blacklist (char *model)
 	return -1;
 }
 
+unsigned int ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
+{
+	struct hd_driveid *id = drive->id;
+	int cycle_time = 0;
+
+	if (id->field_valid & 2) {
+		if (id->capability & 8)
+			cycle_time = id->eide_pio_iordy;
+		else
+			cycle_time = id->eide_pio;
+	}
+
+	/* conservative "downgrade" for all pre-ATA2 drives */
+	if (pio < 3) {
+		if (cycle_time && cycle_time < ide_pio_timings[pio].cycle_time)
+			cycle_time = 0; /* use standard timing */
+	}
+
+	return cycle_time ? cycle_time : ide_pio_timings[pio].cycle_time;
+}
+
+EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
+
 /**
  *	ide_get_best_pio_mode	-	get PIO mode from drive
  *	@drive: drive to consider
  *	@mode_wanted: preferred mode
  *	@max_mode: highest allowed mode
- *	@d: PIO data
  *
  *	This routine returns the recommended PIO settings for a given drive,
  *	based on the drive->id information and the ide_pio_blacklist[].
@@ -263,22 +285,18 @@ static int ide_scan_pio_blacklist (char *model)
  *	This is used by most chipset support modules when "auto-tuning".
  */
 
-u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_pio_data_t *d)
+u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 {
 	int pio_mode;
-	int cycle_time = 0;
-	int use_iordy = 0;
 	struct hd_driveid* id = drive->id;
 	int overridden  = 0;
 
-	if (mode_wanted != 255) {
-		pio_mode = mode_wanted;
-		use_iordy = (pio_mode > 2);
-	} else if (!drive->id) {
-		pio_mode = 0;
-	} else if ((pio_mode = ide_scan_pio_blacklist(id->model)) != -1) {
-		overridden = 1;
-		use_iordy = (pio_mode > 2);
+	if (mode_wanted != 255)
+		return min_t(u8, mode_wanted, max_mode);
+
+	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0 &&
+	    (pio_mode = ide_scan_pio_blacklist(id->model)) != -1) {
+		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
 	} else {
 		pio_mode = id->tPIO;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
@@ -286,9 +304,7 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_p
 			overridden = 1;
 		}
 		if (id->field_valid & 2) {	  /* drive implements ATA2? */
-			if (id->capability & 8) { /* drive supports use_iordy? */
-				use_iordy = 1;
-				cycle_time = id->eide_pio_iordy;
+			if (id->capability & 8) { /* IORDY supported? */
 				if (id->eide_pio_modes & 7) {
 					overridden = 0;
 					if (id->eide_pio_modes & 4)
@@ -298,31 +314,27 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_p
 					else
 						pio_mode = 3;
 				}
-			} else {
-				cycle_time = id->eide_pio;
 			}
 		}
 
+		if (overridden)
+			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
+					 drive->name);
+
 		/*
 		 * Conservative "downgrade" for all pre-ATA2 drives
 		 */
-		if (pio_mode && pio_mode < 4) {
+		if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_DOWNGRADE) == 0 &&
+		    pio_mode && pio_mode < 4) {
 			pio_mode--;
-			overridden = 1;
-			if (cycle_time && cycle_time < ide_pio_timings[pio_mode].cycle_time)
-				cycle_time = 0; /* use standard timing */
+			printk(KERN_INFO "%s: applying conservative "
+					 "PIO \"downgrade\"\n", drive->name);
 		}
 	}
-	if (pio_mode > max_mode) {
+
+	if (pio_mode > max_mode)
 		pio_mode = max_mode;
-		cycle_time = 0;
-	}
-	if (d) {
-		d->pio_mode = pio_mode;
-		d->cycle_time = cycle_time ? cycle_time : ide_pio_timings[pio_mode].cycle_time;
-		d->use_iordy = use_iordy;
-		d->overridden = overridden;
-	}
+
 	return pio_mode;
 }
 
diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
index e6cb859..daffbb9 100644
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -106,23 +106,6 @@ static struct ide_timing ide_timing[] = {
 #define XFER_EPIO	0x01
 #define XFER_PIO	0x00
 
-static short ide_find_best_pio_mode(ide_drive_t *drive)
-{
-	struct hd_driveid *id = drive->id;
-	short best = 0;
-
-	if (id->field_valid & 2) {	/* EIDE PIO modes */
-
-		if ((best = (drive->id->eide_pio_modes & 4) ? XFER_PIO_5 :
-			    (drive->id->eide_pio_modes & 2) ? XFER_PIO_4 :
-			    (drive->id->eide_pio_modes & 1) ? XFER_PIO_3 : 0)) return best;
-	}
-	
-	return  (drive->id->tPIO == 2) ? XFER_PIO_2 :
-		(drive->id->tPIO == 1) ? XFER_PIO_1 :
-		(drive->id->tPIO == 0) ? XFER_PIO_0 : XFER_PIO_SLOW;
-}
-
 static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q, int T, int UT)
 {
 	q->setup   = EZ(t->setup   * 1000,  T);
@@ -212,7 +195,8 @@ static int ide_timing_compute(ide_drive_t *drive, short speed, struct ide_timing
  */
 
 	if ((speed & XFER_MODE) != XFER_PIO) {
-		ide_timing_compute(drive, ide_find_best_pio_mode(drive), &p, T, UT);
+		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
+		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
 		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 077fb67..5e88a06 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -16,10 +16,6 @@
  *   (usually 14 & 15).
  * There can be up to two drives per interface, as per the ATA-2 spec.
  *
- * Primary:    ide0, port 0x1f0; major=3;  hda is minor=0; hdb is minor=64
- * Secondary:  ide1, port 0x170; major=22; hdc is minor=0; hdd is minor=64
- * Tertiary:   ide2, port 0x???; major=33; hde is minor=0; hdf is minor=64
- * Quaternary: ide3, port 0x???; major=34; hdg is minor=0; hdh is minor=64
  * ...
  *
  *  From hd.c:
@@ -47,80 +43,6 @@
  *  This was a rewrite of just about everything from hd.c, though some original
  *  code is still sprinkled about.  Think of it as a major evolution, with
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
- *
- *  Version 1.0 ALPHA	initial code, primary i/f working okay
- *  Version 1.3 BETA	dual i/f on shared irq tested & working!
- *  Version 1.4 BETA	added auto probing for irq(s)
- *  Version 1.5 BETA	added ALPHA (untested) support for IDE cd-roms,
- *  ...
- * Version 5.50		allow values as small as 20 for idebus=
- * Version 5.51		force non io_32bit in drive_cmd_intr()
- *			change delay_10ms() to delay_50ms() to fix problems
- * Version 5.52		fix incorrect invalidation of removable devices
- *			add "hdx=slow" command line option
- * Version 5.60		start to modularize the driver; the disk and ATAPI
- *			 drivers can be compiled as loadable modules.
- *			move IDE probe code to ide-probe.c
- *			move IDE disk code to ide-disk.c
- *			add support for generic IDE device subdrivers
- *			add m68k code from Geert Uytterhoeven
- *			probe all interfaces by default
- *			add ioctl to (re)probe an interface
- * Version 6.00		use per device request queues
- *			attempt to optimize shared hwgroup performance
- *			add ioctl to manually adjust bandwidth algorithms
- *			add kerneld support for the probe module
- *			fix bug in ide_error()
- *			fix bug in the first ide_get_lock() call for Atari
- *			don't flush leftover data for ATAPI devices
- * Version 6.01		clear hwgroup->active while the hwgroup sleeps
- *			support HDIO_GETGEO for floppies
- * Version 6.02		fix ide_ack_intr() call
- *			check partition table on floppies
- * Version 6.03		handle bad status bit sequencing in ide_wait_stat()
- * Version 6.10		deleted old entries from this list of updates
- *			replaced triton.c with ide-dma.c generic PCI DMA
- *			added support for BIOS-enabled UltraDMA
- *			rename all "promise" things to "pdc4030"
- *			fix EZ-DRIVE handling on small disks
- * Version 6.11		fix probe error in ide_scan_devices()
- *			fix ancient "jiffies" polling bugs
- *			mask all hwgroup interrupts on each irq entry
- * Version 6.12		integrate ioctl and proc interfaces
- *			fix parsing of "idex=" command line parameter
- * Version 6.13		add support for ide4/ide5 courtesy rjones@orchestream.com
- * Version 6.14		fixed IRQ sharing among PCI devices
- * Version 6.15		added SMP awareness to IDE drivers
- * Version 6.16		fixed various bugs; even more SMP friendly
- * Version 6.17		fix for newest EZ-Drive problem
- * Version 6.18		default unpartitioned-disk translation now "BIOS LBA"
- * Version 6.19		Re-design for a UNIFORM driver for all platforms,
- *			  model based on suggestions from Russell King and
- *			  Geert Uytterhoeven
- *			Promise DC4030VL now supported.
- *			add support for ide6/ide7
- *			delay_50ms() changed to ide_delay_50ms() and exported.
- * Version 6.20		Added/Fixed Generic ATA-66 support and hwif detection.
- *			Added hdx=flash to allow for second flash disk
- *			  detection w/o the hang loop.
- *			Added support for ide8/ide9
- *			Added idex=ata66 for the quirky chipsets that are
- *			  ATA-66 compliant, but have yet to determine a method
- *			  of verification of the 80c cable presence.
- *			  Specifically Promise's PDC20262 chipset.
- * Version 6.21		Fixing/Fixed SMP spinlock issue with insight from an old
- *			  hat that clarified original low level driver design.
- * Version 6.30		Added SMP support; fixed multmode issues.  -ml
- * Version 6.31		Debug Share INTR's and request queue streaming
- *			Native ATA-100 support
- *			Prep for Cascades Project
- * Version 7.00alpha	First named revision of ide rearrange
- *
- *  Some additional driver compile-time options are in ./include/linux/ide.h
- *
- *  To do, in likely order of completion:
- *	- modify kernel to obtain BIOS geometry for drives on 2nd/3rd/4th i/f
- *
  */
 
 #define	REVISION	"Revision: 7.00alpha2"
@@ -455,6 +377,10 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->straight8			= tmp_hwif->straight8;
 	hwif->bus_state			= tmp_hwif->bus_state;
 
+	hwif->host_flags		= tmp_hwif->host_flags;
+
+	hwif->pio_mask			= tmp_hwif->pio_mask;
+
 	hwif->atapi_dma			= tmp_hwif->atapi_dma;
 	hwif->ultra_mask		= tmp_hwif->ultra_mask;
 	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
@@ -1171,10 +1097,6 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			return 0;
 		}
 
-		case CDROMEJECT:
-		case CDROMCLOSETRAY:
-			return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
-
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index df17ed6..9b9c476 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -115,13 +115,12 @@ static void ali14xx_tune_drive (ide_drive_t *drive, u8 pio)
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	ide_pio_data_t d;
 	int bus_speed = system_bus_clock();
 
-	pio = ide_get_best_pio_mode(drive, pio, ALI_MAX_PIO, &d);
+	pio = ide_get_best_pio_mode(drive, pio, ALI_MAX_PIO);
 
 	/* calculate timing, according to PIO mode */
-	time1 = d.cycle_time;
+	time1 = ide_pio_cycle_time(drive, pio);
 	time2 = ide_pio_timings[pio].active_time;
 	param3 = param1 = (time2 * bus_speed + 999) / 1000;
 	param4 = param2 = (time1 * bus_speed + 999) / 1000 - param1;
@@ -212,10 +211,12 @@ static int __init ali14xx_probe(void)
 	mate = &ide_hwifs[1];
 
 	hwif->chipset = ide_ali14xx;
+	hwif->pio_mask = ATA_PIO4;
 	hwif->tuneproc = &ali14xx_tune_drive;
 	hwif->mate = mate;
 
 	mate->chipset = ide_ali14xx;
+	mate->pio_mask = ATA_PIO4;
 	mate->tuneproc = &ali14xx_tune_drive;
 	mate->mate = hwif;
 	mate->channel = 1;
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 36a3f0a..6c01d95 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -71,7 +71,7 @@ static void tune_dtc2278 (ide_drive_t *drive, u8 pio)
 {
 	unsigned long flags;
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 
 	if (pio >= 3) {
 		spin_lock_irqsave(&ide_lock, flags);
@@ -123,6 +123,7 @@ static int __init dtc2278_probe(void)
 
 	hwif->serialized = 1;
 	hwif->chipset = ide_dtc2278;
+	hwif->pio_mask = ATA_PIO4;
 	hwif->tuneproc = &tune_dtc2278;
 	hwif->drives[0].no_unmask = 1;
 	hwif->drives[1].no_unmask = 1;
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index c8f353b..bfaa202 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -203,19 +203,21 @@ static u8 ht_pio2timings(ide_drive_t *drive, u8 pio)
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	ide_pio_data_t d;
 	int bus_speed = system_bus_clock();
 	
         if (pio) {
-		pio = ide_get_best_pio_mode(drive, pio, 5, &d);
-		
+		unsigned int cycle_time;
+
+		pio = ide_get_best_pio_mode(drive, pio, 5);
+		cycle_time = ide_pio_cycle_time(drive, pio);
+
 		/*
 		 *  Just like opti621.c we try to calculate the
 		 *  actual cycle time for recovery and activity
 		 *  according system bus speed.
 		 */
 		active_time = ide_pio_timings[pio].active_time;
-		recovery_time = d.cycle_time 
+		recovery_time = cycle_time
 			- active_time
 			- ide_pio_timings[pio].setup_time;
 		/*
@@ -331,12 +333,14 @@ int __init ht6560b_init(void)
 
 	hwif->chipset = ide_ht6560b;
 	hwif->selectproc = &ht6560b_selectproc;
+	hwif->pio_mask = ATA_PIO5;
 	hwif->tuneproc = &tune_ht6560b;
 	hwif->serialized = 1;	/* is this needed? */
 	hwif->mate = mate;
 
 	mate->chipset = ide_ht6560b;
 	mate->selectproc = &ht6560b_selectproc;
+	mate->pio_mask = ATA_PIO5;
 	mate->tuneproc = &tune_ht6560b;
 	mate->serialized = 1;	/* is this needed? */
 	mate->mate = hwif;
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 2f3977f..4cdb519 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -386,6 +386,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 7783745..8b87a42 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -252,38 +252,38 @@ static void qd6500_tune_drive (ide_drive_t *drive, u8 pio)
 
 static void qd6580_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	ide_pio_data_t d;
 	int base = HWIF(drive)->select_data;
+	unsigned int cycle_time;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
 
 	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
-		pio = ide_get_best_pio_mode(drive, pio, 4, &d);
+		pio = ide_get_best_pio_mode(drive, pio, 4);
+		cycle_time = ide_pio_cycle_time(drive, pio);
 
 		switch (pio) {
 			case 0: break;
 			case 3:
-				if (d.cycle_time >= 110) {
+				if (cycle_time >= 110) {
 					active_time = 86;
-					recovery_time = d.cycle_time - 102;
+					recovery_time = cycle_time - 102;
 				} else
 					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
 				break;
 			case 4:
-				if (d.cycle_time >= 69) {
+				if (cycle_time >= 69) {
 					active_time = 70;
-					recovery_time = d.cycle_time - 61;
+					recovery_time = cycle_time - 61;
 				} else
 					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
 				break;
 			default:
-				if (d.cycle_time >= 180) {
+				if (cycle_time >= 180) {
 					active_time = 110;
-					recovery_time = d.cycle_time - 120;
+					recovery_time = cycle_time - 120;
 				} else {
 					active_time = ide_pio_timings[pio].active_time;
-					recovery_time = d.cycle_time
-							-active_time;
+					recovery_time = cycle_time - active_time;
 				}
 		}
 		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,pio);
@@ -346,6 +346,7 @@ static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
 	hwif->drives[1].drive_data = data1;
 	hwif->drives[0].io_32bit =
 	hwif->drives[1].io_32bit = 1;
+	hwif->pio_mask = ATA_PIO4;
 	hwif->tuneproc = tuneproc;
 	probe_hwif_init(hwif);
 }
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index ddc403a..d2862e6 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -110,7 +110,7 @@ static void tune_umc (ide_drive_t *drive, u8 pio)
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = ide_hwifs[HWIF(drive)->index^1].hwgroup;
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
 	spin_lock_irqsave(&ide_lock, flags);
@@ -149,10 +149,12 @@ static int __init umc8672_probe(void)
 	mate = &ide_hwifs[1];
 
 	hwif->chipset = ide_umc8672;
+	hwif->pio_mask = ATA_PIO4;
 	hwif->tuneproc = &tune_umc;
 	hwif->mate = mate;
 
 	mate->chipset = ide_umc8672;
+	mate->pio_mask = ATA_PIO4;
 	mate->tuneproc = &tune_umc;
 	mate->mate = hwif;
 	mate->channel = 1;
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 2e7013a..2ba6a05 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -106,7 +106,7 @@ static void auide_tune_drive(ide_drive_t *drive, byte pio)
 	u8 speed;
 
 	/* get the best pio mode for the drive */
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 
 	printk(KERN_INFO "%s: setting Au1XXX IDE to PIO mode%d\n",
 	       drive->name, pio);
@@ -692,6 +692,8 @@ static int au_ide_probe(struct device *dev)
 	hwif->swdma_mask                = 0x0;
 #endif
 
+	hwif->pio_mask = ATA_PIO4;
+
 	hwif->noprobe = 0;
 	hwif->drives[0].unmask          = 1;
 	hwif->drives[1].unmask          = 1;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index e5d0936..7443283 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -142,7 +142,7 @@ static int aec6260_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) HWIF(drive)->speedproc(drive, pio + XFER_PIO_0);
 }
 
@@ -174,12 +174,6 @@ static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const ch
 {
 	int bus_speed = system_bus_clock();
 
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS, dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
 	else
@@ -271,48 +265,48 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "AEC6260",
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "AEC6260R",
 		.init_setup	= init_setup_aec62xx,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= NEVER_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "AEC6280",
 		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "AEC6280R",
 		.init_setup	= init_setup_aec6x80,
 		.init_chipset	= init_chipset_aec62xx,
 		.init_hwif	= init_hwif_aec62xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index ba0fb92..5511c86 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -295,7 +295,6 @@ static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
  
 static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
 {
-	ide_pio_data_t d;
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
 	int s_time, a_time, c_time;
@@ -307,7 +306,7 @@ static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
 	u8 cd_dma_fifo = 0;
 	int unit = drive->select.b.unit & 1;
 
-	pio = ide_get_best_pio_mode(drive, pio, 5, &d);
+	pio = ide_get_best_pio_mode(drive, pio, 5);
 	s_time = ide_pio_timings[pio].setup_time;
 	a_time = ide_pio_timings[pio].active_time;
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
@@ -817,9 +816,9 @@ static ide_pci_device_t ali15x3_chipset __devinitdata = {
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO5,
 };
 
 /**
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 8d30b99..06c15a6 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.20
+ * Version 2.21
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -272,10 +272,8 @@ static int amd_set_drive(ide_drive_t *drive, u8 speed)
 
 static void amd74xx_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	if (pio == 255) {
-		amd_set_drive(drive, ide_find_best_pio_mode(drive));
-		return;
-	}
+	if (pio == 255)
+		pio = ide_get_best_pio_mode(drive, 255, 5);
 
 	amd_set_drive(drive, XFER_PIO_0 + min_t(byte, pio, 5));
 }
@@ -284,12 +282,14 @@ static int amd74xx_ide_dma_check(ide_drive_t *drive)
 {
 	u8 speed = ide_max_dma_mode(drive);
 
-	if (speed == 0)
-		speed = ide_find_best_pio_mode(drive);
+	if (speed == 0) {
+		amd74xx_tune_drive(drive, 255);
+		return -1;
+	}
 
 	amd_set_drive(drive, speed);
 
-	if (drive->autodma && (speed & XFER_MODE) != XFER_PIO)
+	if (drive->autodma)
 		return 0;
 
 	return -1;
@@ -448,10 +448,12 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
-		.channels	= 2,					\
 		.autodma	= AUTODMA,				\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
 		.bootable	= ON_BOARD,				\
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
+				| IDE_HFLAG_PIO_NO_DOWNGRADE,		\
+		.pio_mask	= ATA_PIO5,				\
 	}
 
 #define DECLARE_NV_DEV(name_str)					\
@@ -459,10 +461,12 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
-		.channels	= 2,					\
 		.autodma	= AUTODMA,				\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
 		.bootable	= ON_BOARD,				\
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
+				| IDE_HFLAG_PIO_NO_DOWNGRADE,		\
+		.pio_mask	= ATA_PIO5,				\
 	}
 
 static ide_pci_device_t amd74xx_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 2761510..1725aa4 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -1,9 +1,8 @@
 /*
- *  linux/drivers/ide/pci/atiixp.c	Version 0.01-bart2	Feb. 26, 2004
+ *  linux/drivers/ide/pci/atiixp.c	Version 0.02	Jun 16 2007
  *
  *  Copyright (C) 2003 ATI Inc. <hyu@ati.com>
- *  Copyright (C) 2004 Bartlomiej Zolnierkiewicz
- *
+ *  Copyright (C) 2004,2007 Bartlomiej Zolnierkiewicz
  */
 
 #include <linux/types.h>
@@ -123,14 +122,14 @@ static void atiixp_dma_host_off(ide_drive_t *drive)
 }
 
 /**
- *	atiixp_tune_drive		-	tune a drive attached to a ATIIXP
+ *	atiixp_tune_pio	-	tune a drive attached to a ATIIXP
  *	@drive: drive to tune
  *	@pio: desired PIO mode
  *
  *	Set the interface PIO mode.
  */
 
-static void atiixp_tuneproc(ide_drive_t *drive, u8 pio)
+static void atiixp_tune_pio(ide_drive_t *drive, u8 pio)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
 	unsigned long flags;
@@ -154,6 +153,13 @@ static void atiixp_tuneproc(ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
+static void atiixp_tuneproc(ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	atiixp_tune_pio(drive, pio);
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
 /**
  *	atiixp_tune_chipset	-	tune a ATIIXP interface
  *	@drive: IDE drive to tune
@@ -175,6 +181,11 @@ static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
 
 	speed = ide_rate_filter(drive, xferspeed);
 
+	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
+		atiixp_tune_pio(drive, speed - XFER_PIO_0);
+		return ide_config_drive_speed(drive, speed);
+	}
+
 	spin_lock_irqsave(&atiixp_lock, flags);
 
 	save_mdma_mode[drive->dn] = 0;
@@ -201,7 +212,7 @@ static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
 	else
 		pio = speed - XFER_PIO_0;
 
-	atiixp_tuneproc(drive, pio);
+	atiixp_tune_pio(drive, pio);
 
 	return ide_config_drive_speed(drive, speed);
 }
@@ -216,18 +227,13 @@ static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
 
 static int atiixp_dma_check(ide_drive_t *drive)
 {
-	u8 tspeed, speed;
-
 	drive->init_speed = 0;
 
 	if (ide_tune_dma(drive))
 		return 0;
 
-	if (ide_use_fast_pio(drive)) {
-		tspeed = ide_get_best_pio_mode(drive, 255, 5, NULL);
-		speed = atiixp_dma_2_pio(XFER_PIO_0 + tspeed) + XFER_PIO_0;
-		atiixp_speedproc(drive, speed);
-	}
+	if (ide_use_fast_pio(drive))
+		atiixp_tuneproc(drive, 255);
 
 	return -1;
 }
@@ -285,17 +291,18 @@ static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
 		.name		= "ATIIXP",
 		.init_hwif	= init_hwif_atiixp,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 1 */
 		.name		= "SB600_PATA",
 		.init_hwif	= init_hwif_atiixp,
-		.channels	= 1,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
  		.bootable	= ON_BOARD,
+ 		.host_flags	= IDE_HFLAG_SINGLE,
+		.pio_mask	= ATA_PIO4,
  	},
 };
 
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index dc43f00..9689494 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -633,9 +633,8 @@ static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle
  */
 static void cmd640_tune_drive (ide_drive_t *drive, u8 mode_wanted)
 {
+	unsigned int index = 0, cycle_time;
 	u8 b;
-	ide_pio_data_t  d;
-	unsigned int index = 0;
 
 	while (drive != cmd_drives[index]) {
 		if (++index > 3) {
@@ -662,16 +661,14 @@ static void cmd640_tune_drive (ide_drive_t *drive, u8 mode_wanted)
 			return;
 	}
 
-	(void) ide_get_best_pio_mode (drive, mode_wanted, 5, &d);
-	cmd640_set_mode (index, d.pio_mode, d.cycle_time);
+	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 5);
+	cycle_time = ide_pio_cycle_time(drive, mode_wanted);
+	cmd640_set_mode(index, mode_wanted, cycle_time);
+
+	printk("%s: selected cmd640 PIO mode%d (%dns)",
+		drive->name, mode_wanted, cycle_time);
 
-	printk ("%s: selected cmd640 PIO mode%d (%dns)%s",
-		drive->name,
-		d.pio_mode,
-		d.cycle_time,
-		d.overridden ? " (overriding vendor mode)" : "");
 	display_clocks(index);
-	return;
 }
 
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
@@ -769,6 +766,7 @@ int __init ide_probe_for_cmd640x (void)
 	       cmd_hwif0->name, 'a' + cmd640_chip_version - 1, bus_type, cfr);
 	cmd_hwif0->chipset = ide_cmd640;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	cmd_hwif0->pio_mask = ATA_PIO5;
 	cmd_hwif0->tuneproc = &cmd640_tune_drive;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
@@ -824,6 +822,7 @@ int __init ide_probe_for_cmd640x (void)
 		cmd_hwif1->mate = cmd_hwif0;
 		cmd_hwif1->channel = 1;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+		cmd_hwif1->pio_mask = ATA_PIO5;
 		cmd_hwif1->tuneproc = &cmd640_tune_drive;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 	}
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 1e89dd6..19633c5 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -221,17 +221,18 @@ static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	ide_pio_data_t pio;
+	unsigned int cycle_time;
 	u8 pio_mode, setup_count, arttim = 0;
 	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
 	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
-	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5, &pio);
 
-	cmdprintk("%s: PIO mode wanted %d, selected %d (%d ns)%s\n",
-		  drive->name, mode_wanted, pio_mode, pio.cycle_time,
-		  pio.overridden ? " (overriding vendor mode)" : "");
+	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5);
+	cycle_time = ide_pio_cycle_time(drive, pio_mode);
 
-	program_cycle_times(drive, pio.cycle_time,
+	cmdprintk("%s: PIO mode wanted %d, selected %d (%d ns)\n",
+		  drive->name, mode_wanted, pio_mode, cycle_time);
+
+	program_cycle_times(drive, cycle_time,
 			    ide_pio_timings[pio_mode].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio_mode].setup_time,
@@ -618,40 +619,40 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x00, /* no udma */
 	},{	/* 1 */
 		.name		= "CMD646",
 		.init_setup	= init_setup_cmd646,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 2 */
 		.name		= "CMD648",
 		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "CMD649",
 		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 3b88a3a..bccedf9 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -126,7 +126,7 @@ static int cs5520_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	
 static void cs5520_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	cs5520_tune_chipset(drive, (XFER_PIO_0 + pio));
 }
 
@@ -194,10 +194,10 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 		.name		= name_str,			\
 		.init_setup_dma = cs5520_init_setup_dma,	\
 		.init_hwif	= init_hwif_cs5520,		\
-		.channels	= 2,				\
 		.autodma	= AUTODMA,			\
 		.bootable	= ON_BOARD,			\
-		.flags		= IDEPCI_FLAG_ISA_PORTS,	\
+		.host_flags	= IDE_HFLAG_ISA_PORTS,		\
+		.pio_mask	= ATA_PIO4,			\
 	}
 
 static ide_pci_device_t cyrix_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index b5c00d1..acaf71f 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -82,7 +82,7 @@ static void cs5530_tunepio(ide_drive_t *drive, u8 pio)
 
 static void cs5530_tuneproc (ide_drive_t *drive, u8 pio)	/* pio=255 means "autotune" */
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 
 	if (cs5530_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
 		cs5530_tunepio(drive, pio);
@@ -341,9 +341,9 @@ static ide_pci_device_t cs5530_chipset __devinitdata = {
 	.name		= "CS5530",
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 10f61f3..ce44e38 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -89,7 +89,7 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
 
 		pioa = speed - XFER_PIO_0;
 		piob = ide_get_best_pio_mode(&(drive->hwif->drives[!unit]),
-						255, 4, NULL);
+						255, 4);
 		cmd = pioa < piob ? pioa : piob;
 
 		/* Write the speed of the current drive */
@@ -159,7 +159,7 @@ static void cs5535_tuneproc(ide_drive_t *drive, u8 xferspeed)
 	/* cs5535 max pio is pio 4, best_pio will check the blacklist.
 	i think we don't need to rate_filter the incoming xferspeed
 	since we know we're only going to choose pio */
-	xferspeed = ide_get_best_pio_mode(drive, xferspeed, 4, NULL);
+	xferspeed = ide_get_best_pio_mode(drive, xferspeed, 4);
 	ide_config_drive_speed(drive, modes[xferspeed]);
 	cs5535_set_speed(drive, xferspeed);
 }
@@ -174,7 +174,7 @@ static int cs5535_dma_check(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive)) {
-		speed = ide_get_best_pio_mode(drive, 255, 4, NULL);
+		speed = ide_get_best_pio_mode(drive, 255, 4);
 		cs5535_set_drive(drive, speed);
 	}
 
@@ -228,9 +228,10 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 static ide_pci_device_t cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
-	.channels	= 1,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit cs5535_init_one(struct pci_dev *dev,
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 103b9db..daa36fc 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -330,7 +330,7 @@ static void cy82c693_tune_drive (ide_drive_t *drive, u8 pio)
 #endif /* CY82C693_DEBUG_LOGS */
 
 	/* first let's calc the pio modes */
-	pio = ide_get_best_pio_mode(drive, pio, CY82C693_MAX_PIO, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, CY82C693_MAX_PIO);
 
 #if CY82C693_DEBUG_INFO
 	printk (KERN_INFO "%s: Selected PIO mode %d\n", drive->name, pio);
@@ -483,9 +483,10 @@ static ide_pci_device_t cy82c693_chipset __devinitdata = {
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
-	.channels	= 1,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 0d51a11..48caa46 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -95,92 +95,77 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "Unknown",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 1 */
 		.name		= "NS87410",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
 		.bootable	= ON_BOARD,
         },{	/* 2 */
 		.name		= "SAMURAI",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 3 */
 		.name		= "HT6565",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 4 */
 		.name		= "UM8673F",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 5 */
 		.name		= "UM8886A",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 6 */
 		.name		= "UM8886BF",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 7 */
 		.name		= "HINT_IDE",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 8 */
 		.name		= "VIA_IDE",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 9 */
 		.name		= "OPTI621V",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 10 */
 		.name		= "VIA8237SATA",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 	},{	/* 11 */
 		.name 		= "Piccolo0102",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 12 */
 		.name 		= "Piccolo0103",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 13 */
 		.name 		= "Piccolo0105",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= ON_BOARD,
 	},{	/* 14 */
 		.name		= "Revolution",
 		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 	}
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 2c24c3d..19778c5 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -80,7 +80,7 @@ static int hpt34x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 static void hpt34x_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 5, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 5);
 	(void) hpt34x_tune_chipset(drive, (XFER_PIO_0 + pio));
 }
 
@@ -120,17 +120,10 @@ static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev, const cha
 	pci_write_config_byte(dev, HPT34X_PCI_INIT_REG, 0x00);
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 
-	if (cmd & PCI_COMMAND_MEMORY) {
-		if (pci_resource_start(dev, PCI_ROM_RESOURCE)) {
-			pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-				dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-			printk(KERN_INFO "HPT345: ROM enabled at 0x%08lx\n",
-				(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-		}
+	if (cmd & PCI_COMMAND_MEMORY)
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xF0);
-	} else {
+	else
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
-	}
 
 	/*
 	 * Since 20-23 can be assigned and are R/W, we correct them.
@@ -182,10 +175,10 @@ static ide_pci_device_t hpt34x_chipset __devinitdata = {
 	.name		= "HPT34X",
 	.init_chipset	= init_chipset_hpt34x,
 	.init_hwif	= init_hwif_hpt34x,
-	.channels	= 2,
 	.autodma	= NOAUTODMA,
 	.bootable	= NEVER_BOARD,
-	.extra		= 16
+	.extra		= 16,
+	.pio_mask	= ATA_PIO5,
 };
 
 static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index e9b07a9..2cd74c3 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -652,7 +652,7 @@ static int hpt3xx_tune_chipset(ide_drive_t *drive, u8 speed)
 
 static void hpt3xx_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) hpt3xx_tune_chipset (drive, XFER_PIO_0 + pio);
 }
 
@@ -994,14 +994,6 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	 */
 	*info = *(struct hpt_info *)pci_get_drvdata(dev);
 
-	/*
-	 * FIXME: Not portable. Also, why do we enable the ROM in the first place?
-	 * We don't seem to be using it.
-	 */
-	if (dev->resource[PCI_ROM_RESOURCE].start)
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x78);
 	pci_write_config_byte(dev, PCI_MIN_GNT, 0x08);
@@ -1491,7 +1483,7 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 		 * to both functions -- really stupid design decision... :-(
 		 * Bit 4 is for the primary channel, bit 5 for the secondary.
 		 */
-		d->channels = 1;
+		d->host_flags |= IDE_HFLAG_SINGLE;
 		d->enablebits[0].mask = d->enablebits[0].val = 0x10;
 
 		d->udma_mask = HPT366_ALLOW_ATA66_3 ?
@@ -1554,71 +1546,71 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 1 */
 		.name		= "HPT372A",
 		.init_setup	= init_setup_hpt372a,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 2 */
 		.name		= "HPT302",
 		.init_setup	= init_setup_hpt302,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= HPT302_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 3 */
 		.name		= "HPT371",
 		.init_setup	= init_setup_hpt371,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= HPT371_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 4 */
 		.name		= "HPT374",
 		.init_setup	= init_setup_hpt374,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,	/* 4 */
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= 0x3f,
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 5 */
 		.name		= "HPT372N",
 		.init_setup	= init_setup_hpt372n,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
-		.channels	= 2,	/* 4 */
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
 		.bootable	= OFF_BOARD,
-		.extra		= 240
+		.extra		= 240,
+		.pio_mask	= ATA_PIO4,
 	}
 };
 
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index ff48c23..95dbed7 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -82,7 +82,7 @@ static void it8213_tuneproc (ide_drive_t *drive, u8 pio)
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 
 	spin_lock_irqsave(&tune_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
@@ -214,7 +214,7 @@ static int it8213_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	pio = ide_get_best_pio_mode(drive, 255, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, 255, 4);
 	it8213_tune_chipset(drive, XFER_PIO_0 + pio);
 
 	return -1;
@@ -272,10 +272,11 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	{						\
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_it8213,	\
-		.channels	= 1,			\
 		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}}, \
 		.bootable	= ON_BOARD,		\
+		.host_flags	= IDE_HFLAG_SINGLE,	\
+		.pio_mask	= ATA_PIO4,		\
 	}
 
 static ide_pci_device_t it8213_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 8197b65..9286c99 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -255,7 +255,7 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 	 * on the cable.
 	 */
 	if (pair) {
-		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4, NULL);
+		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
 		/* trim PIO to the slowest of the master/slave */
 		if (pair_pio < set_pio)
 			set_pio = pair_pio;
@@ -276,7 +276,7 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 
 static void it821x_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void)it821x_tunepio(drive, pio);
 }
 
@@ -718,10 +718,10 @@ static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const cha
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_it821x,	\
 		.init_hwif	= init_hwif_it821x,	\
-		.channels	= 2,			\
 		.autodma	= AUTODMA,		\
 		.bootable	= ON_BOARD,		\
-		.fixup	 	= it821x_fixups		\
+		.fixup	 	= it821x_fixups,	\
+		.pio_mask	= ATA_PIO4,		\
 	}
 
 static ide_pci_device_t it821x_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index a6008f6..d7ce9dd 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -97,7 +97,7 @@ static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
 
 static void config_jmicron_chipset_for_pio (ide_drive_t *drive, byte set_speed)
 {
-	u8 speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5, NULL);
+	u8 speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5);
 	if (set_speed)
 		(void) ide_config_drive_speed(drive, speed);
 }
@@ -177,10 +177,10 @@ fallback:
 	{						\
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_jmicron,	\
-		.channels	= 2,			\
 		.autodma	= AUTODMA,		\
 		.bootable	= ON_BOARD,		\
 		.enablebits	= { {0x40, 1, 1}, {0x40, 0x10, 0x10} }, \
+		.pio_mask	= ATA_PIO5,		\
 	}
 
 static ide_pci_device_t jmicron_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index b310c4f..09941f3 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -281,7 +281,6 @@ static ide_pci_device_t ns87415_chipset __devinitdata = {
 	.init_iops	= init_iops_ns87415,
 #endif
 	.init_hwif	= init_hwif_ns87415,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
 };
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index aede7ee..3a2bb27 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -147,12 +147,12 @@ static void compute_pios(ide_drive_t *drive, u8 pio)
 	int d;
 	ide_hwif_t *hwif = HWIF(drive);
 
-	drive->drive_data = ide_get_best_pio_mode(drive, pio, OPTI621_MAX_PIO, NULL);
+	drive->drive_data = ide_get_best_pio_mode(drive, pio, OPTI621_MAX_PIO);
 	for (d = 0; d < 2; ++d) {
 		drive = &hwif->drives[d];
 		if (drive->present) {
 			if (drive->drive_data == PIO_DONT_KNOW)
-				drive->drive_data = ide_get_best_pio_mode(drive, 255, OPTI621_MAX_PIO, NULL);
+				drive->drive_data = ide_get_best_pio_mode(drive, 255, OPTI621_MAX_PIO);
 #ifdef OPTI621_DEBUG
 			printk("%s: Selected PIO mode %d\n",
 				drive->name, drive->drive_data);
@@ -350,17 +350,17 @@ static ide_pci_device_t opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO3,
 	},{	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO3,
 	}
 };
 
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index ee5020d..8a66a28 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -219,7 +219,7 @@ static int pdcnew_tune_chipset(ide_drive_t *drive, u8 speed)
 
 static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void)pdcnew_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -378,13 +378,6 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 	int f, r;
 	u8 pll_ctl0, pll_ctl1;
 
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 #ifdef CONFIG_PPC_PMAC
 	apple_kiwi_init(dev);
 #endif
@@ -573,63 +566,63 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_pdcnew,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 1 */
 		.name		= "PDC20269",
 		.init_setup	= init_setup_pdcnew,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 2 */
 		.name		= "PDC20270",
 		.init_setup	= init_setup_pdc20270,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 3 */
 		.name		= "PDC20271",
 		.init_setup	= init_setup_pdcnew,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 4 */
 		.name		= "PDC20275",
 		.init_setup	= init_setup_pdcnew,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 5 */
 		.name		= "PDC20276",
 		.init_setup	= init_setup_pdc20276,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 6 */
 		.name		= "PDC20277",
 		.init_setup	= init_setup_pdcnew,
 		.init_chipset	= init_chipset_pdcnew,
 		.init_hwif	= init_hwif_pdc202new,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
 	}
 };
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 41ac4a9..fbcb0bb 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -145,7 +145,7 @@ static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 static void pdc202xx_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	pdc202xx_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -316,14 +316,6 @@ static void pdc202xx_reset (ide_drive_t *drive)
 static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
 							const char *name)
 {
-	/* This doesn't appear needed */
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 	return dev->irq;
 }
 
@@ -449,10 +441,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 16,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "PDC20262",
@@ -460,10 +452,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "PDC20263",
@@ -471,10 +463,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "PDC20265",
@@ -482,10 +474,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "PDC20267",
@@ -493,10 +485,10 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
 		.init_dma	= init_dma_pdc202xx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 1372c35..4f69cd0 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -219,7 +219,7 @@ static void piix_tune_pio (ide_drive_t *drive, u8 pio)
  */
 static void piix_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	piix_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -495,10 +495,10 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_piix,	\
 		.init_hwif	= init_hwif_piix,	\
-		.channels	= 2,			\
 		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.bootable	= ON_BOARD,		\
+		.pio_mask	= ATA_PIO4,		\
 		.udma_mask	= udma,			\
 	}
 
@@ -514,11 +514,11 @@ static ide_pci_device_t piix_pci_info[] __devinitdata = {
 		 */
 		.name		= "MPIIX",
 		.init_hwif	= init_hwif_piix,
-		.channels	= 2,
 		.autodma	= NODMA,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
 		.bootable	= ON_BOARD,
-		.flags		= IDEPCI_FLAG_ISA_PORTS
+		.host_flags	= IDE_HFLAG_ISA_PORTS,
+		.pio_mask	= ATA_PIO4,
 	},
 
 	/*  3 */ DECLARE_PIIX_DEV("PIIX3", 0x00),	/* no udma */
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index f8c9546..10e1ae7 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -52,7 +52,6 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 static ide_pci_device_t rz1000_chipset __devinitdata = {
 	.name		= "RZ100x",
 	.init_hwif	= init_hwif_rz1000,
-	.channels	= 2,
 	.autodma	= NODMA,
 	.bootable	= ON_BOARD,
 };
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 523363c..9bdc969 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sc1200.c		Version 0.94	Mar 10 2007
+ * linux/drivers/ide/pci/sc1200.c		Version 0.95	Jun 16 2007
  *
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
  * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
@@ -304,7 +304,7 @@ static void sc1200_tuneproc (ide_drive_t *drive, byte pio)	/* mode=255 means "au
 		return;
 	}
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	printk("SC1200: %s: setting PIO mode%d\n", drive->name, pio);
 
 	if (sc1200_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
@@ -390,7 +390,7 @@ static int sc1200_resume (struct pci_dev *dev)
 	// loop over all interfaces that are part of this pci device:
 	//
 	while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
-		unsigned int		basereg, r, d, format;
+		unsigned int		basereg, r;
 		sc1200_saved_state_t	*ss = (sc1200_saved_state_t *)hwif->config_data;
 
 		//
@@ -402,41 +402,6 @@ static int sc1200_resume (struct pci_dev *dev)
 				pci_write_config_dword(hwif->pci_dev, basereg + (r<<2), ss->regs[r]);
 			}
 		}
-		//
-		// Re-program drive PIO modes
-		//
-		pci_read_config_dword(hwif->pci_dev, basereg+4, &format);
-		format = (format >> 31) & 1;
-		if (format)
-			format += sc1200_get_pci_clock();
-		for (d = 0; d < 2; ++d) {
-			ide_drive_t *drive = &(hwif->drives[d]);
-			if (drive->present) {
-				unsigned int pio, timings;
-				pci_read_config_dword(hwif->pci_dev, basereg+(drive->select.b.unit << 3), &timings);
-				for (pio = 0; pio <= 4; ++pio) {
-					if (sc1200_pio_timings[format][pio] == timings)
-						break;
-				}
-				if (pio > 4)
-					pio = 255; /* autotune */
-				(void)sc1200_tuneproc(drive, pio);
-			}
-		}
-		//
-		// Re-program drive DMA modes
-		//
-		for (d = 0; d < MAX_DRIVES; ++d) {
-			ide_drive_t *drive = &(hwif->drives[d]);
-			if (drive->present && !__ide_dma_bad_drive(drive)) {
-				int enable_dma = drive->using_dma;
-				hwif->dma_off_quietly(drive);
-				if (sc1200_config_dma(drive))
-					enable_dma = 0;
-				if (enable_dma)
-					hwif->dma_host_on(drive);
-			}
-		}
 	}
 	return 0;
 }
@@ -471,9 +436,9 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 static ide_pci_device_t sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
 	.init_hwif	= init_hwif_sc1200,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 7b87488..f668d23 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -165,9 +165,9 @@ scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
 	ide_hwif_t *hwif = HWIF(drive);
 
 	out_be32((void*)port, addr);
-	__asm__ __volatile__("eieio":::"memory");
+	eieio();
 	in_be32((void*)(hwif->dma_base + 0x01c));
-	__asm__ __volatile__("eieio":::"memory");
+	eieio();
 }
 
 static void
@@ -210,7 +210,7 @@ static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
 	unsigned char speed = XFER_PIO_0;
 	int offset;
 
-	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 4, NULL);
+	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 4);
 	switch (mode_wanted) {
 	case 4:
 		speed = XFER_PIO_4;
@@ -401,6 +401,33 @@ static int scc_ide_dma_end(ide_drive_t * drive)
 	ide_hwif_t *hwif = HWIF(drive);
 	unsigned long intsts_port = hwif->dma_base + 0x014;
 	u32 reg;
+	int dma_stat, data_loss = 0;
+	static int retry = 0;
+
+	/* errata A308 workaround: Step5 (check data loss) */
+	/* We don't check non ide_disk because it is limited to UDMA4 */
+	if (!(in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
+		reg = in_be32((void __iomem *)intsts_port);
+		if (!(reg & INTSTS_ACTEINT)) {
+			printk(KERN_WARNING "%s: operation failed (transfer data loss)\n",
+			       drive->name);
+			data_loss = 1;
+			if (retry++) {
+				struct request *rq = HWGROUP(drive)->rq;
+				int unit;
+				/* ERROR_RESET and drive->crc_count are needed
+				 * to reduce DMA transfer mode in retry process.
+				 */
+				if (rq)
+					rq->errors |= ERROR_RESET;
+				for (unit = 0; unit < MAX_DRIVES; unit++) {
+					ide_drive_t *drive = &hwif->drives[unit];
+					drive->crc_count++;
+				}
+			}
+		}
+	}
 
 	while (1) {
 		reg = in_be32((void __iomem *)intsts_port);
@@ -469,27 +496,25 @@ static int scc_ide_dma_end(ide_drive_t * drive)
 		break;
 	}
 
-	return __ide_dma_end(drive);
+	dma_stat = __ide_dma_end(drive);
+	if (data_loss)
+		dma_stat |= 2; /* emulate DMA error (to retry command) */
+	return dma_stat;
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
 static int scc_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	ide_hwif_t *hwif = HWIF(drive);
+	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
-	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
+	/* SCC errata A252,A308 workaround: Step4 */
+	if ((in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	    (int_stat & INTSTS_INTRQ))
 		return 1;
 
-	/* Workaround for PTERADD: emulate DMA_INTR when
-	 * - IDE_STATUS[ERR] = 1
-	 * - INT_STATUS[INTRQ] = 1
-	 * - DMA_STATUS[IORACTA] = 1
-	 */
-	if (in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT &&
-	    in_be32((void __iomem *)(hwif->dma_base + 0x014)) & INTSTS_INTRQ &&
-		dma_stat & 1)
+	/* SCC errata A308 workaround: Step5 (polling IOIRQS) */
+	if (int_stat & INTSTS_IOIRQS)
 		return 1;
 
 	if (!drive->waiting_for_dma)
@@ -498,6 +523,21 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 	return 0;
 }
 
+static u8 scc_udma_filter(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mask = hwif->ultra_mask;
+
+	/* errata A308 workaround: limit non ide_disk drive to UDMA4 */
+	if ((drive->media != ide_disk) && (mask & 0xE0)) {
+		printk(KERN_INFO "%s: limit %s to UDMA4\n",
+		       SCC_PATA_NAME, drive->name);
+		mask = 0x1F;
+	}
+
+	return mask;
+}
+
 /**
  *	setup_mmio_scc	-	map CTRL/BMID region
  *	@dev: PCI device we are configuring
@@ -702,6 +742,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->tuneproc = scc_tuneproc;
 	hwif->ide_dma_check = scc_config_drive_for_dma;
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
+	hwif->udma_filter = scc_udma_filter;
 
 	hwif->drives[0].autotune = IDE_TUNE_AUTO;
 	hwif->drives[1].autotune = IDE_TUNE_AUTO;
@@ -731,9 +772,10 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
       .init_setup	= init_setup_scc,		\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
-      .channels	= 1,					\
       .autodma	= AUTODMA,				\
       .bootable	= ON_BOARD,				\
+      .host_flags	= IDE_HFLAG_SINGLE,		\
+      .pio_mask		= ATA_PIO4,			\
   }
 
 static ide_pci_device_t scc_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index ed04e0c..9fead2e 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.20	Jun 3 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.22	Jun 27 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -123,23 +123,45 @@ static u8 svwks_csb_check (struct pci_dev *dev)
 	}
 	return 0;
 }
+
+static void svwks_tune_pio(ide_drive_t *drive, const u8 pio)
+{
+	static const u8 pio_modes[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
+	static const u8 drive_pci[] = { 0x41, 0x40, 0x43, 0x42 };
+
+	struct pci_dev *dev = drive->hwif->pci_dev;
+
+	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
+
+	if (svwks_csb_check(dev)) {
+		u16 csb_pio = 0;
+
+		pci_read_config_word(dev, 0x4a, &csb_pio);
+
+		csb_pio &= ~(0x0f << (4 * drive->dn));
+		csb_pio |= (pio << (4 * drive->dn));
+
+		pci_write_config_word(dev, 0x4a, csb_pio);
+	}
+}
+
 static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	static const u8 udma_modes[]		= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
-	static const u8 pio_modes[]		= { 0x5d, 0x47, 0x34, 0x22, 0x20 };
-	static const u8 drive_pci[]		= { 0x41, 0x40, 0x43, 0x42 };
 	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 speed		= ide_rate_filter(drive, xferspeed);
-	u8 pio			= ide_get_best_pio_mode(drive, 255, 4, NULL);
 	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 csb5			= svwks_csb_check(dev);
-	u8 ultra_enable		= 0, ultra_timing = 0;
-	u8 dma_timing		= 0, pio_timing = 0;
-	u16 csb5_pio		= 0;
+
+	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
+
+	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
+		svwks_tune_pio(drive, speed - XFER_PIO_0);
+		return ide_config_drive_speed(drive, speed);
+	}
 
 	/* If we are about to put a disk into UDMA mode we screwed up.
 	   Our code assumes we never _ever_ do this on an OSB4 */
@@ -149,31 +171,15 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			BUG();
 
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
-	pci_read_config_word(dev, 0x4A, &csb5_pio);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
-	csb5_pio	&= ~(0x0F << (4*drive->dn));
 
 	switch(speed) {
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			pio_timing |= pio_modes[speed - XFER_PIO_0];
-			csb5_pio   |= ((speed - XFER_PIO_0) << (4*drive->dn));
-			break;
-
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_MW_DMA_0:
-			/*
-			 * TODO: always setup PIO mode so this won't be needed
-			 */
-			pio_timing |= pio_modes[pio];
-			csb5_pio   |= (pio << (4*drive->dn));
 			dma_timing |= dma_modes[speed - XFER_MW_DMA_0];
 			break;
 
@@ -183,11 +189,6 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_UDMA_2:
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
-			/*
-			 * TODO: always setup PIO mode so this won't be needed
-			 */
-			pio_timing   |= pio_modes[pio];
-			csb5_pio     |= (pio << (4*drive->dn));
 			dma_timing   |= dma_modes[2];
 			ultra_timing |= ((udma_modes[speed - XFER_UDMA_0]) << (4*unit));
 			ultra_enable |= (0x01 << drive->dn);
@@ -195,10 +196,6 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			break;
 	}
 
-	pci_write_config_byte(dev, drive_pci[drive->dn], pio_timing);
-	if (csb5)
-		pci_write_config_word(dev, 0x4A, csb5_pio);
-
 	pci_write_config_byte(dev, drive_pci2[drive->dn], dma_timing);
 	pci_write_config_byte(dev, (0x56|hwif->channel), ultra_timing);
 	pci_write_config_byte(dev, 0x54, ultra_enable);
@@ -208,8 +205,9 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 static void svwks_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
-	(void)svwks_tune_chipset(drive, XFER_PIO_0 + pio);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	svwks_tune_pio(drive, pio);
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 static int svwks_config_drive_xfer_rate (ide_drive_t *drive)
@@ -389,8 +387,6 @@ static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 {
-	u8 dma_stat = 0;
-
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
@@ -407,11 +403,11 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = 1;
+	hwif->drives[1].autotune = 1;
+
+	if (!hwif->dma_base)
 		return;
-	}
 
 	hwif->ide_dma_check = &svwks_config_drive_xfer_rate;
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
@@ -421,11 +417,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	if (!noautodma)
 		hwif->autodma = 1;
 
-	dma_stat = inb(hwif->dma_status);
-	hwif->drives[0].autodma = (dma_stat & 0x20);
-	hwif->drives[1].autodma = (dma_stat & 0x40);
-	hwif->drives[0].autotune = (!(dma_stat & 0x20));
-	hwif->drives[1].autotune = (!(dma_stat & 0x40));
+	hwif->drives[0].autodma = hwif->drives[1].autodma = 1;
 }
 
 static int __devinit init_setup_svwks (struct pci_dev *dev, ide_pci_device_t *d)
@@ -441,9 +433,12 @@ static int __devinit init_setup_csb6 (struct pci_dev *dev, ide_pci_device_t *d)
 			d->bootable = ON_BOARD;
 	}
 
-	d->channels = ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE ||
-			dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2) &&
-		       (!(PCI_FUNC(dev->devfn) & 1))) ? 1 : 2;
+	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE ||
+	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2) &&
+	    (!(PCI_FUNC(dev->devfn) & 1)))
+		d->host_flags |= IDE_HFLAG_SINGLE;
+	else
+		d->host_flags &= ~IDE_HFLAG_SINGLE;
 
 	return ide_setup_pci_device(dev, d);
 }
@@ -454,41 +449,43 @@ static ide_pci_device_t serverworks_chipsets[] __devinitdata = {
 		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 1 */
 		.name		= "SvrWks CSB5",
 		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 2 */
 		.name		= "SvrWks CSB6",
 		.init_setup	= init_setup_csb6,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 3 */
 		.name		= "SvrWks CSB6",
 		.init_setup	= init_setup_csb6,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.channels	= 1,	/* 2 */
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_SINGLE,
+		.pio_mask	= ATA_PIO4,
 	},{	/* 4 */
 		.name		= "SvrWks HT1000",
 		.init_setup	= init_setup_svwks,
 		.init_chipset	= init_chipset_svwks,
 		.init_hwif	= init_hwif_svwks,
-		.channels	= 1,	/* 2 */
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_SINGLE,
+		.pio_mask	= ATA_PIO4,
 	}
 };
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index d396b29..5714576 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -586,6 +586,7 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->ultra_mask = 0x0;	/* Disable Ultra DMA */
 	hwif->mwdma_mask = 0x2;	/* Multimode-2 DMA  */
 	hwif->swdma_mask = 0x2;
+	hwif->pio_mask = 0x00;
 	hwif->tuneproc = NULL;	/* Sets timing for PIO mode */
 	hwif->speedproc = NULL;	/* Sets timing for DMA &/or PIO modes */
 	hwif->selectproc = NULL;/* Use the default routine to select drive */
@@ -724,10 +725,10 @@ static ide_pci_device_t sgiioc4_chipset __devinitdata = {
 	 .name = "SGIIOC4",
 	 .init_hwif = ide_init_sgiioc4,
 	 .init_dma = ide_dma_sgiioc4,
-	 .channels = 1,
 	 .autodma = AUTODMA,
 	 /* SGI IOC4 doesn't have enablebits. */
 	 .bootable = ON_BOARD,
+	 .host_flags = IDE_HFLAG_SINGLE,
 };
 
 int
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 1c3e354..50f6d17 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,9 +1,10 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.12	Mar 10 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.15	Jun 29 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		MontaVista Software, Inc.
+ * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
@@ -31,6 +32,10 @@
  *  unplugging/replugging the virtual CD interface when the DRAC is reset.
  *  This often causes drivers/ide/siimage to panic but is ok with the rather
  *  smarter code in libata.
+ *
+ * TODO:
+ * - IORDY fixes
+ * - VDMA support
  */
 
 #include <linux/types.h>
@@ -160,82 +165,45 @@ out:
 }
 
 /**
- *	siimage_taskfile_timing	-	turn timing data to a mode
- *	@hwif: interface to query
- *
- *	Read the timing data for the interface and return the 
- *	mode that is being used.
- */
- 
-static byte siimage_taskfile_timing (ide_hwif_t *hwif)
-{
-	u16 timing	= 0x328a;
-	unsigned long addr = siimage_selreg(hwif, 2);
-
-	if (hwif->mmio)
-		timing = hwif->INW(addr);
-	else
-		pci_read_config_word(hwif->pci_dev, addr, &timing);
-
-	switch (timing) {
-		case 0x10c1:	return 4;
-		case 0x10c3:	return 3;
-		case 0x1104:
-		case 0x1281:	return 2;
-		case 0x2283:	return 1;
-		case 0x328a:
-		default:	return 0;
-	}
-}
-
-/**
- *	simmage_tuneproc	-	tune a drive
+ *	sil_tune_pio	-	tune a drive
  *	@drive: drive to tune
- *	@mode_wanted: the target operating mode
+ *	@pio: the desired PIO mode
  *
  *	Load the timing settings for this device mode into the
  *	controller. If we are in PIO mode 3 or 4 turn on IORDY
  *	monitoring (bit 9). The TF timing is bits 31:16
  */
- 
-static void siimage_tuneproc (ide_drive_t *drive, byte mode_wanted)
+
+static void sil_tune_pio(ide_drive_t *drive, u8 pio)
 {
+	const u16 tf_speed[]	= { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
+	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
+
 	ide_hwif_t *hwif	= HWIF(drive);
+	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
 	unsigned long tfaddr	= siimage_selreg(hwif, 0x02);
-	
-	/* cheat for now and use the docs */
-	switch (mode_wanted) {
-	case 4:
-		speedp = 0x10c1;
-		speedt = 0x10c1;
-		break;
-	case 3:
-		speedp = 0x10c3;
-		speedt = 0x10c3;
-		break;
-	case 2:
-		speedp = 0x1104;
-		speedt = 0x1281;
-		break;
-	case 1:
-		speedp = 0x2283;
-		speedt = 0x2283;
-		break;
-	case 0:
-	default:
-		speedp = 0x328a;
-		speedt = 0x328a;
-		break;
+	u8 tf_pio		= pio;
+
+	/* trim *taskfile* PIO to the slowest of the master/slave */
+	if (pair->present) {
+		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
+
+		if (pair_pio < tf_pio)
+			tf_pio = pair_pio;
 	}
 
+	/* cheat for now and use the docs */
+	speedp = data_speed[pio];
+	speedt = tf_speed[tf_pio];
+
 	if (hwif->mmio) {
 		hwif->OUTW(speedp, addr);
 		hwif->OUTW(speedt, tfaddr);
 		/* Now set up IORDY */
-		if(mode_wanted == 3 || mode_wanted == 4)
+		if (pio > 2)
 			hwif->OUTW(hwif->INW(tfaddr-2)|0x200, tfaddr-2);
 		else
 			hwif->OUTW(hwif->INW(tfaddr-2)&~0x200, tfaddr-2);
@@ -245,42 +213,17 @@ static void siimage_tuneproc (ide_drive_t *drive, byte mode_wanted)
 		pci_read_config_word(hwif->pci_dev, tfaddr-2, &speedp);
 		speedp &= ~0x200;
 		/* Set IORDY for mode 3 or 4 */
-		if(mode_wanted == 3 || mode_wanted == 4)
+		if (pio > 2)
 			speedp |= 0x200;
 		pci_write_config_word(hwif->pci_dev, tfaddr-2, speedp);
 	}
 }
 
-/**
- *	config_siimage_chipset_for_pio	-	set drive timings
- *	@drive: drive to tune
- *	@speed we want
- *
- *	Compute the best pio mode we can for a given device. Also honour
- *	the timings for the driver when dealing with mixed devices. Some
- *	of this is ugly but its all wrapped up here
- *
- *	The SI680 can also do VDMA - we need to start using that
- *
- *	FIXME: we use the BIOS channel timings to avoid driving the task
- *	files too fast at the disk. We need to compute the master/slave
- *	drive PIO mode properly so that we can up the speed on a hotplug
- *	system.
- */
- 
-static void config_siimage_chipset_for_pio (ide_drive_t *drive, byte set_speed)
+static void sil_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	u8 channel_timings	= siimage_taskfile_timing(HWIF(drive));
-	u8 speed = 0, set_pio	= ide_get_best_pio_mode(drive, 4, 5, NULL);
-
-	/* WARNING PIO timing mess is going to happen b/w devices, argh */
-	if ((channel_timings != set_pio) && (set_pio > channel_timings))
-		set_pio = channel_timings;
-
-	siimage_tuneproc(drive, set_pio);
-	speed = XFER_PIO_0 + set_pio;
-	if (set_speed)
-		(void) ide_config_drive_speed(drive, speed);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	sil_tune_pio(drive, pio);
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
@@ -335,7 +278,7 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 		case XFER_PIO_2:
 		case XFER_PIO_1:
 		case XFER_PIO_0:
-			siimage_tuneproc(drive, (speed - XFER_PIO_0));
+			sil_tune_pio(drive, speed - XFER_PIO_0);
 			mode |= ((unit) ? 0x10 : 0x01);
 			break;
 		case XFER_MW_DMA_2:
@@ -343,7 +286,6 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 		case XFER_MW_DMA_0:
 			multi = dma[speed - XFER_MW_DMA_0];
 			mode |= ((unit) ? 0x20 : 0x02);
-			config_siimage_chipset_for_pio(drive, 0);
 			break;
 		case XFER_UDMA_6:
 		case XFER_UDMA_5:
@@ -356,7 +298,6 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 			ultra |= ((scsc) ? (ultra6[speed - XFER_UDMA_0]) :
 					   (ultra5[speed - XFER_UDMA_0]));
 			mode |= ((unit) ? 0x30 : 0x03);
-			config_siimage_chipset_for_pio(drive, 0);
 			break;
 		default:
 			return 1;
@@ -390,7 +331,7 @@ static int siimage_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		config_siimage_chipset_for_pio(drive, 1);
+		sil_tuneproc(drive, 255);
 
 	return -1;
 }
@@ -961,7 +902,7 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	
 	hwif->resetproc = &siimage_reset;
 	hwif->speedproc = &siimage_tune_chipset;
-	hwif->tuneproc	= &siimage_tuneproc;
+	hwif->tuneproc	= &sil_tuneproc;
 	hwif->reset_poll = &siimage_reset_poll;
 	hwif->pre_reset = &siimage_pre_reset;
 	hwif->udma_filter = &sil_udma_filter;
@@ -976,11 +917,11 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 			first = 0;
 		}
 	}
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+
+	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+
+	if (hwif->dma_base == 0)
 		return;
-	}
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
@@ -1016,9 +957,9 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 		.init_iops	= init_iops_siimage,	\
 		.init_hwif	= init_hwif_siimage,	\
 		.fixup		= siimage_fixup,	\
-		.channels	= 2,			\
 		.autodma	= AUTODMA,		\
 		.bootable	= ON_BOARD,		\
+		.pio_mask	= ATA_PIO4,		\
 	}
 
 static ide_pci_device_t siimage_chipsets[] __devinitdata = {
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 756a9b6..63fbb79 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -521,7 +521,7 @@ static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 
 static int sis5513_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	config_art_rwp_pio(drive, pio);
 	return ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -878,10 +878,10 @@ static ide_pci_device_t sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
-	.channels	= 2,
 	.autodma	= NOAUTODMA,
 	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit sis5513_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index a7323d2..0947cab 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -52,12 +52,13 @@
  * Convert a PIO mode and cycle time to the required on/off times
  * for the interface.  This has protection against runaway timings.
  */
-static unsigned int get_pio_timings(ide_pio_data_t *p)
+static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 {
 	unsigned int cmd_on, cmd_off;
+	u8 iordy = 0;
 
-	cmd_on  = (ide_pio_timings[p->pio_mode].active_time + 29) / 30;
-	cmd_off = (p->cycle_time - 30 * cmd_on + 29) / 30;
+	cmd_on  = (ide_pio_timings[pio].active_time + 29) / 30;
+	cmd_off = (ide_pio_cycle_time(drive, pio) - 30 * cmd_on + 29) / 30;
 
 	if (cmd_on == 0)
 		cmd_on = 1;
@@ -65,7 +66,10 @@ static unsigned int get_pio_timings(ide_pio_data_t *p)
 	if (cmd_off == 0)
 		cmd_off = 1;
 
-	return (cmd_on - 1) << 8 | (cmd_off - 1) | (p->use_iordy ? 0x40 : 0x00);
+	if (pio > 2 || ide_dev_has_iordy(drive->id))
+		iordy = 0x40;
+
+	return (cmd_on - 1) << 8 | (cmd_off - 1) | iordy;
 }
 
 /*
@@ -75,14 +79,13 @@ static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
 	int reg			= 0x44 + drive->dn * 4;
-	ide_pio_data_t p;
 	u16 drv_ctrl;
 
 	DBG(("sl82c105_tune_pio(drive:%s, pio:%u)\n", drive->name, pio));
 
-	pio = ide_get_best_pio_mode(drive, pio, 5, &p);
+	pio = ide_get_best_pio_mode(drive, pio, 5);
 
-	drv_ctrl = get_pio_timings(&p);
+	drv_ctrl = get_pio_timings(drive, pio);
 
 	/*
 	 * Store the PIO timings so that we can restore them
@@ -101,7 +104,8 @@ static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 	}
 
 	printk(KERN_DEBUG "%s: selected %s (%dns) (%04X)\n", drive->name,
-	       ide_xfer_verbose(pio + XFER_PIO_0), p.cycle_time, drv_ctrl);
+			  ide_xfer_verbose(pio + XFER_PIO_0),
+			  ide_pio_cycle_time(drive, pio), drv_ctrl);
 
 	return pio;
 }
@@ -449,10 +453,10 @@ static ide_pci_device_t sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
 	.init_hwif	= init_hwif_sl82c105,
-	.channels	= 2,
 	.autodma	= NOAUTODMA,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO5,
 };
 
 static int __devinit sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 575dbbd..8e655f2 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -103,7 +103,7 @@ static void slc90e66_tune_pio (ide_drive_t *drive, u8 pio)
 
 static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	slc90e66_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -214,10 +214,10 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 static ide_pci_device_t slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit slc90e66_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 8de1f8e..ec79bac 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -47,7 +47,7 @@ static int tc86c001_tune_chipset(ide_drive_t *drive, u8 speed)
 
 static void tc86c001_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	pio =  ide_get_best_pio_mode(drive, pio, 4, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) tc86c001_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -248,9 +248,10 @@ static ide_pci_device_t tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
-	.channels	= 1,
 	.autodma	= AUTODMA,
-	.bootable	= OFF_BOARD
+	.bootable	= OFF_BOARD,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit tc86c001_init_one(struct pci_dev *dev,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 35e8c61..024bbfa 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -96,7 +96,7 @@ static int triflex_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 
 static void triflex_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	int use_pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	int use_pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) triflex_tune_chipset(drive, (XFER_PIO_0 + use_pio));
 }
 
@@ -129,10 +129,10 @@ static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 static ide_pci_device_t triflex_device __devinitdata = {
 	.name		= "TRIFLEX",
 	.init_hwif	= init_hwif_triflex,
-	.channels	= 2,
 	.autodma	= AUTODMA,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
 	.bootable	= ON_BOARD,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit triflex_init_one(struct pci_dev *dev, 
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index cbb1b11..dc4f4e2 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -327,7 +327,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 static ide_pci_device_t trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
-	.channels	= 2,
 	.autodma	= NOAUTODMA,
 	.bootable	= ON_BOARD,
 };
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 27e92fb..581316f 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.45
+ * Version 3.46
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -203,10 +203,8 @@ static int via_set_drive(ide_drive_t *drive, u8 speed)
 
 static void via82cxxx_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	if (pio == 255) {
-		via_set_drive(drive, ide_find_best_pio_mode(drive));
-		return;
-	}
+	if (pio == 255)
+		pio = ide_get_best_pio_mode(drive, 255, 5);
 
 	via_set_drive(drive, XFER_PIO_0 + min_t(u8, pio, 5));
 }
@@ -223,12 +221,14 @@ static int via82cxxx_ide_dma_check (ide_drive_t *drive)
 {
 	u8 speed = ide_max_dma_mode(drive);
 
-	if (speed == 0)
-		speed = ide_find_best_pio_mode(drive);
+	if (speed == 0) {
+		via82cxxx_tune_drive(drive, 255);
+		return -1;
+	}
 
 	via_set_drive(drive, speed);
 
-	if (drive->autodma && (speed & XFER_MODE) != XFER_PIO)
+	if (drive->autodma)
 		return 0;
 
 	return -1;
@@ -498,18 +498,22 @@ static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
 		.name		= "VP_IDE",
 		.init_chipset	= init_chipset_via82cxxx,
 		.init_hwif	= init_hwif_via82cxxx,
-		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},
-		.bootable	= ON_BOARD
+		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
+				| IDE_HFLAG_PIO_NO_DOWNGRADE,
+		.pio_mask	= ATA_PIO5,
 	},{	/* 1 */
 		.name		= "VP_IDE",
 		.init_chipset	= init_chipset_via82cxxx,
 		.init_hwif	= init_hwif_via82cxxx,
-		.channels	= 2,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x00,0x00,0x00}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
+				| IDE_HFLAG_PIO_NO_DOWNGRADE,
+		.pio_mask	= ATA_PIO5,
 	}
 };
 
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 82de2d7..8859fe2 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -316,6 +316,7 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 	}
 
 	/* register routine to tune PIO mode */
+	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].tuneproc = m8xx_ide_tuneproc;
 
 	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
@@ -402,6 +403,7 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 	}
 
 	/* register routine to tune PIO mode */
+	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].tuneproc = m8xx_ide_tuneproc;
 
 	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
@@ -431,13 +433,12 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 static void
 m8xx_ide_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	ide_pio_data_t d;
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
 	volatile pcmconf8xx_t	*pcmp;
 	ulong timing, mask, reg;
 #endif
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, &d);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
 
 #if 1
 	printk("%s[%d] %s: best PIO mode: %d\n",
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index e46f472..33630ad 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -615,24 +615,25 @@ out:
 static void
 pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	ide_pio_data_t d;
 	u32 *timings;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
 	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
-	
+	unsigned int cycle_time;
+
 	if (pmif == NULL)
 		return;
 		
 	/* which drive is it ? */
 	timings = &pmif->timings[drive->select.b.unit & 0x01];
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, &d);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	cycle_time = ide_pio_cycle_time(drive, pio);
 
 	switch (pmif->kind) {
 	case controller_sh_ata6: {
 		/* 133Mhz cell */
-		u32 tr = kauai_lookup_timing(shasta_pio_timings, d.cycle_time);
+		u32 tr = kauai_lookup_timing(shasta_pio_timings, cycle_time);
 		if (tr == 0)
 			return;
 		*timings = ((*timings) & ~TR_133_PIOREG_PIO_MASK) | tr;
@@ -641,7 +642,7 @@ pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 	case controller_un_ata6:
 	case controller_k2_ata6: {
 		/* 100Mhz cell */
-		u32 tr = kauai_lookup_timing(kauai_pio_timings, d.cycle_time);
+		u32 tr = kauai_lookup_timing(kauai_pio_timings, cycle_time);
 		if (tr == 0)
 			return;
 		*timings = ((*timings) & ~TR_100_PIOREG_PIO_MASK) | tr;
@@ -649,7 +650,7 @@ pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 		}
 	case controller_kl_ata4:
 		/* 66Mhz cell */
-		recTime = d.cycle_time - ide_pio_timings[pio].active_time
+		recTime = cycle_time - ide_pio_timings[pio].active_time
 				- ide_pio_timings[pio].setup_time;
 		recTime = max(recTime, 150U);
 		accessTime = ide_pio_timings[pio].active_time;
@@ -665,7 +666,7 @@ pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 	default: {
 		/* 33Mhz cell */
 		int ebit = 0;
-		recTime = d.cycle_time - ide_pio_timings[pio].active_time
+		recTime = cycle_time - ide_pio_timings[pio].active_time
 				- ide_pio_timings[pio].setup_time;
 		recTime = max(recTime, 150U);
 		accessTime = ide_pio_timings[pio].active_time;
@@ -1247,6 +1248,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->drives[0].unmask = 1;
 	hwif->drives[1].unmask = 1;
+	hwif->pio_mask = ATA_PIO4;
 	hwif->tuneproc = pmac_ide_tuneproc;
 	if (pmif->kind == controller_un_ata6
 	    || pmif->kind == controller_k2_ata6
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index c88d332..30e596c 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -5,12 +5,6 @@
  *
  *  Copyright (c) 1995-1998  Mark Lord
  *  May be copied or modified under the terms of the GNU General Public License
- *
- *  Recent Changes
- *	Split the set up function into multiple functions
- *	Use pci_set_master
- *	Fix misreporting of I/O v MMIO problems
- *	Initial fixups for simplex devices
  */
 
 /*
@@ -407,7 +401,7 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, ide_pci_device_t *d,
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
 
-	if ((d->flags & IDEPCI_FLAG_ISA_PORTS) == 0) {
+	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		/*  Possibly we should fail if these checks report true */
 		ide_pci_check_iomem(dev, d, 2*port);
 		ide_pci_check_iomem(dev, d, 2*port+1);
@@ -571,7 +565,7 @@ out:
  
 void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, ata_index_t *index)
 {
-	int port;
+	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	int at_least_one_hwif_enabled = 0;
 	ide_hwif_t *hwif, *mate = NULL;
 	u8 tmp;
@@ -582,16 +576,13 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 	 * Set up the IDE ports
 	 */
 	 
-	for (port = 0; port <= 1; ++port) {
+	for (port = 0; port < channels; ++port) {
 		ide_pci_enablebit_t *e = &(d->enablebits[port]);
 	
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val))
 			continue;	/* port not enabled */
 
-		if (d->channels	<= port)
-			break;
-	
 		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL)
 			continue;
 
@@ -616,6 +607,9 @@ void ide_pci_setup_ports(struct pci_dev *dev, ide_pci_device_t *d, int pciirq, a
 		else
 			ide_hwif_setup_dma(dev, d, hwif);
 bypass_legacy_dma:
+		hwif->host_flags = d->host_flags;
+		hwif->pio_mask = d->pio_mask;
+
 		if (d->init_hwif)
 			/* Call chipset-specific routine
 			 * for each enabled hwif
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b5a2016..23a22df 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -64,6 +64,15 @@ enum {
 	ATA_ID_PROD_LEN		= 40,
 
 	ATA_PCI_CTL_OFS		= 2,
+
+	ATA_PIO0		= (1 << 0),
+	ATA_PIO1		= ATA_PIO0 | (1 << 1),
+	ATA_PIO2		= ATA_PIO1 | (1 << 2),
+	ATA_PIO3		= ATA_PIO2 | (1 << 3),
+	ATA_PIO4		= ATA_PIO3 | (1 << 4),
+	ATA_PIO5		= ATA_PIO4 | (1 << 5),
+	ATA_PIO6		= ATA_PIO5 | (1 << 6),
+
 	ATA_UDMA0		= (1 << 0),
 	ATA_UDMA1		= ATA_UDMA0 | (1 << 1),
 	ATA_UDMA2		= ATA_UDMA1 | (1 << 2),
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 19ab258..5f5daad 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -681,6 +681,10 @@ typedef struct hwif_s {
 	u8 straight8;	/* Alan's straight 8 check */
 	u8 bus_state;	/* power state of the IDE bus */
 
+	u8 host_flags;
+
+	u8 pio_mask;
+
 	u8 atapi_dma;	/* host supports atapi_dma */
 	u8 ultra_mask;
 	u8 mwdma_mask;
@@ -1244,7 +1248,13 @@ typedef struct ide_pci_enablebit_s {
 
 enum {
 	/* Uses ISA control ports not PCI ones. */
-	IDEPCI_FLAG_ISA_PORTS		= (1 << 0),
+	IDE_HFLAG_ISA_PORTS		= (1 << 0),
+	/* single port device */
+	IDE_HFLAG_SINGLE		= (1 << 1),
+	/* don't use legacy PIO blacklist */
+	IDE_HFLAG_PIO_NO_BLACKLIST	= (1 << 2),
+	/* don't use conservative PIO "downgrade" */
+	IDE_HFLAG_PIO_NO_DOWNGRADE	= (1 << 3),
 };
 
 typedef struct ide_pci_device_s {
@@ -1256,13 +1266,13 @@ typedef struct ide_pci_device_s {
 	void                    (*init_hwif)(ide_hwif_t *);
 	void			(*init_dma)(ide_hwif_t *, unsigned long);
 	void			(*fixup)(ide_hwif_t *);
-	u8			channels;
 	u8			autodma;
 	ide_pci_enablebit_t	enablebits[2];
 	u8			bootable;
 	unsigned int		extra;
 	struct ide_pci_device_s	*next;
-	u8			flags;
+	u8			host_flags;
+	u8			pio_mask;
 	u8			udma_mask;
 } ide_pci_device_t;
 
@@ -1363,6 +1373,11 @@ extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 int ide_use_fast_pio(ide_drive_t *);
 
+static inline int ide_dev_has_iordy(struct hd_driveid *id)
+{
+	return ((id->field_valid & 2) && (id->capability & 8)) ? 1 : 0;
+}
+
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
 typedef struct ide_pio_timings_s {
@@ -1372,14 +1387,8 @@ typedef struct ide_pio_timings_s {
 				/* active + recovery (+ setup for some chips) */
 } ide_pio_timings_t;
 
-typedef struct ide_pio_data_s {
-	u8 pio_mode;
-	u8 use_iordy;
-	u8 overridden;
-	unsigned int cycle_time;
-} ide_pio_data_t;
-
-extern u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_pio_data_t *d);
+unsigned int ide_pio_cycle_time(ide_drive_t *, u8);
+u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
 extern const ide_pio_timings_t ide_pio_timings[6];
 
 
