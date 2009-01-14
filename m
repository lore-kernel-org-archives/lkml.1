Return-Path: <linux-kernel-owner+w=401wt.eu-S1764008AbZANQBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764008AbZANQBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763963AbZANQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:00:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45102 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763957AbZANQAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:00:50 -0500
Date: Wed, 14 Jan 2009 08:00:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com
Subject: Re: [PATCH fyi] RCU: the bloatwatch edition
Message-ID: <20090114160048.GA6734@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090113221724.GA15307@linux.vnet.ibm.com> <20090114104055.GD2913@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114104055.GD2913@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:40:55AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Just FYI, not for inclusion.
> > 
> > This patch is a version of RCU designed for !CONFIG_SMP provided as a 
> > proof of concept of a small-footprint RCU implementation.  In 
> > particular, the implementation of synchronize_rcu() is extremely 
> > lightweight and high performance.  It passes moderate rcutorture testing 
> > in each of the four relevant configurations (combinations of NO_HZ and 
> > PREEMPT) on x86.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> maybe it could be included - dependent on PREEMPT, just like we have SLOB?

I suppose that the fact that it already depends on !SMP should keep
it hidden from most people, and it does work just fine for !PREEMPT.
My concern is rather that if no one is using it, the code will bitrot
rather quickly.  None of us needs a broken RCU implementation in mainline,
least of all me.  ;-)

> it would also be rather educative IMO: if someone wants to understand the 
> core concepts of RCU, start with kernel/rcutiny.c. We are getting 
> complaints from academic institutions that the Linux kernel is getting too 
> complex to teach in courses - and that's a pity.

Yeah, I have had to refer a number of institutions to various LWN
articles.  I think that it is safe to say that LWN is not on every
university's normal reading list.  ;-)  One (surprisingly prominent)
institution that -does- read LWN unfortunately chose "The design
of preemptible read-copy-update" to introduce themselves to RCU
(http://lwn.net/Articles/253651/), and, needless to say, found it
tough going.  I offered my sympathies and pointed them at the "What is
RCU?" LWN series.

So it might well be good to have simplified implementations for academic
study and perhaps also for deep embedded use.  Sort of like the approach
for designing video games -- easy first level, second level is a bit
harder, and so on.

							Thanx, Paul
