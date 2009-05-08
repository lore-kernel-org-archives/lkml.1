Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZEHEea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZEHEea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZEHEdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZEHEdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:31 -0400
Message-Id: <20090508043331.493337344@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 00:32:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] ring-buffer: add total count in ring-buffer-benchmark
Content-Disposition: inline; filename=0003-ring-buffer-add-total-count-in-ring-buffer-benchmar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

It is nice to see the overhead of the benchmark test when tracing is
disabled. That is, we turn off the ring buffer just to see what the
cost of running the loop that calls into the ring buffer is.

Currently, if no entries wer made, we get 0. This is not informative.
This patch changes it to check if we had any "missed" (non recorded)
events. If so, a total count is also reported.

[ Impact: evaluate the over head of the ring buffer benchmark test ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a7c048b..a21aa7b 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -285,6 +285,17 @@ static void ring_buffer_producer(void)
 		avg = 1000000 / hit;
 		pr_info("%ld ns per entry\n", avg);
 	}
+
+
+	if (missed) {
+		if (time)
+			missed /= (long)time;
+
+		pr_info("Total iterations per millisec: %ld\n", hit + missed);
+
+		avg = 1000000 / (hit + missed);
+		pr_info("%ld ns per entry\n", avg);
+	}
 }
 
 static void wait_to_die(void)
-- 
1.6.2.4

-- 
