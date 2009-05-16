Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZEPAbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZEPAbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 20:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZEPAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 20:30:53 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48393 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZEPAaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 20:30:52 -0400
Date: Sat, 16 May 2009 06:00:43 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 09/12] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090516003043.GJ16792@in.ibm.com>
References: <20090515105133.629980476@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_kexec_09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables Hardware breakpoints before doing a 'kexec' on the machine.

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
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

