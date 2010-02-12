Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0BLTKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:10:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0BLTKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:10:38 -0500
X-Authority-Analysis: v=1.0 c=1 a=QEzcV-ImEyYA:10 a=meVymXHHAAAA:8 a=MfOiGYneL4kA26P_FgwA:9 a=buI_vU1kSSCRVHUnUVyMfj7e5-sA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100212191037.283998401@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Feb 2010 14:09:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 2/2][RFC] tracing: Add extract out softirq names used by irq trace events
References: <20100212190907.954438555@goodmis.org>
Content-Disposition: inline; filename=irq-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq trace events that map the softirq vectors to strings
shows up in the format files as names. To allow binary parsers to
be able to convert these names to their actual numbers, this patch
extracts those enums.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 include/trace/events/irq.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-trace.git/include/trace/events/irq.h
===================================================================
--- linux-trace.git.orig/include/trace/events/irq.h	2010-02-12 13:29:44.000000000 -0500
+++ linux-trace.git/include/trace/events/irq.h	2010-02-12 13:33:20.000000000 -0500
@@ -7,6 +7,17 @@
 #include <linux/tracepoint.h>
 #include <linux/interrupt.h>
 
+EXTRACT_TRACE_SYMBOL(HI_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(TIMER_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(NET_TX_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(NET_RX_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(BLOCK_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(BLOCK_IOPOLL_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(TASKLET_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(SCHED_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(HRTIMER_SOFTIRQ);
+EXTRACT_TRACE_SYMBOL(RCU_SOFTIRQ);
+
 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
 #define show_softirq_name(val)				\
 	__print_symbolic(val,				\

