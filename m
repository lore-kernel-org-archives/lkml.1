Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYKFWyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYKFWyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYKFWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:54:47 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:37471 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKFWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:54:46 -0500
Subject: Re: [alsa-devel] 2.6.26.[6|7] vs. rt11 vs. alsa (usb) midi
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5h63n2mxcc.wl%tiwai@suse.de>
References: <1224989187.3706.7.camel@localhost.localdomain>
	 <s5hljwazc9i.wl%tiwai@suse.de>
	 <1225229755.3750.1.camel@localhost.localdomain>
	 <s5hr65zejxv.wl%tiwai@suse.de>
	 <1225695131.3772.12.camel@localhost.localdomain>
	 <s5h63n2mxcc.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 14:53:27 -0800
Message-Id: <1226012007.3135.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 08:43 +0100, Takashi Iwai wrote:
> At Sun, 02 Nov 2008 22:52:11 -0800,
> Fernando Lopez-Lezcano wrote:
> > 
> > On Wed, 2008-10-29 at 12:10 +0100, Takashi Iwai wrote:
> > > At Tue, 28 Oct 2008 14:35:55 -0700,
> > > Fernando Lopez-Lezcano wrote:
> > > > 
> > > > On Mon, 2008-10-27 at 09:13 +0100, Takashi Iwai wrote:
> > > > > At Sat, 25 Oct 2008 19:46:27 -0700,
> > > > > Fernando Lopez-Lezcano wrote:
> > > > > > 
> > > > > > Hi... anyone out there also having problem with this combination?
> > > > > >    2.6.26.7 or 2.6.26.6 with 2.6.26.6-rt11 and alsa MIDI
> > > > > > It looks to me like alsa midi is broken. 
> > > > > > 
> > > > > > Probably an interaction with the realtime kernel patch. A Fedora kernel
> > > > > > based on 2.6.26.6 (2.6.26.6-49 on fc8) works fine, a very similarly
> > > > > > patched kernel that includes the realtime patch does not. The
> > > > > > configurations for both are almost the same (today I tried to change
> > > > > > some of the most obvious differences and rebuild, with the same
> > > > > > result). 
> > > > > > 
> > > > > > No problems with 2.6.24.7-rt21. 
> > 
> > (but on Fedora 9 I get X segfaults with it... so not really usable
> > either)
> > 
> > > > > > Test: boot, login, plugin an external usb keyboard (Yamaha P250), it is
> > > > > > recognized, use qjackctl alsa patchbay to connect it to kmidimon,
> > > > > > kmidimon sees only _one_ midi message and that's it. Kmidimon can't be
> > > > > > killed after that. 
> > > > > 
> > > > > What about other MIDI devices on other bus, e.g. an MPU401 on a PCI
> > > > > soundcard or so?  There is a possibility of breakage in the USB driver
> > > > > side, too.
> > > > 
> > > > I just tested an RME PCMCIA card + Multiface interface and it shows the
> > > > same problem. No MIDI messages get through (but the LED in the Multiface
> > > > blinks). Same hardware booted into 2.6.24.7-rt21 works fine. 
> > > 
> > > Then this should be in RT side.  There is no fundamental change
> > > regarding rawmidi since some time ago...
> > 
> > Hmm, why do you say rawmidi? This is happening with the sequencer
> > interface, AFAIK. 
> 
> Hmm, it's not impossible, if it's relevant with a timer interface,
> although the sequencer core part has been fundamentally unchanged for
> ages.
> 
> For sequencer issues, you can sort out by using it without rawmidi
> interface.  For example, start aseqdump program in alsa-utils, and
> send to that port via aplaymidi.

The sequencer interface works fine (AFAICT) when not touching external
ports. 

The rawmidi interface seems to work separately. The sequencer interface
(internal) seems to work. The whole thing hangs when connecting an
external port (rawmidi, I guess) to internal stuff. 

Any kernel gurus that could help? Takashi: where in the *.c files should
I start looking? I guess I could try to start sprinkling printk's or
whatever there and see where the heck this is hanging. 

-- Fernando


