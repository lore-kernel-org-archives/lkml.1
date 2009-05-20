Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZETS00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZETS00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZETSYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:24:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44315 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZETSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:24:54 -0400
Subject: [RFC v2][PATCH 04/35] arm: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:24:51 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182451.168A6FC7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/arm/include/asm/pgtable.h |    6 ++----
 linux-2.6.git-dave/arch/arm/include/asm/ptemap.h  |    9 +++++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/arm/include/asm/pgtable.h~arm-ptemaph arch/arm/include/asm/pgtable.h
--- linux-2.6.git/arch/arm/include/asm/pgtable.h~arm-ptemaph	2009-04-30 15:10:54.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/pgtable.h	2009-04-30 15:10:54.000000000 -0700
@@ -264,10 +264,8 @@ extern struct page *empty_zero_page;
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 #define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map_nested(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
+
+#include <asm/ptemap.h>
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
 
diff -puN /dev/null arch/arm/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/ptemap.h	2009-04-30 15:10:54.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _ARM_ASM_PTEMAP_H
+#define _ARM_ASM_PTEMAP_H
+
+#define pte_offset_map(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
+#define pte_offset_map_nested(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#endif /* _ARM_ASM_PTEMAP_H */
_
