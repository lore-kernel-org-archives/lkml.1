Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZEAOsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZEAOsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZEAOmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36848 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbZEAOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:27 -0400
Subject: [RFC][PATCH 09/35] m32r: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:15 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144215.DCC8DF34@kernel>
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
