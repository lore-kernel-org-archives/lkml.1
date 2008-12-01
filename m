Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLAMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLAMN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYLAMNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:13:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43321 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYLAMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:13:48 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 03/11] make zone_nr_pages() helper function
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211256.1CD3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:13:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make zone_nr_pages() helper function.

it is used by latter patch.
this patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -137,6 +137,13 @@ static struct zone_reclaim_stat *get_rec
 	return &zone->reclaim_stat;
 }
 
+static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
+				   enum lru_list lru)
+{
+	return zone_page_state(zone, NR_LRU_BASE + lru);
+}
+
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1424,10 +1431,10 @@ static void get_scan_ratio(struct zone *
 		return;
 	}
 
-	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
-		zone_page_state(zone, NR_INACTIVE_ANON);
-	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
-		zone_page_state(zone, NR_INACTIVE_FILE);
+	anon  = zone_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
 	free  = zone_page_state(zone, NR_FREE_PAGES);
 
 	/* If we have very few page cache pages, force-scan anon pages. */


