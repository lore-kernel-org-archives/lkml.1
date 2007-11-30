Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbXK3X3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbXK3X3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbXK3X24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:28:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760595AbXK3X2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:28:55 -0500
Date: Fri, 30 Nov 2007 18:28:33 -0500 (EST)
Message-Id: <20071130.182833.95501674.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 10/28] blk_end_request: changing sunvdc (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sunvdc to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sunvdc.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/sunvdc.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/sunvdc.c
+++ 2.6.24-rc3-mm2/drivers/block/sunvdc.c
@@ -214,10 +214,7 @@ static void vdc_end_special(struct vdc_p
 
 static void vdc_end_request(struct request *req, int uptodate, int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, num_sectors << 9);
 }
 
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
