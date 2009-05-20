Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZETS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZETS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZETSZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36914 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbZETSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:09 -0400
Subject: [RFC v2][PATCH 11/35] mips: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:02 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182502.17360A9A@kernel>
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
