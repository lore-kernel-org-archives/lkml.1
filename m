Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271Ab0AMSYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0AMSYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779Ab0AMSYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:24:44 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:41277 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab0AMSYo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:24:44 -0500
Date: Wed, 13 Jan 2010 13:24:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicholas Miell <nmiell@comcast.net>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113182442.GA20704@Krystal>
References: <20100113013757.GA29314@Krystal> <1263358823.3874.10.camel@entropy> <20100113053126.GC6781@linux.vnet.ibm.com> <1263361196.3874.12.camel@entropy> <20100113143805.GC30875@Krystal> <1263406071.3874.16.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1263406071.3874.16.camel@entropy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:22:12 up 28 days,  2:40,  6 users,  load average: 0.32, 0.19,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Miell (nmiell@comcast.net) wrote:
> On Wed, 2010-01-13 at 09:38 -0500, Mathieu Desnoyers wrote:
> > * Nicholas Miell (nmiell@comcast.net) wrote:
> > > On Tue, 2010-01-12 at 21:31 -0800, Paul E. McKenney wrote:
> > > > Why is it OK to ignore the developer's request for an expedited
> > > > membarrer()?  The guy who expected the syscall to complete in a few
> > > > microseconds might not be so happy to have it take many milliseconds.
> > > > By the same token, the guy who specified non-expedited so as to minimally
> > > > disturb other threads in the system might not be so happy to see them
> > > > all be IPIed for no good reason.  ;-)
> > > > 
> > > > 							Thanx, Paul
> > > 
> > > Because the behavior is still correct, even if it is slower than you'd
> > > expect. It doesn't really matter where the expedited flag goes, though,
> > > because every future kernel will understand it.
> > 
> > 16ms vs few µs is such a huge performance difference that it's barely
> > adequate to say that the behavior is still correct, but we definitely
> > cannot say it is unchanged. It can really render some applications
> > unusable.
> > 
> > If, for some reason, the expedited version of the system call happens to
> > be unimplemented, we should return -EINVAL, so the application can deal
> > with it in the approproate way (which could be, for instance, to use a
> > fall-back doing memory barriers on the RCU read-side).
> > 
> > But I don't see any reason for not implementing the expedited version
> > properly in the first place.
> > 
> 
> You're focusing on the least important detail of the proposal. It
> doesn't matter whether the expedited flag is compat flag or an incompat
> flag, because every version of kernel that ever has the membarrier
> system call will know what it means, and even if for some reason it
> doesn't implement expedited membarriers, it will still be able to
> recognize the flag and return an error.
> 
> The whole point of compat and incompat flags is that it allows new
> applications to run on old kernels and either work or fail as
> appropriate, depending on whether the new features they're using must be
> implemented or can be silently ignored.

I see. Thanks for the explanation. Then the expedited flag should
clearly be part of the mandatory flags.

Can you point me to other system calls that are doing this ?

Thanks,

Mathieu

> 
> -- 
> Nicholas Miell <nmiell@comcast.net>
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
