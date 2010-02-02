Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0BBVVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:21:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0BBVVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:21:52 -0500
Date: Tue, 2 Feb 2010 16:21:38 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Message-Id: <219418520c3fd7c2cef8c5d8ef62b3e716125414.1265142153.git.jbaron@redhat.com>
In-Reply-To: <cover.1265142153.git.jbaron@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com>
Subject: [PATCH 1/6] x86: add NR_syscalls_compat, make ia32 syscall table visible
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'NR_syscalls_compat' global for x86. Also, make 'ia32_sys_call_table' into a global.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/ia32/ia32entry.S     |    3 +++
 arch/x86/include/asm/compat.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 53147ad..acc6fbf 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -503,6 +503,7 @@ END(ia32_ptregs_common)
 
 	.section .rodata,"a"
 	.align 8
+.globl ia32_sys_call_table
 ia32_sys_call_table:
 	.quad sys_restart_syscall
 	.quad sys_exit
@@ -843,3 +844,5 @@ ia32_sys_call_table:
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
 ia32_syscall_end:
+.globl NR_syscalls_compat
+NR_syscalls_compat: .int ((ia32_syscall_end - ia32_sys_call_table)/8)
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 9a9c7bd..b5b78e6 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -215,4 +215,6 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
 
+extern int NR_syscalls_compat;
+
 #endif /* _ASM_X86_COMPAT_H */
-- 
1.6.5.1

