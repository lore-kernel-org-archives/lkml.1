Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYEILML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYEILML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYEILJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:37 -0400
Received: from gw.goop.org ([64.81.55.164]:47578 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] xen: use PTE_MASK in pte_mfn()
X-Mercurial-Node: 082f5a7e3ebb1f42880eb12025a655c47b265b80
Message-Id: <082f5a7e3ebb1f42880e.1210330966@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTE_MASK to extract mfn from pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -127,7 +127,7 @@
 
 static inline unsigned long pte_mfn(pte_t pte)
 {
-	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
+	return (pte.pte & PTE_MASK) >> PAGE_SHIFT;
 }
 
 static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)


