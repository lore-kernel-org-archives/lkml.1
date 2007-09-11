Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXIKTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXIKTCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933717AbXIKTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:00:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609AbXIKTAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:00:12 -0400
Date: Tue, 11 Sep 2007 14:59:42 -0400 (EDT)
Message-Id: <20070911.145942.10250776.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 10/27] blk_end_request: changing ps3disk (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ps3disk to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ps3disk.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -rupN 09-nbd-caller-change/drivers/block/ps3disk.c 10-ps3disk-caller-change/drivers/block/ps3disk.c
--- 09-nbd-caller-change/drivers/block/ps3disk.c	2007-08-27 21:32:35.000000000 -0400
+++ 10-ps3disk-caller-change/drivers/block/ps3disk.c	2007-09-10 18:03:00.000000000 -0400
@@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
 	}
 
 	spin_lock(&priv->lock);
-	if (!end_that_request_first(req, uptodate, num_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, num_sectors << 9);
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
