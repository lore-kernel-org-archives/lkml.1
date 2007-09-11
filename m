Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXIKTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXIKTEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbXIKTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:01:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbXIKTBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:01:33 -0400
Date: Tue, 11 Sep 2007 15:01:10 -0400 (EDT)
Message-Id: <20070911.150110.78388754.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 14/27] blk_end_request: changing viodasd (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts viodasd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/viodasd.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 13-ub-caller-change/drivers/block/viodasd.c 14-viodasd-caller-change/drivers/block/viodasd.c
--- 13-ub-caller-change/drivers/block/viodasd.c	2007-08-27 21:32:35.000000000 -0400
+++ 14-viodasd-caller-change/drivers/block/viodasd.c	2007-09-10 18:05:02.000000000 -0400
@@ -275,10 +275,7 @@ static struct block_device_operations vi
 static void viodasd_end_request(struct request *req, int uptodate,
 		int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, num_sectors << 9);
 }
 
 /*
