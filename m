Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbZAPEzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbZAPEzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZAPEyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45860 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045417.820150410@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/6] trace: add gcc printf check to trace_seq_printf
Content-Disposition: inline; filename=0002-trace-add-gcc-printf-check-to-trace_seq_printf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Andrew Morton suggested adding a printf checker to trace_seq_printf
since there are a number of users that have improper format arguments.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_output.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index b2c1461..1cbab5e 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -16,7 +16,8 @@ struct trace_event {
 	trace_print_func	binary;
 };
 
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
 extern int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
-- 
1.5.6.5

-- 
