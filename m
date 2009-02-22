Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZBVXVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZBVXVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbZBVXQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39487 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZBVXQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:28 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 13/20] Inline buffered_rmqueue()
Date: Sun, 22 Feb 2009 23:17:22 +0000
Message-Id: <1235344649-18265-14-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffered_rmqueue() is in the fast path so inline it. This incurs text
bloat as there is now a copy in the fast and slow paths but the cost of
the function call was noticeable in profiles of the fast path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8a6828..2383147 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1080,7 +1080,8 @@ void split_page(struct page *page, unsigned int order)
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.
  */
-static struct page *buffered_rmqueue(struct zone *preferred_zone,
+static inline
+struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, int order, gfp_t gfp_flags,
 			int migratetype)
 {
-- 
1.5.6.5

