Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZJUOhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZJUOhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZJUOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZJUOg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:36:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] tracing: removing cpu arg from rb_time_stamp function
Date: Wed, 21 Oct 2009 16:36:41 +0200
Message-Id: <1256135801-1849-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu argument is not used inside rb_time_stamp function. Plus typo fix.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/trace_seq.h  |    2 +-
 kernel/trace/ring_buffer.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c134dd1..09077f6 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -7,7 +7,7 @@
 
 /*
  * Trace sequences are used to allow a function to call several other functions
- * to create a string of data to use (up to a max of PAGE_SIZE.
+ * to create a string of data to use (up to a max of PAGE_SIZE).
  */
 
 struct trace_seq {
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d33e5ca..63446f1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -486,7 +486,7 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
-static inline u64 rb_time_stamp(struct ring_buffer *buffer, int cpu)
+static inline u64 rb_time_stamp(struct ring_buffer *buffer)
 {
 	/* shift to debug/test normalization and TIME_EXTENTS */
 	return buffer->clock() << DEBUG_SHIFT;
@@ -497,7 +497,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 	u64 time;
 
 	preempt_disable_notrace();
-	time = rb_time_stamp(buffer, cpu);
+	time = rb_time_stamp(buffer);
 	preempt_enable_no_resched_notrace();
 
 	return time;
@@ -602,7 +602,7 @@ static struct list_head *rb_list_head(struct list_head *list)
 }
 
 /*
- * rb_is_head_page - test if the give page is the head page
+ * rb_is_head_page - test if the given page is the head page
  *
  * Because the reader may move the head_page pointer, we can
  * not trust what the head page is (it may be pointing to
@@ -1871,7 +1871,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		 * Nested commits always have zero deltas, so
 		 * just reread the time stamp
 		 */
-		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
+		*ts = rb_time_stamp(buffer);
 		next_page->page->time_stamp = *ts;
 	}
 
@@ -2114,7 +2114,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		goto out_fail;
 
-	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
+	ts = rb_time_stamp(cpu_buffer->buffer);
 
 	/*
 	 * Only the first commit can update the timestamp.
-- 
1.6.2.5

