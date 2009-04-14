Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZDNHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZDNHZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZDNHZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:25:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:51375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZDNHZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:25:33 -0400
Subject: [PATCH -tip] x86: page_types.h unification of declarations
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 12:54:29 +0530
Message-Id: <1239693869.3033.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: unification of declarations, cleanup

Unification of declarations:
 moved init_memory_mapping, initmem_init and free_initmem from
page_XX_types.h to page_types.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/page_32_types.h |    4 ----
 arch/x86/include/asm/page_64_types.h |    6 ------
 arch/x86/include/asm/page_types.h    |    6 ++++++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index 0f915ae..6f1b733 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -54,10 +54,6 @@ extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
 extern void find_low_pfn_range(void);
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-extern void initmem_init(unsigned long, unsigned long);
-extern void free_initmem(void);
 extern void setup_bootmem_allocator(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d38c91b..3f58718 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -71,12 +71,6 @@ extern unsigned long __phys_addr(unsigned long);
 
 #define vmemmap ((struct page *)VMEMMAP_START)
 
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
-extern void free_initmem(void);
-
 extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
 extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index f8b9c88..25e94a4 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -54,6 +54,12 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
+
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
+extern void free_initmem(void);
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif	/* _ASM_X86_PAGE_DEFS_H */
-- 
1.6.0.6



