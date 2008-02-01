Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbYBAJyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbYBAJyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYBAJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:20 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:29292 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYBAJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:19 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/12] Add pgtable accessor functions for GB pages
Message-Id: <20080201095317.3CBD81B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:17 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:46:59.0780 (UTC) FILETIME=[63E4F040:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable_32.h |    2 ++
 include/asm-x86/pgtable_64.h |    6 ++++++
 2 files changed, 8 insertions(+)

Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -199,6 +199,12 @@ static inline unsigned long pmd_bad(pmd_
 #define pud_offset(pgd, address) ((pud_t *) pgd_page_vaddr(*(pgd)) + pud_index(address))
 #define pud_present(pud) (pud_val(pud) & _PAGE_PRESENT)
 
+static inline int pud_large(pud_t pte)
+{
+	return (pud_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
+		(_PAGE_PSE|_PAGE_PRESENT);
+}
+
 /* PMD  - Level 2 access */
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -148,6 +148,8 @@ static inline void clone_pgd_range(pgd_t
  */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
+static inline int pud_large(pud_t pud) { return 0; }
+
 /*
  * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
  *
