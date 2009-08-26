Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZHZHWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZHZHWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZHZHWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:22:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:46752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbZHZHWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:22:49 -0400
Date: Wed, 26 Aug 2009 07:21:53 GMT
From: tip-bot for Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, jiayingz@google.com,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, jistone@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mbligh@google.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       peterz@infradead.org, jistone@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu, mbligh@google.com
In-Reply-To: <1251150194-1713-3-git-send-email-jistone@redhat.com>
References: <1251150194-1713-3-git-send-email-jistone@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Make syscall tracepoints conditional
Message-ID: <tip-3d27d8cb34fc156beb86de2338ca4029873a5cc6@git.kernel.org>
Git-Commit-ID: 3d27d8cb34fc156beb86de2338ca4029873a5cc6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 07:21:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d27d8cb34fc156beb86de2338ca4029873a5cc6
Gitweb:     http://git.kernel.org/tip/3d27d8cb34fc156beb86de2338ca4029873a5cc6
Author:     Josh Stone <jistone@redhat.com>
AuthorDate: Mon, 24 Aug 2009 14:43:12 -0700
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 00:24:19 +0200

tracing: Make syscall tracepoints conditional

The syscall enter/exit tracepoints are only supported on archs that
HAVE_SYSCALL_TRACEPOINTS, so the declarations should be #ifdef'ed.
Also, the definition of syscall_regfunc and syscall_unregfunc should
depend on this same config, rather than the ftrace-specific one.

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
LKML-Reference: <1251150194-1713-3-git-send-email-jistone@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


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
index be86b9a..9e0a36f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -576,7 +576,7 @@ __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
 
-#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
 static DEFINE_MUTEX(regfunc_mutex);
 static int sys_tracepoint_refcount;
