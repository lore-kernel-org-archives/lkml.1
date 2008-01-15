Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYAOMrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYAOMrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAOMrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:47:41 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48295 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYAOMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:47:40 -0500
Date: Tue, 15 Jan 2008 13:47:39 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: mingo@elte.hu
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: minor cleanup for ptrace_32/64
Message-ID: <Pine.LNX.4.64.0801151336570.30034@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit abd7e7b7e05f8af290e7a7e6c5f3cbb57192523a
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 15 03:31:39 2008 +0100

    x86: minor cleanup
    
    - let get_stack_long from ptrace_32 use long (not int) for consistency
    - make put_stack_long() return void (return value not used anywhere)
    - add const keyword to args
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index ff5431c..339a1fa 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -57,13 +57,14 @@ static inline struct pt_regs *get_child_regs(struct task_struct *task)
  * This routine assumes that all the privileged stacks are in our
  * data space.
  */   
-static inline int get_stack_long(struct task_struct *task, int offset)
+static inline unsigned long
+get_stack_long(const struct task_struct *task, int offset)
 {
 	unsigned char *stack;
 
 	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
 	stack += offset;
-	return (*((int *)stack));
+	return *(unsigned long *)stack;
 }
 
 /*
@@ -72,7 +73,7 @@ static inline int get_stack_long(struct task_struct *task, int offset)
  * This routine assumes that all the privileged stacks are in our
  * data space.
  */
-static inline int put_stack_long(struct task_struct *task, int offset,
+static inline void put_stack_long(const struct task_struct *task, int offset,
 	unsigned long data)
 {
 	unsigned char * stack;
@@ -80,7 +81,6 @@ static inline int put_stack_long(struct task_struct *task, int offset,
 	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
 	stack += offset;
 	*(unsigned long *) stack = data;
-	return 0;
 }
 
 static int putreg(struct task_struct *child,
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 607085f..b60ed76 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -56,13 +56,14 @@
  * this routine assumes that all the privileged stacks are in our
  * data space.
  */   
-static inline unsigned long get_stack_long(struct task_struct *task, int offset)
+static inline unsigned long
+get_stack_long(const struct task_struct *task, int offset)
 {
 	unsigned char *stack;
 
 	stack = (unsigned char *)task->thread.rsp0;
 	stack += offset;
-	return (*((unsigned long *)stack));
+	return *(unsigned long *)stack;
 }
 
 /*
@@ -71,7 +72,7 @@ static inline unsigned long get_stack_long(struct task_struct *task, int offset)
  * this routine assumes that all the privileged stacks are in our
  * data space.
  */
-static inline long put_stack_long(struct task_struct *task, int offset,
+static inline void put_stack_long(const struct task_struct *task, int offset,
 	unsigned long data)
 {
 	unsigned char * stack;
@@ -79,7 +80,6 @@ static inline long put_stack_long(struct task_struct *task, int offset,
 	stack = (unsigned char *) task->thread.rsp0;
 	stack += offset;
 	*(unsigned long *) stack = data;
-	return 0;
 }
 
 #define LDT_SEGMENT 4


