Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZCTKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZCTKIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbZCTKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55064 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbZCTKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:43 -0400
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
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/25] Inline buffered_rmqueue()
Date: Fri, 20 Mar 2009 10:03:01 +0000
Message-Id: <1237543392-11797-15-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
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
index a3ca80d..9f7631e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1079,7 +1079,8 @@ void split_page(struct page *page, unsigned int order)
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

