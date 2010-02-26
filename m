Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966244Ab0BZVh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966192Ab0BZVh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:37:56 -0500
Date: Fri, 26 Feb 2010 16:37:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <5e34f7a5b0e845156fb3cd66be67c7c1bf1e2844.1267214186.git.jbaron@redhat.com>
In-Reply-To: <cover.1267214186.git.jbaron@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com>
Subject: [PATCH 02/12] x86: add arch_compat_syscall_addr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch_compat_syscall_addr(int nr) for x86_64. This is in preparation for adding
compat syscall support to the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/ftrace.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cd37469..3ee2f46 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -510,3 +510,14 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+extern unsigned long *ia32_sys_call_table;
+
+#ifdef CONFIG_COMPAT
+unsigned long __init arch_compat_syscall_addr(int nr)
+{
+	return (unsigned long)(&ia32_sys_call_table)[nr];
+}
+#endif
+#endif
-- 
1.6.5.1

