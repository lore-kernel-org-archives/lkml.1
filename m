Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXBSPoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXBSPoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBSPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:44:00 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2836 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXBSPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:43:59 -0500
Message-ID: <45D9C5BB.9020807@xs4all.nl>
Date: Mon, 19 Feb 2007 16:43:55 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca> <45D921E0.2040608@xs4all.nl> <20070219151705.GQ7582@csclub.uwaterloo.ca>
In-Reply-To: <20070219151705.GQ7582@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Mon, Feb 19, 2007 at 05:04:48AM +0100, Udo van den Heuvel wrote:
>> lspci and interrupts at the bottom. yes, we have apic.
> 
> Well you could always try to just change the setting

You mean the Device Number of the riser card?
Or?

> to see if you find
> one where the interrupts are happy.  If you change the setting by one at
> a time, you should only have to try 4 positions to get one that works
> since that is how many interrupts PCI has.

So there could (or is) be a relation between interrupt and DN?

# lspci
00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
(...)
00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev 01)

Device Numbers can be configured from 12 to 19 but some numbers are
already in use (the number after the initial 00:). That is OK?


>> The info:
>>
>> 00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
>> Host Bridge
(...)

> You need lspci -v to get interrupt information.

# lspci -v
00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: bus master, 66MHz, medium devsel, latency 8
        Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [80] AGP version 3.5
        Capabilities: [50] Power Management version 2

00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if 00
[Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fb000000-fcffffff
        Prefetchable memory behind bridge: f4000000-f7ffffff
        Capabilities: [70] Power Management version 2

00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80) (prog-if 10 [OHCI])
        Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 20
        Memory at fdfff000 (32-bit, non-prefetchable) [size=2K]
        I/O ports at fc00 [size=128]
        Capabilities: [50] Power Management version 2

00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
Gigabit Ethernet Adapter (rev 11)
        Subsystem: VIA Technologies, Inc. Unknown device 0110
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
        I/O ports at f800 [size=256]
        Memory at fdffe000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2

00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller
        Flags: bus master, medium devsel, latency 32, IRQ 18
        I/O ports at f400 [size=8]
        I/O ports at f000 [size=4]
        I/O ports at ec00 [size=8]
        I/O ports at e800 [size=4]
        I/O ports at e400 [size=16]
        I/O ports at e000 [size=256]
        Capabilities: [c0] Power Management version 2

00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
        Flags: bus master, medium devsel, latency 32, IRQ 18
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        I/O ports at dc00 [size=16]
        Capabilities: [c0] Power Management version 2

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d000 [size=32]
        Capabilities: [80] Power Management version 2

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at fdffd000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: bus master, stepping, medium devsel, latency 0
        Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: medium devsel, IRQ 21
        I/O ports at c800 [size=256]
        Capabilities: [c0] Power Management version 2

00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1155
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdffb000 (32-bit, non-prefetchable) [size=512]

01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev 01) (prog-if 00 [VGA])
        Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
        Capabilities: [70] AGP version 3.0


Kind regards,
Udo
