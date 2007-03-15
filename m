Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXCOFVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXCOFVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXCOFRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:32 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45132 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbXCOFQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:59 -0400
Message-Id: <20070315051529.518661228@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 02/20] tsc_sync.c switch
Content-Disposition: inline; filename=02-tsc_sync.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move tsc_sync.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index a57040d..c8fe439 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
+obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
diff --git a/arch/i386/kernel/tsc_sync.c b/arch/i386/kernel/tsc_sync.c
deleted file mode 100644
index 1242462..0000000
--- a/arch/i386/kernel/tsc_sync.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../x86_64/kernel/tsc_sync.c"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 55f268f..bd548e6 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,2 +1,7 @@
 
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+
+# i386 defines CONFIG_X86_SMP when CONFIG_SMP and !CONFIG_X86_VOYAGER
+ifeq ($(CONFIG_X86_VOYAGER), )
+obj-$(CONFIG_SMP)		+= tsc_sync.o
+endif
diff --git a/arch/x86_64/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
similarity index 100%
rename from arch/x86_64/kernel/tsc_sync.c
rename to arch/x86/kernel/tsc_sync.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 8b2535c..54fe500 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
 obj-y				+= apic.o  nmi.o
 obj-y				+= io_apic.o mpparse.o \
 		genapic.o genapic_cluster.o genapic_flat.o

--
