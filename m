Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZK0Fuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZK0Fuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZK0Fut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:50:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:57950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZK0Fup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:50:45 -0500
Date: Fri, 27 Nov 2009 05:50:00 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <4B0CEBAF.6000104@cn.fujitsu.com>
References: <4B0CEBAF.6000104@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_kprobes: Always show group name
Message-ID: <tip-3d9b2e1ddf42dd3df38af7794fa5e39cce760f3b@git.kernel.org>
Git-Commit-ID: 3d9b2e1ddf42dd3df38af7794fa5e39cce760f3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d9b2e1ddf42dd3df38af7794fa5e39cce760f3b
Gitweb:     http://git.kernel.org/tip/3d9b2e1ddf42dd3df38af7794fa5e39cce760f3b
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Nov 2009 16:32:47 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:43:04 +0100

trace_kprobes: Always show group name

Sometimes the group name is not "kprobes",
It'll be better if we can read it from tracing/kprobe_events.

 # echo 'r:laijs/vfs_read vfs_read %ax' > kprobe_events
 # cat kprobe_events
 r:laijs/vfs_read vfs_read %ax=%ax

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0CEBAF.6000104@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 82e8583..96e1944 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -760,7 +760,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char buf[MAX_ARGSTR_LEN + 1];
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s", tp->call.name);
+	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
 
 	if (tp->symbol)
 		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
