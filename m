Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYJQPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYJQPHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYJQPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:46066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbYJQPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=x2/JyvWvpCPGbXCheB4AF7xeT+rhR5PJdx0jCLQuOLFP5jFq43Zk1Ji93vMqenQabb
         nlNiat0liq+dzVlCSCAF8pXEHLQLnUVeQpaWzCxFojSglK0P+IfPa2fiLmf61S7obcPu
         1vdSoBAxHZdxhHhQRq9DNM5w0THUhwLoHhTYI=
To: linux-kernel@vger.kernel.org
Subject: [patch 06/24] perfmon3:  generic x86 definitions
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:22 -0700 (PDT)
Message-ID: <48f8a9b2.0437560a.655a.6376@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions for the perfmon interrupt vector
and thread info flags. It is common to i386 and x86_64 code.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/include/asm-x86/irq_vectors.h
===================================================================
--- o3.orig/include/asm-x86/irq_vectors.h	2008-10-10 14:54:58.000000000 +0200
+++ o3/include/asm-x86/irq_vectors.h	2008-10-10 14:56:55.000000000 +0200
@@ -92,6 +92,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * PERfmon PMU interrupt vector
+ */
+#define LOCAL_PERFMON_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: o3/include/asm-x86/thread_info.h
===================================================================
--- o3.orig/include/asm-x86/thread_info.h	2008-10-10 14:54:58.000000000 +0200
+++ o3/include/asm-x86/thread_info.h	2008-10-10 16:21:36.000000000 +0200
@@ -71,6 +71,7 @@
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_PERFMON_WORK	1	/* work for pfm_handle_work() */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -91,6 +92,7 @@
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+#define TIF_PERFMON_CTXSW	28	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -112,6 +114,8 @@
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -133,12 +137,12 @@
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERFMON_WORK)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
 	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS| \
-								_TIF_NOTSC)
+	 _TIF_NOTSC|_TIF_PERFMON_CTXSW)
 
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)

-- 

