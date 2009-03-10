Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbZCJE60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbZCJE60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZCJE6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZCJE6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:13 -0400
Message-Id: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>
Subject: [PATCH 0/7] [GIT PULL] enhancements for tracing in tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch series replaces the TRACE_EVENT_FORMAT with the new
TRACE_EVENT

NOTE: I started with a pull from tip/tracing/printk. It does not
show up as a merge since I did the pull at the point where it forked.
But by pulling this branch, you will also receive your changes from
tracing/printk. I rebased my changes off of this pull so that my changes
would be after the pull, making this patch series cleaner.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (7):
      tracing: typecast sizeof and offsetof to unsigned int
      tracing: replace TP<var> with TP_<var>
      tracing: use generic __stringify
      tracing: new format for specialized trace points
      tracing: convert the sched trace points to the TRACE_EVENT macros
      tracing: convert irq trace points to new macros
      tracing: remove obsolete TRACE_EVENT_FORMAT macro

----
 Documentation/tracepoints.txt          |    8 +-
 include/linux/tracepoint.h             |   10 +-
 include/trace/block.h                  |   70 +++---
 include/trace/irq_event_types.h        |   46 ++--
 include/trace/lockdep_event_types.h    |   26 +-
 include/trace/power.h                  |   12 +-
 include/trace/sched_event_types.h      |  442 +++++++++++++++++++++++---------
 include/trace/workqueue.h              |   16 +-
 kernel/trace/events.c                  |    4 +-
 kernel/trace/trace.h                   |    5 -
 kernel/trace/trace_event_types.h       |   29 +-
 kernel/trace/trace_events.c            |  174 +------------
 kernel/trace/trace_events_stage_1.h    |   27 +-
 kernel/trace/trace_events_stage_2.h    |   91 +++++--
 kernel/trace/trace_events_stage_3.h    |   42 +---
 kernel/trace/trace_export.c            |   41 +++-
 kernel/trace/trace_format.h            |   55 ----
 kernel/trace/trace_selftest.c          |    6 +-
 samples/tracepoints/tp-samples-trace.h |    8 +-
 19 files changed, 575 insertions(+), 537 deletions(-)
-- 
