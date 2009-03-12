Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZCLCjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZCLCjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZCLCjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:39:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCLCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:39:39 -0400
Message-Id: <20090312023720.144716747@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Mar 2009 22:37:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/4] [GIT PULL] memory saving ring buffer for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch series implements a better memory management by the
ring buffer. It only allocates the buffers for the online CPUS, as well
as keeps the buffers to a minimum size until they are used.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      tracing: keep ring buffer to minimum size till used
      tracing: expand the ring buffers when an event is activated
      tracing: fix trace_wait to know to wait on all cpus or just one
      ring-buffer: only allocate buffers for online cpus

----
 kernel/trace/ring_buffer.c  |  266 +++++++++++++++++++++++++++++++++++--------
 kernel/trace/trace.c        |  118 +++++++++++++++----
 kernel/trace/trace.h        |    3 +
 kernel/trace/trace_events.c |    8 ++
 4 files changed, 319 insertions(+), 76 deletions(-)

-- 
