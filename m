Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbZBETd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbZBETd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZBETcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:19 -0500
Received: from gw.goop.org ([64.81.55.164]:40046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbZBETcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:18 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 36] x86: unify pte_same
X-Mercurial-Node: 52c651df2b00c653c469e0435811cee45e9f0898
Message-Id: <52c651df2b00c653c469.1233862244@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_same.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    6 ------
 arch/x86/include/asm/pgtable.h        |    6 ++++++
 arch/x86/include/asm/pgtable_64.h     |    2 --
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -145,12 +145,6 @@
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-#define __HAVE_ARCH_PTE_SAME
-static inline int pte_same(pte_t a, pte_t b)
-{
-	return a.pte_low == b.pte_low && a.pte_high == b.pte_high;
-}
-
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -462,6 +462,12 @@
 	return !pte.pte;
 }
 
+#define __HAVE_ARCH_PTE_SAME
+static inline int pte_same(pte_t a, pte_t b)
+{
+	return a.pte == b.pte;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -133,8 +133,6 @@
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
-#define pte_same(a, b)		((a).pte == (b).pte)
-
 #endif /* !__ASSEMBLY__ */
 
 #define PMD_SIZE	(_AC(1, UL) << PMD_SHIFT)


