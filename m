Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXEGBJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXEGBJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXEGBJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:09:43 -0400
Received: from ozlabs.org ([203.10.76.45]:48481 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXEGBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:09:41 -0400
Subject: [PATCH 1/3] lguest: 2.6.21-mm1 update:
	lguest-remove-unnecessary-gdt-load.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:09:28 +1000
Message-Id: <1178500168.7731.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew did a great job of merging in the PDA->percpu changes and
lguest code for 2.6.21-mm1, but the load_gdt is now unnecessary.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |    4 ----
 1 file changed, 4 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -409,9 +409,6 @@ static unsigned lguest_patch(u8 type, u1
 	memcpy(insns, lguest_insns[type].start, insn_len);
 	return insn_len;
 }
-
-/* From head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
 
 __init void lguest_init(void)
 {
@@ -468,7 +465,6 @@ __init void lguest_init(void)
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
 
-	load_gdt(&early_gdt_descr);
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
 	reserve_top_address(lguest_data.reserve_mem);


