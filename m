Return-Path: <linux-kernel-owner+w=401wt.eu-S1422880AbXBANxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422880AbXBANxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422884AbXBANxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:53:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888AbXBANxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:53:05 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] uml-i386: fix build breakage with CONFIG_HIGHMEM
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1HCcN6-0007T7-0K@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:53:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


missing helper used by arch/i386/mm/highmem.c, which is pulled
into build on that configuration.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-um/pgtable.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/asm-um/pgtable.h b/include/asm-um/pgtable.h
index 188f726..e57ff13 100644
--- a/include/asm-um/pgtable.h
+++ b/include/asm-um/pgtable.h
@@ -408,6 +408,15 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 
 #include <asm-generic/pgtable-nopud.h>
 
+#ifdef CONFIG_HIGHMEM
+/* Clear a kernel PTE and flush it from the TLB */
+#define kpte_clear_flush(ptep, vaddr)					\
+do {									\
+	pte_clear(&init_mm, vaddr, ptep);				\
+	__flush_tlb_one(vaddr);						\
+} while (0)
+#endif
+
 #endif
 #endif
 
-- 
1.5.0-rc2.GIT

