Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZIGLfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZIGLfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZIGLfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:35:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZIGLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:35:17 -0400
Date: Mon, 7 Sep 2009 13:31:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: Re: Zaurus suspend saga
Message-ID: <20090907113132.GM23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252276145.17852.15.camel@dax.rpnet.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > fatal reads invalid values -- -108 -- probably because spi is not ready?
> > 
> > is spi suspend/resume required? yes.; and yes spi is resumed too late
> >  in the sequence. Or perhaps fatal battery check is way too early.
> > 
> > Could someone confirm that simply removing sharpsl_fatal_check() fixes
> > zaurus suspend on 2.6.31? 
> 
> Sadly lack of time means I've lost track of the Zaurus kernels but this
> sounds like all accesses to the SSP buses now go through the SPI layer
> and when it was converted nobody thought about the impact this would
> have on the Zaurus charger code.

Unfortunately... Do you have any idea when this conversion took place?

> If suspend/resume is broken in this way, it also means the charger code
> is also likely to be totally broken/malfunctioning since it won't be
> able to read from the ADC either.

Yes. Seems like low-level zaurus code is FUBAR.

> Either:
> 
> a) Someone steps up and finds a way to partially resume the kernel so
> the "offline" charging code can work and access SPI

> b) We find some other way to allow the SPI interface to be accessed by
> the charger code without resuming the whole kernel (the way it used to
> work)

Doing that in a hacky way should be rather easy... just calling spi
resume manually. But...

> c) We rip the whole thing out and stop supporting "offline" charging.

How much faster is offline charge, compared to online charging? I have
impression that online charging basically does not charge anything...

> I'd hate to see c) happen but I doubt I'm going to find time to rewrite
> that code any time soon and nobody else even seems to have grasped how
> deep this problem really is :(.

Well, I have a bit of time now and then...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
