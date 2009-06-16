Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZFPTdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZFPTdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZFPTdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:33:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbZFPTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:33:03 -0400
Date: Tue, 16 Jun 2009 21:32:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 0/7] add syscall tracepoints
Message-ID: <20090616193220.GB12699@elte.hu>
References: <cover.1244837725.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> hi,
> 
> The following is an implementation of Frederic's syscall tracer on 
> top of tracepoints. It adds the ability to toggle the entry/exit 
> of each syscall via the standard 
> events/syscalls/syscall_blah/enable interface. The implementation 
> is done by adding 2 tracepoints. One on entry and one for exit.
> 
> This implementation required a few 'core' api changes. I've added 
> 'DECLARE_TRACE_REG()' macro which takes a register and and an 
> unregister function as arguments. This allowed me to toggle the 
> ftrace tif flag when the first tracepoint callback is added and 
> the last is removed. Current callers of 'DECLARE_TRACE()' are not 
> impacted.
> 
> Another change was to call arch_init_ftrace_syscalls via an 
> 'arch_initall'. In this implmentation I needed to access the 
> syscalls_metadata structure at runtime in order to determine which 
> syscalls were 'traceable'. Although the implementation uses 
> SYSCALL_DEFINE() to set up the the trace events, for some reason 
> at runtime there is no syscalls_metadata, associated with some of 
> the SYSCALL_DEFINE() calls. I'm not quite sure why that is. 
> However, by calling arch_init_ftrace_syscalls() at boot I can make 
> sure the lists are in sync.
> 
> thanks,
> 
> -Jason 
> 
> 
>  arch/x86/include/asm/ftrace.h |    4 +-
>  arch/x86/kernel/ftrace.c      |   24 +++++-
>  arch/x86/kernel/ptrace.c      |    6 +-
>  include/linux/syscalls.h      |   63 +++++++++++++++
>  include/linux/tracepoint.h    |   27 ++++++-
>  include/trace/syscall.h       |   37 +++++++---
>  kernel/trace/trace_events.c   |   29 +++++---
>  kernel/trace/trace_syscalls.c |  172 +++++++++++++++++++----------------------
>  kernel/tracepoint.c           |   38 +++++++++
>  9 files changed, 278 insertions(+), 122 deletions(-)

This looks far nicer structurally. Steve, Frederic, what's your take 
on this series?

	Ingo
