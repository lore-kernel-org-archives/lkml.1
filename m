Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbXLRMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbXLRMFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXLRMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:05:30 -0500
Received: from elvis.franken.de ([193.175.24.41]:40249 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbXLRMFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:05:30 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "Keith Mannthey" <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-Id: <20071218120300.7565AE3030@solo.franken.de>
Date: Tue, 18 Dec 2007 13:03:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using FLAT_MEMORY and ARCH_PFN_OFFSET is not 0, the kernel
crashes in memmap_init_zone(). This bug got introduced by
commit c713216deebd95d2b0ab38fef8bb2361c0180c2d

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b5a58d4..496f7f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3427,7 +3427,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 		mem_map = NODE_DATA(0)->node_mem_map;
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
-			mem_map -= pgdat->node_start_pfn;
+			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 	}
 #endif
