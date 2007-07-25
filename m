Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbXGYTIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbXGYTIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbXGYTIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:08:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3957 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753884AbXGYTI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:08:29 -0400
Date: Wed, 25 Jul 2007 19:01:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SD Root filesystem suspend/resume problems
Message-ID: <20070725190115.GB10208@ucw.cz>
References: <1184860419.29634.10.camel@localhost.localdomain> <20070719190309.28708be8@poseidon.drzeus.cx> <1185110313.6819.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185110313.6819.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Lots of Linux handhelds use MMC/SD devices as the root file system.
> > > This has worked quite reliably for many kernel versions. In 2.6.22,
> > > it seems that if you suspend such a system then resume it, the device
> > > locks up. Trying to execute anything on the filesystem results in a
> > > "Permission Denied" message. I did see a message from the MMC
> > > subsystem saying it had redetected the card. There are also messages
> > > on the console like "MMC: killing requests for dead queue" each time
> > > you suspend/resume.
> > 
> > The card is removed when you suspend and readded when you resume.
> > That's the only safe thing we can do until we get suspend support in
> > the filesystems.
> > 
> > If you really want to shoot yourself in the foot, there is a Kconfig
> > option that keeps the card around across the suspend.
> 
> I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing was
> "fixed". I think having this option is a bad idea (in its current form)
> as it doesn't actually stop filesystem corruption.
> 
> With the option disabled, if a filesystem is mounted when you suspend my
> tests show the filesystem is corrupted. At least if the option is
> enabled, the filesystem is only corrupted if you remove the card whilst
> suspended which is more preferable.

Are we talking _corruption_ here, or are we talking 'the kind of
corruption recoverable by fsck that happens on powerfail'?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
