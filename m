Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYA1JK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYA1JK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYA1JKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:10:11 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58321 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYA1JKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:10:09 -0500
Date: Mon, 28 Jan 2008 01:16:54 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: mark x86_cpu_to_node_map_init to __initdata like other
 xx_init
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801280116.54810.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: mark x86_cpu_to_node_map_init to __initdata like other xx_init

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f0e5cab..d7af3fd 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -31,7 +31,7 @@ bootmem_data_t plat_node_bdata[MAX_NUMNODES];
 
 struct memnode memnode;
 
-int x86_cpu_to_node_map_init[NR_CPUS] = {
+int x86_cpu_to_node_map_init[NR_CPUS] __initdata = {
 	[0 ... NR_CPUS-1] = NUMA_NO_NODE
 };
 void *x86_cpu_to_node_map_early_ptr;
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 8af05a9..d3340de 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -35,7 +35,7 @@ extern int cpu_to_node_map[];
 
 #else
 DECLARE_PER_CPU(int, x86_cpu_to_node_map);
-extern int x86_cpu_to_node_map_init[];
+extern int __initdata x86_cpu_to_node_map_init[];
 extern void *x86_cpu_to_node_map_early_ptr;
 /* Returns the number of the current Node. */
 #define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
