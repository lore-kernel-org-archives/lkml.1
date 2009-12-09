Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZLIUwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZLIUwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbZLIUwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:52:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbZLIUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:51:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=s0PAhWk7tisA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=mR-5iSUsI6MNs7BQALkA:9 a=0rWeREpT4AM97NjZWh01-p8tfbEA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091209205112.864968685@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Dec 2009 15:40:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/5] [PATCH 1/5] tracing: Only call pipe_close if pipe_close is defined
References: <20091209204035.871524827@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Only-call-pipe_close-if-pipe_close-is-define.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This fixes a cut and paste error that had pipe_close get called
if pipe_open was defined (not pipe_close).

Reported-by: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f804b40..dc937e1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2899,7 +2899,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
 
 
-	if (iter->trace->pipe_open)
+	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
 
 	mutex_unlock(&trace_types_lock);
-- 
1.6.5


