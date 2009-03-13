Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZCMCjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZCMCjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZCMCia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023825.008224270@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/16] tracing: fix comments about trace buffer resizing
Content-Disposition: inline; filename=0001-tracing-fix-comments-about-trace-buffer-resizing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup

Some of the comments about the trace buffer resizing is gobbledygook.
And I wonder why people question if I'm a native English speaker.

This patch makes the comments make a bit more sense.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c3946a6..c61ee85 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2336,7 +2336,8 @@ static int tracing_resize_ring_buffer(unsigned long size)
 
 	/*
 	 * If kernel or user changes the size of the ring buffer
-	 * it get completed.
+	 * we use the size that was given, and we can forget about
+	 * expanding it later.
 	 */
 	ring_buffer_expanded = 1;
 
@@ -2351,8 +2352,20 @@ static int tracing_resize_ring_buffer(unsigned long size)
 		r = ring_buffer_resize(global_trace.buffer,
 				       global_trace.entries);
 		if (r < 0) {
-			/* AARGH! We are left with different
-			 * size max buffer!!!! */
+			/*
+			 * AARGH! We are left with different
+			 * size max buffer!!!!
+			 * The max buffer is our "snapshot" buffer.
+			 * When a tracer needs a snapshot (one of the
+			 * latency tracers), it swaps the max buffer
+			 * with the saved snap shot. We succeeded to
+			 * update the size of the main buffer, but failed to
+			 * update the size of the max buffer. But when we tried
+			 * to reset the main buffer to the original size, we
+			 * failed there too. This is very unlikely to
+			 * happen, but if it does, warn and kill all
+			 * tracing.
+			 */
 			WARN_ON(1);
 			tracing_disabled = 1;
 		}
-- 
1.6.1.3

-- 
