Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbZCMFhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbZCMFhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZCMFhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbZCMFhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:37:17 -0400
Date: Fri, 13 Mar 2009 05:36:36 GMT
From: Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090313122235.43EB.A69D9226@jp.fujitsu.com>
References: <20090313122235.43EB.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] tracing: add comment for use of double __builtin_consant_p
Message-ID: <tip-bdc067582b8b71c7771bab076bbc51569c594fb4@git.kernel.org>
Git-Commit-ID: bdc067582b8b71c7771bab076bbc51569c594fb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:36:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdc067582b8b71c7771bab076bbc51569c594fb4
Gitweb:     http://git.kernel.org/tip/bdc067582b8b71c7771bab076bbc51569c594fb4
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 13 Mar 2009 00:12:52 -0400
Commit:     Steven Rostedt <srostedt@redhat.com>
CommitDate: Fri, 13 Mar 2009 00:15:46 -0400

tracing: add comment for use of double __builtin_consant_p

Impact: documentation

The use of the double __builtin_contant_p checks in the event_trace_printk
can be confusing to developers and reviewers. This patch adds a comment
to explain why it is there.

Requested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20090313122235.43EB.A69D9226@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>


---
 kernel/trace/trace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 35cfa7b..67595b8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -776,6 +776,11 @@ extern struct ftrace_event_call __stop_ftrace_events[];
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement optimizing out.
+ */
 #define event_trace_printk(ip, fmt, args...)				\
 do {									\
 	__trace_printk_check_format(fmt, ##args);			\
