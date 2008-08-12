Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYHLNKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYHLNKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYHLNKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:10:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44217 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYHLNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:10:39 -0400
Date: Tue, 12 Aug 2008 14:00:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080812120031.GD8806@elf.ucw.cz>
References: <1216695757.18980.16.camel@shinybook.infradead.org> <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com> <20080809125447.GA13169@ucw.cz> <20080811173526.GA28661@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811173526.GA28661@linux-os.sc.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >which will run some time later when the CPU happens to be awake. And a
> > > >non-deferrable timer at the hard deadline, to ensure it really does
> > > >happen by then.
> > > >
> > >
> > > One concern I have is drivers using range_timers thinking that they need
> > > some upper bound, while all they need is a simple deferrable timer. With that
> > > we will have multiple timers waking up the CPU all the time (say, on
> > > different CPUs) problem again. Even without the timers waking up all
> > 
> > I don't get it. Who has timers that can be deferred forever? At that
> > point they may simply not set the timer at all, right?
> > 
> 
> I don't think I said drivers have or need timers that can be deferred forever.
> 
> My point is, is it worth the overhead of setting and deleting additional timer,
> just because drivers think that they need to use this new interface,
> need to set a upper bound and come up with random upper bounds.
> Apart from the overhead of setup and teardown we will somewhat negate the
> benefits of deferrable timers as the upper bound hard timers can fire at
> different times waking up the CPUs frequently.

> I understand that some drivers need this kind of upper limit. I am not sure
> whether all drivers need it and if not, how can we restrict drivers from using
> this when they don't really need it.

Do you have example of driver that does NOT need upper limit?

Like... lets take ATA.

submit_command()
if command is not back in ~5 seconds, it probably timed out.

So you set soft limit to 5 seconds, and hard limit to 10. You
definitely want user to know something is wrong after 10 seconds,
right?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
