Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZL3Q0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZL3Q0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZL3Q0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:26:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZL3Q0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:26:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=8wszxA3bwjAA:10 a=omOdbC7AAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=bM-HBBmkZ2LYzGnRkV0A:9 a=AEBswRaj5wnZx9kBRfYuhMx2WxUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091230162614.424587156@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 30 Dec 2009 11:23:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 1/3] tracing/kprobe: Show sign of fields in trace_kprobe format files
References: <20091230162303.088852290@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-kprobe-Show-sign-of-fields-in-trace_kprobe-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The format files of trace_kprobe do not show the sign of the fields.
The other format files show the field signed type of the fields and
this patch makes the trace_kprobe formats consistent with the others.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D27.5040009@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..83f1e6e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1182,10 +1182,11 @@ static int __probe_event_show_format(struct trace_seq *s,
 #undef SHOW_FIELD
 #define SHOW_FIELD(type, item, name)					\
 	do {								\
-		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
-				"offset:%u;\tsize:%u;\n", name,		\
+		ret = trace_seq_printf(s, "\tfield:" #type " %s;\t"	\
+				"offset:%u;\tsize:%u;\tsigned:%d;\n", name,\
 				(unsigned int)offsetof(typeof(field), item),\
-				(unsigned int)sizeof(type));		\
+				(unsigned int)sizeof(type),		\
+				is_signed_type(type));			\
 		if (!ret)						\
 			return 0;					\
 	} while (0)
-- 
1.6.5


