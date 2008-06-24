Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYFXKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYFXKar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYFXKah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:30:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYFXKaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:30:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for June 20: [regression] No sound on SB600
Date: Tue, 24 Jun 2008 12:32:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080620172507.b7301bd1.sfr@canb.auug.org.au> <200806240048.35044.rjw@sisk.pl> <s5hvdzztjhz.wl%tiwai@suse.de>
In-Reply-To: <s5hvdzztjhz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241232.08387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 of June 2008, Takashi Iwai wrote:
> At Tue, 24 Jun 2008 00:48:34 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Monday, 23 of June 2008, Takashi Iwai wrote:
> > > At Mon, 23 Jun 2008 17:05:02 +0200,
> > > Rafael J. Wysocki wrote:
> > > > 
> > > > On Monday, 23 of June 2008, Takashi Iwai wrote:
> > > > > At Mon, 23 Jun 2008 16:32:08 +0200,
> > > > > Rafael J. Wysocki wrote:
> > > > > > 
> > > > > > On Monday, 23 of June 2008, Takashi Iwai wrote:
> > > > > > > At Sat, 21 Jun 2008 21:25:41 +0200,
> > > > > > > Rafael J. Wysocki wrote:
> > > > > > > > 
> > > > > > > > On Saturday, 21 of June 2008, Takashi Iwai wrote:
> > > > > > > > > At Sat, 21 Jun 2008 17:28:09 +0200,
> > > > > > > > > Rafael J. Wysocki wrote:
> > > > > > > > > > 
> > > > > > > > > > On Friday, 20 of June 2008, Stephen Rothwell wrote:
> > > > > > > > > > > Hi all,
> > > > > > > > > > > 
> > > > > > > > > > > Changes since next-20080619:
> > > > > > > > > > > 
> > > > > > > > > > > The net tree lost its conflict against Linus' tree.
> > > > > > > > > > > 
> > > > > > > > > > > The bkl-removal tree lost a conflict.
> > > > > > > > > > 
> > > > > > > > > > On one of my test boxes with the ATI chipset (SB600 south bridge) there's no
> > > > > > > > > > sound output.  Bisection shows that the following commit causes this to happen
> > > > > > > > > > and reverting the commit fixes the problem for me:
> > > > > > > > > > 
> > > > > > > > > > commit cf97e6678f1e1e7bbdb566c36771540123832a31
> > > > > > > > > > Author: Takashi Iwai <tiwai@suse.de>
> > > > > > > > > > Date:   Mon Jun 16 15:47:26 2008 +0200
> > > > > > > > > > 
> > > > > > > > > >     ALSA: hda - Fix wrong volumes in AD1988 auto-probe mode
> > > > > > > > > >     
> > > > > > > > > >     Don't create mixer volume elements for Headphone and Speaker if they
> > > > > > > > > >     use the same DAC as normal line-outs on AD1988.  Otherwise the amp
> > > > > > > > > >     value gets screwed up, e.g.
> > > > > > > > > >     	https://bugzilla.novell.com/show_bug.cgi?id=398255
> > > > > > > > > >     
> > > > > > > > > >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > > > > > > 
> > > > > > > > > > Please let me know if you need any additional information.
> > > > > > > > > 
> > > > > > > > > Could you run alsa-info.sh with --no-upload option and attach the
> > > > > > > > > output for both states with and without that commit?  The script is
> > > > > > > > > found at
> > > > > > > > > 	http://www.alsa-project.org/alsa-info.sh
> > > > > > > > > Also, show the relevant kernel message from snd-hda-intel (informing
> > > > > > > > > the auto-parsing of pins, etc), too.
> > > > > > > > 
> > > > > > > > dmesg outputs and the outputs of 'alsa-info.sh --no-upload' for the kernel with
> > > > > > > > the patch applied (1) and with the reverted (2) are at:
> > > > > > > > 
> > > > > > > > http://www.sisk.pl/kernel/debug/20080620/box2/dmesg-1.log
> > > > > > > > http://www.sisk.pl/kernel/debug/20080620/box2/alsa-info-1.txt
> > > > > > > > 
> > > > > > > > http://www.sisk.pl/kernel/debug/20080620/box2/dmesg-2.log
> > > > > > > > http://www.sisk.pl/kernel/debug/20080620/box2/alsa-info-2.txt
> > > > > > > 
> > > > > > > Well, this is actually no regression but an unlucky side-effect of the
> > > > > > > fix.
> > > > > > > 
> > > > > > > In the old version, "Front" volume didn't work properly because of
> > > > > > > confliction with a bogus "Headphone" volume.  Now, a wrong volume
> > > > > > > element is removed but only "Front" remains while "Front" wasn't set
> > > > > > > up properly.
> > > > > > > 
> > > > > > > In short, the below should fix the problem:
> > > > > > > 
> > > > > > > 	% amixer set Front 90%
> > > > > > 
> > > > > > Well, okay, but where should I add that to make KDE mixers work, for example?
> > 
> > Ah, there is a "Front" volume control that works instead of the "Headphone" one.
> 
> It's been there but it didn't work because of conflict with a bogus
> "Headphone" volume.
> 
> > > > > 
> > > > > You must have "Master" volume control now.  This also changes Front,
> > > > > etc.  Try to reassign Master as the default volume in kmix.
> > >>
> > > > Yes, I have the "Master" control and I had it before the patch too, but it has
> > > > no effect both after and before the patch AFAICS (will double check).
> > > 
> > > Oh, yes, let me know if "Master" still doesn't work.
> > 
> > No, it doesn't.
> 
> Hmm...
> 
> > > This should have been fixed with the last patch, too.
> > 
> > Oh well ... ;-)
> 
> Just to be sure, did you adjust Front volume properly before testing
> Master volume?  Master volume is only attenuation and no gain.  Thus,
> if Front is low, you won't get any high volumes even if you raise
> Master to full.

Ah, I see.  OK, it works this way.  Sorry for the confusion.

> To be noted, you have also other mixer elements like Surround, Center,
> etc.  Together with Front, these correspond to the volumes of 7.1
> output channels individually.  Your hardware has no individual
> headphone volume but it's connected from the front channels.  That's
> why "Front" controls the headphone volume, too.

Thanks for the explanation.

Rafael
