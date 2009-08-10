Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZHJPIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZHJPIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZHJPIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:08:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46476 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZHJPII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:08:08 -0400
Date: Mon, 10 Aug 2009 08:08:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, manfred@colorfullife.com
Subject: Re: [BUG] race of RCU vs NOHU
Message-ID: <20090810150807.GA6791@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090807151529.2806b8b4@skybase> <20090807142957.GB6700@linux.vnet.ibm.com> <20090810142535.3e685109@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810142535.3e685109@skybase>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 02:25:35PM +0200, Martin Schwidefsky wrote:
> On Fri, 7 Aug 2009 07:29:57 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Aug 07, 2009 at 03:15:29PM +0200, Martin Schwidefsky wrote:
> > > Hi Paul,
> > > I analysed a dump of a hanging 2.6.30 system and found what I think is
> > > a bug of RCU vs NOHZ. There are a number of patches ontop of that
> > > kernel but they should be independent of the bug.
> > > 
> > > The systems has 4 cpus and uses classic RCU. cpus #0, #2 and #3 woke up
> > > recently, cpu #1 has been sleeping for 5 minutes, but there is a pending
> > > rcu batch. The timer wheel for cpu #1 is empty, it will continue to
> > > sleep for NEXT_TIMER_MAX_DELTA ticks.
> > 
> > Congratulations, Martin!  You have exercised what to date has been a
> > theoretical bug identified last year by Manfred Spraul.  The fix is to
> > switch from CONFIG_RCU_CLASSIC to CONFIG_RCU_TREE, which was added in
> > 2.6.29.
> > 
> > Of course, if you need to work with an old kernel version, you might
> > still need a patch, perhaps for the various -stable versions.  If so,
> > please let me know -- otherwise, I will focus forward on CONFIG_RCU_TREE
> > rather than backwards on CONFIG_RCU_CLASSIC.
> 
> SLES11 is 2.6.27 and uses classic RCU. The not-so theoretical bug is
> present there and I think it needs to be fixed :-/

I was afraid of that.  ;-)

Given that there are some other theoretical bugs in Classic RCU involving
interrupts and CONFIG_NO_HZ, would backporting CONFIG_TREE_RCU make more
sense than playing whack-a-mole on Classic RCU bugs?

							Thanx, Paul
