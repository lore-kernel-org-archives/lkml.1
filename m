Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYKURRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYKURRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYKURQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:16:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756198AbYKURQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:16:50 -0500
Date: Fri, 21 Nov 2008 11:16:49 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v3] SGI RTC: add clocksource/clockevent driver and generic timer vector
Message-ID: <20081121171649.GB12370@sgi.com>
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com> <20081120095943.GF6885@elte.hu> <49261276.10408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49261276.10408@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 05:44:22PM -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> >> The following patches provide a driver for synchronized RTC 
> >> clocksource and clockevents for SGI systems, as well as a generic 
> >> timer system interrupt.
> >>
> >> With these patches, a module can be installed that registers the 
> >> system-wide synchronized RTC clocksource and timers as both a 
> >> clocksource and clockevents device running in high resolution mode.
> >>
> >> [PATCH 1/2 v3] SGI RTC: add clocksource driver
> >> [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
> > 
> > Looks very clean and well-done to me.
> > 
> > I had to take a good look at the rtc_timer_head->expires[] construct - 
> > but i guess that's the best approach, as the max number of entries is 
> > hard to judge at build time. (and we wont get any real limit 
> > protection from gcc anyway)
> > 
> > Thomas, any objections?
> 
> I have *extremely* serious reservations about reserving even more
> hardware vectors for SGI only.  This affects all systems, and quite
> frankly should not be necessary at all.
> 
> The SGI UV people have pushed this at a number of points in the past,
> and we have told them to use an irqchip instead.  This patch tries to
> allocate yet another reserved vector, instead.

I labeled the system vector as generic to indicate that this is available
to other platforms.  See my other email to you for the reasons why I did
not use an irq instead.
