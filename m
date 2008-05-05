Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbYEES0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbYEES0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbYEESYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:24:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54841 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760093AbYEESYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:24:43 -0400
Date: Mon, 5 May 2008 21:23:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc64: remove online_page()
Message-ID: <20080505182336.GH17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The identical online_page() implementations from all architectures got 
moved to mm/memory_hotplug.c - except for the sparc64 one that even was 
dead code due to MEMORY_HOTPLUG not being available there.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4bd8f2a3209b4bca3f04f10e995c55ead827ae7e diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index 8c2b50e..3feb4ff 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -2361,16 +2361,3 @@ void __flush_tlb_all(void)
 	__asm__ __volatile__("wrpr	%0, 0, %%pstate"
 			     : : "r" (pstate));
 }
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
-#endif /* CONFIG_MEMORY_HOTPLUG */
