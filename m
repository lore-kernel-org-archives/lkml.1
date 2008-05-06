Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbYEFQVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbYEFQVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYEFQVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:21:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4096 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYEFQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:21:22 -0400
Subject: Re: x86: Clean up computation of HPET .mult variables
From: Daniel Walker <dwalker@mvista.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20080506125920.GA26295@beyonder.ift.unesp.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
	 <1210031888.17132.85.camel@localhost.localdomain>
	 <20080506021321.GA4928@Pilar.virtua.com.br>
	 <1210044218.17132.109.camel@localhost.localdomain>
	 <20080506125920.GA26295@beyonder.ift.unesp.br>
Content-Type: text/plain
Date: Tue, 06 May 2008 09:21:20 -0700
Message-Id: <1210090880.17132.140.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 09:59 -0300, Carlos R. Mafra wrote:
> On Mon  5.May'08 at 20:23:38 -0700, Daniel Walker wrote:
> > 
> > On Mon, 2008-05-05 at 23:13 -0300, Carlos R. Mafra wrote:
> > > So the savings in my patch is due to using the period directly, and
> > > not the frequency. That's what my idea was, so if you object then
> > > my attempt was a failure and should be forgotten :-)
> > > 
> > > Or maybe I should create a clocksource_period2mult to replace 
> > > clocksource_hz2mult and save the extra operation in more places too?
> > 
> > The one concern I have is the rounding that is done in the
> > clocksource_hz2mult(). The div_sc doesn't include it .. 
> 
> So that would be a point in favour of using div_sc(), right?

No, the other way. I think clocksource_hz2mult() is more accurate.

> > You could add a
> > clocksource_period2mult(), that would help out any one later that has a
> > period instead of hz ..
> 
> Hmm, clocksource_period2mult() would be just a rename of div_sc(), see
> for example how clocksource_hpet.mult is computed with my patch:
> 
> clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
> 
> However, hpet_clockevent.mult would also require the exchange of
> the first two arguments, due to the different definition of 'mult' in
> clockchips.h and clocksource.h
> 
> So I would like to ask if this different definition of mult 
> variables in clockevent versus clocksource is intentional or not.

clockevents convert nanoseconds to cycles, clocksources convert cycles
to nanosecond. So the mult would reflect that difference I imagine.

> And do you agree that your first suggestion of using clocksource_hz2mult
> makes the code a bit bigger due to the extra computation of the frequency?

I agree, but the size in this case takes a back seat to accuracy.

Daniel


