Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXD2QIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXD2QIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXD2QIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:08:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414AbXD2QIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:08:11 -0400
Date: Sun, 29 Apr 2007 09:07:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <p73d51n1fup.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk>
 <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
 <p73d51n1fup.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > The thing is, bugzilla is totally broken because it's designed to help 
> > track bugs, but it's *not* designed to actually handle the much harder 
> > problem, which is to actually get the *right* developers to be aware 
> > of the *right* bugs!
> 
> This means we need people who figure out who to assign bugs too.
> Aka bugmasters.

Yes. But not using bugzilla.

I don't know if you've noticed already, but I'm not the only one that 
doesn't have a very high opinon of bugzilla ;)

What works is somebody who is a bugmaster, and it doesn't really matter 
*what* bug tracker he points to (bugzilla being one of the possibilities, 
although not necessarily the best, and absolutely NOT the only choice), 
and turn them into emails. Once they are emails, bugzilla can track them.

Andrew does this, and yes, Adrian did it.

> In theory it could be nearly automated. Figure out what files related
> to the bug and assign to the last 5 people who submitted patches
> for them and/or signed off. 

I do think you're pretty optimistic. I think it's true for trivial driver 
bugs, but even for trivial driver bugs the initial report is often not 
enough to pinpoint the driver. 

Let's take the sis900 bug as an example (not because I want to rag on that 
being a problem, but it happened to be a _trivial_ bug in 2.6.21, so it's 
a good case of something really really easy - and if that easy case isn't 
handled trivially and obviously, then the bug-reporting doesn't work).

In that case, the initial report was (condensed version, but fairly 
accurate): "system hangs on boot at random points. 2.6.21-rc7 worked 
well".

Now, realistically, if that entry had been in bugzilla, what would you do?

Equally realistically, let's ignore bugzilla for a moment, and ask what 
the best method for handling something like this would be? Have an open 
mind, no rules on "have to use bug tracker XYZ". 

You know what? The report went to me and the kernel mailing list as email. 
And that was the *right* thing in that case. There was no good sign of who 
it should go to, and while there wasn't a whole lot of information there, 
there *was* a very tight timeframe (ie it could pinpoint to within about a 
week when it started). But the only thing I could really ask for was for 
the person to bisect it.

Would bugzilla have helped? HELL NO. It would have been a disaster. It 
would have wasted reporter time, it would have wasted developer time, and 
it would likely have been ignored because the bug report wasn't specific 
enough to really trigger any good queries or trigger a maintainer.

So bugzilla wouldn't have helped even for a _trivial_ bug. 

I personally suspect that bugzilla helps more if a bug actually has a real 
history, and people want to actually save that history because they are 
stumped. But I think it should come in *then*, not immediately. Because it 
is actually too intrustive for the simple stuff - and most bugs actually 
are simple, it's just that they also get resolved so simply that people 
don't even think of them as bugs (ie we have a lot of "duh" kind of fixes 
too).

> BTW one big problem in our current bugzilla is that a lot of people
> cannot reassign bugs they don't own. I sometimes see bugs that I don't
> own bug I know who is responsible, but bugzilla doesn't allow me to do it.

I think that's a problem, but I think the thing that I react to most (and 
I know some other people do too) is that I just don't want a broken mousy 
interface that I have to explicitly go and look at. I'd much rather get 
involved by email once it's clear that I need to be involved. Having a 
link to "more information at xyz" (where xyz _can_ be bugzilla too, but 
doesn't have to be!) is fine, but but it really cannot be the first 
interface, not in the current form, at least.

> So I think what would help:
> 
> - Ask more people to just categorize and reassign bugs (anybody interested?)
> - Give more people in bugzilla the power to reassign arbitary bugs
>   (bugzilla maintainers would need to do that)

I think both of these are good ideas, but I don't think it's enough. There 
must be some better form of bug tracking than bugzilla. Some relly 
distributed way of letting people work together, *without* having to 
congregate on some central web-site kind of thing. A "git for bugs", where 
you can track bugs locally and without a web interface.

And I think it would be something much closer to "distributed email mbox 
with status tracking facilities", _not_ a web clicky interface.

		Linus
