Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXKOUKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXKOUKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761676AbXKOUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:10:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760919AbXKOUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:10:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Date: Thu, 15 Nov 2007 21:27:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca>
In-Reply-To: <473C825E.3030307@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152127.38816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of November 2007, Mark Lord wrote:
> > Hi!
> > 
> >> > I have been reporting this off and on since 2.6.23 was released.
> >> > This problem was not apparent up to perhaps 2.6.23-rc8,
> >> > but definitely became common in 2.6.23 and 2.6.23.1.
> >> > 
> >> > Most of the time, a resume-from-RAM on my notebook takes about 2.1 seconds
> >> > of kernel time to complete.
> >> > 
> >> > Once in a while, it takes *much* longer, in the 14-20 second range.
> >> > These long events *seem* to be mostly after the notebook has been
> >> > in suspend for a longish time, but there's really nothing consistent here.
> >> > 
> >> > So git-bisect isn't going to work for this one.   I recently rebuilt the 
> >> > kernel
> >> > to include printk timestamps, and then it went 2 days without the issue 
> >> > happening,
> >> > until this morning (after an overnight suspend) finally.
> >> > 
> >> > The machine is a Dell Inspiron 9400, Intel chipset + Core2Duo 2.1GHZ w/3GB 
> >> > DDR2.
> >> > PCIe express chipset, ATI graphics, SATA hard drive.
> >> > 
> >> > 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
> >> > Express Memory Controller Hub (rev 03)
> >> > 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
> >> > Express PCI Express Root Port (rev 03)
> >> > 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
> >> > Definition Audio Controller (rev 01)
> >> > 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> >> > 1 (rev 01)
> >> > 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> >> > 2 (rev 01)
> >> > 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> >> > 4 (rev 01)
> >> > 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 
> >> > (rev 01)
> >> > 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 
> >> > (rev 01)
> >> > 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 
> >> > (rev 01)
> >> > 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 
> >> > (rev 01)
> >> > 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
> >> > Controller (rev 01)
> >> > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
> >> > 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
> >> > Bridge (rev 01)
> >> > 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial 
> >> > ATA Storage Controller IDE (rev 01)
> >> > 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
> >> > 01)
> >> > 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility 
> >> > X1400
> >> > 03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
> >> > (rev 02)
> >> > 03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832
> >> > 03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
> >> > SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
> >> > 03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
> >> > 03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
> >> > Adapter (rev 0a)
> >> > 03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
> >> > 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network 
> >> > Connection (rev 02)
> >> > 
> >> > There's also a USB2 hub connected, with the Logitech mouse being the
> >> > only thing plugged into it at present.
> >> > 
> >> > The best clue I have of what is happening, other than that it was first
> >> > seen during the late 2.6.23-rc* series, are the following two sets of
> >> > kernel logs.  The first set is from a "normal" fast wake-up,
> >> > and the second set is from the "slow" wake-up seen this morning.
> >> > 
> >> > Both logs show the same information, in pretty much the same order.
> >> > The BIG difference is a bunch of unexplained pauses of exactly 1-second
> >> > each that occur during the slow wakeup.
> >> > 
> >> > The only other difference is that the SATA disk messages are placed
> >> > differently within the two logs.  I'm thinking on that one but it
> >> > doesn't look significant to me.
> >> > 
> >> > The real question is, why the 1-sec pauses?
> > 
> > Can you try nohz=off highres=off? Strange stuff is happening with
> > nohz.
> ..
> 
> (added Ingo to CC: list:  maybe this is some weird interaction with CFS
> and jiffies being reset to 0 on resume ??)
> 
> I can try it, but it won't help debug the problem much.

Well, if you could verify that it doesn't happen at all with NO_HZ unset, that
would be a valuable data point, IMO.

> Remember, this happens very inconsistently, maybe 3-4 times a day,
> or not at all for 3-4 days.
> 
> But if somebody has a specific bug-fix patch that could explain this,
> then I'll happily apply it here.

I'm not aware of any fix related to the symptoms that you observe.

Greetings,
Rafael
