Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZKOTFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZKOTFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 14:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZKOTFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 14:05:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:22166 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZKOTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 14:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PdiKvNprsMijx2qJFdKvhRJPXLb07/170HynnRdZE6jK7AFQTx5lte3IA9PIgc81I4
         XvwIoh4jHRs2OhHDtFeWn4JybAvfv9yy3sV4SF9wPi7NUBQZnT1r6hiUa2/BKx7X14mL
         soAQSROpSRws2Y/cyWyvkWm8cDByKTNHsdKIc=
From: Stijn Devriendt <highguy@gmail.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: Stijn Devriendt <HIGHGuY@gmail.com>
Subject: [PATCH] Initial prototype version of sched_wait_block
Date: Sun, 15 Nov 2009 20:04:19 +0100
Message-Id: <1258311859-6189-2-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stijn Devriendt <HIGHGuY@gmail.com>
---
 arch/alpha/include/asm/unistd.h      |    3 +-
 arch/arm/include/asm/unistd.h        |    1 +
 arch/avr32/include/asm/unistd.h      |    3 +-
 arch/blackfin/include/asm/unistd.h   |    3 +-
 arch/cris/include/asm/unistd.h       |    3 +-
 arch/frv/include/asm/unistd.h        |    3 +-
 arch/h8300/include/asm/unistd.h      |    3 +-
 arch/ia64/include/asm/unistd.h       |    3 +-
 arch/m32r/include/asm/unistd.h       |    3 +-
 arch/m68k/include/asm/unistd.h       |    3 +-
 arch/microblaze/include/asm/unistd.h |    3 +-
 arch/mips/include/asm/unistd.h       |    4 +-
 arch/mn10300/include/asm/unistd.h    |    3 +-
 arch/parisc/include/asm/unistd.h     |    3 +-
 arch/powerpc/include/asm/unistd.h    |    3 +-
 arch/s390/include/asm/unistd.h       |    4 ++-
 arch/sh/include/asm/unistd_32.h      |    3 +-
 arch/sh/include/asm/unistd_64.h      |    3 +-
 arch/sparc/include/asm/unistd.h      |    3 +-
 arch/x86/ia32/ia32entry.S            |    1 +
 arch/x86/include/asm/unistd_32.h     |    1 +
 arch/x86/include/asm/unistd_64.h     |    2 +
 arch/x86/kernel/syscall_table_32.S   |    1 +
 arch/xtensa/include/asm/unistd.h     |    3 +-
 include/asm-generic/unistd.h         |    5 ++-
 include/linux/init_task.h            |    1 +
 include/linux/sched.h                |    3 +-
 include/linux/syscalls.h             |    1 +
 include/linux/wait.h                 |    1 +
 kernel/fork.c                        |    2 +
 kernel/sched.c                       |   64 ++++++++++++++++++++++++++++++++--
 31 files changed, 117 insertions(+), 25 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 5b5c174..3b1b200 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -433,10 +433,11 @@
 #define __NR_signalfd			476
 #define __NR_timerfd			477
 #define __NR_eventfd			478
+#define __NR_sched_wait_block 479
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			479
+#define NR_SYSCALLS			480
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 4e506d0..76364ce 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -391,6 +391,7 @@
 #define __NR_pwritev			(__NR_SYSCALL_BASE+362)
 #define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
+#define __NR_sched_wait_block   (__NR_SYSCALL_BASE+365)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/avr32/include/asm/unistd.h b/arch/avr32/include/asm/unistd.h
index 89861a2..eb892f6 100644
--- a/arch/avr32/include/asm/unistd.h
+++ b/arch/avr32/include/asm/unistd.h
@@ -299,9 +299,10 @@
 #define __NR_signalfd		279
 /* 280 was __NR_timerfd */
 #define __NR_eventfd		281
+#define __NR_sched_wait_block 282
 
 #ifdef __KERNEL__
-#define NR_syscalls		282
+#define NR_syscalls		283
 
 /* Old stuff */
 #define __IGNORE_uselib
diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 779be02..8535d69 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -388,8 +388,9 @@
 #define __NR_pwritev		367
 #define __NR_rt_tgsigqueueinfo	368
 #define __NR_perf_event_open	369
+#define __NR_sched_wait_block 370
 
-#define __NR_syscall		370
+#define __NR_syscall		371
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index c170793..8360734 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -339,10 +339,11 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_sched_wait_block 335
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 335
+#define NR_syscalls 336
 
 #include <arch/unistd.h>
 
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index be6ef0f..4c90687 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -343,10 +343,11 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_sched_wait_block 337
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 337
+#define NR_syscalls 338
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
diff --git a/arch/h8300/include/asm/unistd.h b/arch/h8300/include/asm/unistd.h
index 99f3c35..eb73a9c 100644
--- a/arch/h8300/include/asm/unistd.h
+++ b/arch/h8300/include/asm/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_sched_wait_block 320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 5a5347f..ccb2154 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -311,11 +311,12 @@
 #define __NR_preadv			1319
 #define __NR_pwritev			1320
 #define __NR_rt_tgsigqueueinfo		1321
+#define __NR_sched_wait_block 1322
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			298 /* length of syscall table */
+#define NR_syscalls			299 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/m32r/include/asm/unistd.h b/arch/m32r/include/asm/unistd.h
index cf701c9..f4a0030 100644
--- a/arch/m32r/include/asm/unistd.h
+++ b/arch/m32r/include/asm/unistd.h
@@ -330,10 +330,11 @@
 /* #define __NR_timerfd		322 removed */
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_sched_wait_block 325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 48b87f5..e792350 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -336,10 +336,11 @@
 #define __NR_pwritev		330
 #define __NR_rt_tgsigqueueinfo	331
 #define __NR_perf_event_open	332
+#define __NR_sched_wait_block 333
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		333
+#define NR_syscalls		334
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index cb05a07..df787b2 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -382,8 +382,9 @@
 #define __NR_pwritev		364 /* new */
 #define __NR_rt_tgsigqueueinfo	365 /* new */
 #define __NR_perf_event_open	366 /* new */
+#define __NR_sched_wait_block 367
 
-#define __NR_syscalls		367
+#define __NR_syscalls		368
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index 8c9dfa9..ac3086f 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -355,11 +355,11 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_Linux + 332)
 #define __NR_perf_event_open		(__NR_Linux + 333)
 #define __NR_accept4			(__NR_Linux + 334)
-
+#define __NR_sched_wait_block (__NR_Linux + 335)
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		334
+#define __NR_Linux_syscalls		335
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index 2a98393..3d0ec30 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -348,10 +348,11 @@
 #define __NR_pwritev		335
 #define __NR_rt_tgsigqueueinfo	336
 #define __NR_perf_event_open	337
+#define __NR_sched_wait_block 338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 339
 
 /*
  * specify the deprecated syscalls we want to support on this arch
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index cda1583..383332b 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -811,8 +811,9 @@
 #define __NR_pwritev		(__NR_Linux + 316)
 #define __NR_rt_tgsigqueueinfo	(__NR_Linux + 317)
 #define __NR_perf_event_open	(__NR_Linux + 318)
+#define __NR_sched_wait_block (__NR_Linux + 319)
 
-#define __NR_Linux_syscalls	(__NR_perf_event_open + 1)
+#define __NR_Linux_syscalls	(__NR_sched_wait_block + 1)
 
 
 #define __IGNORE_select		/* newselect */
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index f6ca761..466aa45 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -345,10 +345,11 @@
 #define __NR_preadv		320
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
+#define __NR_sched_wait_block 323
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		323
+#define __NR_syscalls		324
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index cb5232d..c0dabc5 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -269,7 +269,9 @@
 #define	__NR_pwritev		329
 #define __NR_rt_tgsigqueueinfo	330
 #define __NR_perf_event_open	331
-#define NR_syscalls 332
+#define __NR_sched_wait_block 332
+
+#define NR_syscalls 333
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/sh/include/asm/unistd_32.h b/arch/sh/include/asm/unistd_32.h
index f3fd1b9..16516d3 100644
--- a/arch/sh/include/asm/unistd_32.h
+++ b/arch/sh/include/asm/unistd_32.h
@@ -345,8 +345,9 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_sched_wait_block 337
 
-#define NR_syscalls 337
+#define NR_syscalls 338
 
 #ifdef __KERNEL__
 
diff --git a/arch/sh/include/asm/unistd_64.h b/arch/sh/include/asm/unistd_64.h
index 343ce8f..6bf4ab4 100644
--- a/arch/sh/include/asm/unistd_64.h
+++ b/arch/sh/include/asm/unistd_64.h
@@ -385,10 +385,11 @@
 #define __NR_pwritev		362
 #define __NR_rt_tgsigqueueinfo	363
 #define __NR_perf_event_open	364
+#define __NR_sched_wait_block 365
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 365
+#define NR_syscalls 366
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index 42f2316..482664d 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -396,8 +396,9 @@
 #define __NR_pwritev		325
 #define __NR_rt_tgsigqueueinfo	326
 #define __NR_perf_event_open	327
+#define __NR_sched_wait_block 328
 
-#define NR_SYSCALLS		328
+#define NR_SYSCALLS		329
 
 #ifdef __32bit_syscall_numbers__
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 581b056..a63001a 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -841,4 +841,5 @@ ia32_sys_call_table:
 	.quad compat_sys_pwritev
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
+	.quad sys_sched_wait_block
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6fb3c20..91a9e56 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,6 +342,7 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_sched_wait_block 337
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 8d3ad0a..11e943e 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,8 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_sched_wait_block     299
+__SYSCALL(__NR_sched_wait_block, sys_sched_wait_block)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0157cd2..2f93cef 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,4 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long sys_sched_wait_block
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index c092c8f..834aa00 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -681,8 +681,9 @@ __SYSCALL(304, sys_signalfd, 3)
 __SYSCALL(305, sys_ni_syscall, 0)
 #define __NR_eventfd				306
 __SYSCALL(306, sys_eventfd, 1)
+#define __NR_sched_wait_block 307
 
-#define __NR_syscall_count			307
+#define __NR_syscall_count			308
 
 /*
  * sysxtensa syscall handler
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..ff21a1b 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -623,8 +623,11 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 241
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 
+#define __NR_sched_wait_block 242
+__SYSCALL(__NR_sched_wait_block, sys_sched_wait_block)
+
 #undef __NR_syscalls
-#define __NR_syscalls 242
+#define __NR_syscalls 243
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 21a6f5d..21ed548 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -145,6 +145,7 @@ extern struct cred init_cred;
 	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
+	.task_waiters = __WAIT_QUEUE_HEAD_INITIALIZER(tsk.task_waiters), \
 	.real_parent	= &tsk,						\
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c46023..d4639b4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1280,7 +1280,7 @@ struct task_struct {
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
 	unsigned in_iowait:1;
-
+  unsigned in_taskwait:1;
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
@@ -1315,6 +1315,7 @@ struct task_struct {
 	struct list_head ptraced;
 	struct list_head ptrace_entry;
 
+	wait_queue_head_t task_waiters;
 	/*
 	 * This is the tracer handle for the ptrace BTS extension.
 	 * This field actually belongs to the ptracer task.
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b50974a..e18d7e8 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -406,6 +406,7 @@ asmlinkage long sys_sched_rr_get_interval(pid_t pid,
 					struct timespec __user *interval);
 asmlinkage long sys_setpriority(int which, int who, int niceval);
 asmlinkage long sys_getpriority(int which, int who);
+asmlinkage long sys_sched_wait_block(pid_t pid, struct timespec __user *uts);
 
 asmlinkage long sys_shutdown(int, int);
 asmlinkage long sys_reboot(int magic1, int magic2, unsigned int cmd,
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..4afb340 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -157,6 +157,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_sync_all(x) __wake_up_sync((x), TASK_NORMAL, 0)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..e664442 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1121,6 +1121,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
+	init_waitqueue_head(&p->task_waiters);
+
 	p->bts = NULL;
 
 	p->stack_start = stack_start;
diff --git a/kernel/sched.c b/kernel/sched.c
index 7179c80..98f5480 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5440,6 +5440,7 @@ asmlinkage void __sched schedule(void)
 	struct rq *rq;
 	int cpu;
 
+
 need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
@@ -5450,6 +5451,8 @@ need_resched:
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
+	if (prev->state && !unlikely(prev->in_taskwait) && unlikely(waitqueue_active(&prev->task_waiters)))
+		wake_up_sync_all(&prev->task_waiters);
 
 	schedule_debug(prev);
 
@@ -5467,7 +5470,7 @@ need_resched_nonpreemptible:
 			deactivate_task(rq, prev, 1);
 		switch_count = &prev->nvcsw;
 	}
-
+	
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
@@ -5717,8 +5720,8 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 	if (unlikely(!q))
 		return;
 
-	if (unlikely(!nr_exclusive))
-		wake_flags = 0;
+	/*if (unlikely(!nr_exclusive))
+		wake_flags = 0;*/
 
 	spin_lock_irqsave(&q->lock, flags);
 	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
@@ -6889,6 +6892,61 @@ out_unlock:
 	return retval;
 }
 
+SYSCALL_DEFINE2(sched_wait_block, pid_t, pid, struct timespec __user *, uts)
+{
+  struct task_struct* p;
+	long retval;
+	struct timespec ts;
+	long timeout = MAX_SCHEDULE_TIMEOUT;
+
+	if (pid < 0)
+	{
+		printk(KERN_INFO "Unknown PID: %d\n", pid);
+		return -EINVAL;
+	}
+
+	if (uts)
+	{
+	  if (copy_from_user(&ts, uts, sizeof(struct timespec)))
+			return -EINVAL;
+
+	  timeout = timespec_to_jiffies(&ts);
+		printk(KERN_INFO "Timeout: %d\n", timeout);
+
+		if (timeout < 0)
+			return -EINVAL;
+	}
+
+	read_lock(&tasklist_lock);
+	p = find_process_by_pid(pid);
+	if (!p)
+	{
+		read_unlock(&tasklist_lock);
+		return -ESRCH;
+	}
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
+	printk(KERN_INFO "Waiting...");
+	// logic
+	current->in_taskwait = 1;
+	retval = wait_event_interruptible_timeout(p->task_waiters, p->state, timeout);
+	current->in_taskwait = 0;
+	// endlogic
+	printk("Done: %d\n", retval);
+
+	if (retval == -ERESTARTSYS)
+		retval = -EINTR;
+	else if (p->state)
+		retval = 0;
+	else
+		retval = -EAGAIN;
+
+  put_task_struct(p);
+
+	return retval;
+}
+
 static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 
 void sched_show_task(struct task_struct *p)
-- 
1.6.3.3

