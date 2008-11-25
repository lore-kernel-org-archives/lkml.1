Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYKYVi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYKYVi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYKYVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:62506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYKYVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=hw7TZGz9CItbpBBiJ1HinOaWPkojNBDm3g3/eeo4+l3wUFCuo4PL9BRH97oQ7vkbbh
         O7Db4LbolKn6wijDAikyTd7lzd+gjAGFdptJDv8NdS6lk2KlqN9ArYsohWTjqqhrbUd1
         SA801qAnTgR/SR+61gSC4GdM8hBeOQ++sXYGU=
To: linux-kernel@vger.kernel.org
Subject: [patch 06/24] perfmon: generic x86 definitions (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:07 -0800 (PST)
Message-ID: <492c6fc7.15185e0a.156e.194b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions for the perfmon interrupt vector
and thread info flags. It is common to i386 and x86_64 code.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/include/asm/irq_vectors.h
===================================================================
--- o3.orig/arch/x86/include/asm/irq_vectors.h	2008-11-03 10:55:26.000000000 +0100
+++ o3/arch/x86/include/asm/irq_vectors.h	2008-11-03 10:56:12.000000000 +0100
@@ -87,6 +87,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * Perfmon PMU interrupt vector
+ */
+#define LOCAL_PERFMON_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: o3/arch/x86/include/asm/thread_info.h
===================================================================
--- o3.orig/arch/x86/include/asm/thread_info.h	2008-11-03 10:55:14.000000000 +0100
+++ o3/arch/x86/include/asm/thread_info.h	2008-11-03 10:58:10.000000000 +0100
@@ -79,6 +79,7 @@
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
+#define TIF_PERFMON_WORK	9	/* work for pfm_handle_work() */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
@@ -92,6 +93,7 @@
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+#define TIF_PERFMON_CTXSW	28	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -114,6 +116,8 @@
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -135,12 +139,12 @@
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERFMON_WORK)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
 	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS| \
-								_TIF_NOTSC)
+	 _TIF_NOTSC|_TIF_PERFMON_CTXSW)
 
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)

-- 

