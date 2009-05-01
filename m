Return-Path: <linux-kernel-owner+w=401wt.eu-S1763819AbZEAOoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763819AbZEAOoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZEAOmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36757 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZEAOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:12 -0400
Subject: [RFC][PATCH 06/35] cris: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:10 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144210.82088247@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/cris/include/asm/pgtable.h |    7 +------
 linux-2.6.git-dave/arch/cris/include/asm/ptemap.h  |   11 +++++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/cris/include/asm/pgtable.h~cris-ptemaph arch/cris/include/asm/pgtable.h
--- linux-2.6.git/arch/cris/include/asm/pgtable.h~cris-ptemaph	2009-04-30 15:10:56.000000000 -0700
+++ linux-2.6.git-dave/arch/cris/include/asm/pgtable.h	2009-04-30 15:10:56.000000000 -0700
@@ -244,12 +244,7 @@ static inline pgd_t * pgd_offset(const s
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) +  __pte_offset(address))
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
-
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
+#include <asm/ptemap.h>
 #define pte_pfn(x)		((unsigned long)(__va((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -puN arch/cris/include/asm/ptemap.h~cris-ptemaph arch/cris/include/asm/ptemap.h
--- linux-2.6.git/arch/cris/include/asm/ptemap.h~cris-ptemaph	2009-04-30 15:10:56.000000000 -0700
+++ linux-2.6.git-dave/arch/cris/include/asm/ptemap.h	2009-04-30 15:10:56.000000000 -0700
@@ -0,0 +1,11 @@
+#ifndef _CRIS_ASM_PTEMAP_H
+#define _CRIS_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address) \
+	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+
+#endif /* _CRIS_ASM_PTEMAP_H */
_
