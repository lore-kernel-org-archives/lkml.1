Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYCTLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYCTLQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYCTLQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:16:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYCTLQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:16:38 -0400
Date: Thu, 20 Mar 2008 12:16:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: USB-audio strange problems
Message-ID: <20080320111637.GB24304@atrey.karlin.mff.cuni.cz>
References: <20070203131014.GA4231@elf.ucw.cz> <s5htzy0y2rx.wl%tiwai@suse.de> <20080319211247.GA2659@elf.ucw.cz> <s5h63vhver6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h63vhver6.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At Wed, 19 Mar 2008 22:12:47 +0100,
> Pavel Machek wrote:
> > 
> > Hi!
> > 
> > Ok, so it took me a year to get back to this bug. Oops.
> 
> Oh well, I don't remember what was the exactly problem...

Yes, sorry about that.

> > > Yep, let's fix it.  Just to make sure (ane debugging easy atm), could
> > > you attach the following?
> > > 
> > > - content of /proc/asound/cards
> > > - content of /proc/asound/card*/stream*
> > > - the output of "lsusb -v"
> > > - the generated file via "alsactl -f store somefile"
> > > 
> > > If I remember correctly, alsamixer at least doesn't break if you build
> > > snd-usb-audio driver with IGNORE_CTL_ERR enabled, right?
> > 
> > I got the usb soundcard to work. I still have IGNORE_CTL_ERR enabled.
> > 
> > Problem was not mixer after all... somehow it expects me to play sound
> > as 8-bit, and then I can play 16-bit mono and actually hear
> > it. _Strange_.
> > 
> > So:
> > 
> > mplayer -ao alsa:device=hw=0 -af format=u8  KDE_Startup.wav
> > mplayer -ao alsa:device=hw=0 -af format=s16le -af resample=48000  -af channels=1 KDE_Logout_1.ogg
> > 
> > ...plays both files. 
> > 
> > Forget about the first mplayer, and it will play nothing.
> 
> Dalls DS4201 has a known bug that it doesn't handle U8 format but only
> S8 format.  The driver changes the supported format flags from U8 to
> S8 when this USB ID is detected.  So you cannot play U8 format
> natively.  (Still strange that it is accepted by mplayer.)

But problem is: I have to. Otherwise the second mplayer will produce
just silence.

Also, even with that treatment, I'm unable to play stereo :-(.

How to debug this?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
