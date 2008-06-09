Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYFIUoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYFIUoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYFIUoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:44:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYFIUoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:44:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
Date: Mon, 9 Jun 2008 22:45:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200806082303.59245.rjw@sisk.pl> <s5h7iczc6ex.wl%tiwai@suse.de> <200806091656.31251.rjw@sisk.pl>
In-Reply-To: <200806091656.31251.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092245.01595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 9 of June 2008, Rafael J. Wysocki wrote:
> On Monday, 9 of June 2008, Takashi Iwai wrote:
> > At Sun, 8 Jun 2008 23:03:58 +0200,
> > Rafael J. Wysocki wrote:
> > > 
> > > Hi,
> > > 
> > > snd-emu10k1 doesn't work on one of my test boxes.  The driver apparently loads,
> > > but the card is not visible, for example, to any mixer apps (including the ALSA
> > > mixer).  However, YaST correctly detects and reports the card (the system is
> > > openSUSE 10.3, x86-64).  The openSUSE-made kernel (2.6.22-something) does
> > > correctly work on the same hardware.
> > > 
> > > Is there anything I should pay attention to, like any options related to /proc
> > > or sysfs that could have an effect on the audio adapter?
> > 
> > First off, check /proc/asound/cards whether snd-emu10k1 driver is
> > really loaded on the first slot.  I guess something else occupies the
> > position.
> 
> This is quite possible, as there is an on-board audio in this box too and I'm
> not sure if the setup switch really turns it off.
> 
> > If yes, a simple solution is to add the following option for snd module:
> > 
> > 	options snd slots=snd-emu10k1
> > 
> > then the first slot is reserved for emu10k1.  Note that this option is
> > available for 2.6.25 or later kernel.
> 
> I'll try later today and let you know.

No, it didn't work.

Here's what I got from /proc/asound/cards:

 0 [Audigy         ]: Audigy - Audigy 1 [SB0090]
                      Audigy 1 [SB0090] (rev.3, serial:0x531102) at 0xa000, irq 17
 1 [UART           ]: MPU-401 UART - MPU-401 UART
                      MPU-401 UART at 0x330, irq 10

so I think this is correct, and the "options snd slots=snd-emu10k1" thing had
no visible effect.

Thanks,
Rafael
