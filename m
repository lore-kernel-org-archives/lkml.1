Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab0CAJxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:53:40 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:42964 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0CAJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:53:39 -0500
Subject: [PATCH] block: don't access jiffies when initialising io_context
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 09:53:33 +0000
Message-ID: <1267437213.2127.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the comment says the initial value of last_waited is never used, so
there is no need to initialise it with the current jiffies. Jiffies is
hot enough without accessing it for no reason.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.33
compiled & tested on x86_64

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 98e6bf6..3f65c8a 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -91,7 +91,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		spin_lock_init(&ret->lock);
 		ret->ioprio_changed = 0;
 		ret->ioprio = 0;
-		ret->last_waited = jiffies; /* doesn't matter... */
+		ret->last_waited = 0; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);


