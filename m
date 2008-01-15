Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbYAOWWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbYAOWWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYAOWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:21:53 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19041 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbYAOWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:21:52 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Subject: [PATCH 3/4] RT: remove finish_arch_switch
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:20:46 -0800
Message-Id: <1200435646.4092.18.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:21:46.0801 (UTC) FILETIME=[040A3210:01C857C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

This is probably just a temporary workaround for one procssor - the MIPS
community will most likely want to architect a solution to this issue.

Make of preempt kernel barfs in kernel/sched.c ifdef finish_arch_switch.
Remove the finish_arch_switch() for boards with TX49xx MIPS processor.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/asm-mips/mach-tx49xx/cpu-feature-overrides.h |    7 	7 +	0 -	0 !
 include/asm-mips/system.h                            |    3 	3 +	0 -	0 !
 2 files changed, 10 insertions(+)

Index: linux-2.6.24-rc7/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
+++ linux-2.6.24-rc7/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
@@ -1,6 +1,13 @@
 #ifndef __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
 #define __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
 
+/* finish_arch_switch_empty is defined if we know finish_arch_switch() will
+ * be empty, based on the lack of features defined in this file.  This is
+ * needed because config preempt will barf in kernel/sched.c ifdef
+ * finish_arch_switch
+ */
+#define finish_arch_switch_empty
+
 #define cpu_has_llsc	1
 #define cpu_has_64bits	1
 #define cpu_has_inclusive_pcaches	0
Index: linux-2.6.24-rc7/include/asm-mips/system.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-mips/system.h
+++ linux-2.6.24-rc7/include/asm-mips/system.h
@@ -70,6 +70,8 @@ do {									\
 	(last) = resume(prev, next, task_thread_info(next));		\
 } while (0)
 
+/* preempt kernel barfs in kernel/sched.c ifdef finish_arch_switch */
+#ifndef finish_arch_switch_empty
 #define finish_arch_switch(prev)					\
 do {									\
 	if (cpu_has_dsp)						\
@@ -77,6 +79,7 @@ do {									\
 	if (cpu_has_userlocal)						\
 		write_c0_userlocal(current_thread_info()->tp_value);	\
 } while (0)
+#endif
 
 static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
 {



