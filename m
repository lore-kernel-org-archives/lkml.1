Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbXK3X25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbXK3X25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbXK3X22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:28:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695AbXK3X2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:28:25 -0500
Date: Fri, 30 Nov 2007 18:27:54 -0500 (EST)
Message-Id: <20071130.182754.63993899.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 08/28] blk_end_request: changing nbd (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts nbd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/nbd.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/nbd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/nbd.c
+++ 2.6.24-rc3-mm2/drivers/block/nbd.c
@@ -108,9 +108,7 @@ static void nbd_end_request(struct reque
 			req, uptodate? "done": "failed");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, req->nr_sectors << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
