Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZJQKAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZJQKAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZJQKAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:00:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:36309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZJQKAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:00:12 -0400
Date: Sat, 17 Oct 2009 09:59:21 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090910235314.22412.64631.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235314.22412.64631.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Fix probe offset to be unsigned
Message-ID: <tip-2fba0c8867af47f6455490e7b59e512dd180c027@git.kernel.org>
Git-Commit-ID: 2fba0c8867af47f6455490e7b59e512dd180c027
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:59:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fba0c8867af47f6455490e7b59e512dd180c027
Gitweb:     http://git.kernel.org/tip/2fba0c8867af47f6455490e7b59e512dd180c027
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 10 Sep 2009 19:53:14 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 11 Sep 2009 04:18:58 +0200

tracing/kprobes: Fix probe offset to be unsigned

Prohibit user to specify negative offset from symbols.
Since kprobe.offset is unsigned int, the offset must be always positive
value.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090910235314.22412.64631.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |   14 +++++++-------
 kernel/trace/trace_kprobe.c         |   19 +++++++------------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 3de7517..db55318 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -25,15 +25,15 @@ probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
 
 Synopsis of kprobe_events
 -------------------------
-  p[:EVENT] SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: Set a probe
-  r[:EVENT] SYMBOL[+0] [FETCHARGS]			: Set a return probe
+  p[:EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
+  r[:EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
 
- EVENT			: Event name. If omitted, the event name is generated
-			  based on SYMBOL+offs or MEMADDR.
- SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
- MEMADDR		: Address where the probe is inserted.
+ EVENT		: Event name. If omitted, the event name is generated
+		  based on SYMBOL+offs or MEMADDR.
+ SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
+ MEMADDR	: Address where the probe is inserted.
 
- FETCHARGS		: Arguments. Each probe can have up to 128 args.
+ FETCHARGS	: Arguments. Each probe can have up to 128 args.
   %REG	: Fetch register REG
   sN	: Fetch Nth entry of stack (N >= 0)
   sa	: Fetch stack address.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 19a6de6..c24b7e9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -210,7 +210,7 @@ static __kprobes const char *probe_symbol(struct trace_probe *tp)
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
-static __kprobes long probe_offset(struct trace_probe *tp)
+static __kprobes unsigned int probe_offset(struct trace_probe *tp)
 {
 	return (probe_is_return(tp)) ? tp->rp.kp.offset : tp->kp.offset;
 }
@@ -380,7 +380,7 @@ end:
 }
 
 /* Split symbol and offset. */
-static int split_symbol_offset(char *symbol, long *offset)
+static int split_symbol_offset(char *symbol, unsigned long *offset)
 {
 	char *tmp;
 	int ret;
@@ -389,16 +389,11 @@ static int split_symbol_offset(char *symbol, long *offset)
 		return -EINVAL;
 
 	tmp = strchr(symbol, '+');
-	if (!tmp)
-		tmp = strchr(symbol, '-');
-
 	if (tmp) {
 		/* skip sign because strict_strtol doesn't accept '+' */
-		ret = strict_strtol(tmp + 1, 0, offset);
+		ret = strict_strtoul(tmp + 1, 0, offset);
 		if (ret)
 			return ret;
-		if (*tmp == '-')
-			*offset = -(*offset);
 		*tmp = '\0';
 	} else
 		*offset = 0;
@@ -520,7 +515,7 @@ static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p[:EVENT] SYMBOL[+OFFS|-OFFS]|ADDRESS [FETCHARGS]
+	 *  - Add kprobe: p[:EVENT] SYMBOL[+OFFS]|ADDRESS [FETCHARGS]
 	 *  - Add kretprobe: r[:EVENT] SYMBOL[+0] [FETCHARGS]
 	 * Fetch args:
 	 *  aN	: fetch Nth of function argument. (N:0-)
@@ -539,7 +534,7 @@ static int create_trace_probe(int argc, char **argv)
 	int i, ret = 0;
 	int is_return = 0;
 	char *symbol = NULL, *event = NULL;
-	long offset = 0;
+	unsigned long offset = 0;
 	void *addr = NULL;
 
 	if (argc < 2)
@@ -605,7 +600,7 @@ static int create_trace_probe(int argc, char **argv)
 
 	if (tp->symbol) {
 		kp->symbol_name = tp->symbol;
-		kp->offset = offset;
+		kp->offset = (unsigned int)offset;
 	} else
 		kp->addr = addr;
 
@@ -675,7 +670,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	seq_printf(m, ":%s", tp->call.name);
 
 	if (tp->symbol)
-		seq_printf(m, " %s%+ld", probe_symbol(tp), probe_offset(tp));
+		seq_printf(m, " %s+%u", probe_symbol(tp), probe_offset(tp));
 	else
 		seq_printf(m, " 0x%p", probe_address(tp));
 
