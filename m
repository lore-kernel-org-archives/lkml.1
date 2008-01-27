Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYA0J4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYA0J4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYA0Jtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:46 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59287 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756754AbYA0Jtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:32 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 28/32] ide-tape: shorten some function names
Date: Sun, 27 Jan 2008 10:48:16 +0100
Message-Id: <1201427300-3954-23-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f8a4b27..d4c4255 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1066,7 +1066,7 @@ static void idetape_postpone_request (ide_drive_t *drive)
  * command. We will transfer some of the data (as requested by the drive) and
  * will re-point interrupt handler to us. When data transfer is finished, we
  * will act according to the algorithm described before
- * idetape_issue_packet_command.
+ * idetape_issue_pc.
  */
 
 typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, uint);
@@ -1249,7 +1249,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
  *
  *	The handling will be done in three stages:
  *
- *	1.	idetape_issue_packet_command will send the packet command to the
+ *	1.	idetape_issue_pc will send the packet command to the
  *		drive, and will set the interrupt handler to idetape_pc_intr.
  *
  *	2.	On each interrupt, idetape_pc_intr will be called. This step
@@ -1324,7 +1324,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape_pc_t *pc)
+static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
@@ -1638,7 +1638,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	if (tape->failed_pc != NULL &&
 	    tape->pc->c[0] == REQUEST_SENSE) {
-		return idetape_issue_packet_command(drive, tape->failed_pc);
+		return idetape_issue_pc(drive, tape->failed_pc);
 	}
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
@@ -1732,7 +1732,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	BUG();
 out:
-	return idetape_issue_packet_command(drive, pc);
+	return idetape_issue_pc(drive, pc);
 
 err:
 	printk(KERN_ERR "ide-tape: Error processing request %u\n", rq->cmd[0]);
@@ -2290,10 +2290,10 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 }
 
 /*
- *	idetape_insert_pipeline_into_queue is used to start servicing the
+ *	idetape_ins_ppl_into_queue is used to start servicing the
  *	pipeline stages, starting from tape->next_stage.
  */
-static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
+static void idetape_ins_ppl_into_queue(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2385,7 +2385,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			spin_unlock_irqrestore(&tape->que_lock, flags);
 		} else {
 			spin_unlock_irqrestore(&tape->que_lock, flags);
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_ins_ppl_into_queue(drive);
 			if (idetape_pipeline_active(tape))
 				continue;
 			/*
@@ -2421,7 +2421,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			tape->ins_time = jiffies;
 			tape->ins_size = 0;
 			tape->ins_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_ins_ppl_into_queue(drive);
 		}
 	}
 	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
@@ -2440,7 +2440,7 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 	unsigned long flags;
 
 	while (tape->next_stage || idetape_pipeline_active(tape)) {
-		idetape_insert_pipeline_into_queue(drive);
+		idetape_ins_ppl_into_queue(drive);
 		spin_lock_irqsave(&tape->que_lock, flags);
 		if (idetape_pipeline_active(tape))
 			idetape_wait_for_request(drive, tape->act_data_rq);
@@ -2532,7 +2532,7 @@ static void idetape_restart_speed_control (ide_drive_t *drive)
 	tape->ctl_prev_htime = tape->unctl_prev_htime = jiffies;
 }
 
-static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
+static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2593,7 +2593,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			tape->ins_time = jiffies;
 			tape->ins_size = 0;
 			tape->ins_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_ins_ppl_into_queue(drive);
 		}
 	}
 	return 0;
@@ -2623,7 +2623,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	 * Wait for the next block to be available at the head
 	 * of the pipeline
 	 */
-	idetape_initiate_read(drive, tape->max_stages);
+	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
 		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
 			return 0;
@@ -2879,7 +2879,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 			    (count % tape->blk_sz) == 0)
 				tape->user_bs_factor = count / tape->blk_sz;
 	}
-	if ((rc = idetape_initiate_read(drive, tape->max_stages)) < 0)
+	rc = idetape_init_read(drive, tape->max_stages);
+	if (rc < 0)
 		return rc;
 	if (count == 0)
 		return (0);
-- 
1.5.3.7

