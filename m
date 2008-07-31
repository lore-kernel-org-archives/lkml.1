Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYGaPsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYGaPsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYGaPr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:47:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37850 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYGaPr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:47:56 -0400
Message-Id: <4891FAEF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 31 Jul 2008 16:48:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix overlap of modules and fixmap areas
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plus add a build time check so this doesn't go unnoticed again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/head64.c     |    1 +
 include/asm-x86/pgtable_64.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.27-rc1/arch/x86/kernel/head64.c	2008-07-31 17:31:51.000000000 +0200
+++ 2.6.27-rc1-x86_64-modules-fixmap/arch/x86/kernel/head64.c	2008-07-31 15:55:01.000000000 +0200
@@ -88,6 +88,7 @@ void __init x86_64_start_kernel(char * r
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
--- linux-2.6.27-rc1/include/asm-x86/pgtable_64.h	2008-07-31 17:32:19.000000000 +0200
+++ 2.6.27-rc1-x86_64-modules-fixmap/include/asm-x86/pgtable_64.h	2008-07-31 15:50:44.000000000 +0200
@@ -151,7 +151,7 @@ static inline void native_pgd_clear(pgd_
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
-#define MODULES_END      _AC(0xfffffffffff00000, UL)
+#define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #ifndef __ASSEMBLY__



