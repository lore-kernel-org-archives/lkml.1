Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZAOADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZAOADr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbZAOADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:03:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285AbZAOADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:03:34 -0500
Message-Id: <20090115000332.170230237@goodmis.org>
References: <20090115000254.519563275@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 19:02:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] trace: print ftrace_dump at KERN_EMERG log level
Content-Disposition: inline; filename=0001-trace-print-ftrace_dump-at-KERN_EMERG-log-level.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to print out ftrace_dump when expected

I was debugging a hard race condition to only find out that
after I hit the race, my log level was not at level to show
KERN_INFO. The time it took to trigger the race was wasted because
I did not capture the trace.

Since ftrace_dump is only called from kernel oops (and only when
it is set in the kernel command line to do so), or when a
developer adds it to their own local tree, the log level of
the print should be at KERN_EMERG to make sure the print appears.

ftrace_dump is not called by a normal user setup, and will not
add extra unwanted print out to the console. There is no reason
it should be at KERN_INFO.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 40217fb..408c03f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3076,7 +3076,7 @@ static struct notifier_block trace_die_notifier = {
  * it if we decide to change what log level the ftrace dump
  * should be at.
  */
-#define KERN_TRACE		KERN_INFO
+#define KERN_TRACE		KERN_EMERG
 
 static void
 trace_printk_seq(struct trace_seq *s)
-- 
1.5.6.5

-- 
