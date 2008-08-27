Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYH0KFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYH0KFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYH0KE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:04:57 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:26234 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753067AbYH0KE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:04:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ARCHk8fep61sbhKKYcs8c4eJS+AQd2StOFxpAkNoDxHDzInmGpJTXsylu+bJXClBumNVrX9aeKZc6DVxRgo78OTd7TCqlGyJKxYeZfxlm1JFNGreoeRdjzgoqGSmBTm+SuU9NWA3tZ1Tu9t7mvA/DgPa1Vw2XGx8Nuy8hFGSgG8=  ;
X-YMail-OSG: bEWndZEVM1m3OLFKiLuoVEaAG4.JNpNqtu0vNMYs3wA.PmXqlhLOdFCTWPH6lFhjR0FEA.Rkobqb8FA5MiAXcRKwAXlbt0mzefBgXqH4kbTezng8YciNcN0b8jH9OCYGffwm6qJFXZ531lOXt7rsNgky
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Wed, 27 Aug 2008 20:04:46 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808262127.26803.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272004.47569.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 07:37, Thomas Gleixner wrote:
> On Tue, 26 Aug 2008, Nick Piggin wrote:
> > On Tuesday 26 August 2008 21:09, Thomas Gleixner wrote:
> > > On Tue, 26 Aug 2008, Nick Piggin wrote:
> > > > On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > > > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > > > So... no reply to this? I'm really wondering how it's OK to break
> > > > > > documented standards and previous Linux behaviour by default for
> > > > > > something that it is trivial to solve in userspace? [...]
> > > > >
> > > > > I disagree
> > > >
> > > > Your arguments were along the line of:
> > > >
> > > > * It probably doesn't break anything (except we had somebody report
> > > >   that it breaks their app)
> > >
> > > I'm a real-time oldtimer. An application which hogs the CPU for 9.9
> > > seconds with SCHED_FIFO priority is just broken. It's broken beyond
> > > all limits, whether POSIX allows to do that or Linux obeyed the
> > > request of the braindamaged application design.
> >
> > Oh with this much handwaving from you old timers I feel much better
> > about it ;) I bet before the bug report and change to 10s, any
> > application that hogged the CPU for more than 0.9 seconds was just
> > broken too, right? But 10s is more than enough for everybody?
>
> Well, we might have a public opinion poll, whether a system is
> declared frozen after 1, 10 or 100 seconds.

I don't understand the fixation on declaring a system frozen. I repeat:
how do you know "rt task code that hogs the CPU for 10s is broken"? This
still hasn't been adequately explained to me, and from responses to this
post, it seems that others have a different view than you do.


> Even a one second 
> unresponsivness shows up on the kernel bugzilla and you request that
> unlimited unresponsivness w/o a chance to debug it is the sane
> default.
>
> An one second RT CPU hog is just a broken application, nothing
> else. Your precious customer use case is simply crap.

What customer use case are you talking about? I never mentioned one and
have none. Are you confusing me with someone else?

But OK, so if someone else has a customer use case that breaks, what
makes you think you can just declare it is crap and we don't care about
it? For that matter, what has closed source got to do with it? We don't
break kernel userspace API regardless of closed source or open source.


> Real-time is about determinism and not about the allowance to fuck up
> a system at will. If a system failed to prevent the fuckup once then
> this is not at all a guarantee that it allows to do that forever.


This is just handwaving and ignoring the issue at hand. SCHED_FIFO and
SCHED_RT are exactly about being able to hog the CPU. That is exactly
how they are defined.


> Especially not in the Open Source space, where developers are still
> allowed to use their brain and apply common sense to prevent such a
> wreckage and abuse. Still, your not yet specified use case can
> continue to do stupid things forever with the simple tweak that it
> needs to declare itself broken by turning off the kernel sanity
> checks.

Huh? Again, I don't have a use case, and even ignoring the several posts
of people who do, I would still make the same argument because it is
plain for me to see that breaking the API by default is the wrong thing
to do.


> > I may not be an old timer, but I can say the kernel is just broken
> > if it deliberately deviates from standards to undocumented behaviour,
> > and even more so if it changes from working to broken behaviour for
> > reasons that can be worked around in userspace (eg. running a higher
> > priority watchdog).
>
> Right. I appreciate the nitpicking janitor of the most important POSIX
> feature:
>
> "The unlimited right to monopolize the CPU for any given timeframe."

Umm... yeah. That's exactly one of the important properties of SCHED_FIFO
and SCHED_RR. Why do you think it is OK to change this?


> Get your brain together. Just because it worked before and POSIX
> allows it is not an argument at all that it is something useful. If
> you want to do this you still can do it by resetting the limit.
>
> Your request to enforce that stupid and braindead behaviour on
> everyone is simply annyoing.

Get my brain together? You're the one with faulty reasoning on this issue.


> > > > * If it does break something then they must be doing something stupid
> > > >   (I refuted that because there are several legitimate ways to use rt
> > > >   scheduling that is broken by this)
> > > >
> > > > * We have many other APIs and tools that don't conform to posix (why
> > > >   is that a reason to break this one?)
> > >
> > > Simply because we use common sense instead of following every single
> > > POSIX brainfart by the letter.
> >
> > How is that a brainfart? It is simple, relatively unambiguous, and not
> > arbitrary. You really say the POSIX specified behaviour is "a brainfart",
> > but adding an arbitrary 10s throttle "but the process might be preempted
> > and lose the CPU to a lower priority task if it uses 10s of consecutive
> > CPU time" would eliminate that brainfart? I have to laugh.
>
> No, I did not say that. All I said is that giving the normal and
> common sense capable user/developer the chance to debug a runaway task
> w/o rebooting the system via the power off button is a sensible and
> useful default.

I don't deny that the runaway task thing is a *small* advantage. But
it is the only one, and weighed against lots of negatives.


> Your request to default to a possibly unusable system serves some yet
> to be explained higher goal, which is definitely out of the scope of
> common sense.
>
> You still did not explain why this behaviour is useful and your
> handwaving vs. some (probably closed source) customer application is
> not an argument at all.

You have it completely backwards. If someone wants to change a userspace API,
it is *they* who must not handwave about why "anybody who wants to do that is
broken anyway so we don't care about them".

I, on the other hand, opposing the API change, sure can handwave or find one
or two counter examples as to why we might have users relying on the old
behaviour.

The replies you got might convince you that your view of the rt world is not
the complete and only picture. But if not, then consider that rt tasks need
not have a fixed amount of work to be done per unit of time but they may
scale work according to the available CPU power. Or it may be something
that runs a polling loop I guess.


> > > > * We should break the API to cater for stupid users and distros who
> > > >   create local DoS and/or lock up their boxes (except this is trivial
> > > >   to solve by setting sysctls or having a watchdog or using sysrq)
> > >
> > > For the vast majority of users and RT developers a sane default of
> > > sanity measures is useful and sensible.
> >
> > You seriously develop complex rt tasks without having at least a simple
> > watchdog task?
>
> Dude, don't tell me how to design and debug a real time system.

I didn't tell you, I asked you. Do you develop without a watchdog? Do
you think the majority of RT developers do?

Because if so, then I certianly will tell you to use a watchdog to get
the debuggability you ask for, rather than break the kernel interface
for everyone else.. If not, then the RT developers debuggability
argument is false.


> It's not about me, but about the general usability and debuggability
> of Linux even in extreme situations, e.g. an unvoluntary runaway task,
> which we see even from time to time in bug reports. Having a sensible
> default guard is helping in the common case and denying it is just a
> selfserving attitude to keep some braindamaged customer niche
> application alive. Linux and Open Source is not about the customer
> application, it is about having a sane and safe environment for 99% of
> the use cases. Your pretious CPU hog SCHED_FIFO application is an
> engineering brainfart which is really not relevant to any community
> decision of a sane and per default safe guarded OS.

Enough with this strawman, please. I never argued in the context of having
a specific broken application. It is the concept of changing this interface
which is what I am arguing against.

However, assuming I did have some customer application, I would know why
you think it is OK that it has been broken "because it must be crap anyway".


> > > If someone wants to shoot himself in the foot then it's not an
> > > unreasonable request that he needs to disable the safety guards before
> > > pulling the trigger.
> >
> > root is allowed to shoot themselves in the foot. root is the safeguard.
>
> Sure. You are allowed to shoot yourself in the foot as well. Does the
> gun manufacturer omit safety guards just because you are allowed to
> and just because the 1990 version of the gun did not have that safety
> guard ?

Making arguments with metaphores like this is useless. How are we supposed
to have a sane technical argument otherwise?

So: root can shoot themselves in the foot, easily, in many ways. Lots of
ways do not have safeguards. This has never been considered a problem before.


> Again. Common sense is way more important than some green table
> specification and some esoteric customer application.

It is not some green table specification. It is really widely accepted
and implemented behaviour, and perhaps most importantly it has existed
that way in Linux for a long time.

I can't believe I have to argue so hard against this change to the API.

If you and your users or developers want a different scheduling policy
that throttles, WTF not just create a new SCHED_ policy? People that
ask for SCHED_FIFO are expecting to get what SCHED_FIFO gives in other
operating systems, in older Linux versions, and in specifications. You
can't tell me that *I'm* wrong for advocating that we implement this
correctly -- you have to tell all users of this API that they're wrong
for asking for it, and then you can provide a SCHED_FIFO_THROTTLED or
something for them to use.

