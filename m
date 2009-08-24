Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZHXVnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZHXVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZHXVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZHXVnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:42 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v4 2/4] tracing: Make syscall tracepoints conditional
Date: Mon, 24 Aug 2009 14:43:12 -0700
Message-Id: <1251150194-1713-3-git-send-email-jistone@redhat.com>
In-Reply-To: <1251150194-1713-2-git-send-email-jistone@redhat.com>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com>
 <1251150194-1713-1-git-send-email-jistone@redhat.com>
 <1251150194-1713-2-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall enter/exit tracepoints are only supported on archs that
HAVE_SYSCALL_TRACEPOINTS, so the declarations should be #ifdef'ed.
Also, the definition of syscall_regfunc and syscall_unregfunc need the
should use this same flag, rather than the ftrace-specific one.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/trace/syscall.h |    4 ++++
 kernel/tracepoint.c     |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 9661dd4..5dcb7e3 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -8,6 +8,8 @@
 #include <asm/ptrace.h>
 
 
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
+
 extern void syscall_regfunc(void);
 extern void syscall_unregfunc(void);
 
@@ -25,6 +27,8 @@ DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
 	syscall_unregfunc
 );
 
+#endif
+
 /*
  * A syscall entry in the ftrace syscalls array.
  *
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 43bca1f..6c2e12c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -579,7 +579,7 @@ __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
 
-#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
 static DEFINE_MUTEX(regfunc_mutex);
 static int sys_tracepoint_refcount;
-- 
1.6.2.5

