Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYKHDsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYKHDsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYKHDrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKHDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:50 -0500
Message-Id: <20081108034748.750387183@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/10] ftrace: fix set_ftrace_filter
Content-Disposition: inline; filename=0001-ftrace-fix-set_ftrace_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix of output of set_ftrace_filter

Commit ftrace: do not show freed records in available_filter_functions

Removed a bit too much from the set_ftrace_filter code, where we now see
all functions in the set_ftrace_filter file even when we set a filter.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 896c71f..4d2e751 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -765,6 +765,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		    ((iter->flags & FTRACE_ITER_FAILURES) &&
 		     !(rec->flags & FTRACE_FL_FAILED)) ||
 
+		    ((iter->flags & FTRACE_ITER_FILTER) &&
+		     !(rec->flags & FTRACE_FL_FILTER)) ||
+
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !(rec->flags & FTRACE_FL_NOTRACE))) {
 			rec = NULL;
-- 
1.5.6.5

-- 
