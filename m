Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZFSGlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZFSGlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZFSGlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:41:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZFSGlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:41:22 -0400
Message-ID: <4A3B3372.4040608@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 14:42:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] tracing: seqfile fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing syscall tracepoints proposed by Jason, I found some
entries were missing when reading available_events.

It turned out there's bug in seqfile handling. The bug is, it's
wrong to increment @pos in seq start().

I fixed similar bugs in some other places. (the last patch fixes
a different seqfile bug)

[PATCH 1/5] tracing/events: don't increment @pos in s_start()
[PATCH 2/5] tracing_bprintk: don't increment @pos in t_start()
[PATCH 3/5] trace_stat: don't increment @pos in stat_seq_start()
[PATCH 4/5] ftrace: don't increment @pos in g_start()
[PATCH 5/5] tracing: reset iterator in t_start()
---
 kernel/trace/ftrace.c       |   28 +++++++++++++---------------
 kernel/trace/trace.c        |   18 ++++--------------
 kernel/trace/trace_events.c |   28 ++++++++++++++++++++++------
 kernel/trace/trace_printk.c |   26 ++++++--------------------
 kernel/trace/trace_stat.c   |    6 +-----
 5 files changed, 46 insertions(+), 60 deletions(-)



