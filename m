Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbZBEThI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbZBEThI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbZBETc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:29 -0500
Received: from gw.goop.org ([64.81.55.164]:40049 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 36] x86: unify pud_offset
X-Mercurial-Node: 46ede6eff2be934e287cf4ac677551879d274b14
Message-Id: <46ede6eff2be934e287c.1233862258@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_offset.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_64.h |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -544,6 +544,11 @@
 {
 	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
 }
+
+static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
+{
+	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(address);
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -182,8 +182,6 @@
 #define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)
 
 /* PUD - Level3 access */
-#define pud_offset(pgd, address)					\
-	((pud_t *)pgd_page_vaddr(*(pgd)) + pud_index((address)))
 
 static inline int pud_large(pud_t pte)
 {


