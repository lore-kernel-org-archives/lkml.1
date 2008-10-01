Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYJAOOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYJAOOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYJAOOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:14:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYJAOOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:14:44 -0400
Date: Wed, 01 Oct 2008 10:12:15 -0400 (EDT)
Message-Id: <20081001.101215.71084348.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 2/5] memstick: change to use __blk_end_request()
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts memstick to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/memstick/core/mspro_block.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-block/drivers/memstick/core/mspro_block.c
===================================================================
--- linux-2.6-block.orig/drivers/memstick/core/mspro_block.c
+++ linux-2.6-block/drivers/memstick/core/mspro_block.c
@@ -828,7 +828,7 @@ static void mspro_block_submit_req(struc
 
 	if (msb->eject) {
 		while ((req = elv_next_request(q)) != NULL)
-			end_queued_request(req, -ENODEV);
+			__blk_end_request(req, -ENODEV, blk_rq_bytes(req));
 
 		return;
 	}
