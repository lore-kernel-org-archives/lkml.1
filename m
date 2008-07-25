Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYGYOvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYGYOvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYGYOuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:50:11 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:8912 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYGYOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:50:09 -0400
X-BigFish: VPS8(z37d4lzzz10d3izzz32i43j)
X-WSS-ID: 0K4KH72-04-24H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] x86: convert numa_64.c from round_up to roundup
Date: Fri, 25 Jul 2008 16:48:58 +0200
Message-ID: <1216997339-31427-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0483 (UTC) FILETIME=[925E72B0:01C8EE65]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/numa_64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 9782f42..e8e2aed 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -81,7 +81,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 		return 0;
 
 	addr = 0x8000;
-	nodemap_size = round_up(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
+	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
 	nodemap_addr = find_e820_area(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
@@ -178,10 +178,10 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	unsigned long start_pfn, last_pfn, bootmap_pages, bootmap_size;
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
-	const int pgdat_size = round_up(sizeof(pg_data_t), PAGE_SIZE);
+	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
-	start = round_up(start, ZONE_ALIGN);
+	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
 	       start, end);
@@ -212,9 +212,9 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
 	nid = phys_to_nid(nodedata_phys);
 	if (nid == nodeid)
-		bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+		bootmap_start = roundup(nodedata_phys + pgdat_size, PAGE_SIZE);
 	else
-		bootmap_start = round_up(start, PAGE_SIZE);
+		bootmap_start = roundup(start, PAGE_SIZE);
 	/*
 	 * SMP_CACHE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
-- 
1.5.3.7


