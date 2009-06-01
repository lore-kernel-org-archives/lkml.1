Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZFARSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZFARSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbZFARRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:23 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47405 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbZFARRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f1+SleW0nVdkmJoJhzQ3pUZ345/HhofS6nidZ8QIqkJDMllXcItFNcx5mIY4O/7nvz
         WqtZQvZnS3cezxDIQnK34BBzmE0uEs0NKVCiCk+NyZX5of/lQWDe/zVbg3INVdZex4S1
         tkQgWgGrN/xdKm6gNw3JsJi5Xhxts48Xq8+9c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
       Oleg Nesterov <oleg@redhat.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] tracing/events: use %pf in workqueue trace events
Date: Mon,  1 Jun 2009 19:17:14 +0200
Message-Id: <1243876637-6616-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Using %pf instead of %pF supresses printing of the function offset
which will always be 0.

[ Impact: cleanup workqueue events traces output ]

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/workqueue.txt |    6 +++---
 include/trace/events/workqueue.h  |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/workqueue.txt b/Documentation/trace/workqueue.txt
index 4019a8a..c446b28 100644
--- a/Documentation/trace/workqueue.txt
+++ b/Documentation/trace/workqueue.txt
@@ -107,8 +107,8 @@ worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction
  # TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #   | |       |          |         |
 
-<...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task+0x0/0x280 cpu=0
-<...>-508   [000]  4597.858660: worklet_execute: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task+0x0/0x280
+<...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task cpu=0
+<...>-508   [000]  4597.858660: worklet_execute: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task
 <...>-508   [000]  4597.858684: worklet_complete: thread=ata/0:508 work=ffff88007e9e67b8
-<...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task+0x0/0x280
+<...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task
 [...]
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 49608c7..6cb7833 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -32,7 +32,7 @@ TRACE_EVENT(worklet_enqueue,
 		__entry->cpu		= cpu;
 	),
 
-	TP_printk("thread=%s:%d func=%pF cpu=%d", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf cpu=%d", __entry->thread_comm,
 		__entry->thread_pid, __entry->func, __entry->cpu)
 );
 
@@ -63,7 +63,7 @@ TRACE_EVENT(worklet_enqueue_delayed,
 		__entry->delay		= delay;
 	),
 
-	TP_printk("thread=%s:%d func=%pF cpu=%d delay=%lu",
+	TP_printk("thread=%s:%d func=%pf cpu=%d delay=%lu",
 		__entry->thread_comm, __entry->thread_pid, __entry->func,
 		__entry->cpu, __entry->delay)
 );
@@ -88,7 +88,7 @@ TRACE_EVENT(worklet_execute,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d work=%p func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d work=%p func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->work, __entry->func)
 );
 
@@ -128,7 +128,7 @@ TRACE_EVENT(worklet_cancel,
 		__entry->func	= work->func;
 	),
 
-	TP_printk("func=%pF", __entry->func)
+	TP_printk("func=%pf", __entry->func)
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
-- 
1.6.2.3

