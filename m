Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXLNLQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXLNLQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXLNLQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:16:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbXLNLQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:16:34 -0500
Date: Fri, 14 Dec 2007 12:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214111534.GD23964@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712140143.16451.mb@bu3sch.de> <2c0942db0712131712t6f30ab88g48cc1af27a7a6ce9@mail.gmail.com> <200712141149.46945.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712141149.46945.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> On Friday 14 December 2007 02:12:25 Ray Lee wrote:
> > Digging a little farther into it, it looks like b43 is barfing partway
> > through init as the firmware file it's looking for has changed names.
> > Perhaps that's the issue. I'll take a longer look at this all
> > tomorrow.
> 
> http://www.linuxwireless.org/en/users/Drivers/b43#firmwareinstallation
> 
> > Well, it only hit the main kernel October 10th. That means no final
> > point release of the kernel.org kernel has even had it included! So
> > testing-wise, you still haven't hit the hordes yet. Scheduling a
> > removal of bcm43xx (as painful as that code is [*]), seems either
> > premature or very optimistic. So, how about scheduling the removal
> > once you get a feel for the bug reports that'll come in once 2.6.24 is
> > released.
> 
> So you volunteer to maintain bcm43xx? Fine. Thanks a lot.

it's sad that you are trying to force testers to upgrade to your new 
driver by threatening to unsupport the old driver. The testers who did 
nothing but reported that the new driver did not work on their hardware.

You can write new drivers but you must not break existing users. That's 
true for every single piece of the kernel. It is _your_ responsibility 
to get that rule right - and if it does not work out of box (no matter 
whom to blame, udev or the driver) you dont get to remove the driver 
from the upstream kernel.

Yes, you can then "unsupport it" in spite and be a prick about it in 
general but that will only talk of your own personal qualities and will 
sharply reduce your credibility as a maintainer (and eventually hinder 
your ability to introduce new code) - users will still have the code 
available and will have a chance to fix the driver that happens to work. 
(and perhaps another, capable, but friendler maintainer arises.) And 
that old code will be a clot to drag around, hindering your 'new' 
wireless code all along.

I really dont know why it's so hard to understand: new is totally 
useless if it does not work for old setups 100% of the time. And people 
_WANT_ to use your new code, so it's not like you have to pull their 
hairs to get your stuff tested. And YOU wrote the old code in large 
part:

 $ git-authors drivers/net/wireless/bcm43xx/ | tail -10
      2  Sam Ravnborg
      3  David Howells
      3  David Woodhouse
      3  Joe Perches
      4  Jeff Garzik
      5  Daniel Drake
      6  Stefano Brivio
      9  John W. Linville
     48  Larry Finger
     80  Michael Buesch

so it's not like "someone else messed it up" and that you would be 
incapable of getting it all work nicely and make the migration of users 
smoother. And if udev is a hindrance to you, reduce your driver's 
dependence on udev breakages.

	Ingo
