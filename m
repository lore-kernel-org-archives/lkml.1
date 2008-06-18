Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYFRLmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYFRLmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYFRLlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:41:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26435 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYFRLlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:41:52 -0400
Message-Id: <485910B3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 12:42:11 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: remove unnecessary ptregs call stubs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the ptregs call stubs are superfluous these days - the called
functions don't have a trailing 'struct pt_regs *' parameter anymore.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/ia32/ia32entry.S   |    6 ++----
 arch/x86/kernel/entry_64.S  |    1 -
 include/asm-x86/unistd_64.h |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- linux-2.6.26-rc6/arch/x86/ia32/ia32entry.S	2008-06-18 12:49:29.000000000 +0200
+++ 2.6.26-rc6-x86_64-remove-ptregs-stubs/arch/x86/ia32/ia32entry.S	2008-06-11 12:26:13.000000000 +0200
@@ -370,13 +370,11 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn, %rdi
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn, %rdi
 	PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
-	PTREGSCALL stub32_sigsuspend, sys32_sigsuspend, %rcx
 	PTREGSCALL stub32_execve, sys32_execve, %rcx
 	PTREGSCALL stub32_fork, sys_fork, %rdi
 	PTREGSCALL stub32_clone, sys32_clone, %rdx
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
-	PTREGSCALL stub32_rt_sigsuspend, sys_rt_sigsuspend, %rdx
 
 ENTRY(ia32_ptregs_common)
 	popq %r11
@@ -476,7 +474,7 @@ ia32_sys_call_table:
 	.quad sys_ssetmask
 	.quad sys_setreuid16	/* 70 */
 	.quad sys_setregid16
-	.quad stub32_sigsuspend
+	.quad sys32_sigsuspend
 	.quad compat_sys_sigpending
 	.quad sys_sethostname
 	.quad compat_sys_setrlimit	/* 75 */
@@ -583,7 +581,7 @@ ia32_sys_call_table:
 	.quad sys32_rt_sigpending
 	.quad compat_sys_rt_sigtimedwait
 	.quad sys32_rt_sigqueueinfo
-	.quad stub32_rt_sigsuspend
+	.quad sys_rt_sigsuspend
 	.quad sys32_pread		/* 180 */
 	.quad sys32_pwrite
 	.quad sys_chown16
--- linux-2.6.26-rc6/arch/x86/kernel/entry_64.S	2008-06-18 12:49:29.000000000 +0200
+++ 2.6.26-rc6-x86_64-remove-ptregs-stubs/arch/x86/kernel/entry_64.S	2008-06-11 12:24:52.000000000 +0200
@@ -420,7 +420,6 @@ END(\label)
 	PTREGSCALL stub_clone, sys_clone, %r8
 	PTREGSCALL stub_fork, sys_fork, %rdi
 	PTREGSCALL stub_vfork, sys_vfork, %rdi
-	PTREGSCALL stub_rt_sigsuspend, sys_rt_sigsuspend, %rdx
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
 
--- linux-2.6.26-rc6/include/asm-x86/unistd_64.h	2008-06-18 12:49:47.000000000 +0200
+++ 2.6.26-rc6-x86_64-remove-ptregs-stubs/include/asm-x86/unistd_64.h	2008-06-11 12:29:56.000000000 +0200
@@ -290,7 +290,7 @@ __SYSCALL(__NR_rt_sigtimedwait, sys_rt_s
 #define __NR_rt_sigqueueinfo			129
 __SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
 #define __NR_rt_sigsuspend			130
-__SYSCALL(__NR_rt_sigsuspend, stub_rt_sigsuspend)
+__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend)
 #define __NR_sigaltstack			131
 __SYSCALL(__NR_sigaltstack, stub_sigaltstack)
 #define __NR_utime				132



