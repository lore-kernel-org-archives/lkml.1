Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbXEIJy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbXEIJy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXEIJwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:52:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756412AbXEIJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:52:35 -0400
Message-Id: <200705090951.l499pa6G020397@shell0.pdx.osdl.net>
Subject: [patch 4/9] lguest: the asm offsets
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de
From: akpm@linux-foundation.org
Date: Wed, 09 May 2007 02:51:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This is the structure offsets required by lg.ko's switcher.S.

Unfortunately we don't have infrastructure for private asm-offsets
creation.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets
+++ a/arch/i386/kernel/asm-offsets.c
@@ -17,6 +17,10 @@
 #include <asm/pgtable.h>
 #include <asm/thread_info.h>
 #include <asm/elf.h>
+#ifdef CONFIG_LGUEST_GUEST
+#include <linux/lguest.h>
+#include "../../../drivers/lguest/lg.h"
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -116,4 +120,19 @@ void foo(void)
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
_
