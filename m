Return-Path: <linux-kernel-owner+w=401wt.eu-S1763255AbXIKTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763255AbXIKTGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933913AbXIKTC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:02:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933944AbXIKTCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:02:24 -0400
Date: Tue, 11 Sep 2007 15:01:50 -0400 (EDT)
Message-Id: <20070911.150150.10127251.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 16/27] blk_end_request: changing viocd (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts viocd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/cdrom/viocd.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 15-xen-caller-change/drivers/cdrom/viocd.c 16-viocd-caller-change/drivers/cdrom/viocd.c
--- 15-xen-caller-change/drivers/cdrom/viocd.c	2007-08-27 21:32:35.000000000 -0400
+++ 16-viocd-caller-change/drivers/cdrom/viocd.c	2007-09-10 18:06:02.000000000 -0400
@@ -389,11 +389,8 @@ static void viocd_end_request(struct req
 	if (!nsectors)
 		nsectors = 1;
 
-	if (end_that_request_first(req, uptodate, nsectors))
+	if (__blk_end_request(req, uptodate, nsectors << 9))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 static int rwreq;
