Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbXD2NfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbXD2NfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbXD2NfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:35:25 -0400
Received: from ozlabs.org ([203.10.76.45]:47834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbXD2NfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:35:24 -0400
Subject: [PATCH 1/2] lguest: fix up after pda->percpu conversion
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 23:34:57 +1000
Message-Id: <1177853697.30071.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton commented out some stuff to make lguest compile.  This
should actually make it work (in the latest -mm).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -34,7 +34,6 @@
 #include <asm/desc.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
-//#include <asm/pda.h>
 #include <asm/mce.h>
 
 /* Declarations for definitions in lguest_guest.S */
@@ -406,10 +409,6 @@ static unsigned lguest_patch(u8 type, u1
 	memcpy(insns, lguest_insns[type].start, insn_len);
 	return insn_len;
 }
-
-/* From head.S */
-//extern void setup_pda(void);
-extern struct Xgt_desc_struct early_gdt_descr;
 
 __init void lguest_init(void)
 {
@@ -466,10 +465,8 @@ __init void lguest_init(void)
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
 
-	/* set up PDA descriptor */
-//	setup_pda();
-	load_gdt(&early_gdt_descr);
-//	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
+	/* Set up per-cpu descriptor (pointing to master area) */
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
 	reserve_top_address(lguest_data.reserve_mem);
 


