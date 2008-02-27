Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbYB0VHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbYB0VHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYB0VHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:07:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:34552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYB0VHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jeVUCGc07j96AEqMv2YuyrYcantTpNRcr6p7bXfPNL9lPj7n526pKHstiqeVlbSViojXemSfQwj+yfx93PHuRC4qeycUvza0VHr8mux8ZocUiSCnk8/mIGhHHQQ8X4OHUHZ8/7huiyFtOIqjPziwFcAD9JNpG6AUB+bcWp7HJHw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Date: Wed, 27 Feb 2008 22:18:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <1204136449-9490-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204136449-9490-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802272218.50537.bzolnier@gmail.com>
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
@@ -433,13 +433,13 @@
 			 * sector. If we got here the error is not correctable.
 			 */
 			ide_dump_status_no_sense(drive,
-						"media error (bad sector)",
-						stat);
+						 "media error (bad sector)",
+						 stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* disk appears blank ?? */
 			ide_dump_status_no_sense(drive, "media error (blank)",
-						stat);
+						 stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
 			/* go to the default handler for other errors */
@@ -510,7 +510,7 @@
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
 			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
-				rq->cmd[0]);
+					 rq->cmd[0]);
 		wait = 0;
 		break;
 	}
@@ -552,7 +552,7 @@
 
 		/* packet command */
 		ide_execute_command(drive, WIN_PACKETCMD, handler,
-					ATAPI_WAIT_PC, cdrom_timer_expiry);
+				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
 		unsigned long flags;
@@ -809,7 +809,7 @@
 	info->dma = 0;
 	info->start_seek = jiffies;
 	return cdrom_start_packet_command(drive, 0,
-					cdrom_start_seek_continuation);
+					  cdrom_start_seek_continuation);
 }
 
 /*
@@ -819,8 +819,8 @@
 static void restore_request(struct request *rq)
 {
 	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) /
-				SECTOR_SIZE;
+		sector_t n =
+			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
 
 		rq->buffer = bio_data(rq->bio);
 		rq->nr_sectors += n;
@@ -1192,8 +1192,8 @@
 	/* sg request */
 	if (rq->bio) {
 		int mask = drive->queue->dma_alignment;
-		unsigned long addr = (unsigned long)
-					page_address(bio_page(rq->bio));
+		unsigned long addr =
+			(unsigned long)page_address(bio_page(rq->bio));
 
 		info->dma = drive->using_dma;
 
@@ -1233,16 +1233,14 @@
 					return ide_stopped;
 				}
 				printk(KERN_ERR "%s: DSC timeout\n",
-					drive->name);
+						drive->name);
 			}
 			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
-		if ((rq_data_dir(rq) == READ) &&
-			IDE_LARGE_SEEK(info->last_block,
-					block,
-					IDECD_SEEK_THRESHOLD) &&
-			drive->dsc_overlap)
-
+		if (rq_data_dir(rq) == READ &&
+		    IDE_LARGE_SEEK(info->last_block, block,
+				   IDECD_SEEK_THRESHOLD) &&
+		    drive->dsc_overlap)
 			action = cdrom_start_seek(drive, block);
 		else
 			action = cdrom_start_rw(drive, rq);
@@ -1375,7 +1373,7 @@
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
 			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
-				drive->name);
+					drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
@@ -1619,7 +1617,7 @@
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
 		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
-			drive->name);
+				drive->name);
 		return nslots;
 	}
 
@@ -2118,7 +2116,7 @@
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
 			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
-				drive->name);
+					 drive->name);
 			goto failed;
 		}
 	}
@@ -2130,7 +2128,7 @@
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
 		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
-			drive->name);
+				drive->name);
 		goto failed;
 	}
 
