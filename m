Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbXGGW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbXGGW1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 18:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXGGW1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 18:27:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4570 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbXGGW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 18:27:37 -0400
Date: Fri, 29 Jun 2007 18:31:04 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Hannu Savolainen <hannu@opensound.com>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org,
       Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: OSS vs ALSA API (was Re: Is it time for remove (crap) ALSA from kernel tree ?)
Message-ID: <20070629183103.GA3861@ucw.cz>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <4680310D.6060206@opensound.com> <4680FCF8.4090403@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4680FCF8.4090403@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Today both OSS and ALSA teams have to spend significant 
> >amounts of time in emulating the "alien" APIs. Making 
> >OSS and ALSA to co-exist will require some work in both 
> >sides but that should be nothing when compared to the 
> >effort required for emulation.
> 
...
> In Linux we typically do not do two APIs and codebases 
> for the same purpose.  If we do, like sys_mmap and 
> sys_mmap2, it's an older legacy interface that never 
> changes, that we are moving people AWAY from, and a 
> newer interface.
> 
> I see no reason to change from the path at which 
> upstream has arrived: OSS is a legacy API that's frozen 
> in time, and ALSA provides the new stuff.

While I agree that ALSA is better than OSS... I don't actually think
ALSA kernel<>user api is... at least for my purposes. I'm still using
OSS emulation, because I could not get alsa proper to work... and the
advanced stuff just does not work in emulation.

In OSS days, if you wanted to test kernel sound driver, you did:

mknod /dev/dsp
cat /bin/bash > /dev/dsp.

With alsa+oss emulation, you need

mknod /dev/mixer
install aumix
aumix
mknod /dev/dsp
cat /bin/bash > /dev/dsp.

With alsa proper, it is

install alsalib
create about 5 device nodes
install alsautils
maybe do some config?
aplay some.wav

..provided you have .wav near you. I'm not sure if it is possible to
produce sounds using normal shell scripting? (w/o alsautils)?

I can even test kernel graphics drivers by cat /bin/bash > /dev/fb0...
it would be nice to have equivalent for audio... OSS API seems to be
the equivalent these days, but please don't deprecate it.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
