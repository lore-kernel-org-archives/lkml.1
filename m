Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZFWS3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZFWS3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZFWS3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:29:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZFWS3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:29:23 -0400
Date: Tue, 23 Jun 2009 14:28:49 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 0/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

The following is an implementation of Frederic's syscall tracer on top of
tracepoints. It adds the ability to toggle the entry/exit of each syscall
via the standard events/syscalls/syscall_blah/enable interface. The
implementation is done by adding 2 tracepoints. One on entry and one for exit.

I've tried to address all of the comments from the last posting...updates include:
-2/7: make arch_init_ftrace_syscalls static, removed locking, make patch bi-sectable
-3/7: rename DECLARE_TRACE_REG as DECLARE_TRACE_WITH_CALLBACK
-4/7: make mutex and counter static
-7/7: add event tracing for syscalls that take no args

thanks,

-Jason

 arch/x86/include/asm/ftrace.h |    4 +-
 arch/x86/kernel/ftrace.c      |   31 +++++---
 arch/x86/kernel/ptrace.c      |    6 +-
 include/linux/syscalls.h      |   75 +++++++++++++++++-
 include/linux/tracepoint.h    |   29 ++++++-
 include/trace/syscall.h       |   37 +++++++---
 kernel/trace/trace_events.c   |   29 +++++---
 kernel/trace/trace_syscalls.c |  172 +++++++++++++++++++----------------------
 kernel/tracepoint.c           |   38 +++++++++
 9 files changed, 289 insertions(+), 132 deletions(-)

