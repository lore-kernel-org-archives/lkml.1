Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbZKYIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbZKYIdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZKYIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:33:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZKYIdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:33:09 -0500
Message-ID: <4B0CEBAF.6000104@cn.fujitsu.com>
Date: Wed, 25 Nov 2009 16:32:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] trace_kprobes: always show group name
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sometimes the group name is not "kprobes",
It'll be better if we can read it from tracing/kprobe_events.

# echo 'r:laijs/vfs_read vfs_read %ax' > kprobe_events
# cat kprobe_events
r:laijs/vfs_read vfs_read %ax=%ax

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 79ce6a2..9e42f2a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -758,7 +758,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char buf[MAX_ARGSTR_LEN + 1];
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s", tp->call.name);
+	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
 
 	if (tp->symbol)
 		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);


