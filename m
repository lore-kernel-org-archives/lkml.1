Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbXEQKKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbXEQKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXEQKKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:10:44 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:44014 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbXEQKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:10:44 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070517101042.3113.13245.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
References: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 1/5] Mark bio_alloc() allocations correctly
Date: Thu, 17 May 2007 11:10:42 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


bio_alloc() currently uses __GFP_MOVABLE which is plain wrong. Objects are
allocated with that gfp mask via mempool. The slab that is ultimatly used
is not reclaimable or movable.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
---

 buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc1-mm1-clean/fs/buffer.c linux-2.6.22-rc1-mm1-010_biomovable/fs/buffer.c
--- linux-2.6.22-rc1-mm1-clean/fs/buffer.c	2007-05-16 10:54:18.000000000 +0100
+++ linux-2.6.22-rc1-mm1-010_biomovable/fs/buffer.c	2007-05-16 22:55:50.000000000 +0100
@@ -2641,7 +2641,7 @@ int submit_bh(int rw, struct buffer_head
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around
 	 */
-	bio = bio_alloc(GFP_NOIO|__GFP_MOVABLE, 1);
+	bio = bio_alloc(GFP_NOIO, 1);
 
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
