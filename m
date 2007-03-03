Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXCCOfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXCCOfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXCCOfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:35:17 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4855 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278AbXCCOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:35:15 -0500
Message-ID: <45E98799.5060506@xs4all.nl>
Date: Sat, 03 Mar 2007 15:35:05 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>, techzone@tranquilpc.co.uk,
       kenny@morex.com.tw
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>	<20070221224027.GK22464@csclub.uwaterloo.ca>	<200702212355.25601.s0348365@sms.ed.ac.uk>	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>	<m3wt2869nd.fsf@maximus.localdomain> <45DF2F9E.20905@xs4all.nl> <m3mz3464p8.fsf@maximus.localdomain>
In-Reply-To: <m3mz3464p8.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> I have DN19 and DN20 now and it doesn't work.
>> Only because the INT mapping on the riser is not right?
> 
> Yes. I assume DN20 works, only DN19 has problems.

Well, today I tried the same VIA motherboard (EN12000) with a Morex 2788
case and their dual PCI riser card does have a working interrupt on the
upper slot. lspci is below. I can use the lower slot later, when the
harddisk is not blocking the space for the PCI-card there.

I use a 2.6.20.1 kernel with SAA7146_USE_I2C_IRQ for budget-av.c. In the
old situation I was forced to use SAA7146_I2C_SHORT_DELAY even though
the upper slot had the same DN and same IRQ given by Linux.

Thanks a lot for all the comments and feedback!
Thanks to Morex for having a working PCI riser card!


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
[Normal
              decode])
        Flags: bus master, 66MHz, medium devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fb000000-fcffffff
        Prefetchable memory behind bridge: f4000000-f7ffffff
        Capabilities: [70] Power Management version 2

00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (
                  rev 80) (prog-if 10 [OHCI])
        Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 20
        Memory at fdfff000 (32-bit, non-prefetchable) [size=2K]
        I/O ports at fc00 [size=128]
        Capabilities: [50] Power Management version 2

00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
Gigabit
              Ethernet Adapter (rev 11)
        Subsystem: VIA Technologies, Inc. Unknown device 0110
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
        I/O ports at f800 [size=256]
        Memory at fdffe000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2

00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (r
                   ev 80) (prog-if 8f [Master SecP SecO PriP PriO])
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
VT82C586A/B/VT82C686/A/B/VT823x/A/
                                        C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8
                                            235 PIPC Bus Master IDE
        Flags: bus master, medium devsel, latency 32, IRQ 18
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        I/O ports at dc00 [size=16]
        Capabilities: [c0] Power Management version 2

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller
                 (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller
                 (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller
                 (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d000 [size=32]
        Capabilities: [80] Power Management version 2

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
20 [EHC
             I])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at fdffd000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T89
                         0 South]
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: bus master, stepping, medium devsel, latency 0
        Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 A
                          C97 Audio Controller (rev 60)
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: medium devsel, IRQ 21
        I/O ports at c800 [size=256]
        Capabilities: [c0] Power Management version 2

00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev
               01) (prog-if 00 [VGA])
        Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
        Capabilities: [70] AGP version 3.0


