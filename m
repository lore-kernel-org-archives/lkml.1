Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZHMWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZHMWGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZHMWGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:06:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:48859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZHMWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:06:29 -0400
Date: Thu, 13 Aug 2009 22:05:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/core] tracing: Fix syscall tracing on !HAVE_FTRACE_SYSCALLS architectures
Message-ID: <tip-60d970c254b95ec7a0fc4c590b510253987b64a0@git.kernel.org>
Git-Commit-ID: 60d970c254b95ec7a0fc4c590b510253987b64a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 22:05:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60d970c254b95ec7a0fc4c590b510253987b64a0
Gitweb:     http://git.kernel.org/tip/60d970c254b95ec7a0fc4c590b510253987b64a0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 13 Aug 2009 23:37:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 23:38:20 +0200

tracing: Fix syscall tracing on !HAVE_FTRACE_SYSCALLS architectures

The new syscall_regfunc()/unregfunc() functions rely on
the existence of TIF_SYSCALL_FTRACE - but that TIF flag
is only offered by HAVE_FTRACE_SYSCALLS.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/tracepoint.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 070a42b..35dd27a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -579,6 +579,8 @@ __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+
 static DEFINE_MUTEX(regfunc_mutex);
 static int sys_tracepoint_refcount;
 
@@ -615,3 +617,4 @@ void syscall_unregfunc(void)
 	}
 	mutex_unlock(&regfunc_mutex);
 }
+#endif
