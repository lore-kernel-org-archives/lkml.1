Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZETHZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZETHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZETHZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:25:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:20310 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZETHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MckxIxXeCHWO7ip9q7X6Ch0WlqmrzYFAvORAxlN6m3cN3tSPe2acTB5Jnz58xLh/ZN
         GAAzbEjMdLRW/8P5JlIcqdIILw4dztO5gw9ugPIAeMNNKhtf4HhccTiHD1j+6IUQi7WZ
         g7F3nXkDwSMP+3ZELF/ULtl5U9gFaKjZ/yqgM=
Date: Wed, 20 May 2009 16:19:36 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/3] add inactive ratio calculation function of each zone
Message-Id: <20090520161936.c86a0e38.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch divides setup_per_zone_inactive_ratio with
per zone inactive ratio calculaton.

CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b2cb16..cede957 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1059,6 +1059,7 @@ extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmark_min(void);
+extern void calculate_per_zone_inactive_ratio(struct zone* zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 273526b..4601ba0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4552,11 +4552,8 @@ void setup_per_zone_wmark_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void __init setup_per_zone_inactive_ratio(void)
+void calculate_per_zone_inactive_ratio(struct zone* zone)
 {
-	struct zone *zone;
-
-	for_each_zone(zone) {
 		unsigned int gb, ratio;
 
 		/* Zone size in gigabytes */
@@ -4567,7 +4564,14 @@ static void __init setup_per_zone_inactive_ratio(void)
 			ratio = 1;
 
 		zone->inactive_ratio = ratio;
-	}
+}
+
+static void __init setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone) 
+		calculate_per_zone_inactive_ratio(zone);
 }
 
 /*
-- 
1.5.4.3



-- 
Kinds Regards
Minchan Kim
