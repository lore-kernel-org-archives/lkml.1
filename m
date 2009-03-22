Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZCVOU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZCVOU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZCVOUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:20:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:44897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZCVOUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:20:34 -0400
Date: Sun, 22 Mar 2009 14:19:55 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
References: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/ftrace] tracing: keep the tracing buffer after self-test failure
Message-ID: <tip-0cf53ff62b3e9e491ff5e5f05b193fb6ce643047@git.kernel.org>
Git-Commit-ID: 0cf53ff62b3e9e491ff5e5f05b193fb6ce643047
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 14:19:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cf53ff62b3e9e491ff5e5f05b193fb6ce643047
Gitweb:     http://git.kernel.org/tip/0cf53ff62b3e9e491ff5e5f05b193fb6ce643047
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 15:13:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 15:17:21 +0100

tracing: keep the tracing buffer after self-test failure

Instead of using ftrace_dump_on_oops, it's far more convenient
to have the trace leading up to a self-test failure available
in /debug/tracing/trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237694675-23509-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_selftest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index b56dcf7..08f4eb2 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -299,7 +299,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 
 	/* Have we just recovered from a hang? */
 	if (graph_hang_thresh > GRAPH_MAX_FUNC_TEST) {
-		trace->reset(tr);
+		tracing_selftest_disabled = true;
 		ret = -1;
 		goto out;
 	}
