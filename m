Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbXIKTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbXIKTE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXIKTBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:01:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828AbXIKTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:01:32 -0400
Date: Tue, 11 Sep 2007 15:00:51 -0400 (EDT)
Message-Id: <20070911.150051.25402848.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 13/27] blk_end_request: changing ub (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ub to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -rupN 12-sx8-caller-change/drivers/block/ub.c 13-ub-caller-change/drivers/block/ub.c
--- 12-sx8-caller-change/drivers/block/ub.c	2007-08-27 21:32:35.000000000 -0400
+++ 13-ub-caller-change/drivers/block/ub.c	2007-09-10 18:04:31.000000000 -0400
@@ -814,8 +814,8 @@ static void ub_end_rq(struct request *rq
 		uptodate = 0;
 		rq->errors = scsi_status;
 	}
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_size(rq)))
+		BUG();
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
