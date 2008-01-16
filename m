Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYAPWSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYAPWSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAPWPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:14 -0500
Received: from ns2.suse.de ([195.135.220.15]:38240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAPWPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:10 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [10/36] Add pte_pgprot on i386
Message-Id: <20080116221509.041FB150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit already had it.

Needed for later patches.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/pgtable.h    |    2 ++
 include/asm-x86/pgtable_64.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -191,6 +191,8 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
+#define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -120,8 +120,6 @@ static inline void native_pgd_clear(pgd_
 
 #define pte_same(a, b)		((a).pte == (b).pte)
 
-#define pte_pgprot(a)	(__pgprot((a).pte & ~PHYSICAL_PAGE_MASK))
-
 #endif /* !__ASSEMBLY__ */
 
 #define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
