Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZKLEtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZKLEtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbZKLEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:49:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZKLEtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:49:32 -0500
Message-Id: <20091112044142.741419929@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 11 Nov 2009 23:41:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: performance boosts for recording traces
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first patch is really a fix to the ring_buffer_benchmark. It was
not giving a correct representation of the time of a trace. The
logic to time the trace was 1/3 of the measurement.

The second patch removes the disabling of interrupts in trace_clock_local.
This showed a 30 to 40 ns latency.

I'm still seeing the time stamp being a large overhead in the tracing.
I'll be posting an RFC patch set on using normalizing the timestamp
on read, to take some of the work out of the write side. This
drops the write from 179 ns to 151 ns. More about that later.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (2):
      ring-buffer: Add multiple iterations between benchmark timestamps
      tracing: do not disable interrupts for trace_clock_local

----
 kernel/trace/ring_buffer_benchmark.c |   25 ++++++++++++++++---------
 kernel/trace/trace_clock.c           |    8 +++++---
 2 files changed, 21 insertions(+), 12 deletions(-)
