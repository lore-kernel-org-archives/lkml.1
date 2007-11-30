Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbXK3Xbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbXK3Xbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762021AbXK3Xb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:31:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761982AbXK3Xb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:31:27 -0500
Date: Fri, 30 Nov 2007 18:30:54 -0500 (EST)
Message-Id: <20071130.183054.66181916.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 15/28] blk_end_request: changing viocd (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/drivers/cdrom/viocd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/cdrom/viocd.c
+++ 2.6.24-rc3-mm2/drivers/cdrom/viocd.c
@@ -302,11 +302,8 @@ static void viocd_end_request(struct req
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
