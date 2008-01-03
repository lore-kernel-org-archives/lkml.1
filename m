Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYACPZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYACPZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYACPYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:43013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYACPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:20 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [5/28] Add pte_pgprot on i386
Message-Id: <20080103152419.4A07414E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:19 +0100 (CET)
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
@@ -76,6 +76,8 @@ static inline int pte_exec_kernel(pte_t 
 #define pgoff_to_pte(off) \
 	((pte_t) { (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
 
+#define pte_pgprot(x) __pgprot((x).pte_low & 0xfff)
+
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
Index: linux/include/asm-x86/pgtable-3level.h
===================================================================
--- linux.orig/include/asm-x86/pgtable-3level.h
+++ linux/include/asm-x86/pgtable-3level.h
@@ -172,6 +172,8 @@ static inline pmd_t pfn_pmd(unsigned lon
 		      pgprot_val(pgprot)) & __supported_pte_mask);
 }
 
+#define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
+
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
