Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbZBETgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbZBETgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbZBETcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:21 -0500
Received: from gw.goop.org ([64.81.55.164]:40046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbZBETcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:19 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 36] x86: unify pte_hidden
X-Mercurial-Node: fc68b287e3a257f621aa2d222283de134a689e7a
Message-Id: <fc68b287e3a257f621aa.1233862247@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_hidden.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_32.h |    6 ------
 arch/x86/include/asm/pgtable_64.h |    6 ------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -478,6 +478,11 @@
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
+static inline int pte_hidden(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_HIDDEN;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -85,12 +85,6 @@
 /* The boot page tables (all created as a single array) */
 extern unsigned long pg0[];
 
-#ifdef CONFIG_KMEMCHECK
-#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
-#else
-#define pte_hidden(x)	0
-#endif
-
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -168,12 +168,6 @@
 	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
-#ifdef CONFIG_KMEMCHECK
-#define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
-#else
-#define pte_hidden(x)	0
-#endif
-
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 
 /*


