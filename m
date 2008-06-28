Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYF1Xyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYF1Xyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 19:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYF1XyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 19:54:23 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35859 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYF1XyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 19:54:23 -0400
Date: Sun, 29 Jun 2008 00:54:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH trivial] block: GFP_ATOMIC is __GFP_HIGH
Message-ID: <Pine.LNX.4.64.0806290052350.18327@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is __GFP_HIGH: no need for alloc_io_context() to add that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 block/blk-ioc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next/block/blk-ioc.c	2008-05-12 02:01:05.000000000 +0100
+++ linux/block/blk-ioc.c	2008-06-27 14:08:00.000000000 +0100
@@ -98,7 +98,7 @@ struct io_context *alloc_io_context(gfp_
 		ret->last_waited = jiffies; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		ret->aic = NULL;
-		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
+		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC);
 		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
 	}
