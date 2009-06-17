Return-Path: <linux-kernel-owner+w=401wt.eu-S1764546AbZFQJNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764546AbZFQJNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZFQJNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:13:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:46013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZFQJNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:13:45 -0400
Subject: [PATCH -tip] x86: hw_breakpoint.c arch_check_va_in_kernelspace and
 hw_breakpoint_handler should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:44:19 +0530
Message-Id: <1245230059.2662.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch_check_va_in_kernelspace() and hw_breakpoint_handler() is used only by same file so it should be static.

Also fixed non-ANSI function declaration of function 'arch_uninstall_thread_hw_breakpoint'

Fixed following sparse warnings :
  arch/x86/kernel/hw_breakpoint.c:124:42: warning: non-ANSI function declaration of function 'arch_uninstall_thread_hw_breakpoint'
  arch/x86/kernel/hw_breakpoint.c:169:5: warning: symbol 'arch_check_va_in_kernelspace' was not declared. Should it be static?
  arch/x86/kernel/hw_breakpoint.c:313:15: warning: symbol 'hw_breakpoint_handler' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 6945147..47869d8 100644
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
-- 
1.6.0.6



