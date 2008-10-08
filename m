Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYJHT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYJHT12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYJHT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:27:15 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:56906 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbYJHT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:27:14 -0400
Date: Thu, 9 Oct 2008 00:57:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 9/9] Cleanup HW Breakpoint registers before kexec
Message-ID: <20081008192700.GI4989@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008192044.GA4510@in.ibm.com>
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
