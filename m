Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbYJJVdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbYJJVdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761344AbYJJVdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:33:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:35352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761006AbYJJVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=jVDRGBGtJvsLQ49di22opo4di+lvtLCI+LGUoTUGIDeVFhIwLE3ip39nDKn2Ab8PhV
         HELtwY/I52DD3H7xI0BXYFFC7sTrgIaGN2cuYMEqSCJVGXYCAjP0lP+T5OD7/5gOo/LI
         R5fkkFfQ5Q9R/2xny4w5urejUF8S5BGAmjg+g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates #1
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 10 Oct 2008 23:19:48 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810102319.50206.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Inside:

* ide-generic host driver fix to not claim by default ports for
  which there is a better driver available. (Borislav Petkov)

* Proper PCI Power Management support.

* More work on generic ATAPI support. (Borislav Petkov & me)

* Use/add generic helpers for device identity handling.

* Re-work of IDE settings infrastructure.

* Use special driver requests for handling IDE settings. 
  (Elias Oltmanns)

* Misc fixes/improvements.
  (Mark de Wever, FUJITA Tomonori, Linus Torvalds, me)

Thanks to all contributors!

Also thanks to all people reviewing patches and testing linux-next
(+ reporting bugs) since without their help it wouldn't be possible
to keep the usual high-quality of IDE updates.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ata/libata-scsi.c      |    2 +-
 drivers/block/hd.c             |    9 +-
 drivers/ide/Kconfig            |   23 --
 drivers/ide/Makefile           |    7 +-
 drivers/ide/arm/icside.c       |    5 +-
 drivers/ide/arm/palm_bk3710.c  |    8 +-
 drivers/ide/ide-acpi.c         |    6 +-
 drivers/ide/ide-atapi.c        |  236 +++++++++++++--
 drivers/ide/ide-cd.c           |   72 ++---
 drivers/ide/ide-disk.c         |  340 ++++++++-------------
 drivers/ide/ide-dma.c          |   52 ++--
 drivers/ide/ide-floppy.c       |  668 +++++++---------------------------------
 drivers/ide/ide-floppy.h       |   63 ++++
 drivers/ide/ide-floppy_ioctl.c |  243 +++++++++++++++
 drivers/ide/ide-generic.c      |   55 +++-
 drivers/ide/ide-io.c           |  117 +++++---
 drivers/ide/ide-ioctls.c       |  290 +++++++++++++++++
 drivers/ide/ide-iops.c         |  225 ++++----------
 drivers/ide/ide-lib.c          |   73 +++---
 drivers/ide/ide-probe.c        |  252 +++++++--------
 drivers/ide/ide-proc.c         |  306 ++++++-------------
 drivers/ide/ide-tape.c         |  478 ++++++++---------------------
 drivers/ide/ide-taskfile.c     |  156 ++--------
 drivers/ide/ide-timings.c      |   22 +-
 drivers/ide/ide.c              |  238 ++-------------
 drivers/ide/legacy/ali14xx.c   |    1 -
 drivers/ide/legacy/buddha.c    |    1 -
 drivers/ide/legacy/dtc2278.c   |    1 -
 drivers/ide/legacy/falconide.c |    1 -
 drivers/ide/legacy/gayle.c     |    1 -
 drivers/ide/legacy/ht6560b.c   |    1 -
 drivers/ide/legacy/ide-cs.c    |    1 -
 drivers/ide/legacy/macide.c    |    1 -
 drivers/ide/legacy/q40ide.c    |    2 -
 drivers/ide/legacy/qd65xx.c    |   23 +-
 drivers/ide/legacy/umc8672.c   |    1 -
 drivers/ide/pci/aec62xx.c      |    5 +-
 drivers/ide/pci/alim15x3.c     |    9 +-
 drivers/ide/pci/amd74xx.c      |    8 +-
 drivers/ide/pci/atiixp.c       |    3 +-
 drivers/ide/pci/cmd640.c       |   43 ++--
 drivers/ide/pci/cmd64x.c       |    5 +-
 drivers/ide/pci/cs5520.c       |    3 +-
 drivers/ide/pci/cs5530.c       |   19 +-
 drivers/ide/pci/cs5535.c       |   14 +-
 drivers/ide/pci/cy82c693.c     |    4 +-
 drivers/ide/pci/delkin_cb.c    |    1 -
 drivers/ide/pci/generic.c      |    3 +-
 drivers/ide/pci/hpt34x.c       |    5 +-
 drivers/ide/pci/hpt366.c       |   77 +++--
 drivers/ide/pci/it8213.c       |    3 +-
 drivers/ide/pci/it821x.c       |   58 ++--
 drivers/ide/pci/jmicron.c      |    3 +-
 drivers/ide/pci/ns87415.c      |    9 +-
 drivers/ide/pci/opti621.c      |    7 +-
 drivers/ide/pci/pdc202xx_new.c |   15 +-
 drivers/ide/pci/pdc202xx_old.c |   11 +-
 drivers/ide/pci/piix.c         |    5 +-
 drivers/ide/pci/rz1000.c       |    1 -
 drivers/ide/pci/sc1200.c       |   15 +-
 drivers/ide/pci/scc_pata.c     |    5 +-
 drivers/ide/pci/serverworks.c  |    9 +-
 drivers/ide/pci/sgiioc4.c      |    1 -
 drivers/ide/pci/siimage.c      |   17 +-
 drivers/ide/pci/sis5513.c      |    5 +-
 drivers/ide/pci/sl82c105.c     |    7 +-
 drivers/ide/pci/slc90e66.c     |    3 +-
 drivers/ide/pci/triflex.c      |    3 +-
 drivers/ide/pci/trm290.c       |    1 -
 drivers/ide/pci/via82cxxx.c    |   10 +-
 drivers/ide/ppc/pmac.c         |    6 +-
 drivers/ide/setup-pci.c        |   33 ++
 drivers/scsi/ide-scsi.c        |  120 +++-----
 include/linux/ata.h            |  112 +++++++-
 include/linux/ide.h            |  316 ++++++++++++-------
 75 files changed, 2388 insertions(+), 2566 deletions(-)
 create mode 100644 drivers/ide/ide-floppy.h
 create mode 100644 drivers/ide/ide-floppy_ioctl.c
 create mode 100644 drivers/ide/ide-ioctls.c


Bartlomiej Zolnierkiewicz (65):
      ide: remove superfluous check from ide_disk_special()
      ide: cleanup ide_disk_init_mult_count()
      ide: cleanup ide_fix_driveid()
      ide: make drive->id an union (take 2)
      ide: remove drive->driveid
      ide: use ata_id_current_chs_valid()
      ide-disk: use ata_id_wcache_enabled()
      ide-disk: use ata_id_hpa_enabled()
      libata: WIN_* -> ATA_CMD_*
      ide: WIN_* -> ATA_CMD_*
      hd: WIN_* -> ATA_CMD_*
      ide: use ATA_* defines instead of *_STAT and *_ERR ones
      ide: remove no longer needed ide_drive_t fields
      ide: fix EXABYTENEST handling in probe_for_drive()
      ide: enhance ide_busy_sleep()
      ide: remove no longer needed BUG_ON()-s from init_irq()
      ide: remove IDE_CHIPSET_* macros
      ide: remove unused _IDE_C and _IDE_DISK defines
      ide: remove needless drive->present checks from device drivers
      ide: check drive->present in ide_get_paired_drive()
      ide: remove CONFIG_IDEDISK_MULTI_MODE
      ide: include <linux/hdreg.h> only when needed
      ide: call ide_proc_register_driver() later
      ide: preparations for /proc/ide/hd*/settings rework
      ide: /proc/ide/hd*/settings rework
      ide: remove SECTOR_WORDS define
      cmd640: add __set_prefetch_mode()
      ide: remove read-only ->atapi_overlap field from ide_drive_t
      ide: remove ->supports_dsc_overlap field from ide_driver_t
      ide: factor out HDIO_*_NICE ioctl handling to ide_*_nice_ioctl()
      ide: ide_dev_has_iordy() -> ata_id_has_iordy()
      ide: ide_dev_is_sata() -> ata_id_is_sata()
      ide: idedisk_supports_lba48() -> ata_id_lba48_enabled()
      ide: check only for CACHE FLUSH command support in ide_id_has_flush_cache()
      ide: ide_id_has_flush_cache() -> ata_id_flush_enabled()
      ide: ide_id_has_flush_cache_ext() -> ata_id_flush_ext_enabled()
      ide: use ata_id_is_cfa()
      ide: ide_id_to_hd_driveid() -> ata_id_to_hd_driveid()
      ide: lba_capacity_is_ok() -> ata_id_is_lba_capacity_ok()
      hpt366: add hpt3xx_disable_fast_irq() helper
      ide: add proper PCI PM support (v2)
      ide: remove ->bus_state field from ide_hwif_t
      ide: add ide_setting_ioctl() helper
      ide: cleanup generic_ide_ioctl()
      ide: move ioctls handling to ide-ioctls.c
      ide: add ide_check_atapi_device() helper
      ide-floppy: remove needless parens
      ide-floppy: add ide_floppy_format_ioctl() helper
      ide-tape: remove idetape_init_rq()
      ide-{floppy,tape}: remove request stack
      ide-{floppy,tape}: remove packet command stack
      ide-floppy: remove MODE_SENSE_* defines
      ide-scsi: cleanup ide_scsi_io_buffers()
      ide: add ide_io_buffers() helper
      ide-floppy: add ide_floppy_set_media_lock() helper
      ide-tape: add ide_tape_set_media_lock() helper
      ide: add ide_init_pc() helper
      ide: add ide_queue_pc_head() helper
      ide: add ide_queue_pc_tail() helper
      ide-floppy: ->{srfp,wp} -> IDE_AFLAG_{SRFP,WP}
      ide-floppy: move floppy ioctls handling to ide-floppy_ioctl.c
      ide: add ide_set_media_lock() helper
      ide: add ide_do_start_stop() helper
      ide: add ide_do_test_unit_ready() helper
      ide: move IDE{FLOPPY,TAPE}_WAIT_CMD defines to <linux/ide.h>

Borislav Petkov (2):
      ide-floppy: use scatterlists for pio transfers
      ide-generic: handle probing of legacy io-ports v5

Elias Oltmanns (1):
      ide: Remove ide_spin_wait_hwgroup() and use special requests instead

FUJITA Tomonori (1):
      ide-cd: use the new object_is_in_stack() helper

Linus Torvalds (1):
      ide: re-code ide_fixstring() loop to be less evil

Mark de Wever (1):
      ide-tape: Buildfix when IDETAPE_DEBUG_LOG is set to 1.


diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 59fe051..5d312dc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -503,7 +503,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	scsi_cmd[0] = ATA_16;
 
 	scsi_cmd[4] = args[2];
-	if (args[0] == WIN_SMART) { /* hack -- ide driver does this too... */
+	if (args[0] == ATA_CMD_SMART) { /* hack -- ide driver does this too */
 		scsi_cmd[6]  = args[3];
 		scsi_cmd[8]  = args[1];
 		scsi_cmd[10] = 0x4f;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 682243b..482c0c4 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -39,6 +39,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/blkpg.h>
+#include <linux/ata.h>
 #include <linux/hdreg.h>
 
 #define REALLY_SLOW_IO
@@ -370,7 +371,7 @@ repeat:
 		struct hd_i_struct *disk = &hd_info[i];
 		disk->special_op = disk->recalibrate = 1;
 		hd_out(disk, disk->sect, disk->sect, disk->head-1,
-			disk->cyl, WIN_SPECIFY, &reset_hd);
+			disk->cyl, ATA_CMD_INIT_DEV_PARAMS, &reset_hd);
 		if (reset)
 			goto repeat;
 	} else
@@ -558,7 +559,7 @@ static int do_special_op(struct hd_i_struct *disk, struct request *req)
 {
 	if (disk->recalibrate) {
 		disk->recalibrate = 0;
-		hd_out(disk, disk->sect, 0, 0, 0, WIN_RESTORE, &recal_intr);
+		hd_out(disk, disk->sect, 0, 0, 0, ATA_CMD_RESTORE, &recal_intr);
 		return reset;
 	}
 	if (disk->head > 16) {
@@ -631,13 +632,13 @@ repeat:
 	if (blk_fs_request(req)) {
 		switch (rq_data_dir(req)) {
 		case READ:
-			hd_out(disk, nsect, sec, head, cyl, WIN_READ,
+			hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_READ,
 				&read_intr);
 			if (reset)
 				goto repeat;
 			break;
 		case WRITE:
-			hd_out(disk, nsect, sec, head, cyl, WIN_WRITE,
+			hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_WRITE,
 				&write_intr);
 			if (reset)
 				goto repeat;
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 052879a..b50b5da 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -131,29 +131,6 @@ config BLK_DEV_IDEDISK
 
 	  If unsure, say Y.
 
-config IDEDISK_MULTI_MODE
-	bool "Use multiple sector mode for Programmed Input/Output by default"
-	help
-	  This setting is irrelevant for most IDE disks, with direct memory
-	  access, to which multiple sector mode does not apply. Multiple sector
-	  mode is a feature of most modern IDE hard drives, permitting the
-	  transfer of multiple sectors per Programmed Input/Output interrupt,
-	  rather than the usual one sector per interrupt. When this feature is
-	  enabled, it can reduce operating system overhead for disk Programmed
-	  Input/Output. On some systems, it also can increase the data
-	  throughput of Programmed Input/Output. Some drives, however, seemed
-	  to run slower with multiple sector mode enabled. Some drives claimed
-	  to support multiple sector mode, but lost data at some settings.
-	  Under rare circumstances, such failures could result in massive
-	  filesystem corruption.
-
-	  If you get the following error, try to say Y here:
-
-	  hda: set_multmode: status=0x51 { DriveReady SeekComplete Error }
-	  hda: set_multmode: error=0x04 { DriveStatusError }
-
-	  If in doubt, say N.
-
 config BLK_DEV_IDECS
 	tristate "PCMCIA IDE support"
 	depends on PCMCIA
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 64e0ecd..308b8a1 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -4,8 +4,8 @@
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
-ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o \
-	      ide-pio-blacklist.o
+ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
+	      ide-taskfile.o ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
@@ -37,11 +37,12 @@ obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
+ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
+obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
-obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy.o
 
 ifeq ($(CONFIG_BLK_DEV_IDECS), y)
 	ide-cs-core-y += legacy/ide-cs.o
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index df4af40..70f5b16 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
@@ -265,8 +264,8 @@ static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 	 * If we're going to be doing MW_DMA_1 or MW_DMA_2, we should
 	 * take care to note the values in the ID...
 	 */
-	if (use_dma_info && drive->id->eide_dma_time > cycle_time)
-		cycle_time = drive->id->eide_dma_time;
+	if (use_dma_info && drive->id[ATA_ID_EIDE_DMA_TIME] > cycle_time)
+		cycle_time = drive->id[ATA_ID_EIDE_DMA_TIME];
 
 	drive->drive_data = cycle_time;
 
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 4fd91dc..122ed3c 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -180,7 +179,7 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 	val32 |= (t2i << (dev ? 8 : 0));
 	writel(val32, base + BK3710_DATRCVR);
 
-	if (mate && mate->present) {
+	if (mate) {
 		u8 mode2 = ide_get_best_pio_mode(mate, 255, 4);
 
 		if (mode2 < mode)
@@ -213,7 +212,8 @@ static void palm_bk3710_set_dma_mode(ide_drive_t *drive, u8 xferspeed)
 		palm_bk3710_setudmamode(base, is_slave,
 					xferspeed - XFER_UDMA_0);
 	} else {
-		palm_bk3710_setdmamode(base, is_slave, drive->id->eide_dma_min,
+		palm_bk3710_setdmamode(base, is_slave,
+				       drive->id[ATA_ID_EIDE_DMA_MIN],
 				       xferspeed);
 	}
 }
@@ -229,7 +229,7 @@ static void palm_bk3710_set_pio_mode(ide_drive_t *drive, u8 pio)
 	 * Obtain the drive PIO data for tuning the Palm Chip registers
 	 */
 	cycle_time = ide_pio_cycle_time(drive, pio);
-	mate = ide_get_paired_drive(drive);
+	mate = ide_get_pair_dev(drive);
 	palm_bk3710_setpiomode(base, mate, is_slave, cycle_time, pio);
 }
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 6f70462..2427c38 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -584,7 +584,7 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
  * This function executes the _STM ACPI method for the target channel.
  *
  * _STM requires Identify Drive data, which has to passed as an argument.
- * Unfortunately hd_driveid is a mangled version which we can't readily
+ * Unfortunately drive->id is a mangled version which we can't readily
  * use; hence we'll get the information afresh.
  */
 void ide_acpi_push_timing(ide_hwif_t *hwif)
@@ -614,10 +614,10 @@ void ide_acpi_push_timing(ide_hwif_t *hwif)
 	in_params[0].buffer.length = sizeof(struct GTM_buffer);
 	in_params[0].buffer.pointer = (u8 *)&hwif->acpidata->gtm;
 	in_params[1].type = ACPI_TYPE_BUFFER;
-	in_params[1].buffer.length = sizeof(struct hd_driveid);
+	in_params[1].buffer.length = sizeof(ATA_ID_WORDS * 2);
 	in_params[1].buffer.pointer = (u8 *)&master->idbuff;
 	in_params[2].type = ACPI_TYPE_BUFFER;
-	in_params[2].buffer.length = sizeof(struct hd_driveid);
+	in_params[2].buffer.length = sizeof(ATA_ID_WORDS * 2);
 	in_params[2].buffer.pointer = (u8 *)&slave->idbuff;
 	/* Output buffer: _STM has no output */
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index adf04f9..608c5ba 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -14,12 +14,201 @@
 #define debug_log(fmt, args...) do {} while (0)
 #endif
 
+/*
+ * Check whether we can support a device,
+ * based on the ATAPI IDENTIFY command results.
+ */
+int ide_check_atapi_device(ide_drive_t *drive, const char *s)
+{
+	u16 *id = drive->id;
+	u8 gcw[2], protocol, device_type, removable, drq_type, packet_size;
+
+	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
+
+	protocol    = (gcw[1] & 0xC0) >> 6;
+	device_type =  gcw[1] & 0x1F;
+	removable   = (gcw[0] & 0x80) >> 7;
+	drq_type    = (gcw[0] & 0x60) >> 5;
+	packet_size =  gcw[0] & 0x03;
+
+#ifdef CONFIG_PPC
+	/* kludge for Apple PowerBook internal zip */
+	if (drive->media == ide_floppy && device_type == 5 &&
+	    !strstr((char *)&id[ATA_ID_PROD], "CD-ROM") &&
+	    strstr((char *)&id[ATA_ID_PROD], "ZIP"))
+		device_type = 0;
+#endif
+
+	if (protocol != 2)
+		printk(KERN_ERR "%s: %s: protocol (0x%02x) is not ATAPI\n",
+			s, drive->name, protocol);
+	else if ((drive->media == ide_floppy && device_type != 0) ||
+		 (drive->media == ide_tape && device_type != 1))
+		printk(KERN_ERR "%s: %s: invalid device type (0x%02x)\n",
+			s, drive->name, device_type);
+	else if (removable == 0)
+		printk(KERN_ERR "%s: %s: the removable flag is not set\n",
+			s, drive->name);
+	else if (drive->media == ide_floppy && drq_type == 3)
+		printk(KERN_ERR "%s: %s: sorry, DRQ type (0x%02x) not "
+			"supported\n", s, drive->name, drq_type);
+	else if (packet_size != 0)
+		printk(KERN_ERR "%s: %s: packet size (0x%02x) is not 12 "
+			"bytes\n", s, drive->name, packet_size);
+	else
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_check_atapi_device);
+
+/* PIO data transfer routine using the scatter gather table. */
+int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		    unsigned int bcount, int write)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
+	struct scatterlist *sg = pc->sg;
+	char *buf;
+	int count, done = 0;
+
+	while (bcount) {
+		count = min(sg->length - pc->b_count, bcount);
+
+		if (PageHighMem(sg_page(sg))) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+			xf(drive, NULL, buf + pc->b_count, count);
+			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			local_irq_restore(flags);
+		} else {
+			buf = sg_virt(sg);
+			xf(drive, NULL, buf + pc->b_count, count);
+		}
+
+		bcount -= count;
+		pc->b_count += count;
+		done += count;
+
+		if (pc->b_count == sg->length) {
+			if (!--pc->sg_cnt)
+				break;
+			pc->sg = sg = sg_next(sg);
+			pc->b_count = 0;
+		}
+	}
+
+	if (bcount) {
+		printk(KERN_ERR "%s: %d leftover bytes, %s\n", drive->name,
+			bcount, write ? "padding with zeros"
+				      : "discarding data");
+		ide_pad_transfer(drive, write, bcount);
+	}
+
+	return done;
+}
+EXPORT_SYMBOL_GPL(ide_io_buffers);
+
+void ide_init_pc(struct ide_atapi_pc *pc)
+{
+	memset(pc, 0, sizeof(*pc));
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDE_PC_BUFFER_SIZE;
+}
+EXPORT_SYMBOL_GPL(ide_init_pc);
+
+/*
+ * Generate a new packet command request in front of the request queue, before
+ * the current request, so that it will be processed immediately, on the next
+ * pass through the driver.
+ */
+void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
+		       struct ide_atapi_pc *pc, struct request *rq)
+{
+	blk_rq_init(NULL, rq);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_PREEMPT;
+	rq->buffer = (char *)pc;
+	rq->rq_disk = disk;
+	memcpy(rq->cmd, pc->c, 12);
+	if (drive->media == ide_tape)
+		rq->cmd[13] = REQ_IDETAPE_PC1;
+	ide_do_drive_cmd(drive, rq);
+}
+EXPORT_SYMBOL_GPL(ide_queue_pc_head);
+
+/*
+ * Add a special packet command request to the tail of the request queue,
+ * and wait for it to be serviced.
+ */
+int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
+		      struct ide_atapi_pc *pc)
+{
+	struct request *rq;
+	int error;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->buffer = (char *)pc;
+	memcpy(rq->cmd, pc->c, 12);
+	if (drive->media == ide_tape)
+		rq->cmd[13] = REQ_IDETAPE_PC1;
+	error = blk_execute_rq(drive->queue, disk, rq, 0);
+	blk_put_request(rq);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
+
+int ide_do_test_unit_ready(ide_drive_t *drive, struct gendisk *disk)
+{
+	struct ide_atapi_pc pc;
+
+	ide_init_pc(&pc);
+	pc.c[0] = TEST_UNIT_READY;
+
+	return ide_queue_pc_tail(drive, disk, &pc);
+}
+EXPORT_SYMBOL_GPL(ide_do_test_unit_ready);
+
+int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
+{
+	struct ide_atapi_pc pc;
+
+	ide_init_pc(&pc);
+	pc.c[0] = START_STOP;
+	pc.c[4] = start;
+
+	if (drive->media == ide_tape)
+		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
+
+	return ide_queue_pc_tail(drive, disk, &pc);
+}
+EXPORT_SYMBOL_GPL(ide_do_start_stop);
+
+int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
+{
+	struct ide_atapi_pc pc;
+
+	if (drive->atapi_flags & IDE_AFLAG_NO_DOORLOCK)
+		return 0;
+
+	ide_init_pc(&pc);
+	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
+	pc.c[4] = on;
+
+	return ide_queue_pc_tail(drive, disk, &pc);
+}
+EXPORT_SYMBOL_GPL(ide_set_media_lock);
+
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
@@ -41,7 +230,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
-		    (drive->media == ide_tape && !scsi && (stat & ERR_STAT))) {
+		    (drive->media == ide_tape && !scsi && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy && !scsi)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
@@ -56,7 +245,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
+	if ((stat & ATA_DRQ) == 0) {
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
@@ -65,10 +254,10 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape && !scsi &&
-		    (stat & ERR_STAT) && rq->cmd[0] == REQUEST_SENSE)
-			stat &= ~ERR_STAT;
+		    (stat & ATA_ERR) && rq->cmd[0] == REQUEST_SENSE)
+			stat &= ~ATA_ERR;
 
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+		if ((stat & ATA_ERR) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
 
@@ -95,7 +284,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 cmd_finished:
 		pc->error = 0;
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & SEEK_STAT) == 0) {
+		    (stat & ATA_DSC) == 0) {
 			dsc_handle(drive);
 			return ide_stopped;
 		}
@@ -117,17 +306,18 @@ cmd_finished:
 	/* Get the number of bytes to transfer on this interrupt. */
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
-	if (ireason & CD) {
+	if (ireason & ATAPI_COD) {
 		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
+	if (((ireason & ATAPI_IO) == ATAPI_IO) ==
+		!!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
 				"to %s!\n", drive->name,
-				(ireason & IO) ? "Write" : "Read",
-				(ireason & IO) ? "Read" : "Write");
+				(ireason & ATAPI_IO) ? "Write" : "Read",
+				(ireason & ATAPI_IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 
@@ -171,9 +361,14 @@ cmd_finished:
 
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
-	    (scsi && pc->sg))
-		io_buffers(drive, pc, bcount, !!(pc->flags & PC_FLAG_WRITING));
-	else
+	    (scsi && pc->sg)) {
+		int done = io_buffers(drive, pc, bcount,
+				  !!(pc->flags & PC_FLAG_WRITING));
+
+		/* FIXME: don't do partial completions */
+		if (drive->media == ide_floppy && !scsi)
+			ide_end_request(drive, 1, done >> 9);
+	} else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
 	/* Update the current position */
@@ -205,7 +400,8 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 {
 	int retries = 100;
 
-	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
+	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
+		(ireason & ATAPI_IO))) {
 		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
@@ -214,8 +410,8 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 					"a packet command, ignoring\n",
 					drive->name);
-			ireason |= CD;
-			ireason &= ~IO;
+			ireason |= ATAPI_COD;
+			ireason &= ~ATAPI_IO;
 		}
 	}
 
@@ -231,7 +427,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
 		printk(KERN_ERR "%s: Strange, packet command initiated yet "
 				"DRQ isn't asserted\n", drive->name);
 		return startstop;
@@ -241,7 +437,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	if (drive->media == ide_tape && !drive->scsi)
 		ireason = ide_wait_ireason(drive, ireason);
 
-	if ((ireason & CD) == 0 || (ireason & IO)) {
+	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
 		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
 				"a packet command\n", drive->name);
 		return ide_do_reset(drive);
@@ -303,7 +499,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, WIN_PACKETCMD, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, handler,
 				    timeout, NULL);
 		return ide_started;
 	} else {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 03c2cb6..465a92c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -436,7 +436,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			ide_dump_status_no_sense(drive, "media error (blank)",
 						 stat);
 			do_end_request = 1;
-		} else if ((err & ~ABRT_ERR) != 0) {
+		} else if ((err & ~ATA_ABORTED) != 0) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
@@ -457,7 +457,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		 * If we got a CHECK_CONDITION status, queue
 		 * a request sense command.
 		 */
-		if (stat & ERR_STAT)
+		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 	} else {
 		blk_dump_rq_flags(rq, "ide-cd: bad rq");
@@ -468,7 +468,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	return 1;
 
 end_request:
-	if (stat & ERR_STAT) {
+	if (stat & ATA_ERR) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ide_lock, flags);
@@ -541,7 +541,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
-		ide_execute_command(drive, WIN_PACKETCMD, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, handler,
 				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
@@ -574,7 +574,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 		 */
 
 		/* check for errors */
-		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
+		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
 			return ide_stopped;
 
 		/* ok, next interrupt will be DMA interrupt */
@@ -582,8 +582,8 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 			drive->waiting_for_dma = 1;
 	} else {
 		/* otherwise, we must wait for DRQ to get set */
-		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
-				BUSY_STAT, WAIT_READY))
+		if (ide_wait_stat(&startstop, drive, ATA_DRQ,
+				  ATA_BUSY, WAIT_READY))
 			return startstop;
 	}
 
@@ -938,7 +938,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		thislen = len;
 
 	/* If DRQ is clear, the command has completed. */
-	if ((stat & DRQ_STAT) == 0) {
+	if ((stat & ATA_DRQ) == 0) {
 		if (blk_fs_request(rq)) {
 			/*
 			 * If we're not done reading/writing, complain.
@@ -1164,13 +1164,12 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
-		unsigned long addr;
-		unsigned long stack_mask = ~(THREAD_SIZE - 1);
+		char *buf;
 
 		if (rq->bio)
-			addr = (unsigned long)bio_data(rq->bio);
+			buf = bio_data(rq->bio);
 		else
-			addr = (unsigned long)rq->data;
+			buf = rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1181,11 +1180,8 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * separate masks.
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-		if (addr & alignment || rq->data_len & alignment)
-			info->dma = 0;
-
-		if (!((addr & stack_mask) ^
-		      ((unsigned long)current->stack & stack_mask)))
+		if ((unsigned long)buf & alignment || rq->data_len & alignment
+		    || object_is_on_stack(buf))
 			info->dma = 0;
 	}
 }
@@ -1206,7 +1202,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 			unsigned long elapsed = jiffies - info->start_seek;
 			int stat = hwif->tp_ops->read_status(hwif);
 
-			if ((stat & SEEK_STAT) != SEEK_STAT) {
+			if ((stat & ATA_DSC) != ATA_DSC) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
 					ide_stall_queue(drive,
 							IDECD_SEEK_TIMER);
@@ -1813,13 +1809,12 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ NULL, 0, NULL, NULL }
 };
 
-static void ide_cdrom_add_settings(ide_drive_t *drive)
-{
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->dsc_overlap, NULL);
-}
-#else
-static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
+ide_devset_rw_field(dsc_overlap, dsc_overlap);
+
+static const struct ide_proc_devset idecd_settings[] = {
+	IDE_PROC_DEVSET(dsc_overlap, 0, 1),
+	{ 0 },
+};
 #endif
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
@@ -1866,14 +1861,14 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
 	{ NULL, NULL, 0 }
 };
 
-static unsigned int ide_cd_flags(struct hd_driveid *id)
+static unsigned int ide_cd_flags(u16 *id)
 {
 	const struct cd_list_entry *cle = ide_cd_quirks_list;
 
 	while (cle->id_model) {
-		if (strcmp(cle->id_model, id->model) == 0 &&
+		if (strcmp(cle->id_model, (char *)&id[ATA_ID_PROD]) == 0 &&
 		    (cle->id_firmware == NULL ||
-		     strstr(id->fw_rev, cle->id_firmware)))
+		     strstr((char *)&id[ATA_ID_FW_REV], cle->id_firmware)))
 			return cle->cd_flags;
 		cle++;
 	}
@@ -1885,7 +1880,8 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
+	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
@@ -1900,15 +1896,15 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
-	if ((id->config & 0x0060) == 0x20)
+	if ((id[ATA_ID_CONFIG] & 0x0060) == 0x20)
 		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 
 	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
-	    id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
+	    fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
 				     IDE_AFLAG_TOCADDR_AS_BCD);
 	else if ((drive->atapi_flags & IDE_AFLAG_VERTOS_600_ESD) &&
-		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
+		 fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= IDE_AFLAG_TOCTRACKS_AS_BCD;
 	else if (drive->atapi_flags & IDE_AFLAG_SANYO_3CD)
 		/* 3 => use CD in slot 0 */
@@ -1927,7 +1923,8 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
-	ide_cdrom_add_settings(drive);
+
+	ide_proc_register_driver(drive, cd->driver);
 	return 0;
 }
 
@@ -1972,12 +1969,12 @@ static ide_driver_t ide_cdrom_driver = {
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
 	.media			= ide_cdrom,
-	.supports_dsc_overlap	= 1,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idecd_proc,
+	.settings		= idecd_settings,
 #endif
 };
 
@@ -2112,10 +2109,10 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_cdrom && drive->media != ide_optical)
 		goto failed;
+
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
@@ -2137,8 +2134,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &ide_cdrom_driver);
-
 	kref_init(&info->kref);
 
 	info->drive = drive;
@@ -2153,7 +2148,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	g->driverfs_dev = &drive->gendev;
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
-		ide_proc_unregister_driver(drive, &ide_cdrom_driver);
 		ide_cd_release(&info->kref);
 		goto failed;
 	}
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 33ea8c0..01846f2 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -30,10 +30,8 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/leds.h>
-
-#define _IDE_DISK
-
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
@@ -90,68 +88,19 @@ static void ide_disk_put(struct ide_disk_obj *idkp)
 	mutex_unlock(&idedisk_ref_mutex);
 }
 
-/*
- * lba_capacity_is_ok() performs a sanity check on the claimed "lba_capacity"
- * value for this drive (from its reported identification information).
- *
- * Returns:	1 if lba_capacity looks sensible
- *		0 otherwise
- *
- * It is called only once for each drive.
- */
-static int lba_capacity_is_ok(struct hd_driveid *id)
-{
-	unsigned long lba_sects, chs_sects, head, tail;
-
-	/* No non-LBA info .. so valid! */
-	if (id->cyls == 0)
-		return 1;
-
-	/*
-	 * The ATA spec tells large drives to return
-	 * C/H/S = 16383/16/63 independent of their size.
-	 * Some drives can be jumpered to use 15 heads instead of 16.
-	 * Some drives can be jumpered to use 4092 cyls instead of 16383.
-	 */
-	if ((id->cyls == 16383
-	     || (id->cyls == 4092 && id->cur_cyls == 16383)) &&
-	    id->sectors == 63 &&
-	    (id->heads == 15 || id->heads == 16) &&
-	    (id->lba_capacity >= 16383*63*id->heads))
-		return 1;
-
-	lba_sects   = id->lba_capacity;
-	chs_sects   = id->cyls * id->heads * id->sectors;
-
-	/* perform a rough sanity check on lba_sects:  within 10% is OK */
-	if ((lba_sects - chs_sects) < chs_sects/10)
-		return 1;
-
-	/* some drives have the word order reversed */
-	head = ((lba_sects >> 16) & 0xffff);
-	tail = (lba_sects & 0xffff);
-	lba_sects = (head | (tail << 16));
-	if ((lba_sects - chs_sects) < chs_sects/10) {
-		id->lba_capacity = lba_sects;
-		return 1;	/* lba_capacity is (now) good */
-	}
-
-	return 0;	/* lba_capacity value may be bad */
-}
-
 static const u8 ide_rw_cmds[] = {
-	WIN_MULTREAD,
-	WIN_MULTWRITE,
-	WIN_MULTREAD_EXT,
-	WIN_MULTWRITE_EXT,
-	WIN_READ,
-	WIN_WRITE,
-	WIN_READ_EXT,
-	WIN_WRITE_EXT,
-	WIN_READDMA,
-	WIN_WRITEDMA,
-	WIN_READDMA_EXT,
-	WIN_WRITEDMA_EXT,
+	ATA_CMD_READ_MULTI,
+	ATA_CMD_WRITE_MULTI,
+	ATA_CMD_READ_MULTI_EXT,
+	ATA_CMD_WRITE_MULTI_EXT,
+	ATA_CMD_PIO_READ,
+	ATA_CMD_PIO_WRITE,
+	ATA_CMD_PIO_READ_EXT,
+	ATA_CMD_PIO_WRITE_EXT,
+	ATA_CMD_READ,
+	ATA_CMD_WRITE,
+	ATA_CMD_READ_EXT,
+	ATA_CMD_WRITE_EXT,
 };
 
 static const u8 ide_data_phases[] = {
@@ -322,9 +271,9 @@ static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 	/* Create IDE/ATA command request structure */
 	memset(&args, 0, sizeof(ide_task_t));
 	if (lba48)
-		tf->command = WIN_READ_NATIVE_MAX_EXT;
+		tf->command = ATA_CMD_READ_NATIVE_MAX_EXT;
 	else
-		tf->command = WIN_READ_NATIVE_MAX;
+		tf->command = ATA_CMD_READ_NATIVE_MAX;
 	tf->device  = ATA_LBA;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
@@ -359,10 +308,10 @@ static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 		tf->hob_lbal = (addr_req >>= 8) & 0xff;
 		tf->hob_lbam = (addr_req >>= 8) & 0xff;
 		tf->hob_lbah = (addr_req >>= 8) & 0xff;
-		tf->command  = WIN_SET_MAX_EXT;
+		tf->command  = ATA_CMD_SET_MAX_EXT;
 	} else {
 		tf->device   = (addr_req >>= 8) & 0x0f;
-		tf->command  = WIN_SET_MAX;
+		tf->command  = ATA_CMD_SET_MAX;
 	}
 	tf->device |= ATA_LBA;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
@@ -385,25 +334,6 @@ static unsigned long long sectors_to_MB(unsigned long long n)
 }
 
 /*
- * Bits 10 of command_set_1 and cfs_enable_1 must be equal,
- * so on non-buggy drives we need test only one.
- * However, we should also check whether these fields are valid.
- */
-static inline int idedisk_supports_hpa(const struct hd_driveid *id)
-{
-	return (id->command_set_1 & 0x0400) && (id->cfs_enable_1 & 0x0400);
-}
-
-/*
- * The same here.
- */
-static inline int idedisk_supports_lba48(const struct hd_driveid *id)
-{
-	return (id->command_set_2 & 0x0400) && (id->cfs_enable_2 & 0x0400)
-	       && id->lba_capacity_2;
-}
-
-/*
  * Some disks report total number of sectors instead of
  * maximum sector address.  We list them here.
  */
@@ -417,7 +347,7 @@ static const struct drive_list_entry hpa_list[] = {
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
-	int lba48 = idedisk_supports_lba48(drive->id);
+	int lba48 = ata_id_lba48_enabled(drive->id);
 
 	capacity = drive->capacity64;
 
@@ -453,23 +383,23 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	/*
 	 * If this drive supports the Host Protected Area feature set,
 	 * then we may need to change our opinion about the drive's capacity.
 	 */
-	int hpa = idedisk_supports_hpa(id);
+	int hpa = ata_id_hpa_enabled(id);
 
-	if (idedisk_supports_lba48(id)) {
+	if (ata_id_lba48_enabled(id)) {
 		/* drive speaks 48-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = id->lba_capacity_2;
+		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		if (hpa)
 			idedisk_check_hpa(drive);
-	} else if ((id->capability & 2) && lba_capacity_is_ok(id)) {
+	} else if (ata_id_has_lba(id) && ata_id_is_lba_capacity_ok(id)) {
 		/* drive speaks 28-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = id->lba_capacity;
+		drive->capacity64 = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 		if (hpa)
 			idedisk_check_hpa(drive);
 	} else {
@@ -480,7 +410,7 @@ static void init_idedisk_capacity(ide_drive_t *drive)
 
 static sector_t idedisk_capacity(ide_drive_t *drive)
 {
-	return drive->capacity64 - drive->sect0;
+	return drive->capacity64;
 }
 
 #ifdef CONFIG_IDE_PROC_FS
@@ -490,10 +420,10 @@ static int smart_enable(ide_drive_t *drive)
 	struct ide_taskfile *tf = &args.tf;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = SMART_ENABLE;
-	tf->lbam    = SMART_LCYL_PASS;
-	tf->lbah    = SMART_HCYL_PASS;
-	tf->command = WIN_SMART;
+	tf->feature = ATA_SMART_ENABLE;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	return ide_no_data_taskfile(drive, &args);
 }
@@ -506,9 +436,9 @@ static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 	memset(&args, 0, sizeof(ide_task_t));
 	tf->feature = sub_cmd;
 	tf->nsect   = 0x01;
-	tf->lbam    = SMART_LCYL_PASS;
-	tf->lbah    = SMART_HCYL_PASS;
-	tf->command = WIN_SMART;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
 	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	args.data_phase	= TASKFILE_IN;
 	(void) smart_enable(drive);
@@ -523,7 +453,7 @@ static int proc_idedisk_read_cache
 	int		len;
 
 	if (drive->id_read)
-		len = sprintf(out, "%i\n", drive->id->buf_size / 2);
+		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
 	else
 		len = sprintf(out, "(none)\n");
 
@@ -549,13 +479,14 @@ static int proc_idedisk_read_smart(char *page, char **start, off_t off,
 
 	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
-		char *out = ((char *)val) + (SECTOR_WORDS * 4);
+		char *out = (char *)val + SECTOR_SIZE;
+
 		page = out;
 		do {
 			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
 				       (++i & 7) ? ' ' : '\n');
 			val += 1;
-		} while (i < (SECTOR_WORDS * 2));
+		} while (i < SECTOR_SIZE / 2);
 		len = out - page;
 	}
 
@@ -566,14 +497,14 @@ static int proc_idedisk_read_sv
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       SMART_READ_VALUES);
+				       ATA_SMART_READ_VALUES);
 }
 
 static int proc_idedisk_read_st
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       SMART_READ_THRESHOLDS);
+				       ATA_SMART_READ_THRESHOLDS);
 }
 
 static ide_proc_entry_t idedisk_proc[] = {
@@ -595,11 +526,11 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	BUG_ON(task == NULL);
 
 	memset(task, 0, sizeof(*task));
-	if (ide_id_has_flush_cache_ext(drive->id) &&
+	if (ata_id_flush_ext_enabled(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		task->tf.command = WIN_FLUSH_CACHE_EXT;
+		task->tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		task->tf.command = WIN_FLUSH_CACHE;
+		task->tf.command = ATA_CMD_FLUSH;
 	task->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
 			   IDE_TFLAG_DYN;
 	task->data_phase = TASKFILE_NO_DATA;
@@ -609,6 +540,8 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	rq->special = task;
 }
 
+ide_devset_get(multcount, mult_count);
+
 /*
  * This is tightly woven into the driver->do_special can not touch.
  * DON'T do it again until a total personality rewrite is committed.
@@ -618,7 +551,7 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	struct request *rq;
 	int error;
 
-	if (arg < 0 || arg > drive->id->max_multsect)
+	if (arg < 0 || arg > (drive->id[ATA_ID_MAX_MULTSECT] & 0xff))
 		return -EINVAL;
 
 	if (drive->special.b.set_multmode)
@@ -635,22 +568,21 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
+ide_devset_get(nowerr, nowerr);
+
 static int set_nowerr(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
 	drive->nowerr = arg;
 	drive->bad_wstat = arg ? BAD_R_STAT : BAD_W_STAT;
-	spin_unlock_irq(&ide_lock);
 	return 0;
 }
 
 static void update_ordered(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
 
@@ -666,9 +598,9 @@ static void update_ordered(ide_drive_t *drive)
 		 * not available so we don't need to recheck that.
 		 */
 		capacity = idedisk_capacity(drive);
-		barrier = ide_id_has_flush_cache(id) && !drive->noflush &&
+		barrier = ata_id_flush_enabled(id) && !drive->noflush &&
 			(drive->addressing == 0 || capacity <= (1ULL << 28) ||
-			 ide_id_has_flush_cache_ext(id));
+			 ata_id_flush_ext_enabled(id));
 
 		printk(KERN_INFO "%s: cache flushes %ssupported\n",
 		       drive->name, barrier ? "" : "not ");
@@ -683,7 +615,9 @@ static void update_ordered(ide_drive_t *drive)
 	blk_queue_ordered(drive->queue, ordered, prep_fn);
 }
 
-static int write_cache(ide_drive_t *drive, int arg)
+ide_devset_get(wcache, wcache);
+
+static int set_wcache(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
 	int err = 1;
@@ -691,11 +625,11 @@ static int write_cache(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (ide_id_has_flush_cache(drive->id)) {
+	if (ata_id_flush_enabled(drive->id)) {
 		memset(&args, 0, sizeof(ide_task_t));
 		args.tf.feature = arg ?
-			SETFEATURES_EN_WCACHE : SETFEATURES_DIS_WCACHE;
-		args.tf.command = WIN_SETFEATURES;
+			SETFEATURES_WC_ON : SETFEATURES_WC_OFF;
+		args.tf.command = ATA_CMD_SET_FEATURES;
 		args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 		err = ide_no_data_taskfile(drive, &args);
 		if (err == 0)
@@ -712,14 +646,16 @@ static int do_idedisk_flushcache(ide_drive_t *drive)
 	ide_task_t args;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	if (ide_id_has_flush_cache_ext(drive->id))
-		args.tf.command = WIN_FLUSH_CACHE_EXT;
+	if (ata_id_flush_ext_enabled(drive->id))
+		args.tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		args.tf.command = WIN_FLUSH_CACHE;
+		args.tf.command = ATA_CMD_FLUSH;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	return ide_no_data_taskfile(drive, &args);
 }
 
+ide_devset_get(acoustic, acoustic);
+
 static int set_acoustic(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
@@ -728,22 +664,24 @@ static int set_acoustic(ide_drive_t *drive, int arg)
 		return -EINVAL;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tf.feature = arg ? SETFEATURES_EN_AAM : SETFEATURES_DIS_AAM;
+	args.tf.feature = arg ? SETFEATURES_AAM_ON : SETFEATURES_AAM_OFF;
 	args.tf.nsect   = arg;
-	args.tf.command = WIN_SETFEATURES;
+	args.tf.command = ATA_CMD_SET_FEATURES;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	ide_no_data_taskfile(drive, &args);
 	drive->acoustic = arg;
 	return 0;
 }
 
+ide_devset_get(addressing, addressing);
+
 /*
  * drive->addressing:
  *	0: 28-bit
  *	1: 48-bit
  *	2: 48-bit capable doing 28-bit
  */
-static int set_lba_addressing(ide_drive_t *drive, int arg)
+static int set_addressing(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 2)
 		return -EINVAL;
@@ -753,52 +691,54 @@ static int set_lba_addressing(ide_drive_t *drive, int arg)
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_LBA48)
 		return 0;
 
-	if (!idedisk_supports_lba48(drive->id))
+	if (ata_id_lba48_enabled(drive->id) == 0)
 		return -EIO;
+
 	drive->addressing = arg;
+
 	return 0;
 }
 
+ide_devset_rw(acoustic, acoustic);
+ide_devset_rw(address, addressing);
+ide_devset_rw(multcount, multcount);
+ide_devset_rw(wcache, wcache);
+
+ide_devset_rw_sync(nowerr, nowerr);
+
 #ifdef CONFIG_IDE_PROC_FS
-static void idedisk_add_settings(ide_drive_t *drive)
-{
-	struct hd_driveid *id = drive->id;
-
-	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
-			&drive->bios_cyl, NULL);
-	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&drive->bios_head, NULL);
-	ide_add_setting(drive, "bios_sect", SETTING_RW, TYPE_BYTE, 0, 63, 1, 1,
-			&drive->bios_sect, NULL);
-	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
-			&drive->addressing, set_lba_addressing);
-	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
-			id->max_multsect, 1, 1, &drive->mult_count,
-			set_multcount);
-	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->nowerr, set_nowerr);
-	ide_add_setting(drive, "lun", SETTING_RW, TYPE_INT, 0, 7, 1, 1,
-			&drive->lun, NULL);
-	ide_add_setting(drive, "wcache", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->wcache, write_cache);
-	ide_add_setting(drive, "acoustic", SETTING_RW, TYPE_BYTE, 0, 254, 1, 1,
-			&drive->acoustic, set_acoustic);
-	ide_add_setting(drive, "failures", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
-			&drive->failures, NULL);
-	ide_add_setting(drive, "max_failures", SETTING_RW, TYPE_INT, 0, 65535,
-			1, 1, &drive->max_failures, NULL);
-}
-#else
-static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+ide_devset_rw_field(failures, failures);
+ide_devset_rw_field(lun, lun);
+ide_devset_rw_field(max_failures, max_failures);
+
+static const struct ide_proc_devset idedisk_settings[] = {
+	IDE_PROC_DEVSET(acoustic,	0,   254),
+	IDE_PROC_DEVSET(address,	0,     2),
+	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
+	IDE_PROC_DEVSET(bios_head,	0,   255),
+	IDE_PROC_DEVSET(bios_sect,	0,    63),
+	IDE_PROC_DEVSET(failures,	0, 65535),
+	IDE_PROC_DEVSET(lun,		0,     7),
+	IDE_PROC_DEVSET(max_failures,	0, 65535),
+	IDE_PROC_DEVSET(multcount,	0,    16),
+	IDE_PROC_DEVSET(nowerr,		0,     1),
+	IDE_PROC_DEVSET(wcache,		0,     1),
+	{ 0 },
+};
 #endif
 
 static void idedisk_setup(ide_drive_t *drive)
 {
+	struct ide_disk_obj *idkp = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
+	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long long capacity;
 
-	idedisk_add_settings(drive);
+	ide_proc_register_driver(drive, idkp->driver);
 
 	if (drive->id_read == 0)
 		return;
@@ -807,11 +747,11 @@ static void idedisk_setup(ide_drive_t *drive)
 		/*
 		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
-		if (id->model[0] != 'W' || id->model[1] != 'D')
+		if (m[0] != 'W' || m[1] != 'D')
 			drive->doorlocking = 1;
 	}
 
-	(void)set_lba_addressing(drive, 1);
+	(void)set_addressing(drive, 1);
 
 	if (drive->addressing == 1) {
 		int max_s = 2048;
@@ -853,8 +793,7 @@ static void idedisk_setup(ide_drive_t *drive)
 	capacity = idedisk_capacity(drive);
 
 	if (!drive->forced_geom) {
-
-		if (idedisk_supports_lba48(drive->id)) {
+		if (ata_id_lba48_enabled(drive->id)) {
 			/* compatibility */
 			drive->bios_sect = 63;
 			drive->bios_head = 255;
@@ -880,22 +819,22 @@ static void idedisk_setup(ide_drive_t *drive)
 			 drive->name, capacity, sectors_to_MB(capacity));
 
 	/* Only print cache size when it was specified */
-	if (id->buf_size)
-		printk(KERN_CONT " w/%dKiB Cache", id->buf_size / 2);
+	if (id[ATA_ID_BUF_SIZE])
+		printk(KERN_CONT " w/%dKiB Cache", id[ATA_ID_BUF_SIZE] / 2);
 
 	printk(KERN_CONT ", CHS=%d/%d/%d\n",
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
-	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))
+	if ((id[ATA_ID_CSFO] & 1) || ata_id_wcache_enabled(id))
 		drive->wcache = 1;
 
-	write_cache(drive, 1);
+	set_wcache(drive, 1);
 }
 
 static void ide_cacheflush_p(ide_drive_t *drive)
 {
-	if (!drive->wcache || !ide_id_has_flush_cache(drive->id))
+	if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0)
 		return;
 
 	if (do_idedisk_flushcache(drive))
@@ -937,7 +876,7 @@ static int ide_disk_probe(ide_drive_t *drive);
  */
 static void ide_disk_resume(ide_drive_t *drive)
 {
-	if (idedisk_supports_hpa(drive->id))
+	if (ata_id_hpa_enabled(drive->id))
 		init_idedisk_capacity(drive);
 }
 
@@ -980,12 +919,12 @@ static ide_driver_t idedisk_driver = {
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
 	.media			= ide_disk,
-	.supports_dsc_overlap	= 0,
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idedisk_proc,
+	.settings		= idedisk_settings,
 #endif
 };
 
@@ -994,7 +933,7 @@ static int idedisk_set_doorlock(ide_drive_t *drive, int on)
 	ide_task_t task;
 
 	memset(&task, 0, sizeof(task));
-	task.tf.command = on ? WIN_DOORLOCK : WIN_DOORUNLOCK;
+	task.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	return ide_no_data_taskfile(drive, &task);
@@ -1059,52 +998,28 @@ static int idedisk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
+{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
+{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
+{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    &ide_devset_nowerr	  },
+{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    &ide_devset_wcache	  },
+{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  &ide_devset_acoustic  },
+{ 0 }
+};
+
 static int idedisk_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	unsigned long flags;
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
 	ide_drive_t *drive = idkp->drive;
-	int err, (*setfunc)(ide_drive_t *, int);
-	u8 *val;
-
-	switch (cmd) {
-	case HDIO_GET_ADDRESS:	 val = &drive->addressing;	goto read_val;
-	case HDIO_GET_MULTCOUNT: val = &drive->mult_count;	goto read_val;
-	case HDIO_GET_NOWERR:	 val = &drive->nowerr;		goto read_val;
-	case HDIO_GET_WCACHE:	 val = &drive->wcache;		goto read_val;
-	case HDIO_GET_ACOUSTIC:	 val = &drive->acoustic;	goto read_val;
-	case HDIO_SET_ADDRESS:	 setfunc = set_lba_addressing;	goto set_val;
-	case HDIO_SET_MULTCOUNT: setfunc = set_multcount;	goto set_val;
-	case HDIO_SET_NOWERR:	 setfunc = set_nowerr;		goto set_val;
-	case HDIO_SET_WCACHE:	 setfunc = write_cache;		goto set_val;
-	case HDIO_SET_ACOUSTIC:	 setfunc = set_acoustic;	goto set_val;
-	}
+	int err;
 
-	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
 
-read_val:
-	mutex_lock(&ide_setting_mtx);
-	spin_lock_irqsave(&ide_lock, flags);
-	err = *val;
-	spin_unlock_irqrestore(&ide_lock, flags);
-	mutex_unlock(&ide_setting_mtx);
-	return err >= 0 ? put_user(err, (long __user *)arg) : err;
-
-set_val:
-	if (bdev != bdev->bd_contains)
-		err = -EINVAL;
-	else {
-		if (!capable(CAP_SYS_ADMIN))
-			err = -EACCES;
-		else {
-			mutex_lock(&ide_setting_mtx);
-			err = setfunc(drive, arg);
-			mutex_unlock(&ide_setting_mtx);
-		}
-	}
-	return err;
+	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
 }
 
 static int idedisk_media_changed(struct gendisk *disk)
@@ -1148,8 +1063,7 @@ static int ide_disk_probe(ide_drive_t *drive)
 	/* strstr("foo", "") is non-NULL */
 	if (!strstr("ide-disk", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_disk)
 		goto failed;
 
@@ -1163,8 +1077,6 @@ static int ide_disk_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idedisk_driver);
-
 	kref_init(&idkp->kref);
 
 	idkp->drive = drive;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 3fa07c0..ef2f150 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -106,7 +106,7 @@ ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 	dma_stat = hwif->dma_ops->dma_end(drive);
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
+	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
 			struct request *rq = HWGROUP(drive)->rq;
 
@@ -288,7 +288,7 @@ EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 static int config_drive_for_dma (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	if (drive->media != ide_disk) {
 		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
@@ -299,16 +299,17 @@ static int config_drive_for_dma (ide_drive_t *drive)
 	 * Enable DMA on any drive that has
 	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
 	 */
-	if ((id->field_valid & 4) && ((id->dma_ultra >> 8) & 0x7f))
+	if ((id[ATA_ID_FIELD_VALID] & 4) &&
+	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
 		return 1;
 
 	/*
 	 * Enable DMA on any drive that has mode2 DMA
 	 * (multi or single) enabled
 	 */
-	if (id->field_valid & 2)	/* regular DMA */
-		if ((id->dma_mword & 0x404) == 0x404 ||
-		    (id->dma_1word & 0x404) == 0x404)
+	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
+		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
+		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
 			return 1;
 
 	/* Consult the list of known "good" drives */
@@ -591,12 +592,12 @@ static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 
 int __ide_dma_bad_drive (ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	int blacklist = ide_in_drive_list(id, drive_blacklist);
 	if (blacklist) {
 		printk(KERN_WARNING "%s: Disabling (U)DMA for %s (blacklisted)\n",
-				    drive->name, id->model);
+				    drive->name, (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
 	return 0;
@@ -612,21 +613,21 @@ static const u8 xfer_mode_bases[] = {
 
 static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
 	switch(base) {
 	case XFER_UDMA_0:
-		if ((id->field_valid & 4) == 0)
+		if ((id[ATA_ID_FIELD_VALID] & 4) == 0)
 			break;
 
 		if (port_ops && port_ops->udma_filter)
 			mask = port_ops->udma_filter(drive);
 		else
 			mask = hwif->ultra_mask;
-		mask &= id->dma_ultra;
+		mask &= id[ATA_ID_UDMA_MODES];
 
 		/*
 		 * avoid false cable warning from eighty_ninty_three()
@@ -637,19 +638,19 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 		}
 		break;
 	case XFER_MW_DMA_0:
-		if ((id->field_valid & 2) == 0)
+		if ((id[ATA_ID_FIELD_VALID] & 2) == 0)
 			break;
 		if (port_ops && port_ops->mdma_filter)
 			mask = port_ops->mdma_filter(drive);
 		else
 			mask = hwif->mwdma_mask;
-		mask &= id->dma_mword;
+		mask &= id[ATA_ID_MWDMA_MODES];
 		break;
 	case XFER_SW_DMA_0:
-		if (id->field_valid & 2) {
-			mask = id->dma_1word & hwif->swdma_mask;
-		} else if (id->tDMA) {
-			u8 mode = id->tDMA;
+		if (id[ATA_ID_FIELD_VALID] & 2) {
+			mask = id[ATA_ID_SWDMA_MODES] & hwif->swdma_mask;
+		} else if (id[ATA_ID_OLD_DMA_MODES] >> 8) {
+			u8 mode = id[ATA_ID_OLD_DMA_MODES] >> 8;
 
 			/*
 			 * if the mode is valid convert it to the mask
@@ -706,7 +707,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 		/*
 		 * is this correct?
 		 */
-		if (ide_dma_good_drive(drive) && drive->id->eide_dma_time < 150)
+		if (ide_dma_good_drive(drive) &&
+		    drive->id[ATA_ID_EIDE_DMA_TIME] < 150)
 			mode = XFER_MW_DMA_1;
 	}
 
@@ -725,7 +727,7 @@ static int ide_tune_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (drive->nodma || (drive->id->capability & 1) == 0)
+	if (drive->nodma || ata_id_has_dma(drive->id) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
@@ -767,13 +769,15 @@ static int ide_dma_check(ide_drive_t *drive)
 
 int ide_id_dma_bug(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
-	if (id->field_valid & 4) {
-		if ((id->dma_ultra >> 8) && (id->dma_mword >> 8))
+	if (id[ATA_ID_FIELD_VALID] & 4) {
+		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
+		    (id[ATA_ID_MWDMA_MODES] >> 8))
 			goto err_out;
-	} else if (id->field_valid & 2) {
-		if ((id->dma_mword >> 8) && (id->dma_1word >> 8))
+	} else if (id[ATA_ID_FIELD_VALID] & 2) {
+		if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
+		    (id[ATA_ID_SWDMA_MODES] >> 8))
 			goto err_out;
 	}
 	return 0;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index e9034c0..d36f155 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -15,6 +15,8 @@
  * Documentation/ide/ChangeLog.ide-floppy.1996-2002
  */
 
+#define DRV_NAME "ide-floppy"
+
 #define IDEFLOPPY_VERSION "1.00"
 
 #include <linux/module.h>
@@ -31,8 +33,10 @@
 #include <linux/slab.h>
 #include <linux/cdrom.h>
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi_ioctl.h>
 
@@ -42,6 +46,8 @@
 #include <linux/io.h>
 #include <asm/unaligned.h>
 
+#include "ide-floppy.h"
+
 /* define to see debug info */
 #define IDEFLOPPY_DEBUG_LOG		0
 
@@ -55,102 +61,23 @@
 #define debug_log(fmt, args...) do {} while (0)
 #endif
 
-
-/* Some drives require a longer irq timeout. */
-#define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
-
 /*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDEFLOPPY_MAX_PC_RETRIES times.
  */
 #define IDEFLOPPY_MAX_PC_RETRIES	3
 
-/*
- * With each packet command, we allocate a buffer of IDEFLOPPY_PC_BUFFER_SIZE
- * bytes.
- */
-#define IDEFLOPPY_PC_BUFFER_SIZE	256
-
-/*
- * In various places in the driver, we need to allocate storage for packet
- * commands and requests, which will remain valid while	we leave the driver to
- * wait for an interrupt or a timeout event.
- */
-#define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
 #define CAPACITY_CURRENT	0x02
 #define CAPACITY_NO_CARTRIDGE	0x03
 
-/*
- * Most of our global data which we need to save even as we leave the driver
- * due to an interrupt or a timer event is stored in a variable of type
- * idefloppy_floppy_t, defined below.
- */
-typedef struct ide_floppy_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
-	/* Packet command stack */
-	struct ide_atapi_pc pc_stack[IDEFLOPPY_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
-	struct request rq_stack[IDEFLOPPY_PC_STACK];
-	/* We implement a circular array */
-	int rq_stack_index;
-
-	/* Last error information */
-	u8 sense_key, asc, ascq;
-	/* delay this long before sending packet command */
-	u8 ticks;
-	int progress_indication;
-
-	/* Device information */
-	/* Current format */
-	int blocks, block_size, bs_factor;
-	/* Last format capacity descriptor */
-	u8 cap_desc[8];
-	/* Copy of the flexible disk page */
-	u8 flexible_disk_page[32];
-	/* Write protect */
-	int wp;
-	/* Supports format progress report */
-	int srfp;
-} idefloppy_floppy_t;
-
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/* Defines for the MODE SENSE command */
-#define MODE_SENSE_CURRENT		0x00
-#define MODE_SENSE_CHANGEABLE		0x01
-#define MODE_SENSE_DEFAULT		0x02
-#define MODE_SENSE_SAVED		0x03
-
-/* IOCTLs used in low-level formatting. */
-#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
-#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
-#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
-#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
-
 /* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
-/*
- * Pages of the SELECT SENSE / MODE SENSE packet commands.
- * See SFF-8070i spec.
- */
-#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
-#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
-
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
 #define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
@@ -219,44 +146,6 @@ static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  unsigned int bcount, int direction)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = pc->rq;
-	struct req_iterator iter;
-	struct bio_vec *bvec;
-	unsigned long flags;
-	int count, done = 0;
-	char *data;
-
-	rq_for_each_segment(bvec, rq, iter) {
-		if (!bcount)
-			break;
-
-		count = min(bvec->bv_len, bcount);
-
-		data = bvec_kmap_irq(bvec, &flags);
-		if (direction)
-			hwif->tp_ops->output_data(drive, NULL, data, count);
-		else
-			hwif->tp_ops->input_data(drive, NULL, data, count);
-		bvec_kunmap_irq(data, &flags);
-
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-	}
-
-	idefloppy_end_request(drive, 1, done >> 9);
-
-	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
-				drive->name, __func__, bcount);
-		ide_pad_transfer(drive, direction, bcount);
-	}
-}
-
 static void idefloppy_update_buffers(ide_drive_t *drive,
 				struct ide_atapi_pc *pc)
 {
@@ -267,43 +156,6 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
 		idefloppy_end_request(drive, 1, 0);
 }
 
-/*
- * Generate a new packet command request in front of the request queue, before
- * the current request so that it will be processed immediately, on the next
- * pass through the driver.
- */
-static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		struct request *rq)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-
-	blk_rq_init(NULL, rq);
-	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->rq_disk = floppy->disk;
-	memcpy(rq->cmd, pc->c, 12);
-	ide_do_drive_cmd(drive, rq);
-}
-
-static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	if (floppy->pc_stack_index == IDEFLOPPY_PC_STACK)
-		floppy->pc_stack_index = 0;
-	return (&floppy->pc_stack[floppy->pc_stack_index++]);
-}
-
-static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	if (floppy->rq_stack_index == IDEFLOPPY_PC_STACK)
-		floppy->rq_stack_index = 0;
-	return (&floppy->rq_stack[floppy->rq_stack_index++]);
-}
-
 static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -341,16 +193,9 @@ static void ide_floppy_callback(ide_drive_t *drive)
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-static void idefloppy_init_pc(struct ide_atapi_pc *pc)
-{
-	memset(pc, 0, sizeof(*pc));
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-}
-
-static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
+void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->req_xfer = 18;
@@ -362,14 +207,13 @@ static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
  */
 static void idefloppy_retry_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *pc;
-	struct request *rq;
+	struct ide_floppy_obj *floppy = drive->driver_data;
+	struct request *rq = &floppy->request_sense_rq;
+	struct ide_atapi_pc *pc = &floppy->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	pc = idefloppy_next_pc_storage(drive);
-	rq = idefloppy_next_rq_storage(drive);
-	idefloppy_create_request_sense_cmd(pc);
-	idefloppy_queue_pc_head(drive, pc, rq);
+	ide_floppy_create_request_sense_cmd(pc);
+	ide_queue_pc_head(drive, floppy->disk, pc, rq);
 }
 
 /* The usual interrupt handler called during a packet command. */
@@ -378,8 +222,8 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
-			   IDEFLOPPY_WAIT_CMD, NULL, idefloppy_update_buffers,
-			   idefloppy_retry_pc, NULL, ide_floppy_io_buffers);
+			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
+			   idefloppy_retry_pc, NULL, ide_io_buffers);
 }
 
 /*
@@ -396,10 +240,9 @@ static int idefloppy_transfer_pc(ide_drive_t *drive)
 	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
 
 	/* Timeout for the packet command */
-	return IDEFLOPPY_WAIT_CMD;
+	return WAIT_FLOPPY_CMD;
 }
 
-
 /*
  * Called as an interrupt (or directly). When the device says it's ready for a
  * packet, we schedule the packet transfer to occur about 2-3 ticks later in
@@ -424,7 +267,7 @@ static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 		timeout = floppy->ticks;
 		expiry = &idefloppy_transfer_pc;
 	} else {
-		timeout = IDEFLOPPY_WAIT_CMD;
+		timeout = WAIT_FLOPPY_CMD;
 		expiry = NULL;
 	}
 
@@ -474,58 +317,27 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	pc->retries++;
 
 	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
-			    IDEFLOPPY_WAIT_CMD, NULL);
-}
-
-static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
-{
-	debug_log("creating prevent removal command, prevent = %d\n", prevent);
-
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
-	pc->c[4] = prevent;
+			    WAIT_FLOPPY_CMD, NULL);
 }
 
-static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
+void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
 	pc->req_xfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
-{
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_FORMAT_UNIT;
-	pc->c[1] = 0x17;
-
-	memset(pc->buf, 0, 12);
-	pc->buf[1] = 0xA2;
-	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
-
-	if (flags & 1)				/* Verify bit on... */
-		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buf[3] = 8;
-
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
-	pc->buf_size = 12;
-	pc->flags |= PC_FLAG_WRITING;
-}
-
 /* A mode sense command is used to "sense" floppy parameters. */
-static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
-		u8 page_code, u8 type)
+void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
-	pc->c[2] = page_code + (type << 6);
+	pc->c[2] = page_code;
 
 	switch (page_code) {
 	case IDEFLOPPY_CAPABILITIES_PAGE:
@@ -542,13 +354,6 @@ static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
 	pc->req_xfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
-{
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_START_STOP_UNIT;
-	pc->c[4] = start;
-}
-
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
@@ -560,7 +365,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
 		block, blocks);
 
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
@@ -568,7 +373,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	memcpy(rq->cmd, pc->c, 12);
 
 	pc->rq = rq;
-	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
+	pc->b_count = 0;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
@@ -579,10 +384,10 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	pc->b_count = rq->data_len;
+	pc->b_count = 0;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
@@ -599,15 +404,17 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		struct request *rq, sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log("dev: %s, cmd_type: %x, errors: %d\n",
-			rq->rq_disk ? rq->rq_disk->disk_name : "?",
-			rq->cmd_type, rq->errors);
-	debug_log("sector: %ld, nr_sectors: %ld, "
-			"current_nr_sectors: %d\n", (long)rq->sector,
-			rq->nr_sectors, rq->current_nr_sectors);
+	debug_log("%s: dev: %s, cmd: 0x%x, cmd_type: %x, errors: %d\n",
+		  __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		  rq->cmd[0], rq->cmd_type, rq->errors);
+
+	debug_log("%s: sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",
+		  __func__, (long)rq->sector, rq->nr_sectors,
+		  rq->current_nr_sectors);
 
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc)
@@ -626,12 +433,12 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
-		pc = idefloppy_next_pc_storage(drive);
+		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
 	} else if (blk_special_request(rq)) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
-		pc = idefloppy_next_pc_storage(drive);
+		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq,
@@ -640,29 +447,15 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	pc->rq = rq;
+	ide_init_sg_cmd(drive, rq);
+	ide_map_sg(drive, rq);
 
-	return idefloppy_issue_pc(drive, pc);
-}
+	pc->sg = hwif->sg_table;
+	pc->sg_cnt = hwif->sg_nents;
 
-/*
- * Add a special packet command request to the tail of the request queue,
- * and wait for it to be serviced.
- */
-static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request *rq;
-	int error;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	memcpy(rq->cmd, pc->c, 12);
-	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
-	blk_put_request(rq);
+	pc->rq = rq;
 
-	return error;
+	return idefloppy_issue_pc(drive, pc);
 }
 
 /*
@@ -672,22 +465,28 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *page;
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
-					MODE_SENSE_CURRENT);
+	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
 				" parameters\n");
 		return 1;
 	}
-	floppy->wp = !!(pc.buf[3] & 0x80);
-	set_disk_ro(floppy->disk, floppy->wp);
+
+	if (pc.buf[3] & 0x80)
+		drive->atapi_flags |= IDE_AFLAG_WP;
+	else
+		drive->atapi_flags &= ~IDE_AFLAG_WP;
+
+	set_disk_ro(disk, !!(drive->atapi_flags & IDE_AFLAG_WP));
+
 	page = &pc.buf[8];
 
 	transfer_rate = be16_to_cpup((__be16 *)&pc.buf[8 + 2]);
@@ -721,23 +520,6 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	return 0;
 }
 
-static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-
-	floppy->srfp = 0;
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
-						 MODE_SENSE_CURRENT);
-
-	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
-	if (idefloppy_queue_pc_tail(drive, &pc))
-		return 1;
-
-	floppy->srfp = pc.buf[8 + 2] & 0x40;
-	return (0);
-}
-
 /*
  * Determine if a media is present in the floppy drive, and if so, its LBA
  * capacity.
@@ -745,6 +527,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *cap_desc;
 	u8 header_len, desc_cnt;
@@ -756,8 +539,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	floppy->bs_factor = 1;
 	set_capacity(floppy->disk, 0);
 
-	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	ide_floppy_create_read_capacity_cmd(&pc);
+	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
@@ -832,202 +615,55 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
-	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
+	set_capacity(disk, floppy->blocks * floppy->bs_factor);
+
 	return rc;
 }
 
-/*
- * Obtain the list of formattable capacities.
- * Very similar to ide_floppy_get_capacity, except that we push the capacity
- * descriptors to userland, instead of our own structures.
- *
- * Userland gives us the following structure:
- *
- * struct idefloppy_format_capacities {
- *	int nformats;
- *	struct {
- *		int nblocks;
- *		int blocksize;
- *	} formats[];
- * };
- *
- * userland initializes nformats to the number of allocated formats[] records.
- * On exit we set nformats to the number of records we've actually initialized.
- */
-
-static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+static sector_t idefloppy_capacity(ide_drive_t *drive)
 {
-	struct ide_atapi_pc pc;
-	u8 header_len, desc_cnt;
-	int i, blocks, length, u_array_size, u_index;
-	int __user *argp;
-
-	if (get_user(u_array_size, arg))
-		return (-EFAULT);
-
-	if (u_array_size <= 0)
-		return (-EINVAL);
-
-	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-		return (-EIO);
-	}
-	header_len = pc.buf[3];
-	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
-
-	u_index = 0;
-	argp = arg + 1;
-
-	/*
-	 * We always skip the first capacity descriptor.  That's the current
-	 * capacity.  We are interested in the remaining descriptors, the
-	 * formattable capacities.
-	 */
-	for (i = 1; i < desc_cnt; i++) {
-		unsigned int desc_start = 4 + i*8;
-
-		if (u_index >= u_array_size)
-			break;	/* User-supplied buffer too small */
-
-		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
-
-		if (put_user(blocks, argp))
-			return(-EFAULT);
-		++argp;
-
-		if (put_user(length, argp))
-			return (-EFAULT);
-		++argp;
-
-		++u_index;
-	}
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	unsigned long capacity = floppy->blocks * floppy->bs_factor;
 
-	if (put_user(u_index, arg))
-		return (-EFAULT);
-	return (0);
+	return capacity;
 }
 
-/*
- * Get ATAPI_FORMAT_UNIT progress indication.
- *
- * Userland gives a pointer to an int.  The int is set to a progress
- * indicator 0-65536, with 65536=100%.
- *
- * If the drive does not support format progress indication, we just check
- * the dsc bit, and return either 0 or 65536.
- */
+#ifdef CONFIG_IDE_PROC_FS
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
 
-static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
+static int get_ticks(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-	int progress_indication = 0x10000;
-
-	if (floppy->srfp) {
-		idefloppy_create_request_sense_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc))
-			return (-EIO);
-
-		if (floppy->sense_key == 2 &&
-		    floppy->asc == 4 &&
-		    floppy->ascq == 4)
-			progress_indication = floppy->progress_indication;
-
-		/* Else assume format_unit has finished, and we're at 0x10000 */
-	} else {
-		ide_hwif_t *hwif = drive->hwif;
-		unsigned long flags;
-		u8 stat;
-
-		local_irq_save(flags);
-		stat = hwif->tp_ops->read_status(hwif);
-		local_irq_restore(flags);
-
-		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
-	}
-	if (put_user(progress_indication, arg))
-		return (-EFAULT);
-
-	return (0);
+	return floppy->ticks;
 }
 
-static sector_t idefloppy_capacity(ide_drive_t *drive)
+static int set_ticks(ide_drive_t *drive, int arg)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	unsigned long capacity = floppy->blocks * floppy->bs_factor;
-
-	return capacity;
-}
-
-/*
- * Check whether we can support a drive, based on the ATAPI IDENTIFY command
- * results.
- */
-static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
-{
-	u8 gcw[2];
-	u8 device_type, protocol, removable, drq_type, packet_size;
-
-	*((u16 *) &gcw) = id->config;
-
-	device_type =  gcw[1] & 0x1F;
-	removable   = (gcw[0] & 0x80) >> 7;
-	protocol    = (gcw[1] & 0xC0) >> 6;
-	drq_type    = (gcw[0] & 0x60) >> 5;
-	packet_size =  gcw[0] & 0x03;
-
-#ifdef CONFIG_PPC
-	/* kludge for Apple PowerBook internal zip */
-	if (device_type == 5 &&
-	    !strstr(id->model, "CD-ROM") && strstr(id->model, "ZIP"))
-		device_type = 0;
-#endif
-
-	if (protocol != 2)
-		printk(KERN_ERR "ide-floppy: Protocol (0x%02x) is not ATAPI\n",
-			protocol);
-	else if (device_type != 0)
-		printk(KERN_ERR "ide-floppy: Device type (0x%02x) is not set "
-				"to floppy\n", device_type);
-	else if (!removable)
-		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
-	else if (drq_type == 3)
-		printk(KERN_ERR "ide-floppy: Sorry, DRQ type (0x%02x) not "
-				"supported\n", drq_type);
-	else if (packet_size != 0)
-		printk(KERN_ERR "ide-floppy: Packet size (0x%02x) is not 12 "
-				"bytes\n", packet_size);
-	else
-		return 1;
+	floppy->ticks = arg;
 	return 0;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static void idefloppy_add_settings(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
+IDE_DEVSET(ticks, DS_SYNC, get_ticks, set_ticks);
 
-	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 1023, 1, 1,
-			&drive->bios_cyl, NULL);
-	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&drive->bios_head, NULL);
-	ide_add_setting(drive, "bios_sect", SETTING_RW,	TYPE_BYTE, 0,  63, 1, 1,
-			&drive->bios_sect, NULL);
-	ide_add_setting(drive, "ticks",	   SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&floppy->ticks,	 NULL);
-}
-#else
-static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
+static const struct ide_proc_devset idefloppy_settings[] = {
+	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
+	IDE_PROC_DEVSET(bios_head, 0,  255),
+	IDE_PROC_DEVSET(bios_sect, 0,   63),
+	IDE_PROC_DEVSET(ticks,	   0,  255),
+	{ 0 },
+};
 #endif
 
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
+	u16 *id = drive->id;
 	u8 gcw[2];
 
-	*((u16 *) &gcw) = drive->id->config;
-	floppy->pc = floppy->pc_stack;
+	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
+
 	drive->pc_callback = ide_floppy_callback;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
@@ -1041,7 +677,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 * it. It should be fixed as of version 1.9, but to be on the safe side
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
-	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
+	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
@@ -1052,13 +688,16 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
 	 * nasty clicking noises without it, so please don't remove this.
 	 */
-	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
+	if (strncmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
+		/* IOMEGA Clik! drives do not support lock/unlock commands */
+		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
 	}
 
 	(void) ide_floppy_get_capacity(drive);
-	idefloppy_add_settings(drive);
+
+	ide_proc_register_driver(drive, floppy->driver);
 }
 
 static void ide_floppy_remove(ide_drive_t *drive)
@@ -1115,12 +754,12 @@ static ide_driver_t idefloppy_driver = {
 	.remove			= ide_floppy_remove,
 	.version		= IDEFLOPPY_VERSION,
 	.media			= ide_floppy,
-	.supports_dsc_overlap	= 0,
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idefloppy_proc,
+	.settings		= idefloppy_settings,
 #endif
 };
 
@@ -1129,7 +768,6 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy;
 	ide_drive_t *drive;
-	struct ide_atapi_pc pc;
 	int ret = 0;
 
 	debug_log("Reached %s\n", __func__);
@@ -1146,13 +784,8 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
-		idefloppy_init_pc(&pc);
-		pc.c[0] = GPCMD_TEST_UNIT_READY;
-
-		if (idefloppy_queue_pc_tail(drive, &pc)) {
-			idefloppy_create_start_stop_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
+		if (ide_do_test_unit_ready(drive, disk))
+			ide_do_start_stop(drive, disk, 1);
 
 		if (ide_floppy_get_capacity(drive)
 		   && (filp->f_flags & O_NDELAY) == 0
@@ -1166,16 +799,13 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			goto out_put_floppy;
 		}
 
-		if (floppy->wp && (filp->f_mode & 2)) {
+		if ((drive->atapi_flags & IDE_AFLAG_WP) && (filp->f_mode & 2)) {
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
+
 		drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
-		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
+		ide_set_media_lock(drive, disk, 1);
 		check_disk_change(inode->i_bdev);
 	} else if (drive->atapi_flags & IDE_AFLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
@@ -1194,17 +824,11 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
-	struct ide_atapi_pc pc;
 
 	debug_log("Reached %s\n", __func__);
 
 	if (floppy->openers == 1) {
-		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 0);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-
+		ide_set_media_lock(drive, disk, 0);
 		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 	}
 
@@ -1230,80 +854,20 @@ static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			       unsigned long arg, unsigned int cmd)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
+	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
 
 	if (floppy->openers > 1)
 		return -EBUSY;
 
-	/* The IOMEGA Clik! Drive doesn't support this command -
-	 * no room for an eject mechanism */
-	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-		int prevent = arg ? 1 : 0;
-
-		if (cmd == CDROMEJECT)
-			prevent = 0;
+	ide_set_media_lock(drive, disk, prevent);
 
-		idefloppy_create_prevent_cmd(pc, prevent);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
-	}
-
-	if (cmd == CDROMEJECT) {
-		idefloppy_create_start_stop_cmd(pc, 2);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
-	}
+	if (cmd == CDROMEJECT)
+		ide_do_start_stop(drive, disk, 2);
 
 	return 0;
 }
 
-static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
-				  int __user *arg)
-{
-	struct ide_atapi_pc pc;
-	ide_drive_t *drive = floppy->drive;
-	int blocks, length, flags, err = 0;
-
-	if (floppy->openers > 1) {
-		/* Don't format if someone is using the disk */
-		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
-		return -EBUSY;
-	}
-
-	drive->atapi_flags |= IDE_AFLAG_FORMAT_IN_PROGRESS;
-
-	/*
-	 * Send ATAPI_FORMAT_UNIT to the drive.
-	 *
-	 * Userland gives us the following structure:
-	 *
-	 * struct idefloppy_format_command {
-	 *        int nblocks;
-	 *        int blocksize;
-	 *        int flags;
-	 *        } ;
-	 *
-	 * flags is a bitmask, currently, the only defined flag is:
-	 *
-	 *        0x01 - verify media after format.
-	 */
-	if (get_user(blocks, arg) ||
-			get_user(length, arg+1) ||
-			get_user(flags, arg+2)) {
-		err = -EFAULT;
-		goto out;
-	}
-
-	(void) idefloppy_get_sfrp_bit(drive);
-	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
-
-	if (idefloppy_queue_pc_tail(drive, &pc))
-		err = -EIO;
-
-out:
-	if (err)
-		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
-	return err;
-}
-
-
 static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -1314,23 +878,12 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	void __user *argp = (void __user *)arg;
 	int err;
 
-	switch (cmd) {
-	case CDROMEJECT:
-		/* fall through */
-	case CDROM_LOCKDOOR:
+	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
 		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
-	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
-		return 0;
-	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
-		return ide_floppy_get_format_capacities(drive, argp);
-	case IDEFLOPPY_IOCTL_FORMAT_START:
-		if (!(file->f_mode & 2))
-			return -EPERM;
-
-		return ide_floppy_format_unit(floppy, (int __user *)arg);
-	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
-		return idefloppy_get_format_progress(drive, argp);
-	}
+
+	err = ide_floppy_format_ioctl(drive, file, cmd, argp);
+	if (err != -ENOTTY)
+		return err;
 
 	/*
 	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
@@ -1339,8 +892,6 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
 		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
 					bdev->bd_disk, cmd, argp);
-	else
-		err = -ENOTTY;
 
 	if (err == -ENOTTY)
 		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
@@ -1388,11 +939,11 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	if (!strstr("ide-floppy", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_floppy)
 		goto failed;
-	if (!idefloppy_identify_device(drive, drive->id)) {
+
+	if (!ide_check_atapi_device(drive, DRV_NAME)) {
 		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
 				" of ide-floppy\n", drive->name);
 		goto failed;
@@ -1410,8 +961,6 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idefloppy_driver);
-
 	kref_init(&floppy->kref);
 
 	floppy->drive = drive;
@@ -1450,6 +999,7 @@ static int __init idefloppy_init(void)
 }
 
 MODULE_ALIAS("ide:*m-floppy*");
+MODULE_ALIAS("ide-floppy");
 module_init(idefloppy_init);
 module_exit(idefloppy_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
new file mode 100644
index 0000000..ecadc2b
--- /dev/null
+++ b/drivers/ide/ide-floppy.h
@@ -0,0 +1,63 @@
+#ifndef __IDE_FLOPPY_H
+#define __IDE_FLOPPY_H
+
+/*
+ * Most of our global data which we need to save even as we leave the driver
+ * due to an interrupt or a timer event is stored in a variable of type
+ * idefloppy_floppy_t, defined below.
+ */
+typedef struct ide_floppy_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+
+	/* Current packet command */
+	struct ide_atapi_pc *pc;
+	/* Last failed packet command */
+	struct ide_atapi_pc *failed_pc;
+	/* used for blk_{fs,pc}_request() requests */
+	struct ide_atapi_pc queued_pc;
+
+	struct ide_atapi_pc request_sense_pc;
+	struct request request_sense_rq;
+
+	/* Last error information */
+	u8 sense_key, asc, ascq;
+	/* delay this long before sending packet command */
+	u8 ticks;
+	int progress_indication;
+
+	/* Device information */
+	/* Current format */
+	int blocks, block_size, bs_factor;
+	/* Last format capacity descriptor */
+	u8 cap_desc[8];
+	/* Copy of the flexible disk page */
+	u8 flexible_disk_page[32];
+} idefloppy_floppy_t;
+
+/*
+ * Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * See SFF-8070i spec.
+ */
+#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
+#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
+
+/* IOCTLs used in low-level formatting. */
+#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
+#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
+#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
+#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
+
+/* ide-floppy.c */
+void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
+void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
+void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *);
+
+/* ide-floppy_ioctl.c */
+int ide_floppy_format_ioctl(ide_drive_t *, struct file *, unsigned int,
+			    void __user *);
+
+#endif /*__IDE_FLOPPY_H */
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
new file mode 100644
index 0000000..5ffc451
--- /dev/null
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -0,0 +1,243 @@
+/*
+ * ide-floppy IOCTLs handling.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/cdrom.h>
+
+#include <asm/unaligned.h>
+
+#include <scsi/scsi_ioctl.h>
+
+#include "ide-floppy.h"
+
+/*
+ * Obtain the list of formattable capacities.
+ * Very similar to ide_floppy_get_capacity, except that we push the capacity
+ * descriptors to userland, instead of our own structures.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_capacities {
+ *	int nformats;
+ *	struct {
+ *		int nblocks;
+ *		int blocksize;
+ *	} formats[];
+ * };
+ *
+ * userland initializes nformats to the number of allocated formats[] records.
+ * On exit we set nformats to the number of records we've actually initialized.
+ */
+
+static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+{
+	struct ide_floppy_obj *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	u8 header_len, desc_cnt;
+	int i, blocks, length, u_array_size, u_index;
+	int __user *argp;
+
+	if (get_user(u_array_size, arg))
+		return -EFAULT;
+
+	if (u_array_size <= 0)
+		return -EINVAL;
+
+	ide_floppy_create_read_capacity_cmd(&pc);
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc)) {
+		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
+		return -EIO;
+	}
+
+	header_len = pc.buf[3];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
+
+	u_index = 0;
+	argp = arg + 1;
+
+	/*
+	 * We always skip the first capacity descriptor.  That's the current
+	 * capacity.  We are interested in the remaining descriptors, the
+	 * formattable capacities.
+	 */
+	for (i = 1; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
+
+		if (u_index >= u_array_size)
+			break;	/* User-supplied buffer too small */
+
+		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
+
+		if (put_user(blocks, argp))
+			return -EFAULT;
+
+		++argp;
+
+		if (put_user(length, argp))
+			return -EFAULT;
+
+		++argp;
+
+		++u_index;
+	}
+
+	if (put_user(u_index, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
+static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
+		int l, int flags)
+{
+	ide_init_pc(pc);
+	pc->c[0] = GPCMD_FORMAT_UNIT;
+	pc->c[1] = 0x17;
+
+	memset(pc->buf, 0, 12);
+	pc->buf[1] = 0xA2;
+	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
+
+	if (flags & 1)				/* Verify bit on... */
+		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
+	pc->buf[3] = 8;
+
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
+	pc->buf_size = 12;
+	pc->flags |= PC_FLAG_WRITING;
+}
+
+static int ide_floppy_get_sfrp_bit(ide_drive_t *drive)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+
+	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
+
+	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
+	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
+
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+		return 1;
+
+	if (pc.buf[8 + 2] & 0x40)
+		drive->atapi_flags |= IDE_AFLAG_SRFP;
+
+	return 0;
+}
+
+static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	int blocks, length, flags, err = 0;
+
+	if (floppy->openers > 1) {
+		/* Don't format if someone is using the disk */
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
+		return -EBUSY;
+	}
+
+	drive->atapi_flags |= IDE_AFLAG_FORMAT_IN_PROGRESS;
+
+	/*
+	 * Send ATAPI_FORMAT_UNIT to the drive.
+	 *
+	 * Userland gives us the following structure:
+	 *
+	 * struct idefloppy_format_command {
+	 *        int nblocks;
+	 *        int blocksize;
+	 *        int flags;
+	 *        } ;
+	 *
+	 * flags is a bitmask, currently, the only defined flag is:
+	 *
+	 *        0x01 - verify media after format.
+	 */
+	if (get_user(blocks, arg) ||
+			get_user(length, arg+1) ||
+			get_user(flags, arg+2)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	(void)ide_floppy_get_sfrp_bit(drive);
+	ide_floppy_create_format_unit_cmd(&pc, blocks, length, flags);
+
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+		err = -EIO;
+
+out:
+	if (err)
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
+	return err;
+}
+
+/*
+ * Get ATAPI_FORMAT_UNIT progress indication.
+ *
+ * Userland gives a pointer to an int.  The int is set to a progress
+ * indicator 0-65536, with 65536=100%.
+ *
+ * If the drive does not support format progress indication, we just check
+ * the dsc bit, and return either 0 or 65536.
+ */
+
+static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	int progress_indication = 0x10000;
+
+	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
+		ide_floppy_create_request_sense_cmd(&pc);
+		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+			return -EIO;
+
+		if (floppy->sense_key == 2 &&
+		    floppy->asc == 4 &&
+		    floppy->ascq == 4)
+			progress_indication = floppy->progress_indication;
+
+		/* Else assume format_unit has finished, and we're at 0x10000 */
+	} else {
+		ide_hwif_t *hwif = drive->hwif;
+		unsigned long flags;
+		u8 stat;
+
+		local_irq_save(flags);
+		stat = hwif->tp_ops->read_status(hwif);
+		local_irq_restore(flags);
+
+		progress_indication = ((stat & ATA_DSC) == 0) ? 0 : 0x10000;
+	}
+
+	if (put_user(progress_indication, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
+			    unsigned int cmd, void __user *argp)
+{
+	switch (cmd) {
+	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
+		return 0;
+	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
+		return ide_floppy_get_format_capacities(drive, argp);
+	case IDEFLOPPY_IOCTL_FORMAT_START:
+		if (!(file->f_mode & 2))
+			return -EPERM;
+		return ide_floppy_format_unit(drive, (int __user *)argp);
+	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
+		return ide_floppy_get_format_progress(drive, argp);
+	default:
+		return -ENOTTY;
+	}
+}
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 8fe8b5b..0a3cb0c 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ide.h>
+#include <linux/pci_ids.h>
 
 /* FIXME: convert m32r to use ide_platform host driver */
 #ifdef CONFIG_M32R
@@ -27,7 +28,7 @@
 
 #define DRV_NAME	"ide_generic"
 
-static int probe_mask = 0x03;
+static int probe_mask;
 module_param(probe_mask, int, 0);
 MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
@@ -100,19 +101,65 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
 static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
 #endif
 
+static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
+{
+	struct pci_dev *p = NULL;
+	u16 val;
+
+	for_each_pci_dev(p) {
+
+		if (pci_resource_start(p, 0) == 0x1f0)
+			*primary = 1;
+		if (pci_resource_start(p, 2) == 0x170)
+			*secondary = 1;
+
+		/* Cyrix CS55{1,2}0 pre SFF MWDMA ATA on the bridge */
+		if (p->vendor == PCI_VENDOR_ID_CYRIX &&
+		    (p->device == PCI_DEVICE_ID_CYRIX_5510 ||
+		     p->device == PCI_DEVICE_ID_CYRIX_5520))
+			*primary = *secondary = 1;
+
+		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
+		if (p->vendor == PCI_VENDOR_ID_INTEL &&
+		    p->device == PCI_DEVICE_ID_INTEL_82371MX) {
+
+			pci_read_config_word(p, 0x6C, &val);
+			if (val & 0x8000) {
+				/* ATA port enabled */
+				if (val & 0x4000)
+					*secondary = 1;
+				else
+					*primary = 1;
+			}
+		}
+	}
+}
+
 static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
 	struct ide_host *host;
 	unsigned long io_addr;
-	int i, rc;
+	int i, rc, primary = 0, secondary = 0;
 
 #ifdef CONFIG_MIPS
 	if (!ide_probe_legacy())
 		return -ENODEV;
 #endif
-	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
-			 "parameter for probing all legacy ISA IDE ports\n");
+	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
+
+	if (!probe_mask) {
+		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" "
+		     "module parameter for probing all legacy ISA IDE ports\n");
+
+		if (primary == 0)
+			probe_mask |= 0x1;
+
+		if (secondary == 0)
+			probe_mask |= 0x2;
+	} else
+		printk(KERN_INFO DRV_NAME ": enforcing probing of I/O ports "
+			"upon user request\n");
 
 	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index a896a28..1c51949 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -40,6 +40,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/reboot.h>
 #include <linux/cdrom.h>
@@ -183,18 +184,18 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		if (drive->media != ide_disk)
 			break;
 		/* Not supported? Switch to next step now. */
-		if (!drive->wcache || !ide_id_has_flush_cache(drive->id)) {
+		if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0) {
 			ide_complete_power_step(drive, rq, 0, 0);
 			return ide_stopped;
 		}
-		if (ide_id_has_flush_cache_ext(drive->id))
-			args->tf.command = WIN_FLUSH_CACHE_EXT;
+		if (ata_id_flush_ext_enabled(drive->id))
+			args->tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			args->tf.command = WIN_FLUSH_CACHE;
+			args->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 
 	case idedisk_pm_standby:	/* Suspend step 2 (standby) */
-		args->tf.command = WIN_STANDBYNOW1;
+		args->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 
 	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
@@ -209,7 +210,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		return ide_stopped;
 
 	case idedisk_pm_idle:		/* Resume step 2 (idle) */
-		args->tf.command = WIN_IDLEIMMEDIATE;
+		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 
 	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
@@ -322,7 +323,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 		ide_task_t *task = (ide_task_t *)rq->special;
 
 		if (rq->errors == 0)
-			rq->errors = !OK_STAT(stat, READY_STAT, BAD_STAT);
+			rq->errors = !OK_STAT(stat, ATA_DRDY, BAD_STAT);
 
 		if (task) {
 			struct ide_taskfile *tf = &task->tf;
@@ -373,29 +374,29 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (stat & BUSY_STAT || ((stat & WRERR_STAT) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
-	} else if (stat & ERR_STAT) {
+	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
-		if (err == ABRT_ERR) {
+		if (err == ATA_ABORTED) {
 			if (drive->select.b.lba &&
-			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->tp_ops->read_status(hwif) == WIN_SPECIFY)
+			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
+			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
 			drive->crc_count++;
-		} else if (err & (BBD_ERR | ECC_ERR)) {
+		} else if (err & (ATA_BBK | ATA_UNC)) {
 			/* retries won't help these */
 			rq->errors = ERROR_MAX;
-		} else if (err & TRK0_ERR) {
+		} else if (err & ATA_TRK0NF) {
 			/* help it find track zero */
 			rq->errors |= ERROR_RECAL;
 		}
 	}
 
-	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
+	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
 	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
 		int nsect = drive->mult_count ? drive->mult_count : 1;
 
@@ -407,7 +408,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		return ide_stopped;
 	}
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -427,16 +428,16 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (stat & BUSY_STAT || ((stat & WRERR_STAT) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
 		/* add decoding error stuff */
 	}
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -509,19 +510,19 @@ static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 	tf->lbam    = drive->cyl;
 	tf->lbah    = drive->cyl >> 8;
 	tf->device  = ((drive->head - 1) | drive->select.all) & ~ATA_LBA;
-	tf->command = WIN_SPECIFY;
+	tf->command = ATA_CMD_INIT_DEV_PARAMS;
 }
 
 static void ide_tf_set_restore_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
-	tf->command = WIN_RESTORE;
+	tf->command = ATA_CMD_RESTORE;
 }
 
 static void ide_tf_set_setmult_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->mult_req;
-	tf->command = WIN_SETMULT;
+	tf->command = ATA_CMD_SET_MULTI;
 }
 
 static ide_startstop_t ide_disk_special(ide_drive_t *drive)
@@ -540,8 +541,6 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 		ide_tf_set_restore_cmd(drive, &args.tf);
 	} else if (s->b.set_multmode) {
 		s->b.set_multmode = 0;
-		if (drive->mult_req > drive->id->max_multsect)
-			drive->mult_req = drive->id->max_multsect;
 		ide_tf_set_setmult_cmd(drive, &args.tf);
 	} else if (s->all) {
 		int special = s->all;
@@ -586,9 +585,10 @@ static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
  *	do_special		-	issue some special commands
  *	@drive: drive the command is for
  *
- *	do_special() is used to issue WIN_SPECIFY, WIN_RESTORE, and WIN_SETMULT
- *	commands to a drive.  It used to do much more, but has been scaled
- *	back.
+ *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
+ *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
+ *
+ *	It used to do much more, but has been scaled back.
  */
 
 static ide_startstop_t do_special (ide_drive_t *drive)
@@ -716,9 +716,49 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  	return ide_stopped;
 }
 
+int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
+		       int arg)
+{
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	int ret = 0;
+
+	if (!(setting->flags & DS_SYNC))
+		return setting->set(drive, arg);
+
+	rq = blk_get_request(q, READ, GFP_KERNEL);
+	if (!rq)
+		return -ENOMEM;
+
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 5;
+	rq->cmd[0] = REQ_DEVSET_EXEC;
+	*(int *)&rq->cmd[1] = arg;
+	rq->special = setting->set;
+
+	if (blk_execute_rq(q, NULL, rq, 0))
+		ret = rq->errors;
+	blk_put_request(rq);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ide_devset_execute);
+
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
 	switch (rq->cmd[0]) {
+	case REQ_DEVSET_EXEC:
+	{
+		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
+
+		err = setfunc(drive, *(int *)&rq->cmd[1]);
+		if (err)
+			rq->errors = err;
+		else
+			err = 1;
+		ide_end_request(drive, err, 0);
+		return ide_stopped;
+	}
 	case REQ_DRIVE_RESET:
 		return ide_do_reset(drive);
 	default:
@@ -766,9 +806,7 @@ static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
  *	start_request	-	start of I/O and command issuing for IDE
  *
  *	start_request() initiates handling of a new I/O request. It
- *	accepts commands and I/O (read/write) requests. It also does
- *	the final remapping for weird stuff like EZDrive. Once 
- *	device mapper can work sector level the EZDrive stuff can go away
+ *	accepts commands and I/O (read/write) requests.
  *
  *	FIXME: this function needs a rename
  */
@@ -776,7 +814,6 @@ static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 {
 	ide_startstop_t startstop;
-	sector_t block;
 
 	BUG_ON(!blk_rq_started(rq));
 
@@ -791,21 +828,12 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		goto kill_rq;
 	}
 
-	block    = rq->sector;
-	if (blk_fs_request(rq) &&
-	    (drive->media == ide_disk || drive->media == ide_floppy)) {
-		block += drive->sect0;
-	}
-	/* Yecch - this will shift the entire interval,
-	   possibly killing some innocent following sector */
-	if (block == 0 && drive->remap_0_to_1 == 1)
-		block = 1;  /* redirect MBR access to EZ-Drive partn table */
-
 	if (blk_pm_request(rq))
 		ide_check_pm_state(drive, rq);
 
 	SELECT_DRIVE(drive);
-	if (ide_wait_stat(&startstop, drive, drive->ready_stat, BUSY_STAT|DRQ_STAT, WAIT_READY)) {
+	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
+			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
@@ -844,7 +872,8 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			return ide_special_rq(drive, rq);
 
 		drv = *(ide_driver_t **)rq->rq_disk->private_data;
-		return drv->do_request(drive, rq, block);
+
+		return drv->do_request(drive, rq, rq->sector);
 	}
 	return do_special(drive);
 kill_rq:
@@ -1325,7 +1354,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
 		if (hwif->irq == irq) {
 			stat = hwif->tp_ops->read_status(hwif);
 
-			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
+			if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
 				++count;
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
new file mode 100644
index 0000000..cf01564
--- /dev/null
+++ b/drivers/ide/ide-ioctls.c
@@ -0,0 +1,290 @@
+/*
+ * IDE ioctls handling.
+ */
+
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+
+static const struct ide_ioctl_devset ide_ioctl_settings[] = {
+{ HDIO_GET_32BIT,	 HDIO_SET_32BIT,	&ide_devset_io_32bit  },
+{ HDIO_GET_KEEPSETTINGS, HDIO_SET_KEEPSETTINGS,	&ide_devset_keepsettings },
+{ HDIO_GET_UNMASKINTR,	 HDIO_SET_UNMASKINTR,	&ide_devset_unmaskirq },
+{ HDIO_GET_DMA,		 HDIO_SET_DMA,		&ide_devset_using_dma },
+{ -1,			 HDIO_SET_PIO_MODE,	&ide_devset_pio_mode  },
+{ 0 }
+};
+
+int ide_setting_ioctl(ide_drive_t *drive, struct block_device *bdev,
+		      unsigned int cmd, unsigned long arg,
+		      const struct ide_ioctl_devset *s)
+{
+	const struct ide_devset *ds;
+	unsigned long flags;
+	int err = -EOPNOTSUPP;
+
+	for (; (ds = s->setting); s++) {
+		if (ds->get && s->get_ioctl == cmd)
+			goto read_val;
+		else if (ds->set && s->set_ioctl == cmd)
+			goto set_val;
+	}
+
+	return err;
+
+read_val:
+	mutex_lock(&ide_setting_mtx);
+	spin_lock_irqsave(&ide_lock, flags);
+	err = ds->get(drive);
+	spin_unlock_irqrestore(&ide_lock, flags);
+	mutex_unlock(&ide_setting_mtx);
+	return err >= 0 ? put_user(err, (long __user *)arg) : err;
+
+set_val:
+	if (bdev != bdev->bd_contains)
+		err = -EINVAL;
+	else {
+		if (!capable(CAP_SYS_ADMIN))
+			err = -EACCES;
+		else {
+			mutex_lock(&ide_setting_mtx);
+			err = ide_devset_execute(drive, ds, arg);
+			mutex_unlock(&ide_setting_mtx);
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(ide_setting_ioctl);
+
+static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
+				  unsigned long arg)
+{
+	u16 *id = NULL;
+	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
+	int rc = 0;
+
+	if (drive->id_read == 0) {
+		rc = -ENOMSG;
+		goto out;
+	}
+
+	id = kmalloc(size, GFP_KERNEL);
+	if (id == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(id, drive->id, size);
+	ata_id_to_hd_driveid(id);
+
+	if (copy_to_user((void __user *)arg, id, size))
+		rc = -EFAULT;
+
+	kfree(id);
+out:
+	return rc;
+}
+
+static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
+			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
+}
+
+static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
+		return -EPERM;
+
+	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
+	    (drive->media == ide_disk || drive->media == ide_floppy ||
+	     drive->scsi))
+		return -EPERM;
+
+	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
+	drive->nice1 = (arg >> IDE_NICE_1) & 1;
+
+	return 0;
+}
+
+static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+{
+	u8 *buf = NULL;
+	int bufsize = 0, err = 0;
+	u8 args[4], xfer_rate = 0;
+	ide_task_t tfargs;
+	struct ide_taskfile *tf = &tfargs.tf;
+	u16 *id = drive->id;
+
+	if (NULL == (void *) arg) {
+		struct request *rq;
+
+		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+		err = blk_execute_rq(drive->queue, NULL, rq, 0);
+		blk_put_request(rq);
+
+		return err;
+	}
+
+	if (copy_from_user(args, (void __user *)arg, 4))
+		return -EFAULT;
+
+	memset(&tfargs, 0, sizeof(ide_task_t));
+	tf->feature = args[2];
+	if (args[0] == ATA_CMD_SMART) {
+		tf->nsect = args[3];
+		tf->lbal  = args[1];
+		tf->lbam  = 0x4f;
+		tf->lbah  = 0xc2;
+		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+	} else {
+		tf->nsect = args[1];
+		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
+				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+	}
+	tf->command = args[0];
+	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
+
+	if (args[3]) {
+		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
+		bufsize = SECTOR_SIZE * args[3];
+		buf = kzalloc(bufsize, GFP_KERNEL);
+		if (buf == NULL)
+			return -ENOMEM;
+	}
+
+	if (tf->command == ATA_CMD_SET_FEATURES &&
+	    tf->feature == SETFEATURES_XFER &&
+	    tf->nsect >= XFER_SW_DMA_0 &&
+	    (id[ATA_ID_UDMA_MODES] ||
+	     id[ATA_ID_MWDMA_MODES] ||
+	     id[ATA_ID_SWDMA_MODES])) {
+		xfer_rate = args[1];
+		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
+			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
+					    "be set\n", drive->name);
+			goto abort;
+		}
+	}
+
+	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
+
+	args[0] = tf->status;
+	args[1] = tf->error;
+	args[2] = tf->nsect;
+
+	if (!err && xfer_rate) {
+		/* active-retuning-calls future */
+		ide_set_xfer_rate(drive, xfer_rate);
+		ide_driveid_update(drive);
+	}
+abort:
+	if (copy_to_user((void __user *)arg, &args, 4))
+		err = -EFAULT;
+	if (buf) {
+		if (copy_to_user((void __user *)(arg + 4), buf, bufsize))
+			err = -EFAULT;
+		kfree(buf);
+	}
+	return err;
+}
+
+static int ide_task_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+{
+	void __user *p = (void __user *)arg;
+	int err = 0;
+	u8 args[7];
+	ide_task_t task;
+
+	if (copy_from_user(args, p, 7))
+		return -EFAULT;
+
+	memset(&task, 0, sizeof(task));
+	memcpy(&task.tf_array[7], &args[1], 6);
+	task.tf.command = args[0];
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	err = ide_no_data_taskfile(drive, &task);
+
+	args[0] = task.tf.command;
+	memcpy(&args[1], &task.tf_array[7], 6);
+
+	if (copy_to_user(p, args, 7))
+		err = -EFAULT;
+
+	return err;
+}
+
+static int generic_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq;
+	int ret = 0;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 1;
+	rq->cmd[0] = REQ_DRIVE_RESET;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	if (blk_execute_rq(drive->queue, NULL, rq, 1))
+		ret = rq->errors;
+	blk_put_request(rq);
+	return ret;
+}
+
+int generic_ide_ioctl(ide_drive_t *drive, struct file *file,
+		      struct block_device *bdev,
+		      unsigned int cmd, unsigned long arg)
+{
+	int err;
+
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	switch (cmd) {
+	case HDIO_OBSOLETE_IDENTITY:
+	case HDIO_GET_IDENTITY:
+		if (bdev != bdev->bd_contains)
+			return -EINVAL;
+		return ide_get_identity_ioctl(drive, cmd, arg);
+	case HDIO_GET_NICE:
+		return ide_get_nice_ioctl(drive, arg);
+	case HDIO_SET_NICE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return ide_set_nice_ioctl(drive, arg);
+#ifdef CONFIG_IDE_TASK_IOCTL
+	case HDIO_DRIVE_TASKFILE:
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		if (drive->media == ide_disk)
+			return ide_taskfile_ioctl(drive, cmd, arg);
+		return -ENOMSG;
+#endif
+	case HDIO_DRIVE_CMD:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_cmd_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_TASK:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_task_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return generic_drive_reset(drive);
+	case HDIO_GET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		if (put_user(BUSSTATE_ON, (long __user *)arg))
+			return -EFAULT;
+		return 0;
+	case HDIO_SET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(generic_ide_ioctl);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 2cbadff..0a2fd3b 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 #include <linux/nmi.h>
@@ -400,97 +399,14 @@ const struct ide_tp_ops default_tp_ops = {
 	.output_data		= ide_output_data,
 };
 
-void ide_fix_driveid (struct hd_driveid *id)
+void ide_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
 	int i;
-	u16 *stringcast;
-
-	id->config         = __le16_to_cpu(id->config);
-	id->cyls           = __le16_to_cpu(id->cyls);
-	id->reserved2      = __le16_to_cpu(id->reserved2);
-	id->heads          = __le16_to_cpu(id->heads);
-	id->track_bytes    = __le16_to_cpu(id->track_bytes);
-	id->sector_bytes   = __le16_to_cpu(id->sector_bytes);
-	id->sectors        = __le16_to_cpu(id->sectors);
-	id->vendor0        = __le16_to_cpu(id->vendor0);
-	id->vendor1        = __le16_to_cpu(id->vendor1);
-	id->vendor2        = __le16_to_cpu(id->vendor2);
-	stringcast = (u16 *)&id->serial_no[0];
-	for (i = 0; i < (20/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->buf_type       = __le16_to_cpu(id->buf_type);
-	id->buf_size       = __le16_to_cpu(id->buf_size);
-	id->ecc_bytes      = __le16_to_cpu(id->ecc_bytes);
-	stringcast = (u16 *)&id->fw_rev[0];
-	for (i = 0; i < (8/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	stringcast = (u16 *)&id->model[0];
-	for (i = 0; i < (40/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->dword_io       = __le16_to_cpu(id->dword_io);
-	id->reserved50     = __le16_to_cpu(id->reserved50);
-	id->field_valid    = __le16_to_cpu(id->field_valid);
-	id->cur_cyls       = __le16_to_cpu(id->cur_cyls);
-	id->cur_heads      = __le16_to_cpu(id->cur_heads);
-	id->cur_sectors    = __le16_to_cpu(id->cur_sectors);
-	id->cur_capacity0  = __le16_to_cpu(id->cur_capacity0);
-	id->cur_capacity1  = __le16_to_cpu(id->cur_capacity1);
-	id->lba_capacity   = __le32_to_cpu(id->lba_capacity);
-	id->dma_1word      = __le16_to_cpu(id->dma_1word);
-	id->dma_mword      = __le16_to_cpu(id->dma_mword);
-	id->eide_pio_modes = __le16_to_cpu(id->eide_pio_modes);
-	id->eide_dma_min   = __le16_to_cpu(id->eide_dma_min);
-	id->eide_dma_time  = __le16_to_cpu(id->eide_dma_time);
-	id->eide_pio       = __le16_to_cpu(id->eide_pio);
-	id->eide_pio_iordy = __le16_to_cpu(id->eide_pio_iordy);
-	for (i = 0; i < 2; ++i)
-		id->words69_70[i] = __le16_to_cpu(id->words69_70[i]);
-	for (i = 0; i < 4; ++i)
-		id->words71_74[i] = __le16_to_cpu(id->words71_74[i]);
-	id->queue_depth    = __le16_to_cpu(id->queue_depth);
-	for (i = 0; i < 4; ++i)
-		id->words76_79[i] = __le16_to_cpu(id->words76_79[i]);
-	id->major_rev_num  = __le16_to_cpu(id->major_rev_num);
-	id->minor_rev_num  = __le16_to_cpu(id->minor_rev_num);
-	id->command_set_1  = __le16_to_cpu(id->command_set_1);
-	id->command_set_2  = __le16_to_cpu(id->command_set_2);
-	id->cfsse          = __le16_to_cpu(id->cfsse);
-	id->cfs_enable_1   = __le16_to_cpu(id->cfs_enable_1);
-	id->cfs_enable_2   = __le16_to_cpu(id->cfs_enable_2);
-	id->csf_default    = __le16_to_cpu(id->csf_default);
-	id->dma_ultra      = __le16_to_cpu(id->dma_ultra);
-	id->trseuc         = __le16_to_cpu(id->trseuc);
-	id->trsEuc         = __le16_to_cpu(id->trsEuc);
-	id->CurAPMvalues   = __le16_to_cpu(id->CurAPMvalues);
-	id->mprc           = __le16_to_cpu(id->mprc);
-	id->hw_config      = __le16_to_cpu(id->hw_config);
-	id->acoustic       = __le16_to_cpu(id->acoustic);
-	id->msrqs          = __le16_to_cpu(id->msrqs);
-	id->sxfert         = __le16_to_cpu(id->sxfert);
-	id->sal            = __le16_to_cpu(id->sal);
-	id->spg            = __le32_to_cpu(id->spg);
-	id->lba_capacity_2 = __le64_to_cpu(id->lba_capacity_2);
-	for (i = 0; i < 22; i++)
-		id->words104_125[i]   = __le16_to_cpu(id->words104_125[i]);
-	id->last_lun       = __le16_to_cpu(id->last_lun);
-	id->word127        = __le16_to_cpu(id->word127);
-	id->dlf            = __le16_to_cpu(id->dlf);
-	id->csfo           = __le16_to_cpu(id->csfo);
-	for (i = 0; i < 26; i++)
-		id->words130_155[i] = __le16_to_cpu(id->words130_155[i]);
-	id->word156        = __le16_to_cpu(id->word156);
-	for (i = 0; i < 3; i++)
-		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
-	id->cfa_power      = __le16_to_cpu(id->cfa_power);
-	for (i = 0; i < 15; i++)
-		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
-	for (i = 0; i < 30; i++)
-		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
-	for (i = 0; i < 49; i++)
-		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
-	id->integrity_word  = __le16_to_cpu(id->integrity_word);
+
+	for (i = 0; i < 256; i++)
+		id[i] = __le16_to_cpu(id[i]);
 # else
 #  error "Please fix <asm/byteorder.h>"
 # endif
@@ -501,19 +417,21 @@ void ide_fix_driveid (struct hd_driveid *id)
  * ide_fixstring() cleans up and (optionally) byte-swaps a text string,
  * removing leading/trailing blanks and compressing internal blanks.
  * It is primarily used to tidy up the model name/number fields as
- * returned by the WIN_[P]IDENTIFY commands.
+ * returned by the ATA_CMD_ID_ATA[PI] commands.
  */
 
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 {
-	u8 *p = s, *end = &s[bytecount & ~1]; /* bytecount must be even */
+	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
 
 	if (byteswap) {
 		/* convert from big-endian to host byte order */
-		for (p = end ; p != s;)
-			be16_to_cpus((u16 *)(p -= 2));
+		for (p = s ; p != end ; p += 2)
+			be16_to_cpus((u16 *) p);
 	}
+
 	/* strip leading blanks */
+	p = s;
 	while (s != end && *s == ' ')
 		++s;
 	/* compress internal blanks and strip trailing blanks */
@@ -556,7 +474,7 @@ int drive_is_ready (ide_drive_t *drive)
 		/* Note: this may clear a pending IRQ!! */
 		stat = hwif->tp_ops->read_status(hwif);
 
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		/* drive busy:  definitely not interrupting */
 		return 0;
 
@@ -588,10 +506,10 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
 	stat = tp_ops->read_status(hwif);
 
-	if (stat & BUSY_STAT) {
+	if (stat & ATA_BUSY) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = tp_ops->read_status(hwif)) & BUSY_STAT) {
+		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
@@ -599,7 +517,7 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 				 * progress during the timeout..
 				 */
 				stat = tp_ops->read_status(hwif);
-				if (!(stat & BUSY_STAT))
+				if ((stat & ATA_BUSY) == 0)
 					break;
 
 				local_irq_restore(flags);
@@ -660,18 +578,18 @@ EXPORT_SYMBOL(ide_wait_stat);
 /**
  *	ide_in_drive_list	-	look for drive in black/white list
  *	@id: drive identifier
- *	@drive_table: list to inspect
+ *	@table: list to inspect
  *
  *	Look for a drive in the blacklist and the whitelist tables
  *	Returns 1 if the drive is found in the table.
  */
 
-int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *drive_table)
+int ide_in_drive_list(u16 *id, const struct drive_list_entry *table)
 {
-	for ( ; drive_table->id_model; drive_table++)
-		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    (!drive_table->id_firmware ||
-		     strstr(id->fw_rev, drive_table->id_firmware)))
+	for ( ; table->id_model; table++)
+		if ((!strcmp(table->id_model, (char *)&id[ATA_ID_PROD])) &&
+		    (!table->id_firmware ||
+		     strstr((char *)&id[ATA_ID_FW_REV], table->id_firmware)))
 			return 1;
 	return 0;
 }
@@ -702,7 +620,7 @@ static const struct drive_list_entry ivb_list[] = {
 u8 eighty_ninty_three (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	int ivb = ide_in_drive_list(id, ivb_list);
 
 	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
@@ -712,7 +630,7 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 		printk(KERN_DEBUG "%s: skipping word 93 validity check\n",
 				  drive->name);
 
-	if (ide_dev_is_sata(id) && !ivb)
+	if (ata_id_is_sata(id) && !ivb)
 		return 1;
 
 	if (hwif->cbl != ATA_CBL_PATA80 && !ivb)
@@ -724,7 +642,8 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	if ((id->hw_config & 0x4000) || (ivb && (id->hw_config & 0x2000)))
+	if ((id[ATA_ID_HW_CONFIG] & 0x4000) ||
+	    (ivb && (id[ATA_ID_HW_CONFIG] & 0x2000)))
 		return 1;
 
 no_80w:
@@ -745,8 +664,8 @@ int ide_driveid_update(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	struct hd_driveid *id;
-	unsigned long timeout, flags;
+	u16 *id;
+	unsigned long flags;
 	u8 stat;
 
 	/*
@@ -757,29 +676,24 @@ int ide_driveid_update(ide_drive_t *drive)
 	SELECT_MASK(drive, 1);
 	tp_ops->set_irq(hwif, 0);
 	msleep(50);
-	tp_ops->exec_command(hwif, WIN_IDENTIFY);
-	timeout = jiffies + WAIT_WORSTCASE;
-	do {
-		if (time_after(jiffies, timeout)) {
-			SELECT_MASK(drive, 0);
-			return 0;	/* drive timed-out */
-		}
+	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
 
-		msleep(50);	/* give drive a breather */
-		stat = tp_ops->read_altstatus(hwif);
-	} while (stat & BUSY_STAT);
+	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 1)) {
+		SELECT_MASK(drive, 0);
+		return 0;
+	}
 
-	msleep(50);	/* wait for IRQ and DRQ_STAT */
+	msleep(50);	/* wait for IRQ and ATA_DRQ */
 	stat = tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
+	if (!OK_STAT(stat, ATA_DRQ, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
 		printk("%s: CHECK for good STATUS\n", drive->name);
 		return 0;
 	}
 	local_irq_save(flags);
 	SELECT_MASK(drive, 0);
-	id = kmalloc(SECTOR_WORDS*4, GFP_ATOMIC);
+	id = kmalloc(SECTOR_SIZE, GFP_ATOMIC);
 	if (!id) {
 		local_irq_restore(flags);
 		return 0;
@@ -789,16 +703,16 @@ int ide_driveid_update(ide_drive_t *drive)
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
-	if (id) {
-		drive->id->dma_ultra = id->dma_ultra;
-		drive->id->dma_mword = id->dma_mword;
-		drive->id->dma_1word = id->dma_1word;
-		/* anything more ? */
-		kfree(id);
-
-		if (drive->using_dma && ide_id_dma_bug(drive))
-			ide_dma_off(drive);
-	}
+
+	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
+	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
+	drive->id[ATA_ID_SWDMA_MODES] = id[ATA_ID_SWDMA_MODES];
+	/* anything more ? */
+
+	kfree(id);
+
+	if (drive->using_dma && ide_id_dma_bug(drive))
+		ide_dma_off(drive);
 
 	return 1;
 }
@@ -807,6 +721,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	u16 *id = drive->id, i;
 	int error = 0;
 	u8 stat;
 	ide_task_t task;
@@ -817,7 +732,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 #endif
 
 	/* Skip setting PIO flow-control modes on pre-EIDE drives */
-	if ((speed & 0xf8) == XFER_PIO_0 && !(drive->id->capability & 0x08))
+	if ((speed & 0xf8) == XFER_PIO_0 && ata_id_has_iordy(drive->id) == 0)
 		goto skip;
 
 	/*
@@ -851,13 +766,13 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
 	tp_ops->tf_load(drive, &task);
 
-	tp_ops->exec_command(hwif, WIN_SETFEATURES);
+	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
 	if (drive->quirk_list == 2)
 		tp_ops->set_irq(hwif, 1);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
-				BUSY_STAT|DRQ_STAT|ERR_STAT,
+				ATA_BUSY | ATA_DRQ | ATA_ERR,
 				WAIT_CMD, &stat);
 
 	SELECT_MASK(drive, 0);
@@ -869,9 +784,9 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 		return error;
 	}
 
-	drive->id->dma_ultra &= ~0xFF00;
-	drive->id->dma_mword &= ~0x0F00;
-	drive->id->dma_1word &= ~0x0F00;
+	id[ATA_ID_UDMA_MODES]  &= ~0xFF00;
+	id[ATA_ID_MWDMA_MODES] &= ~0x0F00;
+	id[ATA_ID_SWDMA_MODES] &= ~0x0F00;
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
@@ -881,23 +796,17 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 		ide_dma_off_quietly(drive);
 #endif
 
-	switch(speed) {
-		case XFER_UDMA_7:   drive->id->dma_ultra |= 0x8080; break;
-		case XFER_UDMA_6:   drive->id->dma_ultra |= 0x4040; break;
-		case XFER_UDMA_5:   drive->id->dma_ultra |= 0x2020; break;
-		case XFER_UDMA_4:   drive->id->dma_ultra |= 0x1010; break;
-		case XFER_UDMA_3:   drive->id->dma_ultra |= 0x0808; break;
-		case XFER_UDMA_2:   drive->id->dma_ultra |= 0x0404; break;
-		case XFER_UDMA_1:   drive->id->dma_ultra |= 0x0202; break;
-		case XFER_UDMA_0:   drive->id->dma_ultra |= 0x0101; break;
-		case XFER_MW_DMA_2: drive->id->dma_mword |= 0x0404; break;
-		case XFER_MW_DMA_1: drive->id->dma_mword |= 0x0202; break;
-		case XFER_MW_DMA_0: drive->id->dma_mword |= 0x0101; break;
-		case XFER_SW_DMA_2: drive->id->dma_1word |= 0x0404; break;
-		case XFER_SW_DMA_1: drive->id->dma_1word |= 0x0202; break;
-		case XFER_SW_DMA_0: drive->id->dma_1word |= 0x0101; break;
-		default: break;
+	if (speed >= XFER_UDMA_0) {
+		i = 1 << (speed - XFER_UDMA_0);
+		id[ATA_ID_UDMA_MODES] |= (i << 8 | i);
+	} else if (speed >= XFER_MW_DMA_0) {
+		i = 1 << (speed - XFER_MW_DMA_0);
+		id[ATA_ID_MWDMA_MODES] |= (i << 8 | i);
+	} else if (speed >= XFER_SW_DMA_0) {
+		i = 1 << (speed - XFER_SW_DMA_0);
+		id[ATA_ID_SWDMA_MODES] |= (i << 8 | i);
 	}
+
 	if (!drive->init_speed)
 		drive->init_speed = speed;
 	drive->current_speed = speed;
@@ -977,7 +886,7 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->tp_ops->exec_command(hwif, WIN_PACKETCMD);
+	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1010,7 +919,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	udelay (10);
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, 0, BUSY_STAT))
+	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk("%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
@@ -1056,7 +965,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 
 	tmp = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
+	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
@@ -1102,7 +1011,7 @@ out:
 
 static void ide_disk_pre_reset(ide_drive_t *drive)
 {
-	int legacy = (drive->id->cfs_enable_2 & 0x0400) ? 0 : 1;
+	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
 
 	drive->special.all = 0;
 	drive->special.b.set_geometry = legacy;
@@ -1187,7 +1096,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		tp_ops->exec_command(hwif, WIN_SRST);
+		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1270,7 +1179,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 		 */
 		mdelay(1);
 		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0)
+		if ((stat & ATA_BUSY) == 0)
 			return 0;
 		/*
 		 * Assume a value of 0xff means nothing is connected to
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 97fefab..ed426dd 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -2,7 +2,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
@@ -90,29 +89,31 @@ static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 
 u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 {
-	int pio_mode;
-	struct hd_driveid* id = drive->id;
-	int overridden  = 0;
+	u16 *id = drive->id;
+	int pio_mode = -1, overridden = 0;
 
 	if (mode_wanted != 255)
 		return min_t(u8, mode_wanted, max_mode);
 
-	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0 &&
-	    (pio_mode = ide_scan_pio_blacklist(id->model)) != -1) {
+	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
+		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
+
+	if (pio_mode != -1) {
 		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
 	} else {
-		pio_mode = id->tPIO;
+		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
 			pio_mode = 2;
 			overridden = 1;
 		}
-		if (id->field_valid & 2) {	  /* drive implements ATA2? */
-			if (id->capability & 8) { /* IORDY supported? */
-				if (id->eide_pio_modes & 7) {
+
+		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
+			if (ata_id_has_iordy(id)) {
+				if (id[ATA_ID_PIO_MODES] & 7) {
 					overridden = 0;
-					if (id->eide_pio_modes & 4)
+					if (id[ATA_ID_PIO_MODES] & 4)
 						pio_mode = 5;
-					else if (id->eide_pio_modes & 2)
+					else if (id[ATA_ID_PIO_MODES] & 2)
 						pio_mode = 4;
 					else
 						pio_mode = 3;
@@ -338,16 +339,16 @@ static void ide_dump_sector(ide_drive_t *drive)
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
 	printk("{ ");
-	if (err & ABRT_ERR)	printk("DriveStatusError ");
-	if (err & ICRC_ERR)
-		printk((err & ABRT_ERR) ? "BadCRC " : "BadSector ");
-	if (err & ECC_ERR)	printk("UncorrectableError ");
-	if (err & ID_ERR)	printk("SectorIdNotFound ");
-	if (err & TRK0_ERR)	printk("TrackZeroNotFound ");
-	if (err & MARK_ERR)	printk("AddrMarkNotFound ");
+	if (err & ATA_ABORTED)	printk("DriveStatusError ");
+	if (err & ATA_ICRC)
+		printk((err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
+	if (err & ATA_UNC)	printk("UncorrectableError ");
+	if (err & ATA_IDNF)	printk("SectorIdNotFound ");
+	if (err & ATA_TRK0NF)	printk("TrackZeroNotFound ");
+	if (err & ATA_AMNF)	printk("AddrMarkNotFound ");
 	printk("}");
-	if ((err & (BBD_ERR | ABRT_ERR)) == BBD_ERR ||
-	    (err & (ECC_ERR|ID_ERR|MARK_ERR))) {
+	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
+	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
 		ide_dump_sector(drive);
 		if (HWGROUP(drive) && HWGROUP(drive)->rq)
 			printk(", sector=%llu",
@@ -359,12 +360,12 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
 	printk("{ ");
-	if (err & ILI_ERR)	printk("IllegalLengthIndication ");
-	if (err & EOM_ERR)	printk("EndOfMedia ");
-	if (err & ABRT_ERR)	printk("AbortedCommand ");
-	if (err & MCR_ERR)	printk("MediaChangeRequested ");
-	if (err & LFS_ERR)	printk("LastFailedSense=0x%02x ",
-				       (err & LFS_ERR) >> 4);
+	if (err & ATAPI_ILI)	printk("IllegalLengthIndication ");
+	if (err & ATAPI_EOM)	printk("EndOfMedia ");
+	if (err & ATA_ABORTED)	printk("AbortedCommand ");
+	if (err & ATA_MCR)	printk("MediaChangeRequested ");
+	if (err & ATAPI_LFS)	printk("LastFailedSense=0x%02x ",
+				       (err & ATAPI_LFS) >> 4);
 	printk("}\n");
 }
 
@@ -386,19 +387,19 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 
 	local_irq_save(flags);
 	printk("%s: %s: status=0x%02x { ", drive->name, msg, stat);
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		printk("Busy ");
 	else {
-		if (stat & READY_STAT)	printk("DriveReady ");
-		if (stat & WRERR_STAT)	printk("DeviceFault ");
-		if (stat & SEEK_STAT)	printk("SeekComplete ");
-		if (stat & DRQ_STAT)	printk("DataRequest ");
-		if (stat & ECC_STAT)	printk("CorrectedError ");
-		if (stat & INDEX_STAT)	printk("Index ");
-		if (stat & ERR_STAT)	printk("Error ");
+		if (stat & ATA_DRDY)	printk("DriveReady ");
+		if (stat & ATA_DF)	printk("DeviceFault ");
+		if (stat & ATA_DSC)	printk("SeekComplete ");
+		if (stat & ATA_DRQ)	printk("DataRequest ");
+		if (stat & ATA_CORR)	printk("CorrectedError ");
+		if (stat & ATA_IDX)	printk("Index ");
+		if (stat & ATA_ERR)	printk("Error ");
 	}
 	printk("}\n");
-	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
+	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
 		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 70aa86c..06575a1 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -50,59 +50,54 @@
  
 static void generic_id(ide_drive_t *drive)
 {
-	drive->id->cyls = drive->cyl;
-	drive->id->heads = drive->head;
-	drive->id->sectors = drive->sect;
-	drive->id->cur_cyls = drive->cyl;
-	drive->id->cur_heads = drive->head;
-	drive->id->cur_sectors = drive->sect;
+	u16 *id = drive->id;
+
+	id[ATA_ID_CUR_CYLS]	= id[ATA_ID_CYLS]	= drive->cyl;
+	id[ATA_ID_CUR_HEADS]	= id[ATA_ID_HEADS]	= drive->head;
+	id[ATA_ID_CUR_SECTORS]	= id[ATA_ID_SECTORS]	= drive->sect;
 }
 
 static void ide_disk_init_chs(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	/* Extract geometry if we did not already have one for the drive */
 	if (!drive->cyl || !drive->head || !drive->sect) {
-		drive->cyl  = drive->bios_cyl  = id->cyls;
-		drive->head = drive->bios_head = id->heads;
-		drive->sect = drive->bios_sect = id->sectors;
+		drive->cyl  = drive->bios_cyl  = id[ATA_ID_CYLS];
+		drive->head = drive->bios_head = id[ATA_ID_HEADS];
+		drive->sect = drive->bios_sect = id[ATA_ID_SECTORS];
 	}
 
 	/* Handle logical geometry translation by the drive */
-	if ((id->field_valid & 1) && id->cur_cyls &&
-	    id->cur_heads && (id->cur_heads <= 16) && id->cur_sectors) {
-		drive->cyl  = id->cur_cyls;
-		drive->head = id->cur_heads;
-		drive->sect = id->cur_sectors;
+	if (ata_id_current_chs_valid(id)) {
+		drive->cyl  = id[ATA_ID_CUR_CYLS];
+		drive->head = id[ATA_ID_CUR_HEADS];
+		drive->sect = id[ATA_ID_CUR_SECTORS];
 	}
 
 	/* Use physical geometry if what we have still makes no sense */
-	if (drive->head > 16 && id->heads && id->heads <= 16) {
-		drive->cyl  = id->cyls;
-		drive->head = id->heads;
-		drive->sect = id->sectors;
+	if (drive->head > 16 && id[ATA_ID_HEADS] && id[ATA_ID_HEADS] <= 16) {
+		drive->cyl  = id[ATA_ID_CYLS];
+		drive->head = id[ATA_ID_HEADS];
+		drive->sect = id[ATA_ID_SECTORS];
 	}
 }
 
 static void ide_disk_init_mult_count(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
-
-	drive->mult_count = 0;
-	if (id->max_multsect) {
-#ifdef CONFIG_IDEDISK_MULTI_MODE
-		id->multsect = ((id->max_multsect/2) > 1) ? id->max_multsect : 0;
-		id->multsect_valid = id->multsect ? 1 : 0;
-		drive->mult_req = id->multsect_valid ? id->max_multsect : 0;
-		drive->special.b.set_multmode = drive->mult_req ? 1 : 0;
-#else	/* original, pre IDE-NFG, per request of AC */
-		drive->mult_req = 0;
-		if (drive->mult_req > id->max_multsect)
-			drive->mult_req = id->max_multsect;
-		if (drive->mult_req || ((id->multsect_valid & 1) && id->multsect))
+	u16 *id = drive->id;
+	u8 max_multsect = id[ATA_ID_MAX_MULTSECT] & 0xff;
+
+	if (max_multsect) {
+		if ((max_multsect / 2) > 1)
+			id[ATA_ID_MULTSECT] = max_multsect | 0x100;
+		else
+			id[ATA_ID_MULTSECT] &= ~0x1ff;
+
+		drive->mult_req = id[ATA_ID_MULTSECT] & 0xff;
+
+		if (drive->mult_req)
 			drive->special.b.set_multmode = 1;
-#endif
 	}
 }
 
@@ -119,10 +114,10 @@ static void ide_disk_init_mult_count(ide_drive_t *drive)
 static inline void do_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	int bswap = 1;
-	struct hd_driveid *id;
+	u16 *id = drive->id;
+	char *m = (char *)&id[ATA_ID_PROD];
+	int bswap = 1, is_cfa;
 
-	id = drive->id;
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
@@ -135,27 +130,28 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	ide_fix_driveid(id);
 
 	/*
-	 *  WIN_IDENTIFY returns little-endian info,
-	 *  WIN_PIDENTIFY *usually* returns little-endian info.
+	 *  ATA_CMD_ID_ATA returns little-endian info,
+	 *  ATA_CMD_ID_ATAPI *usually* returns little-endian info.
 	 */
-	if (cmd == WIN_PIDENTIFY) {
-		if ((id->model[0] == 'N' && id->model[1] == 'E') /* NEC */
-		 || (id->model[0] == 'F' && id->model[1] == 'X') /* Mitsumi */
-		 || (id->model[0] == 'P' && id->model[1] == 'i'))/* Pioneer */
+	if (cmd == ATA_CMD_ID_ATAPI) {
+		if ((m[0] == 'N' && m[1] == 'E') ||  /* NEC */
+		    (m[0] == 'F' && m[1] == 'X') ||  /* Mitsumi */
+		    (m[0] == 'P' && m[1] == 'i'))    /* Pioneer */
 			/* Vertos drives may still be weird */
-			bswap ^= 1;	
+			bswap ^= 1;
 	}
-	ide_fixstring(id->model,     sizeof(id->model),     bswap);
-	ide_fixstring(id->fw_rev,    sizeof(id->fw_rev),    bswap);
-	ide_fixstring(id->serial_no, sizeof(id->serial_no), bswap);
+
+	ide_fixstring(m, ATA_ID_PROD_LEN, bswap);
+	ide_fixstring((char *)&id[ATA_ID_FW_REV], ATA_ID_FW_REV_LEN, bswap);
+	ide_fixstring((char *)&id[ATA_ID_SERNO], ATA_ID_SERNO_LEN, bswap);
 
 	/* we depend on this a lot! */
-	id->model[sizeof(id->model)-1] = '\0';
+	m[ATA_ID_PROD_LEN - 1] = '\0';
 
-	if (strstr(id->model, "E X A B Y T E N E S T"))
+	if (strstr(m, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-	printk(KERN_INFO "%s: %s, ", drive->name, id->model);
+	printk(KERN_INFO "%s: %s, ", drive->name, m);
 
 	drive->present = 1;
 	drive->dead = 0;
@@ -163,16 +159,16 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	/*
 	 * Check for an ATAPI device
 	 */
-	if (cmd == WIN_PIDENTIFY) {
-		u8 type = (id->config >> 8) & 0x1f;
+	if (cmd == ATA_CMD_ID_ATAPI) {
+		u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
 		printk(KERN_CONT "ATAPI ");
 		switch (type) {
 			case ide_floppy:
-				if (!strstr(id->model, "CD-ROM")) {
-					if (!strstr(id->model, "oppy") &&
-					    !strstr(id->model, "poyp") &&
-					    !strstr(id->model, "ZIP"))
+				if (!strstr(m, "CD-ROM")) {
+					if (!strstr(m, "oppy") &&
+					    !strstr(m, "poyp") &&
+					    !strstr(m, "ZIP"))
 						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
 						printk(KERN_CONT "FLOPPY");
@@ -186,8 +182,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 				drive->removable = 1;
 #ifdef CONFIG_PPC
 				/* kludge for Apple PowerBook internal zip */
-				if (!strstr(id->model, "CD-ROM") &&
-				    strstr(id->model, "ZIP")) {
+				if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
 					printk(KERN_CONT "FLOPPY");
 					type = ide_floppy;
 					break;
@@ -217,18 +212,15 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	 * Not an ATAPI device: looks like a "regular" hard disk
 	 */
 
-	/*
-	 * 0x848a = CompactFlash device
-	 * These are *not* removable in Linux definition of the term
-	 */
+	is_cfa = ata_id_is_cfa(id);
 
-	if ((id->config != 0x848a) && (id->config & (1<<7)))
+	/* CF devices are *not* removable in Linux definition of the term */
+	if (is_cfa == 0 && (id[ATA_ID_CONFIG] & (1 << 7)))
 		drive->removable = 1;
 
 	drive->media = ide_disk;
 
-	printk(KERN_CONT "%s DISK drive\n",
-		(id->config == 0x848a) ? "CFA" : "ATA");
+	printk(KERN_CONT "%s DISK drive\n", is_cfa ? "CFA" : "ATA");
 
 	return;
 
@@ -268,7 +260,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	if (io_ports->ctl_addr) {
 		a = tp_ops->read_altstatus(hwif);
 		s = tp_ops->read_status(hwif);
-		if ((a ^ s) & ~INDEX_STAT)
+		if ((a ^ s) & ~ATA_IDX)
 			/* ancient Seagate drives, broken interfaces */
 			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
 					 "instead of ALTSTATUS(0x%02x)\n",
@@ -281,7 +273,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	/* set features register for atapi
 	 * identify command to be sure of reply
 	 */
-	if (cmd == WIN_PIDENTIFY) {
+	if (cmd == ATA_CMD_ID_ATAPI) {
 		ide_task_t task;
 
 		memset(&task, 0, sizeof(task));
@@ -294,24 +286,16 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	/* ask drive for ID */
 	tp_ops->exec_command(hwif, cmd);
 
-	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
-	timeout += jiffies;
-	do {
-		if (time_after(jiffies, timeout)) {
-			/* drive timed-out */
-			return 1;
-		}
-		/* give drive a breather */
-		msleep(50);
-		s = use_altstatus ? tp_ops->read_altstatus(hwif)
-				  : tp_ops->read_status(hwif);
-	} while (s & BUSY_STAT);
+	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 
-	/* wait for IRQ and DRQ_STAT */
+	if (ide_busy_sleep(hwif, timeout, use_altstatus))
+		return 1;
+
+	/* wait for IRQ and ATA_DRQ */
 	msleep(50);
 	s = tp_ops->read_status(hwif);
 
-	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
+	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
 		unsigned long flags;
 
 		/* local CPU only; some systems need this */
@@ -387,19 +371,21 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 	return retval;
 }
 
-static int ide_busy_sleep(ide_hwif_t *hwif)
+int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 {
-	unsigned long timeout = jiffies + WAIT_WORSTCASE;
 	u8 stat;
 
+	timeout += jiffies;
+
 	do {
-		msleep(50);
-		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0)
+		msleep(50);	/* give drive a breather */
+		stat = altstatus ? hwif->tp_ops->read_altstatus(hwif)
+				 : hwif->tp_ops->read_status(hwif);
+		if ((stat & ATA_BUSY) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
 
-	return 1;
+	return 1;	/* drive timed-out */
 }
 
 static u8 ide_read_device(ide_drive_t *drive)
@@ -444,13 +430,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 
 	if (drive->present) {
 		/* avoid waiting for inappropriate probes */
-		if ((drive->media != ide_disk) && (cmd == WIN_IDENTIFY))
+		if (drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
 			return 4;
 	}
 #ifdef DEBUG
 	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, drive->present, drive->media,
-		(cmd == WIN_IDENTIFY) ? "ATA" : "ATAPI");
+		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
 
 	/* needed for some systems
@@ -464,7 +450,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
-			/* allow BUSY_STAT to assert & clear */
+			/* allow ATA_BUSY to assert & clear */
 			msleep(50);
 		}
 		/* no i/f present: mmm.. this should be a 4 -ml */
@@ -473,8 +459,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 
 	stat = tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
-	    drive->present || cmd == WIN_PIDENTIFY) {
+	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
+	    drive->present || cmd == ATA_CMD_ID_ATAPI) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
 			/* failed: try again */
@@ -483,17 +469,17 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 
 		stat = tp_ops->read_status(hwif);
 
-		if (stat == (BUSY_STAT | READY_STAT))
+		if (stat == (ATA_BUSY | ATA_DRDY))
 			return 4;
 
-		if (rc == 1 && cmd == WIN_PIDENTIFY) {
+		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			tp_ops->exec_command(hwif, WIN_SRST);
-			(void)ide_busy_sleep(hwif);
+			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
+			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
 			rc = try_to_identify(drive, cmd);
 		}
 
@@ -526,13 +512,14 @@ static void enable_nest (ide_drive_t *drive)
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-	printk(KERN_INFO "%s: enabling %s -- ", hwif->name, drive->id->model);
+	printk(KERN_INFO "%s: enabling %s -- ",
+		hwif->name, (char *)&drive->id[ATA_ID_PROD]);
 
 	SELECT_DRIVE(drive);
 	msleep(50);
-	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
+	tp_ops->exec_command(hwif, ATA_EXABYTE_ENABLE_NEST);
 
-	if (ide_busy_sleep(hwif)) {
+	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 0)) {
 		printk(KERN_CONT "failed (timeout)\n");
 		return;
 	}
@@ -545,12 +532,6 @@ static void enable_nest (ide_drive_t *drive)
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
 	else
 		printk(KERN_CONT "success\n");
-
-	/* if !(success||timed-out) */
-	if (do_probe(drive, WIN_IDENTIFY) >= 2) {
-		/* look for ATAPI device */
-		(void) do_probe(drive, WIN_PIDENTIFY);
-	}
 }
 
 /**
@@ -567,6 +548,8 @@ static void enable_nest (ide_drive_t *drive)
  
 static inline u8 probe_for_drive (ide_drive_t *drive)
 {
+	char *m;
+
 	/*
 	 *	In order to keep things simple we have an id
 	 *	block for all drives at all times. If the device
@@ -576,29 +559,34 @@ static inline u8 probe_for_drive (ide_drive_t *drive)
 	 *	Also note that 0 everywhere means "can't do X"
 	 */
  
-	drive->id = kzalloc(SECTOR_WORDS *4, GFP_KERNEL);
+	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
 	drive->id_read = 0;
 	if(drive->id == NULL)
 	{
 		printk(KERN_ERR "ide: out of memory for id data.\n");
 		return 0;
 	}
-	strcpy(drive->id->model, "UNKNOWN");
-	
+
+	m = (char *)&drive->id[ATA_ID_PROD];
+	strcpy(m, "UNKNOWN");
+
 	/* skip probing? */
-	if (!drive->noprobe)
-	{
+	if (!drive->noprobe) {
+retry:
 		/* if !(success||timed-out) */
-		if (do_probe(drive, WIN_IDENTIFY) >= 2) {
+		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
-			(void) do_probe(drive, WIN_PIDENTIFY);
-		}
+			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
+
 		if (!drive->present)
 			/* drive not found */
 			return 0;
-		if (strstr(drive->id->model, "E X A B Y T E N E S T"))
+
+		if (strstr(m, "E X A B Y T E N E S T")) {
 			enable_nest(drive);
-	
+			goto retry;
+		}
+
 		/* identification failed? */
 		if (!drive->id_read) {
 			if (drive->media == ide_disk) {
@@ -740,36 +728,38 @@ out:
 
 /**
  *	ide_undecoded_slave	-	look for bad CF adapters
- *	@drive1: drive
+ *	@dev1: slave device
  *
  *	Analyse the drives on the interface and attempt to decide if we
  *	have the same drive viewed twice. This occurs with crap CF adapters
  *	and PCMCIA sometimes.
  */
 
-void ide_undecoded_slave(ide_drive_t *drive1)
+void ide_undecoded_slave(ide_drive_t *dev1)
 {
-	ide_drive_t *drive0 = &drive1->hwif->drives[0];
+	ide_drive_t *dev0 = &dev1->hwif->drives[0];
 
-	if ((drive1->dn & 1) == 0 || drive0->present == 0)
+	if ((dev1->dn & 1) == 0 || dev0->present == 0)
 		return;
 
 	/* If the models don't match they are not the same product */
-	if (strcmp(drive0->id->model, drive1->id->model))
+	if (strcmp((char *)&dev0->id[ATA_ID_PROD],
+		   (char *)&dev1->id[ATA_ID_PROD]))
 		return;
 
 	/* Serial numbers do not match */
-	if (strncmp(drive0->id->serial_no, drive1->id->serial_no, 20))
+	if (strncmp((char *)&dev0->id[ATA_ID_SERNO],
+		    (char *)&dev1->id[ATA_ID_SERNO], ATA_ID_SERNO_LEN))
 		return;
 
 	/* No serial number, thankfully very rare for CF */
-	if (drive0->id->serial_no[0] == 0)
+	if (*(char *)&dev0->id[ATA_ID_SERNO] == 0)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
 	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
 
-	drive1->present = 0;
+	dev1->present = 0;
 }
 
 EXPORT_SYMBOL_GPL(ide_undecoded_slave);
@@ -853,7 +843,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
 			drive->no_io_32bit = 1;
 		else
-			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
+			drive->no_io_32bit = drive->id[ATA_ID_DWORD_IO] ? 1 : 0;
 	}
 }
 
@@ -1037,11 +1027,6 @@ static int init_irq (ide_hwif_t *hwif)
 	ide_hwgroup_t *hwgroup;
 	ide_hwif_t *match = NULL;
 
-
-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());	
-	BUG_ON(hwif == NULL);
-
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
 #if MAX_HWIFS > 1
@@ -1116,7 +1101,8 @@ static int init_irq (ide_hwif_t *hwif)
 		sa = IRQF_SHARED;
 #endif /* __mc68000__ */
 
-		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
+		if (hwif->chipset == ide_pci || hwif->chipset == ide_cmd646 ||
+		    hwif->chipset == ide_ali14xx)
 			sa = IRQF_SHARED;
 
 		if (io_ports->ctl_addr)
@@ -1344,8 +1330,6 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 		if (!drive->present)
 			continue;
 
-		ide_add_generic_settings(drive);
-
 		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
@@ -1602,8 +1586,10 @@ struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
 	if (hws[0])
 		host->dev[0] = hws[0]->dev;
 
-	if (d)
+	if (d) {
+		host->init_chipset = d->init_chipset;
 		host->host_flags = d->host_flags;
+	}
 
 	return host;
 }
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index f66c9c3..e7030a4 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -12,14 +12,6 @@
  * "settings" files.  e.g.    "cat /proc/ide0/hda/settings"
  * To write a new value "val" into a specific setting "name", use:
  *   echo "name:val" >/proc/ide/ide0/hda/settings
- *
- * Also useful, "cat /proc/ide0/hda/[identify, smart_values,
- * smart_thresholds, capabilities]" will issue an IDENTIFY /
- * PACKET_IDENTIFY / SMART_READ_VALUES / SMART_READ_THRESHOLDS /
- * SENSE CAPABILITIES command to /dev/hda, and then dump out the
- * returned data as 256 16-bit words.  The "hdparm" utility will
- * be updated someday soon to use this mechanism.
- *
  */
 
 #include <linux/module.h>
@@ -31,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/ctype.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/seq_file.h>
 
@@ -109,13 +100,14 @@ static int proc_ide_read_identify
 
 		err = taskfile_lib_get_identify(drive, page);
 		if (!err) {
-			char *out = ((char *)page) + (SECTOR_WORDS * 4);
+			char *out = (char *)page + SECTOR_SIZE;
+
 			page = out;
 			do {
 				out += sprintf(out, "%04x%c",
 					le16_to_cpup(val), (++i & 7) ? ' ' : '\n');
 				val += 1;
-			} while (i < (SECTOR_WORDS * 2));
+			} while (i < SECTOR_SIZE / 2);
 			len = out - page;
 		}
 	}
@@ -123,140 +115,25 @@ static int proc_ide_read_identify
 }
 
 /**
- *	__ide_add_setting	-	add an ide setting option
- *	@drive: drive to use
- *	@name: setting name
- *	@rw: true if the function is read write
- *	@data_type: type of data
- *	@min: range minimum
- *	@max: range maximum
- *	@mul_factor: multiplication scale
- *	@div_factor: divison scale
- *	@data: private data field
- *	@set: setting
- *	@auto_remove: setting auto removal flag
- *
- *	Removes the setting named from the device if it is present.
- *	The function takes the settings_lock to protect against
- *	parallel changes. This function must not be called from IRQ
- *	context. Returns 0 on success or -1 on failure.
- *
- *	BUGS: This code is seriously over-engineered. There is also
- *	magic about how the driver specific features are setup. If
- *	a driver is attached we assume the driver settings are auto
- *	remove.
- */
-
-static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
-{
-	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
-
-	mutex_lock(&ide_setting_mtx);
-	while ((*p) && strcmp((*p)->name, name) < 0)
-		p = &((*p)->next);
-	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
-		goto abort;
-	if ((setting->name = kmalloc(strlen(name) + 1, GFP_KERNEL)) == NULL)
-		goto abort;
-	strcpy(setting->name, name);
-	setting->rw = rw;
-	setting->data_type = data_type;
-	setting->min = min;
-	setting->max = max;
-	setting->mul_factor = mul_factor;
-	setting->div_factor = div_factor;
-	setting->data = data;
-	setting->set = set;
-
-	setting->next = *p;
-	if (auto_remove)
-		setting->auto_remove = 1;
-	*p = setting;
-	mutex_unlock(&ide_setting_mtx);
-	return 0;
-abort:
-	mutex_unlock(&ide_setting_mtx);
-	kfree(setting);
-	return -1;
-}
-
-int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
-{
-	return __ide_add_setting(drive, name, rw, data_type, min, max, mul_factor, div_factor, data, set, 1);
-}
-
-EXPORT_SYMBOL(ide_add_setting);
-
-/**
- *	__ide_remove_setting	-	remove an ide setting option
- *	@drive: drive to use
- *	@name: setting name
- *
- *	Removes the setting named from the device if it is present.
- *	The caller must hold the setting semaphore.
- */
-
-static void __ide_remove_setting(ide_drive_t *drive, char *name)
-{
-	ide_settings_t **p, *setting;
-
-	p = (ide_settings_t **) &drive->settings;
-
-	while ((*p) && strcmp((*p)->name, name))
-		p = &((*p)->next);
-	setting = (*p);
-	if (setting == NULL)
-		return;
-
-	(*p) = setting->next;
-
-	kfree(setting->name);
-	kfree(setting);
-}
-
-/**
- *	auto_remove_settings	-	remove driver specific settings
- *	@drive: drive
- *
- *	Automatically remove all the driver specific settings for this
- *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_mtx.
- */
-
-static void auto_remove_settings(ide_drive_t *drive)
-{
-	ide_settings_t *setting;
-repeat:
-	setting = drive->settings;
-	while (setting) {
-		if (setting->auto_remove) {
-			__ide_remove_setting(drive, setting->name);
-			goto repeat;
-		}
-		setting = setting->next;
-	}
-}
-
-/**
- *	ide_find_setting_by_name	-	find a drive specific setting
- *	@drive: drive to scan
+ *	ide_find_setting	-	find a specific setting
+ *	@st: setting table pointer
  *	@name: setting name
  *
- *	Scan's the device setting table for a matching entry and returns
+ *	Scan's the setting table for a matching entry and returns
  *	this or NULL if no entry is found. The caller must hold the
  *	setting semaphore
  */
 
-static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
+static
+const struct ide_proc_devset *ide_find_setting(const struct ide_proc_devset *st,
+					       char *name)
 {
-	ide_settings_t *setting = drive->settings;
-
-	while (setting) {
-		if (strcmp(setting->name, name) == 0)
+	while (st->name) {
+		if (strcmp(st->name, name) == 0)
 			break;
-		setting = setting->next;
+		st++;
 	}
-	return setting;
+	return st->name ? st : NULL;
 }
 
 /**
@@ -272,26 +149,20 @@ static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
  *	be told apart
  */
 
-static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
+static int ide_read_setting(ide_drive_t *drive,
+			    const struct ide_proc_devset *setting)
 {
-	int		val = -EINVAL;
-	unsigned long	flags;
+	const struct ide_devset *ds = setting->setting;
+	int val = -EINVAL;
+
+	if (ds->get) {
+		unsigned long flags;
 
-	if ((setting->rw & SETTING_READ)) {
 		spin_lock_irqsave(&ide_lock, flags);
-		switch (setting->data_type) {
-		case TYPE_BYTE:
-			val = *((u8 *) setting->data);
-			break;
-		case TYPE_SHORT:
-			val = *((u16 *) setting->data);
-			break;
-		case TYPE_INT:
-			val = *((u32 *) setting->data);
-			break;
-		}
+		val = ds->get(drive);
 		spin_unlock_irqrestore(&ide_lock, flags);
 	}
+
 	return val;
 }
 
@@ -313,33 +184,23 @@ static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
  *	The current scheme of polling is kludgy, though safe enough.
  */
 
-static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int val)
+static int ide_write_setting(ide_drive_t *drive,
+			     const struct ide_proc_devset *setting, int val)
 {
+	const struct ide_devset *ds = setting->setting;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (setting->set)
-		return setting->set(drive, val);
-	if (!(setting->rw & SETTING_WRITE))
+	if (!ds->set)
 		return -EPERM;
-	if (val < setting->min || val > setting->max)
+	if ((ds->flags & DS_SYNC)
+	    && (val < setting->min || val > setting->max))
 		return -EINVAL;
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
-	switch (setting->data_type) {
-	case TYPE_BYTE:
-		*((u8 *) setting->data) = val;
-		break;
-	case TYPE_SHORT:
-		*((u16 *) setting->data) = val;
-		break;
-	case TYPE_INT:
-		*((u32 *) setting->data) = val;
-		break;
-	}
-	spin_unlock_irq(&ide_lock);
-	return 0;
+	return ide_devset_execute(drive, ds, val);
 }
 
+ide_devset_get(xfer_rate, current_speed);
+
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
 	ide_task_t task;
@@ -349,7 +210,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 		return -EINVAL;
 
 	memset(&task, 0, sizeof(task));
-	task.tf.command = WIN_SETFEATURES;
+	task.tf.command = ATA_CMD_SET_FEATURES;
 	task.tf.feature = SETFEATURES_XFER;
 	task.tf.nsect   = (u8)arg;
 	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
@@ -364,29 +225,23 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 	return err;
 }
 
-/**
- *	ide_add_generic_settings	-	generic ide settings
- *	@drive: drive being configured
- *
- *	Add the generic parts of the system settings to the /proc files.
- *	The caller must not be holding the ide_setting_mtx.
- */
-
-void ide_add_generic_settings (ide_drive_t *drive)
-{
-/*
- *			  drive		setting name		read/write access				data type	min	max				mul_factor	div_factor	data pointer			set function
- */
-	__ide_add_setting(drive,	"io_32bit",		drive->no_io_32bit ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
-	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		NULL,		0);
-	__ide_add_setting(drive,	"nice1",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
-	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
-	__ide_add_setting(drive,	"unmaskirq",		drive->no_unmask ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			NULL,		0);
-	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
-	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
-	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
-	__ide_add_setting(drive,	"number",		SETTING_RW,					TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
-}
+ide_devset_rw(current_speed, xfer_rate);
+ide_devset_rw_field(init_speed, init_speed);
+ide_devset_rw_field(nice1, nice1);
+ide_devset_rw_field(number, dn);
+
+static const struct ide_proc_devset ide_generic_settings[] = {
+	IDE_PROC_DEVSET(current_speed, 0, 70),
+	IDE_PROC_DEVSET(init_speed, 0, 70),
+	IDE_PROC_DEVSET(io_32bit,  0, 1 + (SUPPORT_VLB_SYNC << 1)),
+	IDE_PROC_DEVSET(keepsettings, 0, 1),
+	IDE_PROC_DEVSET(nice1, 0, 1),
+	IDE_PROC_DEVSET(number, 0, 3),
+	IDE_PROC_DEVSET(pio_mode, 0, 255),
+	IDE_PROC_DEVSET(unmaskirq, 0, 1),
+	IDE_PROC_DEVSET(using_dma, 0, 1),
+	{ 0 },
+};
 
 static void proc_ide_settings_warn(void)
 {
@@ -403,19 +258,32 @@ static void proc_ide_settings_warn(void)
 static int proc_ide_read_settings
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
+	const struct ide_proc_devset *setting, *g, *d;
+	const struct ide_devset *ds;
 	ide_drive_t	*drive = (ide_drive_t *) data;
-	ide_settings_t	*setting = (ide_settings_t *) drive->settings;
 	char		*out = page;
 	int		len, rc, mul_factor, div_factor;
 
 	proc_ide_settings_warn();
 
 	mutex_lock(&ide_setting_mtx);
+	g = ide_generic_settings;
+	d = drive->settings;
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
-	while (setting) {
-		mul_factor = setting->mul_factor;
-		div_factor = setting->div_factor;
+	while (g->name || (d && d->name)) {
+		/* read settings in the alphabetical order */
+		if (g->name && d && d->name) {
+			if (strcmp(d->name, g->name) < 0)
+				setting = d++;
+			else
+				setting = g++;
+		} else if (d && d->name) {
+			setting = d++;
+		} else
+			setting = g++;
+		mul_factor = setting->mulf ? setting->mulf(drive) : 1;
+		div_factor = setting->divf ? setting->divf(drive) : 1;
 		out += sprintf(out, "%-24s", setting->name);
 		rc = ide_read_setting(drive, setting);
 		if (rc >= 0)
@@ -423,12 +291,12 @@ static int proc_ide_read_settings
 		else
 			out += sprintf(out, "%-16s", "write-only");
 		out += sprintf(out, "%-16d%-16d", (setting->min * mul_factor + div_factor - 1) / div_factor, setting->max * mul_factor / div_factor);
-		if (setting->rw & SETTING_READ)
+		ds = setting->setting;
+		if (ds->get)
 			out += sprintf(out, "r");
-		if (setting->rw & SETTING_WRITE)
+		if (ds->set)
 			out += sprintf(out, "w");
 		out += sprintf(out, "\n");
-		setting = setting->next;
 	}
 	len = out - page;
 	mutex_unlock(&ide_setting_mtx);
@@ -442,9 +310,10 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
 	char		name[MAX_LEN + 1];
-	int		for_real = 0;
+	int		for_real = 0, mul_factor, div_factor;
 	unsigned long	n;
-	ide_settings_t	*setting;
+
+	const struct ide_proc_devset *setting;
 	char *buf, *s;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -512,13 +381,21 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 			}
 
 			mutex_lock(&ide_setting_mtx);
-			setting = ide_find_setting_by_name(drive, name);
+			/* generic settings first, then driver specific ones */
+			setting = ide_find_setting(ide_generic_settings, name);
 			if (!setting) {
-				mutex_unlock(&ide_setting_mtx);
-				goto parse_error;
+				if (drive->settings)
+					setting = ide_find_setting(drive->settings, name);
+				if (!setting) {
+					mutex_unlock(&ide_setting_mtx);
+					goto parse_error;
+				}
+			}
+			if (for_real) {
+				mul_factor = setting->mulf ? setting->mulf(drive) : 1;
+				div_factor = setting->divf ? setting->divf(drive) : 1;
+				ide_write_setting(drive, setting, val * div_factor / mul_factor);
 			}
-			if (for_real)
-				ide_write_setting(drive, setting, val * setting->div_factor / setting->mul_factor);
 			mutex_unlock(&ide_setting_mtx);
 		}
 	} while (!for_real++);
@@ -561,11 +438,10 @@ static int proc_ide_read_dmodel
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
-	struct hd_driveid *id = drive->id;
+	char		*m = (char *)&drive->id[ATA_ID_PROD];
 	int		len;
 
-	len = sprintf(page, "%.40s\n",
-		(id && id->model[0]) ? (char *)id->model : "(none)");
+	len = sprintf(page, "%.40s\n", m[0] ? m : "(none)");
 	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
@@ -690,6 +566,10 @@ static void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t
 
 void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
 {
+	mutex_lock(&ide_setting_mtx);
+	drive->settings = driver->settings;
+	mutex_unlock(&ide_setting_mtx);
+
 	ide_add_proc_entries(drive->proc, driver->proc, drive);
 }
 
@@ -726,7 +606,7 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 	 * OTOH both ide_{read,write}_setting are only ever used under
 	 * ide_setting_mtx.
 	 */
-	auto_remove_settings(drive);
+	drive->settings = NULL;
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3833189..f8c84df 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -15,6 +15,8 @@
  * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
+#define DRV_NAME "ide-tape"
+
 #define IDETAPE_VERSION "1.20"
 
 #include <linux/module.h>
@@ -54,8 +56,6 @@ enum {
 	DBG_CHRDEV =		(1 << 2),
 	/* all remaining procedures */
 	DBG_PROCS =		(1 << 3),
-	/* buffer alloc info (pc_stack & rq_stack) */
-	DBG_PCRQ_STACK =	(1 << 4),
 };
 
 /* define to see debug info */
@@ -81,26 +81,6 @@ enum {
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- * With each packet command, we allocate a buffer of IDETAPE_PC_BUFFER_SIZE
- * bytes. This is used for several packet commands (Not for READ/WRITE commands)
- */
-#define IDETAPE_PC_BUFFER_SIZE		256
-
-/*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
- */
-#define IDETAPE_PC_STACK		(10 + IDETAPE_MAX_PC_RETRIES)
-
-/*
- * Some drives (for example, Seagate STT3401A Travan) require a very long
- * timeout, because they don't return an interrupt or clear their busy bit
- * until after the command completes (even retension commands).
- */
-#define IDETAPE_WAIT_CMD		(900*HZ)
-
-/*
  * The following parameter is used to select the point in the internal tape fifo
  * in which we will start to refill the buffer. Decreasing the following
  * parameter will improve the system's latency and interactive response, while
@@ -172,20 +152,6 @@ struct idetape_bh {
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
-/*
- * Special requests for our block device strategy routine.
- *
- * In order to service a character device command, we add special requests to
- * the tail of our block device request queue and wait for their completion.
- */
-
-enum {
-	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
-	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
-	REQ_IDETAPE_READ	= (1 << 2),
-	REQ_IDETAPE_WRITE	= (1 << 3),
-};
-
 /* Error codes returned in rq->errors to the higher part of the driver. */
 #define IDETAPE_ERROR_GENERAL		101
 #define IDETAPE_ERROR_FILEMARK		102
@@ -206,13 +172,6 @@ typedef struct ide_tape_obj {
 	struct kref	kref;
 
 	/*
-	 *	Since a typical character device operation requires more
-	 *	than one packet command, we provide here enough memory
-	 *	for the maximum of interconnected packet commands.
-	 *	The packet commands are stored in the circular array pc_stack.
-	 *	pc_stack_index points to the last used entry, and warps around
-	 *	to the start when we get to the last array entry.
-	 *
 	 *	pc points to the current processed packet command.
 	 *
 	 *	failed_pc points to the last failed packet command, or contains
@@ -224,13 +183,11 @@ typedef struct ide_tape_obj {
 	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
-	/* Packet command stack */
-	struct ide_atapi_pc pc_stack[IDETAPE_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
-	struct request rq_stack[IDETAPE_PC_STACK];
-	/* We implement a circular array */
-	int rq_stack_index;
+	/* used by REQ_IDETAPE_{READ,WRITE} requests */
+	struct ide_atapi_pc queued_pc;
+
+	struct ide_atapi_pc request_sense_pc;
+	struct request request_sense_rq;
 
 	/*
 	 * DSC polling variables.
@@ -451,47 +408,6 @@ static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 }
 
 /*
- *	idetape_next_pc_storage returns a pointer to a place in which we can
- *	safely store a packet command, even though we intend to leave the
- *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
- *	commands is allocated at initialization time.
- */
-static struct ide_atapi_pc *idetape_next_pc_storage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
-
-	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index = 0;
-	return (&tape->pc_stack[tape->pc_stack_index++]);
-}
-
-/*
- *	idetape_next_rq_storage is used along with idetape_next_pc_storage.
- *	Since we queue packet commands in the request queue, we need to
- *	allocate a request, along with the allocation of a packet command.
- */
-
-/**************************************************************
- *                                                            *
- *  This should get fixed to use kmalloc(.., GFP_ATOMIC)      *
- *  followed later on by kfree().   -ml                       *
- *                                                            *
- **************************************************************/
-
-static struct request *idetape_next_rq_storage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
-
-	if (tape->rq_stack_index == IDETAPE_PC_STACK)
-		tape->rq_stack_index = 0;
-	return (&tape->rq_stack[tape->rq_stack_index++]);
-}
-
-/*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
@@ -667,61 +583,14 @@ static void ide_tape_callback(ide_drive_t *drive)
 	idetape_end_request(drive, uptodate, 0);
 }
 
-static void idetape_init_pc(struct ide_atapi_pc *pc)
-{
-	memset(pc->c, 0, 12);
-	pc->retries = 0;
-	pc->flags = 0;
-	pc->req_xfer = 0;
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
-	pc->bh = NULL;
-	pc->b_data = NULL;
-}
-
 static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->req_xfer = 20;
 }
 
-static void idetape_init_rq(struct request *rq, u8 cmd)
-{
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[13] = cmd;
-}
-
-/*
- * Generate a new packet command request in front of the request queue, before
- * the current request, so that it will be processed immediately, on the next
- * pass through the driver. The function below is called from the request
- * handling part of the driver (the "bottom" part). Safe storage for the request
- * should be allocated with ide_tape_next_{pc,rq}_storage() prior to that.
- *
- * Memory for those requests is pre-allocated at initialization time, and is
- * limited to IDETAPE_PC_STACK requests. We assume that we have enough space for
- * the maximum possible number of inter-dependent packet commands.
- *
- * The higher level of the driver - The ioctl handler and the character device
- * handling functions should queue request to the lower level part and wait for
- * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
- */
-static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  struct request *rq)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-
-	idetape_init_rq(rq, REQ_IDETAPE_PC1);
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->buffer = (char *) pc;
-	rq->rq_disk = tape->disk;
-	memcpy(rq->cmd, pc->c, 12);
-	ide_do_drive_cmd(drive, rq);
-}
-
 /*
  *	idetape_retry_pc is called when an error was detected during the
  *	last packet command. We queue a request sense packet command in
@@ -729,15 +598,14 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
  */
 static void idetape_retry_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *pc;
-	struct request *rq;
+	struct ide_tape_obj *tape = drive->driver_data;
+	struct request *rq = &tape->request_sense_rq;
+	struct ide_atapi_pc *pc = &tape->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	pc = idetape_next_pc_storage(drive);
-	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	idetape_queue_pc_head(drive, pc, rq);
+	ide_queue_pc_head(drive, tape->disk, pc, rq);
 }
 
 /*
@@ -766,13 +634,15 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
 	idetape_postpone_request(drive);
 }
 
-static void ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				unsigned int bcount, int write)
 {
 	if (write)
 		idetape_output_buffers(drive, pc, bcount);
 	else
 		idetape_input_buffers(drive, pc, bcount);
+
+	return bcount;
 }
 
 /*
@@ -786,7 +656,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, IDETAPE_WAIT_CMD,
+	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, WAIT_TAPE_CMD,
 			   NULL, idetape_update_buffers, idetape_retry_pc,
 			   ide_tape_handle_dsc, ide_tape_io_buffers);
 }
@@ -832,7 +702,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 
 	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
-			       IDETAPE_WAIT_CMD, NULL);
+			       WAIT_TAPE_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
@@ -881,13 +751,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 	pc->retries++;
 
 	return ide_issue_pc(drive, pc, idetape_transfer_pc,
-			    IDETAPE_WAIT_CMD, NULL);
+			    WAIT_TAPE_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
 static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
 		/* DBD = 1 - Don't return block descriptors */
@@ -920,8 +790,8 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (stat & SEEK_STAT) {
-		if (stat & ERR_STAT) {
+	if (stat & ATA_DSC) {
+		if (stat & ATA_ERR) {
 			/* Error detected */
 			if (pc->c[0] != TEST_UNIT_READY)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
@@ -946,7 +816,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
 	unsigned int length = rq->current_nr_sectors;
 
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->bh = bh;
@@ -978,9 +848,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
-			" current_nr_sectors: %d\n",
-			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
+			" current_nr_sectors: %u\n",
+			(unsigned long long)rq->sector, rq->nr_sectors,
+			rq->current_nr_sectors);
 
 	if (!blk_special_request(rq)) {
 		/* We do not support buffer cache originated requests. */
@@ -1021,7 +892,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 
 	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
-	    (stat & SEEK_STAT) == 0) {
+	    (stat & ATA_DSC) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
@@ -1043,12 +914,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
-		pc = idetape_next_pc_storage(drive);
+		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
-		pc = idetape_next_pc_storage(drive);
+		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
 		goto out;
 	}
@@ -1235,77 +1106,30 @@ static void idetape_init_merge_buffer(idetape_tape_t *tape)
 static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc, int write_filemark)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
-{
-	idetape_init_pc(pc);
-	pc->c[0] = TEST_UNIT_READY;
-}
-
-/*
- * We add a special packet command request to the tail of the request queue, and
- * wait for it to be serviced. This is not to be called from within the request
- * handling part of the driver! We allocate here data on the stack and it is
- * valid until the request is finished. This is not the case for the bottom part
- * of the driver, where we are always leaving the functions to wait for an
- * interrupt or a timer event.
- *
- * From the bottom part of the driver, we should allocate safe memory using
- * idetape_next_pc_storage() and ide_tape_next_rq_storage(), and add the request
- * to the request list without waiting for it to be serviced! In that case, we
- * usually use idetape_queue_pc_head().
- */
-static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-	struct request *rq;
-	int error;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[13] = REQ_IDETAPE_PC1;
-	rq->buffer = (char *)pc;
-	memcpy(rq->cmd, pc->c, 12);
-	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
-	blk_put_request(rq);
-	return error;
-}
-
-static void idetape_create_load_unload_cmd(ide_drive_t *drive,
-		struct ide_atapi_pc *pc, int cmd)
-{
-	idetape_init_pc(pc);
-	pc->c[0] = START_STOP;
-	pc->c[4] = cmd;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-}
-
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc pc;
+	struct gendisk *disk = tape->disk;
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
 	set_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
-		idetape_create_test_unit_ready_cmd(&pc);
-		if (!idetape_queue_pc_tail(drive, &pc))
+		if (ide_do_test_unit_ready(drive, disk) == 0)
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
 		    || (tape->asc == 0x3A)) {
 			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc,
-							IDETAPE_LU_LOAD_MASK);
-			idetape_queue_pc_tail(drive, &pc);
+			ide_do_start_stop(drive, disk, IDETAPE_LU_LOAD_MASK);
 			load_attempted = 1;
 		/* not about to be ready */
 		} else if (!(tape->sense_key == 2 && tape->asc == 4 &&
@@ -1318,11 +1142,12 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 
 static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	rc = idetape_queue_pc_tail(drive, &pc);
+	rc = ide_queue_pc_tail(drive, tape->disk, &pc);
 	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
@@ -1331,7 +1156,7 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 
 static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = READ_POSITION;
 	pc->req_xfer = 20;
 }
@@ -1345,7 +1170,7 @@ static int idetape_read_position(ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
-	if (idetape_queue_pc_tail(drive, &pc))
+	if (ide_queue_pc_tail(drive, tape->disk, &pc))
 		return -1;
 	position = tape->first_frame;
 	return position;
@@ -1355,7 +1180,7 @@ static void idetape_create_locate_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc,
 		unsigned int block, u8 partition, int skip)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
@@ -1363,21 +1188,6 @@ static void idetape_create_locate_cmd(ide_drive_t *drive,
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-static int idetape_create_prevent_cmd(ide_drive_t *drive,
-		struct ide_atapi_pc *pc, int prevent)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	/* device supports locking according to capabilities page */
-	if (!(tape->caps[6] & 0x01))
-		return 0;
-
-	idetape_init_pc(pc);
-	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
-	pc->c[4] = prevent;
-	return 1;
-}
-
 static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1405,6 +1215,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		u8 partition, int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	int retval;
 	struct ide_atapi_pc pc;
 
@@ -1412,12 +1223,12 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return (retval);
 
 	idetape_create_read_position_cmd(&pc);
-	return (idetape_queue_pc_tail(drive, &pc));
+	return ide_queue_pc_tail(drive, disk, &pc);
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -1477,7 +1288,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
 	pc->req_xfer = 254;
@@ -1486,14 +1297,14 @@ static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 static void idetape_create_rewind_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
 static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
@@ -1501,7 +1312,7 @@ static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 
 static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
@@ -1664,20 +1475,20 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
  */
 static int idetape_rewind_tape(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	int retval;
 	struct ide_atapi_pc pc;
-	idetape_tape_t *tape;
-	tape = drive->driver_data;
 
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return retval;
 
 	idetape_create_read_position_cmd(&pc);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return retval;
 	return 0;
@@ -1720,6 +1531,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	struct ide_atapi_pc pc;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
@@ -1744,7 +1556,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	case MTBSF:
 		idetape_create_space_cmd(&pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTFSFM:
 	case MTBSFM:
 		if (!sprev)
@@ -1933,11 +1745,12 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 static int idetape_write_filemark(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
@@ -1960,6 +1773,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	struct ide_atapi_pc pc;
 	int i, retval;
 
@@ -1996,9 +1810,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		return 0;
 	case MTLOAD:
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
-					       IDETAPE_LU_LOAD_MASK);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_do_start_stop(drive, disk, IDETAPE_LU_LOAD_MASK);
 	case MTUNLOAD:
 	case MTOFFL:
 		/*
@@ -2006,14 +1818,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		 * attempting to eject.
 		 */
 		if (tape->door_locked) {
-			if (idetape_create_prevent_cmd(drive, &pc, 0))
-				if (!idetape_queue_pc_tail(drive, &pc))
-					tape->door_locked = DOOR_UNLOCKED;
+			if (!ide_set_media_lock(drive, disk, 0))
+				tape->door_locked = DOOR_UNLOCKED;
 		}
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
-					      !IDETAPE_LU_LOAD_MASK);
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_do_start_stop(drive, disk, !IDETAPE_LU_LOAD_MASK);
 		if (!retval)
 			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 		return retval;
@@ -2022,16 +1831,15 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
+		return ide_do_start_stop(drive, disk,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-		return idetape_queue_pc_tail(drive, &pc);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
 		idetape_create_erase_cmd(&pc);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTSETBLK:
 		if (mt_count) {
 			if (mt_count < tape->blk_size ||
@@ -2052,17 +1860,13 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	case MTFSR:
 	case MTBSR:
 	case MTLOCK:
-		if (!idetape_create_prevent_cmd(drive, &pc, 1))
-			return 0;
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_set_media_lock(drive, disk, 1);
 		if (retval)
 			return retval;
 		tape->door_locked = DOOR_EXPLICITLY_LOCKED;
 		return 0;
 	case MTUNLOCK:
-		if (!idetape_create_prevent_cmd(drive, &pc, 0))
-			return 0;
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_set_media_lock(drive, disk, 0);
 		if (retval)
 			return retval;
 		tape->door_locked = DOOR_UNLOCKED;
@@ -2144,7 +1948,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -2164,7 +1968,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
-	struct ide_atapi_pc pc;
 	int retval;
 
 	if (i >= MAX_HWIFS * MAX_DRIVES)
@@ -2227,11 +2030,9 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	/* Lock the tape drive door so user can't eject. */
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
-		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
-			if (!idetape_queue_pc_tail(drive, &pc)) {
-				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
-					tape->door_locked = DOOR_LOCKED;
-			}
+		if (!ide_set_media_lock(drive, tape->disk, 1)) {
+			if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
+				tape->door_locked = DOOR_LOCKED;
 		}
 	}
 	unlock_kernel();
@@ -2264,7 +2065,6 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
-	struct ide_atapi_pc pc;
 	unsigned int minor = iminor(inode);
 
 	lock_kernel();
@@ -2283,10 +2083,8 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
-			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
-				if (!idetape_queue_pc_tail(drive, &pc))
-					tape->door_locked = DOOR_UNLOCKED;
-			}
+			if (!ide_set_media_lock(drive, tape->disk, 0))
+				tape->door_locked = DOOR_UNLOCKED;
 		}
 	}
 	clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
@@ -2295,45 +2093,6 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*
- * check the contents of the ATAPI IDENTIFY command results. We return:
- *
- * 1 - If the tape can be supported by us, based on the information we have so
- * far.
- *
- * 0 - If this tape driver is not currently supported by us.
- */
-static int idetape_identify_device(ide_drive_t *drive)
-{
-	u8 gcw[2], protocol, device_type, removable, packet_size;
-
-	if (drive->id_read == 0)
-		return 1;
-
-	*((unsigned short *) &gcw) = drive->id->config;
-
-	protocol	=   (gcw[1] & 0xC0) >> 6;
-	device_type	=    gcw[1] & 0x1F;
-	removable	= !!(gcw[0] & 0x80);
-	packet_size	=    gcw[0] & 0x3;
-
-	/* Check that we can support this device */
-	if (protocol != 2)
-		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
-				protocol);
-	else if (device_type != 1)
-		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
-				"to tape\n", device_type);
-	else if (!removable)
-		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
-	else if (packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12"
-				" bytes\n", packet_size);
-	} else
-		return 1;
-	return 0;
-}
-
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2341,7 +2100,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
 		return;
@@ -2370,7 +2129,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
 		tape->blk_size = 512;
@@ -2402,6 +2161,11 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	}
 
 	memcpy(&tape->caps, caps, 20);
+
+	/* device lacks locking support according to capabilities page */
+	if ((caps[6] & 1) == 0)
+		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
+
 	if (caps[7] & 0x02)
 		tape->blk_size = 512;
 	else if (caps[7] & 0x04)
@@ -2409,28 +2173,56 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idetape_add_settings(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
-			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
-			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive, "buffer_size", SETTING_READ, TYPE_INT, 0, 0xffff,
-			1, 1024, &tape->buffer_size, NULL);
-	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
-			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
-			NULL);
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
-			1, &drive->dsc_overlap, NULL);
-	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
-			1, 1, &tape->avg_speed, NULL);
-	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
-			1, &tape->debug_mask, NULL);
-}
-#else
-static inline void idetape_add_settings(ide_drive_t *drive) { ; }
+#define ide_tape_devset_get(name, field) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	idetape_tape_t *tape = drive->driver_data; \
+	return tape->field; \
+}
+
+#define ide_tape_devset_set(name, field) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	idetape_tape_t *tape = drive->driver_data; \
+	tape->field = arg; \
+	return 0; \
+}
+
+#define ide_tape_devset_rw_field(_name, _field) \
+ide_tape_devset_get(_name, _field) \
+ide_tape_devset_set(_name, _field) \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
+
+#define ide_tape_devset_r_field(_name, _field) \
+ide_tape_devset_get(_name, _field) \
+IDE_DEVSET(_name, 0, get_##_name, NULL)
+
+static int mulf_tdsc(ide_drive_t *drive)	{ return 1000; }
+static int divf_tdsc(ide_drive_t *drive)	{ return   HZ; }
+static int divf_buffer(ide_drive_t *drive)	{ return    2; }
+static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
+
+ide_devset_rw_field(dsc_overlap, dsc_overlap);
+
+ide_tape_devset_rw_field(debug_mask, debug_mask);
+ide_tape_devset_rw_field(tdsc, best_dsc_rw_freq);
+
+ide_tape_devset_r_field(avg_speed, avg_speed);
+ide_tape_devset_r_field(speed, caps[14]);
+ide_tape_devset_r_field(buffer, caps[16]);
+ide_tape_devset_r_field(buffer_size, buffer_size);
+
+static const struct ide_proc_devset idetape_settings[] = {
+	__IDE_PROC_DEVSET(avg_speed,	0, 0xffff, NULL, NULL),
+	__IDE_PROC_DEVSET(buffer,	0, 0xffff, NULL, divf_buffer),
+	__IDE_PROC_DEVSET(buffer_size,	0, 0xffff, NULL, divf_buffer_size),
+	__IDE_PROC_DEVSET(debug_mask,	0, 0xffff, NULL, NULL),
+	__IDE_PROC_DEVSET(dsc_overlap,	0,      1, NULL, NULL),
+	__IDE_PROC_DEVSET(speed,	0, 0xffff, NULL, NULL),
+	__IDE_PROC_DEVSET(tdsc,		IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
+					mulf_tdsc, divf_tdsc),
+	{ 0 },
+};
 #endif
 
 /*
@@ -2462,15 +2254,15 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		drive->dsc_overlap = 0;
 	}
 	/* Seagate Travan drives do not support DSC overlap. */
-	if (strstr(drive->id->model, "Seagate STT3401"))
+	if (strstr((char *)&drive->id[ATA_ID_PROD], "Seagate STT3401"))
 		drive->dsc_overlap = 0;
 	tape->minor = minor;
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
-	tape->pc = tape->pc_stack;
-	*((unsigned short *) &gcw) = drive->id->config;
+
+	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
@@ -2512,7 +2304,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
-	idetape_add_settings(drive);
+	ide_proc_register_driver(drive, tape->driver);
 }
 
 static void ide_tape_remove(ide_drive_t *drive)
@@ -2577,12 +2369,12 @@ static ide_driver_t idetape_driver = {
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.media			= ide_tape,
-	.supports_dsc_overlap 	= 1,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idetape_proc,
+	.settings		= idetape_settings,
 #endif
 };
 
@@ -2645,11 +2437,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	if (!strstr("ide-tape", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_tape)
 		goto failed;
-	if (!idetape_identify_device(drive)) {
+
+	if (drive->id_read == 1 && !ide_check_atapi_device(drive, DRV_NAME)) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
 		goto failed;
@@ -2667,8 +2459,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idetape_driver);
-
 	kref_init(&tape->kref);
 
 	tape->drive = drive;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 7fb6f1c..487b18b 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -44,9 +44,9 @@ int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 	memset(&args, 0, sizeof(ide_task_t));
 	args.tf.nsect = 0x01;
 	if (drive->media == ide_disk)
-		args.tf.command = WIN_IDENTIFY;
+		args.tf.command = ATA_CMD_ID_ATA;
 	else
-		args.tf.command = WIN_PIDENTIFY;
+		args.tf.command = ATA_CMD_ID_ATAPI;
 	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	args.data_phase	= TASKFILE_IN;
 	return ide_raw_taskfile(drive, &args, buf, 1);
@@ -99,12 +99,17 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	case TASKFILE_NO_DATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		/* WIN_{SPECIFY,RESTORE,SETMULT} use custom handlers */
 		if (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) {
 			switch (tf->command) {
-			case WIN_SPECIFY: handler = set_geometry_intr;	break;
-			case WIN_RESTORE: handler = recal_intr;		break;
-			case WIN_SETMULT: handler = set_multmode_intr;	break;
+			case ATA_CMD_INIT_DEV_PARAMS:
+				handler = set_geometry_intr;
+				break;
+			case ATA_CMD_RESTORE:
+				handler = recal_intr;
+				break;
+			case ATA_CMD_SET_MULTI:
+				handler = set_multmode_intr;
+				break;
 			}
 		}
 		ide_execute_command(drive, tf->command, handler,
@@ -121,7 +126,7 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
- * set_multmode_intr() is invoked on completion of a WIN_SETMULT cmd.
+ * set_multmode_intr() is invoked on completion of a ATA_CMD_SET_MULTI cmd.
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
@@ -131,7 +136,7 @@ static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		drive->mult_count = drive->mult_req;
 	else {
 		drive->mult_req = drive->mult_count = 0;
@@ -142,7 +147,7 @@ static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 }
 
 /*
- * set_geometry_intr() is invoked on completion of a WIN_SPECIFY cmd.
+ * set_geometry_intr() is invoked on completion of a ATA_CMD_INIT_DEV_PARAMS cmd.
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
@@ -154,15 +159,15 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 
 	while (1) {
 		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
+		if ((stat & ATA_BUSY) == 0 || retries-- == 0)
 			break;
 		udelay(10);
 	};
 
-	if (OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_stopped;
 
-	if (stat & (ERR_STAT|DRQ_STAT))
+	if (stat & (ATA_ERR | ATA_DRQ))
 		return ide_error(drive, "set_geometry_intr", stat);
 
 	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
@@ -170,7 +175,7 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 }
 
 /*
- * recal_intr() is invoked on completion of a WIN_RESTORE (recalibrate) cmd.
+ * recal_intr() is invoked on completion of a ATA_CMD_RESTORE (recalibrate) cmd.
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
@@ -180,7 +185,7 @@ static ide_startstop_t recal_intr(ide_drive_t *drive)
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
 	return ide_stopped;
 }
@@ -197,7 +202,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
 
@@ -220,13 +225,13 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	for (retries = 0; retries < 1000; retries++) {
 		stat = hwif->tp_ops->read_status(hwif);
 
-		if (stat & BUSY_STAT)
+		if (stat & ATA_BUSY)
 			udelay(10);
 		else
 			break;
 	}
 
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
 
 	return stat;
@@ -385,7 +390,7 @@ void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	/* Command all done? */
-	if (OK_STAT(stat, READY_STAT, BUSY_STAT)) {
+	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY)) {
 		task_end_request(drive, rq, stat);
 		return ide_stopped;
 	}
@@ -405,11 +410,11 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
-	if (stat & ERR_STAT)
+	if (stat & ATA_ERR)
 		return task_error(drive, rq, __func__, stat);
 
 	/* Didn't want any data? Odd. */
-	if (!(stat & DRQ_STAT))
+	if ((stat & ATA_DRQ) == 0)
 		return task_in_unexpected(drive, rq, stat);
 
 	ide_pio_datablock(drive, rq, 0);
@@ -442,7 +447,7 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 		return task_error(drive, rq, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
-	if (((stat & DRQ_STAT) == 0) ^ !hwif->nleft)
+	if (((stat & ATA_DRQ) == 0) ^ !hwif->nleft)
 		return task_error(drive, rq, __func__, stat);
 
 	if (!hwif->nleft) {
@@ -461,7 +466,7 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
 	ide_startstop_t startstop;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT,
+	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 				drive->name,
@@ -721,110 +726,3 @@ abort:
 	return err;
 }
 #endif
-
-int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
-{
-	u8 *buf = NULL;
-	int bufsize = 0, err = 0;
-	u8 args[4], xfer_rate = 0;
-	ide_task_t tfargs;
-	struct ide_taskfile *tf = &tfargs.tf;
-	struct hd_driveid *id = drive->id;
-
-	if (NULL == (void *) arg) {
-		struct request *rq;
-
-		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-		err = blk_execute_rq(drive->queue, NULL, rq, 0);
-		blk_put_request(rq);
-
-		return err;
-	}
-
-	if (copy_from_user(args, (void __user *)arg, 4))
-		return -EFAULT;
-
-	memset(&tfargs, 0, sizeof(ide_task_t));
-	tf->feature = args[2];
-	if (args[0] == WIN_SMART) {
-		tf->nsect = args[3];
-		tf->lbal  = args[1];
-		tf->lbam  = 0x4f;
-		tf->lbah  = 0xc2;
-		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
-	} else {
-		tf->nsect = args[1];
-		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
-				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
-	}
-	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
-
-	if (args[3]) {
-		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
-		bufsize = SECTOR_WORDS * 4 * args[3];
-		buf = kzalloc(bufsize, GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-	}
-
-	if (tf->command == WIN_SETFEATURES &&
-	    tf->feature == SETFEATURES_XFER &&
-	    tf->nsect >= XFER_SW_DMA_0 &&
-	    (id->dma_ultra || id->dma_mword || id->dma_1word)) {
-		xfer_rate = args[1];
-		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
-			goto abort;
-		}
-	}
-
-	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
-
-	args[0] = tf->status;
-	args[1] = tf->error;
-	args[2] = tf->nsect;
-
-	if (!err && xfer_rate) {
-		/* active-retuning-calls future */
-		ide_set_xfer_rate(drive, xfer_rate);
-		ide_driveid_update(drive);
-	}
-abort:
-	if (copy_to_user((void __user *)arg, &args, 4))
-		err = -EFAULT;
-	if (buf) {
-		if (copy_to_user((void __user *)(arg + 4), buf, bufsize))
-			err = -EFAULT;
-		kfree(buf);
-	}
-	return err;
-}
-
-int ide_task_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
-{
-	void __user *p = (void __user *)arg;
-	int err = 0;
-	u8 args[7];
-	ide_task_t task;
-
-	if (copy_from_user(args, p, 7))
-		return -EFAULT;
-
-	memset(&task, 0, sizeof(task));
-	memcpy(&task.tf_array[7], &args[1], 6);
-	task.tf.command = args[0];
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-
-	err = ide_no_data_taskfile(drive, &task);
-
-	args[0] = task.tf.command;
-	memcpy(&args[1], &task.tf_array[7], 6);
-
-	if (copy_to_user(p, args, 7))
-		err = -EFAULT;
-
-	return err;
-}
diff --git a/drivers/ide/ide-timings.c b/drivers/ide/ide-timings.c
index 8c2f832..81f527a 100644
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/module.h>
 
@@ -78,15 +77,15 @@ EXPORT_SYMBOL_GPL(ide_timing_find_mode);
 
 u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u16 cycle = 0;
 
-	if (id->field_valid & 2) {
-		if (id->capability & 8)
-			cycle = id->eide_pio_iordy;
+	if (id[ATA_ID_FIELD_VALID] & 2) {
+		if (ata_id_has_iordy(drive->id))
+			cycle = id[ATA_ID_EIDE_PIO_IORDY];
 		else
-			cycle = id->eide_pio;
+			cycle = id[ATA_ID_EIDE_PIO];
 
 		/* conservative "downgrade" for all pre-ATA2 drives */
 		if (pio < 3 && cycle < t->cycle)
@@ -138,7 +137,7 @@ EXPORT_SYMBOL_GPL(ide_timing_merge);
 int ide_timing_compute(ide_drive_t *drive, u8 speed,
 		       struct ide_timing *t, int T, int UT)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	struct ide_timing *s, p;
 
 	/*
@@ -157,16 +156,15 @@ int ide_timing_compute(ide_drive_t *drive, u8 speed,
 	 * If the drive is an EIDE drive, it can tell us it needs extended
 	 * PIO/MWDMA cycle timing.
 	 */
-	if (id && id->field_valid & 2) {	/* EIDE drive */
-
+	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
 
 		if (speed <= XFER_PIO_2)
-			p.cycle = p.cyc8b = id->eide_pio;
+			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
 		else if (speed <= XFER_PIO_5)
-			p.cycle = p.cyc8b = id->eide_pio_iordy;
+			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-			p.cycle = id->eide_dma_min;
+			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
 
 		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
 	}
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 7724516..9dcf5ae 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -44,8 +44,6 @@
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
  */
 
-#define _IDE_C			/* Tell ide.h it's really us */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -58,6 +56,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/device.h>
 
@@ -97,8 +96,6 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 	hwif->name[2]	= 'e';
 	hwif->name[3]	= '0' + index;
 
-	hwif->bus_state	= BUSSTATE_ON;
-
 	init_completion(&hwif->gendev_rel_comp);
 
 	hwif->tp_ops = &default_tp_ops;
@@ -119,7 +116,7 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
 		drive->hwif			= hwif;
-		drive->ready_stat		= READY_STAT;
+		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
 		drive->special.b.recalibrate	= 1;
 		drive->special.b.set_geometry	= 1;
@@ -253,42 +250,9 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 
 DEFINE_MUTEX(ide_setting_mtx);
 
-EXPORT_SYMBOL_GPL(ide_setting_mtx);
-
-/**
- *	ide_spin_wait_hwgroup	-	wait for group
- *	@drive: drive in the group
- *
- *	Wait for an IDE device group to go non busy and then return
- *	holding the ide_lock which guards the hwgroup->busy status
- *	and right to use it.
- */
+ide_devset_get(io_32bit, io_32bit);
 
-int ide_spin_wait_hwgroup (ide_drive_t *drive)
-{
-	ide_hwgroup_t *hwgroup = HWGROUP(drive);
-	unsigned long timeout = jiffies + (3 * HZ);
-
-	spin_lock_irq(&ide_lock);
-
-	while (hwgroup->busy) {
-		unsigned long lflags;
-		spin_unlock_irq(&ide_lock);
-		local_irq_set(lflags);
-		if (time_after(jiffies, timeout)) {
-			local_irq_restore(lflags);
-			printk(KERN_ERR "%s: channel busy\n", drive->name);
-			return -EBUSY;
-		}
-		local_irq_restore(lflags);
-		spin_lock_irq(&ide_lock);
-	}
-	return 0;
-}
-
-EXPORT_SYMBOL(ide_spin_wait_hwgroup);
-
-int set_io_32bit(ide_drive_t *drive, int arg)
+static int set_io_32bit(ide_drive_t *drive, int arg)
 {
 	if (drive->no_io_32bit)
 		return -EPERM;
@@ -296,53 +260,39 @@ int set_io_32bit(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
 		return -EINVAL;
 
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
-
 	drive->io_32bit = arg;
 
-	spin_unlock_irq(&ide_lock);
-
 	return 0;
 }
 
+ide_devset_get(ksettings, keep_settings);
+
 static int set_ksettings(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
 	drive->keep_settings = arg;
-	spin_unlock_irq(&ide_lock);
 
 	return 0;
 }
 
-int set_using_dma(ide_drive_t *drive, int arg)
+ide_devset_get(using_dma, using_dma);
+
+static int set_using_dma(ide_drive_t *drive, int arg)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	ide_hwif_t *hwif = drive->hwif;
 	int err = -EPERM;
 
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (!drive->id || !(drive->id->capability & 1))
+	if (ata_id_has_dma(drive->id) == 0)
 		goto out;
 
-	if (hwif->dma_ops == NULL)
+	if (drive->hwif->dma_ops == NULL)
 		goto out;
 
-	err = -EBUSY;
-	if (ide_spin_wait_hwgroup(drive))
-		goto out;
-	/*
-	 * set ->busy flag, unlock and let it ride
-	 */
-	hwif->hwgroup->busy = 1;
-	spin_unlock_irq(&ide_lock);
-
 	err = 0;
 
 	if (arg) {
@@ -351,12 +301,6 @@ int set_using_dma(ide_drive_t *drive, int arg)
 	} else
 		ide_dma_off(drive);
 
-	/*
-	 * lock, clear ->busy flag and unlock before leaving
-	 */
-	spin_lock_irq(&ide_lock);
-	hwif->hwgroup->busy = 0;
-	spin_unlock_irq(&ide_lock);
 out:
 	return err;
 #else
@@ -367,7 +311,7 @@ out:
 #endif
 }
 
-int set_pio_mode(ide_drive_t *drive, int arg)
+static int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	struct request *rq;
 	ide_hwif_t *hwif = drive->hwif;
@@ -395,6 +339,8 @@ int set_pio_mode(ide_drive_t *drive, int arg)
 	return 0;
 }
 
+ide_devset_get(unmaskirq, unmask);
+
 static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
 	if (drive->no_unmask)
@@ -403,14 +349,20 @@ static int set_unmaskirq(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
 	drive->unmask = arg;
-	spin_unlock_irq(&ide_lock);
 
 	return 0;
 }
 
+#define ide_gen_devset_rw(_name, _func) \
+__IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
+
+ide_gen_devset_rw(io_32bit, io_32bit);
+ide_gen_devset_rw(keepsettings, ksettings);
+ide_gen_devset_rw(unmaskirq, unmaskirq);
+ide_gen_devset_rw(using_dma, using_dma);
+__IDE_DEVSET(pio_mode, 0, NULL, set_pio_mode);
+
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
 	ide_drive_t *drive = dev->driver_data;
@@ -486,138 +438,6 @@ static int generic_ide_resume(struct device *dev)
 	return err;
 }
 
-static int generic_drive_reset(ide_drive_t *drive)
-{
-	struct request *rq;
-	int ret = 0;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_len = 1;
-	rq->cmd[0] = REQ_DRIVE_RESET;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
-	if (blk_execute_rq(drive->queue, NULL, rq, 1))
-		ret = rq->errors;
-	blk_put_request(rq);
-	return ret;
-}
-
-int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
-			unsigned int cmd, unsigned long arg)
-{
-	unsigned long flags;
-	ide_driver_t *drv;
-	void __user *p = (void __user *)arg;
-	int err = 0, (*setfunc)(ide_drive_t *, int);
-	u8 *val;
-
-	switch (cmd) {
-	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
-	case HDIO_GET_KEEPSETTINGS: val = &drive->keep_settings; goto read_val;
-	case HDIO_GET_UNMASKINTR:   val = &drive->unmask;	 goto read_val;
-	case HDIO_GET_DMA:	    val = &drive->using_dma;	 goto read_val;
-	case HDIO_SET_32BIT:	    setfunc = set_io_32bit;	 goto set_val;
-	case HDIO_SET_KEEPSETTINGS: setfunc = set_ksettings;	 goto set_val;
-	case HDIO_SET_PIO_MODE:	    setfunc = set_pio_mode;	 goto set_val;
-	case HDIO_SET_UNMASKINTR:   setfunc = set_unmaskirq;	 goto set_val;
-	case HDIO_SET_DMA:	    setfunc = set_using_dma;	 goto set_val;
-	}
-
-	switch (cmd) {
-		case HDIO_OBSOLETE_IDENTITY:
-		case HDIO_GET_IDENTITY:
-			if (bdev != bdev->bd_contains)
-				return -EINVAL;
-			if (drive->id_read == 0)
-				return -ENOMSG;
-			if (copy_to_user(p, drive->id, (cmd == HDIO_GET_IDENTITY) ? sizeof(*drive->id) : 142))
-				return -EFAULT;
-			return 0;
-
-		case HDIO_GET_NICE:
-			return put_user(drive->dsc_overlap	<<	IDE_NICE_DSC_OVERLAP	|
-					drive->atapi_overlap	<<	IDE_NICE_ATAPI_OVERLAP	|
-					drive->nice1 << IDE_NICE_1,
-					(long __user *) arg);
-#ifdef CONFIG_IDE_TASK_IOCTL
-		case HDIO_DRIVE_TASKFILE:
-		        if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			switch(drive->media) {
-				case ide_disk:
-					return ide_taskfile_ioctl(drive, cmd, arg);
-				default:
-					return -ENOMSG;
-			}
-#endif /* CONFIG_IDE_TASK_IOCTL */
-
-		case HDIO_DRIVE_CMD:
-			if (!capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			return ide_cmd_ioctl(drive, cmd, arg);
-
-		case HDIO_DRIVE_TASK:
-			if (!capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			return ide_task_ioctl(drive, cmd, arg);
-		case HDIO_SET_NICE:
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
-				return -EPERM;
-			drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-			drv = *(ide_driver_t **)bdev->bd_disk->private_data;
-			if (drive->dsc_overlap && !drv->supports_dsc_overlap) {
-				drive->dsc_overlap = 0;
-				return -EPERM;
-			}
-			drive->nice1 = (arg >> IDE_NICE_1) & 1;
-			return 0;
-		case HDIO_DRIVE_RESET:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-
-			return generic_drive_reset(drive);
-
-		case HDIO_GET_BUSSTATE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			if (put_user(HWIF(drive)->bus_state, (long __user *)arg))
-				return -EFAULT;
-			return 0;
-
-		case HDIO_SET_BUSSTATE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			return -EOPNOTSUPP;
-		default:
-			return -EINVAL;
-	}
-
-read_val:
-	mutex_lock(&ide_setting_mtx);
-	spin_lock_irqsave(&ide_lock, flags);
-	err = *val;
-	spin_unlock_irqrestore(&ide_lock, flags);
-	mutex_unlock(&ide_setting_mtx);
-	return err >= 0 ? put_user(err, (long __user *)arg) : err;
-
-set_val:
-	if (bdev != bdev->bd_contains)
-		err = -EINVAL;
-	else {
-		if (!capable(CAP_SYS_ADMIN))
-			err = -EACCES;
-		else {
-			mutex_lock(&ide_setting_mtx);
-			err = setfunc(drive, arg);
-			mutex_unlock(&ide_setting_mtx);
-		}
-	}
-	return err;
-}
-
-EXPORT_SYMBOL(generic_ide_ioctl);
-
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
  * @drive:	device to get a reference to
@@ -710,21 +530,21 @@ static ssize_t model_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->model);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_PROD]);
 }
 
 static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->fw_rev);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_FW_REV]);
 }
 
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->serial_no);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
 }
 
 static struct device_attribute ide_dev_attrs[] = {
@@ -841,7 +661,7 @@ MODULE_PARM_DESC(noprobe, "skip probing for a device");
 static unsigned int ide_nowerr;
 
 module_param_call(nowerr, ide_set_dev_param_mask, NULL, &ide_nowerr, 0);
-MODULE_PARM_DESC(nowerr, "ignore the WRERR_STAT bit for a device");
+MODULE_PARM_DESC(nowerr, "ignore the ATA_DF bit for a device");
 
 static unsigned int ide_cdroms;
 
@@ -906,7 +726,7 @@ static void ide_dev_apply_params(ide_drive_t *drive)
 		drive->noprobe = 1;
 	}
 	if (ide_nowerr & (1 << i)) {
-		printk(KERN_INFO "ide: ignoring the WRERR_STAT bit for %s\n",
+		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
 				 drive->name);
 		drive->bad_wstat = BAD_R_STAT;
 	}
@@ -927,7 +747,7 @@ static void ide_dev_apply_params(ide_drive_t *drive)
 				 drive->cyl, drive->head, drive->sect);
 		drive->present = 1;
 		drive->media = ide_disk;
-		drive->ready_stat = READY_STAT;
+		drive->ready_stat = ATA_DRDY;
 	}
 }
 
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 4ec1973..7276c96 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -43,7 +43,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 7c2afa9..c5a3c9e 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/zorro.h>
 #include <linux/ide.h>
 #include <linux/init.h>
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index af791a0..689b2e4 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 724f950..39d500d 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index 51ba085..6915068 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/zorro.h>
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 98f7c95..5123ea2 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 21bfac1..ee6fc30 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -38,7 +38,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <asm/io.h>
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index a0bb167..43f97cc 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
 
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 4abd8fc..4af4a8c 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -14,8 +14,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
-
 #include <linux/ide.h>
 
     /*
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 2338f34..ec408b3 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -27,7 +27,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <asm/system.h>
@@ -151,12 +150,14 @@ static int qd_find_disk_type (ide_drive_t *drive,
 		int *active_time, int *recovery_time)
 {
 	struct qd65xx_timing_s *p;
-	char model[40];
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+	char model[ATA_ID_PROD_LEN];
 
-	if (!*drive->id->model) return 0;
+	if (*m == 0)
+		return 0;
 
-	strncpy(model,drive->id->model,40);
-	ide_fixstring(model,40,1); /* byte-swap */
+	strncpy(model, m, ATA_ID_PROD_LEN);
+	ide_fixstring(model, ATA_ID_PROD_LEN, 1); /* byte-swap */
 
 	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
 		if (!strncmp(p->model, model+p->offset, 4)) {
@@ -185,20 +186,20 @@ static void qd_set_timing (ide_drive_t *drive, u8 timing)
 
 static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	u16 *id = drive->id;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
 
 	/*
 	 * FIXME: use "pio" value
 	 */
-	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)
-		&& drive->id->tPIO && (drive->id->field_valid & 0x02)
-		&& drive->id->eide_pio >= 240) {
-
+	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
+	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
+	    id[ATA_ID_EIDE_PIO] >= 240) {
 		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
-				drive->id->tPIO);
+			id[ATA_ID_OLD_PIO_MODES] & 0xff);
 		active_time = 110;
-		recovery_time = drive->id->eide_pio - 120;
+		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
 	}
 
 	qd_set_timing(drive, qd6500_compute_timing(HWIF(drive), active_time, recovery_time));
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index b54a14a..1da076e 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -45,7 +45,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 3187215..e7475ba 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -140,7 +139,7 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
+static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
 {
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
@@ -308,6 +307,8 @@ static struct pci_driver driver = {
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
 	.remove		= __devexit_p(aec62xx_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init aec62xx_ide_init(void)
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index d647526..053c752 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -134,8 +133,8 @@ static u8 ali_udma_filter(ide_drive_t *drive)
 	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
 		if (drive->media != ide_disk)
 			return 0;
-		if (chip_is_1543c_e && strstr(drive->id->model, "WDC ") &&
-		    wdc_udma == 0)
+		if (wdc_udma == 0 && chip_is_1543c_e &&
+		    strstr((char *)&drive->id[ATA_ID_PROD], "WDC "))
 			return 0;
 	}
 
@@ -214,7 +213,7 @@ static int ali15x3_dma_setup(ide_drive_t *drive)
  *	appropriate also sets up the 1533 southbridge.
  */
 
-static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
+static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
@@ -582,6 +581,8 @@ static struct pci_driver driver = {
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init ali15x3_ide_init(void)
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 1e66a96..824471f 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -112,13 +112,13 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-static void __devinit amd7409_cable_detect(struct pci_dev *dev)
+static void amd7409_cable_detect(struct pci_dev *dev)
 {
 	/* no host side cable detection */
 	amd_80w = 0x03;
 }
 
-static void __devinit amd7411_cable_detect(struct pci_dev *dev)
+static void amd7411_cable_detect(struct pci_dev *dev)
 {
 	int i;
 	u32 u = 0;
@@ -140,7 +140,7 @@ static void __devinit amd7411_cable_detect(struct pci_dev *dev)
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev)
+static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -324,6 +324,8 @@ static struct pci_driver driver = {
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init amd74xx_ide_init(void)
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 41f6cb6..e443703 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -188,6 +187,8 @@ static struct pci_driver driver = {
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init atiixp_ide_init(void)
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index e6c6200..7f39cdb 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -103,7 +103,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -375,6 +374,21 @@ static void cmd640_dump_regs(void)
 }
 #endif
 
+static void __set_prefetch_mode(ide_drive_t *drive, int mode)
+{
+	if (mode) {	/* want prefetch on? */
+#if CMD640_PREFETCH_MASKS
+		drive->no_unmask = 1;
+		drive->unmask = 0;
+#endif
+		drive->no_io_32bit = 0;
+	} else {
+		drive->no_unmask = 0;
+		drive->no_io_32bit = 1;
+		drive->io_32bit = 0;
+	}
+}
+
 #ifndef CONFIG_BLK_DEV_CMD640_ENHANCED
 /*
  * Check whether prefetch is on for a drive,
@@ -384,19 +398,10 @@ static void __init check_prefetch(ide_drive_t *drive, unsigned int index)
 {
 	u8 b = get_cmd640_reg(prefetch_regs[index]);
 
-	if (b & prefetch_masks[index]) {	/* is prefetch off? */
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
-		drive->io_32bit = 0;
-	} else {
-#if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
-#endif
-		drive->no_io_32bit = 0;
-	}
+	__set_prefetch_mode(drive, (b & prefetch_masks[index]) ? 0 : 1);
 }
 #else
+
 /*
  * Sets prefetch mode for a drive.
  */
@@ -408,19 +413,11 @@ static void set_prefetch_mode(ide_drive_t *drive, unsigned int index, int mode)
 
 	spin_lock_irqsave(&cmd640_lock, flags);
 	b = __get_cmd640_reg(reg);
-	if (mode) {	/* want prefetch on? */
-#if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
-#endif
-		drive->no_io_32bit = 0;
+	__set_prefetch_mode(drive, mode);
+	if (mode)
 		b &= ~prefetch_masks[index];	/* enable prefetch */
-	} else {
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
-		drive->io_32bit = 0;
+	else
 		b |= prefetch_masks[index];	/* disable prefetch */
-	}
 	__put_cmd640_reg(reg, b);
 	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index e064398..456dee1 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -332,7 +331,7 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev)
+static unsigned int init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
@@ -511,6 +510,8 @@ static struct pci_driver driver = {
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init cmd64x_ide_init(void)
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 151844f..d6341f7 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
@@ -150,6 +149,8 @@ static struct pci_driver driver = {
 	.name		= "Cyrix_IDE",
 	.id_table	= cs5520_pci_tbl,
 	.probe		= cs5520_init_one,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init cs5520_ide_init(void)
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index f235db8..da42fa7 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
@@ -81,17 +80,19 @@ static void cs5530_set_pio_mode(ide_drive_t *drive, const u8 pio)
 static u8 cs5530_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
-	struct hd_driveid *mateid = mate->id;
+	ide_drive_t *mate = ide_get_pair_dev(drive);
+	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
-	if (mate->present == 0)
+	if (mate == NULL)
 		goto out;
 
-	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
-		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
+		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
+		    (mateid[ATA_ID_MWDMA_MODES] & 7))
 			mask = 0;
 	}
 out:
@@ -133,7 +134,7 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int __devinit init_chipset_cs5530(struct pci_dev *dev)
+static unsigned int init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
@@ -271,6 +272,8 @@ static struct pci_driver driver = {
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init cs5530_ide_init(void)
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index dd3dc23..1e5bc59 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -80,12 +80,12 @@ static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 
 	/* Set the PIO timings */
 	if (speed < XFER_SW_DMA_0) {
-		ide_drive_t *pair = ide_get_paired_drive(drive);
+		ide_drive_t *pair = ide_get_pair_dev(drive);
 		u8 cmd, pioa;
 
 		cmd = pioa = speed - XFER_PIO_0;
 
-		if (pair->present) {
+		if (pair) {
 			u8 piob = ide_get_best_pio_mode(pair, 255, 4);
 
 			if (piob < cmd)
@@ -193,10 +193,12 @@ static const struct pci_device_id cs5535_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, cs5535_pci_tbl);
 
 static struct pci_driver driver = {
-	.name       = "CS5535_IDE",
-	.id_table   = cs5535_pci_tbl,
-	.probe      = cs5535_init_one,
-	.remove     = ide_pci_remove,
+	.name		= "CS5535_IDE",
+	.id_table	= cs5535_pci_tbl,
+	.probe		= cs5535_init_one,
+	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init cs5535_ide_init(void)
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index e6d8ee8..69820e9 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -332,7 +332,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 /*
  * this function is called during init and is used to setup the cy82c693 chip
  */
-static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev)
+static unsigned int init_chipset_cy82c693(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
 		return 0;
@@ -448,6 +448,8 @@ static struct pci_driver driver = {
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
 	.remove		= __devexit_p(cy82c693_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init cy82c693_ide_init(void)
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index f84bfb4..83b63b3 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -19,7 +19,6 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index b07d4f4..092b238 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -172,6 +171,8 @@ static struct pci_driver driver = {
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init generic_ide_init(void)
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 6009b0b..644de29 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -79,7 +78,7 @@ static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
  */
 #define	HPT34X_PCI_INIT_REG		0x80
 
-static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev)
+static unsigned int init_chipset_hpt34x(struct pci_dev *dev)
 {
 	int i = 0;
 	unsigned long hpt34xIoBase = pci_resource_start(dev, 4);
@@ -172,6 +171,8 @@ static struct pci_driver driver = {
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init hpt34x_ide_init(void)
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index c37ab17..a194022 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -122,7 +122,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -605,10 +604,10 @@ static const struct hpt_info hpt371n __devinitdata = {
 
 static int check_in_drive_list(ide_drive_t *drive, const char **list)
 {
-	struct hd_driveid *id = drive->id;
+	char *m = (char *)&drive->id[ATA_ID_PROD];
 
 	while (*list)
-		if (!strcmp(*list++,id->model))
+		if (!strcmp(*list++, m))
 			return 1;
 	return 0;
 }
@@ -655,7 +654,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 	case HPT372A:
 	case HPT372N:
 	case HPT374 :
-		if (ide_dev_is_sata(drive->id))
+		if (ata_id_is_sata(drive->id))
 			mask &= ~0x0e;
 		/* Fall thru */
 	default:
@@ -675,7 +674,7 @@ static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 	case HPT372A:
 	case HPT372N:
 	case HPT374 :
-		if (ide_dev_is_sata(drive->id))
+		if (ata_id_is_sata(drive->id))
 			return 0x00;
 		/* Fall thru */
 	default:
@@ -731,11 +730,11 @@ static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void hpt3xx_quirkproc(ide_drive_t *drive)
 {
-	struct hd_driveid *id	= drive->id;
+	char *m			= (char *)&drive->id[ATA_ID_PROD];
 	const  char **list	= quirk_drives;
 
 	while (*list)
-		if (strstr(id->model, *list++)) {
+		if (strstr(m, *list++)) {
 			drive->quirk_list = 1;
 			return;
 		}
@@ -944,7 +943,7 @@ static void hpt3xxn_rw_disk(ide_drive_t *drive, struct request *rq)
  *	Perform a calibration cycle on the DPLL.
  *	Returns 1 if this succeeds
  */
-static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f_high)
+static int hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f_high)
 {
 	u32 dpll = (f_high << 16) | f_low | 0x100;
 	u8  scr2;
@@ -972,7 +971,37 @@ static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f
 	return 1;
 }
 
-static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
+static void hpt3xx_disable_fast_irq(struct pci_dev *dev, u8 mcr_addr)
+{
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	u8  chip_type		= info->chip_type;
+	u8  new_mcr, old_mcr	= 0;
+
+	/*
+	 * Disable the "fast interrupt" prediction.  Don't hold off
+	 * on interrupts. (== 0x01 despite what the docs say)
+	 */
+	pci_read_config_byte(dev, mcr_addr + 1, &old_mcr);
+
+	if (chip_type >= HPT374)
+		new_mcr = old_mcr & ~0x07;
+	else if (chip_type >= HPT370) {
+		new_mcr = old_mcr;
+		new_mcr &= ~0x02;
+#ifdef HPT_DELAY_INTERRUPT
+		new_mcr &= ~0x01;
+#else
+		new_mcr |=  0x01;
+#endif
+	} else					/* HPT366 and HPT368  */
+		new_mcr = old_mcr & ~0x80;
+
+	if (new_mcr != old_mcr)
+		pci_write_config_byte(dev, mcr_addr + 1, new_mcr);
+}
+
+static unsigned int init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
@@ -1209,9 +1238,11 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 	 * NOTE: This register is only writeable via I/O space.
 	 */
 	if (chip_type == HPT371N && clock == ATA_CLOCK_66MHZ)
-
 		outb(inb(io_base + 0x9c) | 0x04, io_base + 0x9c);
 
+	hpt3xx_disable_fast_irq(dev, 0x50);
+	hpt3xx_disable_fast_irq(dev, 0x54);
+
 	return dev->irq;
 }
 
@@ -1265,7 +1296,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
-	u8  new_mcr, old_mcr	= 0;
 
 	/* Cache the channel's MISC. control registers' offset */
 	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
@@ -1288,29 +1318,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	/* Serialize access to this device if needed */
 	if (serialize && hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
-
-	/*
-	 * Disable the "fast interrupt" prediction.  Don't hold off
-	 * on interrupts. (== 0x01 despite what the docs say)
-	 */
-	pci_read_config_byte(dev, hwif->select_data + 1, &old_mcr);
-
-	if (info->chip_type >= HPT374)
-		new_mcr = old_mcr & ~0x07;
-	else if (info->chip_type >= HPT370) {
-		new_mcr = old_mcr;
-		new_mcr &= ~0x02;
-
-#ifdef HPT_DELAY_INTERRUPT
-		new_mcr &= ~0x01;
-#else
-		new_mcr |=  0x01;
-#endif
-	} else					/* HPT366 and HPT368  */
-		new_mcr = old_mcr & ~0x80;
-
-	if (new_mcr != old_mcr)
-		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
 }
 
 static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
@@ -1620,6 +1627,8 @@ static struct pci_driver driver = {
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
 	.remove		= __devexit_p(hpt366_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init hpt366_ide_init(void)
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 652e47d..0954ccd 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -195,6 +194,8 @@ static struct pci_driver driver = {
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init it8213_ide_init(void)
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 4a1508a..46edd08 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -63,7 +63,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -446,8 +445,7 @@ static u8 it821x_cable_detect(ide_hwif_t *hwif)
 static void it821x_quirkproc(ide_drive_t *drive)
 {
 	struct it821x_dev *itdev = ide_get_hwifdata(drive->hwif);
-	struct hd_driveid *id = drive->id;
-	u16 *idbits = (u16 *)drive->id;
+	u16 *id = drive->id;
 
 	if (!itdev->smart) {
 		/*
@@ -466,36 +464,36 @@ static void it821x_quirkproc(ide_drive_t *drive)
 	 */
 
 		/* Check for RAID v native */
-		if(strstr(id->model, "Integrated Technology Express")) {
+		if (strstr((char *)&id[ATA_ID_PROD],
+			   "Integrated Technology Express")) {
 			/* In raid mode the ident block is slightly buggy
 			   We need to set the bits so that the IDE layer knows
 			   LBA28. LBA48 and DMA ar valid */
-			id->capability |= 3;		/* LBA28, DMA */
-			id->command_set_2 |= 0x0400;	/* LBA48 valid */
-			id->cfs_enable_2 |= 0x0400;	/* LBA48 on */
+			id[ATA_ID_CAPABILITY]    |= (3 << 8); /* LBA28, DMA */
+			id[ATA_ID_COMMAND_SET_2] |= 0x0400;   /* LBA48 valid */
+			id[ATA_ID_CFS_ENABLE_2]  |= 0x0400;   /* LBA48 on */
 			/* Reporting logic */
 			printk(KERN_INFO "%s: IT8212 %sRAID %d volume",
-				drive->name,
-				idbits[147] ? "Bootable ":"",
-				idbits[129]);
-				if(idbits[129] != 1)
-					printk("(%dK stripe)", idbits[146]);
-				printk(".\n");
+				drive->name, id[147] ? "Bootable " : "",
+				id[ATA_ID_CSFO]);
+			if (id[ATA_ID_CSFO] != 1)
+				printk(KERN_CONT "(%dK stripe)", id[146]);
+			printk(KERN_CONT ".\n");
 		} else {
 			/* Non RAID volume. Fixups to stop the core code
 			   doing unsupported things */
-			id->field_valid &= 3;
-			id->queue_depth = 0;
-			id->command_set_1 = 0;
-			id->command_set_2 &= 0xC400;
-			id->cfsse &= 0xC000;
-			id->cfs_enable_1 = 0;
-			id->cfs_enable_2 &= 0xC400;
-			id->csf_default &= 0xC000;
-			id->word127 = 0;
-			id->dlf = 0;
-			id->csfo = 0;
-			id->cfa_power = 0;
+			id[ATA_ID_FIELD_VALID]	 &= 3;
+			id[ATA_ID_QUEUE_DEPTH]	  = 0;
+			id[ATA_ID_COMMAND_SET_1]  = 0;
+			id[ATA_ID_COMMAND_SET_2] &= 0xC400;
+			id[ATA_ID_CFSSE]	 &= 0xC000;
+			id[ATA_ID_CFS_ENABLE_1]	  = 0;
+			id[ATA_ID_CFS_ENABLE_2]	 &= 0xC400;
+			id[ATA_ID_CSF_DEFAULT]	 &= 0xC000;
+			id[127]			  = 0;
+			id[ATA_ID_DLF]		  = 0;
+			id[ATA_ID_CSFO]		  = 0;
+			id[ATA_ID_CFA_POWER]	  = 0;
 			printk(KERN_INFO "%s: Performing identify fixups.\n",
 				drive->name);
 		}
@@ -505,8 +503,8 @@ static void it821x_quirkproc(ide_drive_t *drive)
 		 * IDE core that DMA is supported (it821x hardware
 		 * takes care of DMA mode programming).
 		 */
-		if (id->capability & 1) {
-			id->dma_mword |= 0x0101;
+		if (ata_id_has_dma(id)) {
+			id[ATA_ID_MWDMA_MODES] |= 0x0101;
 			drive->current_speed = XFER_MW_DMA_0;
 		}
 	}
@@ -588,7 +586,7 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	hwif->mwdma_mask = ATA_MWDMA2;
 }
 
-static void __devinit it8212_disable_raid(struct pci_dev *dev)
+static void it8212_disable_raid(struct pci_dev *dev)
 {
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(dev, 0x5E, 0x01);
@@ -605,7 +603,7 @@ static void __devinit it8212_disable_raid(struct pci_dev *dev)
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev)
+static unsigned int init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
@@ -687,6 +685,8 @@ static struct pci_driver driver = {
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
 	.remove		= __devexit_p(it821x_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init it821x_ide_init(void)
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index bb9d09d..acd6471 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -155,6 +154,8 @@ static struct pci_driver driver = {
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init jmicron_ide_init(void)
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index ffefcd1..53bd645 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -11,7 +11,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
@@ -274,9 +273,9 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 		do {
 			udelay(50);
 			stat = hwif->tp_ops->read_status(hwif);
-                	if (stat == 0xff)
-                        	break;
-        	} while ((stat & BUSY_STAT) && --timeout);
+			if (stat == 0xff)
+				break;
+		} while ((stat & ATA_BUSY) && --timeout);
 #endif
 	}
 
@@ -340,6 +339,8 @@ static struct pci_driver driver = {
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init ns87415_ide_init(void)
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index e28e672..3de11dd 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -85,7 +85,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
@@ -137,7 +136,7 @@ static u8 read_reg(int reg)
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *pair = ide_get_paired_drive(drive);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	unsigned long flags;
 	u8 tim, misc, addr_pio = pio, clk;
 
@@ -153,7 +152,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	drive->drive_data = XFER_PIO_0 + pio;
 
-	if (pair->present) {
+	if (pair) {
 		if (pair->drive_data && pair->drive_data < drive->drive_data)
 			addr_pio = pair->drive_data - XFER_PIO_0;
 	}
@@ -226,6 +225,8 @@ static struct pci_driver driver = {
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init opti621_ide_init(void)
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index d477da6..9fc5996 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
@@ -203,10 +202,10 @@ static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 
 static void pdcnew_quirkproc(ide_drive_t *drive)
 {
-	const char **list, *model = drive->id->model;
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
 
 	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(model, *list) != NULL) {
+		if (strstr(m, *list) != NULL) {
 			drive->quirk_list = 2;
 			return;
 		}
@@ -227,7 +226,7 @@ static void pdcnew_reset(ide_drive_t *drive)
  * read_counter - Read the byte count registers
  * @dma_base: for the port address
  */
-static long __devinit read_counter(u32 dma_base)
+static long read_counter(u32 dma_base)
 {
 	u32  pri_dma_base = dma_base, sec_dma_base = dma_base + 0x08;
 	u8   cnt0, cnt1, cnt2, cnt3;
@@ -267,7 +266,7 @@ static long __devinit read_counter(u32 dma_base)
  * @dma_base: for the port address
  * E.g. 16949000 on 33 MHz PCI bus, i.e. half of the PCI clock.
  */
-static long __devinit detect_pll_input_clock(unsigned long dma_base)
+static long detect_pll_input_clock(unsigned long dma_base)
 {
 	struct timeval start_time, end_time;
 	long start_count, end_count;
@@ -310,7 +309,7 @@ static long __devinit detect_pll_input_clock(unsigned long dma_base)
 }
 
 #ifdef CONFIG_PPC_PMAC
-static void __devinit apple_kiwi_init(struct pci_dev *pdev)
+static void apple_kiwi_init(struct pci_dev *pdev)
 {
 	struct device_node *np = pci_device_to_OF_node(pdev);
 	u8 conf;
@@ -326,7 +325,7 @@ static void __devinit apple_kiwi_init(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev)
+static unsigned int init_chipset_pdcnew(struct pci_dev *dev)
 {
 	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
@@ -567,6 +566,8 @@ static struct pci_driver driver = {
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
 	.remove		= __devexit_p(pdc202new_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init pdc202new_ide_init(void)
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index de9a274..cb6d2a0 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
@@ -86,7 +85,7 @@ static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
 		 */
 		AP &= ~0x3f;
-		if (drive->id->capability & 4)
+		if (ata_id_iordy_disable(drive->id))
 			AP |= 0x20;	/* set IORDY_EN bit */
 		if (drive->media == ide_disk)
 			AP |= 0x10;	/* set Prefetch_EN bit */
@@ -154,10 +153,10 @@ static void pdc_old_disable_66MHz_clock(ide_hwif_t *hwif)
 
 static void pdc202xx_quirkproc(ide_drive_t *drive)
 {
-	const char **list, *model = drive->id->model;
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
 
 	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(model, *list) != NULL) {
+		if (strstr(m, *list) != NULL) {
 			drive->quirk_list = 2;
 			return;
 		}
@@ -265,7 +264,7 @@ static void pdc202xx_dma_timeout(ide_drive_t *drive)
 	ide_dma_timeout(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev)
+static unsigned int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
@@ -432,6 +431,8 @@ static struct pci_driver driver = {
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init pdc202xx_ide_init(void)
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 30cfc81..a06c03f 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -48,7 +48,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -205,7 +204,7 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
  *	out to be nice and simple.
  */
 
-static unsigned int __devinit init_chipset_ich(struct pci_dev *dev)
+static unsigned int init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
@@ -450,6 +449,8 @@ static struct pci_driver driver = {
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init piix_ide_init(void)
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 8d11ee8..c117a06 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 8efaed1..bdc1fed 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
@@ -104,17 +103,19 @@ static void sc1200_tunepio(ide_drive_t *drive, u8 pio)
 static u8 sc1200_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
-	struct hd_driveid *mateid = mate->id;
+	ide_drive_t *mate = ide_get_pair_dev(drive);
+	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
-	if (mate->present == 0)
+	if (mate == NULL)
 		goto out;
 
-	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
-		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
+		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
+		    (mateid[ATA_ID_MWDMA_MODES] & 7))
 			mask = 0;
 	}
 out:
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 44cccd1..e92a874 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -400,7 +399,7 @@ static int scc_dma_end(ide_drive_t *drive)
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
 	if (!(in_be32((void __iomem *)hwif->io_ports.ctl_addr)
-	      & ERR_STAT) &&
+	      & ATA_ERR) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
 		if (!(reg & INTSTS_ACTEINT)) {
@@ -504,7 +503,7 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 
 	/* SCC errata A252,A308 workaround: Step4 */
 	if ((in_be32((void __iomem *)hwif->io_ports.ctl_addr)
-	     & ERR_STAT) &&
+	     & ATA_ERR) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
 
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index c3bdc6e..3dff2ae 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -57,8 +56,10 @@ static struct pci_dev *isa_dev;
 
 static int check_in_drive_lists (ide_drive_t *drive, const char **list)
 {
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+
 	while (*list)
-		if (!strcmp(*list++, drive->id->model))
+		if (!strcmp(*list++, m))
 			return 1;
 	return 0;
 }
@@ -174,7 +175,7 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int __devinit init_chipset_svwks(struct pci_dev *dev)
+static unsigned int init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -447,6 +448,8 @@ static struct pci_driver driver = {
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init svwks_ide_init(void)
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 681306c..1017fb4 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index db2b88a..174a873 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -39,7 +39,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -223,7 +222,9 @@ static u8 sil_pata_udma_filter(ide_drive_t *drive)
 
 static u8 sil_sata_udma_filter(ide_drive_t *drive)
 {
-	return strstr(drive->id->model, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+
+	return strstr(m, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
 }
 
 /**
@@ -243,7 +244,7 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	ide_drive_t *pair	= ide_get_paired_drive(drive);
+	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
@@ -257,7 +258,7 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	u8 unit			= drive->select.b.unit;
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
-	if (pair->present) {
+	if (pair) {
 		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
 
 		if (pair_pio < tf_pio)
@@ -462,7 +463,7 @@ static void sil_sata_pre_reset(ide_drive_t *drive)
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev)
+static unsigned int init_chipset_siimage(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
@@ -616,8 +617,8 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 
 static int is_dev_seagate_sata(ide_drive_t *drive)
 {
-	const char *s	= &drive->id->model[0];
-	unsigned len	= strnlen(s, sizeof(drive->id->model));
+	const char *s	= (const char *)&drive->id[ATA_ID_PROD];
+	unsigned len	= strnlen(s, ATA_ID_PROD_LEN);
 
 	if ((len > 4) && (!memcmp(s, "ST", 2)))
 		if ((!memcmp(s + len - 2, "AS", 2)) ||
@@ -833,6 +834,8 @@ static struct pci_driver driver = {
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
 	.remove		= __devexit_p(siimage_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init siimage_ide_init(void)
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 5efe21d..734dd41 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -47,7 +47,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
@@ -448,7 +447,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 	return chipset_family;
 }
 
-static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev)
+static unsigned int init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
@@ -611,6 +610,8 @@ static struct pci_driver driver = {
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
 	.remove		= __devexit_p(sis5513_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init sis5513_ide_init(void)
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 73905bc..37a6b7b 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
@@ -62,7 +61,7 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 	if (cmd_off == 0)
 		cmd_off = 1;
 
-	if (pio > 2 || ide_dev_has_iordy(drive->id))
+	if (pio > 2 || ata_id_has_iordy(drive->id))
 		iordy = 0x40;
 
 	return (cmd_on - 1) << 8 | (cmd_off - 1) | iordy;
@@ -272,7 +271,7 @@ static u8 sl82c105_bridge_revision(struct pci_dev *dev)
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev)
+static unsigned int init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
@@ -351,6 +350,8 @@ static struct pci_driver driver = {
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init sl82c105_ide_init(void)
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 866d6c6..a9551a1 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
@@ -160,6 +159,8 @@ static struct pci_driver driver = {
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init slc90e66_ide_init(void)
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index b77ec35..be8715d 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -120,6 +119,8 @@ static struct pci_driver driver = {
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
 	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init triflex_ide_init(void)
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index fd28b49..4dfbc6a 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -135,7 +135,6 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 94fb9ab..acacdaa 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -154,7 +154,7 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 static void via_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
+	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
@@ -173,7 +173,7 @@ static void via_set_drive(ide_drive_t *drive, const u8 speed)
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->present) {
+	if (peer) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
@@ -215,7 +215,7 @@ static struct via_isa_bridge *via_config_find(struct pci_dev **isa)
 /*
  * Check and handle 80-wire cable presence
  */
-static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
+static void via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 {
 	int i;
 
@@ -267,7 +267,7 @@ static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
  *	and initialize its drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev)
+static unsigned int init_chipset_via82cxxx(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
@@ -492,6 +492,8 @@ static struct pci_driver driver = {
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
 	.remove		= __devexit_p(via_remove),
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
 };
 
 static int __init via_ide_init(void)
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index fa2be26..c3432da 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -669,9 +669,9 @@ static void
 set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 		 	u8 speed)
 {
+	u16 *id = drive->id;
 	int cycleTime, accessTime = 0, recTime = 0;
 	unsigned accessTicks, recTicks;
-	struct hd_driveid *id = drive->id;
 	struct mdma_timings_t* tm = NULL;
 	int i;
 
@@ -686,8 +686,8 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 	}
 
 	/* Check if drive provides explicit DMA cycle time */
-	if ((id->field_valid & 2) && id->eide_dma_time)
-		cycleTime = max_t(int, id->eide_dma_time, cycleTime);
+	if ((id[ATA_ID_FIELD_VALID] & 2) && id[ATA_ID_EIDE_DMA_TIME])
+		cycleTime = max_t(int, id[ATA_ID_EIDE_DMA_TIME], cycleTime);
 
 	/* OHare limits according to some old Apple sources */	
 	if ((intf_type == controller_ohare) && (cycleTime < 150))
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index a8e9e8a..9f1f916 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -659,3 +659,36 @@ void ide_pci_remove(struct pci_dev *dev)
 	pci_disable_device(dev);
 }
 EXPORT_SYMBOL_GPL(ide_pci_remove);
+
+#ifdef CONFIG_PM
+int ide_pci_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_pci_suspend);
+
+int ide_pci_resume(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	int rc;
+
+	pci_set_power_state(dev, PCI_D0);
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	pci_restore_state(dev);
+	pci_set_master(dev);
+
+	if (host->init_chipset)
+		host->init_chipset(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_pci_resume);
+#endif
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 81c16cb..90212ac 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -40,7 +40,6 @@
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
@@ -131,50 +130,6 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
 	return scsihost_to_idescsi(ide_drive->driver_data);
 }
 
-/*
- *	PIO data transfer routine using the scatter gather table.
- */
-static void ide_scsi_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				unsigned int bcount, int write)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
-	char *buf;
-	int count;
-
-	while (bcount) {
-		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(sg_page(pc->sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
-					  pc->sg->offset;
-			xf(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(pc->sg);
-			xf(drive, NULL, buf + pc->b_count, count);
-		}
-		bcount -= count; pc->b_count += count;
-		if (pc->b_count == pc->sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg_next(pc->sg);
-			pc->b_count = 0;
-		}
-	}
-
-	if (bcount) {
-		printk(KERN_ERR "%s: scatter gather table too small, %s\n",
-				drive->name, write ? "padding with zeros"
-						   : "discarding data");
-		ide_pad_transfer(drive, write, bcount);
-	}
-}
-
 static void ide_scsi_hex_dump(u8 *data, int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
@@ -244,9 +199,9 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
 	rq->errors++;
 
@@ -344,7 +299,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 
 	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
 			   idescsi_expiry, NULL, NULL, NULL,
-			   ide_scsi_io_buffers);
+			   ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
@@ -430,21 +385,41 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idescsi_add_settings(ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-/*
- *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
- */
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,	1,		1,		&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,	1,		1,		&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,	1,		1,		&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"transform",	SETTING_RW,	TYPE_INT,	0,	3,	1,		1,		&scsi->transform,	NULL);
-	ide_add_setting(drive,	"log",		SETTING_RW,	TYPE_INT,	0,	1,	1,		1,		&scsi->log,		NULL);
-}
-#else
-static inline void idescsi_add_settings(ide_drive_t *drive) { ; }
+#define ide_scsi_devset_get(name, field) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive); \
+	return scsi->field; \
+}
+
+#define ide_scsi_devset_set(name, field) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive); \
+	scsi->field = arg; \
+	return 0; \
+}
+
+#define ide_scsi_devset_rw_field(_name, _field) \
+ide_scsi_devset_get(_name, _field); \
+ide_scsi_devset_set(_name, _field); \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name);
+
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+
+ide_scsi_devset_rw_field(transform, transform);
+ide_scsi_devset_rw_field(log, log);
+
+static const struct ide_proc_devset idescsi_settings[] = {
+	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
+	IDE_PROC_DEVSET(bios_head, 0,  255),
+	IDE_PROC_DEVSET(bios_sect, 0,	63),
+	IDE_PROC_DEVSET(log,	   0,	 1),
+	IDE_PROC_DEVSET(transform, 0,	 3),
+	{ 0 },
+};
 #endif
 
 /*
@@ -452,7 +427,7 @@ static inline void idescsi_add_settings(ide_drive_t *drive) { ; }
  */
 static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
-	if (drive->id && (drive->id->config & 0x0060) == 0x20)
+	if ((drive->id[ATA_ID_CONFIG] & 0x0060) == 0x20)
 		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
@@ -461,7 +436,7 @@ static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 
 	drive->pc_callback = ide_scsi_callback;
 
-	idescsi_add_settings(drive);
+	ide_proc_register_driver(drive, scsi->driver);
 }
 
 static void ide_scsi_remove(ide_drive_t *drive)
@@ -503,12 +478,12 @@ static ide_driver_t idescsi_driver = {
 	.remove			= ide_scsi_remove,
 	.version		= IDESCSI_VERSION,
 	.media			= ide_scsi,
-	.supports_dsc_overlap	= 0,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idescsi_proc,
+	.settings		= idescsi_settings,
 #endif
 };
 
@@ -811,6 +786,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	static int warned;
 	int err = -ENOMEM;
+	u16 last_lun;
 
 	if (!warned && drive->media == ide_cdrom) {
 		printk(KERN_WARNING "ide-scsi is deprecated for cd burning! Use ide-cd and give dev=/dev/hdX as device\n");
@@ -821,7 +797,6 @@ static int ide_scsi_probe(ide_drive_t *drive)
 		return -ENODEV;
 
 	if (!strstr("ide-scsi", drive->driver_req) ||
-	    !drive->present ||
 	    drive->media == ide_disk ||
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
@@ -836,12 +811,12 @@ static int ide_scsi_probe(ide_drive_t *drive)
 
 	host->max_id = 1;
 
-	if (drive->id->last_lun)
-		debug_log("%s: id->last_lun=%u\n", drive->name,
-			  drive->id->last_lun);
+	last_lun = drive->id[ATA_ID_LAST_LUN];
+	if (last_lun)
+		debug_log("%s: last_lun=%u\n", drive->name, last_lun);
 
-	if ((drive->id->last_lun & 0x7) != 7)
-		host->max_lun = (drive->id->last_lun & 0x7) + 1;
+	if ((last_lun & 7) != 7)
+		host->max_lun = (last_lun & 7) + 1;
 	else
 		host->max_lun = 1;
 
@@ -852,7 +827,6 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	idescsi->host = host;
 	idescsi->disk = g;
 	g->private_data = &idescsi->driver;
-	ide_proc_register_driver(drive, &idescsi_driver);
 	err = 0;
 	idescsi_setup(drive, idescsi);
 	g->fops = &idescsi_ops;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index be00973..a53318b 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -30,6 +30,7 @@
 #define __LINUX_ATA_H__
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 /* defines only for the constants which don't work well as enums */
 #define ATA_DMA_BOUNDARY	0xffffUL
@@ -558,6 +559,15 @@ static inline int ata_id_has_flush(const u16 *id)
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
 }
 
+static inline int ata_id_flush_enabled(const u16 *id)
+{
+	if (ata_id_has_flush(id) == 0)
+		return 0;
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
+		return 0;
+	return id[ATA_ID_CFS_ENABLE_2] & (1 << 12);
+}
+
 static inline int ata_id_has_flush_ext(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
@@ -565,6 +575,19 @@ static inline int ata_id_has_flush_ext(const u16 *id)
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
 }
 
+static inline int ata_id_flush_ext_enabled(const u16 *id)
+{
+	if (ata_id_has_flush_ext(id) == 0)
+		return 0;
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
+		return 0;
+	/*
+	 * some Maxtor disks have bit 13 defined incorrectly
+	 * so check bit 10 too
+	 */
+	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
+}
+
 static inline int ata_id_has_lba48(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
@@ -574,6 +597,15 @@ static inline int ata_id_has_lba48(const u16 *id)
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
 }
 
+static inline int ata_id_lba48_enabled(const u16 *id)
+{
+	if (ata_id_has_lba48(id) == 0)
+		return 0;
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
+		return 0;
+	return id[ATA_ID_CFS_ENABLE_2] & (1 << 10);
+}
+
 static inline int ata_id_hpa_enabled(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
@@ -645,7 +677,15 @@ static inline unsigned int ata_id_major_version(const u16 *id)
 
 static inline int ata_id_is_sata(const u16 *id)
 {
-	return ata_id_major_version(id) >= 5 && id[ATA_ID_HW_CONFIG] == 0;
+	/*
+	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
+	 * verifying that word 80 by casting it to a signed type --
+	 * this trick allows us to filter out the reserved values of
+	 * 0x0000 and 0xffff along with the earlier ATA revisions...
+	 */
+	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
+		return 1;
+	return 0;
 }
 
 static inline int ata_id_has_tpm(const u16 *id)
@@ -742,6 +782,76 @@ static inline int atapi_id_dmadir(const u16 *dev_id)
 	return ata_id_major_version(dev_id) >= 7 && (dev_id[62] & 0x8000);
 }
 
+/*
+ * ata_id_is_lba_capacity_ok() performs a sanity check on
+ * the claimed LBA capacity value for the device.
+ *
+ * Returns 1 if LBA capacity looks sensible, 0 otherwise.
+ *
+ * It is called only once for each device.
+ */
+static inline int ata_id_is_lba_capacity_ok(u16 *id)
+{
+	unsigned long lba_sects, chs_sects, head, tail;
+
+	/* No non-LBA info .. so valid! */
+	if (id[ATA_ID_CYLS] == 0)
+		return 1;
+
+	lba_sects = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+
+	/*
+	 * The ATA spec tells large drives to return
+	 * C/H/S = 16383/16/63 independent of their size.
+	 * Some drives can be jumpered to use 15 heads instead of 16.
+	 * Some drives can be jumpered to use 4092 cyls instead of 16383.
+	 */
+	if ((id[ATA_ID_CYLS] == 16383 ||
+	     (id[ATA_ID_CYLS] == 4092 && id[ATA_ID_CUR_CYLS] == 16383)) &&
+	    id[ATA_ID_SECTORS] == 63 &&
+	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
+	    (lba_sects >= 16383 * 63 * id[ATA_ID_HEADS]))
+		return 1;
+
+	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
+
+	/* perform a rough sanity check on lba_sects: within 10% is OK */
+	if (lba_sects - chs_sects < chs_sects/10)
+		return 1;
+
+	/* some drives have the word order reversed */
+	head = (lba_sects >> 16) & 0xffff;
+	tail = lba_sects & 0xffff;
+	lba_sects = head | (tail << 16);
+
+	if (lba_sects - chs_sects < chs_sects/10) {
+		*(__le32 *)&id[ATA_ID_LBA_CAPACITY] = __cpu_to_le32(lba_sects);
+		return 1;	/* LBA capacity is (now) good */
+	}
+
+	return 0;	/* LBA capacity value may be bad */
+}
+
+static inline void ata_id_to_hd_driveid(u16 *id)
+{
+#ifdef __BIG_ENDIAN
+	/* accessed in struct hd_driveid as 8-bit values */
+	id[ATA_ID_MAX_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MAX_MULTSECT]);
+	id[ATA_ID_CAPABILITY]	 = __cpu_to_le16(id[ATA_ID_CAPABILITY]);
+	id[ATA_ID_OLD_PIO_MODES] = __cpu_to_le16(id[ATA_ID_OLD_PIO_MODES]);
+	id[ATA_ID_OLD_DMA_MODES] = __cpu_to_le16(id[ATA_ID_OLD_DMA_MODES]);
+	id[ATA_ID_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MULTSECT]);
+
+	/* as 32-bit values */
+	*(u32 *)&id[ATA_ID_LBA_CAPACITY] = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+	*(u32 *)&id[ATA_ID_SPG]		 = ata_id_u32(id, ATA_ID_SPG);
+
+	/* as 64-bit value */
+	*(u64 *)&id[ATA_ID_LBA_CAPACITY_2] =
+		ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
+#endif
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 6514db8..a9d82d6 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -8,7 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
+#include <linux/ata.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/completion.h>
+#include <linux/pm.h>
 #ifdef CONFIG_BLK_DEV_IDEACPI
 #include <acpi/acpi.h>
 #endif
@@ -87,12 +88,13 @@ struct ide_io_ports {
 };
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
-#define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
-#define BAD_W_STAT		(BAD_R_STAT  | WRERR_STAT)
-#define BAD_STAT		(BAD_R_STAT  | DRQ_STAT)
-#define DRIVE_READY		(READY_STAT  | SEEK_STAT)
 
-#define BAD_CRC			(ABRT_ERR    | ICRC_ERR)
+#define BAD_R_STAT	(ATA_BUSY | ATA_ERR)
+#define BAD_W_STAT	(BAD_R_STAT | ATA_DF)
+#define BAD_STAT	(BAD_R_STAT | ATA_DRQ)
+#define DRIVE_READY	(ATA_DRDY | ATA_DSC)
+
+#define BAD_CRC		(ATA_ABORTED | ATA_ICRC)
 
 #define SATA_NR_PORTS		(3)	/* 16 possible ?? */
 
@@ -125,24 +127,41 @@ struct ide_io_ports {
 #define PARTN_BITS	6	/* number of minor dev bits for partitions */
 #define MAX_DRIVES	2	/* per interface; 2 assumed by lots of code */
 #define SECTOR_SIZE	512
-#define SECTOR_WORDS	(SECTOR_SIZE / 4)	/* number of 32bit words per sector */
+
 #define IDE_LARGE_SEEK(b1,b2,t)	(((b1) > (b2) + (t)) || ((b2) > (b1) + (t)))
 
 /*
  * Timeouts for various operations:
  */
-#define WAIT_DRQ	(HZ/10)		/* 100msec - spec allows up to 20ms */
-#define WAIT_READY	(5*HZ)		/* 5sec - some laptops are very slow */
-#define WAIT_PIDENTIFY	(10*HZ)	/* 10sec  - should be less than 3ms (?), if all ATAPI CD is closed at boot */
-#define WAIT_WORSTCASE	(30*HZ)	/* 30sec  - worst case when spinning up */
-#define WAIT_CMD	(10*HZ)	/* 10sec  - maximum wait for an IRQ to happen */
-#define WAIT_MIN_SLEEP	(2*HZ/100)	/* 20msec - minimum sleep time */
+enum {
+	/* spec allows up to 20ms */
+	WAIT_DRQ	= HZ / 10,	/* 100ms */
+	/* some laptops are very slow */
+	WAIT_READY	= 5 * HZ,	/* 5s */
+	/* should be less than 3ms (?), if all ATAPI CD is closed at boot */
+	WAIT_PIDENTIFY	= 10 * HZ,	/* 10s */
+	/* worst case when spinning up */
+	WAIT_WORSTCASE	= 30 * HZ,	/* 30s */
+	/* maximum wait for an IRQ to happen */
+	WAIT_CMD	= 10 * HZ,	/* 10s */
+	/* Some drives require a longer IRQ timeout. */
+	WAIT_FLOPPY_CMD	= 50 * HZ,	/* 50s */
+	/*
+	 * Some drives (for example, Seagate STT3401A Travan) require a very
+	 * long timeout, because they don't return an interrupt or clear their
+	 * BSY bit until after the command completes (even retension commands).
+	 */
+	WAIT_TAPE_CMD	= 900 * HZ,	/* 900s */
+	/* minimum sleep time */
+	WAIT_MIN_SLEEP	= HZ / 50,	/* 20ms */
+};
 
 /*
  * Op codes for special requests to be handled by ide_special_rq().
  * Values should be in the range of 0x20 to 0x3f.
  */
 #define REQ_DRIVE_RESET		0x20
+#define REQ_DEVSET_EXEC		0x21
 
 /*
  * Check for an interrupt and acknowledge the interrupt status
@@ -303,8 +322,8 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
+struct ide_devset;
 struct ide_driver_s;
-struct ide_settings_s;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 struct ide_acpi_drive_link;
@@ -315,10 +334,10 @@ struct ide_acpi_hwif_link;
 enum {
 	IDE_AFLAG_DRQ_INTERRUPT		= (1 << 0),
 	IDE_AFLAG_MEDIA_CHANGED		= (1 << 1),
-
-	/* ide-cd */
 	/* Drive cannot lock the door. */
 	IDE_AFLAG_NO_DOORLOCK		= (1 << 2),
+
+	/* ide-cd */
 	/* Drive cannot eject the disc. */
 	IDE_AFLAG_NO_EJECT		= (1 << 3),
 	/* Drive is a pre ATAPI 1.2 drive. */
@@ -354,21 +373,25 @@ enum {
 	IDE_AFLAG_CLIK_DRIVE		= (1 << 19),
 	/* Requires BH algorithm for packets */
 	IDE_AFLAG_ZIP_DRIVE		= (1 << 20),
+	/* Write protect */
+	IDE_AFLAG_WP			= (1 << 21),
+	/* Supports format progress report */
+	IDE_AFLAG_SRFP			= (1 << 22),
 
 	/* ide-tape */
-	IDE_AFLAG_IGNORE_DSC		= (1 << 21),
+	IDE_AFLAG_IGNORE_DSC		= (1 << 23),
 	/* 0 When the tape position is unknown */
-	IDE_AFLAG_ADDRESS_VALID		= (1 <<	22),
+	IDE_AFLAG_ADDRESS_VALID		= (1 <<	24),
 	/* Device already opened */
-	IDE_AFLAG_BUSY			= (1 << 23),
+	IDE_AFLAG_BUSY			= (1 << 25),
 	/* Attempt to auto-detect the current user block size */
-	IDE_AFLAG_DETECT_BS		= (1 << 24),
+	IDE_AFLAG_DETECT_BS		= (1 << 26),
 	/* Currently on a filemark */
-	IDE_AFLAG_FILEMARK		= (1 << 25),
+	IDE_AFLAG_FILEMARK		= (1 << 27),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 26),
+	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 28),
 
-	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 27),
+	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 29),
 };
 
 struct ide_drive_s {
@@ -380,10 +403,10 @@ struct ide_drive_s {
 	struct request		*rq;	/* current request */
 	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
-	struct hd_driveid	*id;	/* drive model identification info */
+	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
-	struct ide_settings_s *settings;/* /proc/ide/ drive settings */
+	const struct ide_proc_devset *settings; /* /proc/ide/ drive settings */
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
@@ -395,16 +418,16 @@ struct ide_drive_s {
 	special_t	special;	/* special action flags */
 	select_t	select;		/* basic drive/head select reg value */
 
-	u8	keep_settings;		/* restore settings after drive reset */
-	u8	using_dma;		/* disk is using dma for read/write */
 	u8	retry_pio;		/* retrying dma capable host in pio */
 	u8	state;			/* retry state */
 	u8	waiting_for_dma;	/* dma currently in progress */
-	u8	unmask;			/* okay to unmask other irqs */
-	u8	noflush;		/* don't attempt flushes */
-	u8	dsc_overlap;		/* DSC overlap */
-	u8	nice1;			/* give potential excess bandwidth */
 
+	unsigned keep_settings	: 1;	/* restore settings after drive reset */
+	unsigned using_dma	: 1;	/* disk is using dma for read/write */
+	unsigned unmask		: 1;	/* okay to unmask other irqs */
+	unsigned noflush	: 1;	/* don't attempt flushes */
+	unsigned dsc_overlap	: 1;	/* DSC overlap */
+	unsigned nice1		: 1;	/* give potential excess bandwidth */
 	unsigned present	: 1;	/* drive is physically present */
 	unsigned dead		: 1;	/* device ejected hint */
 	unsigned id_read	: 1;	/* 1=id read from disk 0 = synthetic */
@@ -414,23 +437,22 @@ struct ide_drive_s {
 	unsigned forced_geom	: 1;	/* 1 if hdx=c,h,s was given at boot */
 	unsigned no_unmask	: 1;	/* disallow setting unmask bit */
 	unsigned no_io_32bit	: 1;	/* disallow enabling 32bit I/O */
-	unsigned atapi_overlap	: 1;	/* ATAPI overlap (not supported) */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
 	unsigned nodma		: 1;	/* disallow DMA */
-	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
 	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
 	unsigned udma33_warned	: 1;
+	unsigned addressing	: 2;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
+	unsigned wcache		: 1;	/* status of write cache */
+	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
 
-	u8	addressing;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
-        u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
 	u8	ready_stat;	/* min status value for drive ready */
@@ -438,9 +460,7 @@ struct ide_drive_s {
 	u8	mult_req;	/* requested multiple sector setting */
 	u8	tune_req;	/* requested drive tuning setting */
 	u8	io_32bit;	/* 0=16-bit, 1=32-bit, 2/3=32bit+sync */
-	u8	bad_wstat;	/* used for ignoring WRERR_STAT */
-	u8	nowerr;		/* used for ignoring WRERR_STAT */
-	u8	sect0;		/* offset of first sector for DM6:DDO */
+	u8	bad_wstat;	/* used for ignoring ATA_DF */
 	u8	head;		/* "real" number of heads */
 	u8	sect;		/* "real" sectors per track */
 	u8	bios_head;	/* BIOS/fdisk/LILO number of heads */
@@ -474,10 +494,6 @@ typedef struct ide_drive_s ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
 
-#define IDE_CHIPSET_PCI_MASK	\
-    ((1<<ide_pci)|(1<<ide_cmd646)|(1<<ide_ali14xx))
-#define IDE_CHIPSET_IS_PCI(c)	((IDE_CHIPSET_PCI_MASK >> (c)) & 1)
-
 struct ide_task_s;
 struct ide_port_info;
 
@@ -567,7 +583,6 @@ typedef struct hwif_s {
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
 	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
-	u8 bus_state;	/* power state of the IDE bus */
 
 	u32 host_flags;
 
@@ -645,6 +660,7 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
 	struct device	*dev[2];
+	unsigned int	(*init_chipset)(struct pci_dev *);
 	unsigned long	host_flags;
 	void		*host_priv;
 };
@@ -692,9 +708,61 @@ typedef struct ide_driver_s ide_driver_t;
 
 extern struct mutex ide_setting_mtx;
 
-int set_io_32bit(ide_drive_t *, int);
-int set_pio_mode(ide_drive_t *, int);
-int set_using_dma(ide_drive_t *, int);
+/*
+ * configurable drive settings
+ */
+
+#define DS_SYNC	(1 << 0)
+
+struct ide_devset {
+	int		(*get)(ide_drive_t *);
+	int		(*set)(ide_drive_t *, int);
+	unsigned int	flags;
+};
+
+#define __DEVSET(_flags, _get, _set) { \
+	.flags	= _flags, \
+	.get	= _get,	\
+	.set	= _set,	\
+}
+
+#define ide_devset_get(name, field) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	return drive->field; \
+}
+
+#define ide_devset_set(name, field) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	drive->field = arg; \
+	return 0; \
+}
+
+#define __IDE_DEVSET(_name, _flags, _get, _set) \
+const struct ide_devset ide_devset_##_name = \
+	__DEVSET(_flags, _get, _set)
+
+#define IDE_DEVSET(_name, _flags, _get, _set) \
+static __IDE_DEVSET(_name, _flags, _get, _set)
+
+#define ide_devset_rw(_name, _func) \
+IDE_DEVSET(_name, 0, get_##_func, set_##_func)
+
+#define ide_devset_w(_name, _func) \
+IDE_DEVSET(_name, 0, NULL, set_##_func)
+
+#define ide_devset_rw_sync(_name, _func) \
+IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
+
+#define ide_decl_devset(_name) \
+extern const struct ide_devset ide_devset_##_name
+
+ide_decl_devset(io_32bit);
+ide_decl_devset(keepsettings);
+ide_decl_devset(pio_mode);
+ide_decl_devset(unmaskirq);
+ide_decl_devset(using_dma);
 
 /* ATAPI packet command flags */
 enum {
@@ -710,6 +778,12 @@ enum {
 	PC_FLAG_TIMEDOUT		= (1 << 7),
 };
 
+/*
+ * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
+ * This is used for several packet commands (not for READ/WRITE commands).
+ */
+#define IDE_PC_BUFFER_SIZE	256
+
 struct ide_atapi_pc {
 	/* actual packet bytes */
 	u8 c[12];
@@ -739,7 +813,7 @@ struct ide_atapi_pc {
 	 * those are more or less driver-specific and some of them are subject
 	 * to change/removal later.
 	 */
-	u8 pc_buf[256];
+	u8 pc_buf[IDE_PC_BUFFER_SIZE];
 
 	/* idetape only */
 	struct idetape_bh *bh;
@@ -757,37 +831,34 @@ struct ide_atapi_pc {
 
 #ifdef CONFIG_IDE_PROC_FS
 /*
- * configurable drive settings
+ * /proc/ide interface
  */
 
-#define TYPE_INT	0
-#define TYPE_BYTE	1
-#define TYPE_SHORT	2
+#define ide_devset_rw_field(_name, _field) \
+ide_devset_get(_name, _field); \
+ide_devset_set(_name, _field); \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
+
+struct ide_proc_devset {
+	const char		*name;
+	const struct ide_devset	*setting;
+	int			min, max;
+	int			(*mulf)(ide_drive_t *);
+	int			(*divf)(ide_drive_t *);
+};
 
-#define SETTING_READ	(1 << 0)
-#define SETTING_WRITE	(1 << 1)
-#define SETTING_RW	(SETTING_READ | SETTING_WRITE)
+#define __IDE_PROC_DEVSET(_name, _min, _max, _mulf, _divf) { \
+	.name = __stringify(_name), \
+	.setting = &ide_devset_##_name, \
+	.min = _min, \
+	.max = _max, \
+	.mulf = _mulf, \
+	.divf = _divf, \
+}
 
-typedef int (ide_procset_t)(ide_drive_t *, int);
-typedef struct ide_settings_s {
-	char			*name;
-	int			rw;
-	int			data_type;
-	int			min;
-	int			max;
-	int			mul_factor;
-	int			div_factor;
-	void			*data;
-	ide_procset_t		*set;
-	int			auto_remove;
-	struct ide_settings_s	*next;
-} ide_settings_t;
-
-int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
+#define IDE_PROC_DEVSET(_name, _min, _max) \
+__IDE_PROC_DEVSET(_name, _min, _max, NULL, NULL)
 
-/*
- * /proc/ide interface
- */
 typedef struct {
 	const char	*name;
 	mode_t		mode;
@@ -804,8 +875,6 @@ void ide_proc_unregister_port(ide_hwif_t *);
 void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
 void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
 
-void ide_add_generic_settings(ide_drive_t *);
-
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
 
@@ -833,7 +902,6 @@ static inline void ide_proc_unregister_device(ide_drive_t *drive) { ; }
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
 static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
-static inline void ide_add_generic_settings(ide_drive_t *drive) { ; }
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
@@ -879,7 +947,6 @@ enum {
 struct ide_driver_s {
 	const char			*version;
 	u8				media;
-	unsigned supports_dsc_overlap	: 1;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
@@ -889,7 +956,8 @@ struct ide_driver_s {
 	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
-	ide_proc_entry_t	*proc;
+	ide_proc_entry_t		*proc;
+	const struct ide_proc_devset	*settings;
 #endif
 };
 
@@ -898,7 +966,17 @@ struct ide_driver_s {
 int ide_device_get(ide_drive_t *);
 void ide_device_put(ide_drive_t *);
 
-int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsigned, unsigned long);
+struct ide_ioctl_devset {
+	unsigned int	get_ioctl;
+	unsigned int	set_ioctl;
+	const struct ide_devset *setting;
+};
+
+int ide_setting_ioctl(ide_drive_t *, struct block_device *, unsigned int,
+		      unsigned long, const struct ide_ioctl_devset *);
+
+int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *,
+		      unsigned, unsigned long);
 
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
@@ -920,14 +998,19 @@ ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
 
-extern void ide_fix_driveid(struct hd_driveid *);
+void ide_fix_driveid(u16 *);
 
 extern void ide_fixstring(u8 *, const int, const int);
 
+int ide_busy_sleep(ide_hwif_t *, unsigned long, int);
+
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
+extern int ide_devset_execute(ide_drive_t *drive,
+			      const struct ide_devset *setting, int arg);
+
 extern void ide_do_drive_cmd(ide_drive_t *, struct request *);
 
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
@@ -1051,6 +1134,8 @@ void ide_tf_read(ide_drive_t *, ide_task_t *);
 void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
 
+int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
+
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
@@ -1061,11 +1146,36 @@ extern int drive_is_ready(ide_drive_t *);
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
+int ide_check_atapi_device(ide_drive_t *, const char *);
+
+void ide_init_pc(struct ide_atapi_pc *);
+
+/*
+ * Special requests for ide-tape block device strategy routine.
+ *
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
+ */
+enum {
+	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
+	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
+	REQ_IDETAPE_READ	= (1 << 2),
+	REQ_IDETAPE_WRITE	= (1 << 3),
+};
+
+void ide_queue_pc_head(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
+		       struct request *);
+int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
+
+int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
+int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
+int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
+
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
+	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
 			   int));
 ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
@@ -1080,8 +1190,6 @@ int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
 int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
-int ide_cmd_ioctl(ide_drive_t *, unsigned int, unsigned long);
-int ide_task_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
@@ -1092,7 +1200,6 @@ extern int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout);
 
 extern void ide_stall_queue(ide_drive_t *drive, unsigned long timeout);
 
-extern int ide_spin_wait_hwgroup(ide_drive_t *);
 extern void ide_timer_expiry(unsigned long);
 extern irqreturn_t ide_intr(int irq, void *dev_id);
 extern void do_ide_request(struct request_queue *);
@@ -1229,6 +1336,14 @@ int ide_pci_init_two(struct pci_dev *, struct pci_dev *,
 		     const struct ide_port_info *, void *);
 void ide_pci_remove(struct pci_dev *);
 
+#ifdef CONFIG_PM
+int ide_pci_suspend(struct pci_dev *, pm_message_t);
+int ide_pci_resume(struct pci_dev *);
+#else
+#define ide_pci_suspend NULL
+#define ide_pci_resume NULL
+#endif
+
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);
 
@@ -1240,7 +1355,7 @@ struct drive_list_entry {
 	const char *id_firmware;
 };
 
-int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
+int ide_in_drive_list(u16 *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
@@ -1347,24 +1462,6 @@ const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
-static inline int ide_dev_has_iordy(struct hd_driveid *id)
-{
-	return ((id->field_valid & 2) && (id->capability & 8)) ? 1 : 0;
-}
-
-static inline int ide_dev_is_sata(struct hd_driveid *id)
-{
-	/*
-	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
-	 * verifying that word 80 by casting it to a signed type --
-	 * this trick allows us to filter out the reserved values of
-	 * 0x0000 and 0xffff along with the earlier ATA revisions...
-	 */
-	if (id->hw_config == 0 && (short)id->major_rev_num >= 0x0020)
-		return 1;
-	return 0;
-}
-
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
@@ -1436,13 +1533,6 @@ extern struct mutex ide_cfg_mtx;
 extern struct bus_type ide_bus_type;
 extern struct class *ide_port_class;
 
-/* check if CACHE FLUSH (EXT) command is supported (bits defined in ATA-6) */
-#define ide_id_has_flush_cache(id)	((id)->cfs_enable_2 & 0x3000)
-
-/* some Maxtor disks have bit 13 defined incorrectly so check bit 10 too */
-#define ide_id_has_flush_cache_ext(id)	\
-	(((id)->cfs_enable_2 & 0x2400) == 0x2400)
-
 static inline void ide_dump_identify(u8 *id)
 {
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 2, id, 512, 0);
@@ -1453,10 +1543,10 @@ static inline int hwif_to_node(ide_hwif_t *hwif)
 	return hwif->dev ? dev_to_node(hwif->dev) : -1;
 }
 
-static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
+static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
 
-	return &hwif->drives[(drive->dn ^ 1) & 1];
+	return peer->present ? peer : NULL;
 }
 #endif /* _IDE_H */
