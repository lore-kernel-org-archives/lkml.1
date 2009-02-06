Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZBFBj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZBFBj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbZBFBjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:39:11 -0500
Received: from cmpxchg.org ([85.214.51.133]:33745 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbZBFBjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:39:10 -0500
Message-Id: <E1LVFj1-00032y-7X@cmpxchg.org>
From: hannes@cmpxchg.org
Date: Fri, 06 Feb 2009 02:41:47 +0100
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From hannes@cmpxchg.org Fri Feb  6 02:28:54 2009
Message-Id: <20090206012854.817934336@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Fri, 06 Feb 2009 02:26:07 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
 Rik van Riel <riel@redhat.com>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [PATCH 2/3] swsusp: dont fiddle with swappiness
References: <20090206012605.378214179@cmpxchg.org>
Content-Disposition: inline; filename=swsusp-dont-fiddle-with-swappiness.patch

sc.swappiness is not used in the swsusp memory shrinking path, do not
set it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2111,7 +2111,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_swap = 0,
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
-		.swappiness = vm_swappiness,
 		.isolate_pages = isolate_pages_global,
 	};
 
@@ -2145,10 +2144,8 @@ unsigned long shrink_all_memory(unsigned
 		int prio;
 
 		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2) {
+		if (pass > 2)
 			sc.may_swap = 1;
-			sc.swappiness = 100;
-		}
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
 			unsigned long nr_to_scan = nr_pages - ret;


