Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZEIQcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZEIQcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZEIQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:32:29 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63317 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbZEIQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:32:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8GAKdIBUpMQW1W/2dsb2JhbACBUM0Kg34F
Date: Sat, 9 May 2009 12:32:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509163216.GA7548@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <20090509153629.GC29911@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090509153629.GC29911@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:30 up 70 days, 12:56,  4 users,  load average: 0.51, 0.52,
	0.53
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Sat, May 09, 2009 at 10:37:37AM +0200, Ingo Molnar wrote:
> > [...]
> > Firstly, it adds two new tracepoints to every system call. That is 
> > unnecessary - we already have the TIF flag based callbacks, and we 
> > can use the existing syscall attributes table to get to tracepoints 
> > - without slow down (or impacting) the fast path in any way.
> > [...]
> 
> However, as the TIF_SYSCALL_FTRACE and/or TIF_SYSCALL_TRACE flags are
> tied to a single consumer, it would limit the usefulness of the
> naturally multiple-client tracepoints, if they were made conditional
> on them.  Would you be interested in a proper reference-counting API?
> 

Hrm, actually, looking at 

void start_ftrace_syscalls(void)
{
        unsigned long flags;
        struct task_struct *g, *t;

        mutex_lock(&syscall_trace_lock);

        /* Don't enable the flag on the tasks twice */
        if (++refcount != 1)
                goto unlock;

shows me that there is in fact some refcounting done there. But I'll
send the TIF_KERNEL_TRACE patchset anyway, given it supports much more
architectures and has a more generic thread flag name.

Mathieu


> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
