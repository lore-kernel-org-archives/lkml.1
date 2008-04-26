Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbYDZBLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbYDZBLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 21:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYDZBLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 21:11:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44328 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYDZBLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 21:11:39 -0400
Subject: Re: [PATCH] make alsa use corect patch for Realtek ALC889A
From: Kasper Sandberg <lkml@metanurb.dk>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <s5htzhqje2k.wl%tiwai@suse.de>
References: <1208017043.1514.50.camel@localhost>
	 <s5hbq4af4h3.wl%tiwai@suse.de> <s5htzi1eur8.wl%tiwai@suse.de>
	 <1208483526.14146.29.camel@localhost> <s5h3apjfox5.wl%tiwai@suse.de>
	 <1208897629.7522.6.camel@localhost> <s5hfxtddk6a.wl%tiwai@suse.de>
	 <1208986542.7743.19.camel@localhost>  <s5htzhqje2k.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 03:11:04 +0200
Message-Id: <1209172264.7743.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 14:48 +0200, Takashi Iwai wrote:
> At Wed, 23 Apr 2008 23:35:42 +0200,
> Kasper Sandberg wrote:
> > 
> > On Wed, 2008-04-23 at 10:55 +0200, Takashi Iwai wrote:
> > > At Tue, 22 Apr 2008 22:53:49 +0200,
> > > Kasper Sandberg wrote:
> > > > 
> > > > On Fri, 2008-04-18 at 12:16 +0200, Takashi Iwai wrote:
> > > > > At Fri, 18 Apr 2008 03:52:06 +0200,
> > > > > Kasper Sandberg wrote:
> > > > > > 
> > > > > > On Wed, 2008-04-16 at 16:31 +0200, Takashi Iwai wrote:
> > > > > > > At Wed, 16 Apr 2008 13:01:44 +0200,
> > > > > > > I wrote:
> > > > > > > > 
> > > > > > > > At Sat, 12 Apr 2008 18:17:23 +0200,
> > > > > > > > Kasper Sandberg wrote:
> > > > > > > > > 
> > > > > > > > > Hello..
> > > > > > > > > I have a gigabyte X48-DQ6 motherboard, specification url:
> > > > > > > > > http://www.gigabyte.com.tw/Products/Motherboard/Products_Spec.aspx?ClassValue=Motherboard&ProductID=2763&ProductName=GA-X48-DQ6
> > > > > > > > > they clearly state it uses a realtek alc 889a.
> > > > > > > > > 
> > > > > > > > > google around, it seems lots of people which has this chip gets it
> > > > > > > > > detected as alc885, including me.
> > > > > > > > > 
> > > > > > > > > now, audio works (atleast analog out, havent tested the rest), allthough
> > > > > > > > > i couldnt get the supposed feature of separate channel to front panel to
> > > > > > > > > work(doesent matter much to me though)
> > > > > > > > > 
> > > > > > > > > interrested in fixing this just for the sake of fixing, i ventured into
> > > > > > > > > patch_realtek.c, and found the structure that defined patches for hda
> > > > > > > > > audio.
> > > > > > > > > 
> > > > > > > > > i inspected my /proc/asound/card0/codec#2 file (only one except the id
> > > > > > > > > file), and found the following information:
> > > > > > > > > Codec: Realtek ALC885
> > > > > > > > > Address: 2
> > > > > > > > > Vendor Id: 0x10ec0885
> > > > > > > > > Subsystem Id: 0x1458a002
> > > > > > > > > Revision Id: 0x100103
> > > > > > > > > 
> > > > > > > > > i then modified patch_realtek.c to detect mine as ALC889A, and assign
> > > > > > > > > the correct patch to it (well, the one used for 889).
> > > > > > > > > 
> > > > > > > > > After rebuilding, it now uses patch 883 instead of 882 as it did before.
> > > > > > > > > i dont appear to have recieved any separate front panel channel,
> > > > > > > > > however, it still seems more correct now, and is probably wise to keep
> > > > > > > > > for when 883 is improved to support the hardware fully.
> > > > > > > > > 
> > > > > > > > > the only thing i notice has changed, is the message i get from the
> > > > > > > > > kernel, before i changed, it said:
> > > > > > > > > hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
> > > > > > > > > now it says:
> > > > > > > > > hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> > > > > > > > > but i guess if it has to spew out such a line, it now spews out the
> > > > > > > > > correct one.
> > > > > > > > > 
> > > > > > > > > analog audio works, so thats fine..
> > > > > > > > > 
> > > > > > > > > the patch(i apologize if my mailer messes up whitespace, but its so
> > > > > > > > > simple that it doesent matter):
> > > > > > > > 
> > > > > > > > The change looks OK (although I'd move the line just before ALC885
> > > > > > I wasnt sure how it was evaluated, i dont really know alsa alot, so i
> > > > > > wanted to make sure my entry got evaluated first.
> > > > > > > > entry).  I have no datasheet of ALC889A, but rumor says that it's
> > > > > > > > almost compatible with ALC888.  So patch_alc883 seems to be a better
> > > > > > > > choice than now.
> > > > > > > > 
> > > > > > > > I'll fix it on ALSA tree now.
> > > > > > > 
> > > > > > > On the second thought, replacing to patch_alc883 may break many
> > > > > > > devices with preset models because patch_alc882() and patch_alc883()
> > > > > > > have different model tables.  So, I applied the patch below in
> > > > > > > addition.
> > > > > > > 
> > > > > > > BTW, could you show your codec#* files?  This will be really helpful
> > > > > > > to identify problems.
> > > > > > 
> > > > > > Yes, sorry for delay, for some reason my mail client decided not to
> > > > > > update the view.. weird..
> > > > > > 
> > > > > > You should know that this is WITH my modification..
> > > > > > 
> > > > > > About problems.. well.. now that you do mention it, when i play
> > > > > > something without a .asoundrc, i get:
> > > > > > ALSA lib dlmisc.c:118:(snd_dlsym_verify) unable to verify version for
> > > > > > symbol _snd_pcm_empty_open
> > > > > > ALSA lib pcm.c:2108:(snd_pcm_open_conf) symbol _snd_pcm_empty_open is
> > > > > > not defined inside [builtin]
> > > > > > No default libao driver available.
> > > > > 
> > > > > It's a bug of alsa-lib that was already fixed in the recent version.
> > > > > Nothing to do with kernel.
> > > > > 
> > > > > > Now as far as i know, the gigabyte site(and realteks site) says that
> > > > > > this ALC889A should have 7.1 surround, with 2 separate channels of
> > > > > > streaming for front. I connected the hd audio connector for front panel
> > > > > > on motherboard.. but well.. the same thing comes out, and i see no
> > > > > > special channels for it.. BUT, one thing i find odd is, if i play 2
> > > > > > channel stuff, it also comes out of all the other channels, eg the
> > > > > > surround channels.. :)
> > > > > 
> > > > > You can open 4, 6 or 8 channels with the device.  But, the default PCM
> > > > > is set up only for two channels due to soft-mixing.  You can use
> > > > > special PCM names such as "surround51" to open for 5.1 output
> > > > > instead.  Again, no kernel issue.
> > > > 
> > > > if i open hw:0,0, and play only 2 channels, it comes out of all 8
> > > > channels.. but thats fine.. what i meant that does NOT work, is that
> > > > according to gigabyte, i actually should have 10 channels, 7.1 for the
> > > > back panel connectors, and two entirely separate for the front panel,
> > > > but the front panel just plays same as back panel stereo (green)
> > > > connector.
> > > 
> > > Then some output route is missing either in the BIOS setting or in the
> > > driver setup.
> > > 
> > Do you think it could be that i am able to open 10 channels on hw:0,0?
> > is there some way i can see? this is what gigabyte's site says:
> > 7.1+2 Channel High Definition Output
> > The ALC889A provides support for 7.1 sound playback, plus 2 channels of
> > independent stereo output (multiple streaming) through the front panel
> > stereo outputs.
> 
> The independent extra PCM stream isn't implemented yet.  You can have
> a 7.1-output to be duped to another jack, but not two individual
> streams.

Yeah okay, then it makes perfect sense what is happening. Thanks for the
information.

> 
> This is another item on my TODO list.
> 
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

