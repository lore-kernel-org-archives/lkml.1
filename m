Return-Path: <linux-kernel-owner+w=401wt.eu-S965238AbXCOFSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238AbXCOFSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXCOFRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:45 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45146 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320AbXCOFRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:01 -0400
Message-Id: <20070315051532.400874263@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 16/20] acpi files switched
Content-Disposition: inline; filename=17-acpi.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the shared files that were in arch/i386/kernel/acpi to the common
area.

Note, there still exists files in both archs in acpi. Since there's code
there that is unique to the arch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/acpi/Makefile b/arch/i386/kernel/acpi/Makefile
index 7f7be01..3de22c2 100644
--- a/arch/i386/kernel/acpi/Makefile
+++ b/arch/i386/kernel/acpi/Makefile
@@ -1,10 +1,5 @@
-obj-$(CONFIG_ACPI)		+= boot.o
 ifneq ($(CONFIG_PCI),)
 obj-$(CONFIG_X86_IO_APIC)	+= earlyquirk.o
 endif
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
-ifneq ($(CONFIG_ACPI_PROCESSOR),)
-obj-y				+= cstate.o processor.o
-endif
-
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c1a2b58..1167962 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,6 +1,7 @@
 obj-y				+= bootflag.o quirks.o i8237.o topology.o alternative.o
 
 obj-y				+= cpu/
+obj-$(CONFIG_ACPI)		+= acpi/
 
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
new file mode 100644
index 0000000..3aa3d16
--- /dev/null
+++ b/arch/x86/kernel/acpi/Makefile
@@ -0,0 +1,5 @@
+obj-y				+= boot.o
+
+ifneq ($(CONFIG_ACPI_PROCESSOR),)
+obj-y		+= processor.o cstate.o
+endif
diff --git a/arch/i386/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
similarity index 100%
rename from arch/i386/kernel/acpi/boot.c
rename to arch/x86/kernel/acpi/boot.c
diff --git a/arch/i386/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
similarity index 100%
rename from arch/i386/kernel/acpi/cstate.c
rename to arch/x86/kernel/acpi/cstate.c
diff --git a/arch/i386/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
similarity index 100%
rename from arch/i386/kernel/acpi/processor.c
rename to arch/x86/kernel/acpi/processor.c
diff --git a/arch/x86_64/kernel/acpi/Makefile b/arch/x86_64/kernel/acpi/Makefile
index 080b996..eb4bc11 100644
--- a/arch/x86_64/kernel/acpi/Makefile
+++ b/arch/x86_64/kernel/acpi/Makefile
@@ -1,9 +1,2 @@
-obj-y			:= boot.o
-boot-y			:= ../../../i386/kernel/acpi/boot.o
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
-ifneq ($(CONFIG_ACPI_PROCESSOR),)
-obj-y			+= processor.o
-processor-y		:= ../../../i386/kernel/acpi/processor.o ../../../i386/kernel/acpi/cstate.o
-endif
-

--
