Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYEFNB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYEFNB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYEFNBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:01:47 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:59180 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYEFNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:01:47 -0400
Date: Tue, 6 May 2008 09:59:20 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080506125920.GA26295@beyonder.ift.unesp.br>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	venkatesh.pallipadi@intel.com
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <1210031888.17132.85.camel@localhost.localdomain> <20080506021321.GA4928@Pilar.virtua.com.br> <1210044218.17132.109.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210044218.17132.109.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  5.May'08 at 20:23:38 -0700, Daniel Walker wrote:
> 
> On Mon, 2008-05-05 at 23:13 -0300, Carlos R. Mafra wrote:
> > So the savings in my patch is due to using the period directly, and
> > not the frequency. That's what my idea was, so if you object then
> > my attempt was a failure and should be forgotten :-)
> > 
> > Or maybe I should create a clocksource_period2mult to replace 
> > clocksource_hz2mult and save the extra operation in more places too?
> 
> The one concern I have is the rounding that is done in the
> clocksource_hz2mult(). The div_sc doesn't include it .. 

So that would be a point in favour of using div_sc(), right?

> You could add a
> clocksource_period2mult(), that would help out any one later that has a
> period instead of hz ..

Hmm, clocksource_period2mult() would be just a rename of div_sc(), see
for example how clocksource_hpet.mult is computed with my patch:

clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);

However, hpet_clockevent.mult would also require the exchange of
the first two arguments, due to the different definition of 'mult' in
clockchips.h and clocksource.h

So I would like to ask if this different definition of mult 
variables in clockevent versus clocksource is intentional or not.

And do you agree that your first suggestion of using clocksource_hz2mult
makes the code a bit bigger due to the extra computation of the frequency?

My patch saves 49 bytes, and I thought that being careful in the code
comments would make this change a safe thing (because everyone will
understand how the computation is done and that there is a difference
in the definitions).


