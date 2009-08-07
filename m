Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZHGKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZHGKu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZHGKu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:50:26 -0400
Received: from [222.73.24.84] ([222.73.24.84]:56563 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbZHGKuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:50:24 -0400
Message-ID: <4A7C07A1.6070807@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 18:53:21 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] ftrace: Rename set_tracer_flags()'s local variable
 trace_flags
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com> <4A7A6470.60305@cn.fujitsu.com>
In-Reply-To: <4A7A6470.60305@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_tracer_flags() have a local variable named trace_flags which have
same name with global one.
Actually, using tracer_flags should be better by its meaning.

Changelog:
v1->v2: Simplied another patch in this patchset, no change in this patch.

[ Impact: cleanup ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6344573..6c5f67f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2117,23 +2117,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
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
@@ -2141,9 +2141,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
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


