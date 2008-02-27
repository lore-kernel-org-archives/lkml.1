Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYB0SVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYB0SVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbYB0SVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:47474 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYB0SVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=JoTabFHIafReoTSIrC0hAlGhWVMX04rF8bZW/WXyIXnyzZs7ZEDjQ2a4HI0zTfJZ5gvFSr1LlF6b0szzAALk+7G9ms9vVCHEd9mkLLziqtZrZj/frt+QYBvYPKfIUME+hTNVlpnLB1NHHuuI4eQ0HJr11YiDE9Ao/W4AugY87hs=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Date: Wed, 27 Feb 2008 19:20:48 +0100
Message-Id: <1204136449-9490-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   75 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index bb501a4..84415cd 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -279,11 +279,11 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	ide_end_request(drive, uptodate, nsectors);
 }
 
-static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 stat)
+static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
 {
-	if (stat & 0x80)
+	if (st & 0x80)
 		return;
-	ide_dump_status(drive, msg, stat);
+	ide_dump_status(drive, msg, st);
 }
 
 /*
@@ -390,7 +390,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 				 * data from cache.
 				 */
 				if (!rq->errors)
-					info->write_timeout = jiffies + ATAPI_WAIT_WRITE_BUSY;
+					info->write_timeout = jiffies +
+							ATAPI_WAIT_WRITE_BUSY;
 				rq->errors = 1;
 				if (time_after(jiffies, info->write_timeout))
 					do_end_request = 1;
@@ -403,7 +404,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 					 */
 					spin_lock_irqsave(&ide_lock, flags);
 					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock, flags);
+					spin_unlock_irqrestore(&ide_lock,
+								flags);
 					return 1;
 				}
 			}
@@ -430,11 +432,14 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			 * No point in re-trying a zillion times on a bad
 			 * sector. If we got here the error is not correctable.
 			 */
-			ide_dump_status_no_sense(drive, "media error (bad sector)", stat);
+			ide_dump_status_no_sense(drive,
+						"media error (bad sector)",
+						stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* disk appears blank ?? */
-			ide_dump_status_no_sense(drive, "media error (blank)", stat);
+			ide_dump_status_no_sense(drive, "media error (blank)",
+						stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
 			/* go to the default handler for other errors. */
@@ -504,7 +509,8 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
+			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
+				rq->cmd[0]);
 		wait = 0;
 		break;
 	}
@@ -545,7 +551,8 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
-		ide_execute_command(drive, WIN_PACKETCMD, handler, ATAPI_WAIT_PC, cdrom_timer_expiry);
+		ide_execute_command(drive, WIN_PACKETCMD, handler,
+					ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
 		unsigned long flags;
@@ -802,7 +809,8 @@ static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 
 	info->dma = 0;
 	info->start_seek = jiffies;
-	return cdrom_start_packet_command(drive, 0, cdrom_start_seek_continuation);
+	return cdrom_start_packet_command(drive, 0,
+					cdrom_start_seek_continuation);
 }
 
 /*
@@ -812,13 +820,15 @@ static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 static void restore_request(struct request *rq)
 {
 	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) / SECTOR_SIZE;
+		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) /
+				SECTOR_SIZE;
 
 		rq->buffer = bio_data(rq->bio);
 		rq->nr_sectors += n;
 		rq->sector -= n;
 	}
-	rq->hard_cur_sectors = rq->current_nr_sectors = bio_cur_sectors(rq->bio);
+	rq->current_nr_sectors = bio_cur_sectors(rq->bio);
+	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors;
 	rq->hard_sector = rq->sector;
 	rq->q->prep_rq_fn(rq->q, rq);
@@ -1183,7 +1193,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	/* sg request */
 	if (rq->bio) {
 		int mask = drive->queue->dma_alignment;
-		unsigned long addr = (unsigned long) page_address(bio_page(rq->bio));
+		unsigned long addr = (unsigned long)
+					page_address(bio_page(rq->bio));
 
 		info->dma = drive->using_dma;
 
@@ -1198,7 +1209,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	}
 
 	/* start sending the command to the drive. */
-	return cdrom_start_packet_command(drive, rq->data_len, cdrom_do_newpc_cont);
+	return cdrom_start_packet_command(drive, rq->data_len,
+					cdrom_do_newpc_cont);
 }
 
 /*
@@ -1217,14 +1229,21 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
-					ide_stall_queue(drive, IDECD_SEEK_TIMER);
+					ide_stall_queue(drive,
+							IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk(KERN_ERR "%s: DSC timeout\n", drive->name);
+				printk(KERN_ERR "%s: DSC timeout\n",
+					drive->name);
 			}
 			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
-		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) && drive->dsc_overlap)
+		if ((rq_data_dir(rq) == READ) &&
+			IDE_LARGE_SEEK(info->last_block,
+					block,
+					IDECD_SEEK_THRESHOLD) &&
+			drive->dsc_overlap)
+
 			action = cdrom_start_seek(drive, block);
 		else
 			action = cdrom_start_rw(drive, rq);
@@ -1357,7 +1376,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk(KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
+			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
+				drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
@@ -1600,7 +1620,8 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
-		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n", drive->name);
+		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
+			drive->name);
 		return nslots;
 	}
 
@@ -1899,7 +1920,8 @@ int ide_cdrom_setup(ide_drive_t *drive)
 		drive->dsc_overlap = (drive->next != drive);
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk(KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", drive->name);
+		printk(KERN_ERR "%s: %s failed to register device with the"
+				" cdrom driver.\n", drive->name, __func__);
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
@@ -1927,8 +1949,8 @@ static void ide_cd_release(struct kref *kref)
 
 	kfree(info->toc);
 	if (devinfo->handle == drive && unregister_cdrom(devinfo))
-		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
-				"driver.\n", __func__, drive->name);
+		printk(KERN_ERR "%s: %s failed to unregister device from the"
+				" cdrom driver.\n", drive->name, __func__);
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
@@ -2097,17 +2119,20 @@ static int ide_cd_probe(ide_drive_t *drive)
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO "ide-cd: ignoring drive %s\n", drive->name);
+			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
+				drive->name);
 			goto failed;
 		}
 	}
 	if (drive->scsi) {
-		printk(KERN_INFO "ide-cd: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk(KERN_INFO "ide-cd: passing drive %s to ide-scsi "
+				 "emulation.\n", drive->name);
 		goto failed;
 	}
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
-		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n", drive->name);
+		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
+			drive->name);
 		goto failed;
 	}
 
-- 
1.5.4.1

