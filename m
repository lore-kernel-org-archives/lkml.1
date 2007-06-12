Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbXFLHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbXFLHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXFLHZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:25:19 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52199 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439AbXFLHZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:25:18 -0400
Message-Id: <466E66AE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:26:06 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix improper .init-type section references
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. which modpost started warning about.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 kernel/kthread.c |    2 +-
 mm/page_alloc.c  |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.22-rc4/kernel/kthread.c	2007-06-11 18:09:47.000000000 +0200
+++ 2.6.22-rc4-init-attribs/kernel/kthread.c	2007-06-11 09:10:42.000000000 +0200
@@ -215,7 +215,7 @@ int kthread_stop(struct task_struct *k)
 EXPORT_SYMBOL(kthread_stop);
 
 
-static __init void kthreadd_setup(void)
+static noinline __init_refok void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
 
--- linux-2.6.22-rc4/mm/page_alloc.c	2007-06-11 18:09:49.000000000 +0200
+++ 2.6.22-rc4-init-attribs/mm/page_alloc.c	2007-06-11 09:10:42.000000000 +0200
@@ -126,13 +126,13 @@ static unsigned long __meminitdata dma_r
     #endif
   #endif
 
-  struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-  int __meminitdata nr_nodemap_entries;
-  unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
+  static int __meminitdata nr_nodemap_entries;
+  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
-  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
@@ -1968,7 +1968,7 @@ void zone_init_free_lists(struct pglist_
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __cpuinit zone_batchsize(struct zone *zone)
+static int __devinit zone_batchsize(struct zone *zone)
 {
 	int batch;
 
@@ -2370,7 +2370,7 @@ void __init push_node_boundaries(unsigne
 }
 
 /* If necessary, push the node boundary out for reserve hotadd */
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	printk(KERN_DEBUG "Entering account_node_boundary(%u, %lu, %lu)\n",
@@ -2390,7 +2390,7 @@ static void __init account_node_boundary
 void __init push_node_boundaries(unsigned int nid,
 		unsigned long start_pfn, unsigned long end_pfn) {}
 
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn) {}
 #endif
 



