Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZIMDqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZIMDqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZIMDqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:46:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34810 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZIMDqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:33 -0400
Message-Id: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/6] [GIT PULL] tracing: automate output for ftrace formats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Currently, the output for the format files for the internal ftrace
plugin entries is done by hand. This becomes difficult to maintain
and error prone. If a change happens to a structure, it is likely
that it will not be shown in the format file which binary readers
of ftrace require.

This patch series implements the logic that is used by TRACE_EVENT
to use macros that create the structures and those same macros also
show the output layout in the format files. This guarantees that the
structures and the output formats remain in-sync.

Again, this is based off of tip/tracing/core2

Please pull the latest tip/tracing/core3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core3


Steven Rostedt (6):
      tracing: allow filter predicates to handle ksym symbols
      tracing: use macros to create internal ftrace entry ring buffer structures
      tracing: show details of structures within the ftrace structures
      tracing: use the new trace_entries.h to create format files
      tracing: remove trace_event_types.h
      tracing: add filter event logic to special, mmiotrace and boot tracers

----
 include/linux/ftrace_event.h     |    4 +-
 kernel/trace/trace.c             |    5 +-
 kernel/trace/trace.h             |  175 ++++-------------
 kernel/trace/trace_boot.c        |    8 +-
 kernel/trace/trace_entries.h     |  392 ++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_event_types.h |  178 -----------------
 kernel/trace/trace_events.c      |    1 +
 kernel/trace/trace_export.c      |  241 +++++++++++++-----------
 kernel/trace/trace_mmiotrace.c   |   10 +-
 9 files changed, 581 insertions(+), 433 deletions(-)
-- 
