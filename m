Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbZFSDHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbZFSDHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZFSDHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:07:38 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40568 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZFSDHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XRLPrjOSfKkSbAqNqoJMEhtP3vE4KO1zhzBFaR4eqHVgN4ZPFvzZvA2o/uiioyEuh1
         fJ6LBjzRGpk5809rYTGx6IvOdZjudl1AJVKmtJ4Hui31AD4I4gKSO5UVT9F0Ti7wvbDy
         n2E0deIshl6GrkKmujSoZCbYa2CpekF2Xo6Yk=
Date: Fri, 19 Jun 2009 05:07:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 0/7] add syscall tracepoints
Message-ID: <20090619030735.GE7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <20090616193220.GB12699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616193220.GB12699@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:32:20PM +0200, Ingo Molnar wrote:
> 
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > hi,
> > 
> > The following is an implementation of Frederic's syscall tracer on 
> > top of tracepoints. It adds the ability to toggle the entry/exit 
> > of each syscall via the standard 
> > events/syscalls/syscall_blah/enable interface. The implementation 
> > is done by adding 2 tracepoints. One on entry and one for exit.
> > 
> > This implementation required a few 'core' api changes. I've added 
> > 'DECLARE_TRACE_REG()' macro which takes a register and and an 
> > unregister function as arguments. This allowed me to toggle the 
> > ftrace tif flag when the first tracepoint callback is added and 
> > the last is removed. Current callers of 'DECLARE_TRACE()' are not 
> > impacted.
> > 
> > Another change was to call arch_init_ftrace_syscalls via an 
> > 'arch_initall'. In this implmentation I needed to access the 
> > syscalls_metadata structure at runtime in order to determine which 
> > syscalls were 'traceable'. Although the implementation uses 
> > SYSCALL_DEFINE() to set up the the trace events, for some reason 
> > at runtime there is no syscalls_metadata, associated with some of 
> > the SYSCALL_DEFINE() calls. I'm not quite sure why that is. 
> > However, by calling arch_init_ftrace_syscalls() at boot I can make 
> > sure the lists are in sync.
> > 
> > thanks,
> > 
> > -Jason 
> > 
> > 
> >  arch/x86/include/asm/ftrace.h |    4 +-
> >  arch/x86/kernel/ftrace.c      |   24 +++++-
> >  arch/x86/kernel/ptrace.c      |    6 +-
> >  include/linux/syscalls.h      |   63 +++++++++++++++
> >  include/linux/tracepoint.h    |   27 ++++++-
> >  include/trace/syscall.h       |   37 +++++++---
> >  kernel/trace/trace_events.c   |   29 +++++---
> >  kernel/trace/trace_syscalls.c |  172 +++++++++++++++++++----------------------
> >  kernel/tracepoint.c           |   38 +++++++++
> >  9 files changed, 278 insertions(+), 122 deletions(-)
> 
> This looks far nicer structurally. Steve, Frederic, what's your take 
> on this series?
> 
> 	Ingo


I've reviewed all of them and only found small neats to comment.
Yeah the direction looks better now.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

