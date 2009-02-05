Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZBETqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZBETqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZBETcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:46 -0500
Received: from gw.goop.org ([64.81.55.164]:40056 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 36] x86: unify pud_page_vaddr
X-Mercurial-Node: 54b11a18a01331b01c0028342be9112c28e48d3e
Message-Id: <54b11a18a01331b01c00.1233862253@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_page_vaddr.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    3 ---
 arch/x86/include/asm/pgtable.h        |    5 +++++
 arch/x86/include/asm/pgtable_64.h     |    2 --
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -117,9 +117,6 @@
 
 #define pud_page(pud) pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
 
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
-
-
 /* Find an entry in the second-level page table.. */
 #define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
 				  pmd_index(address))
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -500,6 +500,11 @@
 {
 	return pud_val(pud) & _PAGE_PRESENT;
 }
+
+static inline unsigned long pud_page_vaddr(pud_t pud)
+{
+	return (unsigned long)__va((unsigned long)pud_val(pud) & PTE_PFN_MASK);
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -184,8 +184,6 @@
 
 /* PUD - Level3 access */
 /* to find an entry in a page-table-directory. */
-#define pud_page_vaddr(pud)						\
-	((unsigned long)__va(pud_val((pud)) & PHYSICAL_PAGE_MASK))
 #define pud_page(pud)	(pfn_to_page(pud_val((pud)) >> PAGE_SHIFT))
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 #define pud_offset(pgd, address)					\


