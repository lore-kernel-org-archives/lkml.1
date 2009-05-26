Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZEZEdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZEZEdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZEZEdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:33:09 -0400
Received: from ozlabs.org ([203.10.76.45]:43830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZEZEdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:33:09 -0400
Date: Tue, 26 May 2009 14:32:57 +1000
From: Anton Blanchard <anton@samba.org>
To: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/events: Use %pf in workqueue trace events
Message-ID: <20090526043257.GD19728@kryten>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526043123.GC19728@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526043123.GC19728@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using %pf instead of %pF supresses printing of the function offset
which will always be 0.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-master/include/trace/events/workqueue.h
===================================================================
--- linux-2.6-master.orig/include/trace/events/workqueue.h	2009-05-26 12:55:37.000000000 +1000
+++ linux-2.6-master/include/trace/events/workqueue.h	2009-05-26 12:55:44.000000000 +1000
@@ -32,7 +32,7 @@
 		__entry->cpu		= cpu;
 	),
 
-	TP_printk("thread=%s:%d func=%pF cpu=%d", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf cpu=%d", __entry->thread_comm,
 		__entry->thread_pid, __entry->func, __entry->cpu)
 );
 
@@ -63,7 +63,7 @@
 		__entry->delay		= delay;
 	),
 
-	TP_printk("thread=%s:%d func=%pF cpu=%d delay=%lu",
+	TP_printk("thread=%s:%d func=%pf cpu=%d delay=%lu",
 		__entry->thread_comm, __entry->thread_pid, __entry->func,
 		__entry->cpu, __entry->delay)
 );
@@ -88,7 +88,7 @@
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d work=%p func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d work=%p func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->work, __entry->func)
 );
 
@@ -128,7 +128,7 @@
 		__entry->func	= work->func;
 	),
 
-	TP_printk("func=%pF", __entry->func)
+	TP_printk("func=%pf", __entry->func)
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
Index: linux-2.6-master/Documentation/trace/workqueue.txt
===================================================================
--- linux-2.6-master.orig/Documentation/trace/workqueue.txt	2009-05-26 12:55:52.000000000 +1000
+++ linux-2.6-master/Documentation/trace/workqueue.txt	2009-05-26 12:56:14.000000000 +1000
@@ -107,8 +107,8 @@
  # TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #   | |       |          |         |
 
-<...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task+0x0/0x280 cpu=0
-<...>-508   [000]  4597.858660: worklet_entry: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task+0x0/0x280
+<...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task cpu=0
+<...>-508   [000]  4597.858660: worklet_entry: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task
 <...>-508   [000]  4597.858684: worklet_exit: thread=ata/0:508 work=ffff88007e9e67b8
-<...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task+0x0/0x280
+<...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task
 [...]
