Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbZBETqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbZBETqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbZBETcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:45 -0500
Received: from gw.goop.org ([64.81.55.164]:40046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 36] x86: unify pmd_page
X-Mercurial-Node: e1d72165d8a16de4d0af88313fa507ba21f69fc4
Message-Id: <e1d72165d8a16de4d0af.1233862260@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_page.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_32.h |    2 --
 arch/x86/include/asm/pgtable_64.h |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -511,6 +511,11 @@
 	return (unsigned long)__va(pmd_val(pmd) & PTE_PFN_MASK);
 }
 
+static inline struct page *pmd_page(pmd_t pmd)
+{
+	return pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT);
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -124,8 +124,6 @@
 #define pte_offset_kernel(dir, address)				\
 	((pte_t *)pmd_page_vaddr(*(dir)) +  pte_index((address)))
 
-#define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
-
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -190,8 +190,6 @@
 }
 
 /* PMD  - Level 2 access */
-#define pmd_page(pmd)		(pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
-
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 #define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
 				  pmd_index(address))


