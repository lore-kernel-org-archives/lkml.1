Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbZKZHuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbZKZHuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZKZHuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:50:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZKZHuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:50:21 -0500
Message-ID: <4B0E330D.1070206@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:49:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_syscalls: add missed field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Field syscall number is missed in syscall_enter_define_fields()/
syscall_exit_define_fields().

syscall number is also needed for event filter or other users.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9189cbe..63aa807 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -261,6 +261,10 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
+	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < meta->nb_args; i++) {
 		ret = trace_define_field(call, meta->types[i],
 					 meta->args[i], offset,
@@ -281,6 +285,10 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
+	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
+	if (ret)
+		return ret;
+
 	ret = trace_define_field(call, SYSCALL_FIELD(long, ret),
 				 FILTER_OTHER);
 


