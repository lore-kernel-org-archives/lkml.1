Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbYEES0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbYEES0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbYEESYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:24:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44575 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152AbYEESYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:24:51 -0400
Date: Mon, 5 May 2008 21:23:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make mm/memory_hotplug.c:online_page() static
Message-ID: <20080505182344.GI17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it's in the same file as it's caller online_page() can become 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/memory_hotplug.h |    2 --
 mm/memory_hotplug.c            |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

81106e4532f244cd20b40e856c2f6d21774a55fc diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 73e3586..5ca2325 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -64,8 +64,6 @@ static inline void zone_seqlock_init(struct zone *zone)
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
-/* need some defines for these for archs that don't support it */
-extern void online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b17dca7..b3fd604 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -329,7 +329,7 @@ static void grow_pgdat_span(struct pglist_data *pgdat,
 					pgdat->node_start_pfn;
 }
 
-void online_page(struct page *page)
+static void online_page(struct page *page)
 {
 	totalram_pages++;
 	num_physpages++;

