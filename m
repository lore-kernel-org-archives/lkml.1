Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZDVN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZDVN6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZDVNxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:53:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43853 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbZDVNxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:53:38 -0400
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
Subject: [PATCH 13/22] Inline __rmqueue_fallback()
Date: Wed, 22 Apr 2009 14:53:18 +0100
Message-Id: <1240408407-21848-14-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__rmqueue_fallback() is in the slow path but has only one call site. Because
there is only one call-site, this function can then be inlined without
causing text bloat. On an x86-based config, it made no difference as the
savings were padded out by NOP instructions. Milage varies but text will
either decrease in size or remain static.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb57382..e0e9e67 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -775,8 +775,8 @@ static int move_freepages_block(struct zone *zone, struct page *page,
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

