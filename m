Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZHFG1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZHFG1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZHFG1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:44 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:38906 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZHFG1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hdQU0QCFHnjfLcfTJW8800gYnJK6m7/XTUdmp6tl85axTOBfv/kqLOVFTQ7wqjUwkd
         X/IGf1j7aLfoVhhx04vQ4/ZgYdmqngNw21xanVw5+gguM39M+0G+9oXTBn2BF5z06TeE
         nzNW+ebcn074+VytpkntM34axPVjIq0bYSGso=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing: Various cleanups for 2.6.32, v2
Date: Thu,  6 Aug 2009 08:27:31 +0200
Message-Id: <1249540058-5528-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This new shot fixes the build errors you've reported after testing
the first version.
The fact is that the trace_function() helper is not only used by the
function tracer but also by various other tracing callsites.

Instead of keeping it in the function tracer file and paint it
with messy #ifdefs, I think it's better to keep it in the generic
trace.c because it's actually a general helper for various tracers.

I've then zapped the trace_function() moving in the third patch but kept
one of its side effects necessary for the function graph tracer helpers
moving: the ftrace_cpu_disabled var globalizing.

This series also gained a new patch that shuts down a warning in
trace_events.c

Thanks,
Frederic.



The following changes since commit 1f9963cbb0280e0cd554161e00f1a0eeddbf1ae1:
  Li Zefan (1):
        tracing/filters: improve subsystem filter

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Frederic Weisbecker (6):
      tracing/function-graph-tracer: Drop the useless nmi protection
      tracing/core: Turn ftrace_cpu_disabled into a global var
      tracing/core: Make the stack entry helpers global
      tracing: Move sched event insertion helpers in the sched switch tracer file
      tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
      tracing/events: Only define remove_subsystem_dir() if CONFIG_MODULES

Lai Jiangshan (1):
      tracing: Simplify print_graph_cpu()

 arch/x86/kernel/ftrace.c             |    4 -
 kernel/trace/trace.c                 |  192 ++--------------------------------
 kernel/trace/trace.h                 |   30 +++++-
 kernel/trace/trace_events.c          |   52 +++++-----
 kernel/trace/trace_functions_graph.c |  152 ++++++++++++++++++++++-----
 kernel/trace/trace_sched_switch.c    |   57 ++++++++++
 kernel/trace/trace_selftest.c        |    1 +
 7 files changed, 243 insertions(+), 245 deletions(-)
