Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbZBETiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbZBETiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbZBETcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:31 -0500
Received: from gw.goop.org ([64.81.55.164]:40062 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 36] x86: unify pmd_pfn
X-Mercurial-Node: e92b7b826663bcd558bae7b761ab02b2a53cd785
Message-Id: <e92b7b826663bcd558ba.1233862264@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_pfn.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -548,6 +548,11 @@
 {
 	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
 }
+
+static inline unsigned long pmd_pfn(pmd_t pmd)
+{
+	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -190,8 +190,6 @@
 }
 
 /* PMD  - Level 2 access */
-#define pmd_pfn(x)  ((pmd_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
-
 #define pte_to_pgoff(pte) ((pte_val((pte)) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
 #define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) |	\
 					    _PAGE_FILE })


