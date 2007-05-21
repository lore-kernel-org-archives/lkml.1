Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXEULB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXEULB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761955AbXEULAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:00:45 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:26651 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbXEULAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:00:39 -0400
Message-Id: <20070521110109.113710952@de.ibm.com>
References: <20070521105118.955425052@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:51:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/5] More verbose show_mem() like other architectures.
Content-Disposition: inline; filename=005-showmem.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/mm/init.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

Index: quilt-2.6/arch/s390/mm/init.c
===================================================================
--- quilt-2.6.orig/arch/s390/mm/init.c
+++ quilt-2.6/arch/s390/mm/init.c
@@ -61,30 +61,38 @@ void diag10(unsigned long addr)
 
 void show_mem(void)
 {
-        int i, total = 0, reserved = 0;
-        int shared = 0, cached = 0;
+	int i, total = 0, reserved = 0;
+	int shared = 0, cached = 0;
 	struct page *page;
 
-        printk("Mem-info:\n");
-        show_free_areas();
-        printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-        i = max_mapnr;
-        while (i-- > 0) {
+	printk("Mem-info:\n");
+	show_free_areas();
+	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
+	i = max_mapnr;
+	while (i-- > 0) {
 		if (!pfn_valid(i))
 			continue;
 		page = pfn_to_page(i);
-                total++;
+		total++;
 		if (PageReserved(page))
-                        reserved++;
+			reserved++;
 		else if (PageSwapCache(page))
-                        cached++;
+			cached++;
 		else if (page_count(page))
 			shared += page_count(page) - 1;
-        }
-        printk("%d pages of RAM\n",total);
-        printk("%d reserved pages\n",reserved);
-        printk("%d pages shared\n",shared);
-        printk("%d pages swap cached\n",cached);
+	}
+	printk("%d pages of RAM\n", total);
+	printk("%d reserved pages\n", reserved);
+	printk("%d pages shared\n", shared);
+	printk("%d pages swap cached\n", cached);
+
+	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
+	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
+	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
+	printk("%lu pages slab\n",
+	       global_page_state(NR_SLAB_RECLAIMABLE) +
+	       global_page_state(NR_SLAB_UNRECLAIMABLE));
+	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
 }
 
 static void __init setup_ro_region(void)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

