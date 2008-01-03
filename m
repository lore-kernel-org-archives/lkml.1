Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYACN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYACN0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYACNXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:35 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:21053 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753180AbYACNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=YgMXQkcGi4iDIvg4+Uvrdz/wxTzTlhAKFqcS9r3pcoCFoFyzvMozVOwKHlq+VvHsPgFZoTY4ISiuB4eZewolGufGzDwGkEc7bRDmwnXYAQz09RG2MJAFZFaSWajSZuGYOXi47Sh2P0K9EHZ4Xq8niCfhnA+zan6v8MBC4HQCFqs=  ;
X-YMail-OSG: LRVjhhoVM1n6rJPKblBAgIT.wYJheOTHXU.8tInMfwDjJWwE_VMdw9yaNoLcBda3uhze9N61YA--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 04/10] ide-floppy: cleanup debugging macros
Date: Thu,  3 Jan 2008 14:20:03 +0100
Message-Id: <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   58 +++++++++++++++++++++------------------------
 drivers/ide/ide-floppy.h |    3 +-
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 4fb6128..196a697 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -105,7 +105,7 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
-	debug_log(KERN_INFO "Reached idefloppy_end_request\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	switch (uptodate) {
 		case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
@@ -257,13 +257,12 @@ static void idefloppy_analyze_error (ide_drive_t *drive,
 	floppy->progress_indication = result->sksv[0] & 0x80 ?
 		(u16)get_unaligned((u16 *)(result->sksv+1)):0x10000;
 	if (floppy->failed_pc)
-		debug_log(KERN_INFO "ide-floppy: pc = %x, sense key = %x, "
-			"asc = %x, ascq = %x\n", floppy->failed_pc->c[0],
-			result->sense_key, result->asc, result->ascq);
+		debug_log("pc = %x, sense key = %x, asc = %x, ascq = %x\n",
+				floppy->failed_pc->c[0], result->sense_key,
+				result->asc, result->ascq);
 	else
-		debug_log(KERN_INFO "ide-floppy: sense key = %x, asc = %x, "
-			"ascq = %x\n", result->sense_key,
-			result->asc, result->ascq);
+		debug_log("sense key = %x, asc = %x, ascq = %x\n",
+				result->sense_key, result->asc, result->ascq);
 }
 
 static void idefloppy_request_sense_callback (ide_drive_t *drive)
@@ -271,7 +270,7 @@ static void idefloppy_request_sense_callback (ide_drive_t *drive)
 	idefloppy_t *floppy = drive->driver_data;
 	u8 *buf = floppy->pc->buffer;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (!floppy->pc->error) {
 		idefloppy_analyze_error(drive, (rq_sense_res_t *) buf);
@@ -291,7 +290,7 @@ static void idefloppy_pc_callback (ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
@@ -351,8 +350,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	struct request *rq = pc->rq;
 	unsigned int temp;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s interrupt handler\n",
-		__FUNCTION__);
+	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
 		if (HWIF(drive)->ide_dma_end(drive)) {
@@ -361,23 +359,23 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
 		}
-		debug_log(KERN_INFO "ide-floppy: DMA finished\n");
+		debug_log("%s: DMA finished\n", __FUNCTION__);
 	}
 
 	/* Clear the interrupt */
 	status.all = HWIF(drive)->INB(IDE_STATUS_REG);
 
 	if (!status.b.drq) {			/* No more interrupts */
-		debug_log(KERN_INFO "Packet command completed, %d bytes "
-			"transferred\n", pc->actually_transferred);
+		debug_log("Packet command completed, %d bytes transferred\n",
+				pc->actually_transferred);
+
 		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 
 		local_irq_enable_in_hardirq();
 
 		if (status.b.check || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
-			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
-				drive->name);
+			debug_log("%s: I/O error\n", drive->name);
 			rq->errors++;
 			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 				printk(KERN_ERR "ide-floppy: I/O error in "
@@ -438,9 +436,8 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 						NULL);
 				return ide_started;
 			}
-			debug_log(KERN_NOTICE "ide-floppy: The floppy wants to "
-				"send us more data than expected - "
-				"allowing transfer\n");
+			debug_log("The floppy wants to send us more data than"
+					"expected - allowing transfer\n");
 		}
 	}
 	if (test_bit(PC_WRITING, &pc->flags)) {
@@ -624,7 +621,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		return ide_stopped;
 	}
 
-	debug_log(KERN_INFO "Retry number - %d\n",pc->retries);
+	debug_log("Retry number - %d\n", pc->retries);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
@@ -676,9 +673,9 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	}
 }
 
-static void idefloppy_rw_callback (ide_drive_t *drive)
+static void idefloppy_rw_callback(ide_drive_t *drive)
 {
-	debug_log(KERN_INFO "ide-floppy: Reached idefloppy_rw_callback\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	idefloppy_do_end_request(drive, 1, 0);
 	return;
@@ -686,8 +683,7 @@ static void idefloppy_rw_callback (ide_drive_t *drive)
 
 static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
 {
-	debug_log(KERN_INFO "ide-floppy: creating prevent removal command, "
-		"prevent = %d\n", prevent);
+	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
@@ -773,7 +769,7 @@ static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
 	int cmd = rq_data_dir(rq);
 
 	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit (IDEFLOPPY_USE_READ12, &floppy->flags),
+		2 * test_bit(IDEFLOPPY_USE_READ12, &floppy->flags),
 		block, blocks);
 
 	idefloppy_init_pc(pc);
@@ -826,10 +822,10 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive,
 	idefloppy_pc_t *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log(KERN_INFO "dev: %s, flags: %lx, errors: %d\n",
+	debug_log("dev: %s, flags: %lx, errors: %d\n",
 			rq->rq_disk ? rq->rq_disk->disk_name : "?",
 			rq->flags, rq->errors);
-	debug_log(KERN_INFO "sector: %ld, nr_sectors: %ld, "
+	debug_log("sector: %ld, nr_sectors: %ld, "
 			"current_nr_sectors: %d\n", (long)rq->sector,
 			rq->nr_sectors, rq->current_nr_sectors);
 
@@ -1050,10 +1046,10 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		}
 		}
 		if (!i) {
-			debug_log( "Descriptor 0 Code: %d\n",
+			debug_log("Descriptor 0 Code: %d\n",
 				descriptor->dc);
 		}
-		debug_log( "Descriptor %d: %dkB, %d blocks, %d "
+		debug_log("Descriptor %d: %dkB, %d blocks, %d "
 			"sector size\n", i, blocks * length / 1024, blocks,
 			length);
 	}
@@ -1513,7 +1509,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	idefloppy_pc_t pc;
 	int ret = 0;
 
-	debug_log(KERN_INFO "Reached idefloppy_open\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (!(floppy = ide_floppy_get(disk)))
 		return -ENXIO;
@@ -1574,7 +1570,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	ide_drive_t *drive = floppy->drive;
 	idefloppy_pc_t pc;
 
-	debug_log(KERN_INFO "Reached idefloppy_release\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index 4e12038..fb55d32 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -12,7 +12,8 @@
 #define IDEFLOPPY_DEBUG( fmt, args... )
 
 #if IDEFLOPPY_DEBUG_LOG
-#define debug_log printk
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide-floppy: " fmt, ## args)
 #else
 #define debug_log(fmt, args... ) do {} while(0)
 #endif
-- 
1.5.3.7

