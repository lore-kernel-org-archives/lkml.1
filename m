Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbXIKS6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbXIKS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbXIKS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:58:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292AbXIKS6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:58:02 -0400
Date: Tue, 11 Sep 2007 14:57:27 -0400 (EDT)
Message-Id: <20070911.145727.124547613.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 04/27] blk_end_request: changing arm (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts arm to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---

 arch/arm/plat-omap/mailbox.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -rupN 03-blkcore-caller-change/arch/arm/plat-omap/mailbox.c 04-arm-caller-change/arch/arm/plat-omap/mailbox.c
--- 03-blkcore-caller-change/arch/arm/plat-omap/mailbox.c	2007-08-27 21:32:35.000000000 -0400
+++ 04-arm-caller-change/arch/arm/plat-omap/mailbox.c	2007-09-10 17:59:02.000000000 -0400
@@ -117,7 +117,8 @@ static void mbox_tx_work(struct work_str
 
 		spin_lock(q->queue_lock);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -151,7 +152,8 @@ static void mbox_rx_work(struct work_str
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		mbox->rxq->callback((void *)msg);
@@ -265,7 +267,8 @@ omap_mbox_read(struct device *dev, struc
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
