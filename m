Return-Path: <linux-kernel-owner+w=401wt.eu-S965346AbXCOFSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbXCOFSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965254AbXCOFRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:44 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45148 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965323AbXCOFRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:01 -0400
Message-Id: <20070315051532.577743158@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 17/20] k8.c switch
Content-Disposition: inline; filename=18-k8.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the k8.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index ce1f742..72e11f7 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
-obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
@@ -78,6 +77,5 @@ $(obj)/vsyscall-syms.o: $(src)/vsyscall.lds \
 			$(obj)/vsyscall-sysenter.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
-k8-y                      += ../../x86_64/kernel/k8.o
 stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 1167962..06c335d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-y				+= pcspeaker.o
 
diff --git a/arch/x86_64/kernel/k8.c b/arch/x86/kernel/k8.c
similarity index 100%
rename from arch/x86_64/kernel/k8.c
rename to arch/x86/kernel/k8.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 3d90462..0510887 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -29,7 +29,6 @@ obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
-obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 
 obj-$(CONFIG_MODULES)		+= module.o

--
