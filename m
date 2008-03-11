Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYCKVQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYCKVQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbYCKVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:15:45 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40148 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759197AbYCKVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:15:44 -0400
Date: Tue, 11 Mar 2008 21:14:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH rc5-mm1 2/3] just return do_try_to_free_pages 
In-Reply-To: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
Message-ID: <Pine.LNX.4.64.0803112112310.17067@blonde.site>
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_try_to_free_pages returns 0 or 1, and try_to_free_mem_cgroup_pages
returns 0 or 1 accordingly: let's accomplish that in the obvious way.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- 2.6.25-rc5-mm1+/mm/vmscan.c	2008-03-11 20:09:05.000000000 +0000
+++ linux/mm/vmscan.c	2008-03-11 20:15:47.000000000 +0000
@@ -1457,9 +1457,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
-	if (do_try_to_free_pages(zonelist, sc.gfp_mask, &sc))
-		return 1;
-	return 0;
+	return do_try_to_free_pages(zonelist, sc.gfp_mask, &sc);
 }
 #endif
 
