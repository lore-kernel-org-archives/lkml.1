Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbZKLFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbZKLFsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZKLFsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:48:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZKLFsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:48:41 -0500
Message-Id: <20091112054354.838746008@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 12 Nov 2009 00:43:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/3][RFC] tracing/x86: split sched_clock in recording trace time stamps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

In an effort to make the ring buffer as effecient as possible,
I've been using perf top to find where the trouble areas are. I've
found that it is mostly in just grabbing the time stamp.

This patch set uses the normalization feature of the ring buffer
to split sched_clock into just reading the tsc and on the read side
doing the cycles conversion.

This effort has brought the time to do a single record from 179 ns
down to 149 ns on my Intel Xeon 2.8 GHz box.

I'm sending this out as a RFC because I want the views of those that
know time keeping a bit better than I.

Thanks,

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/rfc


Steven Rostedt (3):
      tracing: Add time stamp normalize to ring buffer clock selection
      tracing: Make the trace_clock_local and trace_normalize_local weak
      tracing: Separate out x86 time stamp reading and ns conversion

----
 arch/x86/kernel/tsc.c       |   35 +++++++++++++++++++++++++++++++++++
 include/linux/ring_buffer.h |    3 ++-
 include/linux/trace_clock.h |    2 ++
 kernel/trace/ring_buffer.c  |    9 ++++++++-
 kernel/trace/trace.c        |   18 ++++++++++++++----
 kernel/trace/trace_clock.c  |   18 +++++++++++++++---
 6 files changed, 76 insertions(+), 9 deletions(-)
