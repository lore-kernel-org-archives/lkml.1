Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYFXN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYFXN6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFXN63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:58:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42264 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYFXN62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:58:28 -0400
Message-Id: <20080624135823.747587186@us.ibm.com>
References: <20080624135823.417569216@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 06:58:24 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Menage <menage@google.com>, Pavel Machek <pavel@ucw.cz>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: [patch 1/4] Container Freezer: Add TIF_FREEZE flag to all architectures
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>
Subject: [patch 1/4] Container Freezer: Add TIF_FREEZE flag to all architectures

This patch is the first step in making the refrigerator() available 
to all architectures, even for those without power management. 

The purpose of such a change is to be able to use the refrigerator() 
in a new control group subsystem which will implement a control group
freezer.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
---
 include/asm-alpha/thread_info.h     |    2 ++
 include/asm-avr32/thread_info.h     |    2 ++
 include/asm-cris/thread_info.h      |    2 ++
 include/asm-h8300/thread_info.h     |    2 ++
 include/asm-m68k/thread_info.h      |    1 +
 include/asm-m68knommu/thread_info.h |    2 ++
 include/asm-parisc/thread_info.h    |    2 ++
 include/asm-s390/thread_info.h      |    2 ++
 include/asm-sparc/thread_info.h     |    2 ++
 include/asm-sparc64/thread_info.h   |    2 ++
 include/asm-um/thread_info.h        |    2 ++
 include/asm-xtensa/thread_info.h    |    2 ++
 12 files changed, 23 insertions(+)

Index: linux-2.6.26-rc5-mm2/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-alpha/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-alpha/thread_info.h
@@ -72,16 +72,18 @@ register struct thread_info *__current_t
 #define TIF_UAC_NOPRINT		5	/* see sysinfo.h */
 #define TIF_UAC_NOFIX		6
 #define TIF_UAC_SIGBUS		7
 #define TIF_MEMDIE		8
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
 
 /* Work to do on any return to userspace.  */
Index: linux-2.6.26-rc5-mm2/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-avr32/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-avr32/thread_info.h
@@ -82,10 +82,11 @@ static inline struct thread_info *curren
 #define TIF_BREAKPOINT		4	/* enter monitor mode on return */
 #define TIF_SINGLE_STEP		5	/* single step in progress */
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -93,10 +94,11 @@ static inline struct thread_info *curren
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* Note: The masks below must never span more than 16 bits! */
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK				\
Index: linux-2.6.26-rc5-mm2/include/asm-cris/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-cris/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-cris/thread_info.h
@@ -86,17 +86,19 @@ struct thread_info {
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
 #endif /* __KERNEL__ */
Index: linux-2.6.26-rc5-mm2/include/asm-h8300/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-h8300/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-h8300/thread_info.h
@@ -87,17 +87,19 @@ static inline struct thread_info *curren
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6.26-rc5-mm2/include/asm-m68k/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-m68k/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-m68k/thread_info.h
@@ -50,7 +50,8 @@ struct thread_info {
 #define TIF_SIGPENDING		6	/* signal pending */
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
+#define TIF_FREEZE		19	/* thread is freezing for suspend */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
Index: linux-2.6.26-rc5-mm2/include/asm-m68knommu/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-m68knommu/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-m68knommu/thread_info.h
@@ -82,16 +82,18 @@ static inline struct thread_info *curren
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6.26-rc5-mm2/include/asm-parisc/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-parisc/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-parisc/thread_info.h
@@ -56,17 +56,19 @@ struct thread_info {
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
 
 #endif /* __KERNEL__ */
Index: linux-2.6.26-rc5-mm2/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-s390/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-s390/thread_info.h
@@ -96,10 +96,11 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
+#define TIF_FREEZE		21	/* thread is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -108,10 +109,11 @@ static inline struct thread_info *curren
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
 #define PREEMPT_ACTIVE		0x4000000
 
Index: linux-2.6.26-rc5-mm2/include/asm-sparc/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-sparc/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-sparc/thread_info.h
@@ -137,17 +137,19 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
 #define TIF_MEMDIE		10
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6.26-rc5-mm2/include/asm-sparc64/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-sparc64/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-sparc64/thread_info.h
@@ -214,10 +214,11 @@ register struct thread_info *current_thr
  *       an immediate value in instructions such as andcc.
  */
 #define TIF_ABI_PENDING		12
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_PERFCTR		(1<<TIF_PERFCTR)
@@ -225,10 +226,11 @@ register struct thread_info *current_thr
 #define _TIF_32BIT		(1<<TIF_32BIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
 				 (_TIF_SIGPENDING | \
 				  _TIF_NEED_RESCHED | _TIF_PERFCTR))
 
Index: linux-2.6.26-rc5-mm2/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-um/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-um/thread_info.h
@@ -67,15 +67,17 @@ static inline struct thread_info *curren
 					 */
 #define TIF_RESTART_BLOCK 	4
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG     (1 << TIF_POLLING_NRFLAG)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #endif
Index: linux-2.6.26-rc5-mm2/include/asm-xtensa/thread_info.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-xtensa/thread_info.h
+++ linux-2.6.26-rc5-mm2/include/asm-xtensa/thread_info.h
@@ -132,18 +132,20 @@ static inline struct thread_info *curren
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_IRET		(1<<TIF_IRET)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
 /*

-- 
