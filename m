Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYF3J5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYF3J5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYF3J51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:57:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYF3J51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:57:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
Date: Mon, 30 Jun 2008 11:58:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200806082303.59245.rjw@sisk.pl> <200806301144.40057.rjw@sisk.pl> <s5h4p7bgsns.wl%tiwai@suse.de>
In-Reply-To: <s5h4p7bgsns.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301158.47783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 of June 2008, Takashi Iwai wrote:
> At Mon, 30 Jun 2008 11:44:39 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Monday, 30 of June 2008, Takashi Iwai wrote:
> > > At Sun, 29 Jun 2008 19:46:49 +0200,
> > > Rafael J. Wysocki wrote:
> > > > 
> > > > On Tuesday, 10 of June 2008, Takashi Iwai wrote:
> > > > > At Mon, 9 Jun 2008 22:45:01 +0200,
> > > > > Rafael J. Wysocki wrote:
> > > > > > 
> > > > > > On Monday, 9 of June 2008, Rafael J. Wysocki wrote:
> > > > > > > On Monday, 9 of June 2008, Takashi Iwai wrote:
> > > > > > > > At Sun, 8 Jun 2008 23:03:58 +0200,
> > > > > > > > Rafael J. Wysocki wrote:
> > > > > > > > > 
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > snd-emu10k1 doesn't work on one of my test boxes.  The driver apparently loads,
> > > > > > > > > but the card is not visible, for example, to any mixer apps (including the ALSA
> > > > > > > > > mixer).  However, YaST correctly detects and reports the card (the system is
> > > > > > > > > openSUSE 10.3, x86-64).  The openSUSE-made kernel (2.6.22-something) does
> > > > > > > > > correctly work on the same hardware.
> > > > > > > > > 
> > > > > > > > > Is there anything I should pay attention to, like any options related to /proc
> > > > > > > > > or sysfs that could have an effect on the audio adapter?
> > > > > > > > 
> > > > > > > > First off, check /proc/asound/cards whether snd-emu10k1 driver is
> > > > > > > > really loaded on the first slot.  I guess something else occupies the
> > > > > > > > position.
> > > > > > > 
> > > > > > > This is quite possible, as there is an on-board audio in this box too and I'm
> > > > > > > not sure if the setup switch really turns it off.
> > > > > > > 
> > > > > > > > If yes, a simple solution is to add the following option for snd module:
> > > > > > > > 
> > > > > > > > 	options snd slots=snd-emu10k1
> > > > > > > > 
> > > > > > > > then the first slot is reserved for emu10k1.  Note that this option is
> > > > > > > > available for 2.6.25 or later kernel.
> > > > > > > 
> > > > > > > I'll try later today and let you know.
> > > > > > 
> > > > > > No, it didn't work.
> > > > > > 
> > > > > > Here's what I got from /proc/asound/cards:
> > > > > > 
> > > > > >  0 [Audigy         ]: Audigy - Audigy 1 [SB0090]
> > > > > >                       Audigy 1 [SB0090] (rev.3, serial:0x531102) at 0xa000, irq 17
> > > > > >  1 [UART           ]: MPU-401 UART - MPU-401 UART
> > > > > >                       MPU-401 UART at 0x330, irq 10
> > > > > > 
> > > > > > so I think this is correct, and the "options snd slots=snd-emu10k1" thing had
> > > > > > no visible effect.
> > > > > 
> > > > > Then this must be OK.  Then the remaining possible problems are:
> > > > > 
> > > > > - Device files and permissions.
> > > > >   Check whether /dev/snd/* files exist and have proper permissions and
> > > > >   ACL (see "getfacl /dev/snd/*")
> > > > > 
> > > > > - The default ALSA configuration is hijacked, e.g. via pulse plugin.
> > > > >   Try to remove /etc/asound-pulse.conf if present.
> > > > 
> > > > I've just installed openSUSE 11.0 on this box and the distro kernel
> > > > 2.6.25.5-something works, but 2.6.26-rc8 doesn't.  The symptoms are exactly
> > > > the same as described in this thread and the kernel is the only system
> > > > component replaced.
> > > > 
> > > > So this is a regression from 2.6.25, actually.  Do you want me to bisect?
> > > 
> > > Hmm... there is really no visible problematic changes for emu10k1
> > > between 2.6.25 and 2.6.26.  I guess checking /proc/asound/cards and/or
> > > kernel config would save the time of bisect.  At least, check the
> > > following:
> > > 
> > > 1. you have emu10k1 in the first entry (#0) of /proc/asound/cards
> > 
> > Yes.  The contents of /proc/asound/cards are exactly as shown above.
> > 
> > > 2. the mixer states are OK (e.g. "Audigy Analog/Digital Output
> > > Jack" switch is off, "Master" and "PCM" are muted/adjusted, etc)
> > 
> > I can only run alsamixer as root and then it works correctly.  As a normal
> > user it doesn't start due to insufficient access rights.
> > 
> > While kmix can be started as a normal user, it only shows empty window.
> > 
> > > 3. run "aplay -Dhw:0 /usr/share/sounds/alsa/test.wav" for testing
> > 
> > As root it works just fine.  As a normal user I get:
> > 
> > ALSA lib pcm_hw.c:1240:(_snd_pcm_hw_open) Invalid value for card
> > aplay: main:583: audio open error: Permission denied
> 
> Weird.  Could you try to remove ~/.asoundrc and /etc/asound*.conf if
> they exist?

I only had /etc/asound-pulse.conf .  Removed that, but it didn't change
anything.

Thanks,
Rafael
