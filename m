Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZINQep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZINQep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbZINQei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:34:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZINQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:33 -0400
Message-Id: <20090914163436.294449467@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:33:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH 2/6] tracing: have TRACE_EVENT macro use __flags to not shadow parameter
Content-Disposition: inline; filename=0002-tracing-have-TRACE_EVENT-macro-use-__flags-to-not-sh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The generated functions of TRACE_EVENT uses "flags" in one of the
sub macros which shadows a parameter in the outside macro.

Simple fix is to make the submacro use __flags instead.

Discovered by sparse.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index fa8ce03..72a3b43 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -239,9 +239,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
-		static const struct trace_print_flags flags[] =		\
+		static const struct trace_print_flags __flags[] =	\
 			{ flag_array, { -1, NULL }};			\
-		ftrace_print_flags_seq(p, delim, flag, flags);		\
+		ftrace_print_flags_seq(p, delim, flag, __flags);	\
 	})
 
 #undef __print_symbolic
-- 
1.6.3.3

-- 
