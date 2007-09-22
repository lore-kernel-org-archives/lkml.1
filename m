Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbXIVBn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbXIVBn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbXIVBnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:43:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36409 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbXIVBnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:43:46 -0400
Date: Fri, 21 Sep 2007 18:43:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070922014343.GM9059@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921152048.GF15697@goodmis.org> <20070921230343.GE9059@linux.vnet.ibm.com> <20070922003235.GJ9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212115160.4791@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0709212115160.4791@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 09:19:22PM -0400, Steven Rostedt wrote:
> 
> --
> On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> > >
> > > In any case, I will be looking at the scenarios more carefully.  If
> > > it turns out that GP_STAGES can indeed be cranked down a bit, well,
> > > that is an easy change!  I just fired off a POWER run with GP_STAGES
> > > set to 3, will let you know how it goes.
> >
> > The first attempt blew up during boot badly enough that ABAT was unable
> > to recover the machine (sorry, grahal!!!).  Just for grins, I am trying
> > it again on a machine that ABAT has had a better record of reviving...
> 
> This still frightens the hell out of me. Going through 15 states and
> failing. Seems the CPU is holding off writes for a long long time. That
> means we flipped the counter 4 times, and that still wasn't good enough?

Might be that the other machine has its 2.6.22 version of .config messed
up.  I will try booting it on a stock 2.6.22 kernel when it comes back
to life -- not sure I ever did that before.  Besides, the other similar
machine seems to have gone down for the count, but without me torturing
it...

Also, keep in mind that various stages can "record" a memory misordering,
for example, by incrementing the wrong counter.

> Maybe I'll boot up my powerbook to see if it has the same issues.
> 
> Well, I'm still finishing up on moving into my new house, so I wont be
> available this weekend.

The other machine not only booted, but has survived several minutes of
rcutorture thus far.  I am also trying POWER5 machine as well, as the
one currently running is a POWER4, which is a bit less aggressive about
memory reordering than is the POWER5.

Even if they pass, I refuse to reduce GP_STAGES until proven safe.
Trust me, you -don't- want to be unwittingly making use of a subtely
busted RCU implementation!!!

						Thanx, Paul
