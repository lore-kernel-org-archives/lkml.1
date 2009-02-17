Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZBQFOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZBQFOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZBQFOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZBQFOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:06 -0500
Message-Id: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 00/15] [git pull] for tip/tracing/ftrace 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is a patch series that offers a variety of features.

The first is to add:

 #### all functions enabled ####

to set_ftrace_filter when all functions will be traced when function
tracing is on.

The next is to add a :command: interface, and the module command:

 echo '*:mod:ext4' > set_ftrace_filter

Will select all functions in the ext4 module.

 echo '!*write*:mod:ext4' > set_ftrace_filter

will remove all functions with the characters 'write' and are
in ext4.

Next we extend the :command: interface as well as add a way to
hook tracers to specific functions. Instead of tracing all functions
the same, this patch series adds a hash to be able to trace different
functions differently.

I implement a 'traceon' and 'traceoff' to have a function start or
stop tracing when it is hit. It also includes a counter for the
number of times to implement the trace on/off.

 echo '*_lock:traceon:4' > set_ftrace_filter
 echo '*_unlock:traceoff:5' > set_ftrace_filter

This will have all functions that end with _lock turn on tracing
and all that end with _unlock disable it, 4 times each.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/ftrace


Steven Rostedt (15):
      ftrace: state that all functions are enabled in set_ftrace_filter
      ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
      ftrace: rename ftrace_match to ftrace_match_records
      ftrace: break up ftrace_match_records into smaller components
      ftrace: add module command function filter selection
      ftrace: enable filtering only when a function is filtered on
      ftrace: add command interface for function selection
      ftrace: convert ftrace_lock from a spinlock to mutex
      ftrace: consolidate mutexes
      ftrace: trace different functions with a different tracer
      ring-buffer: add tracing_is_on to test if ring buffer is enabled
      ftrace: add traceon traceoff commands to enable/disable the buffers
      ftrace: show selected functions in set_ftrace_filter
      ftrace: add pretty print to selected fuction traces
      ftrace: add pretty print function for traceon and traceoff hooks

----
 include/linux/ftrace.h         |   40 ++
 include/linux/ring_buffer.h    |    2 +
 kernel/trace/ftrace.c          |  929 +++++++++++++++++++++++++++++++---------
 kernel/trace/ring_buffer.c     |    9 +
 kernel/trace/trace_functions.c |  163 +++++++
 5 files changed, 946 insertions(+), 197 deletions(-)
-- 
