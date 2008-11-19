Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbYKSFgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbYKSFgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYKSFgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:36:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYKSFgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:36:04 -0500
Message-Id: <20081119053602.883951293@goodmis.org>
References: <20081119053449.282336740@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 00:34:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: fix set_ftrace_filter
Content-Disposition: inline; filename=0001-ftrace-fix-set_ftrace_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix of output of set_ftrace_filter

The commit "ftrace: do not show freed records in
             available_filter_functions"

Removed a bit too much from the set_ftrace_filter code, where we now see
all functions in the set_ftrace_filter file even when we set a filter.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a39d24..dcac741 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -738,6 +738,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
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
