Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbYA0Jxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbYA0Jxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbYA0Jt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:26 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58878 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756038AbYA0JtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:18 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 21/32] ide-tape: idetape_chrdev_direction_t:shorten enum names
Date: Sun, 27 Jan 2008 10:48:09 +0100
Message-Id: <1201427300-3954-16-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   60 ++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cf308d7..b487d56 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -178,11 +178,13 @@ enum {
 /*
  *	For general magnetic tape device compatibility.
  */
+
+/* tape directions */
 typedef enum {
-	idetape_direction_none,
-	idetape_direction_read,
-	idetape_direction_write
-} idetape_chrdev_direction_t;
+	idetape_dir_none,
+	idetape_dir_read,
+	idetape_dir_write
+} idetape_chrdev_dir_t;
 
 struct idetape_bh {
 	u32 b_size;
@@ -318,7 +320,7 @@ typedef struct ide_tape_obj {
 	/* device name */
 	char name[4];
 	/* Current character device data transfer direction */
-	idetape_chrdev_direction_t chrdev_direction;
+	idetape_chrdev_dir_t chrdev_direction;
 
 	/*
 	 *	Device information
@@ -1934,7 +1936,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	struct idetape_bh *bh = tape->merge_stage->bh;
 	
 	tape->bh = bh;
-	if (tape->chrdev_direction == idetape_direction_write)
+	if (tape->chrdev_direction == idetape_dir_write)
 		atomic_set(&bh->b_count, 0);
 	else {
 		tape->b_data = bh->b_data;
@@ -2205,7 +2207,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	unsigned long flags;
 	int cnt;
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_direction != idetape_dir_read)
 		return 0;
 
 	/* Remove merge stage. */
@@ -2220,7 +2222,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 
 	/* Clear pipeline flags. */
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_direction = idetape_dir_none;
 
 	/* Remove pipeline stages. */
 	if (tape->first_stage == NULL)
@@ -2260,7 +2262,7 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	int retval;
 	idetape_pc_t pc;
 
-	if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_direction == idetape_dir_read)
 		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
@@ -2487,7 +2489,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	int blocks, min;
 	struct idetape_bh *bh;
 
-	if (tape->chrdev_direction != idetape_direction_write) {
+	if (tape->chrdev_direction != idetape_dir_write) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
 		return;
 	}
@@ -2530,7 +2532,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage = NULL;
 	}
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_direction = idetape_dir_none;
 
 	/*
 	 *	On the next backup, perform the feedback loop again.
@@ -2574,8 +2576,8 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
-	if (tape->chrdev_direction != idetape_direction_read) {
-		if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_direction != idetape_dir_read) {
+		if (tape->chrdev_direction == idetape_dir_write) {
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
@@ -2585,7 +2587,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_read;
+		tape->chrdev_direction = idetape_dir_read;
 
 		/*
 		 *	Issue a read 0 command to ensure that DSC handshake
@@ -2599,7 +2601,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_direction = idetape_dir_none;
 				return bytes_read;
 			}
 		}
@@ -2815,7 +2817,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 		mt_count = - mt_count;
 	}
 
-	if (tape->chrdev_direction == idetape_direction_read) {
+	if (tape->chrdev_direction == idetape_dir_read) {
 		/*
 		 *	We have a read-ahead buffer. Scan it for crossed
 		 *	filemarks.
@@ -2905,7 +2907,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
-	if (tape->chrdev_direction != idetape_direction_read) {
+	if (tape->chrdev_direction != idetape_dir_read) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
 			if (count > tape->tape_block_size &&
 			    (count % tape->tape_block_size) == 0)
@@ -2970,8 +2972,8 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_direction != idetape_direction_write) {
-		if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_direction != idetape_dir_write) {
+		if (tape->chrdev_direction == idetape_dir_read)
 			idetape_discard_read_pipeline(drive, 1);
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
@@ -2980,7 +2982,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_write;
+		tape->chrdev_direction = idetape_dir_write;
 		idetape_init_merge_stage(tape);
 
 		/*
@@ -2995,7 +2997,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_direction = idetape_dir_none;
 				return retval;
 			}
 		}
@@ -3267,7 +3269,7 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	tape->restart_speed_control_req = 1;
-	if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_direction == idetape_dir_write) {
 		idetape_empty_write_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
 	}
@@ -3298,7 +3300,7 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 				return -EFAULT;
 			return 0;
 		default:
-			if (tape->chrdev_direction == idetape_direction_read)
+			if (tape->chrdev_direction == idetape_dir_read)
 				idetape_discard_read_pipeline(drive, 1);
 			return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
@@ -3377,7 +3379,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_direction != idetape_dir_read)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
@@ -3402,7 +3404,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	/*
 	 * Lock the tape drive door so user can't eject.
 	 */
-	if (tape->chrdev_direction == idetape_direction_none) {
+	if (tape->chrdev_direction == idetape_dir_none) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
 				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
@@ -3450,9 +3452,9 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	if (tape->chrdev_direction == idetape_direction_write)
+	if (tape->chrdev_direction == idetape_dir_write)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_direction == idetape_direction_read) {
+	if (tape->chrdev_direction == idetape_dir_read) {
 		if (minor < 128)
 			idetape_discard_read_pipeline(drive, 1);
 		else
@@ -3464,7 +3466,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 	}
 	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-	if (tape->chrdev_direction == idetape_direction_none) {
+	if (tape->chrdev_direction == idetape_dir_none) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
 				if (!idetape_queue_pc_tail(drive, &pc))
@@ -3657,7 +3659,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_direction = idetape_dir_none;
 	tape->pc = tape->pc_stack;
 	tape->max_insert_speed = 10000;
 	tape->speed_control = 1;
-- 
1.5.3.7

