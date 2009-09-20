Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZITSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZITSnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZITSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:43:48 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62612 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420AbZITSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:43:40 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 2/4] Use new __init_task_data macro in arch init_task.c files.
Date: Sun, 20 Sep 2009 14:43:11 -0400
Message-Id: <1253472193-21106-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253472193-21106-1-git-send-email-tabbott@ksplice.com>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/kernel/init_task.c            |    5 ++---
 arch/avr32/kernel/init_task.c          |    5 ++---
 arch/cris/kernel/process.c             |    5 ++---
 arch/frv/kernel/init_task.c            |    5 ++---
 arch/h8300/kernel/init_task.c          |    5 ++---
 arch/ia64/kernel/init_task.c           |    3 ++-
 arch/m32r/kernel/init_task.c           |    5 ++---
 arch/m68k/kernel/process.c             |    6 +++---
 arch/m68knommu/kernel/init_task.c      |    5 ++---
 arch/microblaze/kernel/init_task.c     |    5 ++---
 arch/mips/kernel/init_task.c           |    5 ++---
 arch/mn10300/kernel/init_task.c        |    5 ++---
 arch/parisc/kernel/init_task.c         |    4 ++--
 arch/powerpc/kernel/init_task.c        |    5 ++---
 arch/powerpc/kernel/machine_kexec_64.c |    5 +++--
 arch/s390/kernel/init_task.c           |    5 ++---
 arch/score/kernel/init_task.c          |    5 ++---
 arch/sh/kernel/init_task.c             |    5 ++---
 arch/sparc/kernel/init_task.c          |    5 ++---
 arch/um/kernel/init_task.c             |    5 ++---
 arch/x86/kernel/init_task.c            |    5 ++---
 arch/xtensa/kernel/init_task.c         |    5 ++---
 22 files changed, 46 insertions(+), 62 deletions(-)

diff --git a/arch/arm/kernel/init_task.c b/arch/arm/kernel/init_task.c
index 3f47086..e7cbb50 100644
--- a/arch/arm/kernel/init_task.c
+++ b/arch/arm/kernel/init_task.c
@@ -24,9 +24,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  *
  * The things we do for performance..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/avr32/kernel/init_task.c b/arch/avr32/kernel/init_task.c
index 57ec9f2..6b2343e 100644
--- a/arch/avr32/kernel/init_task.c
+++ b/arch/avr32/kernel/init_task.c
@@ -18,9 +18,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 /*
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 51dcd04..c99aeab 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -45,9 +45,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/frv/kernel/init_task.c b/arch/frv/kernel/init_task.c
index 1d3df1d..3c3e0b3 100644
--- a/arch/frv/kernel/init_task.c
+++ b/arch/frv/kernel/init_task.c
@@ -19,9 +19,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/h8300/kernel/init_task.c b/arch/h8300/kernel/init_task.c
index 089c65e..54c1062 100644
--- a/arch/h8300/kernel/init_task.c
+++ b/arch/h8300/kernel/init_task.c
@@ -31,7 +31,6 @@ EXPORT_SYMBOL(init_task);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
diff --git a/arch/ia64/kernel/init_task.c b/arch/ia64/kernel/init_task.c
index c475fc2..e253ab8 100644
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -33,7 +33,8 @@ union {
 		struct thread_info thread_info;
 	} s;
 	unsigned long stack[KERNEL_STACK_SIZE/sizeof (unsigned long)];
-} init_task_mem asm ("init_task") __attribute__((section(".data.init_task"))) = {{
+} init_task_mem asm ("init_task") __init_task_data =
+	{{
 	.task =		INIT_TASK(init_task_mem.s.task),
 	.thread_info =	INIT_THREAD_INFO(init_task_mem.s.task)
 }};
diff --git a/arch/m32r/kernel/init_task.c b/arch/m32r/kernel/init_task.c
index fce57e5..6c42d5f 100644
--- a/arch/m32r/kernel/init_task.c
+++ b/arch/m32r/kernel/init_task.c
@@ -20,9 +20,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 72bad65..41230c5 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -42,9 +42,9 @@
  */
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-union thread_union init_thread_union
-__attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
-       = { INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data
+	__attribute__((aligned(THREAD_SIZE))) =
+		{ INIT_THREAD_INFO(init_task) };
 
 /* initial task structure */
 struct task_struct init_task = INIT_TASK(init_task);
diff --git a/arch/m68knommu/kernel/init_task.c b/arch/m68knommu/kernel/init_task.c
index 45e97a2..cbf9dc3 100644
--- a/arch/m68knommu/kernel/init_task.c
+++ b/arch/m68knommu/kernel/init_task.c
@@ -31,7 +31,6 @@ EXPORT_SYMBOL(init_task);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
index 67da225..b5d711f 100644
--- a/arch/microblaze/kernel/init_task.c
+++ b/arch/microblaze/kernel/init_task.c
@@ -19,9 +19,8 @@
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
 EXPORT_SYMBOL(init_task);
diff --git a/arch/mips/kernel/init_task.c b/arch/mips/kernel/init_task.c
index 5b457a4..6d6ca53 100644
--- a/arch/mips/kernel/init_task.c
+++ b/arch/mips/kernel/init_task.c
@@ -21,9 +21,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  *
  * The things we do for performance..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"),
-	               __aligned__(THREAD_SIZE))) =
+union thread_union init_thread_union __init_task_data
+	__attribute__((__aligned__(THREAD_SIZE))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/mn10300/kernel/init_task.c b/arch/mn10300/kernel/init_task.c
index 80d423b..a481b04 100644
--- a/arch/mn10300/kernel/init_task.c
+++ b/arch/mn10300/kernel/init_task.c
@@ -27,9 +27,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
index 82974b2..d020eae 100644
--- a/arch/parisc/kernel/init_task.c
+++ b/arch/parisc/kernel/init_task.c
@@ -43,8 +43,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data
+	__attribute__((aligned(128))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 #if PT_NLEVELS == 3
diff --git a/arch/powerpc/kernel/init_task.c b/arch/powerpc/kernel/init_task.c
index ffc4253..2375b7e 100644
--- a/arch/powerpc/kernel/init_task.c
+++ b/arch/powerpc/kernel/init_task.c
@@ -16,9 +16,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 49e705f..040bd1d 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/smp.h>
 #include <linux/thread_info.h>
+#include <linux/init_task.h>
 #include <linux/errno.h>
 
 #include <asm/page.h>
@@ -249,8 +250,8 @@ static void kexec_prepare_cpus(void)
  * We could use a smaller stack if we don't care about anything using
  * current, but that audit has not been performed.
  */
-static union thread_union kexec_stack
-	__attribute__((__section__(".data.init_task"))) = { };
+static union thread_union kexec_stack __init_task_data =
+	{ };
 
 /* Our assembly helper, in kexec_stub.S */
 extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
diff --git a/arch/s390/kernel/init_task.c b/arch/s390/kernel/init_task.c
index fe787f9..4d1c9fb 100644
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -25,9 +25,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/score/kernel/init_task.c b/arch/score/kernel/init_task.c
index ff952f6..baa03ee 100644
--- a/arch/score/kernel/init_task.c
+++ b/arch/score/kernel/init_task.c
@@ -34,9 +34,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"), __aligned__(THREAD_SIZE))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/sh/kernel/init_task.c b/arch/sh/kernel/init_task.c
index 1719957..11f2ea5 100644
--- a/arch/sh/kernel/init_task.c
+++ b/arch/sh/kernel/init_task.c
@@ -17,9 +17,8 @@ struct pt_regs fake_swapper_regs;
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/sparc/kernel/init_task.c b/arch/sparc/kernel/init_task.c
index 28125c5..5fe3d65 100644
--- a/arch/sparc/kernel/init_task.c
+++ b/arch/sparc/kernel/init_task.c
@@ -18,6 +18,5 @@ EXPORT_SYMBOL(init_task);
  * If this is not aligned on a 8k boundry, then you should change code
  * in etrap.S which assumes it.
  */
-union thread_union init_thread_union
-	__attribute__((section (".data.init_task")))
-	= { INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
diff --git a/arch/um/kernel/init_task.c b/arch/um/kernel/init_task.c
index b25121b..8aa77b6 100644
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -30,9 +30,8 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry..
  */
 
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
 	__attribute__((__section__(".data.init_irqstack"))) =
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index 270ff83..3a54dcb 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -20,9 +20,8 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-		{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 /*
  * Initial task structure.
diff --git a/arch/xtensa/kernel/init_task.c b/arch/xtensa/kernel/init_task.c
index c4302f0..cd122fb 100644
--- a/arch/xtensa/kernel/init_task.c
+++ b/arch/xtensa/kernel/init_task.c
@@ -23,9 +23,8 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
-{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
 
-- 
1.6.3.3

