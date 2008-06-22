Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYFVOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYFVOXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYFVOWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:22:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54001 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756364AbYFVOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:22:13 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:22:12 -0700
Message-Id: <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Page frame numbers (the portion of physical addresses above the low
order page offsets) are displayed in several kernel debug and info
prints in decimal, not hex.  Decimal addresse are unreadable.  Use hex.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820.c |    2 +-
 arch/x86/mm/init_64.c  |    2 +-
 mm/page_alloc.c        |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- linux-next.orig/arch/x86/kernel/e820.c	2008-06-22 06:36:07.203937695 -0700
+++ linux-next/arch/x86/kernel/e820.c	2008-06-22 06:36:16.792519156 -0700
@@ -922,7 +922,7 @@ unsigned long __init e820_end_of_ram(voi
 	if (last_pfn > end_user_pfn)
 		last_pfn = end_user_pfn;
 
-	printk(KERN_INFO "last_pfn = %lu max_arch_pfn = %lu\n",
+	printk(KERN_INFO "last_pfn = 0x%lx max_arch_pfn = 0x%lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
--- linux-next.orig/mm/page_alloc.c	2008-06-22 06:35:53.835126994 -0700
+++ linux-next/mm/page_alloc.c	2008-06-22 06:36:16.800519641 -0700
@@ -3517,7 +3517,7 @@ void __init add_active_range(unsigned in
 {
 	int i;
 
-	printk(KERN_DEBUG "Entering add_active_range(%d, %lu, %lu) "
+	printk(KERN_DEBUG "Entering add_active_range(%d, 0x%lx, 0x%lx) "
 			  "%d entries of %d used\n",
 			  nid, start_pfn, end_pfn,
 			  nr_nodemap_entries, MAX_ACTIVE_REGIONS);
@@ -3933,7 +3933,7 @@ void __init free_area_init_nodes(unsigne
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk("  %-8s %8lu -> %8lu\n",
+		printk("  %-8s 0x%8lx -> 0x%8lx\n",
 				zone_names[i],
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
@@ -3949,7 +3949,7 @@ void __init free_area_init_nodes(unsigne
 	/* Print out the early_node_map[] */
 	printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
 	for (i = 0; i < nr_nodemap_entries; i++)
-		printk("  %3d: %8lu -> %8lu\n", early_node_map[i].nid,
+		printk("  %3d: 0x%8lx -> 0x%8lx\n", early_node_map[i].nid,
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
--- linux-next.orig/arch/x86/mm/init_64.c	2008-06-22 06:35:50.326914251 -0700
+++ linux-next/arch/x86/mm/init_64.c	2008-06-22 06:36:16.812520369 -0700
@@ -830,7 +830,7 @@ int __init reserve_bootmem_generic(unsig
 		if (pfn < max_pfn_mapped)
 			return -EFAULT;
 
-		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
+		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %lu\n",
 				phys, len);
 		return -EFAULT;
 	}

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
