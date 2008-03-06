Return-Path: <linux-kernel-owner+w=401wt.eu-S1765677AbYCFVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765677AbYCFVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYCFVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:23:34 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:27128 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752691AbYCFVXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:23:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RrVWizB3SRbPrmqDYFoZ+WACaJueFKtvWjBMulLadY+7LOwPgL9fr2JiqAMec7gkXGc1HoU7dEhPYim2aPdwPZtcx0sBOwOHwa57EvIPnP0X2d4OzeY0r9X6X/HKQVShCkQAPEUgSTL4AuAybfAr5kLhunFju5+bgqi9h/JMALI=  ;
X-YMail-OSG: uWi7EgQVM1n6995ucbzOY7AtbWAY90Zvd3UsX1p8H2kcRuNb6r2Bgzx7xlz156Ymm7qmr7sbvQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Thu, 6 Mar 2008 13:23:29 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <200802241500.41969.rjw@sisk.pl> <200803040144.09601.david-b@pacbell.net> <20080304105841.6c951665@mjolnir.drzeus.cx>
In-Reply-To: <20080304105841.6c951665@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061323.30314.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Card insert/remove events can be system wake events though.  Which
> > > > makes that restriction impractical.
> > 
> > This part seems to be ignored by your comment ... wake events.
> 
> How so? How is a wake caused by the MMC controller different
> than any other source? 

They aren't.  Which is part of why the way MMC currently assumes that
insert/remove events don't work is a problem.


> > That is, the MMC core doesn't understand wakeup events.
> > 
> > Or, as pointed out elsewhere, well-behaved MMC hosts ... which don't
> > need either such reprobing or the associated remove-on-suspend.
> 
> You need well behaved _systems_, not just hosts to achieve that
> guarantee.

Sure, but a host can't be well behaved all by itself!

And in any case, I had already made clear I was talking
about _systems_ that behave properly.


> SDHCI controllers have the ability to wake up the 
> system on card removal, but there is zero guarantee that the
> platform actually wired the controller up in a way that actually
> allows it to do this. Throw suspend to disk, where the system might
> completely lose power, into the mix and you're completely screwed.     

I'm talking about generic MMC/SD controllers of the type
that have been around for years ... on systems which won't
use hibernation ("suspend to disk"), but do use real system
sleep states where card detection (by IRQs) works.

 
> So for the default behaviour to change, we need one of two things:
> 
> - Certainty that removals cannot go unnoticed. (even then, you
>   also need wakeup latency guarantees) 
> - Ability to detect a removal after the fact.
>
> For the general case, the first one is impossible given todays
> hardware.

Odd that it's very possible on the systems I mentioned.


> The second might be solvable, but noone has done the work.  

I don't know what you mean by "detect a removal after
the fact", or why it'd be needed if you detected it
in the first place.

 
> (If your complete system can satisfy the first option, feel
> free to add the "unsafe" option to you defconfig, but that is
> hardly adequate reason to have it on by default.)  

Thing is, I had also pointed out that it wasn't "unsafe"
in the least on many systems.

I'll refresh the patch which improves that mechanism and
updates its description.

- Dave
