Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZEFEXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZEFEXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZEFEXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51086 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/11] [GIT PULL] tracing/ring-buffer: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased again (using ftrace-2 now) and made some minor clean
ups to the patches, as well as added several new ones.

The last patch of the series adds a benchmark/tester for the 
ring buffer. It creates a producer and consumer and measures the time
and number of entries recorded. It prints out the results via
pr_info every 10 seconds.

Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-2


Steven Rostedt (10):
      ring-buffer: export symbols
      ring-buffer: add counters for commit overrun and nmi dropped entries
      tracing: export stats of ring buffers to userspace
      ring-buffer: convert cpu buffer entries to local_t
      ring-buffer: record page entries in buffer page descriptor
      ring-buffer: have read page swap increment counter with page entries
      ring-buffer: disable writers when resetting buffers
      tracing: use proper export symbol for tracing api
      ring-buffer: move big if statement down
      ring-buffer: add benchmark and tester

Tim Abbott (1):
      ftrace: use .sched.text, not .text.sched in recordmcount.pl

----
 include/linux/ring_buffer.h          |    2 +
 kernel/trace/Kconfig                 |   16 ++
 kernel/trace/Makefile                |    1 +
 kernel/trace/ring_buffer.c           |  339 ++++++++++++++++--------------
 kernel/trace/ring_buffer_benchmark.c |  379 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c                 |   48 ++++-
 scripts/recordmcount.pl              |    6 +-
 7 files changed, 628 insertions(+), 163 deletions(-)
-- 
