Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZBETdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZBETdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbZBETcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:20 -0500
Received: from gw.goop.org ([64.81.55.164]:40049 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbZBETcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:18 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 36] x86: unify pte_present
X-Mercurial-Node: 9cc87fb04aa8d6b1a8ce0c67b14a17a6471696a0
Message-Id: <9cc87fb04aa8d6b1a8ce.1233862245@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_32.h |    2 --
 arch/x86/include/asm/pgtable_64.h |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -468,6 +468,11 @@
 	return a.pte == b.pte;
 }
 
+static inline int pte_present(pte_t a)
+{
+	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -85,8 +85,6 @@
 /* The boot page tables (all created as a single array) */
 extern unsigned long pg0[];
 
-#define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
-
 #ifdef CONFIG_KMEMCHECK
 #define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
 #else
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -168,8 +168,6 @@
 	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
-#define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-
 #ifdef CONFIG_KMEMCHECK
 #define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
 #else


