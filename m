Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYANWSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYANWSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYANWQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:59608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYANWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:37 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [4/31] Add pte_pgprot on i386
Message-Id: <20080114221636.0306F14F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit already had it.

Needed for later patches.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable-2level.h |    2 ++
 include/asm-x86/pgtable-3level.h |    2 ++
 2 files changed, 4 insertions(+)

Index: linux/include/asm-x86/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-x86/pgtable-2level.h
+++ linux/include/asm-x86/pgtable-2level.h
@@ -75,6 +75,8 @@ static inline int pte_exec_kernel(pte_t 
 #define pgoff_to_pte(off) \
 	((pte_t) { .pte_low = (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
 
+#define pte_pgprot(x) __pgprot((x).pte_low & 0xfff)
+
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
Index: linux/include/asm-x86/pgtable-3level.h
===================================================================
--- linux.orig/include/asm-x86/pgtable-3level.h
+++ linux/include/asm-x86/pgtable-3level.h
@@ -142,6 +142,8 @@ static inline unsigned long pte_pfn(pte_
 	return pte_val(pte) >> PAGE_SHIFT;
 }
 
+#define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
+
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
