Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZJEUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZJEUSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZJEUSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:18:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZJEUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:18:31 -0400
Subject: [PATCH][GIT PULL][v2.6.32] tracing: fix transposed numbers of
 lock_depth and preempt_count
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 16:14:13 -0400
Message-Id: <1254773653.13160.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: fix transposed numbers of lock_depth and preempt_count

----
 kernel/trace/trace_output.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)
---------------------------
commit c204d97eab2c888b2bc37d594dff8b48782d6af5
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sun Sep 27 07:02:07 2009 -0400

    tracing: fix transposed numbers of lock_depth and preempt_count
    
    The lock_depth and preempt_count numbers in the latency format is
    transposed.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cda766f..ed17565 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -486,16 +486,18 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
-	if (entry->lock_depth < 0)
-		ret = trace_seq_putc(s, '.');
+	if (entry->preempt_count)
+		ret = trace_seq_printf(s, "%x", entry->preempt_count);
 	else
-		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+		ret = trace_seq_putc(s, '.');
+
 	if (!ret)
 		return 0;
 
-	if (entry->preempt_count)
-		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_putc(s, '.');
+	if (entry->lock_depth < 0)
+		return trace_seq_putc(s, '.');
+
+	return trace_seq_printf(s, "%d", entry->lock_depth);
 }
 
 static int


