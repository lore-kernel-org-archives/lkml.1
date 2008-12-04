Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYLDTRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYLDTRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYLDTRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:17:25 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54338 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYLDTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:17:23 -0500
Date: Fri, 5 Dec 2008 00:47:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 9/9] Cleanup HW Breakpoint registers before kexec
Message-ID: <20081204191715.GI20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
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

Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/machine_kexec_32.c
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
Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/machine_kexec_64.c
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
