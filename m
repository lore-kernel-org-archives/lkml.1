Return-Path: <linux-kernel-owner+w=401wt.eu-S1761037AbYBAVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037AbYBAVWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYBAVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:22:12 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43840 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYBAVWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:22:12 -0500
Date: Fri, 01 Feb 2008 13:29:15 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: mark x86_cpu_to_node_map_init to __initdata like other
 xx_init
In-reply-to: <20080201170908.GB2159@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Message-id: <200802011329.15319.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801290053.45776.yinghai.lu@sun.com>
 <200801290105.35561.yinghai.lu@sun.com> <20080201170908.GB2159@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: mark x86_cpu_to_node_map_init to __initdata like other xx_init

x86_cpu_to_apicid_init and x86_bios_cpu_apicid_init are defined with __initdata.

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
