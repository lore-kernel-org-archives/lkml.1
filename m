Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZG3RO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZG3RO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZG3ROZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:14:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34820 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZG3ROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:14:24 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dwalker@fifo99.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090730125351.6f16e9ec@skybase>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 10:12:53 -0700
Message-Id: <1248973973.3331.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 12:53 +0200, Martin Schwidefsky wrote:
> On Wed, 29 Jul 2009 11:17:16 -0600
> dwalker@fifo99.com wrote:
> 
> > On Wed, 2009-07-29 at 19:09 +0200, Martin Schwidefsky wrote:
> > > On Wed, 29 Jul 2009 11:02:21 -0600
> > > dwalker@fifo99.com wrote:
> > > 
> > > > On Wed, 2009-07-29 at 18:50 +0200, Martin Schwidefsky wrote:
> > > > 
> > > > > void clocksource_change_rating(struct clocksource *cs, int rating)
> > > > 
> > > > > the two functions do different things. What exactly is the idea you've
> > > > > got in mind?
> > > > 
> > > > It's only the case when the rating goes to zero .. That makes the
> > > > clocksource unusable, which is very much like unregistering it..
> > > 
> > > True, the clocksource code won't pick the clock any more as long as
> > > there is an alternative clock available. It still shows up in the list
> > > of clocks though and you can do an override with it. 
> > 
> > I'm not sure allowing that type of override a good idea tho .. I don't
> > think it's considered a usable clock when the rating goes to zero.
> 
> Override as the root user -> your foot, no? The whole override stuff is
> there for the case that the clocksource selection picked a broken clock
> and you want to force the system into a semi-working state. Ideally the
> whole override would go away, but that is probably wishful thinking..

Its also not only for when a system is broken, but quite often is used
when the system selects a slower clocksource out of caution and the user
wants to override that decision. The kernel really should get it right,
but there is always the case of an old kernel on new hardware that might
require it. 

thanks
-john

