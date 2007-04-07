Return-Path: <linux-kernel-owner+w=401wt.eu-S966143AbXDGRWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966143AbXDGRWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966146AbXDGRWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:22:52 -0400
Received: from gw.goop.org ([64.81.55.164]:54416 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966143AbXDGRWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:22:51 -0400
Message-ID: <4617D339.3080801@goop.org>
Date: Sat, 07 Apr 2007 10:22:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: [PATCH 1/2] Clean up asm-x86_64/bugs.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most of asm-x86_64/bugs.h is code which should be in a C file, so put it there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/x86_64/kernel/Makefile      |    3 ++-
 arch/x86_64/kernel/bugs.c        |   28 ++++++++++++++++++++++++++++
 include/asm-x86_64/alternative.h |    1 +
 include/asm-x86_64/bugs.h        |   30 ++++--------------------------
 4 files changed, 35 insertions(+), 27 deletions(-)

===================================================================
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -8,7 +8,8 @@ obj-y	:= process.o signal.o entry.o trap
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o
+		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o \
+		bugs.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
===================================================================
--- /dev/null
+++ b/arch/x86_64/kernel/bugs.c
@@ -0,0 +1,28 @@
+/*
+ *  arch/x86_64/kernel/bugs.c
+ *
+ *  Copyright (C) 1994  Linus Torvalds
+ *  Copyright (C) 2000  SuSE
+ *
+ * This is included by init/main.c to check for architecture-dependent bugs.
+ *
+ * Needs:
+ *	void check_bugs(void);
+ */
+
+#include <linux/kernel.h>
+#include <asm/alternative.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/msr.h>
+#include <asm/pda.h>
+
+void __init check_bugs(void)
+{
+	identify_cpu(&boot_cpu_data);
+#if !defined(CONFIG_SMP)
+	printk("CPU: ");
+	print_cpu_info(&boot_cpu_data);
+#endif
+	alternative_instructions();
+}
===================================================================
--- a/include/asm-x86_64/alternative.h
+++ b/include/asm-x86_64/alternative.h
@@ -16,6 +16,7 @@ struct alt_instr {
 	u8  pad[5];
 };
 
+extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
===================================================================
--- a/include/asm-x86_64/bugs.h
+++ b/include/asm-x86_64/bugs.h
@@ -1,28 +1,6 @@
-/*
- *  include/asm-x86_64/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- *  Copyright (C) 2000  SuSE
- *
- * This is included by init/main.c to check for architecture-dependent bugs.
- *
- * Needs:
- *	void check_bugs(void);
- */
+#ifndef _ASM_X86_64_BUGS_H
+#define _ASM_X86_64_BUGS_H
 
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/pda.h>
+void check_bugs(void);
 
-extern void alternative_instructions(void);
-
-static void __init check_bugs(void)
-{
-	identify_cpu(&boot_cpu_data);
-#if !defined(CONFIG_SMP)
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	alternative_instructions(); 
-}
+#endif	/* _ASM_X86_64_BUGS_H */

