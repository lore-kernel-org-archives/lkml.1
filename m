Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbZCMCkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbZCMCkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbZCMCib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 00/16] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Frederic Weisbecker (1):
      tracing/core: bring back raw trace_printk for dynamic formats strings

Jason Baron (2):
      tracing: tracepoints for softirq entry/exit - add softirq-to-name array
      tracing: tracepoints for softirq entry/exit - tracepoints

KOSAKI Motohiro (1):
      tracing: Don't use tracing_record_cmdline() in workqueue tracer fix

Steven Rostedt (12):
      tracing: fix comments about trace buffer resizing
      tracing: protect ring_buffer_expanded with trace_types_lock
      ring-buffer: use CONFIG_HOTPLUG_CPU not CONFIG_HOTPLUG
      ring-buffer: remove unneeded get_online_cpus
      tracing: show that buffer size is not expanded
      tracing: make bprint event use the proper event id
      tracing: have event_trace_printk use static tracer
      tracing: export trace formats to user space
      tracing: fix stack tracer header
      tracing: explain why stack tracer is empty
      tracing: show event name in trace for TRACE_EVENT created events
      ring-buffer: document reader page design

----
 include/linux/interrupt.h            |    5 +
 include/linux/kernel.h               |   40 ++++++---
 include/trace/irq_event_types.h      |   12 +++
 kernel/softirq.c                     |   16 +++-
 kernel/trace/ring_buffer.c           |  168 +++++++++++++++++----------------
 kernel/trace/trace.c                 |  121 ++++++++++++++++++++++--
 kernel/trace/trace.h                 |   30 ++++++-
 kernel/trace/trace_event_types.h     |   11 ++-
 kernel/trace/trace_events.c          |   10 --
 kernel/trace/trace_events_stage_2.h  |    2 +-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_mmiotrace.c       |    7 +-
 kernel/trace/trace_output.c          |   57 ++++++++++-
 kernel/trace/trace_printk.c          |  150 ++++++++++++++++++++++++++++--
 kernel/trace/trace_stack.c           |   19 ++++-
 kernel/trace/trace_workqueue.c       |   20 +++-
 16 files changed, 523 insertions(+), 151 deletions(-)
-- 
