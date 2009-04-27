Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZD0Jvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZD0Jvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZD0Jsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:30 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754575AbZD0Js3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:29 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 26/30] microblaze_mmu_v1: Update cacheflush.h
Date: Mon, 27 Apr 2009 10:32:15 +0200
Message-Id: <1240821139-7247-27-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-26-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/cacheflush.h |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/cacheflush.h b/arch/microblaze/include/asm/cacheflush.h
index 3300b78..f989d6a 100644
--- a/arch/microblaze/include/asm/cacheflush.h
+++ b/arch/microblaze/include/asm/cacheflush.h
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
  * based on v850 version which was
  * Copyright (C) 2001,02,03 NEC Electronics Corporation
@@ -43,6 +44,23 @@
 #define flush_icache_range(start, len)	__invalidate_icache_range(start, len)
 #define flush_icache_page(vma, pg)		do { } while (0)
 
+#ifndef CONFIG_MMU
+# define flush_icache_user_range(start, len)	do { } while (0)
+#else
+# define flush_icache_user_range(vma, pg, adr, len) __invalidate_icache_all()
+
+# define flush_page_to_ram(page)		do { } while (0)
+
+# define flush_icache()			__invalidate_icache_all()
+# define flush_cache_sigtramp(vaddr) \
+			__invalidate_icache_range(vaddr, vaddr + 8)
+
+# define flush_dcache_mmap_lock(mapping)	do { } while (0)
+# define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+# define flush_cache_dup_mm(mm)			do { } while (0)
+#endif
+
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
-- 
1.5.5.1

