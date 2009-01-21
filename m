Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZAUX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZAUX7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZAUX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These patches are fixes for the wakeup tracer.

The first is a fix to the empty output you reported to me earlier.

The second is a fix for the ring buffer to not record updates
if it is disabled, otherwised you can get empty traces there too.

The third is the wakeup change to record all tasks and not just
realtime tasks. It adds a wakeup_rt tracer to record only rt tasks.

The forth is the addition of the scheduling wakeup and sched switch
output to the wakeup tracer. This is very helpful data.

The last is probably the most important, and should go into 29 as well.
I never reset the timestamps used to connect the trace stamps in
the buffers. This can cause stale stamps to appear and explains
some of the really bad timestamps in the buffer I've seen.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (5):
      trace: do not disable wake up tracer on output of trace
      ring-buffer: do not swap if recording is disabled
      trace: separate out rt tasks from wakeup tracer
      wakeup-tracer: show scheduling data in output
      ring-buffer: reset timestamps when ring buffer is reset

----
 kernel/trace/ring_buffer.c        |   18 ++++++++
 kernel/trace/trace.c              |    2 +-
 kernel/trace/trace_sched_wakeup.c |   78 ++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 37 deletions(-)

-- 
