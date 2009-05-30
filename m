Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbZE3KxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbZE3KxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762110AbZE3Kwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:52:54 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39234 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762719AbZE3Kwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:52:53 -0400
Date: Sat, 30 May 2009 16:22:47 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 09/12] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090530105247.GJ9512@in.ibm.com>
References: <20090530103857.715014561@prasadkr_t60p.in.ibm.com>
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

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_32.c
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
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_64.c
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

