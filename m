Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXIKTDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXIKTDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964854AbXIKTBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:01:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbXIKTBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:01:14 -0400
Date: Tue, 11 Sep 2007 15:00:32 -0400 (EDT)
Message-Id: <20070911.150032.15584999.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 12/27] blk_end_request: changing sx8 (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sx8 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sx8.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -rupN 11-sunvdc-caller-change/drivers/block/sx8.c 12-sx8-caller-change/drivers/block/sx8.c
--- 11-sunvdc-caller-change/drivers/block/sx8.c	2007-08-27 21:32:35.000000000 -0400
+++ 12-sx8-caller-change/drivers/block/sx8.c	2007-09-10 18:04:02.000000000 -0400
@@ -747,11 +747,9 @@ static inline void carm_end_request_queu
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = end_that_request_first(req, uptodate, req->hard_nr_sectors);
+	rc = __blk_end_request(req, uptodate, blk_rq_size(req));
 	assert(rc == 0);
 
-	end_that_request_last(req, uptodate);
-
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
 }
