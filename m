Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZBQTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZBQTqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZBQTqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:46:24 -0500
Received: from cmpxchg.org ([85.214.51.133]:38657 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZBQTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:46:24 -0500
Date: Tue, 17 Feb 2009 20:48:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch] vmscan: respect higher order in zone_reclaim()
Message-ID: <20090217194826.GA17415@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_reclaim() already tries to free the requested 2^order pages but
doesn't pass the order information into the inner reclaim code.

This prevents lumpy reclaim from happening on higher orders although
the caller explicitely asked for that.

Fix it up by initializing the order field of the scan control
according to the request.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2297,6 +2297,7 @@ static int __zone_reclaim(struct zone *z
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.order = order,
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
