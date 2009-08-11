Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZHKStK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZHKStK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHKStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:09 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZHKStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jH8A9lRV9sVHIy6WsVTi/Tko8YptDLKpDaB0/weahLMJQV1BYUlEJQAPPg8dqb6u06
         AbAmtBuRyee/M8Rgo649QNdy72KYrSRqB9MVEWpNsbS6HnrmoIsL7jezfORNiksN1LGO
         EZOPe431ab5BUThLQYPzV5g+d7Qai8XmxemoE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [GIT PULL] tracing: Syscalls trace events + perf support
Date: Tue, 11 Aug 2009 20:48:49 +0200
Message-Id: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This pull request integrate one cleanup/fix for ftrace and
an update for syscall tracing: the migration from old-style tracer
to individual tracepoints/trace_events and the support for perf counter.

I've tested it with success either with ftrace (every syscall tracepoints
enabled at the same time without problems) and with perfcounter.

May be one drawback: it creates so much trace events that the ftrace
selftests can take some time :-)

Thanks,
Frederic.

The following changes since commit 89034bc2c7b839702c00a704e79d112737f98be0:
  Ingo Molnar (1):
        Merge branch 'linus' into tracing/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/core

Frederic Weisbecker (3):
      tracing: Add ftrace event call parameter to its field descriptor handler
      tracing: Add fields format definition for syscall events
      tracing: Support for syscall events raw records in perfcounters

Jason Baron (12):
      tracing: Map syscall name to number
      tracing: Call arch_init_ftrace_syscalls at boot
      tracing: Add DECLARE_TRACE_WITH_CALLBACK() macro
      tracing: Add syscall tracepoints
      tracing: Update FTRACE_SYSCALL_MAX
      tracing: Raw_init() bailout in trace event register fail case
      tracing: Add ftrace_event_call void * 'data' field
      tracing: Add trace events for each syscall entry/exit
      tracing: Add individual syscalls tracepoint id support
      tracing: Add perf counter support for syscalls tracing
      tracing: Add more namespace area to 'perf list' output
      tracing: Convert x86_64 mmap and uname to use DEFINE_SYSCALL

Zhaolei (1):
      tracing: Rename set_tracer_flags()'s local variable trace_flags

 arch/x86/include/asm/ftrace.h  |    4 +-
 arch/x86/kernel/ftrace.c       |   41 ++++--
 arch/x86/kernel/ptrace.c       |    7 +-
 arch/x86/kernel/sys_x86_64.c   |    8 +-
 include/linux/ftrace_event.h   |    8 +-
 include/linux/perf_counter.h   |    2 +
 include/linux/syscalls.h       |  126 +++++++++++++-
 include/linux/tracepoint.h     |   31 +++-
 include/trace/ftrace.h         |    7 +-
 include/trace/syscall.h        |   56 +++++-
 kernel/trace/trace.c           |   14 +-
 kernel/trace/trace.h           |    6 -
 kernel/trace/trace_events.c    |   35 +++--
 kernel/trace/trace_export.c    |    6 +-
 kernel/trace/trace_syscalls.c  |  372 +++++++++++++++++++++++++++++++---------
 kernel/tracepoint.c            |   38 ++++
 tools/perf/util/parse-events.c |    8 +-
 17 files changed, 613 insertions(+), 156 deletions(-)
