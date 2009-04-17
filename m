Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbZDQQLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbZDQQLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZDQQLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:11:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZDQQLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:11:22 -0400
Date: Fri, 17 Apr 2009 16:10:38 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jeremy.fitzhardinge@citrix.com,
       mingo@elte.hu
In-Reply-To: <1239950139-1119-5-git-send-email-jeremy@goop.org>
References: <1239950139-1119-5-git-send-email-jeremy@goop.org>
Subject: [tip:tracing/core] tracing: avoid warnings from zero-arg tracepoints
Message-ID: <tip-76aa81118ddfbb3dc31533030cf3ec329dd067a6@git.kernel.org>
Git-Commit-ID: 76aa81118ddfbb3dc31533030cf3ec329dd067a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:10:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76aa81118ddfbb3dc31533030cf3ec329dd067a6
Gitweb:     http://git.kernel.org/tip/76aa81118ddfbb3dc31533030cf3ec329dd067a6
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 16 Apr 2009 23:35:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 17:52:26 +0200

tracing: avoid warnings from zero-arg tracepoints

Tracepoints with no arguments can issue two warnings:

	"field" defined by not used
	"ret" is uninitialized in this function

Mark field as being OK to leave unused, and initialize ret.

[ Impact: fix false positive compiler warnings. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: mathieu.desnoyers@polymtl.ca
LKML-Reference: <1239950139-1119-5-git-send-email-jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 60c5323..39a3351 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -160,8 +160,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 static int								\
 ftrace_format_##call(struct trace_seq *s)				\
 {									\
-	struct ftrace_raw_##call field;					\
-	int ret;							\
+	struct ftrace_raw_##call field __attribute__((unused));		\
+	int ret = 0;							\
 									\
 	tstruct;							\
 									\
