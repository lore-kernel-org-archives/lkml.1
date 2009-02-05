Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZBETk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZBETk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbZBETcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:36 -0500
Received: from gw.goop.org ([64.81.55.164]:40070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 32 of 36] x86: unify pgd_none
X-Mercurial-Node: 0007c65ca74a5db407834de37cc92778ca0c7612
Message-Id: <0007c65ca74a5db40783.1233862274@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pgd_none.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -637,6 +637,11 @@
 {
 	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
+
+static inline int pgd_none(pgd_t pgd)
+{
+	return !pgd_val(pgd);
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -66,8 +66,6 @@
 	printk("%s:%d: bad pgd %p(%016lx).\n",		\
 	       __FILE__, __LINE__, &(e), pgd_val(e))
 
-#define pgd_none(x)	(!pgd_val(x))
-
 struct mm_struct;
 
 void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte);


