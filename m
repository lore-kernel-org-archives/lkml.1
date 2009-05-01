Return-Path: <linux-kernel-owner+w=401wt.eu-S1764555AbZEAOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764555AbZEAOta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZEAOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36891 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbZEAOmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:32 -0400
Subject: [RFC][PATCH 16/35] sh: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:26 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144226.36C5E44D@kernel>
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
