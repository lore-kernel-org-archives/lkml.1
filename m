Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXIKTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXIKTBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbXIKS7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:59:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXIKS7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:59:45 -0400
Date: Tue, 11 Sep 2007 14:59:24 -0400 (EDT)
Message-Id: <20070911.145924.85814380.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 09/27] blk_end_request: changing nbd (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts nbd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/nbd.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -rupN 08-lguest-caller-change/drivers/block/nbd.c 09-nbd-caller-change/drivers/block/nbd.c
--- 08-lguest-caller-change/drivers/block/nbd.c	2007-09-10 17:32:11.000000000 -0400
+++ 09-nbd-caller-change/drivers/block/nbd.c	2007-09-10 18:02:30.000000000 -0400
@@ -107,9 +107,7 @@ static void nbd_end_request(struct reque
 			req, uptodate? "done": "failed");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, req->nr_sectors << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
