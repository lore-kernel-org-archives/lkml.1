Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYLKQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYLKQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbYLKQtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:19 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:51153 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbYLKQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:14 -0500
X-BigFish: VPS4(zz3b5bkzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBQ1DM-02-VNS-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 9/9] ring_buffer: adding EXPORT_SYMBOLs
Date: Thu, 11 Dec 2008 17:42:03 +0100
Message-ID: <1229013723-8191-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0212 (UTC) FILETIME=[5BF7FBC0:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this should be *_GPL().

I added EXPORT_SYMBOLs for all functions part of the API
(ring_buffer.h). This is required since oprofile is using the ring
buffer and the compilation as modules would fail otherwise.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/ring_buffer.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c8996d2..7e0215e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -31,6 +31,7 @@ void tracing_on(void)
 {
 	ring_buffers_off = 0;
 }
+EXPORT_SYMBOL(tracing_on);
 
 /**
  * tracing_off - turn off all tracing buffers
@@ -44,6 +45,7 @@ void tracing_off(void)
 {
 	ring_buffers_off = 1;
 }
+EXPORT_SYMBOL(tracing_off);
 
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
@@ -60,12 +62,14 @@ u64 ring_buffer_time_stamp(int cpu)
 
 	return time;
 }
+EXPORT_SYMBOL(ring_buffer_time_stamp);
 
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
 {
 	/* Just stupid testing the normalize function and deltas */
 	*ts >>= DEBUG_SHIFT;
 }
+EXPORT_SYMBOL(ring_buffer_normalize_time_stamp);
 
 #define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
 #define RB_ALIGNMENT_SHIFT	2
@@ -115,6 +119,7 @@ unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
 	return rb_event_length(event);
 }
+EXPORT_SYMBOL(ring_buffer_event_length);
 
 /* inline for ring buffer fast paths */
 static inline void *
@@ -136,6 +141,7 @@ void *ring_buffer_event_data(struct ring_buffer_event *event)
 {
 	return rb_event_data(event);
 }
+EXPORT_SYMBOL(ring_buffer_event_data);
 
 #define for_each_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_mask(cpu, buffer->cpumask)
@@ -444,6 +450,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	kfree(buffer);
 	return NULL;
 }
+EXPORT_SYMBOL(ring_buffer_alloc);
 
 /**
  * ring_buffer_free - free a ring buffer.
@@ -459,6 +466,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	kfree(buffer);
 }
+EXPORT_SYMBOL(ring_buffer_free);
 
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 
@@ -620,6 +628,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(ring_buffer_resize);
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
@@ -1220,6 +1229,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 		preempt_enable_notrace();
 	return NULL;
 }
+EXPORT_SYMBOL(ring_buffer_lock_reserve);
 
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
@@ -1269,6 +1279,7 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	return 0;
 }
+EXPORT_SYMBOL(ring_buffer_unlock_commit);
 
 /**
  * ring_buffer_write - write data to the buffer without reserving
@@ -1334,6 +1345,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 
 	return ret;
 }
+EXPORT_SYMBOL(ring_buffer_write);
 
 static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
@@ -1360,6 +1372,7 @@ void ring_buffer_record_disable(struct ring_buffer *buffer)
 {
 	atomic_inc(&buffer->record_disabled);
 }
+EXPORT_SYMBOL(ring_buffer_record_disable);
 
 /**
  * ring_buffer_record_enable - enable writes to the buffer
@@ -1372,6 +1385,7 @@ void ring_buffer_record_enable(struct ring_buffer *buffer)
 {
 	atomic_dec(&buffer->record_disabled);
 }
+EXPORT_SYMBOL(ring_buffer_record_enable);
 
 /**
  * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
@@ -1393,6 +1407,7 @@ void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_inc(&cpu_buffer->record_disabled);
 }
+EXPORT_SYMBOL(ring_buffer_record_disable_cpu);
 
 /**
  * ring_buffer_record_enable_cpu - enable writes to the buffer
@@ -1412,6 +1427,7 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_dec(&cpu_buffer->record_disabled);
 }
+EXPORT_SYMBOL(ring_buffer_record_enable_cpu);
 
 /**
  * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
@@ -1428,6 +1444,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return cpu_buffer->entries;
 }
+EXPORT_SYMBOL(ring_buffer_entries_cpu);
 
 /**
  * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
@@ -1444,6 +1461,7 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return cpu_buffer->overrun;
 }
+EXPORT_SYMBOL(ring_buffer_overrun_cpu);
 
 /**
  * ring_buffer_entries - get the number of entries in a buffer
@@ -1466,6 +1484,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 
 	return entries;
 }
+EXPORT_SYMBOL(ring_buffer_entries);
 
 /**
  * ring_buffer_overrun_cpu - get the number of overruns in buffer
@@ -1488,6 +1507,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 
 	return overruns;
 }
+EXPORT_SYMBOL(ring_buffer_overruns);
 
 /**
  * ring_buffer_iter_reset - reset an iterator
@@ -1513,6 +1533,7 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 	else
 		iter->read_stamp = iter->head_page->time_stamp;
 }
+EXPORT_SYMBOL(ring_buffer_iter_reset);
 
 /**
  * ring_buffer_iter_empty - check if an iterator has no more to read
@@ -1527,6 +1548,7 @@ int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
 	return iter->head_page == cpu_buffer->commit_page &&
 		iter->head == rb_commit_index(cpu_buffer);
 }
+EXPORT_SYMBOL(ring_buffer_iter_empty);
 
 static void
 rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
@@ -1797,6 +1819,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	return NULL;
 }
+EXPORT_SYMBOL(ring_buffer_peek);
 
 /**
  * ring_buffer_iter_peek - peek at the next event to be read
@@ -1867,6 +1890,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	return NULL;
 }
+EXPORT_SYMBOL(ring_buffer_iter_peek);
 
 /**
  * ring_buffer_consume - return an event and consume it
@@ -1894,6 +1918,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	return event;
 }
+EXPORT_SYMBOL(ring_buffer_consume);
 
 /**
  * ring_buffer_read_start - start a non consuming read of the buffer
@@ -1934,6 +1959,7 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 
 	return iter;
 }
+EXPORT_SYMBOL(ring_buffer_read_start);
 
 /**
  * ring_buffer_finish - finish reading the iterator of the buffer
@@ -1950,6 +1976,7 @@ ring_buffer_read_finish(struct ring_buffer_iter *iter)
 	atomic_dec(&cpu_buffer->record_disabled);
 	kfree(iter);
 }
+EXPORT_SYMBOL(ring_buffer_read_finish);
 
 /**
  * ring_buffer_read - read the next item in the ring buffer by the iterator
@@ -1971,6 +1998,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
 	return event;
 }
+EXPORT_SYMBOL(ring_buffer_read);
 
 /**
  * ring_buffer_size - return the size of the ring buffer (in bytes)
@@ -1980,6 +2008,7 @@ unsigned long ring_buffer_size(struct ring_buffer *buffer)
 {
 	return BUF_PAGE_SIZE * buffer->pages;
 }
+EXPORT_SYMBOL(ring_buffer_size);
 
 static void
 rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
@@ -2022,6 +2051,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
 }
+EXPORT_SYMBOL(ring_buffer_reset_cpu);
 
 /**
  * ring_buffer_reset - reset a ring buffer
@@ -2034,6 +2064,7 @@ void ring_buffer_reset(struct ring_buffer *buffer)
 	for_each_buffer_cpu(buffer, cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
 }
+EXPORT_SYMBOL(ring_buffer_reset);
 
 /**
  * rind_buffer_empty - is the ring buffer empty?
@@ -2052,6 +2083,7 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 	}
 	return 1;
 }
+EXPORT_SYMBOL(ring_buffer_empty);
 
 /**
  * ring_buffer_empty_cpu - is a cpu buffer of a ring buffer empty?
@@ -2068,6 +2100,7 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return rb_per_cpu_empty(cpu_buffer);
 }
+EXPORT_SYMBOL(ring_buffer_empty_cpu);
 
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
@@ -2117,6 +2150,7 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 
 	return 0;
 }
+EXPORT_SYMBOL(ring_buffer_swap_cpu);
 
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
-- 
1.6.0.1


