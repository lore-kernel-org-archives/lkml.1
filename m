Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbXG2BBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbXG2BBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 21:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbXG2BBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 21:01:05 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:38706
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbXG2BBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 21:01:04 -0400
Date: Sat, 28 Jul 2007 18:00:39 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, jos poortvliet <jos@mijnkamer.nl>,
       ck@vds.kolivas.org, Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-ID: <20070729010039.GA11661@gnuppy.monkey.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org> <200707282128.39906.jos@mijnkamer.nl> <20070728200705.GF32582@gnuppy.monkey.org> <20070728230609.43273a75.diegocg@gmail.com> <20070728213232.GG32582@gnuppy.monkey.org> <alpine.LFD.0.999.0707281445170.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707281445170.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 03:18:24PM -0700, Linus Torvalds wrote:
> I don't think anything was suppressed here.

I disagree. See below.

> You seem to say that more modular code would have helped make for a nicer 
> way to do schedulers, but if so, where were those patches to do that? 
> Con's patches didn't do that either. They just replaced the code.

They replaced code because he would have liked to have taken scheduler code
in possibly a completely different direction. This is a large conceptual
change from what is currently there. That might also mean how the notion of
bandwidth with regards to core frequency might be expressed in the system
with regards to power saving and other things. Things get dropped often
not because of pure technical reasons but because of person preference
and the lack of willingness to ask where this might take us.

The way that Con works and conceptualizes things is quite a bit different
and more comprehensive in a lot of ways compared to how the regular kernel
community operates. He's strong in this area and weak in general kernel
hackery as a function of time and experience. That doesn't mean that he,
his ideas and his code should be subject to an either/or situation with the
scheduler and other ideas that have been rejected by various folks. He
maintained -ck branch successfully for a long time and is a very capable
developer.

I do acknowledge that having a maintainer that you can trust is more
important, but it should not be exclusionary in this way. I totally
understand his reaction.

> In fact, Ingo's patches _do_ add some modularity, and might make it easier 
> to replace the scheduler. So it would seem that you would argue for CFS, 
> not against it?

It's not the same as sched plugin. Some folks might not like to use the
rbtree that's in place and express things in a completely different
manner. Take for instance, Tong Li's stuff with CFS a bit of a conceptual
mismatch with his attempt at expression rebalancing in terms expiry rounds
yet would be more seamlessly integrated with something like either the old
O(1) scheduler or Con's stuff. It's also the only method posted to lkml
that can deal with fairness across SMP situtations with low error. Yet
what's happening here is that his implementation is being rejected because
of size and complexity because of a data structure conceptual mismatch.

Because of this, his notion of trio as a general method of getting
aggressive group fairness (by far the most complete conceptually on lkml,
over design is a different topic altogether) may never see the light of
day in Linux because of people's collective lack of foresight.

To answer the question that you posed, no. I'm not arguing against it. I'm
in favor of it going into the kernel like any dead line mechanism since
it can be generalized, but the current developement processes in Linux
kernel should not create an either/or situation with the scheduler code.
There has been multipule rejection of ideas with regards to the scheduler
code over the years that could have take things in a very different and
possibly complete kick ass way that was suppress because of the development
attitude of various Linux kernel developers.

It's all of a sudden because of Con's work there's a flurry of development
in this area when this idea is shown to be superior and even then, it's
conceptually incomplete and subject to a lot of arbitrary hacking. This
is very different than Con's development style and mine as well.

This is an area that could have been addressed sooner if the general
community admitted that there was a problem earlier and permitted more
conscious and open change. I've seen changes in this area from Con be
reject time and time again which effect the technical direction he
originally wanted to take this.

Now, Con might have a communication problem here, but nobody asked to
clarify what he might have wanted and why, yet folks were very quick at
dismissing him, nitpick him to death,  even when he explained why he might
have wanted a particular change in the first place. This is the
"facilitation" part that's missing in the current kernel culture.

This is a very important idea as the community grows, because I see folks
that are capable of doing work get discouraged and locked out because of
code maintainability issues and an inability to get folks to move that
direction because of a missing concensus mechanism in the community
other that sucking up to developers.

Con and folks like him should be permitted the opportunity to fail on
their own account. If Linux was truely open, it would have dealt with
issue by now and there wouldn't be so much flammage from the general
community.

> > I think that's kind of a bogus assumption from the very get go. Scheduling
> > in Linux is one of the most unevolved systems in the kernel that still
> > could go through a large transformation and get big gains like what
> > we've had over the last few months. This evident with both schedulers,
> > both do well and it's a good thing overall the CFS is going in.
> > 
> > Now, the way it happened is completely screwed up in so many ways that I
> > don't see how folks can miss it. This is not just Ingo versus Con, this
> > is the current Linux community and how it makes decision from the top down
> > and the current cultural attitude towards developers doing things that
> > are:
> 
> I don't think so.
> 
> I think you're barking up the totally wrong tree here.

Did in any place in your reply did you ask what I meant by this ? Where
somebody like me, Con or Tong (sorry to drag you into this) and others
might like to take this and the -rt ? and other things in the Linux
kernel ? Well, this is a failure of the concensus process in Linux.

> I think that what happened was very simple: somebody showed that we did 
> badly and had benchmarks to show for it, and that in turn resulted in a 
> huge spurt of coding from the people involved.

Or ass kissing from large companies that are afraid to challenge the
Linux kernel norm. And a lot of that stuff is a complete ugly hack. That's
a self fullfulling attribute of the Linux culture that indicative of how
many ass kisser we have in this community that can snow ball any arbitary
phenomenon like CFS.

> The fact that you think this is "broken" is interesting. I can point to a 
> very real example of where this also happened, and where I bet you don't 
> think the process was "broken".

This lack of communication is an indicator of it being broken. Folks not
asking where we could take the Linux kernel, versus hacking it without
background on particular area and listening, is indicative of it. General
lack of direction with development is an indicator of it. Lack of design
discussion and inclusiveness of various designs is an indicator of failure.

> Do you remember the mindcraft study?
> 
> Exact same thing. Somebody came in, and showed that Linux did really badly 
> on some benchmark, and that an alternate approach was much better.
> 
> What happened? A huge spurt of development in a pretty short timeframe, 
> that totally _obliterated_ the mindcraft results. 
> 
> It could have happened independently, but the fact is, it didn't. These 
> kinds of events where somebody shows (with real numbers and code) that 
> things can be done better really *are* a good way to do development, and 
> it's how development generally ends up happening. It's hugely 
> motivational, both because competition is motivational in itself, but also 
> because somebody shows that things can be done so much better opens 
> peoples eyes to it.

Everybody here wants Linux to be better. Everybody, me included. Make no
mistake. But collectively we should not be in a state of "reaction" to
external forces as the only known method of development.

The scheduler could have and still can undertake good solid transformation,
but getting folks to listen is another story which is why Con quit. CFS
basically locks him and his ideas out, not just from a technical stand
point, and sends a personal message that we don't care about him because
we've made zero effort to reach out to him. This is exactly how you laid
it out in previous messages. That's broken. He has his own problems, but
he also produces good work and recognizes the development problems with
the community in his /. article that many folks agree with approach
lkml with bug reports.

It's hack versus design. There needs to be a balance between the two and
a culture to receive both and not create and either/or situation. Con's
method of development should be welcomed.

> And if you think the scheduler situation is different, why? Was it just 
> because the mindcraft study compared against Windows NT, not another 
> version of Linux patches?
> 
> The thing is, development is slow and gradual, but at the same time, it 
> happens in spurts (btw, if you have ever studied evolution, you'll find 
> the exact same thing: evolution is slow and gradual, but it also happens 
> in sudden "spurts" where you have relatively much bigger changes happening 
> because you get into a feedback loop).

This time it was Con being the Mindcraft catalyst. But he's on *our* side
and he got beat down by the Linux kernel community. That's the tragedy here.
He was beaten down by the very people he was trying to help out and
support. It should have been handled better.
 
> Another comparison to evolution: most of the competitive pressure actually 
> comes from the _same_ species, not from outside. It's not so much rabbits 
> competing against foxes (although that happens too), quite a lot of it is 
> rabbits competing against other rabbits!

This is different topic and a distraction from inclusiveness issues. All
groups have a mono-culture. Groups that recognized it and push out of it
make it a win for the entire group and not just for a small set of individuals.

Even as your "arm chair kernel" hacker, I've done things that are out of
the box in Linux and I believe are interesting but never cared for the
politics of mainline.

bill

