Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZGJNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZGJNEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZGJNEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:04:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZGJNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:04:17 -0400
Message-Id: <20090710130125.037018244@chello.nl>
References: <20090710125755.559739294@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 10 Jul 2009 14:57:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, tony.luck@intel.com, rth@twiddle.net,
       geert@linux-m68k.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: INIT_PREEMPT_COUNT
Content-Disposition: inline; filename=sched_init_preempt_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull the initial preempt_count value into a single
definition site.

Maintainers for: alpha, ia64 and m68k, please have a look,
your arch code is funny.

The header magic is a bit odd, but similar to the KERNEL_DS
one, CPP waits with expanding these macros until the
INIT_THREAD_INFO macro itself is expanded, which is in
arch/*/kernel/init_task.c where we've already included
sched.h so we're good.

Cc: tony.luck@intel.com
Cc: rth@twiddle.net
Cc: geert@linux-m68k.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/thread_info.h      |    1 +
 arch/arm/include/asm/thread_info.h        |    2 +-
 arch/avr32/include/asm/thread_info.h      |    2 +-
 arch/blackfin/include/asm/thread_info.h   |    2 +-
 arch/cris/include/asm/thread_info.h       |    4 +---
 arch/frv/include/asm/thread_info.h        |    4 +---
 arch/h8300/include/asm/thread_info.h      |    2 +-
 arch/ia64/include/asm/thread_info.h       |    2 +-
 arch/m32r/include/asm/thread_info.h       |    4 +---
 arch/m68k/include/asm/thread_info_mm.h    |    1 +
 arch/m68k/include/asm/thread_info_no.h    |    1 +
 arch/microblaze/include/asm/thread_info.h |    4 +---
 arch/mips/include/asm/thread_info.h       |    4 +---
 arch/mn10300/include/asm/thread_info.h    |    4 +---
 arch/parisc/include/asm/thread_info.h     |    2 +-
 arch/powerpc/include/asm/thread_info.h    |    4 +---
 arch/s390/include/asm/thread_info.h       |    2 +-
 arch/sh/include/asm/thread_info.h         |    2 +-
 arch/sparc/include/asm/thread_info_32.h   |    4 +---
 arch/sparc/include/asm/thread_info_64.h   |    4 +---
 arch/um/include/asm/thread_info.h         |    2 +-
 arch/x86/include/asm/thread_info.h        |    2 +-
 arch/xtensa/include/asm/thread_info.h     |    4 +---
 include/linux/sched.h                     |    6 ++++++
 24 files changed, 29 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/thread_info.h
+++ linux-2.6/arch/alpha/include/asm/thread_info.h
@@ -37,6 +37,7 @@ struct thread_info {
 	.task		= &tsk,			\
 	.exec_domain	= &default_exec_domain,	\
 	.addr_limit	= KERNEL_DS,		\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/arm/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/thread_info.h
+++ linux-2.6/arch/arm/include/asm/thread_info.h
@@ -73,7 +73,7 @@ struct thread_info {
 	.task		= &tsk,						\
 	.exec_domain	= &default_exec_domain,				\
 	.flags		= 0,						\
-	.preempt_count	= 1,						\
+	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
 	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
Index: linux-2.6/arch/avr32/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/thread_info.h
+++ linux-2.6/arch/avr32/include/asm/thread_info.h
@@ -40,7 +40,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,				\
 	.flags		= 0,						\
 	.cpu		= 0,						\
-	.preempt_count	= 1,						\
+	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.restart_block	= {						\
 		.fn	= do_no_restart_syscall				\
 	}								\
Index: linux-2.6/arch/blackfin/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/thread_info.h
+++ linux-2.6/arch/blackfin/include/asm/thread_info.h
@@ -77,7 +77,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count  = 1,                    \
+	.preempt_count  = INIT_PREEMPT_COUNT,   \
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/cris/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/thread_info.h
+++ linux-2.6/arch/cris/include/asm/thread_info.h
@@ -50,8 +50,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 #define INIT_THREAD_INFO(tsk)				\
@@ -60,7 +58,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,		\
 	.flags		= 0,				\
 	.cpu		= 0,				\
-	.preempt_count	= 1,				\
+	.preempt_count	= INIT_PREEMPT_COUNT,		\
 	.addr_limit	= KERNEL_DS,			\
 	.restart_block = {				\
 		       .fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/frv/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/thread_info.h
+++ linux-2.6/arch/frv/include/asm/thread_info.h
@@ -56,8 +56,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
@@ -67,7 +65,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/h8300/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/thread_info.h
+++ linux-2.6/arch/h8300/include/asm/thread_info.h
@@ -36,7 +36,7 @@ struct thread_info {
 	.exec_domain =	&default_exec_domain,	\
 	.flags =	0,			\
 	.cpu =		0,			\
-	.preempt_count = 1,			\
+	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/ia64/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/thread_info.h
+++ linux-2.6/arch/ia64/include/asm/thread_info.h
@@ -48,7 +48,7 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
-	.preempt_count	= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/m32r/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/thread_info.h
+++ linux-2.6/arch/m32r/include/asm/thread_info.h
@@ -57,8 +57,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
@@ -68,7 +66,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/m68k/include/asm/thread_info_mm.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/thread_info_mm.h
+++ linux-2.6/arch/m68k/include/asm/thread_info_mm.h
@@ -19,6 +19,7 @@ struct thread_info {
 {						\
 	.task		= &tsk,			\
 	.exec_domain	= &default_exec_domain,	\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/m68k/include/asm/thread_info_no.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/thread_info_no.h
+++ linux-2.6/arch/m68k/include/asm/thread_info_no.h
@@ -49,6 +49,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/microblaze/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/thread_info.h
+++ linux-2.6/arch/microblaze/include/asm/thread_info.h
@@ -75,8 +75,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #define INIT_THREAD_INFO(tsk)			\
 {						\
@@ -84,7 +82,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/mips/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/thread_info.h
+++ linux-2.6/arch/mips/include/asm/thread_info.h
@@ -39,8 +39,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #define INIT_THREAD_INFO(tsk)			\
 {						\
@@ -48,7 +46,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= _TIF_FIXADE,		\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/mn10300/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/thread_info.h
+++ linux-2.6/arch/mn10300/include/asm/thread_info.h
@@ -65,8 +65,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
@@ -76,7 +74,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/parisc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/thread_info.h
+++ linux-2.6/arch/parisc/include/asm/thread_info.h
@@ -23,7 +23,7 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
   	.restart_block	= {			\
 		.fn = do_no_restart_syscall	\
 	}					\
Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
+++ linux-2.6/arch/powerpc/include/asm/thread_info.h
@@ -46,15 +46,13 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task =		&tsk,			\
 	.exec_domain =	&default_exec_domain,	\
 	.cpu =		0,			\
-	.preempt_count = 1,			\
+	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/s390/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/thread_info.h
+++ linux-2.6/arch/s390/include/asm/thread_info.h
@@ -61,7 +61,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6/arch/sh/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/thread_info.h
+++ linux-2.6/arch/sh/include/asm/thread_info.h
@@ -51,7 +51,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_32.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_32.h
@@ -54,8 +54,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #define INIT_THREAD_INFO(tsk)				\
 {							\
@@ -64,7 +62,7 @@ struct thread_info {
 	.exec_domain	=	&default_exec_domain,	\
 	.flags		=	0,			\
 	.cpu		=	0,			\
-	.preempt_count	=	1,			\
+	.preempt_count	=	INIT_PREEMPT_COUNT,	\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
Index: linux-2.6/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_64.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_64.h
@@ -125,8 +125,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
@@ -135,7 +133,7 @@ struct thread_info {
 	.task		=	&tsk,			\
 	.flags		= ((unsigned long)ASI_P) << TI_FLAG_CURRENT_DS_SHIFT,	\
 	.exec_domain	=	&default_exec_domain,	\
-	.preempt_count	=	1,			\
+	.preempt_count	=	INIT_PREEMPT_COUNT,	\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
Index: linux-2.6/arch/um/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/thread_info.h
+++ linux-2.6/arch/um/include/asm/thread_info.h
@@ -32,7 +32,7 @@ struct thread_info {
 	.exec_domain =	&default_exec_domain,	\
 	.flags =		0,		\
 	.cpu =		0,			\
-	.preempt_count =	1,		\
+	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit =	KERNEL_DS,		\
 	.restart_block =  {			\
 		.fn =  do_no_restart_syscall,	\
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -49,7 +49,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/arch/xtensa/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/thread_info.h
+++ linux-2.6/arch/xtensa/include/asm/thread_info.h
@@ -80,8 +80,6 @@ struct thread_info {
 
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 
 #ifndef __ASSEMBLY__
@@ -92,7 +90,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= 1,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -500,6 +500,12 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
+/*
+ * Disable preemption until the scheduler is running.
+ * Reset by start_kernel()->sched_init()->init_idle().
+ */
+#define INIT_PREEMPT_COUNT	(1)
+
 /**
  * struct thread_group_cputimer - thread group interval timer counts
  * @cputime:		thread group interval timers.

-- 

