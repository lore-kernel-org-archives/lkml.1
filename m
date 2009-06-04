Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZFDF06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZFDF06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZFDF0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61026 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZFDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:12 -0400
Message-Id: <20090604052613.239224761@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/6] tracing/branch-profiler: do not profile managers
Content-Disposition: inline; filename=0003-tracing-branch-profiler-do-not-profile-managers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the branch profiler does not handle modules. Do not bother
processing the code for them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/compiler.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 37bcb50..dd42294 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -75,9 +75,11 @@ struct ftrace_branch_data {
 /*
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
+ *  We currently do not profile modules.
  */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
-    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
+#if defined(CONFIG_TRACE_BRANCH_PROFILING)				\
+	&& !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)	\
+	&& !defined(MODULE)
 void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
-- 
1.6.3.1

-- 
