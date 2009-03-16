Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZCPC36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZCPC36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCPC3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:44270 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZCPC3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/17] ide: don't set REQ_SOFTBARRIER
Date: Mon, 16 Mar 2009 11:28:45 +0900
Message-Id: <1237170540-19130-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide doesn't have to worry about REQ_SOFTBARRIER.  Don't set it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-ioctls.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 806760d..0cd287d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -405,7 +405,6 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	task->data_phase = TASKFILE_NO_DATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->special = task;
 }
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 1be263e..d440fbb 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -229,7 +229,6 @@ static int generic_drive_reset(ide_drive_t *drive)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
 		ret = rq->errors;
 	blk_put_request(rq);
-- 
1.6.0.2

