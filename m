Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbXK3X0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbXK3X0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbXK3X0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:26:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbXK3X0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:26:11 -0500
Date: Fri, 30 Nov 2007 18:25:52 -0500 (EST)
Message-Id: <20071130.182552.105434070.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 04/28] blk_end_request: changing arm (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/arch/arm/plat-omap/mailbox.c
===================================================================
--- 2.6.24-rc3-mm2.orig/arch/arm/plat-omap/mailbox.c
+++ 2.6.24-rc3-mm2/arch/arm/plat-omap/mailbox.c
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
