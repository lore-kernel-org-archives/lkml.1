Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbZDQBCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbZDQBCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760652AbZDQBBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:01:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbZDQBBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:01:51 -0400
Date: Fri, 17 Apr 2009 03:01:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090417010145.GA7394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Zhaolei (2):
      tracing: Fix power tracer header
      tracing: Fix branch tracer header


 kernel/trace/trace_branch.c |    8 ++++++++
 kernel/trace/trace_power.c  |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index ad8c22e..8333715 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -155,6 +155,13 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
+static void branch_print_header(struct seq_file *s)
+{
+	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
+		"  FUNC:FILE:LINE\n");
+	seq_puts(s, "#              | |       |          |         |   "
+		"    |\n");
+}
 
 static struct trace_event trace_branch_event = {
 	.type		= TRACE_BRANCH,
@@ -169,6 +176,7 @@ static struct tracer branch_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_branch,
 #endif /* CONFIG_FTRACE_SELFTEST */
+	.print_header	= branch_print_header,
 };
 
 __init static int init_branch_tracer(void)
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index bae791e..1184397 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -186,6 +186,12 @@ static enum print_line_t power_print_line(struct trace_iterator *iter)
 	return TRACE_TYPE_UNHANDLED;
 }
 
+static void power_print_header(struct seq_file *s)
+{
+	seq_puts(s, "#   TIMESTAMP      STATE  EVENT\n");
+	seq_puts(s, "#       |            |      |\n");
+}
+
 static struct tracer power_tracer __read_mostly =
 {
 	.name		= "power",
@@ -194,6 +200,7 @@ static struct tracer power_tracer __read_mostly =
 	.stop		= stop_power_trace,
 	.reset		= power_trace_reset,
 	.print_line	= power_print_line,
+	.print_header	= power_print_header,
 };
 
 static int init_power_trace(void)
