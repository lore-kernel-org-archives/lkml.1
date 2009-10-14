Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbZJNTrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbZJNTrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbZJNTrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:47:02 -0400
Received: from [71.74.56.122] ([71.74.56.122]:54327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759710AbZJNTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:59 -0400
Message-Id: <20091014194359.790221427@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/13] [PATCH 10/13] perf tools: handle both versions of ftrace output
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0010-perf-tools-handle-both-versions-of-ftrace-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ftrace output events can have either arguments or no arguments.
The parser needs to be able to handle both.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 5f64644..6c3cb0a 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1819,7 +1819,7 @@ static int event_read_print(struct event *event)
 	if (ret < 0)
 		return -1;
 
-	return 0;
+	return ret;
 
  fail:
 	free_token(token);
@@ -3088,6 +3088,9 @@ int parse_ftrace_file(char *buf, unsigned long size)
 	if (ret < 0)
 		die("failed to read ftrace event print fmt");
 
+	/* New ftrace handles args */
+	if (ret > 0)
+		return 0;
 	/*
 	 * The arguments for ftrace files are parsed by the fields.
 	 * Set up the fields as their arguments.
-- 
1.6.3.3


