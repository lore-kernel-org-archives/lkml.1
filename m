Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXBSRNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXBSRNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXBSRNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:13:10 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35483 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429AbXBSRNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:13:09 -0500
Date: Mon, 19 Feb 2007 12:13:08 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070219171308.GW7584@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca> <45D921E0.2040608@xs4all.nl> <20070219151705.GQ7582@csclub.uwaterloo.ca> <45D9C5BB.9020807@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D9C5BB.9020807@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 04:43:55PM +0100, Udo van den Heuvel wrote:
> Lennart Sorensen wrote:
> > On Mon, Feb 19, 2007 at 05:04:48AM +0100, Udo van den Heuvel wrote:
> >> lspci and interrupts at the bottom. yes, we have apic.
> > 
> > Well you could always try to just change the setting
> 
> You mean the Device Number of the riser card?
> Or?

Yeah the device number.

> > to see if you find
> > one where the interrupts are happy.  If you change the setting by one at
> > a time, you should only have to try 4 positions to get one that works
> > since that is how many interrupts PCI has.
> 
> So there could (or is) be a relation between interrupt and DN?

Well certainly the usual way to layout a PCI bus the interrupt does have
to do with the device number.

> # lspci
> 00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> (...)
> 00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
> IGP (rev 01)
> 
> Device Numbers can be configured from 12 to 19 but some numbers are
> already in use (the number after the initial 00:). That is OK?

Just don't use one that is already in use.  The link you sent seemed to
indicate 20 and 19 were the defaults.  That matches with 0x13 and 0x14
so I guess it is.  If 00:10 isn't in use you could try that one (device
16).  If nothing else uses them, 16, 17, 18, 19 would be worth trying
since that should (normally at least) try all the interrupt
possibilities.

> # lspci -v
> 00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
>         Subsystem: VIA Technologies, Inc. Unknown device aa08
>         Flags: bus master, 66MHz, medium devsel, latency 8
>         Memory at e8000000 (32-bit, prefetchable) [size=128M]
>         Capabilities: [80] AGP version 3.5
>         Capabilities: [50] Power Management version 2
> 
> 00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
>         Flags: bus master, medium devsel, latency 0
> 
> 00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
>         Flags: bus master, medium devsel, latency 0
> 
> 00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
>         Flags: bus master, medium devsel, latency 0
> 
> 00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
>         Flags: bus master, medium devsel, latency 0
> 
> 00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
>         Flags: bus master, medium devsel, latency 0
> 
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if 00
> [Normal decode])
>         Flags: bus master, 66MHz, medium devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000b000-0000bfff
>         Memory behind bridge: fb000000-fcffffff
>         Prefetchable memory behind bridge: f4000000-f7ffffff
>         Capabilities: [70] Power Management version 2
> 
> 00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
> Controller (rev 80) (prog-if 10 [OHCI])
>         Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
>         Flags: bus master, stepping, medium devsel, latency 32, IRQ 20
>         Memory at fdfff000 (32-bit, non-prefetchable) [size=2K]
>         I/O ports at fc00 [size=128]
>         Capabilities: [50] Power Management version 2
> 
> 00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
> Gigabit Ethernet Adapter (rev 11)
>         Subsystem: VIA Technologies, Inc. Unknown device 0110
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
>         I/O ports at f800 [size=256]
>         Memory at fdffe000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [50] Power Management version 2
> 
> 00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
> Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         I/O ports at f400 [size=8]
>         I/O ports at f000 [size=4]
>         I/O ports at ec00 [size=8]
>         I/O ports at e800 [size=4]
>         I/O ports at e400 [size=16]
>         I/O ports at e000 [size=256]
>         Capabilities: [c0] Power Management version 2
> 
> 00:0f.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> (prog-if 8a [Master SecP PriP])
>         Subsystem: VIA Technologies, Inc.
> VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
>         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
>         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
>         [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
>         I/O ports at dc00 [size=16]
>         Capabilities: [c0] Power Management version 2
> 
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         I/O ports at d800 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         I/O ports at d400 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         I/O ports at d000 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
> 20 [EHCI])
>         Subsystem: VIA Technologies, Inc. USB 2.0
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         Memory at fdffd000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
> 
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
> [KT600/K8T800/K8T890 South]
>         Subsystem: VIA Technologies, Inc. Unknown device aa08
>         Flags: bus master, stepping, medium devsel, latency 0
>         Capabilities: [c0] Power Management version 2
> 
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc.
> VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
>         Subsystem: VIA Technologies, Inc. Unknown device aa08
>         Flags: medium devsel, IRQ 21
>         I/O ports at c800 [size=256]
>         Capabilities: [c0] Power Management version 2
> 
> 00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Unknown device 1157
>         Flags: bus master, medium devsel, latency 32, IRQ 16
>         Memory at fdffc000 (32-bit, non-prefetchable) [size=512]
> 
> 00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Unknown device 1155
>         Flags: bus master, medium devsel, latency 32, IRQ 20
>         Memory at fdffb000 (32-bit, non-prefetchable) [size=512]
> 
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
> IGP (rev 01) (prog-if 00 [VGA])
>         Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
>         Memory at f4000000 (32-bit, prefetchable) [size=64M]
>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>         [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [70] AGP version 3.0

0x14 = IRQ 20
0x13 = IRQ 16
0x10 = IRQ 19
0x0f = IRQ 18
0x0e = IRQ 17
0x0d = IRQ 20

Hmm, certainly the onboard devices are assigned in interesting order.
Is it possible that this board does simply not allow more pci slots?
After all if the BIOS knows that the only PCI slot in the system is
device 20 (0x14) then it has no reason to have any rule for how to
assign an interrupt to device 19 or anything else for that matter.  If
that is the case you would have to find out what interrupt is used as
INTA, B, C and D on device 20, so you can calculate which one would end
up on the other device (assuming the riser card maps them correctly,
which it probably does), and assign that to the card.  Of course it is
also possible that if you try other device numbers you could get lucky
and have the BIOS happen to assign the right value to your card for one
of them.

I see that VIA as their own 2 port riser card which is labeled as
working only with via boards, which may also mean that other riser cards
do not necesarily work with the via boards without some non standard
tweaking of the software.

--
Len Sorensen
