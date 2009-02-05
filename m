Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZBETfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZBETfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759729AbZBETcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:25 -0500
Received: from gw.goop.org ([64.81.55.164]:40054 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653AbZBETcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 36] x86: unify pmd_present
X-Mercurial-Node: 9124edefaa2775b447abb9bf76d9a2b5bb7b212d
Message-Id: <9124edefaa2775b447ab.1233862250@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_32.h |    1 -
 arch/x86/include/asm/pgtable_64.h |    1 -
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -483,6 +483,11 @@
 	return pte_flags(pte) & _PAGE_HIDDEN;
 }
 
+static inline int pmd_present(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_PRESENT;
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -87,7 +87,6 @@
 
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
-#define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
 #define pmd_bad(x) ((pmd_val(x) & (PTE_FLAGS_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -207,7 +207,6 @@
 #define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
 				  pmd_index(address))
 #define pmd_none(x)	(!pmd_val((x)))
-#define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
 #define pfn_pmd(nr, prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val((prot))))
 #define pmd_pfn(x)  ((pmd_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 


