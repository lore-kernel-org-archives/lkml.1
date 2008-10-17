Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYJQQ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYJQQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbYJQQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:59:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbYJQQ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:59:06 -0400
Date: Fri, 17 Oct 2008 12:58:45 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, edwintorok@gmail.com,
       mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081017165845.GB12352@redhat.com>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net> <20081017144820.GA3167@redhat.com> <20081017164352.GF5696@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017164352.GF5696@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Oct 17, 2008 at 12:43:52PM -0400, Mathieu Desnoyers wrote:
> [...]
> > > _IFF_ you want to place tracepoints, get them in the same place as the
> > > lock-dep/stat hooks, that way you get all the locks, not only mutexes.
> > 
> > makes sense. So we could layer lock-dep/stat on top of tracepoints? That
> > would potentially also make lock-dep/stat more dynamic.

> Guys, please, let's focus on the infrastructure to manage trace data
> (timestamping, buffering, event ID, event type management) before
> going any further in the instrumentation direction.  

Any trace data management widget design that precludes connection to
an event source as simple as tracepoints or markers is going to be a
disappointment.


> Otherwise we will end up adding instrumentation in the Linux kernel
> without any in-kernel user [...]

Connecting markers to /proc style text files has been demonstrated in
less than a hundred lines of code.


Plus, Jason's note clearly referred to another in-kernel use of this
instrumentation: the possibility of connecting lockdep via generic
tracepoints in the lock-related code rather than special-purpose
hooks.  One benefit could be being able to compile in lockdep and/or
lockstat by default (activating it via a boot option).  The other
would be of course the concurrent/alternative of the instrumentation
for performance-related purposes.

- FChE
