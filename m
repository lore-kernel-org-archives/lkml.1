Return-Path: <linux-kernel-owner+w=401wt.eu-S1946515AbXBIPhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946515AbXBIPhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946551AbXBIPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946548AbXBIPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HBN7h+hUlFXQdg7yoXC1ExWFzWnoRymzL6tm2Iie9+riof8w0UCOS3uK+IfQHRdx3Y0C49ZRu8cHm3JfmDmqggbyRS7QrE+qnQcNx8b/HqFgOfi01Tg4IiO7eyTbMuLa4YL+xIvA3mYRzlEl3V+ZNizu+C+PyzC7up3Zv0sh1N0=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, linux-mm@kvack.org
Subject: [PATCH 27/34] __initdata cleanup - mm
Date: Fri, 9 Feb 2007 17:31:54 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091731.54838.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/mm/page_alloc.c linux-2.6.20-rc6-mm3/mm/page_alloc.c
--- linux-2.6.20-rc6-mm3.org/mm/page_alloc.c	2007-01-31 22:15:42.000000000 +0200
+++ linux-2.6.20-rc6-mm3/mm/page_alloc.c	2007-01-31 22:19:30.000000000 +0200
@@ -101,9 +101,9 @@ static char * const zone_names[MAX_NR_ZO
 
 int min_free_kbytes = 1024;
 
-unsigned long __meminitdata nr_kernel_pages;
-unsigned long __meminitdata nr_all_pages;
-static unsigned long __initdata dma_reserve;
+unsigned long __meminitdata nr_kernel_pages = 0l;
+unsigned long __meminitdata nr_all_pages = 0l;
+static unsigned long __initdata dma_reserve = 0l;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
   /*
@@ -126,13 +126,13 @@ static unsigned long __initdata dma_rese
     #endif
   #endif
 
-  struct node_active_region __initdata early_node_map[MAX_ACTIVE_REGIONS];
-  int __initdata nr_nodemap_entries;
-  unsigned long __initdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  unsigned long __initdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+  struct node_active_region __initdata early_node_map[MAX_ACTIVE_REGIONS] = {{0}};
+  int __initdata nr_nodemap_entries = 0;
+  unsigned long __initdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES] = {0};
+  unsigned long __initdata arch_zone_highest_possible_pfn[MAX_NR_ZONES] = {0};
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
-  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
+  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES] = {0};
+  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES] = {0};
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
@@ -1776,7 +1776,7 @@ static int __meminit build_zonelists_nod
 
 #ifdef CONFIG_NUMA
 #define MAX_NODE_LOAD (num_online_nodes())
-static int __meminitdata node_load[MAX_NUMNODES];
+static int __meminitdata node_load[MAX_NUMNODES] = {0};
 /**
  * find_next_best_node - find the next node that should appear in a given node's fallback list
  * @node: node whose fallback list we're appending
diff -urNp linux-2.6.20-rc6-mm3.org/mm/slab.c linux-2.6.20-rc6-mm3/mm/slab.c
--- linux-2.6.20-rc6-mm3.org/mm/slab.c	2007-01-31 22:15:42.000000000 +0200
+++ linux-2.6.20-rc6-mm3/mm/slab.c	2007-01-31 22:19:30.000000000 +0200
@@ -305,7 +305,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS] = {{{0}}};
 #define	CACHE_CACHE 0
 #define	SIZE_AC 1
 #define	SIZE_L3 (1 + MAX_NUMNODES)
