Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585Ab0AVE6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0AVE6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765Ab0AVE62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:58:28 -0500
Received: from mail.perches.com ([173.55.12.10]:1340 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0AVEw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:58 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/24] drivers/block/floppy.c: Remove unnecessary braces
Date: Thu, 21 Jan 2010 20:52:34 -0800
Message-Id: <eef8b55de1ae4d1904bde28801b6ecf82ceb4b11.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 7a2ea35..ac5a4cb 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -686,9 +686,8 @@ static void __reschedule_timeout(int drive, const char *message, int marg)
 	} else
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
-	if (UDP->flags & FD_DEBUG) {
+	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s %d\n", message, marg);
-	}
 	timeout_message = message;
 }
 
@@ -809,9 +808,8 @@ static int set_dor(int fdc, char mask, char data)
 		if (is_selected(olddor, unit) && !is_selected(newdor, unit)) {
 			drive = REVDRIVE(fdc, unit);
 #ifdef DCL_DEBUG
-			if (UDP->flags & FD_DEBUG) {
+			if (UDP->flags & FD_DEBUG)
 				DPRINT("calling disk change from set_dor\n");
-			}
 #endif
 			disk_change(drive);
 		}
@@ -1030,9 +1028,8 @@ static void cancel_activity(void)
 static void fd_watchdog(void)
 {
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from watchdog\n");
-	}
 #endif
 
 	if (disk_change(current_drive)) {
@@ -1369,9 +1366,9 @@ static void fdc_specify(void)
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
 	srt = 16 - DIV_ROUND_UP(DP->srt * scale_dtr / 1000, NOMINAL_DTR);
-	if (slow_floppy) {
+	if (slow_floppy)
 		srt = srt / 4;
-	}
+
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
@@ -1635,9 +1632,8 @@ static void seek_floppy(void)
 	blind_seek = 0;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from seek\n");
-	}
 #endif
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
@@ -1969,9 +1965,8 @@ static void floppy_ready(void)
 		return;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from floppy_ready\n");
-	}
 #endif
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
@@ -2004,9 +1999,8 @@ static void floppy_start(void)
 
 	scandrives();
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in floppy_start\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	floppy_ready();
@@ -2758,9 +2752,8 @@ static int make_raw_rw_request(void)
 		dma_limit =
 		    (MAX_DMA_ADDRESS -
 		     ((unsigned long)current_req->buffer)) >> 9;
-		if ((unsigned long)max_size > dma_limit) {
+		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
-		}
 		/* 64 kb boundaries */
 		if (CROSS_64KB(current_req->buffer, max_size << 9))
 			max_size = (K_64 -
@@ -3026,9 +3019,8 @@ static int poll_drive(int interruptible, int flag)
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in poll_drive\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	WAIT(floppy_ready);
@@ -3291,9 +3283,8 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
 	cont = &raw_cmd_cont;
 	ret = wait_til_done(floppy_start, 1);
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from raw_cmd ioctl\n");
-	}
 #endif
 
 	if (ret != -EINTR && FDCS->reset)
@@ -3486,18 +3477,18 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	 * We do this in order to provide a means to eject floppy disks before
 	 * installing the new fdutils package */
 	if (cmd == CDROMEJECT ||	/* CD-ROM eject */
-	    cmd == 0x6470 /* SunOS floppy eject */ ) {
+	    cmd == 0x6470) {		/* SunOS floppy eject */
 		DPRINT("obsolete eject ioctl\n");
 		DPRINT("please use floppycontrol --eject\n");
 		cmd = FDEJECT;
 	}
 
-	/* convert the old style command into a new style command */
-	if ((cmd & 0xff00) == 0x0200) {
-		ECALL(normalize_ioctl(&cmd, &size));
-	} else
+	if (!((cmd & 0xff00) == 0x0200))
 		return -EINVAL;
 
+	/* convert the old style command into a new style command */
+	ECALL(normalize_ioctl(&cmd, &size));
+
 	/* permission checks */
 	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
@@ -3746,9 +3737,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			INFBOUND(try, 16);
 			tmp = (char *)fd_dma_mem_alloc(1024 * try);
 		}
-		if (!tmp && !floppy_track_buffer) {
+		if (!tmp && !floppy_track_buffer)
 			fallback_on_nodma_alloc(&tmp, 2048 * try);
-		}
 		if (!tmp && !floppy_track_buffer) {
 			DPRINT("Unable to allocate DMA memory\n");
 			goto out;
-- 
1.6.6.rc0.57.gad7a

