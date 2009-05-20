Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZETS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZETS07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZETSZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59025 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbZETSZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:00 -0400
Subject: [RFC v2][PATCH 09/35] m32r: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:24:59 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182459.32EECE8F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/m32r/include/asm/pgtable.h |    6 +-----
 linux-2.6.git-dave/arch/m32r/include/asm/ptemap.h  |   10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN arch/m32r/include/asm/pgtable.h~m32r-ptemaph arch/m32r/include/asm/pgtable.h
--- linux-2.6.git/arch/m32r/include/asm/pgtable.h~m32r-ptemaph	2009-04-30 15:10:57.000000000 -0700
+++ linux-2.6.git-dave/arch/m32r/include/asm/pgtable.h	2009-04-30 15:10:57.000000000 -0700
@@ -330,11 +330,7 @@ static inline void pmd_set(pmd_t * pmdp,
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address)	\
 	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)	\
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address)	pte_offset_map(dir, address)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
+#include <asm/ptemap.h>
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
diff -puN arch/m32r/include/asm/ptemap.h~m32r-ptemaph arch/m32r/include/asm/ptemap.h
--- linux-2.6.git/arch/m32r/include/asm/ptemap.h~m32r-ptemaph	2009-04-30 15:10:57.000000000 -0700
+++ linux-2.6.git-dave/arch/m32r/include/asm/ptemap.h	2009-04-30 15:10:57.000000000 -0700
@@ -0,0 +1,10 @@
+#ifndef _M32R_ASM_PTEMAP_H
+#define _M32R_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address)	\
+	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
+#define pte_offset_map_nested(dir, address)	pte_offset_map(dir, address)
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#endif /* _M32R_ASM_PTEMAP_H */
_
