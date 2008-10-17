Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYJQOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYJQOte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYJQOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:49:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbYJQOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:49:26 -0400
Date: Fri, 17 Oct 2008 10:48:20 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, compudj@krystal.dyndns.org, fche@redhat.com,
       fweisbec@gmail.com, edwintorok@gmail.com, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081017144820.GA3167@redhat.com>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:34:38PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-10-16 at 17:04 -0400, Jason Baron wrote:
> 
> > Below are 3 tracepoints I've been playing with in kernel/mutex.c using
> > a SystemTap script. The idea is to detect and determine the cause of
> > lock contention. Currently I get the following output:
> > 
> > <contended mutex nam> <process name and pid of the contention> <time of
> > contention> <pid that woke me up(caused the contention?)>
> 
> > I think this approach has a number of advantages. It has low
> > overhead in the off case, since its based on tracepoints. It is
> > minimally invasive in the code path (3 tracepoints). It also allows me
> > to explore data structures and parts of the kernel by simply modifying
> > the SystemTap script. I do not need to re-compile the kernel and reboot.
> 
> *sigh* this is why I hate markers and all related things...
> 
> _IFF_ you want to place tracepoints, get them in the same place as the
> lock-dep/stat hooks, that way you get all the locks, not only mutexes.

makes sense. So we could layer lock-dep/stat on top of tracepoints? That
would potentially also make lock-dep/stat more dynamic.

> 
> This is the same reason I absolutely _hate_ Edwin's rwsem tracer.
> 

i'm trying to get some consensus on these types of patches. Do we
want to create a new tracer for each thing we want to trace, or add
tracepoints?

> Folks, lets please start by getting the tracing infrastructure in and
> those few high-level trace-points google proposed.
> 
> Until we get the basics in, I think I'm going to NAK any and all
> tracepoint/marker patches.
> 

I think that core locking functions are pretty basic...


