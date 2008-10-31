Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYJaEDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYJaEDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYJaEDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:03:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYJaEDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:03:24 -0400
Date: Fri, 31 Oct 2008 00:03:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: [PATCH] ftrace: nmi safe code clean ups
In-Reply-To: <20081030141048.904c82e1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch cleans up the NMI safe code for dynamic ftrace as suggested
by Andrew Morton.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/arm/include/asm/ftrace.h     |    4 ++--
 arch/powerpc/include/asm/ftrace.h |    4 ++--
 arch/sh/include/asm/ftrace.h      |    4 ++--
 arch/sparc/include/asm/ftrace.h   |    4 ++--
 arch/x86/include/asm/ftrace.h     |   10 +++++-----
 arch/x86/kernel/ftrace.c          |   16 ++++++++--------
 include/linux/ftrace.h            |    3 +++
 kernel/trace/trace.c              |    9 ++++-----
 8 files changed, 28 insertions(+), 26 deletions(-)

Index: linux-tip.git/arch/arm/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/arm/include/asm/ftrace.h	2008-10-30 10:27:09.000000000 -0400
+++ linux-tip.git/arch/arm/include/asm/ftrace.h	2008-10-30 23:24:18.000000000 -0400
@@ -2,8 +2,8 @@
 #define _ASM_ARM_FTRACE
 
 #ifndef __ASSEMBLY__
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
Index: linux-tip.git/arch/powerpc/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/powerpc/include/asm/ftrace.h	2008-10-30 10:27:09.000000000 -0400
+++ linux-tip.git/arch/powerpc/include/asm/ftrace.h	2008-10-30 23:24:30.000000000 -0400
@@ -2,8 +2,8 @@
 #define _ASM_POWERPC_FTRACE
 
 #ifndef __ASSEMBLY__
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
Index: linux-tip.git/arch/sh/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/sh/include/asm/ftrace.h	2008-10-30 10:27:09.000000000 -0400
+++ linux-tip.git/arch/sh/include/asm/ftrace.h	2008-10-30 23:24:43.000000000 -0400
@@ -2,8 +2,8 @@
 #define __ASM_SH_FTRACE_H
 
 #ifndef __ASSEMBLY__
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
 
 #ifndef __ASSEMBLY__
Index: linux-tip.git/arch/sparc/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/sparc/include/asm/ftrace.h	2008-10-30 10:27:09.000000000 -0400
+++ linux-tip.git/arch/sparc/include/asm/ftrace.h	2008-10-30 23:24:50.000000000 -0400
@@ -2,8 +2,8 @@
 #define _ASM_SPARC64_FTRACE
 
 #ifndef __ASSEMBLY__
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
 
 #ifdef CONFIG_MCOUNT
Index: linux-tip.git/arch/x86/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/x86/include/asm/ftrace.h	2008-10-30 13:16:22.000000000 -0400
+++ linux-tip.git/arch/x86/include/asm/ftrace.h	2008-10-30 23:25:26.000000000 -0400
@@ -22,16 +22,16 @@ static inline unsigned long ftrace_call_
 extern void ftrace_nmi_enter(void);
 extern void ftrace_nmi_exit(void);
 #else
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
-#endif
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
+#endif /* __ASSEMBLY__ */
 
 #else /* CONFIG_FUNCTION_TRACER */
 
 #ifndef __ASSEMBLY__
-#define ftrace_nmi_enter()	do { } while (0)
-#define ftrace_nmi_exit()	do { } while (0)
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
 #endif
 
 #endif /* CONFIG_FUNCTION_TRACER */
Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-30 16:07:05.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-30 23:30:19.000000000 -0400
@@ -67,7 +67,7 @@ unsigned char *ftrace_call_replace(unsig
  *
  * Two buffers are added: An IP buffer and a "code" buffer.
  *
- * 1) Put in the instruction pointer into the IP buffer
+ * 1) Put the instruction pointer into the IP buffer
  *    and the new code into the "code" buffer.
  * 2) Set a flag that says we are modifying code
  * 3) Wait for any running NMIs to finish.
@@ -85,14 +85,14 @@ unsigned char *ftrace_call_replace(unsig
  * are the same as what exists.
  */
 
-static atomic_t in_nmi;
-static int mod_code_status;
-static int mod_code_write;
-static void *mod_code_ip;
-static void *mod_code_newcode;
+static atomic_t in_nmi = ATOMIC_INIT(0);
+static int mod_code_status;		/* holds return value of text write */
+static int mod_code_write;		/* set when NMI should do the write */
+static void *mod_code_ip;		/* holds the IP to write to */
+static void *mod_code_newcode;		/* holds the text to write to the IP */
 
-static int nmi_wait_count;
-static atomic_t nmi_update_count;
+static unsigned nmi_wait_count;
+static atomic_t nmi_update_count = ATOMIC_INIT(0);
 
 int ftrace_arch_read_dyn_info(char *buf, int size)
 {
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-10-30 10:27:07.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-10-30 23:31:33.000000000 -0400
@@ -74,6 +74,9 @@ extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
 
+/* May be defined in arch */
+extern int ftrace_arch_read_dyn_info(char *buf, int size);
+
 /**
  * ftrace_modify_code - modify code segment
  * @ip: the address of the code segment
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-30 16:07:05.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-30 23:33:41.000000000 -0400
@@ -2837,10 +2837,6 @@ static struct file_operations tracing_ma
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-#define DYN_INFO_BUF_SIZE 1023
-static char ftrace_dyn_info_buffer[DYN_INFO_BUF_SIZE+1];
-static DEFINE_MUTEX(dyn_info_mutex);
-
 int __weak ftrace_arch_read_dyn_info(char *buf, int size)
 {
 	return 0;
@@ -2850,14 +2846,17 @@ static ssize_t
 tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
+	static char ftrace_dyn_info_buffer[1024];
+	static DEFINE_MUTEX(dyn_info_mutex);
 	unsigned long *p = filp->private_data;
 	char *buf = ftrace_dyn_info_buffer;
+	int size = ARRAY_SIZE(ftrace_dyn_info_buffer);
 	int r;
 
 	mutex_lock(&dyn_info_mutex);
 	r = sprintf(buf, "%ld ", *p);
 
-	r += ftrace_arch_read_dyn_info(buf+r, DYN_INFO_BUF_SIZE-r);
+	r += ftrace_arch_read_dyn_info(buf+r, (size-1)-r);
 	buf[r++] = '\n';
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);


