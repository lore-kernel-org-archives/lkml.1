Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZFDF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZFDF0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZFDF0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZFDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:12 -0400
Message-Id: <20090604052613.005013632@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] tracing/branch-profiler: fix return value check on register_stat_tracer
Content-Disposition: inline; filename=0002-tracing-branch-profiler-fix-return-value-check-on-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The branch profiler incorrectly takes a zero return on register_stat_tracer
as an error. But zero means success.

[ Impact: remove annoying false warning on boot up ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..19c618f 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -379,7 +379,7 @@ __init static int all_annotated_branch_stats(void)
 	int ret;
 
 	ret = register_stat_tracer(&all_branch_stats);
-	if (!ret) {
+	if (ret) {
 		printk(KERN_WARNING "Warning: could not register "
 				    "all branches stats\n");
 		return 1;
-- 
1.6.3.1

-- 
