Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZCXQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZCXQJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762214AbZCXQGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:41829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761899AbZCXQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:38 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] ide: don't set REQ_SOFTBARRIER
Date: Wed, 25 Mar 2009 01:06:07 +0900
Message-Id: <1237910776-10983-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide doesn't have to worry about REQ_SOFTBARRIER.  Don't set it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-ioctls.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c998cf8..d5f7d79 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -400,7 +400,6 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	cmd->protocol = ATA_PROT_NODATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->special = cmd;
 }
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 7701427..c22b4c7 100644
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

