Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYHZLDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYHZLDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYHZLDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:03:42 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:39115 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753180AbYHZLDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:03:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tU4Fuu6PyiqtVqCUIxwCpxh+ULfNAUsolXlCj3IBMvAcaiCT12KL5HfNzY9qQhOgzLf7TTX8NxtBiZ4DMPhZdhwHkjkMUJE8dfiPJ+Td0yWkcLPOpdWgiESszVpF2sv2fAsoKVd5Uu/POXmWduVpgVCv0A7kda1NDMLVh7t3jGg=  ;
X-YMail-OSG: Y8n8D0sVM1lIx00edFRdhDLDZbDJ.7XhxOcsJYeHFmSrBuBATMMQZ.MjBRZtYgUhvIvqE6vQJDNdfkDStrSfsBzFigQWr8f89kWAMZRK56B1np7ZdyIFj3cL2whdJ2w8NtQNFHhsBr7LScbqw2PUSKkk
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Tue, 26 Aug 2008 21:03:33 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808261944.47176.nickpiggin@yahoo.com.au> <20080826102937.GA25732@elte.hu>
In-Reply-To: <20080826102937.GA25732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808262103.34159.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 20:29, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > So... no reply to this? I'm really wondering how it's OK to break
> > > > documented standards and previous Linux behaviour by default for
> > > > something that it is trivial to solve in userspace? [...]
> > >
> > > I disagree
> >
> > Disagree with what? That it's a problem to basically break the
> > guarantee realtime SCHED_ policies have previously provided?
>
> I think you are sticking to the rigid letter of some standard without
> seeing the bigger picture.
>
> Firstly, please realize that to do a "successful" POSIX or other
> conformance run a default Linux distribution has to be tweaked and often
> crippled literally dozens and often hundreds of ways. In this case you
> also have to add one more entry to /etc/sysctl.conf, to allow RT tasks
> to monopolize CPU time. So you can still get the POSIX sticker if you
> want to - nothing changed about that.

I'm not talking about anything else except this particular interface.
I'm also not talking about getting a sticker or anything, but providing
_expected_ and _documented_ and _matching with previous_ behaviour.


> Secondly, my big picture point is that our task is to make Linux more
> useful and more usable by default. You seem to be arguing that RT tasks
> should be allowed by default to monopolize all CPU time forever, and i
> disagree with that proposition.

Then that's not SCHED_FIFO/SCHED_RT, so just make another scheduling class.
SCHED_FIFO and SCHED_RT can use up all CPU time, but that's why they are
privileged by default. root has always been able to do silly things, that's
nothing new.

It is the easiest thing in the world to have made a new scheduling class
rather than break existing ones.


> But do _you_ actually use such runaway CPU-monopolizing RT tasks? Try it
> one day and you'll quickly meet various practical problems. Let a
> SCHED_FIFO:99 RT task run long enough and on all the main distributions
> you will get:
>
>   BUG: soft lockup - CPU#1 stuck for 61s! [bash:3659]

Again, I'm talking about the upstream kernel, and I'm not actually interested
in other bugs or problems because the way to fix things is to solve one bug
at a time and not give up just because there are some other bugs.

Soft lockup message I don't think causes much pain, except it may be useful to
actually panic and do failover with but AFAIKS it is not enabled by default
anyway.


> But monopolizing any resource in a 100% way (which you are arguing for)
> is just not a generic Linux system and for years (seeing all the
> practical problems with it) we tried various methods to contain
> SCHED_FIFO tasks in the scheduler, none was really acceptable for
> mainline.

Actually you can pretty well isolate kernel services and interrupts from one
CPU and run rt tasks on that. But anyway, who are you to impose a magical
10s limit on it and _really_ break it by design?

> Peter's changes were clean and useful at last. There's lots of apps that
> use SCHED_FIFO for a short burst of activity, and 100% of the ones i
> know do not want to run for longer than 10 seconds.
>
> Thirdly, your argument can only be consistent if you also argue for the
> softlockup watchdog to be disabled. Do you make that point?

It is disabled by default.


> > > and what do you mean by "trivial to solve in user-space"?
> >
> > I mean that if some distro has turned on the RT scheduling ulimit by
> > default and now finds themselves with a local DoS for unpriviliged
> > users as a result, then either that distro should just make their init
> > scripts set the throttle and break the API themselves, or they should
> > start a watchdog at a higher priority than unprivileged user can set.
>
> ... but that's by far not the only usecase. Very frequently i've seen
> bugreports from people with runaway RT tasks (which tasks were running
> as root) where that runaway behavior was completely unintended. Audio
> apps or other apps getting into a loop and locking up the system.

And how is that a kernel problem? Should we fix the kernel against
a stupid user running rm -rf / as root?


> Worse than that, such bugs prevented the system from being debugged by
> plain users. A runaway RT task that monopolizes the CPU will lock it up
> completely, requiring a hard reset or a power cycle. That can lose data,
> etc. If we allow it to lock up the CPU for up to 10 seconds it will
> still be noticed if that is unintentional (the system is very slow), but
> the problem can be debugged.

Tell the stupid audio program writers to run a watchdog task if they
are running a non-trivial amount of code with rt sched policy. Like any
other sane rt apps should have.


> By making RT tasks not lock up like that by default and allowing them to
> 'only' monopolize the CPU up to 10 seconds, we make the system more
> debuggable and more useful in general. It is a quite reasonable
> proposition that makes Linux useful in general, and you seem to be
> ignoring that practical angle altogether. It's not about allowing
> user-space rtprio-rlimit driven apps to not run away, it's about
> allowing _any_ RT task to be throttled by default if they run away.

Privileged users can break the kernel and kill everyone so easily anyway,
that this seems insane.


> On the other side of the equation, what exact application do you know
> that absolutely relies on being able to monopolize all CPU time in
> excess of 10 seconds? I havent heard much about that usecase. Why does
> that particular RT app do it, because that behavior sounds _very_ weird
> to me.

Somebody already reported their app failed with 1s. What makes you
think there are none around that fail with 10s? Changing old existing
userspace APIs can't be done just because a single person (you) can't
think of a counter example.

Especially not when it could equally be done just by introducing a new
API.


> If it's some embedded system or other special-purpose app then it can
> tweak the sysctl no problem. (it will have to do it anyway, to turn off
> the softlockup watchdog)

It won't because it won't be on by default.


> If it's some general purpose Linux app, exactly which one is it? If it's
> an OSS app please give me an URL to its source code, we need to fix it
> urgently. Running for more than 10 seconds wastes power like mad and is
> generally a very un-nice thing to do.

No, what's not nice is to subtly change behaviour in a way that's not
going to be detected except by random failures in the field.


> All in one, since the 'buggy RT app runs into a loop and monopolizes the
> CPU' case is much more common, i do think that supporting that usecase
> is the better choice for a default.

I disagree.

And given the amount of dual core CPUs around these days, I suspect you
exaggerate the number of bug reports you get about this too. But anyway
as I said, if you're enabling rt prio ulimit by default in your distro
and then dislike the local DoS it opens up, then why can't you also just
change the rt throttle yourself rather than breaking upstream?
