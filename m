Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZCCOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZCCOzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZCCOza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:55:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZCCOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:55:29 -0500
Date: Tue, 3 Mar 2009 09:55:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: mingo@goodmis.org,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] fix for tip/tracing/ftrace
Message-ID: <alpine.DEB.2.00.0903030954001.24890@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: fix return value to registering events

----
 kernel/trace/trace_events_stage_3.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
---------------------------
commit 633ddaa7f471e9db181f993c1458d6f4bae321ca
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 3 09:43:50 2009 -0500

    tracing: fix return value to registering events
    
    The registering of events had the return value check backwards.
    A zero returned is success, the check had it as a failure.
    
    This patch also fixes a missing "\n" in the warning that the check
    failed.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index c62a4d2..041789f 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -120,9 +120,9 @@ static int ftrace_reg_event_##call(void)				\
 	int ret;							\
 									\
 	ret = register_trace_##call(ftrace_event_##call);		\
-	if (!ret)							\
+	if (ret)							\
 		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call);				\
+			"probe to " #call "\n");			\
 	return ret;							\
 }									\
 									\
@@ -195,9 +195,9 @@ static int ftrace_raw_reg_event_##call(void)				\
 	int ret;							\
 									\
 	ret = register_trace_##call(ftrace_raw_event_##call);		\
-	if (!ret)							\
+	if (ret)							\
 		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call);				\
+			"probe to " #call "\n");			\
 	return ret;							\
 }									\
 									\

