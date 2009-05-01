Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbZEAO6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbZEAO6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763573AbZEAOne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:43:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32813 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762837AbZEAOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:43:31 -0400
Subject: [RFC][PATCH 08/35] ia64: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:13 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144213.9FAE528C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/ia64/include/asm/pgtable.h |    6 ++----
 linux-2.6.git-dave/arch/ia64/include/asm/ptemap.h  |    9 +++++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/ia64/include/asm/pgtable.h~ia64-ptemaph arch/ia64/include/asm/pgtable.h
--- linux-2.6.git/arch/ia64/include/asm/pgtable.h~ia64-ptemaph	2009-04-30 15:10:57.000000000 -0700
+++ linux-2.6.git-dave/arch/ia64/include/asm/pgtable.h	2009-04-30 15:10:57.000000000 -0700
@@ -405,10 +405,8 @@ pgd_offset (const struct mm_struct *mm, 
  */
 #define pte_index(addr)	 	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir,addr)	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_map(dir, addr)
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
+
+#include <asm/ptemap.h>
 
 /* atomic versions of the some PTE manipulations: */
 
diff -puN arch/ia64/include/asm/ptemap.h~ia64-ptemaph arch/ia64/include/asm/ptemap.h
--- linux-2.6.git/arch/ia64/include/asm/ptemap.h~ia64-ptemaph	2009-04-30 15:10:57.000000000 -0700
+++ linux-2.6.git-dave/arch/ia64/include/asm/ptemap.h	2009-04-30 15:10:57.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _IA64_ASM_PTEMAP_H
+#define _IA64_ASM_PTEMAP_H
+
+#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
+#define pte_offset_map_nested(dir,addr)	pte_offset_map(dir, addr)
+#define pte_unmap(pte)			do { } while (0)
+#define pte_unmap_nested(pte)		do { } while (0)
+
+#endif /* _IA64_ASM_PTEMAP_H */
_
