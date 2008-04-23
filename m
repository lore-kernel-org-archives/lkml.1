Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbYDWCIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbYDWCIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYDWCIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:08:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYDWCIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:08:11 -0400
Date: Tue, 22 Apr 2008 22:08:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@goodmis.org, Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH] ftrace: fix setting of pos in read_pipe
Message-ID: <Pine.LNX.4.58.0804222205110.32718@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In resetting the iterator in read_pipe, the reset of pos was
postitioned in the wrong location with respect to the memset
operation. The current code sets pos, incorrectly, to zero.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-22 10:41:58.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-22 10:42:41.000000000 -0400
@@ -2500,10 +2500,10 @@ tracing_read_pipe(struct file *filp, cha
 		cnt = PAGE_SIZE - 1;

 	/* reset all but tr, trace, and overruns */
-	iter->pos = -1;
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	iter->pos = -1;

 	/*
 	 * We need to stop all tracing on all CPUS to read the

