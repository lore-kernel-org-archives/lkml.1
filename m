Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZKFTAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZKFTAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbZKFTAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:00:16 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53876 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZKFTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:00:14 -0500
Date: Fri, 6 Nov 2009 13:59:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project
	tree
Message-ID: <20091106185950.GD2782@tuxdriver.com>
References: <200911031951.05235.bzolnier@gmail.com> <20091106074643.GA5562@ucw.cz> <200911061858.56816.IvDoorn@gmail.com> <200911061930.13069.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911061930.13069.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 07:30:13PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Friday 06 November 2009 18:58:56 Ivo van Doorn wrote:

> > the merged for those drivers after the asurance that it was only merged
> > to please the users so developers could focus on the rt2x00 version of
> > the driver.
> 
> Could somebody please explain me (in the public or in the private) what is
> the reason behind whole affair about staging drivers because all the time
> I feel like I'm missing some important detail here.

I'm not 100% sure what you are asking, but I think you want to know
the basis for general objections from the people that hang-out on
linux-wireless and/or the rt2x00 team specifically?

I don't think anyone[1] has overwhelming objections to drivers in
staging for devices that have no other driver available.  The main
objection is that drivers/staging steals users and (and often
developers) from the non-staging drivers, reducing the amount of
testing and development they get.  In the effort to help some users,
drivers/staging effectively prolongs the amount of time those users
have to go without properly supported drivers.  Much worse, none of
the wireless drivers in drivers/staging seem to have generated an
actual mergeable[2] wireless driver.

Further, the wireless drivers in drivers/staging are completely
isolated from the wireless infrastructure developments we've been
making over the past few years.  The longer they live, the longer
wireless extensions will linger, the longer custom rfkill solutions
persist, and the longer we have multiple 802.11 stack implementations.

Finally, bug reports from drivers/staging are an unwelcome distraction
in bugzilla and the wireless mailing lists.  Not only do those drivers
generate (often wierd) bugs, we get the privilege of looking like
jerks for refusing to deal with those reports even though we objected
to including the drivers in the first place.

It is little wonder to me why the linux-wireless folks oppose
drivers/staging...

Hth!

John

[1] Actually, I _know_ there are people who object to all of
drivers/staging, but few of those are actively and vigorously objecting
to it.

[2] A mergeable driver should respect and/or utilize existing wireless
infrastructure rather than duplicating it, as well as meeting general
standards of maintainability.  Preferably it would have someone to
stand behind it as a maintainer as well.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
