Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbZBETfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbZBETfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbZBETc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:26 -0500
Received: from gw.goop.org ([64.81.55.164]:40053 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbZBETcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:19 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 36] x86: unify pud_present
X-Mercurial-Node: 1a2d423b84b3857d1772df986f6418408e8155b0
Message-Id: <1a2d423b84b3857d1772.1233862248@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    5 -----
 arch/x86/include/asm/pgtable.h        |    7 +++++++
 arch/x86/include/asm/pgtable_64.h     |    1 -
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -28,11 +28,6 @@
 	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 
-static inline int pud_present(pud_t pud)
-{
-	return pud_val(pud) & _PAGE_PRESENT;
-}
-
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -483,6 +483,13 @@
 	return pte_flags(pte) & _PAGE_HIDDEN;
 }
 
+#if PAGETABLE_LEVELS > 2
+static inline int pud_present(pud_t pud)
+{
+	return pud_val(pud) & _PAGE_PRESENT;
+}
+#endif	/* PAGETABLE_LEVELS > 2 */
+
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -193,7 +193,6 @@
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 #define pud_offset(pgd, address)					\
 	((pud_t *)pgd_page_vaddr(*(pgd)) + pud_index((address)))
-#define pud_present(pud) (pud_val((pud)) & _PAGE_PRESENT)
 
 static inline int pud_large(pud_t pte)
 {


