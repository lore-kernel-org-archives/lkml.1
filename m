Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZEKLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZEKLz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZEKLy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:54:27 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49458 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660AbZEKLyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:54:25 -0400
Date: Mon, 11 May 2009 17:24:18 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 09/12] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090511115418.GJ25673@in.ibm.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_kexec_09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch disables Hardware breakpoints before doing a 'kexec' on the machine.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/machine_kexec_32.c |    2 ++
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 2 files changed, 4 insertions(+)

Index: arch/x86/kernel/machine_kexec_32.c
===================================================================
--- arch/x86/kernel/machine_kexec_32.c.orig
+++ arch/x86/kernel/machine_kexec_32.c
@@ -25,6 +25,7 @@
 #include <asm/desc.h>
 #include <asm/system.h>
 #include <asm/cacheflush.h>
+#include <asm/debugreg.h>
 
 static void set_idt(void *newidt, __u16 limit)
 {
@@ -202,6 +203,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	hw_breakpoint_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
Index: arch/x86/kernel/machine_kexec_64.c
===================================================================
--- arch/x86/kernel/machine_kexec_64.c.orig
+++ arch/x86/kernel/machine_kexec_64.c
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/debugreg.h>
 
 static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 				unsigned long addr)
@@ -282,6 +283,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	hw_breakpoint_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC

