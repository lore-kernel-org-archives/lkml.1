Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbZBETnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbZBETnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZBETck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:40 -0500
Received: from gw.goop.org ([64.81.55.164]:40066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 24 of 36] x86: unify pte_index
X-Mercurial-Node: 8eb5744a1ee4648fbdafba71d9fb82f3e60f351a
Message-Id: <8eb5744a1ee4648fbdaf.1233862266@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_index.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |   11 +++++++++++
 arch/x86/include/asm/pgtable_32.h |    8 --------
 arch/x86/include/asm/pgtable_64.h |    1 -
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -536,6 +536,17 @@
  */
 #define mk_pte(page, pgprot)   pfn_pte(page_to_pfn(page), (pgprot))
 
+/*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this function returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+static inline unsigned pte_index(unsigned long address)
+{
+	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -97,14 +97,6 @@
 
 static inline int pud_large(pud_t pud) { return 0; }
 
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this macro returns the index of the entry in the pte page which would
- * control the given virtual address
- */
-#define pte_index(address)					\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address)				\
 	((pte_t *)pmd_page_vaddr(*(dir)) +  pte_index((address)))
 
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -197,7 +197,6 @@
 
 /* PTE - Level 1 access. */
 
-#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \
 					 pte_index((address)))
 


