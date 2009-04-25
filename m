Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbZDYE0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbZDYE0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZDYE0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZDYE0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:30 -0400
Message-Id: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/5] [GIT PULL] tracing/events: remove TRACE_FORMAT and handle overflow ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch series first removes TRACE_FORMAT. It is no longer needed,
and with the new __string feature of TRACE_EVENT (thanks Frederic!)
these formats can be easly converted.

The ending patch (and reason that the TRACE_FORMAT is removed)
is to make the trace event ids reusable. That is, if a module
with a trace point is added and removed more than the number
of events possible (event->type is only 16 bits), it will then
search the list for freed events.

It is very unlikely that a trace event id will exceed the max number,
and before that happens the operation is O(1). But once the max
is exceeded, it is O(n). But this only runs once on module load
so it should not be a cause for alarm.

The last patch is a fix for reference counting of event files used by
modules.

Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-2


Steven Rostedt (5):
      tracing/lockdep: convert lockdep to use TRACE_EVENT macro
      tracing/irq: convert irq traces to use TRACE_EVENT macro
      tracing: remove deprecated TRACE_FORMAT
      tracing/events: reuse trace event ids after overflow
      tracing/events: make modules have their own file_operations structure

----
 include/linux/ftrace_event.h   |    1 +
 include/linux/tracepoint.h     |    5 --
 include/trace/define_trace.h   |    4 --
 include/trace/events/irq.h     |   57 ++++++++++++++++++++----
 include/trace/events/lockdep.h |   56 +++++++++++++++++++----
 include/trace/ftrace.h         |   66 ---------------------------
 kernel/trace/trace_events.c    |   95 +++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_output.c    |   71 +++++++++++++++++++++++++-----
 8 files changed, 243 insertions(+), 112 deletions(-)
-- 
