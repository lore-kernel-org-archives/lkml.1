Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbZBETdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbZBETdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZBETcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:19 -0500
Received: from gw.goop.org ([64.81.55.164]:40043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbZBETcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:18 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 36] x86: unify pte_none
X-Mercurial-Node: e6f6ce897b091a265b7d9bfdf082c691120f02af
Message-Id: <e6f6ce897b091a265b7d.1233862243@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_none.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-2level.h |    2 --
 arch/x86/include/asm/pgtable-3level.h |    5 -----
 arch/x86/include/asm/pgtable.h        |    5 +++++
 arch/x86/include/asm/pgtable_64.h     |    1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -53,8 +53,6 @@
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-#define pte_none(x)		(!(x).pte_low)
-
 /*
  * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
  * split up the 29 bits of offset into this range:
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -151,11 +151,6 @@
 	return a.pte_low == b.pte_low && a.pte_high == b.pte_high;
 }
 
-static inline int pte_none(pte_t pte)
-{
-	return !pte.pte_low && !pte.pte_high;
-}
-
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -457,6 +457,11 @@
 }
 #endif	/* CONFIG_PARAVIRT */
 
+static inline int pte_none(pte_t pte)
+{
+	return !pte.pte;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -170,7 +170,6 @@
 	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
-#define pte_none(x)	(!pte_val((x)))
 #define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
 #ifdef CONFIG_KMEMCHECK


