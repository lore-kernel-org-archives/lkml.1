Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYLPTeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYLPTeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYLPTc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64756 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYLPTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tVRtKWaQ4AMWVbZMzeOOWp01oLCfzAybJixsnz9dnfvbN5poaNKImCggaW4U8mfo+3
         07uYLOUmL/EOKQsA+IBWHgImWmh7I+pyd4BuBooIa5oq0JomyOU1naW8+p41BertRGij
         G0Jk8yRQKeN/r0OTA/2NXty8qVstgMhdWt9Kc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:32:17 +0100
Message-Id: <20081216193217.3959.81489.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ide: remove ide_driver_t typedef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_driver_t typedef

While at it:
- s/struct ide_driver_s/struct ide_driver/
- use to_ide_driver() macro in ide-proc.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c       |    2 +-
 drivers/ide/ide-cd.h       |    8 ++++----
 drivers/ide/ide-gd.c       |    2 +-
 drivers/ide/ide-gd.h       |   10 +++++-----
 drivers/ide/ide-io.c       |   12 ++++++------
 drivers/ide/ide-pm.c       |    2 +-
 drivers/ide/ide-proc.c     |   16 ++++++++--------
 drivers/ide/ide-tape.c     |   10 +++++-----
 drivers/ide/ide-taskfile.c |    8 ++++----
 drivers/ide/ide.c          |    6 +++---
 include/linux/ide.h        |   18 +++++++++---------
 11 files changed, 47 insertions(+), 47 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1941,7 +1941,7 @@ static void ide_cd_release(struct kref *
 
 static int ide_cd_probe(ide_drive_t *);
 
-static ide_driver_t ide_cdrom_driver = {
+static struct ide_driver ide_cdrom_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-cdrom",
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -77,10 +77,10 @@ struct atapi_toc {
 
 /* Extra per-device info for cdrom drives. */
 struct cdrom_info {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
 
 	/* Buffer for table of contents.  NULL if we haven't allocated
 	   a TOC buffer for this device yet. */
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -149,7 +149,7 @@ static int ide_gd_end_request(ide_drive_
 	return drive->disk_ops->end_request(drive, uptodate, nrsecs);
 }
 
-static ide_driver_t ide_gd_driver = {
+static struct ide_driver ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-gd",
Index: b/drivers/ide/ide-gd.h
===================================================================
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -14,11 +14,11 @@
 #endif
 
 struct ide_disk_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
+	unsigned int		openers;	/* protected by BKL for now */
 
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -199,9 +199,9 @@ EXPORT_SYMBOL(ide_end_drive_cmd);
 static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
 	if (rq->rq_disk) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 		drv->end_request(drive, 0, 0);
 	} else
 		ide_end_request(drive, 0, 0);
@@ -333,9 +333,9 @@ ide_startstop_t ide_error (ide_drive_t *
 	}
 
 	if (rq->rq_disk) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 		return drv->error(drive, rq, stat, err);
 	} else
 		return __ide_error(drive, rq, stat, err);
@@ -606,7 +606,7 @@ static ide_startstop_t start_request (id
 		return startstop;
 	}
 	if (!drive->special.all) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
 		/*
 		 * We reset the drive so we need to issue a SETFEATURES.
@@ -639,7 +639,7 @@ static ide_startstop_t start_request (id
 			 */
 			return ide_special_rq(drive, rq);
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 
 		return drv->do_request(drive, rq, rq->sector);
 	}
Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -67,7 +67,7 @@ int generic_ide_resume(struct device *de
 	blk_put_request(rq);
 
 	if (err == 0 && dev->driver) {
-		ide_driver_t *drv = to_ide_driver(dev->driver);
+		struct ide_driver *drv = to_ide_driver(dev->driver);
 
 		if (drv->resume)
 			drv->resume(drive);
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -439,13 +439,13 @@ static int proc_ide_read_dmodel
 static int proc_ide_read_driver
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	ide_drive_t	*drive = (ide_drive_t *) data;
-	struct device	*dev = &drive->gendev;
-	ide_driver_t	*ide_drv;
-	int		len;
+	ide_drive_t		*drive = (ide_drive_t *)data;
+	struct device		*dev = &drive->gendev;
+	struct ide_driver	*ide_drv;
+	int			len;
 
 	if (dev->driver) {
-		ide_drv = container_of(dev->driver, ide_driver_t, gen_driver);
+		ide_drv = to_ide_driver(dev->driver);
 		len = sprintf(page, "%s version %s\n",
 				dev->driver->name, ide_drv->version);
 	} else
@@ -555,7 +555,7 @@ static void ide_remove_proc_entries(stru
 	}
 }
 
-void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
+void ide_proc_register_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
 	mutex_lock(&ide_setting_mtx);
 	drive->settings = driver->proc_devsets(drive);
@@ -577,7 +577,7 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	Takes ide_setting_mtx.
  */
 
-void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
+void ide_proc_unregister_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
 	ide_remove_proc_entries(drive->proc, driver->proc_entries(drive));
 
@@ -653,7 +653,7 @@ void ide_proc_unregister_port(ide_hwif_t
 
 static int proc_print_driver(struct device_driver *drv, void *data)
 {
-	ide_driver_t *ide_drv = container_of(drv, ide_driver_t, gen_driver);
+	struct ide_driver *ide_drv = to_ide_driver(drv);
 	struct seq_file *s = data;
 
 	seq_printf(s, "%s version %s\n", drv->name, ide_drv->version);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -166,10 +166,10 @@ struct idetape_bh {
  * to an interrupt or a timer event is stored in the struct defined below.
  */
 typedef struct ide_tape_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
 
 	/*
 	 *	failed_pc points to the last failed packet command, or contains
@@ -2313,7 +2313,7 @@ static const struct ide_proc_devset *ide
 
 static int ide_tape_probe(ide_drive_t *);
 
-static ide_driver_t idetape_driver = {
+static struct ide_driver idetape_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-tape",
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -309,9 +309,9 @@ static ide_startstop_t task_error(ide_dr
 		}
 
 		if (sectors > 0) {
-			ide_driver_t *drv;
+			struct ide_driver *drv;
 
-			drv = *(ide_driver_t **)rq->rq_disk->private_data;
+			drv = *(struct ide_driver **)rq->rq_disk->private_data;
 			drv->end_request(drive, 1, sectors);
 		}
 	}
@@ -328,9 +328,9 @@ void task_end_request(ide_drive_t *drive
 	}
 
 	if (rq->rq_disk) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;;
 		drv->end_request(drive, 1, rq->nr_sectors);
 	} else
 		ide_end_request(drive, 1, rq->nr_sectors);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -435,7 +435,7 @@ static int ide_uevent(struct device *dev
 static int generic_ide_probe(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	return drv->probe ? drv->probe(drive) : -ENODEV;
 }
@@ -443,7 +443,7 @@ static int generic_ide_probe(struct devi
 static int generic_ide_remove(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	if (drv->remove)
 		drv->remove(drive);
@@ -454,7 +454,7 @@ static int generic_ide_remove(struct dev
 static void generic_ide_shutdown(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	if (dev->driver && drv->shutdown)
 		drv->shutdown(drive);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -439,7 +439,7 @@ struct ide_atapi_pc {
 };
 
 struct ide_devset;
-struct ide_driver_s;
+struct ide_driver;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 struct ide_acpi_drive_link;
@@ -885,8 +885,6 @@ typedef int (ide_expiry_t)(ide_drive_t *
 /* used by ide-cd, ide-floppy, etc. */
 typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
 
-typedef struct ide_driver_s ide_driver_t;
-
 extern struct mutex ide_setting_mtx;
 
 /*
@@ -1012,8 +1010,8 @@ void ide_proc_register_port(ide_hwif_t *
 void ide_proc_port_register_devices(ide_hwif_t *);
 void ide_proc_unregister_device(ide_drive_t *);
 void ide_proc_unregister_port(ide_hwif_t *);
-void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
-void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
+void ide_proc_register_driver(ide_drive_t *, struct ide_driver *);
+void ide_proc_unregister_driver(ide_drive_t *, struct ide_driver *);
 
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
@@ -1040,8 +1038,10 @@ static inline void ide_proc_register_por
 static inline void ide_proc_port_register_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_unregister_device(ide_drive_t *drive) { ; }
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
-static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
-static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
+static inline void ide_proc_register_driver(ide_drive_t *drive,
+					    struct ide_driver *driver) { ; }
+static inline void ide_proc_unregister_driver(ide_drive_t *drive,
+					      struct ide_driver *driver) { ; }
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
@@ -1110,7 +1110,7 @@ void ide_check_pm_state(ide_drive_t *, s
  * The gendriver.owner field should be set to the module owner of this driver.
  * The gendriver.name field should be set to the name of this driver
  */
-struct ide_driver_s {
+struct ide_driver {
 	const char			*version;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
@@ -1126,7 +1126,7 @@ struct ide_driver_s {
 #endif
 };
 
-#define to_ide_driver(drv) container_of(drv, ide_driver_t, gen_driver)
+#define to_ide_driver(drv) container_of(drv, struct ide_driver, gen_driver)
 
 int ide_device_get(ide_drive_t *);
 void ide_device_put(ide_drive_t *);
