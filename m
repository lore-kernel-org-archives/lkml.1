Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZFGKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZFGKWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZFGKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:22:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:41883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbZFGKWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:22:10 -0400
Date: Sun, 7 Jun 2009 10:21:48 GMT
From: tip-bot for walimis <walimisdev@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, walimisdev@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, walimisdev@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
Subject: [tip:tracing/core] tracing/trace_stack: fix the number of entries in the header
Message-ID: <tip-083a63b48e4dd0a6a2d44216720076dc81ebb255@git.kernel.org>
Git-Commit-ID: 083a63b48e4dd0a6a2d44216720076dc81ebb255
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  083a63b48e4dd0a6a2d44216720076dc81ebb255
Gitweb:     http://git.kernel.org/tip/083a63b48e4dd0a6a2d44216720076dc81ebb255
Author:     walimis <walimisdev@gmail.com>
AuthorDate: Wed, 3 Jun 2009 16:01:28 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 3 Jun 2009 10:24:44 -0400

tracing/trace_stack: fix the number of entries in the header

The last entry in the stack_dump_trace is ULONG_MAX, which is not
a valid entry, but max_stack_trace.nr_entries has accounted for it.
So when printing the header, we should decrease it by one.
Before fix, print as following, for example:

	Depth    Size   Location    (53 entries)	<--- should be 52
	-----    ----   --------
  0)     3264     108   update_wall_time+0x4d5/0x9a0
  ...
 51)       80      80   syscall_call+0x7/0xb
 ^^^
   it's correct.

Signed-off-by: walimis <walimisdev@gmail.com>
LKML-Reference: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace_stack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 1796f00..2d7aebd 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -265,7 +265,7 @@ static int t_show(struct seq_file *m, void *v)
 		seq_printf(m, "        Depth    Size   Location"
 			   "    (%d entries)\n"
 			   "        -----    ----   --------\n",
-			   max_stack_trace.nr_entries);
+			   max_stack_trace.nr_entries - 1);
 
 		if (!stack_tracer_enabled && !max_stack_size)
 			print_disabled(m);
