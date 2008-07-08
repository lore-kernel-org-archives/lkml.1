Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYGHKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYGHKVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYGHKVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:21:23 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:33157 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbYGHKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:21:22 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, npiggin@suse.de,
       hugh@veritas.com
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 08 Jul 2008 12:20:40 +0200
Message-Id: <1215512440.22478.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 include/asm-s390/pgtable.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

Nick Piggin (1):
      [S390] protect _PAGE_SPECIAL bit against mprotect

diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index c7f4f8e..bd0ea19 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -223,6 +223,9 @@ extern char empty_zero_page[PAGE_SIZE];
 #define _PAGE_SPECIAL	0x004		/* SW associated with special page */
 #define __HAVE_ARCH_PTE_SPECIAL
 
+/* Set of bits not changed in pte_modify */
+#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_SPECIAL)
+
 /* Six different types of pages. */
 #define _PAGE_TYPE_EMPTY	0x400
 #define _PAGE_TYPE_NONE		0x401
@@ -681,7 +684,7 @@ static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *pt
  */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	pte_val(pte) &= PAGE_MASK;
+	pte_val(pte) &= _PAGE_CHG_MASK;
 	pte_val(pte) |= pgprot_val(newprot);
 	return pte;
 }


