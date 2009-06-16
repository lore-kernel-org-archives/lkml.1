Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbZFPUUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbZFPUUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763015AbZFPURE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:17:04 -0400
Received: from ru.mvista.com ([213.79.90.228]:2510 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762076AbZFPURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:17:01 -0400
Date: Wed, 17 Jun 2009 00:16:32 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/2] powerpc: Remove -fno-omit-frame-pointer workarounds
Message-ID: <20090616201632.GB4971@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workarounds aren't needed any longer since the top level Makefile
doesn't pass -fno-omit-frame-pointer cflag for PowerPC builds.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/Makefile                    |    5 -----
 arch/powerpc/kernel/Makefile             |   12 ++++++------
 arch/powerpc/platforms/powermac/Makefile |    2 +-
 lib/Kconfig.debug                        |    6 +++---
 4 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index bc35f4e..dd3c63b 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -120,11 +120,6 @@ ifeq ($(CONFIG_6xx),y)
 KBUILD_CFLAGS		+= -mcpu=powerpc
 endif
 
-# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
-ifeq ($(CONFIG_FUNCTION_TRACER),y)
-KBUILD_CFLAGS		+= -mno-sched-epilog
-endif
-
 cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
 cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
 cpu-as-$(CONFIG_POWER4)		+= -Wa,-maltivec
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 612b0c4..19ebe1b 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -14,14 +14,14 @@ endif
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
-CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_cputable.o = -pg
+CFLAGS_REMOVE_prom_init.o = -pg
+CFLAGS_REMOVE_btext.o = -pg
+CFLAGS_REMOVE_prom.o = -pg
 # do not trace tracer code
-CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_ftrace.o = -pg
 # timers used by tracing
-CFLAGS_REMOVE_time.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_time.o = -pg
 endif
 
 obj-y				:= cputable.o ptrace.o syscalls.o \
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index 50f1693..0eb8781 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -2,7 +2,7 @@ CFLAGS_bootx_init.o  		+= -fPIC
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
-CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_bootx_init.o = -pg
 endif
 
 obj-y				+= pic.o setup.o time.o feature.o pci.o \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 39f113a..1479e54 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -492,7 +492,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
+	select FRAME_POINTER if !MIPS && !ARM_UNWIND && !S390
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -861,13 +861,13 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !PPC && !S390
+	select FRAME_POINTER if !S390
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
-	select FRAME_POINTER if !MIPS && !PPC && !S390
+	select FRAME_POINTER if !MIPS && !S390
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
1.6.3.1
