Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZDWM3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZDWM3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZDWM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:38559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbZDWM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:23 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/12] block: don't init rq fields unnecessarily
Date: Thu, 23 Apr 2009 21:25:43 +0900
Message-Id: <1240489553-15724-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_get_request() always returns properly zeroed requests.  Don't set
fields to zero/NULL unnecessarily.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/scsi_ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index bb9aa43..58cf456 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -500,8 +500,6 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->data_len = 0;
-	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
 	rq->cmd[4] = data;
-- 
1.6.0.2

