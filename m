Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbYARTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbYARTMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765255AbYARTMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:12:16 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:44293 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764533AbYARTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:12:14 -0500
Date: Fri, 18 Jan 2008 14:12:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Francis Moreau <francis.moro@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why not creating a GIT RT tree ?
In-Reply-To: <38b2ab8a0801180937y4264fc15wd3b91ca74635f679@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0801181400110.10928@gandalf.stny.rr.com>
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com> 
 <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com>
 <38b2ab8a0801180937y4264fc15wd3b91ca74635f679@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, Francis Moreau wrote:
> >
> > The answer to this is pretty much the same as why the -mm tree isn't in
> > git either.
> >
>
> Well not exactly. Unlike the mm tree which is made of a lots of patches
> dealing with totaly unrelated subjects, the rt patches only hopefully deal
> with realtime stuffs.

Well mostly realtime stuffs, but that's a lot of stuffs.

>
> > The RT tree is made up of lots of patches (over 300). Our goal is to get
> > RT into mainline Linux. RT isn't just one type of system, it extends all
> > over the kernel, and the patches may be rewriten over and over. Managing
> > this in quilt is a lot easier than managing it in git.
> >
>
> I'm probably missing something since I haven't looked at the RT patches
> (yet) but couldn't these 300 patches be sorted out by topics ?

They are, and different things bounce around a bit.

>
> If so you could create a branch per topic and merge all of them in your
> master branch which would be the rt kernel. Hopefully each branch
> won't interact with other branch too much.

That's the big problem, they do. <looks at the series>

Here's some of the stuff that's in the series (by topic)

 - Mcount tracing patches (touches things all over)
 - monotonic cycle patches
 - RT balancing patches (scheduled to go into 2.6.25)
 - KVM fixes (RT specific stuff for KVM)
 - A bunch of different arch stuff for timers (ARM, PPC, etc)
 - suspend / resume tweaks
 - various cleanups (some should probably go to mainline anyway)
 - latency tracer (also touches stuff all over)
 - lockdep tweaks
 - hrtimer tweaks
 - Preempt RCU patch queue (hopefully will go in 2.6.25 or 26)
 - softirq threading
 - hardirq threading
 - RT mutexes (turn spinlocks into mutexes - touches all over)
 - tasklet redesign
 - posix CPU timers
 - general realtime stuff
 - workqueue PI


And there's more. So I'm not sure how many branches would be needed, and
I could imaging it taking quite a bit. Again, this will be much more
difficult to manage then a simple quilt queue. When we get most the major
stuff in RT (threaded softirqs / hardirqs, and spinlocks to mutexes) then
it would probably be the time to create a git repo.


>
> All of this assumes of course that the number of topics is definitely much
> smaller than the number of patches (~300).

Smaller than 300, but much more than 10.

>
> Having such a tree would be very useful for looking at history in each topic,
> for doing some git-bisect debug session IMHO...

True, but then how would you do it. One thing is that most of these
branches would interact with each other. Touching the same code quite
a bit. So it doesn't always help. But pulling out patches can help us to
an extent.

> > That said, there's been talk about making a git tree for others based on
> > the quilt queue. The thing is that a new git tree will need to be created
> > for every release. Which means that it will be difficult for others to
> > simply update their local repo since you will get a bunch of errors with
> > not being from the same head.
> >
> >
> > >
> > > Another question, is there a TODO list somewhere which would
> > > help to port the RT patch to a new architecture ?
> >
> > Which arch? We are already on PowerPC, ARM and MIPS. Thinking about sh?
> >
>
> Yep, not that I'm an expert in this architecture but it's commonly used
> in multimedia device where realtime is often needed.

Great! Looking forward to it ;-)

-- Steve

