Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbZBEThz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbZBEThz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbZBETca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:30 -0500
Received: from gw.goop.org ([64.81.55.164]:40059 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 36] x86: unify pud_index
X-Mercurial-Node: 997d143cbeb1fb6719e8674f9f96cd51ac8ec9a6
Message-Id: <997d143cbeb1fb6719e8.1233862257@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_index.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    6 ++++++
 arch/x86/include/asm/pgtable_64.h |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -538,6 +538,12 @@
 {
 	return pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT);
 }
+
+/* to find an entry in a page-table-directory. */
+static inline unsigned pud_index(unsigned long address)
+{
+	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
+}
 #endif	/* PAGETABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -182,8 +182,6 @@
 #define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)
 
 /* PUD - Level3 access */
-/* to find an entry in a page-table-directory. */
-#define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 #define pud_offset(pgd, address)					\
 	((pud_t *)pgd_page_vaddr(*(pgd)) + pud_index((address)))
 


