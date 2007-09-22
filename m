Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXIVEK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXIVEK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 00:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXIVEKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 00:10:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51980 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbXIVEKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 00:10:49 -0400
Date: Fri, 21 Sep 2007 21:10:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070922041045.GB11123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921152048.GF15697@goodmis.org> <20070921230343.GE9059@linux.vnet.ibm.com> <20070922003235.GJ9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212115160.4791@gandalf.stny.rr.com> <20070922014343.GM9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212249270.6217@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0709212249270.6217@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:56:56PM -0400, Steven Rostedt wrote:
> 
> [ sneaks away from the family for a bit to answer emails ]

[ same here, now that you mention it... ]

> --
> On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> 
> > On Fri, Sep 21, 2007 at 09:19:22PM -0400, Steven Rostedt wrote:
> > >
> > > --
> > > On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> > > > >
> > > > > In any case, I will be looking at the scenarios more carefully.  If
> > > > > it turns out that GP_STAGES can indeed be cranked down a bit, well,
> > > > > that is an easy change!  I just fired off a POWER run with GP_STAGES
> > > > > set to 3, will let you know how it goes.
> > > >
> > > > The first attempt blew up during boot badly enough that ABAT was unable
> > > > to recover the machine (sorry, grahal!!!).  Just for grins, I am trying
> > > > it again on a machine that ABAT has had a better record of reviving...
> > >
> > > This still frightens the hell out of me. Going through 15 states and
> > > failing. Seems the CPU is holding off writes for a long long time. That
> > > means we flipped the counter 4 times, and that still wasn't good enough?
> >
> > Might be that the other machine has its 2.6.22 version of .config messed
> > up.  I will try booting it on a stock 2.6.22 kernel when it comes back
> > to life -- not sure I ever did that before.  Besides, the other similar
> > machine seems to have gone down for the count, but without me torturing
> > it...
> >
> > Also, keep in mind that various stages can "record" a memory misordering,
> > for example, by incrementing the wrong counter.
> >
> > > Maybe I'll boot up my powerbook to see if it has the same issues.
> > >
> > > Well, I'm still finishing up on moving into my new house, so I wont be
> > > available this weekend.
> >
> > The other machine not only booted, but has survived several minutes of
> > rcutorture thus far.  I am also trying POWER5 machine as well, as the
> > one currently running is a POWER4, which is a bit less aggressive about
> > memory reordering than is the POWER5.
> >
> > Even if they pass, I refuse to reduce GP_STAGES until proven safe.
> > Trust me, you -don't- want to be unwittingly making use of a subtely
> > busted RCU implementation!!!
> 
> I totally agree. This is the same reason I want to understand -why- it
> fails with 3 stages. To make sure that adding a 4th stage really does fix
> it, and doesn't just make the chances for the bug smaller.

Or if it really does break, as opposed to my having happened upon a sick
or misconfigured machine.

> I just have that funny feeling that we are band-aiding this for POWER with
> extra stages and not really solving the bug.
> 
> I could be totally out in left field on this. But the more people have a
> good understanding of what is happening (this includes why things fail)
> the more people in general can trust this code.  Right now I'm thinking
> you may be the only one that understands this code enough to trust it. I'm
> just wanting you to help people like me to trust the code by understanding
> and not just having faith in others.

Agreed.  Trusting me is grossly insufficient.  For one thing, the Linux
kernel has a reasonable chance of outliving me.

> If you ever decide to give up jogging, we need to make sure that there are
> people here that can still fill those running shoes (-:

Well, I certainly don't jog as fast or as far as I used to!  ;-)

						Thanx, Paul
