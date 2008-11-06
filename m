Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZD3PpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZD3PpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZD3PmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbZD3PmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:01 -0400
Message-Id: <2d8ccc76119d2379859480dbb8f7562743a1de58.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Nov 2008 14:40:51 +0100
Subject: [PATCH 07/27] asm-generic: add minimal cache description
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+tc5exIHLPTAfl05pdrfzjsn8CCu1C3f3n6yX
 tzZWd17R0ynqILCYJETXFfcVWy+YUhgkviHXWjE3Mi3ZD3oeCt
 +uIChY90bPBh6twn189Zw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures have a 32 byte cache line and never
require flushing the cache, so they can use these
generic implementation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/cache.h      |   12 ++++++++++++
 include/asm-generic/cacheflush.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h

diff --git a/include/asm-generic/cache.h b/include/asm-generic/cache.h
new file mode 100644
index 0000000..1bfcfe5
--- /dev/null
+++ b/include/asm-generic/cache.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_CACHE_H
+#define __ASM_GENERIC_CACHE_H
+/*
+ * 32 bytes appears to be the most common cache line size,
+ * so make that the default here. Architectures with larger
+ * cache lines need to provide their own cache.h.
+ */
+
+#define L1_CACHE_SHIFT		5
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#endif /* __ASM_GENERIC_CACHE_H */
diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
new file mode 100644
index 0000000..ba4ec39
--- /dev/null
+++ b/include/asm-generic/cacheflush.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_CACHEFLUSH_H
+#define __ASM_CACHEFLUSH_H
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/*
+ * The cache doesn't need to be flushed when TLB entries change when
+ * the cache is mapped to physical memory, not virtual memory
+ */
+#define flush_cache_all()			do { } while (0)
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	do { } while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define flush_dcache_page(page)			do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+#define flush_icache_range(start, end)		do { } while (0)
+#define flush_icache_page(vma,pg)		do { } while (0)
+#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#endif /* __ASM_CACHEFLUSH_H */
-- 
1.5.6.3


