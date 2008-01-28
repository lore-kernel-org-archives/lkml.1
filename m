Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYA1VFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYA1VFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYA1VEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:04:52 -0500
Received: from ppp-110-246.adsl.restena.lu ([158.64.110.246]:48916 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753203AbYA1VEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:04:51 -0500
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Troubles waking up from suspend (S3) - how to debug?
Date: Mon, 28 Jan 2008 22:04:48 +0100
User-Agent: KMail/1.9.7
References: <200801271842.38007.bonbons@linux-vserver.org> <200801280239.11581.Rafal.Wysocki@fuw.edu.pl>
In-Reply-To: <200801280239.11581.Rafal.Wysocki@fuw.edu.pl>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801282204.48490.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0000012 364a551c516a4b788bcf14220bb9f377
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 02:39:11 you wrote:
> On Sunday, 27 of January 2008, Bruno Prémont wrote:
> > I'm currently trying out suspend (S3) on a few machines but none of them
> > wakes up completely/properly (I have a few more hosts I'm planning to try
> > suspend on once I can get useful information out of those not waking up
> > properly).
> >
> > Tested kernels: 2.6.24(-rc8), on one 2.6.23.8
> >
> > To suspend I enter the following from console:
> >   echo -n mem > /sys/power/state
>
> Please try s2ram (http://suspend.sf.net/s2ram-support.html).
Thanks for the pointer, using version 0.8 as available in Gentoo portage for my tests.

> > Fujitsu-Siemens S7020 laptop (i915GM based):
> >   Works fine except backlight that remains asleep and Xorg vesa driver
> >   crashing Xorg.
> >   It looks like a suspend cycle discards the VideoBIOS shadow copy.
> >   Adjusting brightness using hotkeys or acpi-fujitsusiemens does not help
> >   waking up the backlight.
> >   At best backlight comes back when suspending from Xorg with
> >   xf86-video-intel-2.2.x but then mode is distorded. Any attempt to fix
> > this using xrandr or switch to/from console puts backlight asleep.
>
> This one is on the s2ram whitelist, should work.
Backlight comes back with vesafb using s2ram, not yet tested with intelfb or Xorg.

Ideally the kernel would be able to recover this without the hacks by s2ram (vesafb
post the videobios -- intelfb (or xf86-video-intel for X) would be able to properly
configure the graphics).
For the intel drivers the problem is probably missing specs from Intel...

> > Acer Travelmate 660 laptop (i855GM based):
> >   Laptop suspends as expected but hangs while waking up.
>
> This might work with "s2ram -f --vbe_post --vbe_save", please try.
New tests scheduled later for this host...

> > Desktop with MSI nforce based mainboard with Athlon CPU, onboard graphics
>
> What kind?
MSI K7N420 (with first-generation nforce chipset), AMD Athlon 1800+ on it

lspci:
00:00.0 Host bridge: nVidia Corporation nForce CPU bridge (rev b2)
00:00.1 RAM memory: nVidia Corporation nForce 220/420 Memory Controller (rev b2)
00:00.2 RAM memory: nVidia Corporation nForce 220/420 Memory Controller (rev b2)
00:00.3 RAM memory: nVidia Corporation nForce 420 Memory Controller (DDR) (rev b2)
00:01.0 ISA bridge: nVidia Corporation nForce ISA Bridge (rev c3)
00:01.1 SMBus: nVidia Corporation nForce PCI System Management (rev c1)
00:02.0 USB Controller: nVidia Corporation nForce USB Controller (rev c3)
00:03.0 USB Controller: nVidia Corporation nForce USB Controller (rev c3)
00:04.0 Ethernet controller: nVidia Corporation nForce Ethernet Controller (rev c2)
00:05.0 Multimedia audio controller: nVidia Corporation nForce Audio (rev c2)
00:06.0 Multimedia audio controller: nVidia Corporation nForce Audio (rev c2)
00:08.0 PCI bridge: nVidia Corporation nForce PCI-to-PCI bridge (rev c2)
00:09.0 IDE interface: nVidia Corporation nForce IDE (rev c3)
00:1e.0 PCI bridge: nVidia Corporation nForce AGP to PCI Bridge (rev b2)
01:04.0 RAID bus controller: Triones Technologies, Inc. HPT374 (rev 07)
01:04.1 RAID bus controller: Triones Technologies, Inc. HPT374 (rev 07)
02:00.0 VGA compatible controller: nVidia Corporation NVCrush11 [GeForce2 MX Integrated Graphics] (rev b1)

00:00.0 0600: 10de:01a4 (rev b2)
00:00.1 0500: 10de:01ac (rev b2)
00:00.2 0500: 10de:01ad (rev b2)
00:00.3 0500: 10de:01ab (rev b2)
00:01.0 0601: 10de:01b2 (rev c3)
00:01.1 0c05: 10de:01b4 (rev c1)
00:02.0 0c03: 10de:01c2 (rev c3)
00:03.0 0c03: 10de:01c2 (rev c3)
00:04.0 0200: 10de:01c3 (rev c2)
00:05.0 0401: 10de:01b0 (rev c2)
00:06.0 0401: 10de:01b1 (rev c2)
00:08.0 0604: 10de:01b8 (rev c2)
00:09.0 0101: 10de:01bc (rev c3)
00:1e.0 0604: 10de:01b7 (rev b2)
01:04.0 0104: 1103:0008 (rev 07)
01:04.1 0104: 1103:0008 (rev 07)
02:00.0 0300: 10de:01a0 (rev b1)

Seen by s2ram as:
This machine can be identified by:
    sys_vendor   = "NVIDIA Corporation."
    sys_product  = "nFORCE-MCP"
    sys_version  = " "
    bios_version = "6.00 PG"

> > and hdd on HighPoint RR1640 PCI card (USB mouse & keyboard):
> >   Suspends as expected but hangs while waking up.
> >   During wakeup I can ping the computer but userspace does not respond
> > (e.g. no answer when trying to connect via ssh)
> >   The display remains off if using vga text console, display comes back
> > with garbadge when using nvidiafb (no Xorg running), USB is powered but
> > triggers no reactions on keyboard/mouse input
> >
> >
> > I tried using netconsole on the desktop computer to capture eventual
> > printks during resume but I got not a line during wakup. (only suspend
> > progress messages before actual suspend)
> >
> > What can I do to get more information out of those two last machines and
> > find out why they don't wake-up properly?
>
> Please apply the patches 01-11 from:
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24/patches/
> on top of 2.6.24, compile the kernel and install it.  After booting, please
> do:
>
> # echo core > /sys/power/pm_test
> # echo mem > /sys/power/state
This test passed (K7N420) with minimal amount of modules loaded (text-mode graphics).
Real suspend worked as well (s2ram -f --vbe_post) but it's not the right tuning to
get usable console back. Currently results in scrambled output with half of the
character placeholders flickering at cursor speed. (will test other options of this
version of s2ram, possibly upgrading to latest to get more options as descibed on
suspend.sf.net).
It takes about 1 minute between the moment when the first ping reply and 
userspace/display wakeup or netconsole messages.
More details to come as I get time to do more complete tests with all drivers.

> and see if the boxes survive it (this causes the suspend/resume sequence to
> be executed without acutally suspending, but busy-waiting for 5 sec.
> instead).
>
> Greetings,
> Rafael

Regards,
Bruno

