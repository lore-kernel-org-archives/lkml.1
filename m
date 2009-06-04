Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZFDMFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZFDMFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZFDME4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:04:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:33648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbZFDMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:04:54 -0400
Date: Thu, 4 Jun 2009 12:04:16 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A2384B1.90100@cn.fujitsu.com>
References: <4A2384B1.90100@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: put TP_fast_assign into braces
Message-ID: <tip-a9c1c3abe1160a5632e48c929b02b740556bf423@git.kernel.org>
Git-Commit-ID: a9c1c3abe1160a5632e48c929b02b740556bf423
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 12:04:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9c1c3abe1160a5632e48c929b02b740556bf423
Gitweb:     http://git.kernel.org/tip/a9c1c3abe1160a5632e48c929b02b740556bf423
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 1 Jun 2009 15:35:13 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 1 Jun 2009 23:24:53 -0400

tracing/events: put TP_fast_assign into braces

Currently TP_fast_assign has a limitation that we can't define local
variables in it.

Here's one use case when we introduce __dynamic_array():

TP_fast_assign(
	type *p = __get_dynamic_array(item);

	foo(p);
	bar(p);
),

[ Impact: allow defining local variables in TP_fast_assign ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A2384B1.90100@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 9276ec4..ee92682 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -471,7 +471,7 @@ static void ftrace_raw_event_##call(proto)				\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-	assign;								\
+	{ assign; }							\
 									\
 	if (!filter_current_check_discard(event_call, entry, event))	\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
