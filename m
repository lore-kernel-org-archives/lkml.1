Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZKUNd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZKUNd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZKUNd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:33:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:41520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZKUNd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:33:58 -0500
Date: Sat, 21 Nov 2009 13:33:30 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, jaswinder@kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, jaswinder@kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1245230059.2662.4.camel@ht.satnam>
References: <1245230059.2662.4.camel@ht.satnam>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: hw_breakpoint.c arch_check_va_in_kernelspace and hw_breakpoint_handler should be static
Message-ID: <tip-4555835b707d5c778ee1c9076670bc99b1eeaf61@git.kernel.org>
Git-Commit-ID: 4555835b707d5c778ee1c9076670bc99b1eeaf61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4555835b707d5c778ee1c9076670bc99b1eeaf61
Gitweb:     http://git.kernel.org/tip/4555835b707d5c778ee1c9076670bc99b1eeaf61
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 17 Jun 2009 14:44:19 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:56:30 +0200

x86: hw_breakpoint.c arch_check_va_in_kernelspace and hw_breakpoint_handler should be static

arch_check_va_in_kernelspace() and hw_breakpoint_handler() is used only by same file so it should be static.

Also fixed non-ANSI function declaration of function 'arch_uninstall_thread_hw_breakpoint'

Fixed following sparse warnings :
  arch/x86/kernel/hw_breakpoint.c:124:42: warning: non-ANSI function declaration of function 'arch_uninstall_thread_hw_breakpoint'
  arch/x86/kernel/hw_breakpoint.c:169:5: warning: symbol 'arch_check_va_in_kernelspace' was not declared. Should it be static?
  arch/x86/kernel/hw_breakpoint.c:313:15: warning: symbol 'hw_breakpoint_handler' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1245230059.2662.4.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/hw_breakpoint.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 51d9595..9316a9d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -121,7 +121,7 @@ void arch_install_thread_hw_breakpoint(struct task_struct *tsk)
 /*
  * Install the debug register values for just the kernel, no thread.
  */
-void arch_uninstall_thread_hw_breakpoint()
+void arch_uninstall_thread_hw_breakpoint(void)
 {
 	/* Clear the user-space portion of debugreg7 by setting only kdr7 */
 	set_debugreg(kdr7, 7);
@@ -166,7 +166,7 @@ int arch_check_va_in_userspace(unsigned long va, u8 hbp_len)
 /*
  * Check for virtual address in kernel space.
  */
-int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
+static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 {
 	unsigned int len;
 
@@ -310,7 +310,7 @@ void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
  * NOTIFY_STOP returned for all other cases
  *
  */
-int __kprobes hw_breakpoint_handler(struct die_args *args)
+static int __kprobes hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct hw_breakpoint *bp;
