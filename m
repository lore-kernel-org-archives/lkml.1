Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZF2JQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZF2JQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZF2JQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:16:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62128 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZF2JQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:16:13 -0400
Message-ID: <4A488667.6040004@cn.fujitsu.com>
Date: Mon, 29 Jun 2009 17:16:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/syscall: remove redundant code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call trace_wake_up() explicitly because it's called
in trace_current_buffer_unlock_commit().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/trace_syscalls.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e57964..dd1ce2c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -168,7 +168,6 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
 	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
 }
 
 void ftrace_syscall_exit(struct pt_regs *regs)
@@ -194,7 +193,6 @@ void ftrace_syscall_exit(struct pt_regs *regs)
 	entry->ret = syscall_get_return_value(current, regs);
 
 	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
 }
 
 static int init_syscall_tracer(struct trace_array *tr)
-- 
1.6.1.2

