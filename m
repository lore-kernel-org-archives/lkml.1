Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZDQVSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZDQVSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZDQVR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:17:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZDQVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:17:57 -0400
Date: Fri, 17 Apr 2009 17:17:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH] tracing: remove format attribute of inline function
Message-ID: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to a cut and paste error, I added the gcc attribute for printf
format to the static inline stub of trace_seq_printf.

This will cause a compile failure.

[ Impact: fix compiler error when CONFIG_TRACING is off ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 15ca2c7..37db9bd 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -42,7 +42,6 @@ extern int trace_seq_path(struct trace_seq *s, struct path *path);
 
 #else /* CONFIG_TRACING */
 static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)))
 {
 	return 0;
 }

