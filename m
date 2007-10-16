Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXJPNqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXJPNqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXJPNqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:46:16 -0400
Received: from rtr.ca ([76.10.145.34]:1998 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbXJPNqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:46:16 -0400
Message-ID: <4714C0A6.1030204@rtr.ca>
Date: Tue, 16 Oct 2007 09:46:14 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com, pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PCIe Hotplug:  NFG unless I boot with card already inserted.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Dell notebook with an PCIe ExpressCard slot.
I also have a PCIe ExpressCard SATA controller (uses sata_sil24 driver).

I would like to be able to hot plug/unplug the controller card at will.
But alas, Linux doesn't cope with it *unless* I boot the kernel with
the card initially inserted.

1. Booting Linux kernel (latest 2.6.23) without the card inserted
means that the card will never be detected, regardless of how many
times subsequently the card is inserted/removed/whatever.

2. Booting Linux kernel *with* the card inserted means that it is
detected and used, and can be unplugged/replugged as I please,
with intervening suspend/resume (RAM or disk) cycles not interfering.

3. Booting Linux kernel without the card inserted, and then doing
a suspend-to-disk poweroff, inserting the card, and powering on again,
the card's BIOS extension runs as normal.  But on resume from the
suspend-to-disk, the running kernel again never sees the card,
even after removing/reinserting/whatever.

4. All of this leads me to believe that the kernel must be doing some
kind of once-only scan of hardware at boot time, and never repeating
it afterwards.  Loading/unloading all of the PCI/PCIe hotplug stuff
has no effect on this, so it must be broken elsewhere.

5. It is not likely to be a BIOS thing, because it still fails on
power-on (with card inserted) after a suspend-to-disk, which appears
to the BIOS exactly the same as any other power-on.

6. But it's probably a "kernel relies on BIOS data structure read
at boot time" issue, based on the observations above.

Suggestions?  Is this a known defect?
Maybe with a known fix lurking in a git tree somewhere?

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express PCI Express Root Port (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility X1400
03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832
03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
0d:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
