Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbYEOQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbYEOQcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYEOQcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:32:04 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4143 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbYEOQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:32:02 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] buddy: clarify comments describing buddy merge
Date: Thu, 15 May 2008 17:32:01 +0100
Message-Id: <1210869121.0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In __free_one_page(), the comment "Move the buddy up one level" appears
attached to the break and by implication when the break is taken we are
moving it up one level:

	if (!page_is_buddy(page, buddy, order))
		break;          /* Move the buddy up one level. */

In reality the inverse is true, we break out when we can no longer merge
this page with its buddy.  Looking back into pre-history (into the full
git history) it appears that these two lines accidentally got joined as
part of another change.

Move the comment down where it belongs below the if and clarify its
language.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 mm/page_alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1575691..20e4c71 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -459,8 +459,9 @@ static inline void __free_one_page(struct page *page,
 
 		buddy = __page_find_buddy(page, page_idx, order);
 		if (!page_is_buddy(page, buddy, order))
-			break;		/* Move the buddy up one level. */
+			break;
 
+		/* Our buddy is free, merge with it and move up one order. */
 		list_del(&buddy->lru);
 		zone->free_area[order].nr_free--;
 		rmv_page_order(buddy);
