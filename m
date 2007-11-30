Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXK3Xab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXK3Xab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbXK3XaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:30:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbXK3XaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:30:07 -0500
Date: Fri, 30 Nov 2007 18:29:49 -0500 (EST)
Message-Id: <20071130.182949.118947603.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 12/28] blk_end_request: changing ub (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/drivers/block/ub.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/ub.c
+++ 2.6.24-rc3-mm2/drivers/block/ub.c
@@ -816,8 +816,8 @@ static void ub_end_rq(struct request *rq
 		uptodate = 0;
 		rq->errors = scsi_status;
 	}
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_bytes(rq)))
+		BUG();
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
