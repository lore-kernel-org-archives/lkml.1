Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXDLQeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXDLQeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXDLQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:33:27 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50718 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXDLQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:33:24 -0400
Date: Thu, 12 Apr 2007 12:28:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 4/6 ] UML - Remove debugging remnants
Message-ID: <20070412162803.GA7245@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I accidentally left the remnants of some debugging in an earlier patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/tlb.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tlb.c	2007-04-12 11:34:40.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tlb.c	2007-04-12 11:46:27.000000000 -0400
@@ -235,9 +235,7 @@ void fix_range_common(struct mm_struct *
 	unsigned long addr = start_addr, next;
 	int ret = 0, last_op = ARRAY_SIZE(ops) - 1, op_index = -1;
 	void *flush = NULL;
-	unsigned long long start_time, end_time;
 
-	start_time = os_nsecs();
 	ops[0].type = NONE;
 	pgd = pgd_offset(mm, addr);
 	do {
@@ -254,7 +252,6 @@ void fix_range_common(struct mm_struct *
 					    &op_index, force, mmu, &flush,
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
-	end_time = os_nsecs();
 
 	if(!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
