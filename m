Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXK3Xee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXK3Xee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbXK3Xdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:33:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764018AbXK3Xdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:33:32 -0500
Date: Fri, 30 Nov 2007 18:32:08 -0500 (EST)
Message-Id: <20071130.183208.99452922.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 18/28] blk_end_request: changing s390 (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts s390 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/s390/block/dasd.c      |    4 +---
 drivers/s390/char/tape_block.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/s390/block/dasd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/s390/block/dasd.c
+++ 2.6.24-rc3-mm2/drivers/s390/block/dasd.c
@@ -1080,10 +1080,8 @@ dasd_int_handler(struct ccw_device *cdev
 static inline void
 dasd_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_bytes(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
 }
 
 /*
Index: 2.6.24-rc3-mm2/drivers/s390/char/tape_block.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/s390/char/tape_block.c
+++ 2.6.24-rc3-mm2/drivers/s390/char/tape_block.c
@@ -76,9 +76,8 @@ tapeblock_trigger_requeue(struct tape_de
 static void
 tapeblock_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_bytes(req)))
 		BUG();
-	end_that_request_last(req, uptodate);
 }
 
 static void
