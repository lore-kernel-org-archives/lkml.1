Return-Path: <linux-kernel-owner+w=401wt.eu-S1764173AbZEAOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764173AbZEAOqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbZEAOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42228 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbZEAOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:20 -0400
Subject: [RFC][PATCH 11/35] mips: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:18 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144218.4F34C17D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h |    8 ------
 linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h |    8 ------
 linux-2.6.git-dave/arch/mips/include/asm/ptemap.h     |   22 ++++++++++++++++++
 3 files changed, 24 insertions(+), 14 deletions(-)

diff -puN arch/mips/include/asm/pgtable-32.h~mips-ptemaph arch/mips/include/asm/pgtable-32.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-32.h~mips-ptemaph	2009-04-30 15:10:58.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h	2009-04-30 15:10:58.000000000 -0700
@@ -151,13 +151,7 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
 #define pte_offset_kernel(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-
-#define pte_offset_map(dir, address)                                    \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)                             \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
+#include <asm/ptemap.h>
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
diff -puN arch/mips/include/asm/pgtable-64.h~mips-ptemaph arch/mips/include/asm/pgtable-64.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-64.h~mips-ptemaph	2009-04-30 15:10:58.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h	2009-04-30 15:10:58.000000000 -0700
@@ -215,13 +215,7 @@ static inline pmd_t *pmd_offset(pud_t * 
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
 #define pte_offset_kernel(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
-
+#include <asm/ptemap.h>
 /*
  * Initialize a new pgd / pmd table with invalid pointers.
  */
diff -puN /dev/null arch/mips/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/ptemap.h	2009-04-30 15:10:58.000000000 -0700
@@ -0,0 +1,22 @@
+#ifndef _MIPS_ASM_PTEMAP_H
+#define _MIPS_ASM_PTEMAP_H
+
+#ifdef CONFIG_32BIT
+#define pte_offset_map(dir, address)                                    \
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)                             \
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+#endif
+
+#ifdef CONFIG_64BIT
+#define pte_offset_map(dir, address)					\
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)				\
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+#endif
+
+#endif /* _MIPS_ASM_PTEMAP_H */
_
