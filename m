Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbZEAOm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbZEAOm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZEAOmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57808 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZEAOmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:04 -0400
Subject: [RFC][PATCH 01/35] rename arm and frv's __pte_index()
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:02 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144202.A869B8B0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The arm and frv __pte_index()es are the exact same as everyone
else's pte_index().  So, remove the __ and give them the same
name as all the other implementations.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/arm/include/asm/pgtable.h |    8 ++++----
 linux-2.6.git-dave/arch/frv/include/asm/pgtable.h |    2 +-
 linux-2.6.git-dave/arch/frv/kernel/gdb-stub.c     |    2 +-
 linux-2.6.git-dave/arch/frv/mm/fault.c            |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/arm/include/asm/pgtable.h~rename-arm-__pte_index arch/arm/include/asm/pgtable.h
--- linux-2.6.git/arch/arm/include/asm/pgtable.h~rename-arm-__pte_index	2009-04-30 15:10:53.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/pgtable.h	2009-04-30 15:10:53.000000000 -0700
@@ -263,9 +263,9 @@ extern struct page *empty_zero_page;
 #define pte_none(pte)		(!pte_val(pte))
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
-#define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
-#define pte_offset_map(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
-#define pte_offset_map_nested(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
+#define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
+#define pte_offset_map(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
+#define pte_offset_map_nested(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
 #define pte_unmap(pte)		do { } while (0)
 #define pte_unmap_nested(pte)	do { } while (0)
 
@@ -373,7 +373,7 @@ static inline pte_t *pmd_page_vaddr(pmd_
 #define pmd_offset(dir, addr)	((pmd_t *)(dir))
 
 /* Find an entry in the third-level page table.. */
-#define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
diff -puN arch/frv/include/asm/pgtable.h~rename-arm-__pte_index arch/frv/include/asm/pgtable.h
--- linux-2.6.git/arch/frv/include/asm/pgtable.h~rename-arm-__pte_index	2009-04-30 15:10:53.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/pgtable.h	2009-04-30 15:10:53.000000000 -0700
@@ -436,7 +436,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pgd_index_k(addr) pgd_index(addr)
 
 /* Find an entry in the bottom-level page table.. */
-#define __pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 
 /*
  * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
diff -puN arch/frv/kernel/gdb-stub.c~rename-arm-__pte_index arch/frv/kernel/gdb-stub.c
--- linux-2.6.git/arch/frv/kernel/gdb-stub.c~rename-arm-__pte_index	2009-04-30 15:10:53.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/kernel/gdb-stub.c	2009-04-30 15:10:53.000000000 -0700
@@ -465,7 +465,7 @@ static inline unsigned long gdbstub_virt
 	__set_DAMPR(5, val | xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C | xAMPRx_V);
 
 	/* now its safe to access pmd */
-	pte = (pte_t *)__get_DAMLR(5) + __pte_index(vaddr);
+	pte = (pte_t *)__get_DAMLR(5) + pte_index(vaddr);
 	if (pte_present(*pte))
 		val = pte_val(*pte);
 	else
diff -puN arch/frv/mm/fault.c~rename-arm-__pte_index arch/frv/mm/fault.c
--- linux-2.6.git/arch/frv/mm/fault.c~rename-arm-__pte_index	2009-04-30 15:10:53.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/mm/fault.c	2009-04-30 15:10:53.000000000 -0700
@@ -240,7 +240,7 @@ asmlinkage void do_page_fault(int datamm
 			     : "r" (_pme | xAMPRx_L|xAMPRx_SS_16Kb|xAMPRx_S|xAMPRx_C|xAMPRx_V)
 			     );
 
-		pte = (pte_t *) damlr + __pte_index(ear0);
+		pte = (pte_t *) damlr + pte_index(ear0);
 		val = pte_val(*pte);
 
 		asm volatile("movgs %0,dampr2" :: "r" (dampr));
_
