Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZEHQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZEHQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZEHQVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:21:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZEHQVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:21:32 -0400
Message-Id: <20090508162131.981675126@goodmis.org>
References: <20090508162033.397923239@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 12:20:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] ring-buffer: replace constants with time macros in ring-buffer-benchmark
Content-Disposition: inline; filename=0001-ring-buffer-replace-constants-with-time-macros-in-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The use of numeric constants is discouraged. It is cleaner and more
descriptive to use macros for constant time conversions.

This patch also removes an extra new line.

[ Impact: more descriptive time conversions ]

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a21aa7b..7d3aef9 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -253,7 +253,7 @@ static void ring_buffer_producer(void)
 	}
 
 	time = end_tv.tv_sec - start_tv.tv_sec;
-	time *= 1000000;
+	time *= USEC_PER_SEC;
 	time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
 
 	entries = ring_buffer_entries(buffer);
@@ -273,7 +273,8 @@ static void ring_buffer_producer(void)
 	pr_info("Missed:   %ld\n", missed);
 	pr_info("Hit:      %ld\n", hit);
 
-	do_div(time, 1000);
+	/* Convert time from usecs to millisecs */
+	do_div(time, USEC_PER_MSEC);
 	if (time)
 		hit /= (long)time;
 	else
@@ -282,18 +283,19 @@ static void ring_buffer_producer(void)
 	pr_info("Entries per millisec: %ld\n", hit);
 
 	if (hit) {
-		avg = 1000000 / hit;
+		/* Calculate the average time in nanosecs */
+		avg = NSEC_PER_MSEC / hit;
 		pr_info("%ld ns per entry\n", avg);
 	}
 
-
 	if (missed) {
 		if (time)
 			missed /= (long)time;
 
 		pr_info("Total iterations per millisec: %ld\n", hit + missed);
 
-		avg = 1000000 / (hit + missed);
+		/* Caculate the average time in nanosecs */
+		avg = NSEC_PER_MSEC / (hit + missed);
 		pr_info("%ld ns per entry\n", avg);
 	}
 }
-- 
1.6.2.4

-- 
