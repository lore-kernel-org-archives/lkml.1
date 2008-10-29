Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYJ2PzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYJ2PzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYJ2PzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:55:05 -0400
Received: from ns.suse.de ([195.135.220.2]:44090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYJ2PzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:55:03 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Andrey Borzenkov <arvidjaar@mail.ru>, Len Brown <len.brown@intel.com>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Wed, 29 Oct 2008 16:54:54 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, toshiba_acpi@memebeam.org,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, preining@logic.at
References: <200809061108.34877.arvidjaar@mail.ru> <200810281615.19894.rjw@sisk.pl> <200810281922.20490.arvidjaar@mail.ru>
In-Reply-To: <200810281922.20490.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291654.56710.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008 17:22:12 Andrey Borzenkov wrote:
> On Tuesday 28 October 2008, Rafael J. Wysocki wrote:
> > On Tuesday, 28 of October 2008, Thomas Renninger wrote:
> > > On Monday 27 October 2008 17:52:55 Andrey Borzenkov wrote:
> > > > On Monday 08 September 2008, Thomas Renninger wrote:
> > > > > On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrote:
> > > > > > On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > > > > > > I have now two different devices that refer to the same
> > > > > > > hardware:
> > > > > > >
> > > > > > > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > > > > > > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 root
> > > > > > > root 0 2008-09-06 11:04 toshiba ->
> > > > > > > ../../devices/virtual/backlight/toshiba/
> > > > > > >
> > > > > > > Unfortunately, due to ACPI implementation the acpi_video0 one
> > > > > > > is much inferior (as it provides only effectively two levels
> > > > > > > instead of 8); and user level tools are apparently quite
> > > > > > > confused which one to select.
> > > > > > >
> > > > > > > Is there any mechanism that would allow tochiba_acpi to claim
> > > > > > > brightness for internal LCD screen that video would not attempt
> > > > > > > to grab it too?
> > > > > > >
> > > > > > > Of course manually disabling brightness handling in video is
> > > > > > > always possible,
> > > > > >
> > > > > > Actually it is not. brightness_switch_enabled only disables event
> > > > > > handling; it still resets actual brightness on loading and
> > > > > > creates sysfs files to confuse user space.
> > > > > >
> > > > > > > still is nice for this to be handled automatically.
> > > > >
> > > > > It is in latest ACPI test branch queued for 2.6.28.
> > > >
> > > > It is still not in rc2; is it scheduled for 2.6.28 or delayed
> > > > further?
> > >
> > > Right, it's not there.
> > > Len, what happened with the:
> > > "Check for ACPI backlight support otherwise use vendor ACPIdrivers -
> > > version 4" patches?
> > >
> > > They are pretty essential for video.ko.
> > > Otherwise graphics devices may get double poked (through vendor_acpi.ko
> > > drivers) or may register for graphics cards which are not there.
> >
> > Do you have a pointer to those patches?
>
> So far I am running with these commits from
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6:
This tree does not exist anymore...

Andrey, do you still have a local copy?
Could you use git format-patch and repost the whole series
(should be about 11 patches) to Len and CC me.
It would be some work for me to recollect everything.

I hope Len is reading that soon and can give a comment why this was
in Andi's, but did not get into his ACPI git tree...

This should directly go into ACPI test branch again.
It would be great if it could still get cherry-picked into .28.

Thanks,

     Thomas

Norbert: I just saw your brightness complains about your Sony on the acpi 
list. You should start testing with the patchset we are talking about here.
video.ko is rather broken without them.

     Thomas

> commit f43d728731c691772ddc29e50d25c68a859935b5
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Fri Aug 1 17:37:55 2008 +0200
>
>     Check for ACPI backlight support otherwise use vendor ACPI drivers
>
>
> commit ad9ed8385ed6ec5be8da7094db911c824258ceec
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Fri Aug 1 17:37:54 2008 +0200
>
>     ACPI: video: Ignore devices that aren't present in hardware
>
> I have been waiting for in-tree inclusion to submit patches for
> toshiba_acpi against stable base.


