Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYB0VHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYB0VHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYB0VHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:07:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:34672 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYB0VHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vbcIdQvjuMWVfSTg39deVSaRZ2igKykooyE5D7ZFSYnnlI7lq3P7eJ8g5ORlYTEA0xL/Ge5TGa5ye6UamP6V0vmOFi+LKoo1TeArlHpOSToBB6St0jVRuz5VN0PYuKCoXgc248uOaOmxRSWASJHcyj2gtiiJvrNGv4HOA/WoyjA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/5] ide-cd: fixup comments
Date: Wed, 27 Feb 2008 22:18:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <1204136449-9490-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204136449-9490-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802272218.47423.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

interdiff for the merged version

diff -u b/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
--- b/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -296,7 +296,7 @@
 	struct request *rq = HWGROUP(drive)->rq;
 	int stat, err, sense_key;
 
-	/* check for errors. */
+	/* check for errors */
 	stat = ide_read_status(drive);
 
 	if (stat_ret)
@@ -305,7 +305,7 @@
 	if (OK_STAT(stat, good_stat, BAD_R_STAT))
 		return 0;
 
-	/* get the IDE error register. */
+	/* get the IDE error register */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
@@ -335,11 +335,11 @@
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* check for tray open. */
+		/* check for tray open */
 		if (sense_key == NOT_READY) {
 			cdrom_saw_media_change(drive);
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change. */
+			/* check for media change */
 			cdrom_saw_media_change(drive);
 			return 0;
 		} else if (sense_key == ILLEGAL_REQUEST &&
@@ -352,7 +352,7 @@
 			 * cdrom_log_sense() knows this!
 			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* otherwise, print an error. */
+			/* otherwise, print an error */
 			ide_dump_status(drive, "packet command error", stat);
 		}
 
@@ -368,24 +368,24 @@
 	} else if (blk_fs_request(rq)) {
 		int do_end_request = 0;
 
-		/* handle errors from READ and WRITE requests. */
+		/* handle errors from READ and WRITE requests */
 
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
 		if (sense_key == NOT_READY) {
-			/* tray open. */
+			/* tray open */
 			if (rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				/* fail the request. */
+				/* fail the request */
 				printk("%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
 
 				/*
-				 * allow the drive 5 seconds to recover, some
+				 * Allow the drive 5 seconds to recover, some
 				 * devices will return this error while flushing
 				 * data from cache.
 				 */
@@ -408,7 +408,7 @@
 				}
 			}
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change. */
+			/* media change */
 			cdrom_saw_media_change (drive);
 
 			/*
@@ -437,11 +437,11 @@
 			ide_dump_status_no_sense(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
-			/* go to the default handler for other errors. */
+			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
 		} else if ((++rq->errors > ERROR_MAX)) {
-			/* we've racked up too many retries, abort. */
+			/* we've racked up too many retries, abort */
 			do_end_request = 1;
 		}
 
@@ -464,7 +464,7 @@
 		cdrom_end_request(drive, 0);
 	}
 
-	/* retry, or handle the next request. */
+	/* retry, or handle the next request */
 	return 1;
 
 end_request:
@@ -527,7 +527,7 @@
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* wait for the controller to be idle. */
+	/* wait for the controller to be idle */
 	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
 		return startstop;
 
@@ -535,7 +535,7 @@
 	if (info->dma)
 		info->dma = !hwif->dma_setup(drive);
 
-	/* set up the controller registers. */
+	/* set up the controller registers */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
 			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
 
@@ -583,21 +583,21 @@
 		 * from the device.  DRQ should how be set.
 		 */
 
-		/* check for errors. */
+		/* check for errors */
 		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
 			return ide_stopped;
 
-		/* ok, next interrupt will be DMA interrupt. */
+		/* ok, next interrupt will be DMA interrupt */
 		if (info->dma)
 			drive->waiting_for_dma = 1;
 	} else {
-		/* otherwise, we must wait for DRQ to get set. */
+		/* otherwise, we must wait for DRQ to get set */
 		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
 				BUSY_STAT, WAIT_READY))
 			return startstop;
 	}
 
-	/* arm the interrupt handler. */
+	/* arm the interrupt handler */
 	ide_set_handler(drive, handler, rq->timeout, cdrom_timer_expiry);
 
 	/* ATAPI commands get padded out to 12 bytes minimum */
@@ -605,7 +605,7 @@
 	if (cmd_len < ATAPI_MIN_CDB_BYTES)
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
-	/* send the command to the device. */
+	/* send the command to the device */
 	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
@@ -664,7 +664,7 @@
 	} else  if (rw == 0 && ireason == 1) {
 		/*
 		 * Some drives (ASUS) seem to tell us that status info is
-		 * available. just get it and ignore.
+		 * available.  Just get it and ignore.
 		 */
 		(void)ide_read_status(drive);
 		return 0;
@@ -754,7 +754,7 @@
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
-	/* send the command to the drive and return. */
+	/* send the command to the drive and return */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
@@ -774,9 +774,8 @@
 	info->cd_flags |= IDE_CD_FLAG_SEEKING;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
-		if (--retry == 0) {
-				drive->dsc_overlap = 0;
-		}
+		if (--retry == 0)
+			drive->dsc_overlap = 0;
 	}
 	return ide_stopped;
 }
@@ -850,7 +849,7 @@
 	if (rq->sense == NULL)
 		rq->sense = &sense;
 
-	/* start of retry loop. */
+	/* start of retry loop */
 	do {
 		int error;
 		unsigned long time = jiffies;
@@ -881,16 +880,16 @@
 				 */
 				ssleep(2);
 			} else {
-				/* otherwise, don't retry. */
+				/* otherwise, don't retry */
 				retries = 0;
 			}
 			--retries;
 		}
 
-		/* end of retry loop. */
+		/* end of retry loop */
 	} while ((rq->cmd_flags & REQ_FAILED) && retries >= 0);
 
-	/* return an error if the command failed. */
+	/* return an error if the command failed */
 	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
 }
 
@@ -916,7 +915,7 @@
 	unsigned int timeout;
 	u8 lowcyl, highcyl;
 
-	/* check for errors. */
+	/* check for errors */
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
@@ -942,7 +941,7 @@
 		goto end_request;
 	}
 
-	/* ok we fall to pio :/	 */
+	/* ok we fall to pio :/ */
 	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
 	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
@@ -974,7 +973,7 @@
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
 			ide_cd_request_sense_fixup(rq);
-			/* complain if we still have data left to transfer. */
+			/* complain if we still have data left to transfer */
 			uptodate = rq->data_len ? 0 : 1;
 		}
 		goto end_request;
@@ -1155,7 +1154,7 @@
 	if (write)
 		cd->devinfo.media_written = 1;
 
-	/* start sending the read/write request to the drive. */
+	/* start sending the read/write request to the drive */
 	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
@@ -1197,7 +1196,7 @@
 			info->dma = 0;
 	}
 
-	/* start sending the command to the drive. */
+	/* start sending the command to the drive */
 	return cdrom_start_packet_command(drive, rq->data_len, cdrom_do_newpc_cont);
 }
 
@@ -1234,7 +1233,6 @@
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		return cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
-
 		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
@@ -1372,7 +1370,7 @@
 	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
 		return 0;
 
-	/* try to get the total cdrom capacity and sector size. */
+	/* try to get the total cdrom capacity and sector size */
 	stat = cdrom_read_capacity(drive, &toc->capacity, &sectors_per_frame,
 				   sense);
 	if (stat)
@@ -1385,7 +1383,7 @@
 	blk_queue_hardsect_size(drive->queue,
 				sectors_per_frame << SECTOR_BITS);
 
-	/* first read just the header, so we know how long the TOC is. */
+	/* first read just the header, so we know how long the TOC is */
 	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
 				    sizeof(struct atapi_toc_header), sense);
 	if (stat)
@@ -1402,7 +1400,7 @@
 	if (ntracks > MAX_TRACKS)
 		ntracks = MAX_TRACKS;
 
-	/* now read the whole schmeer. */
+	/* now read the whole schmeer */
 	stat = cdrom_read_tocentry(drive, toc->hdr.first_track, 1, 0,
 				  (char *)&toc->hdr,
 				   sizeof(struct atapi_toc_header) +
@@ -1463,7 +1461,7 @@
 	}
 
 	if (toc->hdr.first_track != CDROM_LEADOUT) {
-		/* read the multisession information. */
+		/* read the multisession information */
 		stat = cdrom_read_tocentry(drive, 0, 0, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
 		if (stat)
@@ -1490,7 +1488,7 @@
 
 	toc->xa_flag = (ms_tmp.hdr.first_track != ms_tmp.hdr.last_track);
 
-	/* now try to get the total cdrom capacity. */
+	/* now try to get the total cdrom capacity */
 	stat = cdrom_get_last_written(cdi, &last_written);
 	if (!stat && (last_written > toc->capacity)) {
 		toc->capacity = last_written;
@@ -1611,7 +1609,7 @@
 	}
 
 	/*
-	 * we have to cheat a little here. the packet will eventually be queued
+	 * We have to cheat a little here. the packet will eventually be queued
 	 * with ide_cdrom_packet(), which extracts the drive from cdi->handle.
 	 * Since this device hasn't been registered with the Uniform layer yet,
 	 * it can't do this. Same goes for cdi->ops.
@@ -1722,7 +1720,7 @@
 {
 	u8 *c = rq->cmd;
 
-	/* Transform 6-byte read/write commands to the 10-byte version */
+	/* transform 6-byte read/write commands to the 10-byte version */
 	if (c[0] == READ_6 || c[0] == WRITE_6) {
 		c[8] = c[4];
 		c[5] = c[3];
