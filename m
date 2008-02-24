Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYBXVKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYBXVKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYBXVKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:10:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:30822 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYBXVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=DWeVw2cXxVE+FSXnXXtaUdRufmfiGrddNMynueoWjfCT/jbvbAcgisO4l1bjGiaYDUi3vRlOitiAxmYjco26h3cOoRyHNfAg+60Sizf26kiRz1yxZJBdFIzwEe49xPf3H9GeZa1H9JHnjciaEgES0ZgfZbIfUV3/9PhRS+8pOu8=
Date: Sun, 24 Feb 2008 22:10:33 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 1/3] IDE: Coding Style fixes to drivers/ide/ide-cd.c
Message-ID: <20080224221033.595552ce@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 43 errors, 66 warnings, 2183 lines checked

After:
total: 0 errors, 36 warnings, 2192 lines checked

I didn't (and I don't plan to) fix the warnings:
WARNING: line over 80 characters


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/ide-cd.c |  245 ++++++++++++++++++++++++++------------------------
 1 files changed, 127 insertions(+), 118 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 546f436..3181e71 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -13,8 +13,8 @@
  *
  * Suggestions are welcome. Patches that work are more welcome though. ;-)
  * For those wishing to work on this driver, please be sure you download
- * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI 
- * (SFF-8020i rev 2.6) standards. These documents can be obtained by 
+ * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI
+ * (SFF-8020i rev 2.6) standards. These documents can be obtained by
  * anonymous ftp from:
  * ftp://fission.dt.wdc.com/pub/standards/SFF_atapi/spec/SFF8020-r2.6/PS/8020r26.ps
  * ftp://ftp.avc-pioneer.com/Mtfuji4/Spec/Fuji4r10.pdf
@@ -51,7 +51,7 @@
 
 static DEFINE_MUTEX(idecd_ref_mutex);
 
-#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref) 
+#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref)
 
 #define ide_cd_g(disk) \
 	container_of((disk)->private_data, struct cdrom_info, driver)
@@ -83,7 +83,7 @@ static void ide_cd_put(struct cdrom_info *cd)
 
 /* Mark that we've seen a media change, and invalidate our internal
    buffers. */
-static void cdrom_saw_media_change (ide_drive_t *drive)
+static void cdrom_saw_media_change(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 
@@ -100,37 +100,37 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		return 0;
 
 	switch (sense->sense_key) {
-		case NO_SENSE: case RECOVERED_ERROR:
-			break;
-		case NOT_READY:
-			/*
-			 * don't care about tray state messages for
-			 * e.g. capacity commands or in-progress or
-			 * becoming ready
-			 */
-			if (sense->asc == 0x3a || sense->asc == 0x04)
-				break;
-			log = 1;
-			break;
-		case ILLEGAL_REQUEST:
-			/*
-			 * don't log START_STOP unit with LoEj set, since
-			 * we cannot reliably check if drive can auto-close
-			 */
-			if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
-				break;
-			log = 1;
+	case NO_SENSE: case RECOVERED_ERROR:
+		break;
+	case NOT_READY:
+		/*
+		 * don't care about tray state messages for
+		 * e.g. capacity commands or in-progress or
+		 * becoming ready
+		 */
+		if (sense->asc == 0x3a || sense->asc == 0x04)
 			break;
-		case UNIT_ATTENTION:
-			/*
-			 * Make good and sure we've seen this potential media
-			 * change. Some drives (i.e. Creative) fail to present
-			 * the correct sense key in the error register.
-			 */
-			cdrom_saw_media_change(drive);
+		log = 1;
+		break;
+	case ILLEGAL_REQUEST:
+		/*
+		 * don't log START_STOP unit with LoEj set, since
+		 * we cannot reliably check if drive can auto-close
+		 */
+		if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
 			break;
-		default:
-			log = 1;
+		log = 1;
+		break;
+	case UNIT_ATTENTION:
+		/*
+		 * Make good and sure we've seen this potential media
+		 * change. Some drives (i.e. Creative) fail to present
+		 * the correct sense key in the error register.
+		 */
+		cdrom_saw_media_change(drive);
+		break;
+	default:
+		log = 1;
 			break;
 	}
 	return log;
@@ -158,8 +158,8 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
- 	if (sense->error_code == 0x70) {	/* Current Error */
- 		switch(sense->sense_key) {
+	if (sense->error_code == 0x70) {	/* Current Error */
+		switch (sense->sense_key) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
@@ -178,7 +178,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
 				sector <<= 2;	/* Device sector size is 2K */
-			sector &= ~(bio_sectors -1);
+			sector &= ~(bio_sectors - 1);
 			valid = (sector - failed_command->sector) << 9;
 
 			if (valid < 0)
@@ -187,8 +187,8 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				drive->probed_capacity - sector < 4 * 75) {
 				set_capacity(info->disk, sector);
 			}
- 		}
- 	}
+		}
+	}
 
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
@@ -229,7 +229,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static void cdrom_end_request (ide_drive_t *drive, int uptodate)
+static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int nsectors = rq->hard_cur_sectors;
@@ -292,7 +292,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int stat, err, sense_key;
-	
+
 	/* Check for errors. */
 	stat = ide_read_status(drive);
 
@@ -333,26 +333,26 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 
 		/* Check for tray open. */
 		if (sense_key == NOT_READY) {
-			cdrom_saw_media_change (drive);
+			cdrom_saw_media_change(drive);
 		} else if (sense_key == UNIT_ATTENTION) {
 			/* Check for media change. */
-			cdrom_saw_media_change (drive);
+			cdrom_saw_media_change(drive);
 			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
- 		} else if ((sense_key == ILLEGAL_REQUEST) &&
- 			   (rq->cmd[0] == GPCMD_START_STOP_UNIT)) {
- 			/*
- 			 * Don't print error message for this condition--
- 			 * SFF8090i indicates that 5/24/00 is the correct
- 			 * response to a request to close the tray if the
- 			 * drive doesn't have that capability.
- 			 * cdrom_log_sense() knows this!
- 			 */
+		} else if ((sense_key == ILLEGAL_REQUEST) &&
+			   (rq->cmd[0] == GPCMD_START_STOP_UNIT)) {
+			/*
+			 * Don't print error message for this condition--
+			 * SFF8090i indicates that 5/24/00 is the correct
+			 * response to a request to close the tray if the
+			 * drive doesn't have that capability.
+			 * cdrom_log_sense() knows this!
+			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
 			/* Otherwise, print an error. */
 			ide_dump_status(drive, "packet command error", stat);
 		}
-		
+
 		rq->cmd_flags |= REQ_FAILED;
 
 		/*
@@ -373,10 +373,10 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (sense_key == NOT_READY) {
 			/* Tray open. */
 			if (rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change (drive);
+				cdrom_saw_media_change(drive);
 
 				/* Fail the request. */
-				printk ("%s: tray open\n", drive->name);
+				printk("%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
@@ -398,7 +398,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 					 */
 					spin_lock_irqsave(&ide_lock, flags);
 					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock,flags);
+					spin_unlock_irqrestore(&ide_lock, flags);
 					return 1;
 				}
 			}
@@ -406,25 +406,31 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			/* Media change. */
 			cdrom_saw_media_change (drive);
 
-			/* Arrange to retry the request.
-			   But be sure to give up if we've retried
-			   too many times. */
+			/*
+			 * Arrange to retry the request.
+			 * But be sure to give up if we've retried
+			 * too many times.
+			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
 		} else if (sense_key == ILLEGAL_REQUEST ||
 			   sense_key == DATA_PROTECT) {
-			/* No point in retrying after an illegal
-			   request or data protect error.*/
-			ide_dump_status_no_sense (drive, "command error", stat);
+			/*
+			 * No point in retrying after an illegal
+			 * request or data protect error.
+			 */
+			ide_dump_status_no_sense(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
-			/* No point in re-trying a zillion times on a bad 
-			 * sector...  If we got here the error is not correctable */
-			ide_dump_status_no_sense (drive, "media error (bad sector)", stat);
+			/*
+			 * No point in re-trying a zillion times on a bad
+			 * sector... If we got here the error is not correctable
+			 */
+			ide_dump_status_no_sense(drive, "media error (bad sector)", stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* Disk appears blank ?? */
-			ide_dump_status_no_sense (drive, "media error (blank)", stat);
+			ide_dump_status_no_sense(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
 			/* Go to the default handler
@@ -485,18 +491,18 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	 * ide_timer_expiry keep polling us for these.
 	 */
 	switch (rq->cmd[0]) {
-		case GPCMD_BLANK:
-		case GPCMD_FORMAT_UNIT:
-		case GPCMD_RESERVE_RZONE_TRACK:
-		case GPCMD_CLOSE_TRACK:
-		case GPCMD_FLUSH_CACHE:
-			wait = ATAPI_WAIT_PC;
-			break;
-		default:
-			if (!(rq->cmd_flags & REQ_QUIET))
-				printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
-			wait = 0;
-			break;
+	case GPCMD_BLANK:
+	case GPCMD_FORMAT_UNIT:
+	case GPCMD_RESERVE_RZONE_TRACK:
+	case GPCMD_CLOSE_TRACK:
+	case GPCMD_FLUSH_CACHE:
+		wait = ATAPI_WAIT_PC;
+		break;
+	default:
+		if (!(rq->cmd_flags & REQ_QUIET))
+			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
+		wait = 0;
+		break;
 	}
 	return wait;
 }
@@ -556,7 +562,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
    HANDLER is the interrupt handler to call when the command completes
    or there's data ready. */
 #define ATAPI_MIN_CDB_BYTES 12
-static ide_startstop_t cdrom_transfer_packet_command (ide_drive_t *drive,
+static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 					  struct request *rq,
 					  ide_handler_t *handler)
 {
@@ -745,7 +751,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 #define IDECD_SEEK_TIMER	(5 * WAIT_MIN_SLEEP)	/* 100 ms */
 #define IDECD_SEEK_TIMEOUT	(2 * WAIT_CMD)		/* 20 sec */
 
-static ide_startstop_t cdrom_seek_intr (ide_drive_t *drive)
+static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 	int stat;
@@ -762,14 +768,14 @@ static ide_startstop_t cdrom_seek_intr (ide_drive_t *drive)
 			 * this condition is far too common, to bother
 			 * users about it
 			 */
-			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/ 
+			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/
 			drive->dsc_overlap = 0;
 		}
 	}
 	return ide_stopped;
 }
 
-static ide_startstop_t cdrom_start_seek_continuation (ide_drive_t *drive)
+static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	sector_t frame = rq->sector;
@@ -784,7 +790,7 @@ static ide_startstop_t cdrom_start_seek_continuation (ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static ide_startstop_t cdrom_start_seek (ide_drive_t *drive, unsigned int block)
+static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 {
 	struct cdrom_info *info = drive->driver_data;
 
@@ -793,9 +799,11 @@ static ide_startstop_t cdrom_start_seek (ide_drive_t *drive, unsigned int block)
 	return cdrom_start_packet_command(drive, 0, cdrom_start_seek_continuation);
 }
 
-/* Fix up a possibly partially-processed request so that we can
-   start it over entirely, or even put it back on the request queue. */
-static void restore_request (struct request *rq)
+/*
+ * Fix up a possibly partially-processed request so that we can
+ * start it over entirely, or even put it back on the request queue.
+ */
+static void restore_request(struct request *rq)
 {
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) / SECTOR_SIZE;
@@ -846,7 +854,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 		error = ide_do_drive_cmd(drive, rq, ide_wait);
 		time = jiffies - time;
 
-		/* FIXME: we should probably abort/retry or something 
+		/* FIXME: we should probably abort/retry or something
 		 * in case of failure */
 		if (rq->cmd_flags & REQ_FAILED) {
 			/* The request failed.  Retry if it was due to a unit
@@ -1215,7 +1223,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
  * cdrom driver request routine.
  */
 static ide_startstop_t
-ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
+ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 {
 	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
@@ -1230,13 +1238,13 @@ ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
 					ide_stall_queue(drive, IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk (KERN_ERR "%s: DSC timeout\n", drive->name);
+				printk(KERN_ERR "%s: DSC timeout\n", drive->name);
 			}
 			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
-		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap) {
+		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap)
 			action = cdrom_start_seek(drive, block);
-		} else
+		else
 			action = cdrom_start_rw(drive, rq);
 		info->last_block = block;
 		return action;
@@ -1269,7 +1277,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, struct request *rq, sector_t block)
  */
 
 static
-void msf_from_bcd (struct atapi_msf *msf)
+void msf_from_bcd(struct atapi_msf *msf)
 {
 	msf->minute = BCD2BIN(msf->minute);
 	msf->second = BCD2BIN(msf->second);
@@ -1369,7 +1377,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		/* Try to allocate space. */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk (KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
+			printk(KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
@@ -1464,9 +1472,9 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
-		toc->ent[i].addr.lba = msf_to_lba (toc->ent[i].addr.msf.minute,
-						   toc->ent[i].addr.msf.second,
-						   toc->ent[i].addr.msf.frame);
+		toc->ent[i].addr.lba = msf_to_lba(toc->ent[i].addr.msf.minute,
+						  toc->ent[i].addr.msf.second,
+						  toc->ent[i].addr.msf.frame);
 	}
 
 	/* Read the multisession information. */
@@ -1490,9 +1498,9 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		msf_from_bcd (&ms_tmp.ent.addr.msf);
+		msf_from_bcd(&ms_tmp.ent.addr.msf);
 		toc->last_session_lba = msf_to_lba(ms_tmp.ent.addr.msf.minute,
-					  	   ms_tmp.ent.addr.msf.second,
+						   ms_tmp.ent.addr.msf.second,
 						   ms_tmp.ent.addr.msf.frame);
 	}
 
@@ -1574,7 +1582,7 @@ static struct cdrom_device_ops ide_cdrom_dops = {
 	.generic_packet		= ide_cdrom_packet,
 };
 
-static int ide_cdrom_register (ide_drive_t *drive, int nslots)
+static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
@@ -1593,7 +1601,7 @@ static int ide_cdrom_register (ide_drive_t *drive, int nslots)
 }
 
 static
-int ide_cdrom_probe_capabilities (ide_drive_t *drive)
+int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1765,7 +1773,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 		rq->errors = ILLEGAL_REQUEST;
 		return BLKPREP_KILL;
 	}
-	
+
 	return BLKPREP_OK;
 }
 
@@ -1843,7 +1851,7 @@ static unsigned int ide_cd_flags(struct hd_driveid *id)
 }
 
 static
-int ide_cdrom_setup (ide_drive_t *drive)
+int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1874,7 +1882,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
 		cdi->sanyo_slot = 3;	/* 3 => use CD in slot 0 */
 
-	nslots = ide_cdrom_probe_capabilities (drive);
+	nslots = ide_cdrom_probe_capabilities(drive);
 
 	/*
 	 * set correct block size
@@ -1886,7 +1894,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		drive->dsc_overlap = (drive->next != drive);
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk (KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
+		printk(KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
@@ -1896,7 +1904,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 #ifdef CONFIG_IDE_PROC_FS
 static
-sector_t ide_cdrom_capacity (ide_drive_t *drive)
+sector_t ide_cdrom_capacity(ide_drive_t *drive)
 {
 	unsigned long capacity, sectors_per_frame;
 
@@ -1946,8 +1954,8 @@ static int proc_idecd_read_capacity
 	ide_drive_t *drive = data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)ide_cdrom_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t idecd_proc[] = {
@@ -1976,13 +1984,14 @@ static ide_driver_t ide_cdrom_driver = {
 #endif
 };
 
-static int idecd_open(struct inode * inode, struct file * file)
+static int idecd_open(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct cdrom_info *info;
 	int rc = -ENOMEM;
 
-	if (!(info = ide_cd_get(disk)))
+	info = ide_cd_get(disk);
+	if (!info)
 		return -ENXIO;
 
 	rc = cdrom_open(&info->devinfo, inode, file);
@@ -1993,12 +2002,12 @@ static int idecd_open(struct inode * inode, struct file * file)
 	return rc;
 }
 
-static int idecd_release(struct inode * inode, struct file * file)
+static int idecd_release(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct cdrom_info *info = ide_cd_g(disk);
 
-	cdrom_release (&info->devinfo, file);
+	cdrom_release(&info->devinfo, file);
 
 	ide_cd_put(info);
 
@@ -2030,7 +2039,7 @@ static int idecd_get_spindown(struct cdrom_device_info *cdi, unsigned long arg)
 	struct packet_command cgc;
 	char buffer[16];
 	int stat;
- 	char spindown;
+	char spindown;
 
 	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_UNKNOWN);
 
@@ -2039,12 +2048,12 @@ static int idecd_get_spindown(struct cdrom_device_info *cdi, unsigned long arg)
 		return stat;
 
 	spindown = buffer[11] & 0x0f;
-	if (copy_to_user((void __user *)arg, &spindown, sizeof (char)))
+	if (copy_to_user((void __user *)arg, &spindown, sizeof(char)))
 		return -EFAULT;
 	return 0;
 }
 
-static int idecd_ioctl (struct inode *inode, struct file *file,
+static int idecd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
@@ -2052,13 +2061,13 @@ static int idecd_ioctl (struct inode *inode, struct file *file,
 	int err;
 
 	switch (cmd) {
- 	case CDROMSETSPINDOWN:
+	case CDROMSETSPINDOWN:
 		return idecd_set_spindown(&info->devinfo, arg);
- 	case CDROMGETSPINDOWN:
+	case CDROMGETSPINDOWN:
 		return idecd_get_spindown(&info->devinfo, arg);
 	default:
 		break;
- 	}
+	}
 
 	err = generic_ide_ioctl(info->drive, file, bdev, cmd, arg);
 	if (err == -EINVAL)
@@ -2089,11 +2098,11 @@ static struct block_device_operations idecd_ops = {
 	.release	= idecd_release,
 	.ioctl		= idecd_ioctl,
 	.media_changed	= idecd_media_changed,
-	.revalidate_disk= idecd_revalidate_disk
+	.revalidate_disk = idecd_revalidate_disk
 };
 
 /* options */
-static char *ignore = NULL;
+static char *ignore;
 
 module_param(ignore, charp, 0400);
 MODULE_DESCRIPTION("ATAPI CD-ROM Driver");
-- 
1.5.4.2.316.gf7a7

