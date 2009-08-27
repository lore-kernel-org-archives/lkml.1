Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbZH0Cc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbZH0Cc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZH0Ccz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:55 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbZH0Ccw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=GRGAYrWl5APNjO5ew+H2X82mmZNJ8ZAGXMwR1ndVU4wv8nR+1uBgn9GF/Z1pw9aqdi
         pFq9vUPnBOP16NK0akfnNptAjfiZDroJPu9sjlswuj9gWwqWiu2VLGq+k1IwTbAAz+m9
         8ZDhDMltvipMifs6PhI7ua5T6WulRmIDTAXMk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/18] tracing: Add kprobes event profiling interface
Date: Thu, 27 Aug 2009 04:32:12 +0200
Message-Id: <1251340337-5640-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add profiling interfaces for each kprobes event. This interface provides
how many times each probe hit or missed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
LKML-Reference: <20090813203541.31965.8452.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |    8 ++++++
 kernel/trace/trace_kprobe.c         |   43 +++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 5e59e85..3de7517 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -70,6 +70,14 @@ filter:
  names and field names for describing filters.
 
 
+Event Profiling
+---------------
+ You can check the total number of probe hits and probe miss-hits via
+/sys/kernel/debug/tracing/kprobe_profile.
+ The first column is event name, the second is the number of probe hits,
+the third is the number of probe miss-hits.
+
+
 Usage examples
 --------------
 To add a probe as a new event, write a new definition to kprobe_events
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9c067bf..ce68197 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -184,6 +184,7 @@ struct trace_probe {
 		struct kprobe		kp;
 		struct kretprobe	rp;
 	};
+	unsigned long 		nhit;
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
 	struct trace_event		event;
@@ -781,6 +782,37 @@ static const struct file_operations kprobe_events_ops = {
 	.write		= probes_write,
 };
 
+/* Probes profiling interfaces */
+static int probes_profile_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_probe *tp = v;
+
+	seq_printf(m, "  %-44s %15lu %15lu\n", tp->call.name, tp->nhit,
+		   probe_is_return(tp) ? tp->rp.kp.nmissed : tp->kp.nmissed);
+
+	return 0;
+}
+
+static const struct seq_operations profile_seq_op = {
+	.start  = probes_seq_start,
+	.next   = probes_seq_next,
+	.stop   = probes_seq_stop,
+	.show   = probes_profile_seq_show
+};
+
+static int profile_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &profile_seq_op);
+}
+
+static const struct file_operations kprobe_profile_ops = {
+	.owner          = THIS_MODULE,
+	.open           = profile_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
 /* Kprobe handler */
 static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
@@ -791,6 +823,8 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
+	tp->nhit++;
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -1140,9 +1174,18 @@ static __init int init_kprobe_trace(void)
 	entry = debugfs_create_file("kprobe_events", 0644, d_tracer,
 				    NULL, &kprobe_events_ops);
 
+	/* Event list interface */
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'kprobe_events' entry\n");
+
+	/* Profile interface */
+	entry = debugfs_create_file("kprobe_profile", 0444, d_tracer,
+				    NULL, &kprobe_profile_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'kprobe_profile' entry\n");
 	return 0;
 }
 fs_initcall(init_kprobe_trace);
-- 
1.6.2.3

