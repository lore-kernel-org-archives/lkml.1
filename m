Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYK3PTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYK3PTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYK3PTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:19:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYK3PTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:19:32 -0500
Date: Sun, 30 Nov 2008 10:19:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@fifo99.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Hua Zhong <hzhong@gmail.com>
Subject: Re: [PATCH 0/4] trace: profiling branches
In-Reply-To: <1228042736.6868.19.camel@desktop>
Message-ID: <alpine.DEB.1.10.0811301013430.21825@gandalf.stny.rr.com>
References: <20081121071213.365288293@goodmis.org> <1228042736.6868.19.camel@desktop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 30 Nov 2008, Daniel Walker wrote:

> On Fri, 2008-11-21 at 02:12 -0500, Steven Rostedt wrote:
> > Ingo,
> > 
> > The following patches clean up the unlikely/likely tracer. Namely
> > it consolidates it into a single file called "profile_annotated_branch".
> > 
> > It also adds a new profiler. A true branch profiler that profiles all
> > if() statements where the conditional is not a constant. It puts 
> > a bit of overhead on the system, but the results seem pretty interesting.
> > The results are placed in "profile_branch".
> > 
> 
> I looked at the full version of this, and it looks really slow.. As I
> recall the biggest problem with the -mm version was it's cacheline
> bouncing (pointed out by Ingo), and yours doesn't _seem_ to fix that. In
> fact your version looks a lot worse..

I could probably do more to fix the cache line bouncing, but that is not
the number one concern rigth now. It is already a big overhead, both 
memory and performance. That will be something I may address later.


> 
> So really between the two if we want mainline likely profiling the -mm
> version is a better choice.. The reason that version never went into
> mainline is cause neither me or Andrew felt strongly that this was
> useful in more than just -mm ..

This once is also packaged with ftrace, so it makes it nice and tidy ;-)

I'm sure more people will be interested in such a thing outside of -mm.
I doubt that it will ever be turned on in a production kernel.

> 
> If you look at the output from the profiling long enough it becomes
> clear that it's frequently misleading .. In the short term a certain
> branch might be likely, and in the long term it isn't.. So you can't
> really blindly start converting the annotation..

I'd go with both. If it should not be likely in both the short and long
term than it should not be likely (same goes with unlikely). I think this 
will serve more in the case of removing unlikely's than to add them.


> 
> I should also mention that I didn't write the -mm version alone, it was
> an effort between three people me, Andrew, and Hua Zhong (CC added)..

OK, that is good to know. There was just a couple of things that I took 
from your patch set and I stated them. I wrote the first version without 
even knowing about you patch, and it was Andrew that pointed it out to me.

The two things that I took was the use of the builtin_constant_p and to 
use __FILE__ instead of IP.

Thanks,

-- Steve

