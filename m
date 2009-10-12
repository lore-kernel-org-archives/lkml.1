Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbZJLVdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbZJLVdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZJLVdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:33:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:60209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbZJLVdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:33:00 -0400
Date: Mon, 12 Oct 2009 21:31:38 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, ankita@in.ibm.com, balbir@linux.vnet.ibm.com,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu,
       len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, ankita@in.ibm.com, balbir@linux.vnet.ibm.com,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu,
       len.brown@intel.com
In-Reply-To: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Clean up and add missing log levels for k8
Message-ID: <tip-1af5ba514f0c2f2e2af965a4ffa5e8ab269271b9@git.kernel.org>
Git-Commit-ID: 1af5ba514f0c2f2e2af965a4ffa5e8ab269271b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 21:31:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1af5ba514f0c2f2e2af965a4ffa5e8ab269271b9
Gitweb:     http://git.kernel.org/tip/1af5ba514f0c2f2e2af965a4ffa5e8ab269271b9
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Fri, 25 Sep 2009 15:19:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 22:56:45 +0200

x86: Clean up and add missing log levels for k8

Convert all printk's in arch/x86/mm/k8topology_64.c to use
pr_info() or pr_err() appropriately.

Adds log levels for messages currently lacking them.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/k8topology_64.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 268f825..a81561a 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -91,14 +91,14 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	if (nb < 0)
 		return nb;
 
-	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb);
+	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
 
 	reg = read_pci_config(0, nb, 0, 0x60);
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
 		return -1;
 
-	printk(KERN_INFO "Number of nodes %d\n", numnodes);
+	pr_info("Number of nodes %d\n", numnodes);
 
 	memset(&nodes, 0, sizeof(nodes));
 	prevbase = 0;
@@ -111,28 +111,28 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		nodeid = limit & 7;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
-				printk("Skipping disabled node %d\n", i);
+				pr_info("Skipping disabled node %d\n", i);
 			continue;
 		}
 		if (nodeid >= numnodes) {
-			printk("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-			       base, limit);
+			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+				base, limit);
 			continue;
 		}
 
 		if (!limit) {
-			printk(KERN_INFO "Skipping node entry %d (base %lx)\n",
-			       i, base);
+			pr_info("Skipping node entry %d (base %lx)\n",
+				i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			printk(KERN_ERR "Node %d using interleaving mode %lx/%lx\n",
-			       nodeid, (base>>8)&3, (limit>>8) & 3);
+			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -1;
 		}
 		if (node_isset(nodeid, node_possible_map)) {
-			printk(KERN_INFO "Node %d already present. Skipping\n",
-			       nodeid);
+			pr_info("Node %d already present, skipping\n",
+				nodeid);
 			continue;
 		}
 
@@ -154,24 +154,24 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		if (limit > end)
 			limit = end;
 		if (limit == base) {
-			printk(KERN_ERR "Empty node %d\n", nodeid);
+			pr_err("Empty node %d\n", nodeid);
 			continue;
 		}
 		if (limit < base) {
-			printk(KERN_ERR "Node %d bogus settings %lx-%lx.\n",
+			pr_err("Node %d bogus settings %lx-%lx.\n",
 			       nodeid, base, limit);
 			continue;
 		}
 
 		/* Could sort here, but pun for now. Should not happen anyroads. */
 		if (prevbase > base) {
-			printk(KERN_ERR "Node map not sorted %lx,%lx\n",
+			pr_err("Node map not sorted %lx,%lx\n",
 			       prevbase, base);
 			return -1;
 		}
 
-		printk(KERN_INFO "Node %d MemBase %016lx Limit %016lx\n",
-		       nodeid, base, limit);
+		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+			nodeid, base, limit);
 
 		found++;
 
@@ -188,10 +188,10 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
 	if (memnode_shift < 0) {
-		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n");
+		pr_err("No NUMA node hash function found. Contact maintainer\n");
 		return -1;
 	}
-	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift);
+	pr_info("Using node hash shift of %d\n", memnode_shift);
 
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
@@ -200,8 +200,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	/* need to get boot_cpu_id early for system with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
-		printk(KERN_INFO "BSP APIC ID: %02x\n",
-				 boot_cpu_physical_apicid);
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
