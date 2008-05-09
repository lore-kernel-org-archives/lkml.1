Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbYEILMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbYEILMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYEILJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:38 -0400
Received: from gw.goop.org ([64.81.55.164]:47577 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 8] x86: use PTE_MASK rather than ad-hoc mask
X-Mercurial-Node: d7b47c83ea4a433bbbe2ed7be4ab443e7f47e53d
Message-Id: <d7b47c83ea4a433bbbe2.1210330965@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:45 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ~PTE_MASK to extract the non-pfn parts of the pte (ie, the pte
flags), rather than constructing an ad-hoc mask.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -293,7 +293,7 @@
 	return __pte(val);
 }
 
-#define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
+#define pte_pgprot(x) __pgprot(pte_val(x) & ~PTE_MASK)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 


