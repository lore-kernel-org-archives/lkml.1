Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZBETgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZBETgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbZBETc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:27 -0500
Received: from gw.goop.org ([64.81.55.164]:40055 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 36] x86: unify pgd_page_vaddr
X-Mercurial-Node: 7c571e5e9ae67a096f046792514e490871b3a633
Message-Id: <7c571e5e9ae67a096f04.1233862252@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pgd_page_vaddr.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -507,6 +507,11 @@
 {
 	return pgd_val(pgd) & _PAGE_PRESENT;
 }
+
+static inline unsigned long pgd_page_vaddr(pgd_t pgd)
+{
+	return (unsigned long)__va((unsigned long)pgd_val(pgd) & PTE_PFN_MASK);
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -178,8 +178,6 @@
 /*
  * Level 4 access.
  */
-#define pgd_page_vaddr(pgd)						\
-	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_PFN_MASK))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
 static inline int pgd_large(pgd_t pgd) { return 0; }
 #define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)


