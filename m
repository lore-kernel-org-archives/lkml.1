Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbZJNTrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbZJNTrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759580AbZJNTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:53 -0400
Received: from [71.74.56.122] ([71.74.56.122]:56493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759478AbZJNTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:49 -0400
Message-Id: <20091014194358.637991808@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/13] [PATCH 06/13] perf tools: handle newlines in trace parsing better
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0006-perf-tools-handle-newlines-in-trace-parsing-better.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

New lines between args in the trace format can break the parsing.
This should not be the case.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8c86f1..5dba81d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1716,12 +1716,18 @@ process_arg_token(struct event *event, struct print_arg *arg,
 
 static int event_read_print_args(struct event *event, struct print_arg **list)
 {
-	enum event_type type;
+	enum event_type type = EVENT_ERROR;
 	struct print_arg *arg;
 	char *token;
 	int args = 0;
 
 	do {
+		if (type == EVENT_NEWLINE) {
+			free_token(token);
+			type = read_token_item(&token);
+			continue;
+		}
+
 		arg = malloc_or_die(sizeof(*arg));
 		memset(arg, 0, sizeof(*arg));
 
-- 
1.6.3.3


