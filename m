Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYEYMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYEYMYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbYEYMYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:24:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760075AbYEYMYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:24:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Suspend to memory is freezing my machine
Date: Sun, 25 May 2008 14:24:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com> <200805242301.25695.rjw@sisk.pl> <c4e36d110805250159x34e667f2kcfbc01a7b87dda29@mail.gmail.com>
In-Reply-To: <c4e36d110805250159x34e667f2kcfbc01a7b87dda29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251424.49186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of May 2008, Zdenek Kabelac wrote:
> 2008/5/24 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, 22 of May 2008, Zdenek Kabelac wrote:
> >> Hello Rafael
> >>
> >> 2008/5/4 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
> >> >> Hello
> >> >
> >> > Hi,
> >> >
> >> >> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
> >> >> complete freeze of my T61 during suspend. (dual core, 2GB).
> >> >
> >> > How reproducible is this?
> >> >
> >>
> >> The problem happens still even with -rc3. Now I've an update:
> >>
> >> Usually I've to run the machine for couple hours to actually be able
> >> to hit this lock.
> >> (Usually after a day work when I want to leave)
> >>
> >> I've also noticed that when I run the suspend after the reboot I
> >> usually cannot see the suspend freeze - mostly because either the
> >> mashine crashes from other ooops or I do another reboot.
> >>
> >>
> >> >> I'm running kernel with no_console_suspend - but all I can see is
> >> >> blinking cursor on an empty screen - thus even when I run kernel with
> >> >> most debug options turned on, I can't pass more details so far.  I run
> >>
> >> I've figured out, it was caused by some weird Fedora setting, so
> >> adding  kernel.printk = 8  to sysctl.conf  fixed the issue for me.
> >>
> >> >> suspend with with SD card in - so maybe some update in the MMC driver
> >> >> might be responsible for this ?
> >> > (1) The problem occurs without no_console_suspend.
> >> > (2) The problem occurs without the SD card.
> >>
> >> SD card or no_console_suspend option doesn't matter
> >>
> >> This is what I've seen as the last thing on the screen when deadlock
> >> appeared this time:
> >> (no SD card inserted)
> >>
> >> ====
> >> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> >> PM: Entering mem sleep
> >> drm card0: class suspend
> >> drm_sysfs_suspend
> >
> > Hm, what kind of graphics adapter is there in your box?
> >
> 
> 
> After some more checking - I guess this information actually is not
> useful at all :(.
> It looks like even when the suspend is succesful - the line:
> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> is alway the last one visible.
> 
>  I'll try to get figure out a better way how to invoke the lock.
> 
> And my graphics adapter is:
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA
> controller])

If you use s2ram, please check if "echo mem > /sys/power/state" works instead.

Thanks,
Rafael
