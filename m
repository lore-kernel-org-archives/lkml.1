Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbZBETl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbZBETl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760062AbZBETci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:38 -0500
Received: from gw.goop.org ([64.81.55.164]:40046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 33 of 36] x86: unify io_remap_pfn_range
X-Mercurial-Node: 860cbec2a0467ec205acd0b08e9b6b8cdeead74b
Message-Id: <860cbec2a0467ec205ac.1233862275@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify io_remap_pfn_range.  Don't demacro yet.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    3 +++
 arch/x86/include/asm/pgtable_32.h |    3 ---
 arch/x86/include/asm/pgtable_64.h |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -562,6 +562,9 @@
 	return npg >> (20 - PAGE_SHIFT);
 }
 
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -133,7 +133,4 @@
 #define kern_addr_valid(kaddr)	(0)
 #endif
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
-	remap_pfn_range(vma, vaddr, pfn, size, prot)
-
 #endif /* _ASM_X86_PGTABLE_32_H */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -204,9 +204,6 @@
 extern int kern_addr_valid(unsigned long addr);
 extern void cleanup_highmap(void);
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
-	remap_pfn_range(vma, vaddr, pfn, size, prot)
-
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 


