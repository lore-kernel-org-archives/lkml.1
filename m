Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXK3Xbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXK3Xbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbXK3Xay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:30:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695AbXK3Xat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:30:49 -0500
Date: Fri, 30 Nov 2007 18:30:13 -0500 (EST)
Message-Id: <20071130.183013.107945133.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 13/28] blk_end_request: changing viodasd (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/drivers/block/viodasd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/viodasd.c
+++ 2.6.24-rc3-mm2/drivers/block/viodasd.c
@@ -232,10 +232,7 @@ static struct block_device_operations vi
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
