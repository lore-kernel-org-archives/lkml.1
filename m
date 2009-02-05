Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbZBETpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbZBETpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbZBETcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:45 -0500
Received: from gw.goop.org ([64.81.55.164]:40053 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 36] x86: unify pmd_index
X-Mercurial-Node: 64022574a9d7d2160551e51f44912a0fea8b6ddb
Message-Id: <64022574a9d7d2160551.1233862261@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_index.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |   11 +++++++++++
 arch/x86/include/asm/pgtable_32.h |    9 ---------
 arch/x86/include/asm/pgtable_64.h |    1 -
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -516,6 +516,17 @@
 	return pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT);
 }
 
+/*
+ * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
+ *
+ * this macro returns the index of the entry in the pmd page which would
+ * control the given virtual address
+ */
+static inline unsigned pmd_index(unsigned long address)
+{
+	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -105,15 +105,6 @@
 static inline int pud_large(pud_t pud) { return 0; }
 
 /*
- * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
- *
- * this macro returns the index of the entry in the pmd page which would
- * control the given virtual address
- */
-#define pmd_index(address)				\
-	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
-
-/*
  * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
  *
  * this macro returns the index of the entry in the pte page which would
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -190,7 +190,6 @@
 }
 
 /* PMD  - Level 2 access */
-#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 #define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
 				  pmd_index(address))
 #define pfn_pmd(nr, prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val((prot))))


