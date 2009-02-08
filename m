Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZBHFzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZBHFzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 00:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZBHFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 00:53:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZBHFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 00:53:42 -0500
Message-Id: <20090208054955.777429253@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 08 Feb 2009 00:49:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] git pull request for tip/tracing/core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I rebased the previous changes onto tip/tracing/core. The first patch
is new, which is the elimination of the entry->cpu.

I did not remove it when it became obsolete, and thus we had
other developers using it, thinking that it was the way to
get the current cpu number. Unfortunately, the entry->cpu was
just taking up space, and never was initialized.

The rest of the patches, I've posted before, but this time I ported
them over to tip/tracing/core.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/core/devel


Steven Rostedt (7):
      trace: remove deprecated entry->cpu
      ring-buffer: add NMI protection for spinlocks
      ring-buffer: allow tracing_off to be used in core kernel code
      ftrace, x86: rename in_nmi variable
      nmi: add generic nmi tracking state
      ftrace: change function graph tracer to use new in_nmi
      ring-buffer: use generic version of in_nmi

Wenji Huang (1):
      trace: trivial fixes in comment typos.

----
 arch/x86/Kconfig                 |    1 +
 arch/x86/kernel/ftrace.c         |   35 ++++++++---------------------------
 include/linux/ftrace.h           |    2 +-
 include/linux/ftrace_irq.h       |    2 +-
 include/linux/hardirq.h          |   15 +++++++++++++++
 include/linux/ring_buffer.h      |    9 +++++++++
 kernel/trace/Kconfig             |    8 ++++++++
 kernel/trace/ftrace.c            |    6 +++---
 kernel/trace/ring_buffer.c       |   31 +++++++++++++++++++++++++++++--
 kernel/trace/trace.c             |    2 +-
 kernel/trace/trace.h             |    7 +++----
 kernel/trace/trace_hw_branches.c |    3 +--
 kernel/trace/trace_output.c      |    6 +++---
 13 files changed, 83 insertions(+), 44 deletions(-)

-- 
