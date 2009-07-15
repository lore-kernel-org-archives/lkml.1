Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZGOWw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZGOWw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZGOWw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:52:26 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5763 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbZGOWwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:52:25 -0400
Date: Wed, 15 Jul 2009 18:52:23 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715225223.GG14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <20090715214558.GC14993@cs.fsu.edu> <4A5E5430.8000102@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5E5430.8000102@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 04:12:00PM -0600, Chris Friesen wrote:

> As Peter mentioned, it's not so much a matter of whether it's desired or
> not.  It's required, at least in terms of supporting priority
> inheritance for pthread mutexes.  I haven't been involved with the
> linux-rt side of things, but I believe Peter implied that they used PI
> fairly heavily there to try to minimize priority inversion issues
> because it was infeasible to analyze all the various locks.  The kernel
> is over 10 million lines of code, so any locking changes pretty much
> have to fit into the existing framework with minimal changes.
...
> Any additional penalty due to PI should be limited to
> the mutexes which actually have PI enabled.  If an application can limit
> itself to "safe" syscalls and has enough knowledge of its own locking,
> then it could presumably use regular mutexes and avoid the overhead of PI.
>
> I'm not sure the same could apply to the kernel in general...Peter would
> have to address that as I'm not familiar with the linux-rt changes.

I understand the need to support the (largely broken for SMP)
POSIX real-time API, but from what I read of the scheduler it
seems that support for priority inheritance on mutexes has greatly
complicated the kernel, and that the cost extends to applications
that do not use priority inheritance mutexes.  I especially don't
see why why priority inheritance mutexes should ever be used by
the kernel itself.  Is there a way to provide in the kernel
whatever minimal hooks are needed to support the API for users who
want it, with less impact?

My experience on IEEE PASC and the Austin Group, including work
with POSIX validation test suites, has shown that many of the
POSIX specifications leave a huge amount of room for
implementation freedom -- much larger than I thought when I
balloted them.  I found this out when I wrote test programs that
implementors argued went beyond the specs, when I complained as
user about POSIX implementations that I thought did not meet the
specs, and when I read interpretation requests from other users
and implementors.

So, I think it would be worth the effort to read the POSIX
specification for PTHREAD_PRIO_INHERIT carefully, with a lawyerly
attitude, to see if it really requires going to the lengths the
Linux kernel currently goes.  That is, look for loopholes that
permit Linux to do the right thing. I can't do this today, but
maybe I will another day.

Ted
