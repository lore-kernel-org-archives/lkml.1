Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbYBBJDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbYBBJDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYBBJBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:34 -0500
Received: from gw.goop.org ([64.81.55.164]:59464 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214AbYBBJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 5] x86/pgtable.h: demacro ptep_clear_flush_young
X-Mercurial-Node: 07a2f3594d4314c798b552e219f96dfe8bea6622
Message-Id: <07a2f3594d4314c798b5.1201908328@localhost>
In-Reply-To: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgtable.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -324,14 +324,15 @@
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define ptep_clear_flush_young(vma, address, ptep)			\
-({									\
-	int __young;							\
-	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young)							\
-		flush_tlb_page(vma, address);				\
-	__young;							\
-})
+static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
+					 unsigned long address, pte_t *ptep)
+{
+	int young;
+	young = ptep_test_and_clear_young(vma, address, ptep);
+	if (young)
+		flush_tlb_page(vma, address);
+	return young;
+}
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)


