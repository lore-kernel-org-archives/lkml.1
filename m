Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZL2Q2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZL2Q2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZL2Q2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:28:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZL2Q0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:26:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=JeEeBsxCL5YA:10 a=VwQbUJbxAAAA:8 a=kZR599h83bWFg4A6bMkA:9 a=okY4UsiwzlgynzZISdej4YI42bMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091229162231.441352392@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Dec 2009 11:22:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/10][GIT PULL][v2.6.33] tracing: consolidate print fmt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch set contains some fixes but also a nice reduction in
size. Instead of having the TRACE_EVENT create the output format
of the event format file for each individual event, Lai Jiangshan
consolidated it with the filtering code.

   text    data     bss     dec     hex filename
5857201 1355780 9336808 16549789         fc879d vmlinux
5884589 1351684 9337896 16574169         fce6d9 vmlinux-orig

The above shows that this patch set gives us a 24k total reduction
in kernel size.

I know we are outside the merge window, but this looks like a nice
fix that, I believe, we should try to get into 33.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (9):
      tracing/kprobe: Show sign of fields in trace_kprobe format files
      tracing/syscalls: Fix typo in SYSCALL_DEFINE0
      tracing: Have __dynamic_array() define a field
      tracing: Fix sign fields in ftrace_define_fields_##call()
      tracing: Add print_fmt field
      tracing/syscalls: Init print_fmt for syscall events
      tracing/kprobes: Init print_fmt for kprobe events
      tracing: Use defined fields and print_fmt to print formats
      tracing: Remove show_format and related macros from TRACE_EVENT

Steven Rostedt (1):
      tracing: Have syscall tracing call its own init function

----
 include/linux/ftrace_event.h  |    3 +-
 include/linux/syscalls.h      |    8 +-
 include/trace/ftrace.h        |  168 +++++++++--------------------------------
 include/trace/syscall.h       |    4 -
 kernel/trace/trace_events.c   |   78 ++++++++++---------
 kernel/trace/trace_export.c   |   94 ++++-------------------
 kernel/trace/trace_kprobe.c   |  103 +++++++++++--------------
 kernel/trace/trace_syscalls.c |  106 +++++++++++++-------------
 8 files changed, 197 insertions(+), 367 deletions(-)
