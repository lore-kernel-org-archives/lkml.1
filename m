Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXHHHJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXHHHJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbXHHHHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:07:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbXHHHHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:07:40 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/25] [PATCH] native versions for system.h functions
Date: Wed,  8 Aug 2007 01:18:52 -0300
Message-Id: <11865467741753-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467702103-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the native hook for the functions in system.h
They are the read/write_crX, clts and wbinvd. The later, also
gets its call sites patched.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86_64/kernel/tce.c  |    2 +-
 arch/x86_64/mm/pageattr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index e3f2569..587f0c2 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
 	if (cpu_has_clflush)
 		asm volatile("clflush (%0)" :: "r" (tceaddr));
 	else
-		asm volatile("wbinvd":::"memory");
+		wbinvd();
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 7e161c6..b497afd 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -76,7 +76,7 @@ static void flush_kernel_map(void *arg)
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	if (!cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		cache_flush_page(adr);
-- 
1.4.4.2

