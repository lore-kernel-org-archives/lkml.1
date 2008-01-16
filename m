Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYAQRf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYAQRf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYAQRfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:35:50 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40543 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750948AbYAQRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:35:50 -0500
Message-Id: <20080116183438.636758000@sgi.com>
References: <20080116183438.506737000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Jan 2008 10:34:39 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86: Fixup NR-CPUS patch for numa
Content-Disposition: inline; filename=fixup-nr-cpus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the EXPORT_SYMBOL for:

	x86_cpu_to_node_map_init
	x86_cpu_to_node_map_early_ptr

... thus fixing the section mismatch problem.

Also, the mem -> node hash lookup is fixed.

Based on 2.6.24-rc6-mm1 + change-NR_CPUS-V3 patchset

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa_64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -35,8 +35,6 @@ u16 x86_cpu_to_node_map_init[NR_CPUS] __
 	[0 ... NR_CPUS-1] = NUMA_NO_NODE
 };
 void *x86_cpu_to_node_map_early_ptr;
-EXPORT_SYMBOL(x86_cpu_to_node_map_init);
-EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
 DEFINE_PER_CPU(u16, x86_cpu_to_node_map) = NUMA_NO_NODE;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
@@ -88,7 +86,7 @@ static int __init allocate_cachealigned_
 	unsigned long pad, pad_addr;
 
 	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= 48)
+	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
 	pad = L1_CACHE_BYTES - 1;

-- 

