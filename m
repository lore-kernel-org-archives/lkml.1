Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYBQTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYBQTld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYBQTkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:40:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:51349 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYBQTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fgy5jWNbgH7HeRGlz5QnIeIopBHLNzE0fHgXbsRt0SpFlF5/ErqcDkwyTiVlkzbxnkNdlc1FSIkDncUuFsY0SNzMnpiLCOpmv3H2MN8td4wogZIi6ovHyQ5iQOqGpejBW3utxIIKAt5a0Ttgg2xDeYemcCnVnOwS8jdwT5Bx+rQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide-disk: fix issues found by checkpatch.pl
Date: Sun, 17 Feb 2008 20:54:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172054.05788.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no changes to the resulting drivers/ide/ide-disk.o binary file
(md5sum-s after and before the patch match).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |  120 ++++++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 50 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -16,8 +16,6 @@
 
 #define IDEDISK_VERSION	"1.18"
 
-//#define DEBUG
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -88,7 +86,7 @@ static void ide_disk_put(struct ide_disk
  *
  * It is called only once for each drive.
  */
-static int lba_capacity_is_ok (struct hd_driveid *id)
+static int lba_capacity_is_ok(struct hd_driveid *id)
 {
 	unsigned long lba_sects, chs_sects, head, tail;
 
@@ -176,7 +174,8 @@ static void ide_tf_set_cmd(ide_drive_t *
  * __ide_do_rw_disk() issues READ and WRITE commands to a disk,
  * using LBA if supported, or CHS otherwise, to address sectors.
  */
-static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+					sector_t block)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned int dma	= drive->using_dma;
@@ -228,7 +227,8 @@ static ide_startstop_t __ide_do_rw_disk(
 			tf->device = (block >> 8) & 0xf;
 		}
 	} else {
-		unsigned int sect,head,cyl,track;
+		unsigned int sect, head, cyl, track;
+
 		track = (int)block / drive->sect;
 		sect  = (int)block % drive->sect + 1;
 		head  = track % drive->head;
@@ -271,7 +271,8 @@ static ide_startstop_t __ide_do_rw_disk(
  * 1073741822 == 549756 MB or 48bit addressing fake drive
  */
 
-static ide_startstop_t ide_do_rw_disk (ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+				      sector_t block)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
@@ -452,7 +453,7 @@ static void idedisk_check_hpa(ide_drive_
  * in above order (i.e., if value of higher priority is available,
  * reset will be ignored).
  */
-static void init_idedisk_capacity (ide_drive_t  *drive)
+static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 	/*
@@ -479,7 +480,7 @@ static void init_idedisk_capacity (ide_d
 	}
 }
 
-static sector_t idedisk_capacity (ide_drive_t *drive)
+static sector_t idedisk_capacity(ide_drive_t *drive)
 {
 	return drive->capacity64 - drive->sect0;
 }
@@ -524,10 +525,11 @@ static int proc_idedisk_read_cache
 	int		len;
 
 	if (drive->id_read)
-		len = sprintf(out,"%i\n", drive->id->buf_size / 2);
+		len = sprintf(out, "%i\n", drive->id->buf_size / 2);
 	else
-		len = sprintf(out,"(none)\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+		len = sprintf(out, "(none)\n");
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_idedisk_read_capacity
@@ -536,8 +538,9 @@ static int proc_idedisk_read_capacity
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)idedisk_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)idedisk_capacity(drive));
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_idedisk_read_smart(char *page, char **start, off_t off,
@@ -551,12 +554,14 @@ static int proc_idedisk_read_smart(char 
 		char *out = ((char *)val) + (SECTOR_WORDS * 4);
 		page = out;
 		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val), (++i & 7) ? ' ' : '\n');
+			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
+				       (++i & 7) ? ' ' : '\n');
 			val += 1;
 		} while (i < (SECTOR_WORDS * 2));
 		len = out - page;
 	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_idedisk_read_sv
@@ -620,12 +625,13 @@ static int set_multcount(ide_drive_t *dr
 	if (drive->special.b.set_multmode)
 		return -EBUSY;
 
-	ide_init_drive_cmd (&rq);
+	ide_init_drive_cmd(&rq);
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
 	drive->special.b.set_multmode = 1;
-	(void) ide_do_drive_cmd (drive, &rq, ide_wait);
+	(void)ide_do_drive_cmd(drive, &rq, ide_wait);
+
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
@@ -701,7 +707,7 @@ static int write_cache(ide_drive_t *driv
 	return err;
 }
 
-static int do_idedisk_flushcache (ide_drive_t *drive)
+static int do_idedisk_flushcache(ide_drive_t *drive)
 {
 	ide_task_t args;
 
@@ -714,7 +720,7 @@ static int do_idedisk_flushcache (ide_dr
 	return ide_no_data_taskfile(drive, &args);
 }
 
-static int set_acoustic (ide_drive_t *drive, int arg)
+static int set_acoustic(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
 
@@ -748,7 +754,7 @@ static int set_lba_addressing(ide_drive_
 		return 0;
 
 	if (!idedisk_supports_lba48(drive->id))
-                return -EIO;
+		return -EIO;
 	drive->addressing = arg;
 	return 0;
 }
@@ -758,23 +764,35 @@ static void idedisk_add_settings(ide_dri
 {
 	struct hd_driveid *id = drive->id;
 
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,			1,	1,	&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,			1,	1,	&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"address",	SETTING_RW,	TYPE_BYTE,	0,	2,			1,	1,	&drive->addressing,	set_lba_addressing);
-	ide_add_setting(drive,	"multcount",	SETTING_RW,	TYPE_BYTE,	0,	id->max_multsect,	1,	1,	&drive->mult_count,	set_multcount);
-	ide_add_setting(drive,	"nowerr",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->nowerr,		set_nowerr);
-	ide_add_setting(drive,	"lun",		SETTING_RW,	TYPE_INT,	0,	7,			1,	1,	&drive->lun,		NULL);
-	ide_add_setting(drive,	"wcache",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->wcache,		write_cache);
-	ide_add_setting(drive,	"acoustic",	SETTING_RW,	TYPE_BYTE,	0,	254,			1,	1,	&drive->acoustic,	set_acoustic);
- 	ide_add_setting(drive,	"failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->failures,	NULL);
- 	ide_add_setting(drive,	"max_failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->max_failures,	NULL);
+	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
+			&drive->bios_cyl, NULL);
+	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
+			&drive->bios_head, NULL);
+	ide_add_setting(drive, "bios_sect", SETTING_RW, TYPE_BYTE, 0, 63, 1, 1,
+			&drive->bios_sect, NULL);
+	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
+			&drive->addressing, set_lba_addressing);
+	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
+			id->max_multsect, 1, 1, &drive->mult_count,
+			set_multcount);
+	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->nowerr, set_nowerr);
+	ide_add_setting(drive, "lun", SETTING_RW, TYPE_INT, 0, 7, 1, 1,
+			&drive->lun, NULL);
+	ide_add_setting(drive, "wcache", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->wcache, write_cache);
+	ide_add_setting(drive, "acoustic", SETTING_RW, TYPE_BYTE, 0, 254, 1, 1,
+			&drive->acoustic, set_acoustic);
+	ide_add_setting(drive, "failures", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
+			&drive->failures, NULL);
+	ide_add_setting(drive, "max_failures", SETTING_RW, TYPE_INT, 0, 65535,
+			1, 1, &drive->max_failures, NULL);
 }
 #else
 static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
 #endif
 
-static void idedisk_setup (ide_drive_t *drive)
+static void idedisk_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
@@ -787,11 +805,10 @@ static void idedisk_setup (ide_drive_t *
 
 	if (drive->removable) {
 		/*
-		 * Removable disks (eg. SYQUEST); ignore 'WD' drives 
+		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
-		if (id->model[0] != 'W' || id->model[1] != 'D') {
+		if (id->model[0] != 'W' || id->model[1] != 'D')
 			drive->doorlocking = 1;
-		}
 	}
 
 	(void)set_lba_addressing(drive, 1);
@@ -805,10 +822,11 @@ static void idedisk_setup (ide_drive_t *
 		blk_queue_max_sectors(drive->queue, max_s);
 	}
 
-	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name, drive->queue->max_sectors / 2);
+	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
+			 drive->queue->max_sectors / 2);
 
 	/* calculate drive capacity, and select LBA if possible */
-	init_idedisk_capacity (drive);
+	init_idedisk_capacity(drive);
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
 	if (drive->addressing == 0 && drive->capacity64 > 1ULL << 28) {
@@ -821,9 +839,9 @@ static void idedisk_setup (ide_drive_t *
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && drive->addressing) {
 		if (drive->capacity64 > 1ULL << 28) {
-			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode will"
-					 " be used for accessing sectors > %u\n",
-					 drive->name, 1 << 28);
+			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
+					 " will be used for accessing sectors "
+					 "> %u\n", drive->name, 1 << 28);
 		} else
 			drive->addressing = 0;
 	}
@@ -832,7 +850,8 @@ static void idedisk_setup (ide_drive_t *
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
 	 */
-	capacity = idedisk_capacity (drive);
+	capacity = idedisk_capacity(drive);
+
 	if (!drive->forced_geom) {
 
 		if (idedisk_supports_lba48(drive->id)) {
@@ -988,7 +1007,8 @@ static int idedisk_open(struct inode *in
 	struct ide_disk_obj *idkp;
 	ide_drive_t *drive;
 
-	if (!(idkp = ide_disk_get(disk)))
+	idkp = ide_disk_get(disk);
+	if (idkp == NULL)
 		return -ENXIO;
 
 	drive = idkp->drive;
@@ -1110,13 +1130,13 @@ static int idedisk_revalidate_disk(struc
 }
 
 static struct block_device_operations idedisk_ops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_open,
-	.release	= idedisk_release,
-	.ioctl		= idedisk_ioctl,
-	.getgeo		= idedisk_getgeo,
-	.media_changed	= idedisk_media_changed,
-	.revalidate_disk= idedisk_revalidate_disk
+	.owner			= THIS_MODULE,
+	.open			= idedisk_open,
+	.release		= idedisk_release,
+	.ioctl			= idedisk_ioctl,
+	.getgeo			= idedisk_getgeo,
+	.media_changed		= idedisk_media_changed,
+	.revalidate_disk	= idedisk_revalidate_disk
 };
 
 MODULE_DESCRIPTION("ATA DISK Driver");
@@ -1179,7 +1199,7 @@ failed:
 	return -ENODEV;
 }
 
-static void __exit idedisk_exit (void)
+static void __exit idedisk_exit(void)
 {
 	driver_unregister(&idedisk_driver.gen_driver);
 }
