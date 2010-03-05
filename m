Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0CEVzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:55:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:34083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0CEVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:55:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gFwX7owU0wgwxzG4CazJmTdONCxR788xhYEosvomPq8eGwG3xSmR3BlEiMsWNjAKKy
         Cbpolznvy3d/zxZzpTrvpygLuXvA2BfxVMSJS5zNH0Jda1r1qmXn0tMOSRYyrZSIsZFt
         Sg2qcAJRfJLCEEy2gKfNRinkeDxKhlR6dZKRc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf updates
Date: Fri,  5 Mar 2010 22:55:47 +0100
Message-Id: <1267826147-6613-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

- Lock events seem to be usable now with perf
- Better performances in x86-64 stacktraces
- Trace events now have correct callchains
- Cleanups


Other patches still in discussion are not in the branch.

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      lockdep: Move lock events under lockdep recursion protection
      perf/x86-64: Use frame pointer to walk on irq and process stacks
      perf: Introduce new perf_fetch_caller_regs() for hot regs snapshot
      perf: Take a hot regs snapshot for trace events
      perf: Drop the obsolete profile naming for trace events


 arch/x86/kernel/cpu/perf_event.c   |   12 +++
 arch/x86/kernel/dumpstack.h        |   15 +++
 arch/x86/kernel/dumpstack_64.c     |    4 +-
 include/linux/ftrace_event.h       |   23 +++--
 include/linux/perf_event.h         |   42 +++++++++-
 include/linux/syscalls.h           |   24 +++---
 include/trace/ftrace.h             |   44 +++++-----
 include/trace/syscall.h            |    8 +-
 kernel/lockdep.c                   |    9 +--
 kernel/perf_event.c                |   18 ++--
 kernel/trace/Makefile              |    2 +-
 kernel/trace/trace_event_perf.c    |  165 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_event_profile.c |  164 -----------------------------------
 kernel/trace/trace_events.c        |    2 +-
 kernel/trace/trace_kprobe.c        |   29 +++---
 kernel/trace/trace_syscalls.c      |   72 ++++++++--------
 16 files changed, 353 insertions(+), 280 deletions(-)
