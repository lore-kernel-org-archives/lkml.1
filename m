Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYEILLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYEILLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYEILJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:36 -0400
Received: from gw.goop.org ([64.81.55.164]:47575 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] x86: use PTE_MASK in pgtable_32.h
X-Mercurial-Node: a2ab59b40561969b7feaf3f730cefe575362be06
Message-Id: <a2ab59b40561969b7fea.1210330963@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/asm-x86/pgtable_32.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -98,9 +98,9 @@
 extern int pmd_bad(pmd_t pmd);
 
 #define pmd_bad_v1(x)							\
-	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER)))
+	(_KERNPG_TABLE != (pmd_val((x)) & ~(PTE_MASK | _PAGE_USER)))
 #define	pmd_bad_v2(x)							\
-	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER |	\
+	(_KERNPG_TABLE != (pmd_val((x)) & ~(PTE_MASK | _PAGE_USER |	\
 					    _PAGE_PSE | _PAGE_NX)))
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
@@ -172,7 +172,7 @@
 #define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_page_vaddr(pmd)					\
-	((unsigned long)__va(pmd_val((pmd)) & PAGE_MASK))
+	((unsigned long)__va(pmd_val((pmd)) & PTE_MASK))
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\


