Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYG1Az2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYG1Az2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbYG1AzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:55:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20026 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbYG1AzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Tz+AS2ZHsRa6ywMRlGg7mCItf0ClzkcDjEI9RZ/OU++2NFL8o2KQ9vHh9cGicfyigg
         IHHtFVuUMdPK9nBDZ0MpDBp6Fgkoh5/JBw+HvwRt30NtdKhEhRRPCVTPq8ALEqmX1Ed6
         VZjHrURWJ7lmdm1oU1wTFckqMpdFrOeTkq5bQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] mm: remove find_max_pfn_with_active_regions
Date: Sun, 27 Jul 2008 17:54:33 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807271754.33833.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


no user now

also print out info about adding/removing active region

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1036,7 +1036,6 @@ extern unsigned long absent_pages_in_ran
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
-extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3572,8 +3572,7 @@ void __init add_active_range(unsigned in
 {
 	int i;
 
-	mminit_dprintk(MMINIT_TRACE, "memory_register",
-			"Entering add_active_range(%d, %#lx, %#lx) "
+	printk(KERN_INFO "Adding active range (%d, %#lx, %#lx) "
 			"%d entries of %d used\n",
 			nid, start_pfn, end_pfn,
 			nr_nodemap_entries, MAX_ACTIVE_REGIONS);
@@ -3635,7 +3634,7 @@ void __init remove_active_range(unsigned
 	int i, j;
 	int removed = 0;
 
-	printk(KERN_DEBUG "remove_active_range (%d, %lu, %lu)\n",
+	printk(KERN_INFO "Removing active range (%d, %#lx, %#lx)\n",
 			  nid, start_pfn, end_pfn);
 
 	/* Find the old active region end and shrink */
@@ -3753,23 +3752,6 @@ unsigned long __init find_min_pfn_with_a
 	return find_min_pfn_for_node(MAX_NUMNODES);
 }
 
-/**
- * find_max_pfn_with_active_regions - Find the maximum PFN registered
- *
- * It returns the maximum PFN based on information provided via
- * add_active_range().
- */
-unsigned long __init find_max_pfn_with_active_regions(void)
-{
-	int i;
-	unsigned long max_pfn = 0;
-
-	for (i = 0; i < nr_nodemap_entries; i++)
-		max_pfn = max(max_pfn, early_node_map[i].end_pfn);
-
-	return max_pfn;
-}
-
 /*
  * early_calculate_totalpages()
  * Sum pages in active regions for movable zone.
