Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZETS1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZETS1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbZETSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47839 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZETSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:08 -0400
Subject: [RFC v2][PATCH 13/35] parisc: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:05 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182505.EA2386EB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that parisc already had two pte_unmap{_unmap}()
#defines. This removes the dup in addition to moving
them.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/parisc/include/asm/pgtable.h |    7 +------
 linux-2.6.git-dave/arch/parisc/include/asm/ptemap.h  |    9 +++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/parisc/include/asm/pgtable.h~parisc-ptemaph arch/parisc/include/asm/pgtable.h
--- linux-2.6.git/arch/parisc/include/asm/pgtable.h~parisc-ptemaph	2009-05-02 14:39:45.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/include/asm/pgtable.h	2009-05-02 14:39:45.000000000 -0700
@@ -396,13 +396,8 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 #define pte_offset_kernel(pmd, address) \
 	((pte_t *) pmd_page_vaddr(*(pmd)) + pte_index(address))
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
+#include <asm/ptemap.h>
 
 extern void paging_init (void);
 
diff -puN /dev/null arch/parisc/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/include/asm/ptemap.h	2009-05-02 14:43:12.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _PARISC_ASM_PTEMAP_H
+#define _PARISC_ASM_PTEMAP_H
+
+#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
+#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+
+#endif /* _PARISC_ASM_PTEMAP_H */
_
