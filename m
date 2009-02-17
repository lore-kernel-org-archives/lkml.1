Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZBQSXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZBQSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZBQSVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182126.214630484@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/6] ftrace: show unlimited when traceon or traceoff has no counter
Content-Disposition: inline; filename=0006-ftrace-show-unlimited-when-traceon-or-traceoff-has.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The traceon and traceoff function probes are confusing to developers
to what happens when a counter is not specified. This should help
clear things up.

 # echo "*:traceoff" > set_ftrace_filter
 # cat /debug/tracing/set_ftrace_filter

  #### all functions enabled ####
  do_fork:traceoff:unlimited

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 6ea73ed..4c113a8 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -296,7 +296,9 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 	else
 		seq_printf(m, "traceoff");
 
-	if (count != -1)
+	if (count == -1)
+		seq_printf(m, ":unlimited\n");
+	else
 		seq_printf(m, ":count=%ld", count);
 	seq_putc(m, '\n');
 
-- 
1.5.6.5

-- 
