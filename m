Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZEOEJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZEOEJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZEOEHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:07:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZEOEHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:07:47 -0400
Message-Id: <20090515040746.676382923@goodmis.org>
References: <20090515040554.074680910@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 00:05:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/4] tracing: stop stack trace on first empty entry
Content-Disposition: inline; filename=0002-tracing-stop-stack-trace-on-first-empty-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The stack tracer stores eight entries in the ring buffer when an event
traces the stack. The output outputs all eight entries regardless of
how many entries were recorded.

This patch breaks out of the loop when a null entry is discovered.

[ Impact: only print the stack that is recorded ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8bd9a2c..489c0e8 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -898,6 +898,8 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 	trace_assign_type(field, iter->ent);
 
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		if (!field->caller[i])
+			break;
 		if (i) {
 			if (!trace_seq_puts(s, " <= "))
 				goto partial;
-- 
1.6.2.4

-- 
