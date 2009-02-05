Return-Path: <linux-kernel-owner+w=401wt.eu-S1762434AbZBETjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434AbZBETjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbZBETce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:34 -0500
Received: from gw.goop.org ([64.81.55.164]:40067 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 36] x86: unify pud_large
X-Mercurial-Node: 7101d21cfbc97946da1df80ccb108709761e1c2e
Message-Id: <7101d21cfbc97946da1d.1233862268@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_large.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    6 ++++++
 arch/x86/include/asm/pgtable_32.h |    2 --
 arch/x86/include/asm/pgtable_64.h |    6 ------
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -578,6 +578,12 @@
 {
 	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
+
+static inline int pud_large(pud_t pud)
+{
+	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+		(_PAGE_PSE | _PAGE_PRESENT);
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -95,8 +95,6 @@
 # include <asm/pgtable-2level.h>
 #endif
 
-static inline int pud_large(pud_t pud) { return 0; }
-
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -183,12 +183,6 @@
 
 /* PUD - Level3 access */
 
-static inline int pud_large(pud_t pte)
-{
-	return (pud_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
-		(_PAGE_PSE | _PAGE_PRESENT);
-}
-
 /* PMD  - Level 2 access */
 #define pte_to_pgoff(pte) ((pte_val((pte)) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
 #define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) |	\


