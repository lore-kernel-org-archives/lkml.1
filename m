Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbYBHFHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbYBHFHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYBHFGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:06:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:30026 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYBHFGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pURMhvjwvJdoCXqo2+O6ZyZMsShBDMpRqCh2PVKvcWdHqAH+Y0MLwt+wOG0xwwH9ks/KEWrNC/fN+CHETtQtxBT5IfiKeqgdqgPlIEuRFMSKJxYJbNXz2VGFRvXLTvl9w7XO78KPki6Fhal/PreDRlaintutc0x5WrSa0euSVbM=
Subject: [PATCH 2/2] x86: regparm(3) is mandatory, no need to annotate
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:06:30 -0800
Message-Id: <1202447190.31361.42.camel@brick>
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

