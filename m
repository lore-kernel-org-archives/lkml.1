Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYA0Jzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYA0Jzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYA0Jtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:39 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59033 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756648AbYA0Jt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:27 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 29/32] ide-tape: remove mtio.h related comments
Date: Sun, 27 Jan 2008 10:48:17 +0100
Message-Id: <1201427300-3954-24-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Those are already in mtio.h.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   96 +++++++----------------------------------------
 1 files changed, 15 insertions(+), 81 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d4c4255..cfb26d9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3028,69 +3028,20 @@ static int idetape_write_filemark (ide_drive_t *drive)
 }
 
 /*
- *	idetape_mtioctop is called from idetape_chrdev_ioctl when
- *	the general mtio MTIOCTOP ioctl is requested.
+ * Called from idetape_chrdev_ioctl when the general mtio MTIOCTOP ioctl is
+ * requested.
  *
- *	We currently support the following mtio.h operations:
+ * Note: MTBSF and MTBSFM are not supported when the tape doesn't support
+ * spacing over filemarks in the reverse direction. In this case, MTFSFM is also
+ * usually not supported (it is supported in the rare case in which we crossed
+ * the filemark during our read-ahead pipelined operation mode).
  *
- *	MTFSF	-	Space over mt_count filemarks in the positive direction.
- *			The tape is positioned after the last spaced filemark.
+ * The following commands are currently not supported:
  *
- *	MTFSFM	-	Same as MTFSF, but the tape is positioned before the
- *			last filemark.
- *
- *	MTBSF	-	Steps background over mt_count filemarks, tape is
- *			positioned before the last filemark.
- *
- *	MTBSFM	-	Like MTBSF, only tape is positioned after the last filemark.
- *
- *	Note:
- *
- *		MTBSF and MTBSFM are not supported when the tape doesn't
- *		support spacing over filemarks in the reverse direction.
- *		In this case, MTFSFM is also usually not supported (it is
- *		supported in the rare case in which we crossed the filemark
- *		during our read-ahead pipelined operation mode).
- *		
- *	MTWEOF	-	Writes mt_count filemarks. Tape is positioned after
- *			the last written filemark.
- *
- *	MTREW	-	Rewinds tape.
- *
- *	MTLOAD	-	Loads the tape.
- *
- *	MTOFFL	-	Puts the tape drive "Offline": Rewinds the tape and
- *	MTUNLOAD	prevents further access until the media is replaced.
- *
- *	MTNOP	-	Flushes tape buffers.
- *
- *	MTRETEN	-	Retension media. This typically consists of one end
- *			to end pass on the media.
- *
- *	MTEOM	-	Moves to the end of recorded data.
- *
- *	MTERASE	-	Erases tape.
- *
- *	MTSETBLK - 	Sets the user block size to mt_count bytes. If
- *			mt_count is 0, we will attempt to autodetect
- *			the block size.
- *
- *	MTSEEK	-	Positions the tape in a specific block number, where
- *			each block is assumed to contain which user_block_size
- *			bytes.
- *
- *	MTSETPART - 	Switches to another tape partition.
- *
- *	MTLOCK - 	Locks the tape door.
- *
- *	MTUNLOCK - 	Unlocks the tape door.
- *
- *	The following commands are currently not supported:
- *
- *	MTFSS, MTBSS, MTWSM, MTSETDENSITY,
- *	MTSETDRVBUFFER, MT_ST_BOOLEANS, MT_ST_WRITE_THRESHOLD.
+ * MTFSS, MTBSS, MTWSM, MTSETDENSITY, MTSETDRVBUFFER, MT_ST_BOOLEANS,
+ * MT_ST_WRITE_THRESHOLD.
  */
-static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -3203,29 +3154,12 @@ static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
 }
 
 /*
- *	Our character device ioctls.
- *
- *	General mtio.h magnetic io commands are supported here, and not in
- *	the corresponding block interface.
- *
- *	The following ioctls are supported:
- *
- *	MTIOCTOP -	Refer to idetape_mtioctop for detailed description.
- *
- *	MTIOCGET - 	The mt_dsreg field in the returned mtget structure
- *			will be set to (user block size in bytes <<
- *			MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK.
- *
- *			The mt_blkno is set to the current user block number.
- *			The other mtget fields are not supported.
- *
- *	MTIOCPOS -	The current tape "block position" is returned. We
- *			assume that each block contains user_block_size
- *			bytes.
- *
- *	Our own ide-tape ioctls are supported on both interfaces.
+ * Our character device ioctls. General mtio.h magnetic io commands are
+ * supported here, and not in the corresponding block interface. Our own
+ * ide-tape ioctls are supported on both interfaces.
  */
-static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
+		uint cmd, ulong arg)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
-- 
1.5.3.7

