Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZCGExU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZCGExU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 23:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZCGExI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 23:53:08 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56583 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZCGExG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 23:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gPSpQuXE/TcaYVLuM5S9k/ok9RbXD8yO23Jx6VLSwXdAIfuFnSuNky+EKzbXzkSCZf
         95flzQaoimKk8sk72XJDMZdXPzJPqkZeAjQR65yKySwF/PCHykNj3cpmZOdwmHrj1WFE
         ayMmcmyN2ZQNzdBWVGuBJ63wR6/RYvZlm51vs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 0/2] Syscalls tracing
Date: Sat,  7 Mar 2009 05:52:58 +0100
Message-Id: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a first attempt, quick one-shot, to provide a syscall tracing
infrastructure on ftrace.

The RFC prefix is here to reflect its ugliness on various parts.
The compromise between tracing reliabilty and speed is hard to balance.
For example I guess the basic and horrid string mask should be dropped in favour
of something else, which takes care of the volatile strings from the userspace.

But I hope a lot of ideas to make it better will come along this discussion.

Frederic Weisbecker (2):
  tracing/ftrace: syscall tracing infrastructure
  tracing/x86: basic implementation of syscall tracing for x86-64

 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/ftrace.h      |    7 +
 arch/x86/include/asm/thread_info.h |    9 +-
 arch/x86/kernel/ftrace.c           |   15 ++
 arch/x86/kernel/ptrace.c           |    7 +
 include/linux/ftrace.h             |   44 ++++++
 kernel/trace/Kconfig               |   10 ++
 kernel/trace/Makefile              |    1 +
 kernel/trace/trace.c               |    6 +
 kernel/trace/trace.h               |   32 ++++
 kernel/trace/trace_syscalls.c      |  284 ++++++++++++++++++++++++++++++++++++
 11 files changed, 413 insertions(+), 3 deletions(-)
 create mode 100644 kernel/trace/trace_syscalls.c

