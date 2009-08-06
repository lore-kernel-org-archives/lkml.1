Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbZHFDXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbZHFDXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZHFDXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:23:53 -0400
Received: from [222.73.24.84] ([222.73.24.84]:51255 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZHFDXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:23:53 -0400
Message-ID: <4A7A4D7B.7010706@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 11:26:51 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ftrace: Rename set_tracer_flags()'s local variable trace_flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_tracer_flags() have a local variable named trace_flags which have
same name with global one.
Actually, using tracer_flags should be better by its meaning.

[ Impact: cleanup ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..464b7bb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2291,23 +2291,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
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
@@ -2315,9 +2315,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
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
1.5.5.3


