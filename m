Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZHKStM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZHKStM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHKStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:10 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZHKStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rDABxmnyWyfwvqi1TphJP8ur6pgMbOaRfduyYyIMemw3npueu71ke5U3nkXmYLtkyZ
         2QG54RSslO2Key3CzV6HltJv38nIcEL9BK4/uMnXxuv7PYt6ApATJ1eFY8SKoXTErlG6
         AHt5j1ss7dt/MBDFtzNDjzQYXeYmslIuqdoZs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/16] tracing: Rename set_tracer_flags()'s local variable trace_flags
Date: Tue, 11 Aug 2009 20:48:50 +0200
Message-Id: <1250016545-6601-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

set_tracer_flags() have a local variable named trace_flags which has
the same name than a global one in the same scope.
This leads to confusion, using tracer_flags should be better by its
meaning.

Changelog:
v1->v2: Simplified another patch in this patchset, no change in this
        patch.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e793cda..8ac2043 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2118,23 +2118,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 /* Try to assign a tracer specific option */
 static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 {
-	struct tracer_flags *trace_flags = trace->flags;
+	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
 	int ret = 0, i = 0;
 	int len;
 
-	for (i = 0; trace_flags->opts[i].name; i++) {
-		opts = &trace_flags->opts[i];
+	for (i = 0; tracer_flags->opts[i].name; i++) {
+		opts = &tracer_flags->opts[i];
 		len = strlen(opts->name);
 
 		if (strncmp(cmp, opts->name, len) == 0) {
-			ret = trace->set_flag(trace_flags->val,
+			ret = trace->set_flag(tracer_flags->val,
 				opts->bit, !neg);
 			break;
 		}
 	}
 	/* Not found */
-	if (!trace_flags->opts[i].name)
+	if (!tracer_flags->opts[i].name)
 		return -EINVAL;
 
 	/* Refused to handle */
@@ -2142,9 +2142,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 		return ret;
 
 	if (neg)
-		trace_flags->val &= ~opts->bit;
+		tracer_flags->val &= ~opts->bit;
 	else
-		trace_flags->val |= opts->bit;
+		tracer_flags->val |= opts->bit;
 
 	return 0;
 }
-- 
1.6.2.3

