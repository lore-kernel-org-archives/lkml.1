Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXDLT3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXDLT3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXDLT3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:29:50 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55142 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752388AbXDLT3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:29:48 -0400
Date: Thu, 12 Apr 2007 21:22:57 +0200
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412192257.GA13535@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:50:54AM +0200, Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Helge Hafting wrote:
> 
> > > OK.  If you add initcall_debug to the kernel boot command line, what's the
> > > last thing we call?
> > The last messages (handwritten, somewhat shortened)
> > calling hid_init+0x0/0x10()
> > returned 0
> > ran for 0 msec
> > calling hid_init+0x0/0x50()
> > usbcore registered new interface driver hiddev
> > and then it hangs completely.
> 
> Hi Helge,
> 
> 2.6.21-rc6 (without any -mm patches) works fine?
> 
> Could you please
> 
> - try booting without any HID devices plugged in (i.e. usb mice, usb 
>   keyboards) if the problem persists?

Pulled the usb mouse - this moved the crash around.
usbhid was registered anyway, but later than usual.

The last messages:

md:  <...>
cpuidle: <...>
sdhci: <...>
sdhci: <...>
usbcore: registered new interface hiddev
usbcore: registered new interface usbhid
drivers/hid/usbhid/hid_core.c v2.6 USB HID coredriver
Advanced linux sound architecture <...>
ACPI: PCI Interrupt 0000:00:06.0[A]->GSI 17 (lewel,low)->IRQ 17

And then it hung. Rebooting into rc5mm4, I got this as the next msgs:
gameport: Trident 4DWave is pci0000:00:06.0/gameport0, speed 1966kHz
ALSA device list:
  #0: Trident TRID4DWAVENX PCI Audio at 0x9400, irq 17
oprofile: using NMI interrupt.
Netfilter messages via NETLINK v0.30.

I don't know if this is another problem, or what.

> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> 
Just downloaded it. Unfortunately, it will not revert cleanly:
$ patch -p1 -R --dry-run < ../git-hid.patch
 
patching file drivers/hid/Kconfig
patching file drivers/hid/Makefile
patching file drivers/hid/hid-core.c
Hunk #1 succeeded at 30 (offset -1 lines).
Hunk #2 succeeded at 871 (offset -1 lines).
Hunk #3 succeeded at 968 (offset -1 lines).
Hunk #4 succeeded at 984 (offset -1 lines).
patching file drivers/hid/hid-input.c
Hunk #1 succeeded at 433 (offset 2 lines).
Hunk #2 succeeded at 533 (offset 2 lines).
patching file drivers/hid/hidraw.c
patching file drivers/hid/usbhid/Kconfig
patching file drivers/hid/usbhid/Makefile
patching file drivers/hid/usbhid/hid-core.c
Unreversed patch detected!  Ignore -R? [n] 
Apply anyway? [n] 
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file
drivers/hid/usbhid/hid-core.c.
rej
patching file drivers/hid/usbhid/hid-ff.c
patching file drivers/hid/usbhid/hid-lgff.c
patching file drivers/hid/usbhid/hid-pidff.c
patching file drivers/hid/usbhid/hid-plff.c
patching file drivers/hid/usbhid/hid-tmff.c
patching file drivers/hid/usbhid/hid-zpff.c
patching file drivers/hid/usbhid/hiddev.c
patching file drivers/hid/usbhid/usbhid.h
patching file drivers/hid/usbhid/usbkbd.c
patching file drivers/hid/usbhid/usbmouse.c
patching file drivers/usb/Makefile
patching file drivers/usb/input/Kconfig
patching file drivers/usb/input/Makefile
Hunk #1 FAILED at 4.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/usb/input/Makefile.rej
patching file drivers/usb/input/hid-core.c
patching file drivers/usb/input/hid-ff.c
patching file drivers/usb/input/hid-lgff.c
patching file drivers/usb/input/hid-pidff.c
patching file drivers/usb/input/hid-plff.c
patching file drivers/usb/input/hid-tmff.c
patching file drivers/usb/input/hid-zpff.c
patching file drivers/usb/input/hiddev.c
patching file drivers/usb/input/usbhid.h
patching file drivers/usb/input/usbkbd.c
patching file drivers/usb/input/usbmouse.c
patching file include/linux/hid.h
patching file include/linux/hidraw.h


Do you want me to try that patch anyway?

Helge Hafting
