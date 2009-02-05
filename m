Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbZBETni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbZBETni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZBETcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:41 -0500
Received: from gw.goop.org ([64.81.55.164]:40052 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 27 of 36] x86: unify pgd_bad
X-Mercurial-Node: 9090680d4fb74ff7304894f27ac1ec38c2aa81cc
Message-Id: <9090680d4fb74ff73048.1233862269@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pgd_bad.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -612,6 +612,11 @@
 {
 	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(address);
 }
+
+static inline int pgd_bad(pgd_t pgd)
+{
+	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -153,11 +153,6 @@
 
 #ifndef __ASSEMBLY__
 
-static inline int pgd_bad(pgd_t pgd)
-{
-	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
-}
-
 static inline int pud_bad(pud_t pud)
 {
 	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;


