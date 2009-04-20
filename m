Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbZDTWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbZDTWZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZDTWUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:20:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37344 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbZDTWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:20:24 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/25] Inline buffered_rmqueue()
Date: Mon, 20 Apr 2009 23:20:00 +0100
Message-Id: <1240266011-11140-15-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffered_rmqueue() is in the fast path so inline it. Because it only has
one call site, this actually should reduce text bloat instead of
increase it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91a2cdb..2dfe3aa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1077,7 +1077,8 @@ void split_page(struct page *page, unsigned int order)
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.
  */
-static struct page *buffered_rmqueue(struct zone *preferred_zone,
+static inline
+struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, int order, gfp_t gfp_flags,
 			int migratetype, int cold)
 {
-- 
1.5.6.5

