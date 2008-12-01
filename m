Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYLAKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYLAKIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLAKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:08:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39348 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYLAKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:08:08 -0500
Date: Mon, 1 Dec 2008 19:07:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, nickpiggin@yahoo.com.au, knikanth@suse.de,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] memcg:  rename scan_global_lru macro
Message-Id: <20081201190715.20323800.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename scan_grobal_lru() to scanning_global_lru().

scan_global_lru() sounds like that it does "scan" global lru.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/vmscan.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: mmotm-2.6.28-Nov30/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/vmscan.c
+++ mmotm-2.6.28-Nov30/mm/vmscan.c
@@ -126,9 +126,9 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-#define scan_global_lru(sc)	(!(sc)->mem_cgroup)
+#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
 #else
-#define scan_global_lru(sc)	(1)
+#define scanning_global_lru(sc)	(1)
 #endif
 
 /*
@@ -1124,7 +1124,7 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
 			zone->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 			zone->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1162,7 +1162,7 @@ static unsigned long shrink_inactive_lis
 		if (current_is_kswapd()) {
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		} else if (scan_global_lru(sc))
+		} else if (scanning_global_lru(sc))
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
 
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
@@ -1188,7 +1188,7 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page) && scan_global_lru(sc)) {
+			if (PageActive(page) && scanning_global_lru(sc)) {
 				int file = !!page_is_file_cache(page);
 				zone->recent_rotated[file]++;
 			}
@@ -1265,7 +1265,7 @@ static void shrink_active_list(unsigned 
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 		zone->recent_scanned[!!file] += pgmoved;
 	}
@@ -1301,7 +1301,7 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		zone->recent_rotated[!!file] += pgmoved;
 
 	/*
@@ -1361,7 +1361,7 @@ static unsigned long shrink_list(enum lr
 	}
 
 	if (lru == LRU_ACTIVE_ANON &&
-	    (!scan_global_lru(sc) || inactive_anon_is_low(zone))) {
+	    (!scanning_global_lru(sc) || inactive_anon_is_low(zone))) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
@@ -1467,7 +1467,7 @@ static void shrink_zone(int priority, st
 	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			int file = is_file_lru(l);
 			int scan;
 
@@ -1522,9 +1522,9 @@ static void shrink_zone(int priority, st
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
+	if (!scanning_global_lru(sc) || inactive_anon_is_low(zone))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
-	else if (!scan_global_lru(sc))
+	else if (!scanning_global_lru(sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
@@ -1559,7 +1559,7 @@ static void shrink_zones(int priority, s
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 			note_zone_scanning_priority(zone, priority);
@@ -1612,12 +1612,12 @@ static unsigned long do_try_to_free_page
 
 	delayacct_freepages_start();
 
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
 	/*
 	 * mem_cgroup will not do shrink_slab.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
@@ -1636,7 +1636,7 @@ static unsigned long do_try_to_free_page
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -1667,7 +1667,7 @@ static unsigned long do_try_to_free_page
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && scan_global_lru(sc))
+	if (!sc->all_unreclaimable && scanning_global_lru(sc))
 		ret = sc->nr_reclaimed;
 out:
 	/*
@@ -1680,7 +1680,7 @@ out:
 	if (priority < 0)
 		priority = 0;
 
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))

