Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbYFWUZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbYFWUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYFWUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:25:29 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57680 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763956AbYFWUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:25:28 -0400
Date: Mon, 23 Jun 2008 13:15:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, josh@freedesktop.org, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent rcutorture less power-hungry
Message-ID: <20080623201516.GC10595@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com> <20080622131712.54ba732c@infradead.org> <1214243649.4440.10.camel@Aeon> <20080623110706.197f25b1@infradead.org> <1214251374.4440.48.camel@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214251374.4440.48.camel@Aeon>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:02:54PM +0000, Darren Hart wrote:
> On Mon, 2008-06-23 at 11:07 -0700, Arjan van de Ven wrote:
> > On Mon, 23 Jun 2008 17:54:09 +0000
> > Darren Hart <dvhltc@us.ibm.com> wrote:
> > 
> > > I'm a little concerned about how this will affect real-time
> > > performance, as queueing up lots of timers all at once can lead to
> > > long running timer expiration handlers.  If just a schedule_timeout,
> > > I suppose we are only looking at a process wakeup, as opposed to a
> > > softirq context callback function?
> > 
> > in reality, the time it takes to deliver the interrupt (including
> > waking the CPU up etc), is likely to be an order or two of magnitude
> > higher than this kind of code loop.... 
> 
> Sure, if we just look at one of them.  Any idea how many such items
> we're looking at rounding up to fire at the same time?  Is it dozens,
> hundreds, thousands?

Hello, Darren,

Wouldn't these timers be running at low priority, so that high-priority
realtime tasks would preempt them?

							Thanx, Paul
