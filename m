Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbYGQDWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbYGQDWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYGQDWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:22:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38080 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYGQDWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:22:34 -0400
Date: Thu, 17 Jul 2008 12:27:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [mmtom][BUGFIX]
 vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
Message-Id: <20080717122751.92525032.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memcg, active anon tend not to go to inactive anon.
This will cause OOM in memcg easily when tons of anon was used at once.
This check was lacked in split-lru.

This patch is a fix agaisnt
vmscan-second-chance-replacement-for-anonymous-pages.patch


Changelog: v1 -> v2:
 - avoid adding "else".

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmtom-stamp-2008-07-15-15-39/mm/vmscan.c
===================================================================
--- mmtom-stamp-2008-07-15-15-39.orig/mm/vmscan.c
+++ mmtom-stamp-2008-07-15-15-39/mm/vmscan.c
@@ -1351,7 +1351,7 @@ static unsigned long shrink_zone(int pri
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
+	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);

