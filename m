Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXIMHfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXIMHfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXIMHfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:35:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:1561 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXIMHfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q8cbgzQvjBLNULqSNOelOiOnjORn4WjEqD7f3EMIPkibKbxghmwbaZkKUixLbC0sHnp3//ye/fptf5Al5bXo2CCKna/q2nPinXMtPf/kVIJ1je6IZfXfN81Wycgn/hsP662D0QOh6Cgj97V1LJCuYkbNS1yGpKHjl3Q1eygnAE8=
Message-ID: <f24d23310709130034q45e0ec37obc58216e71534f79@mail.gmail.com>
Date: Thu, 13 Sep 2007 03:34:59 -0400
From: "debian developer" <debiandev@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [announce] CFS-devel, performance improvements
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709121405130.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709121405130.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore the previous mail, i messed it up bad.

On 9/12/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Tue, 11 Sep 2007, Ingo Molnar wrote:
>
> > fresh back from the Kernel Summit, Peter Zijlstra and me are pleased to
> > announce the latest iteration of the CFS scheduler development tree. Our
> > main focus has been on simplifications and performance - and as part of
> > that we've also picked up some ideas from Roman Zippel's 'Really Fair
> > Scheduler' patch as well and integrated them into CFS. We'd like to ask
> > people go give these patches a good workout, especially with an eye on
> > any interactivity regressions.
>
> I'm must really say, I'm quite impressed by your efforts to give me as
> little credit as possible.
> On the one hand it's of course positive to see so much sudden activity, on
> the other hand I'm not sure how much had happened if I hadn't posted my
> patch, I don't really think it were my complaints about CFS's complexity
> that finally lead to the improvements in this area. I presented the basic
> concepts of my patch already with my first CFS review, but at that time
> you didn't show any interest and instead you were rather quick to simply
> dismiss it. My patch did not add that much new, it's mostly a conceptual
> improvement and describes the math in more detail, but it also
> demonstrated a number of improvements.
>
> > The combo patch against 2.6.23-rc6 can be picked up from:
> >
> >   http://people.redhat.com/mingo/cfs-scheduler/devel/
> >
> > The sched-devel.git tree can be pulled from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
>
> Am I the only one who can't clone that thing? So I can't go into much
> detail about the individual changes here.
> The thing that makes me curious, is that it also includes patches by
> others. It can't be entirely explained with the Kernel Summit, as this is
> not the first time patches appear out of the blue in form of a git tree.
> The funny/sad thing is that at some point Linus complained about Con that
> his development activity happend on a separate mailing list, but there was
> at least a place to go to. CFS's development appears to mostly happen in
> private. Patches may be your primary form of communication, but that isn't
> true for many other people, with patches a lot of intent and motivation
> for a change is lost. I know it's rather tempting to immediately try out
> an idea first, but would it really hurt you so much to formulate an idea
> in a more conventional manner? Are you afraid it might hurt your
> ueberhacker status by occasionally screwing up in public? Patches on the
> other hand have the advantage to more easily cover that up by simply
> posting a fix - it makes it more difficult to understand what's going on.
> A more conventional way of communication would give more people a chance
> to participate, they may not understand every detail of the patch, but
> they can try to understand the general concepts and apply them to their
> own situation and eventually come up with some ideas/improvements of their
> own, they would be less dependent on you to come up with a solution to
> their problem. Unless of course that's exactly what you want - unless you
> want to be in full control of the situation and you want to be the hero
> that saves the day.
>
> > There are lots of small performance improvements in form of a
> > finegrained 29-patch series. We have removed a number of features and
> > metrics from CFS that might have been needed but ended up being
> > superfluous - while keeping the things that worked out fine, like
> > sleeper fairness. On 32-bit x86 there's a ~16% speedup (over -rc6) in
> > lmbench (lat_ctx -s 0 2) results:
>
> In the patch you really remove _a_lot_ of stuff. You also removed a lot of
> things I tried to get you to explain them to me. On the one hand I could
> be happy that these things are gone, as they were the major road block to
> splitting up my own patch. On the other hand it still leaves me somewhat
> unsatisfied, as I still don't know what that stuff was good for.
> In a more collaborative development model I would have expected that you
> tried to explain these features, which could have resulted in a discussion
> how else things can be implemented or if it's still needed at all. Instead
> of this you now simply decide unilaterally that these things are not
> needed anymore.
>
> BTW the old sleeper fairness logic "that worked out fine" is actually
> completely gone and is now conceptually closer to what I'm already doing
> in my patch (only the amount of sleeper bonus differs).
>
> >                                   (microseconds, lower is better)
> >      ------------------------------------------------------------
> >         v2.6.22    2.6.23-rc6(CFS)     v2.6.23-rc6-CFS-devel
> >      ----------------------------------------------------
> >            0.70          0.75                0.65
> >            0.62          0.66                0.63
> >            0.60          0.72                0.69
> >            0.62          0.74                0.61
> >            0.69          0.73                0.53
> >            0.66          0.73                0.63
> >            0.63          0.69                0.61
> >            0.63          0.70                0.64
> >            0.61          0.76                0.61
> >            0.69          0.74                0.63
> >      ----------------------------------------------------
> >       avg: 0.64          0.72 (+12%)         0.62 (-3%)
> >
> > there is a similar speedup on 64-bit x86 as well. We are now a bit
> > faster than the O(1) scheduler was under v2.6.22 - even on 32-bit. The
> > main speedup comes from the avoidance of divisions (or shifts) in the
> > wakeup and context-switch fastpaths.
> >
> > there's also a visible reduction in code size:
> >
> >    text    data     bss     dec     hex filename
> >   13369     228    2036   15633    3d11 sched.o.before  (UP, nodebug)
> >   11167     224    1988   13379    3443 sched.o.after   (UP, nodebug)
>
> Well, one could say that you used every little trick in the book to get
> these numbers down. On the other hand at this point it's a little unclear
> whether you maybe removed it a little too much to get there, so the
> significance of these numbers is a bit limited.

is'nt it gud to use all those tricks if it helps? we'll know soon if
it helps from the testing which it'll get. i'm just concerned about
doing these cleanups so late in the rc cycle.
And Ingo, please do explain the reasons for all these cleanups and why
they were put there in the first place.

> > Changes: besides the many micro-optimizations, one of the changes is
> > that se->vruntime (virtual runtime) based scheduling has been introduced
> > gradually, step by step - while keeping the wait_runtime metric working
> > too. (so that the two methods are comparable side by side, in the same
> > scheduler)
>
> I can't quite see that, the wait_runtime metric is relative to fair_clock
> and this is gone without any replacement, in my patch I at least
> calculate these values for the debug output, but in your patch even that
> is simply gone, so I'm not sure what you actually compare "side by side".
>
> > The ->vruntime metric is similar to the ->time_norm metric used by
> > Roman's patch (and both are losely related to the already existing
> > sum_exec_runtime metric in CFS), it's in essence the sum of CPU time
> > executed by a task, in nanoseconds - weighted up or down by their nice
> > level (or kept the same on the default nice 0 level). Besides this basic
> > metric our implementation and math differs from RFS.
>
> At this point it gets really interesting - I'm amazed how much you stress
> the differences. If we take the basic math as I more simply explained it
> in this example http://lkml.org/lkml/2007/9/3/168, you now also make the
> step from the relative wait_runtime value to an absolute virtual time
> value. Basically it's really the same thing, only the resolution differs.
> This means you already reimplemented a key element of my patch, so would
> you please give me at least that much credit?
> The rest of the math is indeed different - it's simply missing. What is
> there is IMO not really adequate. I guess you will see the differences,
> once you test a bit more with different nice levels. There's a good reason
> I put that much effort into maintaining a good, but still cheap average,
> it's needed for a good task placement. There is of course more than one
> way to implement this, so you'll have good chances to simply reimplement
> it somewhat differently, but I'd be surprised if it would be something
> completely different.
>
> To make it very clear to everyone else: this is primarely not about
> getting some credit, although that's not completely unimportant of course.

I give you credit for coming up with the math which is so easily
understandable comapared to CFS. Don't loose patience, like Con did.
Please keep fighting if u think ur code is better. It'll help all of
us out here.

regards,
debian dev
