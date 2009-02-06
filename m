Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZBFP1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZBFP1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZBFP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZBFP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:21 -0500
Message-Id: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH v2 0/7] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This is still based off of tip/master since it is not all focused
on ftrace (has NMI generic code). I'll let you cherry pick and
figure out what goes where.

I tried to cherry pick them into tracing/ftrace and hit a bit of conflicts.
Next time, I'll just develop against tip/tracing/ftrace or
tip/tracing/core.

Changes since the first version:

 - Added Mathieu Desnoyers credit in the in_nmi change log.

 - Included the original ring buffer changes which these are
   based on and that I do not see in tip/master.

 - Added a comment fix patch by Wenji.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (6):
      ring-buffer: add NMI protection for spinlocks
      ring-buffer: allow tracing_off to be used in core kernel code
      ftrace, x86: rename in_nmi variable
      nmi: add generic nmi tracking state
      ftrace: change function graph tracer to use new in_nmi
      ring-buffer: use generic version of in_nmi

Wenji Huang (1):
      trace: trivial fixes in comment typos.

----
 arch/x86/Kconfig            |    1 +
 arch/x86/kernel/ftrace.c    |   35 ++++++++---------------------------
 include/linux/ftrace.h      |    2 +-
 include/linux/ftrace_irq.h  |    2 +-
 include/linux/hardirq.h     |   15 +++++++++++++++
 include/linux/ring_buffer.h |    9 +++++++++
 kernel/trace/Kconfig        |    8 ++++++++
 kernel/trace/ftrace.c       |    6 +++---
 kernel/trace/ring_buffer.c  |   31 +++++++++++++++++++++++++++++--
 kernel/trace/trace.h        |    6 +++---
 10 files changed, 78 insertions(+), 37 deletions(-)
-- 
