Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbZEGMgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbZEGMgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZEGMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:35:44 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47650 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZEGMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:35:42 -0400
Subject: [PATCH 2/2] x86: use sparse_memory_present_with_active_regions()
 on UMA
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 07 May 2009 15:35:42 +0300
Message-Id: <1241699742.17846.31.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's no need to use call memory_present() manually on UMA because
initmem_init() sets up early_node_map by calling
e820_register_active_regions().

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_64.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ccc0e6e..5ded102 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -639,11 +639,7 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
-#ifdef CONFIG_NUMA
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
-#else
-	memory_present(0, 0, max_pfn);
-#endif
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }
-- 
1.5.6.3



