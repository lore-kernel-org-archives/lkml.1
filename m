Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbXDJLHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbXDJLHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXDJLHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:07:41 -0400
Received: from ozlabs.org ([203.10.76.45]:42913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbXDJLHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:07:37 -0400
Subject: [PATCH 3/8] lguest: the asm offsets
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <1176203176.26372.25.camel@localhost.localdomain>
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203130.26372.23.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 21:07:11 +1000
Message-Id: <1176203231.26372.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the structure offsets required by lg.ko's switcher.S.

Unfortunately we don't have infrastructure for private asm-offsets
creation.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/kernel/asm-offsets.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -16,6 +16,10 @@
 #include <asm/thread_info.h>
 #include <asm/elf.h>
 #include <asm/pda.h>
+#ifdef CONFIG_LGUEST_GUEST
+#include <linux/lguest.h>
+#include "../../../drivers/lguest/lg.h"
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -114,4 +118,19 @@ void foo(void)
 	OFFSET(PARAVIRT_iret, paravirt_ops, iret);
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
 #endif
+
+#ifdef CONFIG_LGUEST_GUEST
+	BLANK();
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
+	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
+	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
+	OFFSET(LGUEST_PAGES_host_sp, lguest_pages, state.host_sp);
+	OFFSET(LGUEST_PAGES_guest_gdt_desc, lguest_pages,state.guest_gdt_desc);
+	OFFSET(LGUEST_PAGES_guest_idt_desc, lguest_pages,state.guest_idt_desc);
+	OFFSET(LGUEST_PAGES_guest_gdt, lguest_pages, state.guest_gdt);
+	OFFSET(LGUEST_PAGES_regs_trapnum, lguest_pages, regs.trapnum);
+	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
+	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
+#endif
 }


