Return-Path: <linux-kernel-owner+w=401wt.eu-S1764541AbZEAOtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764541AbZEAOtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbZEAOme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49155 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbZEAOmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:31 -0400
Subject: [RFC][PATCH 18/35] um: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:29 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144229.734847A7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/um/include/asm/pgtable.h |    7 +------
 linux-2.6.git-dave/arch/um/include/asm/ptemap.h  |   10 ++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN arch/um/include/asm/pgtable.h~um-ptemaph arch/um/include/asm/pgtable.h
--- linux-2.6.git/arch/um/include/asm/pgtable.h~um-ptemaph	2009-04-30 15:11:02.000000000 -0700
+++ linux-2.6.git-dave/arch/um/include/asm/pgtable.h	2009-04-30 15:11:02.000000000 -0700
@@ -331,12 +331,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-
+#include <asm/ptemap.h>
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 
diff -puN arch/um/include/asm/ptemap.h~um-ptemaph arch/um/include/asm/ptemap.h
--- linux-2.6.git/arch/um/include/asm/ptemap.h~um-ptemaph	2009-04-30 15:11:02.000000000 -0700
+++ linux-2.6.git-dave/arch/um/include/asm/ptemap.h	2009-04-30 15:11:02.000000000 -0700
@@ -0,0 +1,10 @@
+#ifndef _UM_ASM_PTEMAP_H
+#define _UM_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address) \
+	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
+#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+
+#endif /* _UM_ASM_PTEMAP_H */
_
