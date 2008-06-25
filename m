Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYFYMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYFYMou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYFYMon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:44:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45546 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223AbYFYMom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:44:42 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Wed, 25 Jun 2008 05:44:40 -0700
Message-Id: <20080625124440.25036.96518.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 1/2] x86 boot: more tweaks to hex prints of some pfn addresses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix some problems with (and applies on top of) a previous patch:
  x86 boot: show pfn addresses in hex not decimal in some kernel info printks

Primarily change "0x%8lx" format, which displays with a right aligned
space filled hex number (spaces between the "0x" prefix and the number),
into "%0#10lx" format, which zero fills instead of space fills, and
which uses the printf flag '#' to request the "0x" prefix instead of
hard coding it.

Also replace some other "0x%lx" formats with "%#lx", making use of the
'#' printf flag again.

Signed-off-by: Paul Jackson <pj@sgi.com>

diff -u linux-next/arch/x86/kernel/e820.c linux-next/arch/x86/kernel/e820.c
--- linux-next/arch/x86/kernel/e820.c	2008-06-22 06:36:16.792519156 -0700
+++ linux-next/arch/x86/kernel/e820.c	2008-06-24 19:43:19.313976897 -0700
@@ -922,7 +922,7 @@
 	if (last_pfn > end_user_pfn)
 		last_pfn = end_user_pfn;
 
-	printk(KERN_INFO "last_pfn = 0x%lx max_arch_pfn = 0x%lx\n",
+	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
diff -u linux-next/mm/page_alloc.c linux-next/mm/page_alloc.c
--- linux-next/mm/page_alloc.c	2008-06-22 06:36:16.800519641 -0700
+++ linux-next/mm/page_alloc.c	2008-06-25 03:41:40.774158823 -0700
@@ -3517,7 +3517,7 @@
 {
 	int i;
 
-	printk(KERN_DEBUG "Entering add_active_range(%d, 0x%lx, 0x%lx) "
+	printk(KERN_DEBUG "Entering add_active_range(%d, %#lx, %#lx) "
 			  "%d entries of %d used\n",
 			  nid, start_pfn, end_pfn,
 			  nr_nodemap_entries, MAX_ACTIVE_REGIONS);
@@ -3933,7 +3933,7 @@
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk("  %-8s 0x%8lx -> 0x%8lx\n",
+		printk("  %-8s %0#10lx -> %0#10lx\n",
 				zone_names[i],
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
@@ -3949,7 +3949,7 @@
 	/* Print out the early_node_map[] */
 	printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
 	for (i = 0; i < nr_nodemap_entries; i++)
-		printk("  %3d: 0x%8lx -> 0x%8lx\n", early_node_map[i].nid,
+		printk("  %3d: %0#10lx -> %0#10lx\n", early_node_map[i].nid,
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
diff -u linux-next/arch/x86/mm/init_64.c linux-next/arch/x86/mm/init_64.c
--- linux-next/arch/x86/mm/init_64.c	2008-06-22 06:36:16.812520369 -0700
+++ linux-next/arch/x86/mm/init_64.c	2008-06-24 19:45:57.299565640 -0700
@@ -286,7 +286,7 @@
 continue_outer_loop:
 		;
 	}
-	printk(KERN_ERR "early_ioremap(0x%lx, %lu) failed\n", addr, size);
+	printk(KERN_ERR "early_ioremap(%#lx, %lu) failed\n", addr, size);
 
 	return NULL;
 }

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
