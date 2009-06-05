Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZFESIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZFESIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZFESIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:08:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZFESIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:08:35 -0400
Date: Fri, 5 Jun 2009 14:07:59 -0400
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <cover.1244222378.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/2] convert ftrace syscalls to TRACE_EVENT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I brought this up for as RFC before, and people were agreed in principal to
this idea. There are a number of advantages to having the syscall tracing
implemented as an event:

-can toggle on/off individual syscalls
-as a non-dedicated tracer, it can intermix with other tracing data
-by using tracepoints other infrastructures can tie into this implementation
-ability to print flag names and not just bits

In terms of the implementation, I've introduced a new 'trace_syscalls' enabled
flag in the <debugfs>/tracing/ directory to toggle the TIF_SYSCALL_FTRACE.
so: echo 1 > trace_syscalls to enable, echo 0 > trace_syscalls disable.

The implementation is still a bit rough, but I wanted to make sure I was on the 
right track before spending more time on this. I've showed an example of
printing out a flag using a 'clock_id_toname()' to macro. Steven's print_flags()
addition, should make pretty printing flag names much easier.

I believe that this current patch covers the functionality of the current ftrace
syscall tracer minus priting variable names and types, which I could add....thus,
I hope it can be merged in this state, and we can add pretty printing features
over time?

thanks,

-Jason


Jason Baron (2):
  -allow TP_printk() to have no args
  -syscall tracepoints

 arch/x86/kernel/ptrace.c        |    8 +-
 include/asm-generic/syscall.h   |    3 +
 include/trace/events/syscalls.h | 4202 +++++++++++++++++++++++++++++++++++++++
 include/trace/ftrace.h          |    2 +-
 include/trace/syscall.h         |    6 +
 kernel/trace/Makefile           |    1 -
 kernel/trace/trace.c            |  101 +
 kernel/trace/trace_syscalls.c   |  250 ---
 8 files changed, 4318 insertions(+), 255 deletions(-)
 create mode 100644 include/trace/events/syscalls.h
 delete mode 100644 kernel/trace/trace_syscalls.c

