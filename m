Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0BBVV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:21:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab0BBVVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:21:54 -0500
Date: Tue, 2 Feb 2010 16:21:42 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Message-Id: <a692e245543afa7e505611e4663e7e3be9c85dbd.1265142153.git.jbaron@redhat.com>
In-Reply-To: <cover.1265142153.git.jbaron@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com>
Subject: [PATCH 2/6] x86: add arch_compat_syscall_addr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch_compat_syscall_addr(int nr) for x86. This is in preparation for adding
compat syscall support to the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/ftrace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3096892..da2568c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -488,9 +488,18 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 extern unsigned long *sys_call_table;
+extern unsigned long *ia32_sys_call_table;
 
 unsigned long __init arch_syscall_addr(int nr)
 {
 	return (unsigned long)(&sys_call_table)[nr];
 }
+
+#ifdef CONFIG_COMPAT
+unsigned long __init arch_compat_syscall_addr(int nr)
+{
+	return (unsigned long)(&ia32_sys_call_table)[nr];
+}
+#endif
+
 #endif
-- 
1.6.5.1

