Return-Path: <linux-kernel-owner+w=401wt.eu-S965242AbXCOFWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242AbXCOFWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXCOFR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:29 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:52129 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXCOFQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:58 -0400
Message-Id: <20070315051533.118304092@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 20/20] oprofile files switched
Content-Disposition: inline; filename=21-oprofile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the oprofile files from arch/i386/oprofile to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 53d6237..137c063 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1226,7 +1226,7 @@ source "fs/Kconfig"
 menu "Instrumentation Support"
 	depends on EXPERIMENTAL
 
-source "arch/i386/oprofile/Kconfig"
+source "arch/x86/oprofile/Kconfig"
 
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index 06dd07e..6e537be 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -108,7 +108,7 @@ core-y					+= arch/i386/kernel/ \
 drivers-$(CONFIG_MATH_EMULATION)	+= arch/i386/math-emu/
 drivers-$(CONFIG_PCI)			+= arch/i386/pci/
 # must be linked after kernel/
-drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
+drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
 
 CFLAGS += $(mflags-y)
diff --git a/arch/i386/oprofile/Kconfig b/arch/x86/oprofile/Kconfig
similarity index 100%
rename from arch/i386/oprofile/Kconfig
rename to arch/x86/oprofile/Kconfig
diff --git a/arch/i386/oprofile/Makefile b/arch/x86/oprofile/Makefile
similarity index 100%
rename from arch/i386/oprofile/Makefile
rename to arch/x86/oprofile/Makefile
diff --git a/arch/i386/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
similarity index 100%
rename from arch/i386/oprofile/backtrace.c
rename to arch/x86/oprofile/backtrace.c
diff --git a/arch/i386/oprofile/init.c b/arch/x86/oprofile/init.c
similarity index 100%
rename from arch/i386/oprofile/init.c
rename to arch/x86/oprofile/init.c
diff --git a/arch/i386/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
similarity index 100%
rename from arch/i386/oprofile/nmi_int.c
rename to arch/x86/oprofile/nmi_int.c
diff --git a/arch/i386/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
similarity index 100%
rename from arch/i386/oprofile/nmi_timer_int.c
rename to arch/x86/oprofile/nmi_timer_int.c
diff --git a/arch/i386/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
similarity index 100%
rename from arch/i386/oprofile/op_counter.h
rename to arch/x86/oprofile/op_counter.h
diff --git a/arch/i386/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
similarity index 100%
rename from arch/i386/oprofile/op_model_athlon.c
rename to arch/x86/oprofile/op_model_athlon.c
diff --git a/arch/i386/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
similarity index 100%
rename from arch/i386/oprofile/op_model_p4.c
rename to arch/x86/oprofile/op_model_p4.c
diff --git a/arch/i386/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
similarity index 100%
rename from arch/i386/oprofile/op_model_ppro.c
rename to arch/x86/oprofile/op_model_ppro.c
diff --git a/arch/i386/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
similarity index 100%
rename from arch/i386/oprofile/op_x86_model.h
rename to arch/x86/oprofile/op_x86_model.h
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 56eb14c..12e9fc4 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -738,7 +738,7 @@ source fs/Kconfig
 menu "Instrumentation Support"
         depends on EXPERIMENTAL
 
-source "arch/x86_64/oprofile/Kconfig"
+source "arch/x86/oprofile/Kconfig"
 
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index abf1829..0c7e0fa 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -85,7 +85,7 @@ core-y					+= arch/x86_64/kernel/ \
 					   arch/x86_64/crypto/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86_64/pci/
-drivers-$(CONFIG_OPROFILE)		+= arch/x86_64/oprofile/
+drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
 
 boot := arch/x86_64/boot
 
diff --git a/arch/x86_64/oprofile/Kconfig b/arch/x86_64/oprofile/Kconfig
deleted file mode 100644
index d8a8408..0000000
--- a/arch/x86_64/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff --git a/arch/x86_64/oprofile/Makefile b/arch/x86_64/oprofile/Makefile
deleted file mode 100644
index 6be3268..0000000
--- a/arch/x86_64/oprofile/Makefile
+++ /dev/null
@@ -1,19 +0,0 @@
-#
-# oprofile for x86-64.
-# Just reuse the one from i386. 
-#
-
-obj-$(CONFIG_OPROFILE) += oprofile.o
- 
-DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
-	oprof.o cpu_buffer.o buffer_sync.o \
-	event_buffer.o oprofile_files.o \
-	oprofilefs.o oprofile_stats.o \
-	timer_int.o )
-
-OPROFILE-y := init.o backtrace.o
-OPROFILE-$(CONFIG_X86_LOCAL_APIC) += nmi_int.o op_model_athlon.o op_model_p4.o \
-				     op_model_ppro.o
-OPROFILE-$(CONFIG_X86_IO_APIC)    += nmi_timer_int.o 
-
-oprofile-y = $(DRIVER_OBJS) $(addprefix ../../i386/oprofile/, $(OPROFILE-y))

--
