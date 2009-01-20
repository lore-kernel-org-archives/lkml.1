Return-Path: <linux-kernel-owner+w=401wt.eu-S1764570AbZATAVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764570AbZATAVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764803AbZATARh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61322 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764783AbZATARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:34 -0500
Message-Id: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] ftrace: updates to tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The one patch I did here, will need to go to stable as well. I'll write
up a patch against stable, and as soon as it gets into Linus's tree,
it should also be pulled into stable as well. Without the patch, some
archs will not be able to perform any tracing. There is an alignment
issue that will cause the ring buffer to fail to commit any transactions.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Lai Jiangshan (1):
      trace_workqueue: use percpu data for workqueue stat

Markus Metzger (6):
      x86, ftrace, hw-branch-tracer: support hotplug cpus
      x86, ftrace, hw-branch-tracer: dump trace on oops
      x86, ftrace, hw-branch-tracer: reset trace buffer on close
      x86, ftrace, hw-branch-tracer: change trace format
      x86, ftrace, hw-branch-tracer: documentation
      x86, ds, bts: cleanup DS configuration

Steven Rostedt (1):
      ring-buffer: fix alignment problem

----
 Documentation/ftrace.txt         |   74 ++++++++++++++++
 arch/x86/kernel/ds.c             |   31 ++++---
 arch/x86/kernel/dumpstack.c      |    6 ++
 include/linux/ftrace.h           |   13 +++
 kernel/trace/ring_buffer.c       |    2 +-
 kernel/trace/trace.h             |    1 -
 kernel/trace/trace_hw_branches.c |  173 +++++++++++++++++++++++++++++++-------
 kernel/trace/trace_workqueue.c   |   64 +++++++--------
 8 files changed, 281 insertions(+), 83 deletions(-)
-- 
