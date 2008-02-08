Return-Path: <linux-kernel-owner+w=401wt.eu-S935384AbYBHUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384AbYBHUNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935021AbYBHUNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbYBHUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qqzu11KIKPLJk7Q6aF2N5bZwguqAS4Qbr2jO7+dYM5+CVbHqqUyAL+KgIVpF9FFbJt5UqLmCFABiw6x0KZ+hKl5vD3i9TwXmrYQ6DhBWAjxPV0L2R/Gu2zVS3tAfMKBvAjW8/rPuAjQOKeOE3jnIRRMAVylorSJ7BVGOz4iOj54=
Subject: [PATCH 3/9] x86: regparm(3) is mandatory, no need to annotate
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:09:57 -0800
Message-Id: <1202501398.12966.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions in ptrace.c and signal_32.c were defined with __attribute(regparm(3))
which is unnecessary now that X86_32 must compile this way.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/ptrace.c    |    1 -
 arch/x86/kernel/signal_32.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 702c33e..2e785d5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1426,7 +1426,6 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 /* notification of system call entry/exit
  * - triggered by current->work.syscall_trace
  */
-__attribute__((regparm(3)))
 int do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
 	int is_sysemu = test_thread_flag(TIF_SYSCALL_EMU);
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index c1f4ff7..a99529e 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -654,7 +654,6 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-__attribute__((regparm(3)))
 void do_notify_resume(struct pt_regs *regs, void *_unused,
 		      __u32 thread_info_flags)
 {
-- 
1.5.4.1219.g65b9


