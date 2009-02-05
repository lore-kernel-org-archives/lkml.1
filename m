Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbZBETo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbZBETo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbZBETco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:44 -0500
Received: from gw.goop.org ([64.81.55.164]:40058 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759405AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 36] x86: unify pgd_page
X-Mercurial-Node: dde0e1d3837b1443207e7f0466222f3e76453f28
Message-Id: <dde0e1d3837b1443207e.1233862256@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pgd_page.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -533,6 +533,11 @@
 {
 	return (unsigned long)__va((unsigned long)pgd_val(pgd) & PTE_PFN_MASK);
 }
+
+static inline struct page *pgd_page(pgd_t pgd)
+{
+	return pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT);
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -178,7 +178,6 @@
 /*
  * Level 4 access.
  */
-#define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
 static inline int pgd_large(pgd_t pgd) { return 0; }
 #define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)
 


