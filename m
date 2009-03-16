Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbZCPJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbZCPJtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZCPJob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:44:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49702 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZCPJo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:44:27 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 15/35] Inline __rmqueue_fallback()
Date: Mon, 16 Mar 2009 09:46:10 +0000
Message-Id: <1237196790-7268-16-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__rmqueue() is in the slow path but has only one call site. It actually
reduces text if it's inlined.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f7631e..0ba9e4f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -774,8 +774,8 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 }
 
 /* Remove an element from the buddy allocator from the fallback list */
-static struct page *__rmqueue_fallback(struct zone *zone, int order,
-						int start_migratetype)
+static inline struct page *
+__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 {
 	struct free_area * area;
 	int current_order;
-- 
1.5.6.5

