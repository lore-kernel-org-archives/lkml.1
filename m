Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbYA2FIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbYA2FIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYA2FGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:36 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34415 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYA2FGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:34 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/9] Add pgtable accessor functions for GB pages
Message-Id: <20080129050632.A9E611B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:32 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:16.0346 (UTC) FILETIME=[D69BFBA0:01C86233]
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
