Return-Path: <linux-kernel-owner+w=401wt.eu-S933621AbXIKTAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbXIKTAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933734AbXIKS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:59:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933733AbXIKS7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:59:43 -0400
Date: Tue, 11 Sep 2007 14:58:53 -0400 (EDT)
Message-Id: <20070911.145853.62670389.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 08/27] blk_end_request: changing lguest (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts lguest to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/lguest_blk.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 07-floppy-caller-change/drivers/block/lguest_blk.c 08-lguest-caller-change/drivers/block/lguest_blk.c
--- 07-floppy-caller-change/drivers/block/lguest_blk.c	2007-08-27 21:32:35.000000000 -0400
+++ 08-lguest-caller-change/drivers/block/lguest_blk.c	2007-09-10 18:01:53.000000000 -0400
@@ -77,11 +77,8 @@ struct blockdev
  * request.  This improved disk speed by 130%. */
 static void end_entire_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 /* I'm told there are only two stories in the world worth telling: love and
