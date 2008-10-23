Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYJWNlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYJWNlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYJWNhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYJWNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:26 -0400
Message-Id: <20081023133724.850682392@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 12/12 v3] ftrace: remove notrace from arch ftrace file
Content-Disposition: inline; filename=ftace-remove-notrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The entire file of ftrace.c in the arch code needs to be marked
as notrace. It is much cleaner to do this from the Makefile with
CFLAGS_REMOVE_ftrace.o.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   10 +++++-----
 arch/sparc64/kernel/Makefile |    2 ++
 arch/sparc64/kernel/ftrace.c |    8 ++++----
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/ftrace.c     |   10 +++++-----
 5 files changed, 17 insertions(+), 14 deletions(-)

Index: linux-compile.git/arch/powerpc/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/powerpc/kernel/ftrace.c	2008-10-22 16:07:55.000000000 -0400
+++ linux-compile.git/arch/powerpc/kernel/ftrace.c	2008-10-22 16:10:15.000000000 -0400
@@ -28,17 +28,17 @@ static unsigned int ftrace_nop = 0x60000
 #endif
 
 
-static unsigned int notrace ftrace_calc_offset(long ip, long addr)
+static unsigned int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static unsigned int op;
 
@@ -68,7 +68,7 @@ notrace unsigned char *ftrace_call_repla
 # define _ASM_PTR	" .long "
 #endif
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -113,7 +113,7 @@ ftrace_modify_code(unsigned long ip, uns
 	return faulted;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;
Index: linux-compile.git/arch/sparc64/kernel/Makefile
===================================================================
--- linux-compile.git.orig/arch/sparc64/kernel/Makefile	2008-10-21 17:07:17.000000000 -0400
+++ linux-compile.git/arch/sparc64/kernel/Makefile	2008-10-22 16:12:22.000000000 -0400
@@ -5,6 +5,8 @@
 EXTRA_AFLAGS := -ansi
 EXTRA_CFLAGS := -Werror
 
+CFLAGS_REMOVE_ftrace.o = -pg
+
 extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		:= process.o setup.o cpu.o idprom.o reboot.o \
Index: linux-compile.git/arch/sparc64/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/sparc64/kernel/ftrace.c	2008-10-22 16:08:45.000000000 -0400
+++ linux-compile.git/arch/sparc64/kernel/ftrace.c	2008-10-22 16:10:25.000000000 -0400
@@ -9,12 +9,12 @@
 
 static const u32 ftrace_nop = 0x01000000;
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static u32 call;
 	s32 off;
@@ -25,7 +25,7 @@ notrace unsigned char *ftrace_call_repla
 	return (unsigned char *) &call;
 }
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -59,7 +59,7 @@ ftrace_modify_code(unsigned long ip, uns
 	return faulted;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;
Index: linux-compile.git/arch/x86/kernel/Makefile
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/Makefile	2008-10-21 17:07:17.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/Makefile	2008-10-22 16:12:01.000000000 -0400
@@ -11,6 +11,7 @@ ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
 endif
 
 #
Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 16:07:55.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 16:10:33.000000000 -0400
@@ -33,17 +33,17 @@ union ftrace_code_union {
 };
 
 
-static int notrace ftrace_calc_offset(long ip, long addr)
+static int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
 
@@ -57,7 +57,7 @@ notrace unsigned char *ftrace_call_repla
 	return calc.code;
 }
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -90,7 +90,7 @@ ftrace_modify_code(unsigned long ip, uns
 	return 0;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;

-- 
