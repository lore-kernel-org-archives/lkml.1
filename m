Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYJGLrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYJGLrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYJGLrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:47:07 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58981 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYJGLrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:47:05 -0400
Date: Tue, 7 Oct 2008 17:16:51 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 9/9] Cleanup HW Breakpoint registers before kexec
Message-ID: <20081007114651.GD25875@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113815.GA23523@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables Hardware breakpoints before doing a 'kexec' on the machine.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/machine_kexec_32.c |    2 ++
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/machine_kexec_32.c
@@ -24,6 +24,7 @@
 #include <asm/desc.h>
 #include <asm/system.h>
 #include <asm/cacheflush.h>
+#include <asm/debugreg.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -131,6 +132,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
+#include <asm/debugreg.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u64 kexec_pgd[512] PAGE_ALIGNED;
@@ -190,6 +191,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	control_page = page_address(image->control_code_page) + PAGE_SIZE;
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
