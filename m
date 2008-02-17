Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYBQGx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYBQGx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYBQGxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:53:50 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51627 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYBQGxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:53:49 -0500
Date: Sat, 16 Feb 2008 23:02:03 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove never used nodenumer in pda
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802162302.04131.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we don't need copy too. already have x86_cpu_to_node_map

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1aecc65..69b33e3 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -546,8 +546,6 @@ void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
 
-	cpu_pda(cpu)->nodenumber = node;
-
 	if(cpu_to_node_map)
 		cpu_to_node_map[cpu] = node;
 	else if(per_cpu_offset(cpu))
diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index c0305bf..d9dc209 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					   offset 40!!! */
 #endif
 	char *irqstackptr;
-	unsigned int nodenumber;	/* number of current node */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
