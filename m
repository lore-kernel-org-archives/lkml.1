Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXIRVZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXIRVZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbXIRVZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:25:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXIRVY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:24:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Tue, 18 Sep 2007 23:37:12 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709182221.53513.rjw@sisk.pl> <200709182254.55409.rjw@sisk.pl>
In-Reply-To: <200709182254.55409.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182337.12695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 September 2007 22:54, Rafael J. Wysocki wrote:
> On Tuesday, 18 September 2007 22:21, Rafael J. Wysocki wrote:
> > On Tuesday, 18 September 2007 10:18, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > > 
> > > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> > > 
> > > It took me over two solid days to get this lot compiling and booting on a few
> > > boxes.  This required around ninety fixup patches and patch droppings.  There
> > > are several bugs in here which I know of (details below) and presumably many
> > > more which I don't know of.  I have to say that this just isn't working any
> > > more.
> > > 
> > > - The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
> > >   I didn't drop that patch because the iommu patch series depends on it.
> > > 
> > > - The Vaio also hangs during resume-from-RAM, due to git-acpi.patch
> > > 
> > > - And it hangs during suspend-to-RAM, due to git-acpi.patch
> 
> Sorry, I was wrong.
> 
> > On my HP nx6325 it only boots with "noacpitimer nohpet" on the command line,
> > but then it works.
> 
> It _sometimes_ boots with "noacpitimer nohpet" and that's if I press the power
> button for a couple of times during boot (before any messages appear on the
> console).
> 
> > Suspend-to-RAM and hibernation work too. :-) 
> 
> No, they don't (I must have booted -rc6 instead of it by mistake, sigh).
> 
> > Since 2.6.23-rc4-mm1 only booted with nohpet because of
> > 
> > x86_64-convert-to-clockevents.patch
> > 
> > I guess that the boot problems with this one result from the same patch.
> 
> Not sure any more ...
> 
> I'll try to compile it with NO_HZ and HIGH_RES_TIMERS unset.

OK, in that configuration it's much better.

It boots with nohpet alone and suspend/hibernation seem to work (still,
it didn't want to boot right after hibernation, but booted after I'd switched
it off/on manually).

Unfortunately, I get this in dmesg:

ALSA /home/rafael/src/mm/linux-2.6.23-rc6-mm1/sound/pci/hda/hda_intel.c:1758: hda-intel: ioremap error

and (obviously) the sound card doesn't work.

Additionally, I've got a couple of these:

WARNING: at /home/rafael/src/mm/linux-2.6.23-rc6-mm1/drivers/usb/core/driver.c:1
217 usb_autopm_do_device()

Call Trace:
 [<ffffffff8813885e>] :usbcore:usb_autopm_do_device+0x60/0xe9
 [<ffffffff88138910>] :usbcore:usb_autosuspend_device+0xc/0xe
 [<ffffffff88131aa8>] :usbcore:usb_disconnect+0x15f/0x18c
 [<ffffffff88133305>] :usbcore:hub_thread+0x691/0x10a1
 [<ffffffff8024a077>] autoremove_wake_function+0x0/0x38
 [<ffffffff88132c74>] :usbcore:hub_thread+0x0/0x10a1
 [<ffffffff80249f50>] kthread+0x49/0x79
 [<ffffffff8020ce98>] child_rip+0xa/0x12
 [<ffffffff80249f07>] kthread+0x0/0x79
 [<ffffffff8020ce8e>] child_rip+0x0/0x12

Greetings,
Rafael
