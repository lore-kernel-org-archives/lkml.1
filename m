Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXK3XbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXK3XbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbXK3Xav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:30:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbXK3Xat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:30:49 -0500
Date: Fri, 30 Nov 2007 18:29:24 -0500 (EST)
Message-Id: <20071130.182924.102120236.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 11/28] blk_end_request: changing sx8 (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/drivers/block/sx8.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/sx8.c
+++ 2.6.24-rc3-mm2/drivers/block/sx8.c
@@ -749,11 +749,9 @@ static inline void carm_end_request_queu
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = end_that_request_first(req, uptodate, req->hard_nr_sectors);
+	rc = __blk_end_request(req, uptodate, blk_rq_bytes(req));
 	assert(rc == 0);
 
-	end_that_request_last(req, uptodate);
-
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
 }
