Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZETS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZETS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZETSZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52022 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbZETSZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:10 -0400
Subject: [RFC v2][PATCH 16/35] sh: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:10 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182510.B0551105@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/sh/include/asm/pgtable_32.h |    6 +-----
 linux-2.6.git-dave/arch/sh/include/asm/pgtable_64.h |    5 +----
 linux-2.6.git-dave/arch/sh/include/asm/ptemap.h     |    9 +++++++++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff -puN arch/sh/include/asm/pgtable_32.h~sh-ptemaph arch/sh/include/asm/pgtable_32.h
--- linux-2.6.git/arch/sh/include/asm/pgtable_32.h~sh-ptemaph	2009-04-30 15:11:01.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/pgtable_32.h	2009-04-30 15:11:01.000000000 -0700
@@ -403,11 +403,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_index(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
-
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
+#include <asm/ptemap.h>
 
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
diff -puN arch/sh/include/asm/pgtable_64.h~sh-ptemaph arch/sh/include/asm/pgtable_64.h
--- linux-2.6.git/arch/sh/include/asm/pgtable_64.h~sh-ptemaph	2009-04-30 15:11:01.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/pgtable_64.h	2009-04-30 15:11:01.000000000 -0700
@@ -83,10 +83,7 @@ static __inline__ void pmd_set(pmd_t *pm
 #define pte_offset_kernel(dir, addr) \
 		((pte_t *) ((pmd_val(*(dir))) & PAGE_MASK) + pte_index((addr)))
 
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
+#include <asm/ptemap.h>
 
 #ifndef __ASSEMBLY__
 #define IOBASE_VADDR	0xff000000
diff -puN /dev/null arch/sh/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/ptemap.h	2009-04-30 15:11:01.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _SH_ASM_PTEMAP_H
+#define _SH_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#endif /* _SH_ASM_PTEMAP_H */
_
