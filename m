Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZBQFQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZBQFQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZBQFOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZBQFOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:08 -0500
Message-Id: <20090217051407.234082938@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 11/15] ring-buffer: add tracing_is_on to test if ring buffer is enabled
Content-Disposition: inline; filename=0011-ring-buffer-add-tracing_is_on-to-test-if-ring-buffe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the tracing_is_on() interface to tell if the ring
buffer is turned on or not.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    2 ++
 kernel/trace/ring_buffer.c  |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 8e6646a..f5e793d 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -128,10 +128,12 @@ void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 void tracing_on(void);
 void tracing_off(void);
 void tracing_off_permanent(void);
+int tracing_is_on(void);
 #else
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline void tracing_off_permanent(void) { }
+static inline int tracing_is_on(void) { return 0; }
 #endif
 
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2b4626c..8f19f1a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -98,6 +98,15 @@ void tracing_off_permanent(void)
 	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
 }
 
+/**
+ * tracing_is_on - show state of ring buffers enabled
+ */
+int tracing_is_on(void)
+{
+	return ring_buffer_flags == RB_BUFFERS_ON;
+}
+EXPORT_SYMBOL_GPL(tracing_is_on);
+
 #include "trace.h"
 
 /* Up this if you want to test the TIME_EXTENTS and normalization */
-- 
1.5.6.5

-- 
