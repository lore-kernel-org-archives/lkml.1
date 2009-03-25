Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZCYOVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZCYOVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbZCYOS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:57751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761681AbZCYOSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:11 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] ide: drop rq->data handling from ide_map_sg()
Date: Wed, 25 Mar 2009 23:17:53 +0900
Message-Id: <1237990673-8358-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove code path which is no longer necessary

All IDE data transfers now use rq->bio.  Simplify ide_map_sg()
accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/ide/ide-io.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 9ad9bc1..6746171 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -244,11 +244,7 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct scatterlist *sg = hwif->sg_table;
 	struct request *rq = cmd->rq;
 
-	if (!rq->bio) {
-		sg_init_one(sg, rq->data, rq->data_len);
-		cmd->sg_nents = 1;
-	} else
-		cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
+	cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 }
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
-- 
1.6.0.2

