Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYABXz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYABXz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYABXzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:55:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:49976 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYABXzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PqVXpuv1CjW/XDWrI7n3tWbUmFhQWCuDcDBgBtdPydIFEVHtQ4efaZvDTP11l3raXZuE9RiUrdLG4SbSqK39udjsGBueNDAAozy1Xe1qPE5gqMlnTO5tadZa/HxGlrvuBbQfziyE9dS5CS7ElU0xAHge8rsOOZqhUMSWJ8VsOMI=
Date: Wed, 2 Jan 2008 15:58:16 -0800
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Clean up k8topology.c
Message-ID: <20080102235816.GA8826@localhost.physics.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Cleanup k8topology.c

This patch fixes all errors pointed out by checkpatch.pl.

                                      errors   lines of code   errors/KLOC
arch/x86/mm/k8topology_64.c (before)      72             185         389.1
arch/x86/mm/k8topology_64.c (after)        0             185             0

No code changed.

   text    data     bss     dec     hex filename
   1506       0       0    1506     5e2 k8topology_64.o.after
   1506       0       0    1506     5e2 k8topology_64.o.before
   
md5sum:

   f9f48331a7eca4fc60d2a03369dc5f53  k8topology_64.o.after
   f9f48331a7eca4fc60d2a03369dc5f53  k8topology_64.o.before
   
Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>


diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 3695c9e..32b963d 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -1,9 +1,9 @@
-/* 
+/*
  * AMD K8 NUMA support.
  * Discover the memory map and associated nodes.
- * 
+ *
  * This version reads it directly from the K8 northbridge.
- * 
+ *
  * Copyright 2002,2003 Andi Kleen, SuSE Labs.
  */
 #include <linux/kernel.h>
@@ -22,26 +22,26 @@
 
 static __init int find_northbridge(void)
 {
-	int num; 
+	int num;
 
-	for (num = 0; num < 32; num++) { 
+	for (num = 0; num < 32; num++) {
 		u32 header;
-		
-		header = read_pci_config(0, num, 0, 0x00);  
+
+		header = read_pci_config(0, num, 0, 0x00);
 		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
-			continue; 	
+			continue;
 
-		header = read_pci_config(0, num, 1, 0x00); 
+		header = read_pci_config(0, num, 1, 0x00);
 		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
-			continue;	
-		return num; 
-	} 
+			continue;
+		return num;
+	}
 
-	return -1; 	
+	return -1;
 }
 
 int __init k8_scan_nodes(unsigned long start, unsigned long end)
-{ 
+{
 	unsigned long prevbase;
 	struct bootnode nodes[8];
 	int nodeid, i, nb;
@@ -56,97 +56,97 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	if (!early_pci_allowed())
 		return -1;
 
-	nb = find_northbridge(); 
-	if (nb < 0) 
+	nb = find_northbridge();
+	if (nb < 0)
 		return nb;
 
-	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb); 
+	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb);
 
-	reg = read_pci_config(0, nb, 0, 0x60); 
+	reg = read_pci_config(0, nb, 0, 0x60);
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
 		return -1;
 
 	printk(KERN_INFO "Number of nodes %d\n", numnodes);
 
-	memset(&nodes,0,sizeof(nodes)); 
+	memset(&nodes, 0, sizeof(nodes));
 	prevbase = 0;
-	for (i = 0; i < 8; i++) { 
-		unsigned long base,limit; 
+	for (i = 0; i < 8; i++) {
+		unsigned long base, limit;
 		u32 nodeid;
-		
+
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
-		nodeid = limit & 7; 
+		nodeid = limit & 7;
 		nodeids[i] = nodeid;
-		if ((base & 3) == 0) { 
+		if ((base & 3) == 0) {
 			if (i < numnodes)
-				printk("Skipping disabled node %d\n", i); 
+				printk("Skipping disabled node %d\n", i);
 			continue;
-		} 
+		}
 		if (nodeid >= numnodes) {
 			printk("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-			       base, limit); 
+			       base, limit);
 			continue;
-		} 
+		}
 
-		if (!limit) { 
-			printk(KERN_INFO "Skipping node entry %d (base %lx)\n", i,
-			       base);
+		if (!limit) {
+			printk(KERN_INFO "Skipping node entry %d (base %lx)\n",
+			       i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			printk(KERN_ERR "Node %d using interleaving mode %lx/%lx\n", 
-			       nodeid, (base>>8)&3, (limit>>8) & 3); 
-			return -1; 
-		}	
+			printk(KERN_ERR "Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base>>8)&3, (limit>>8) & 3);
+			return -1;
+		}
 		if (node_isset(nodeid, node_possible_map)) {
-			printk(KERN_INFO "Node %d already present. Skipping\n", 
+			printk(KERN_INFO "Node %d already present. Skipping\n",
 			       nodeid);
 			continue;
 		}
 
-		limit >>= 16; 
-		limit <<= 24; 
+		limit >>= 16;
+		limit <<= 24;
 		limit |= (1<<24)-1;
 		limit++;
 
 		if (limit > end_pfn << PAGE_SHIFT)
 			limit = end_pfn << PAGE_SHIFT;
 		if (limit <= base)
-			continue; 
-			
+			continue;
+
 		base >>= 16;
-		base <<= 24; 
-
-		if (base < start) 
-			base = start; 
-		if (limit > end) 
-			limit = end; 
-		if (limit == base) { 
-			printk(KERN_ERR "Empty node %d\n", nodeid); 
-			continue; 
+		base <<= 24;
+
+		if (base < start)
+			base = start;
+		if (limit > end)
+			limit = end;
+		if (limit == base) {
+			printk(KERN_ERR "Empty node %d\n", nodeid);
+			continue;
 		}
-		if (limit < base) { 
+		if (limit < base) {
 			printk(KERN_ERR "Node %d bogus settings %lx-%lx.\n",
-			       nodeid, base, limit); 			       
+			       nodeid, base, limit);
 			continue;
-		} 
-		
+		}
+
 		/* Could sort here, but pun for now. Should not happen anyroads. */
-		if (prevbase > base) { 
+		if (prevbase > base) {
 			printk(KERN_ERR "Node map not sorted %lx,%lx\n",
-			       prevbase,base);
+			       prevbase, base);
 			return -1;
 		}
-			
-		printk(KERN_INFO "Node %d MemBase %016lx Limit %016lx\n", 
-		       nodeid, base, limit); 
-		
+
+		printk(KERN_INFO "Node %d MemBase %016lx Limit %016lx\n",
+		       nodeid, base, limit);
+
 		found++;
-		
-		nodes[nodeid].start = base; 
+
+		nodes[nodeid].start = base;
 		nodes[nodeid].end = limit;
 		e820_register_active_regions(nodeid,
 				nodes[nodeid].start >> PAGE_SHIFT,
@@ -155,31 +155,31 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		prevbase = base;
 
 		node_set(nodeid, node_possible_map);
-	} 
+	}
 
 	if (!found)
-		return -1; 
+		return -1;
 
 	memnode_shift = compute_hash_shift(nodes, 8);
-	if (memnode_shift < 0) { 
-		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n"); 
-		return -1; 
-	} 
-	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift); 
+	if (memnode_shift < 0) {
+		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n");
+		return -1;
+	}
+	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift);
 
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = (1<<bits);
 
 	for (i = 0; i < 8; i++) {
-		if (nodes[i].start != nodes[i].end) { 
+		if (nodes[i].start != nodes[i].end) {
 			nodeid = nodeids[i];
 			for (j = 0; j < cores; j++)
 				apicid_to_node[(nodeid << bits) + j] = i;
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
-		} 
+			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
+		}
 	}
 
 	numa_init_array();
 	return 0;
-} 
+}
