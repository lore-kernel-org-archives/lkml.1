Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbZHZBjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbZHZBjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932843AbZHZBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:39:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:54708 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbZHZBjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dMQyslzmKVU0ssCQkVayE+rt+jieDSNwgjHGpbm8LccXZDqU0OWHi+viV+Wh7eWDQB
         NcjOreZs/MYhgaHhpyZbpylZFnb2p2HqLB5O4JqLRnpgqw0gfE5/NMnJraIAICWMh3no
         xhhVYQvdWN/Y+k+lYyD3DklWMqqH6vLEaYlKw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/4] tracing: Make syscall tracepoints conditional
Date: Wed, 26 Aug 2009 03:39:00 +0200
Message-Id: <1251250742-6458-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
References: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Stone <jistone@redhat.com>

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
-- 
1.6.2.3

