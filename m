Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZFXBvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZFXBvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFXBvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:51:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZFXBvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:51:17 -0400
Message-ID: <4A4186C6.9090706@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:52:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] tracing: seqfile fixes, take 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing syscall tracepoints proposed by Jason, I found some
entries were missing when reading available_events.

It turned out there's bug in seqfile handling. The bug is, it's
wrong to increment @pos in seq start().

The bug exists in some other places. I also fixed some other different
bugs.

All the patches have been reviewed and tested.

Thanks Liming Wang for the review.

[PATCH 1/7] tracing/events: don't increment @pos in s_start()
[PATCH 2/7] tracing_bprintk: don't increment @pos in t_start()
[PATCH 3/7] trace_stat: don't increment @pos in seq start()
[PATCH 4/7] tracing: reset iterator in t_start()
[PATCH 5/7] ftrace: don't increment @pos in g_start()
[PATCH 6/7] ftrace: don't manipulate @pos in t_start()
[PATCH 7/7] ftrace: fix t_hash_start()
---
 kernel/trace/ftrace.c       |   52 ++++++++++++++++++++++++-------------------
 kernel/trace/trace.c        |   18 +++-----------
 kernel/trace/trace_events.c |   28 ++++++++++++++++++-----
 kernel/trace/trace_printk.c |   26 +++++----------------
 kernel/trace/trace_stat.c   |    6 +----
 5 files changed, 62 insertions(+), 68 deletions(-)


