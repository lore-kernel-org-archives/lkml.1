Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXLMIu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXLMIu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXLMIuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:50:12 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29855
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXLMIuL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:50:11 -0500
Message-Id: <47610086.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 08:51:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: hard_{en,dis}able_TSC can be static
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/process_32.c   |    4 ++--
 include/asm-x86/processor_32.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/process_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-i386-seccomp-tsc-static/arch/x86/kernel/process_32.c	2007-12-04 16:09:33.000000000 +0100
@@ -573,7 +573,7 @@ int dump_task_regs(struct task_struct *t
 }
 
 #ifdef CONFIG_SECCOMP
-void hard_disable_TSC(void)
+static void hard_disable_TSC(void)
 {
 	write_cr4(read_cr4() | X86_CR4_TSD);
 }
@@ -588,7 +588,7 @@ void disable_TSC(void)
 		hard_disable_TSC();
 	preempt_enable();
 }
-void hard_enable_TSC(void)
+static void hard_enable_TSC(void)
 {
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
--- linux-2.6.24-rc5/include/asm-x86/processor_32.h	2007-12-12 11:29:30.000000000 +0100
+++ 2.6.24-rc5-i386-seccomp-tsc-static/include/asm-x86/processor_32.h	2007-12-04 16:09:33.000000000 +0100
@@ -222,9 +222,7 @@ extern int bootloader_type;
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
-extern void hard_disable_TSC(void);
 extern void disable_TSC(void);
-extern void hard_enable_TSC(void);
 
 /*
  * Size of io_bitmap.



