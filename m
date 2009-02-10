Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZBJSon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZBJSon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZBJSoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:44:32 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56226 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbZBJSo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:44:29 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/3] trace: fix sparse warnings: make symbols static
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 19:44:12 +0100
Message-ID: <20090210184357.28131.39458.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
References: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make global variables and a global function static

The function '__trace_userstack' does not seem to have a caller, so it
is commented out.

Fix this sparse warnings:
  kernel/trace/trace.c:82:5: warning: symbol 'tracing_disabled' was not declared. Should it be static?
  kernel/trace/trace.c:600:10: warning: symbol 'trace_record_cmdline_disabled' was not declared. Should it be static?
  kernel/trace/trace.c:957:6: warning: symbol '__trace_userstack' was not declared. Should it be static?
  kernel/trace/trace.c:1694:5: warning: symbol 'tracing_release' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/trace/trace.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef4dbac..0e7c84f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -79,7 +79,7 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
  * of the tracer is successful. But that is the only place that sets
  * this back to zero.
  */
-int tracing_disabled = 1;
+static int tracing_disabled = 1;
 
 static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
@@ -597,7 +597,7 @@ static int cmdline_idx;
 static DEFINE_SPINLOCK(trace_cmdline_lock);
 
 /* temporary disable recording */
-atomic_t trace_record_cmdline_disabled __read_mostly;
+static atomic_t trace_record_cmdline_disabled __read_mostly;
 
 static void trace_init_cmdlines(void)
 {
@@ -954,10 +954,12 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 #endif
 }
 
-void __trace_userstack(struct trace_array *tr, unsigned long flags)
+#ifdef UNUSED
+static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 {
 	ftrace_trace_userstack(tr, flags, preempt_count());
 }
+#endif /* UNUSED */
 
 static void
 ftrace_trace_special(void *__tr,
@@ -1691,7 +1693,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-int tracing_release(struct inode *inode, struct file *file)
+static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct trace_iterator *iter = m->private;

