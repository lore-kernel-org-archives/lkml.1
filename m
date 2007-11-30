Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXK3XcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXK3XcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXK3Xbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:31:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762719AbXK3Xbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:31:49 -0500
Date: Fri, 30 Nov 2007 18:30:34 -0500 (EST)
Message-Id: <20071130.183034.17868470.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 14/28] blk_end_request: changing xen-blkfront (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts xen-blkfront to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xen-blkfront.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/xen-blkfront.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/xen-blkfront.c
+++ 2.6.24-rc3-mm2/drivers/block/xen-blkfront.c
@@ -494,10 +494,9 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, uptodate,
+						blk_rq_bytes(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
