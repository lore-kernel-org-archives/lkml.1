Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYCTXST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYCTXST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYCTXSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:18:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52431 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYCTXSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:18:04 -0400
Date: Fri, 21 Mar 2008 00:18:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: USB-audio strange problems
Message-ID: <20080320231835.GE17431@elf.ucw.cz>
References: <20070203131014.GA4231@elf.ucw.cz> <s5htzy0y2rx.wl%tiwai@suse.de> <20080319211247.GA2659@elf.ucw.cz> <s5h63vhver6.wl%tiwai@suse.de> <20080320111637.GB24304@atrey.karlin.mff.cuni.cz> <s5h3aqlvdxe.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3aqlvdxe.wl%tiwai@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > > Problem was not mixer after all... somehow it expects me to play sound
> > > > as 8-bit, and then I can play 16-bit mono and actually hear
> > > > it. _Strange_.
> > > > 
> > > > So:
> > > > 
> > > > mplayer -ao alsa:device=hw=0 -af format=u8  KDE_Startup.wav
> > > > mplayer -ao alsa:device=hw=0 -af format=s16le -af resample=48000  -af channels=1 KDE_Logout_1.ogg
> > > > 
> > > > ...plays both files. 
> > > > 
> > > > Forget about the first mplayer, and it will play nothing.
> > > 
> > > Dalls DS4201 has a known bug that it doesn't handle U8 format but only
> > > S8 format.  The driver changes the supported format flags from U8 to
> > > S8 when this USB ID is detected.  So you cannot play U8 format
> > > natively.  (Still strange that it is accepted by mplayer.)
> > 
> > But problem is: I have to. Otherwise the second mplayer will produce
> > just silence.
> 
> How about "-ao alsa:device=plughw=0 -af format=u8" ?

mplayer -ao alsa:device=plughw=0 -af format=u8 KDE_Startup.wav

...is silent

mplayer -ao alsa:device=hw=0 -af format=u8 KDE_Startup.wav

...I can hear it. (What's difference between hw and plughw?)

> > Also, even with that treatment, I'm unable to play stereo :-(.
> 
> What shows stream* proc file while playing a 16bit stereo file?

I test by:

mplayer -ao alsa:device=hw=0 -af format=s16le -af resample=48000   KDE_Logout_1.ogg

hobit:/proc/asound# grep . */stream*
U0x4fa0x4201/stream0:USB Device 0x4fa:0x4201 at usb-0000:00:1a.0-1,
full speed : USB Audio
U0x4fa0x4201/stream0:Playback:
U0x4fa0x4201/stream0:  Status: Running
U0x4fa0x4201/stream0:    Interface = 1
U0x4fa0x4201/stream0:    Altset = 5
U0x4fa0x4201/stream0:    URBs = 3 [ 8 8 6 ]
U0x4fa0x4201/stream0:    Packet Size = 196
U0x4fa0x4201/stream0:    Momentary freq = 48000 Hz (0x30.0000)
U0x4fa0x4201/stream0:  Interface 1
U0x4fa0x4201/stream0:    Altset 1
U0x4fa0x4201/stream0:    Format: 0x2
U0x4fa0x4201/stream0:    Channels: 2
U0x4fa0x4201/stream0:    Endpoint: 1 OUT (ASYNC)
U0x4fa0x4201/stream0:    Rates: 44100, 48000
U0x4fa0x4201/stream0:  Interface 1
U0x4fa0x4201/stream0:    Altset 2
U0x4fa0x4201/stream0:    Format: 0x2
U0x4fa0x4201/stream0:    Channels: 1
U0x4fa0x4201/stream0:    Endpoint: 1 OUT (ASYNC)
U0x4fa0x4201/stream0:    Rates: 44100, 48000
U0x4fa0x4201/stream0:  Interface 1
U0x4fa0x4201/stream0:    Altset 3
U0x4fa0x4201/stream0:    Format: 0x0
U0x4fa0x4201/stream0:    Channels: 2
U0x4fa0x4201/stream0:    Endpoint: 1 OUT (ASYNC)
U0x4fa0x4201/stream0:    Rates: 44100, 48000
U0x4fa0x4201/stream0:  Interface 1
U0x4fa0x4201/stream0:    Altset 4
U0x4fa0x4201/stream0:    Format: 0x0
U0x4fa0x4201/stream0:    Channels: 1
U0x4fa0x4201/stream0:    Endpoint: 1 OUT (ASYNC)
U0x4fa0x4201/stream0:    Rates: 44100, 48000
U0x4fa0x4201/stream0:  Interface 1
U0x4fa0x4201/stream0:    Altset 5
U0x4fa0x4201/stream0:    Format: 0x2
U0x4fa0x4201/stream0:    Channels: 2
U0x4fa0x4201/stream0:    Endpoint: 1 OUT (ADAPTIVE)
U0x4fa0x4201/stream0:    Rates: 44100, 48000
card0/stream0:USB Device 0x4fa:0x4201 at usb-0000:00:1a.0-1, full
speed : USB Audio
card0/stream0:Playback:
card0/stream0:  Status: Running
card0/stream0:    Interface = 1
card0/stream0:    Altset = 5
card0/stream0:    URBs = 3 [ 8 8 6 ]
card0/stream0:    Packet Size = 196
card0/stream0:    Momentary freq = 48000 Hz (0x30.0000)
card0/stream0:  Interface 1
card0/stream0:    Altset 1
card0/stream0:    Format: 0x2
card0/stream0:    Channels: 2
card0/stream0:    Endpoint: 1 OUT (ASYNC)
card0/stream0:    Rates: 44100, 48000
card0/stream0:  Interface 1
card0/stream0:    Altset 2
card0/stream0:    Format: 0x2
card0/stream0:    Channels: 1
card0/stream0:    Endpoint: 1 OUT (ASYNC)
card0/stream0:    Rates: 44100, 48000
card0/stream0:  Interface 1
card0/stream0:    Altset 3
card0/stream0:    Format: 0x0
card0/stream0:    Channels: 2
card0/stream0:    Endpoint: 1 OUT (ASYNC)
card0/stream0:    Rates: 44100, 48000
card0/stream0:  Interface 1
card0/stream0:    Altset 4
card0/stream0:    Format: 0x0
card0/stream0:    Channels: 1
card0/stream0:    Endpoint: 1 OUT (ASYNC)
card0/stream0:    Rates: 44100, 48000
card0/stream0:  Interface 1
card0/stream0:    Altset 5
card0/stream0:    Format: 0x2
card0/stream0:    Channels: 2
card0/stream0:    Endpoint: 1 OUT (ADAPTIVE)
card0/stream0:    Rates: 44100, 48000
hobit:/proc/asound# 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
