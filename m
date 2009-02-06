Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZBFDNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZBFDNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbZBFDNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:13:08 -0500
Received: from cmpxchg.org ([85.214.51.133]:57483 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226AbZBFDNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:13:06 -0500
Message-Id: <20090206031323.916297777@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Fri, 06 Feb 2009 04:11:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3] swsusp: dont fiddle with swappiness
References: <20090206031125.693559239@cmpxchg.org>
Content-Disposition: inline; filename=swsusp-dont-fiddle-with-swappiness.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


