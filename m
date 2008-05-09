Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYEILLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYEILLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYEILJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:37 -0400
Received: from gw.goop.org ([64.81.55.164]:47576 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 8] x86: clarify use of _PAGE_CHG_MASK
X-Mercurial-Node: 80abf25ee0302f43c89ed4cb0175419fec39b373
Message-Id: <80abf25ee0302f43c89e.1210330964@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:44 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_CHG_MASK is defined as the set of bits not updated by
pte_modify(); specifically, the pfn itself, and the Accessed and Dirty
bits (which are updated by hardware).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -58,6 +58,7 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
+/* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
@@ -285,11 +286,8 @@
 {
 	pteval_t val = pte_val(pte);
 
-	/*
-	 * Chop off the NX bit (if present), and add the NX portion of
-	 * the newprot (if present):
-	 */
-	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
+	/* Extract unchanged bits from pte */
+	val &= _PAGE_CHG_MASK;
 	val |= pgprot_val(newprot) & __supported_pte_mask;
 
 	return __pte(val);


