Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZD2E7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZD2E7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZD2E7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZD2E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:07 -0400
Message-Id: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] tracing/splice/ringbuffer: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I was doing a bit of tracing that was stressing the splice code
and I found lots of badness. Mostly, the second patch is the killer,
and should most likely go upstream ASAP. The ref counting on the
splice page is wrong and is never freed!

The rest are fixes to the read side. While debugging the memory leak
I pulled out my old logdev and used it to monitor what was happening
inside of ftrace (tracing the tracer). I did not like the amount
of copying that was happening in splice. This was mainly because
splice was faster than the writer (and this was with function tracer
running!). I added some enhancements to make the splice code
perform a little nicer.

Here's the logdev patch I was using to trace. As well as adding
my lfcnprint statements (similar to trace_printk).

  http://rostedt.homelinux.com/logdev/logdev-0.6.0-2.6.30-rc1.patch

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (5):
      tracing: convert ftrace_dump spinlocks to raw
      tracing: fix ref count in splice pages
      tracing: only add splice page if entries exist
      tracing: have splice only copy full pages
      ring-buffer: fix printk output

----
 kernel/trace/ring_buffer.c |    2 +-
 kernel/trace/trace.c       |   20 ++++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)
-- 
