Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZLIHQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZLIHQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZLIHQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:16:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZLIHQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:16:04 -0500
Message-ID: <4B1F4E8C.7030504@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/10] trace_syscalls: use agian init_syscall_trace()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_syscall needs a different ->raw_init().
init_syscall_trace() will be not the same as trace_event_raw_init().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6b5985b..72a762c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -144,7 +144,7 @@ struct perf_event_attr;
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
@@ -165,7 +165,7 @@ struct perf_event_attr;
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\

