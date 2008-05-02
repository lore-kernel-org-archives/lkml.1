Return-Path: <linux-kernel-owner+w=401wt.eu-S936679AbYEBXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679AbYEBXDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbYEBXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:03:13 -0400
Received: from mail0.lsil.com ([147.145.40.20]:55175 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbYEBXDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:03:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HELP:  Is writeq an atomic operation??
Date: Fri, 2 May 2008 17:03:06 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B42@NAMAIL2.ad.lsil.com>
In-Reply-To: <87y76stj6j.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HELP:  Is writeq an atomic operation??
thread-index: Acispufoak/bLCWGT9iV5gjPT/h8WgAAXnLA
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 23:03:07.0184 (UTC) FILETIME=[AF139B00:01C8ACA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2008 4:50 PM, Andi Kleen wrote: 
> 
> > Here is a trace from pci express analyzer.   I'm sending
> 
> With what CPU/chipset was that?
> 

I'm developing sas driver for next generation controllers.  They should
work at least on x86, x86_64, ia64, and ppc64.  The host I was using for
gathering that trace was  x86_64 Intel Platform.  Here is the lspci
output:

00:00.0 Host bridge: Intel Corporation E7520 Memory Controller Hub (rev
0c)
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, fast devsel, latency 0
	Capabilities: [40] Vendor Specific Information

00:00.1 Class ff00: Intel Corporation E7525/E7520 Error Reporting
Registers (rev 0c)
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: fast devsel

00:01.0 System peripheral: Intel Corporation E7520 DMA Controller (rev
0c)
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: fast devsel, IRQ 5
	Memory at dd000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit-
Queue=0/1 Enable-

00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port
A (rev 0c) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: dd100000-dd1fffff
	Prefetchable memory behind bridge:
0000000088000000-00000000880fffff
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/1 Enable-
	Capabilities: [64] Express Root Port (Slot-) IRQ 0
	Capabilities: [100] Advanced Error Reporting

00:03.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port
A1 (rev 0c) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: dd200000-dd3fffff
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/1 Enable-
	Capabilities: [64] Express Root Port (Slot-) IRQ 0
	Capabilities: [100] Advanced Error Reporting

00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B
(rev 0c) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/1 Enable-
	Capabilities: [64] Express Root Port (Slot-) IRQ 0
	Capabilities: [100] Advanced Error Reporting

00:06.0 PCI bridge: Intel Corporation E7520 PCI Express Port C (rev 0c)
(prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/1 Enable-
	Capabilities: [64] Express Root Port (Slot-) IRQ 0
	Capabilities: [100] Advanced Error Reporting

00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 1400 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 1420 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 1440 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 1460 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2
EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, medium devsel, latency 0, IRQ 21
	Memory at dd001000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if
00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: dd400000-deffffff
	Prefetchable memory behind bridge: 88100000-881fffff

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
Interface Bridge (rev 02)
	Flags: bus master, medium devsel, latency 0

00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller
(rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 14b0 [size=16]

00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
Controller (rev 02)
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: medium devsel, IRQ 22
	I/O ports at 1100 [size=32]

01:00.0 Mass storage controller [0108]: LSI Logic / Symbios Logic
Unknown device 0077 (rev ff)
	Subsystem: Compaq Computer Corporation Unknown device 40a0
	Flags: bus master, fast devsel, latency 0, IRQ 5
	I/O ports at 2000 [size=256]
	Memory at dd140000 (64-bit, non-prefetchable) [size=16K]
	[virtual] Expansion ROM at 88000000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 3
	Capabilities: [68] Express Endpoint IRQ 0
	Capabilities: [d0] Vital Product Data
	Capabilities: [a8] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
	Capabilities: [c0] MSI-X: Enable- Mask- TabSize=15
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [138] Power Budgeting

02:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge
A (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
	Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [300] Power Budgeting

02:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt
Controller A (rev 09) (prog-if 20 [IO(X)-APIC])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, fast devsel, latency 0
	Memory at dd200000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Endpoint IRQ 0
	Capabilities: [6c] Power Management version 2

02:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge
B (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=02, secondary=04, subordinate=04, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: dd300000-dd3fffff
	Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [300] Power Budgeting

02:00.3 PIC: Intel Corporation 6700PXH I/OxAPIC Interrupt Controller B
(rev 09) (prog-if 20 [IO(X)-APIC])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, fast devsel, latency 0
	Memory at dd201000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Endpoint IRQ 0
	Capabilities: [6c] Power Management version 2

04:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet
Controller (rev 03)
	Subsystem: Intel Corporation PRO/1000 MT Dual Port Server
Adapter
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at dd300000 (64-bit, non-prefetchable) [size=128K]
	I/O ports at 3000 [size=64]
	Capabilities: [dc] Power Management version 2
	Capabilities: [e4] PCI-X non-bridge device
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-

04:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet
Controller (rev 03)
	Subsystem: Intel Corporation PRO/1000 MT Dual Port Server
Adapter
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at dd320000 (64-bit, non-prefetchable) [size=128K]
	I/O ports at 3040 [size=64]
	Capabilities: [dc] Power Management version 2
	Capabilities: [e4] PCI-X non-bridge device
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-

07:01.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
(prog-if 00 [VGA])
	Subsystem: Super Micro Computer Inc Unknown device 5480
	Flags: bus master, stepping, medium devsel, latency 66, IRQ 10
	Memory at de000000 (32-bit, non-prefetchable) [size=16M]
	I/O ports at 4000 [size=256]
	Memory at dd400000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 88100000 [disabled] [size=128K]
	Capabilities: [5c] Power Management version 2
