Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZEKKME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZEKKME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZEKKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:11:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:50753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008AbZEKKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:11:41 -0400
Date: Mon, 11 May 2009 10:10:47 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241699742.17846.31.camel@penberg-laptop>
References: <1241699742.17846.31.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: use sparse_memory_present_with_active_regions() on UMA
Message-ID: <tip-087fa4e964e04371a67f340e1f6ac92c5db5e0a6@git.kernel.org>
Git-Commit-ID: 087fa4e964e04371a67f340e1f6ac92c5db5e0a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:10:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087fa4e964e04371a67f340e1f6ac92c5db5e0a6
Gitweb:     http://git.kernel.org/tip/087fa4e964e04371a67f340e1f6ac92c5db5e0a6
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Thu, 7 May 2009 15:35:42 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:52:06 +0200

x86: use sparse_memory_present_with_active_regions() on UMA

There's no need to use call memory_present() manually on UMA because
initmem_init() sets up early_node_map by calling
e820_register_active_regions().

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1241699742.17846.31.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index be7e127..52bb951 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -596,11 +596,7 @@ void __init paging_init(void)
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
