Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbZBETgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbZBETgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759783AbZBETc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:28 -0500
Received: from gw.goop.org ([64.81.55.164]:40052 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 36] x86: unify pud_page
X-Mercurial-Node: 950c59f445771a7a67e2646d502674a29ad5d431
Message-Id: <950c59f445771a7a67e2.1233862255@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_page.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    2 --
 arch/x86/include/asm/pgtable.h        |    6 ++++++
 arch/x86/include/asm/pgtable_64.h     |    1 -
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -115,8 +115,6 @@
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
-
 /* Find an entry in the second-level page table.. */
 #define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
 				  pmd_index(address))
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -471,6 +471,7 @@
 #endif
 
 #ifndef __ASSEMBLY__
+#include <linux/mm_types.h>
 
 static inline int pte_none(pte_t pte)
 {
@@ -515,6 +516,11 @@
 {
 	return (unsigned long)__va((unsigned long)pud_val(pud) & PTE_PFN_MASK);
 }
+
+static inline struct page *pud_page(pud_t pud)
+{
+	return pfn_to_page(pud_val(pud) >> PAGE_SHIFT);
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -184,7 +184,6 @@
 
 /* PUD - Level3 access */
 /* to find an entry in a page-table-directory. */
-#define pud_page(pud)	(pfn_to_page(pud_val((pud)) >> PAGE_SHIFT))
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 #define pud_offset(pgd, address)					\
 	((pud_t *)pgd_page_vaddr(*(pgd)) + pud_index((address)))


