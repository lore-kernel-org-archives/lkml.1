Return-Path: <linux-kernel-owner+w=401wt.eu-S1764538AbXIKTFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764538AbXIKTFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933918AbXIKTCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:02:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727AbXIKTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:02:08 -0400
Date: Tue, 11 Sep 2007 15:01:31 -0400 (EDT)
Message-Id: <20070911.150131.50590147.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 15/27] blk_end_request: changing xen-blkfront (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
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

diff -rupN 14-viodasd-caller-change/drivers/block/xen-blkfront.c 15-xen-caller-change/drivers/block/xen-blkfront.c
--- 14-viodasd-caller-change/drivers/block/xen-blkfront.c	2007-08-27 21:32:35.000000000 -0400
+++ 15-xen-caller-change/drivers/block/xen-blkfront.c	2007-09-10 18:05:29.000000000 -0400
@@ -498,10 +498,9 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, uptodate,
+						blk_rq_size(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
