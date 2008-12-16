Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYLPC1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYLPC1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYLPCYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36156 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751643AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022410.269898000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:12 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] x86: move and enhance debug printk for nr_cpu_ids etc.
Content-Disposition: inline; filename=0003-x86-move-and-enhance-debug-printk-for-nr_cpu_ids-et.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, better debugging

This has proven useful in debugging, *before* we try to use
for_each_possible_cpu().  It also now shows nr_cpumask_bits.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/setup_percpu.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 1c20842..0b63b08 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -152,6 +152,11 @@ void __init setup_per_cpu_areas(void)
 	old_size = PERCPU_ENOUGH_ROOM;
 	align = max_t(unsigned long, PAGE_SIZE, align);
 	size = roundup(old_size, align);
+
+	printk(KERN_INFO
+		"NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
+
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
@@ -168,24 +173,24 @@ void __init setup_per_cpu_areas(void)
 			       "cpu %d has no node %d or node-local memory\n",
 				cpu, node);
 			if (ptr)
-				printk(KERN_DEBUG "per cpu data for cpu%d at %016lx\n",
+				printk(KERN_DEBUG
+					"per cpu data for cpu%d at %016lx\n",
 					 cpu, __pa(ptr));
 		}
 		else {
 			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
 							__pa(MAX_DMA_ADDRESS));
 			if (ptr)
-				printk(KERN_DEBUG "per cpu data for cpu%d on node%d at %016lx\n",
-					 cpu, node, __pa(ptr));
+				printk(KERN_DEBUG
+					"per cpu data for cpu%d on node%d "
+					"at %016lx\n",
+					cpu, node, __pa(ptr));
 		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
-
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
-- 
1.6.0

-- 
