Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXK3X3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXK3X3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbXK3X2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:28:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712AbXK3X2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:28:36 -0500
Date: Fri, 30 Nov 2007 18:28:10 -0500 (EST)
Message-Id: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 09/28] blk_end_request: changing ps3disk (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ps3disk to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ps3disk.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/ps3disk.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/ps3disk.c
+++ 2.6.24-rc3-mm2/drivers/block/ps3disk.c
@@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
 	}
 
 	spin_lock(&priv->lock);
-	if (!end_that_request_first(req, uptodate, num_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, num_sectors << 9);
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
