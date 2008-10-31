Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYJaNgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYJaNgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYJaNgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYJaNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:36:41 -0400
Date: Fri, 31 Oct 2008 09:36:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: [PATCH] ftrace: fix hardirq header for non ftrace archs
In-Reply-To: <20081031093030.GC30317@elte.hu>
Message-ID: <alpine.DEB.1.10.0810310934010.13290@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com> <alpine.DEB.1.10.0810310016230.28140@gandalf.stny.rr.com> <20081031093030.GC30317@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not all archs implement ftrace, and therefore do not have an asm/ftrace.h.
This patch corrects the problem.

The ftrace_nmi_enter/exit now must be defined for all archs that implement
dynamic ftrace. Currently, only x86 does.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/arm/include/asm/ftrace.h     |    5 -----
 arch/powerpc/include/asm/ftrace.h |    5 -----
 arch/sh/include/asm/ftrace.h      |    5 -----
 arch/sparc/include/asm/ftrace.h   |    5 -----
 arch/x86/include/asm/ftrace.h     |   16 ----------------
 include/linux/ftrace.h            |    5 ++++-
 include/linux/hardirq.h           |    2 +-
 7 files changed, 5 insertions(+), 38 deletions(-)

Index: linux-tip.git/arch/arm/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/arm/include/asm/ftrace.h	2008-10-30 23:24:18.000000000 -0400
+++ linux-tip.git/arch/arm/include/asm/ftrace.h	2008-10-31 08:48:47.000000000 -0400
@@ -1,11 +1,6 @@
 #ifndef _ASM_ARM_FTRACE
 #define _ASM_ARM_FTRACE
 
-#ifndef __ASSEMBLY__
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
Index: linux-tip.git/arch/powerpc/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/powerpc/include/asm/ftrace.h	2008-10-30 23:24:30.000000000 -0400
+++ linux-tip.git/arch/powerpc/include/asm/ftrace.h	2008-10-31 08:48:52.000000000 -0400
@@ -1,11 +1,6 @@
 #ifndef _ASM_POWERPC_FTRACE
 #define _ASM_POWERPC_FTRACE
 
-#ifndef __ASSEMBLY__
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
Index: linux-tip.git/arch/sh/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/sh/include/asm/ftrace.h	2008-10-30 23:24:43.000000000 -0400
+++ linux-tip.git/arch/sh/include/asm/ftrace.h	2008-10-31 08:48:58.000000000 -0400
@@ -2,11 +2,6 @@
 #define __ASM_SH_FTRACE_H
 
 #ifndef __ASSEMBLY__
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
-
-#ifndef __ASSEMBLY__
 extern void mcount(void);
 #endif
 
Index: linux-tip.git/arch/sparc/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/sparc/include/asm/ftrace.h	2008-10-30 23:24:50.000000000 -0400
+++ linux-tip.git/arch/sparc/include/asm/ftrace.h	2008-10-31 08:49:01.000000000 -0400
@@ -1,11 +1,6 @@
 #ifndef _ASM_SPARC64_FTRACE
 #define _ASM_SPARC64_FTRACE
 
-#ifndef __ASSEMBLY__
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
-
 #ifdef CONFIG_MCOUNT
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
Index: linux-tip.git/arch/x86/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/x86/include/asm/ftrace.h	2008-10-30 23:25:26.000000000 -0400
+++ linux-tip.git/arch/x86/include/asm/ftrace.h	2008-10-31 08:52:44.000000000 -0400
@@ -17,23 +17,7 @@ static inline unsigned long ftrace_call_
 	 */
 	return addr - 1;
 }
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-extern void ftrace_nmi_enter(void);
-extern void ftrace_nmi_exit(void);
-#else
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
 #endif /* __ASSEMBLY__ */
-
-#else /* CONFIG_FUNCTION_TRACER */
-
-#ifndef __ASSEMBLY__
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
-#endif
-
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #endif /* _ASM_X86_FTRACE_H */
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-10-30 23:31:33.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-10-31 08:52:29.000000000 -0400
@@ -44,7 +44,6 @@ static inline void ftrace_kill(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
 	FTRACE_FL_FAILED	= (1 << 1),
@@ -105,6 +104,8 @@ extern void ftrace_release(void *start, 
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
+extern void ftrace_nmi_enter(void);
+extern void ftrace_nmi_exit(void);
 
 #else
 # define skip_trace(ip)				({ 0; })
@@ -113,6 +114,8 @@ extern void ftrace_enable_daemon(void);
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
 static inline void ftrace_release(void *start, unsigned long size) { }
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
Index: linux-tip.git/include/linux/hardirq.h
===================================================================
--- linux-tip.git.orig/include/linux/hardirq.h	2008-10-31 00:07:46.000000000 -0400
+++ linux-tip.git/include/linux/hardirq.h	2008-10-31 08:53:01.000000000 -0400
@@ -4,8 +4,8 @@
 #include <linux/preempt.h>
 #include <linux/smp_lock.h>
 #include <linux/lockdep.h>
+#include <linux/ftrace.h>
 #include <asm/hardirq.h>
-#include <asm/ftrace.h>
 #include <asm/system.h>
 
 /*


