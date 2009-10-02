Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZJBOB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZJBOB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZJBOB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:01:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:47809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZJBOB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:01:28 -0400
Date: Fri, 2 Oct 2009 14:00:59 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, srostedt@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AC43118.6050409@ct.jp.nec.com>
References: <4AC43118.6050409@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] trace: Fix missing assignment in trace_ctxwake_*
Message-ID: <tip-a2067f64cb59dfb19940a1a38a5a9fa6f2ddcaa5@git.kernel.org>
Git-Commit-ID: a2067f64cb59dfb19940a1a38a5a9fa6f2ddcaa5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 14:01:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2067f64cb59dfb19940a1a38a5a9fa6f2ddcaa5
Gitweb:     http://git.kernel.org/tip/a2067f64cb59dfb19940a1a38a5a9fa6f2ddcaa5
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Thu, 1 Oct 2009 13:33:28 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 15:24:55 +0200

trace: Fix missing assignment in trace_ctxwake_*

The state char variable S should be reassigned, if S == 0.

We are missing the state of the task that is going to sleep for the
context switch events (in the raw mode).

Fortunately the problem arises with the sched_switch/wake_up
tracers, not the sched trace events.

The formers are legacy now. But still, that was buggy.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4AC43118.6050409@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_output.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f572f44..cda766f 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -883,7 +883,7 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
 			      field->prev_pid,
@@ -918,7 +918,7 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
