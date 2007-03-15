Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXCOFR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXCOFR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXCOFRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:50 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45111 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271AbXCOFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:53 -0400
Message-Id: <20070315051529.277974230@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 01/20] early_printk.c switch
Content-Disposition: inline; filename=00-early_printk.patch-update
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the early_printk.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 4ae3dcf..a57040d 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -35,7 +35,6 @@ obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 
diff --git a/arch/i386/kernel/early_printk.c b/arch/i386/kernel/early_printk.c
deleted file mode 100644
index 92f812b..0000000
--- a/arch/i386/kernel/early_printk.c
+++ /dev/null
@@ -1,2 +0,0 @@
-
-#include "../../x86_64/kernel/early_printk.c"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
new file mode 100644
index 0000000..55f268f
--- /dev/null
+++ b/arch/x86/kernel/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/x86_64/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
similarity index 100%
rename from arch/x86_64/kernel/early_printk.c
rename to arch/x86/kernel/early_printk.c
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 2941a91..3cf9198 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -79,6 +79,7 @@ head-y := arch/x86_64/kernel/head.o arch/x86_64/kernel/head64.o arch/x86_64/kern
 
 libs-y 					+= arch/x86_64/lib/
 core-y					+= arch/x86_64/kernel/ \
+					   arch/x86/kernel/ \
 					   arch/x86_64/mm/ \
 					   arch/x86_64/crypto/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index bb47e86..8b2535c 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= suspend_asm.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index bd28f9f..d73a830 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -100,6 +100,7 @@ head-y := arch/i386/kernel/head.o arch/i386/kernel/init_task.o
 
 libs-y 					+= arch/i386/lib/
 core-y					+= arch/i386/kernel/ \
+					   arch/x86/kernel/ \
 					   arch/i386/mm/ \
 					   arch/i386/$(mcore-y)/ \
 					   arch/i386/crypto/

--
