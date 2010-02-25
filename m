Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab0BYTqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:46:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444Ab0BYTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=COgTIhD4hR0A:10 a=yPCof4ZbAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=CzhbC4G7-0PQpj9RF9cA:9 a=QURCX-c2YPR9IsWS6DLb18fRDaEA:4 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194530.242648627@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:44:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 7/7] tracing: Simplify memory recycle of trace_define_field
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Simplify-memory-recycle-of-trace_define_fiel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Discard freeing field->type since it is not necessary.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c2a3077..3f972ad 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	return 0;
 
 err:
-	if (field) {
+	if (field)
 		kfree(field->name);
-		kfree(field->type);
-	}
 	kfree(field);
 
 	return -ENOMEM;
-- 
1.6.5


