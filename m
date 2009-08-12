Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZHLTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZHLTH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZHLTH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:07:26 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:33324 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZHLTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:07:25 -0400
Date: Wed, 12 Aug 2009 22:07:03 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
Message-ID: <20090812190659.GA21001@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090812064745.GA17285@gandalf>
 <20090812100517.GA11227@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812100517.GA11227@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 12, 2009 at 11:05:17AM +0100, Mark Brown wrote:
> You actually get notification on any change the supply chooses to notify
> the core on IIRC.

true, but that's only (at least on the chips I've seen) for the presence
of the charger. I haven't seen a chip that notify you based on a
threshold of e.g. voltage change or temperature change. Which would be a
really nice feature: you could give a "best" temperature value and a
threshold of +-10% and if that changes over that limit, device
interrupts processor, or something like that.

> I'd be inclined to put at least some of the basic charge cycle into the
> kernel but it doesn't concern me too much so long as the user/kernel
> interface doesn't expose us to the risk of damaging the battery through
> inattention.

sounds reasonable.

> It's probably more interesting to think of prioritising between multiple
> batteries here - most systems I've seen have power path management which
> handles all the incoming power sources and uses them to maintain an
> unregulated power domain which is then used as the root supply for the
> rest of the system, including the battery chargers.  This takes the
> supply selection well out of the domain of charging.

sounds really good. Haven't a system like that so far :-(

> This is the really tricky bit since you need some idea of the load from
> the rest of the system if the charger really is able to draw current.
> Normally there's a combination of checking various gates to see if it's
> possible to start charging with the current parameters and then things
> like monitoring the supply voltage to the charger to make sure it's not
> drooping and taking corrective action if it does.
> 
> My feeling is that in addition to what you're saying the in-kernel side
> of things should also describe how the system is wired together since
> that's the sort of task the kernel is doing anyway, it's something
> that is fixed in the hardware and it's potentially dangerous to get
> wrong.

agree with you here.

> Assuming the charger also has things like voltage and current control
> exposed.  I think I'd expect to see some sort of charger class which
> abstracts out the functionality of the charger so that the same user
> applications can also be used to set policy for more autonomous
> chargers.  Those chargers may require contortions to fit them into the
> regulator API depending on the control they provide to the system.  More
> simple chargers may well fit cleanly into the regulator API (they're
> regulators after all) but that'd be just one example of this class.
> 
> Quite how much I'd expect such a soft charger to be able to do for
> itself I'm less sure about but I'd be inclined to at least look at doing
> the stuff that can be done with only information from the battery in
> kernel to make things more consistent for user space.

makes sense.

> Yes, exactly - there's a real danger of catastrophic system failure if
> that happens.

sure there is.

I believe we're reaching some conclusions here. I'll think over your
thoughts and try to get more time to read the specs over the weekend (so
much work during the week, sigh). Then let's see what could be done so
we have a good design for a charger api in kernel.

-- 
balbi
