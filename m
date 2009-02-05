Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZBETn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZBETn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZBETcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:42 -0500
Received: from gw.goop.org ([64.81.55.164]:40061 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 36] x86: unify pmd_offset
X-Mercurial-Node: 310597cc92a5164e8d682100138a9924eae4023e
Message-Id: <310597cc92a5164e8d68.1233862262@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_offset.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    4 ----
 arch/x86/include/asm/pgtable.h        |    6 ++++++
 arch/x86/include/asm/pgtable_64.h     |    2 --
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -115,10 +115,6 @@
 		write_cr3(pgd);
 }
 
-/* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
-				  pmd_index(address))
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -542,6 +542,12 @@
 {
 	return pfn_to_page(pud_val(pud) >> PAGE_SHIFT);
 }
+
+/* Find an entry in the second-level page table.. */
+static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+{
+	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -190,8 +190,6 @@
 }
 
 /* PMD  - Level 2 access */
-#define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
-				  pmd_index(address))
 #define pfn_pmd(nr, prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val((prot))))
 #define pmd_pfn(x)  ((pmd_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 


