Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYHKRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYHKRfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYHKRf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:35:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYHKRf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,189,1217833200"; 
   d="scan'208";a="428214005"
Date: Mon, 11 Aug 2008 10:35:26 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080811173526.GA28661@linux-os.sc.intel.com>
References: <1216695757.18980.16.camel@shinybook.infradead.org> <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com> <20080809125447.GA13169@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809125447.GA13169@ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 05:54:47AM -0700, Pavel Machek wrote:
> On Mon 2008-07-28 17:36:57, Pallipadi, Venkatesh wrote:
> >
> >
> > >-----Original Message-----
> > >From: linux-kernel-owner@vger.kernel.org
> > >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of David
> > >Woodhouse
> > >Sent: Monday, July 21, 2008 8:03 PM
> > >To: linux-kernel@vger.kernel.org
> > >Cc: Thomas Gleixner; Ingo Molnar; arjan@infradead.org
> > >Subject: [RFC] Imprecise timers.
> > >
> > >Many users of timers don't really care too much about exactly
> > >when their
> > >timer fires -- and waking a CPU to satisfy such a timer is a waste of
> > >power. This patch implements a 'range' timer which will fire
> > >at a 'convenient'
> > >moment within given constraints.
> > >
> > >It's implemented by a deferrable timer at the beginning of the range,
> > >which will run some time later when the CPU happens to be awake. And a
> > >non-deferrable timer at the hard deadline, to ensure it really does
> > >happen by then.
> > >
> >
> > One concern I have is drivers using range_timers thinking that they need
> > some upper bound, while all they need is a simple deferrable timer. With that
> > we will have multiple timers waking up the CPU all the time (say, on
> > different CPUs) problem again. Even without the timers waking up all
> 
> I don't get it. Who has timers that can be deferred forever? At that
> point they may simply not set the timer at all, right?
> 

I don't think I said drivers have or need timers that can be deferred forever.

My point is, is it worth the overhead of setting and deleting additional timer,
just because drivers think that they need to use this new interface,
need to set a upper bound and come up with random upper bounds.
Apart from the overhead of setup and teardown we will somewhat negate the
benefits of deferrable timers as the upper bound hard timers can fire at
different times waking up the CPUs frequently.

I understand that some drivers need this kind of upper limit. I am not sure
whether all drivers need it and if not, how can we restrict drivers from using
this when they don't really need it.

Thanks,
Venki


