Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbYJQQoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbYJQQoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYJQQnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:43:55 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:56190 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYJQQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:43:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEANxb+EhMQWq+/2dsb2JhbACBcr8Ug2w
Date: Fri, 17 Oct 2008 12:43:52 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       fche@redhat.com, fweisbec@gmail.com, edwintorok@gmail.com,
       mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081017164352.GF5696@Krystal>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net> <20081017144820.GA3167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081017144820.GA3167@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:37:37 up 134 days, 21:18,  9 users,  load average: 0.12, 0.41,
	0.75
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Thu, Oct 16, 2008 at 11:34:38PM +0200, Peter Zijlstra wrote:
> > On Thu, 2008-10-16 at 17:04 -0400, Jason Baron wrote:
> > 
> > > Below are 3 tracepoints I've been playing with in kernel/mutex.c using
> > > a SystemTap script. The idea is to detect and determine the cause of
> > > lock contention. Currently I get the following output:
> > > 
> > > <contended mutex nam> <process name and pid of the contention> <time of
> > > contention> <pid that woke me up(caused the contention?)>
> > 
> > > I think this approach has a number of advantages. It has low
> > > overhead in the off case, since its based on tracepoints. It is
> > > minimally invasive in the code path (3 tracepoints). It also allows me
> > > to explore data structures and parts of the kernel by simply modifying
> > > the SystemTap script. I do not need to re-compile the kernel and reboot.
> > 
> > *sigh* this is why I hate markers and all related things...
> > 
> > _IFF_ you want to place tracepoints, get them in the same place as the
> > lock-dep/stat hooks, that way you get all the locks, not only mutexes.
> 
> makes sense. So we could layer lock-dep/stat on top of tracepoints? That
> would potentially also make lock-dep/stat more dynamic.
> 
> > 
> > This is the same reason I absolutely _hate_ Edwin's rwsem tracer.
> > 
> 
> i'm trying to get some consensus on these types of patches. Do we
> want to create a new tracer for each thing we want to trace, or add
> tracepoints?
> 
> > Folks, lets please start by getting the tracing infrastructure in and
> > those few high-level trace-points google proposed.
> > 
> > Until we get the basics in, I think I'm going to NAK any and all
> > tracepoint/marker patches.
> > 
> 
> I think that core locking functions are pretty basic...
> 
> 

Guys, please, let's focus on the infrastructure to manage trace data
(timestamping, buffering, event ID, event type management) before going
any further in the instrumentation direction. Otherwise we will end up
adding instrumentation in the Linux kernel without any in-kernel user
(or various tiny users without overall management insfrastructure), and
this sounds like a no-go. This is what Peter and Thomas are saying by
talking of NACK. Their position is actually nothing new : Linus has been
the first to say that at the Kernel Summit 2008, and I think it makes
sense.

We will have plenty of time to optimize
markers/tracepoints/lockdep/function trace _once_ we get the data
collection right.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
