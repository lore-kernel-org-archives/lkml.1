Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHJUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHJUDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 16:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYHJUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 16:02:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3672 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754347AbYHJUCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 16:02:55 -0400
Date: Sat, 9 Aug 2008 14:54:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080809125447.GA13169@ucw.cz>
References: <1216695757.18980.16.camel@shinybook.infradead.org> <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-07-28 17:36:57, Pallipadi, Venkatesh wrote:
> 
> 
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of David
> >Woodhouse
> >Sent: Monday, July 21, 2008 8:03 PM
> >To: linux-kernel@vger.kernel.org
> >Cc: Thomas Gleixner; Ingo Molnar; arjan@infradead.org
> >Subject: [RFC] Imprecise timers.
> >
> >Many users of timers don't really care too much about exactly
> >when their
> >timer fires -- and waking a CPU to satisfy such a timer is a waste of
> >power. This patch implements a 'range' timer which will fire
> >at a 'convenient'
> >moment within given constraints.
> >
> >It's implemented by a deferrable timer at the beginning of the range,
> >which will run some time later when the CPU happens to be awake. And a
> >non-deferrable timer at the hard deadline, to ensure it really does
> >happen by then.
> >
> 
> One concern I have is drivers using range_timers thinking that they need
> some upper bound, while all they need is a simple deferrable timer. With that
> we will have multiple timers waking up the CPU all the time (say, on
> different CPUs) problem again. Even without the timers waking up all

I don't get it. Who has timers that can be deferred forever? At that
point they may simply not set the timer at all, right?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
