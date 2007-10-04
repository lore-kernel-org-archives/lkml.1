Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXJDPwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXJDPwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbXJDPwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:52:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36432 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028AbXJDPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:52:45 -0400
Message-Id: <1191513164.25019.1214154783@webmail.messagingengine.com>
X-Sasl-Enc: jUOY+rftHN+l/ZmosjRqxg+MmkXuvYBn6y+6C4PKh0uq 1191513164
From: "Scott" <lkml@bluecamel.eml.cc>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: cx88 pci_abort messages
Date: Thu, 04 Oct 2007 11:52:44 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having what I think is a PCI bus problem.

I have a ASUS P5B Intel 965 motherboard and a DVICO Fusion HDTV5 RT
adapter on the PCI bus. When this adapter is recording (anything) I see
pci_abort messages repeating in the /var/log/messages file. As a result
I see some minor video corruption during playback. I've installed the
adapter into a PCI slot that shares an IRQ with the onboard USB.
However, I've also disabled all USB support in BIOS, so the adapter is
the only thing on the IRQ, and still see the same errors. 

Any suggestions for further troubleshooting? Is this a PCI bus quirk on
this motherboard? A copy of my .config is at
http://donpoo.net/kernel_config

Oct  2 21:59:12 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
Oct  2 21:59:12 htpc cx88[0]/2-mpeg: general errors: 0x00080000
Oct  2 21:59:20 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
Oct  2 21:59:20 htpc cx88[0]/2-mpeg: general errors: 0x00080000
Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x00080000

htpc ~ # uname -a
Linux htpc 2.6.22.1 #4 SMP PREEMPT Tue Oct 2 04:15:40 EDT 2007 i686
Intel(R) Core(TM)2 CPU 6600 @ 2.40GHz GenuineIntel GNU/Linux

htpc ~ # lspci -v 
00:00.0 Host bridge: Intel Corporation Memory Controller Hub (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ea
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02)
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: f4900000-f89fffff
        Prefetchable memory behind bridge:
        00000000bfe00000-00000000dfdfffff
        Capabilities: [88] Subsystem: Intel Corporation Unknown device
        277d
        Capabilities: [80] Power Management version 3
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
        Queue=0/0 Enable-
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at e000 [size=32]

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 21
        I/O ports at e080 [size=32]

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev
02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 18
        Memory at febff400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, fast devsel, latency 0, IRQ 20
        Memory at febf8000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
        Queue=0/0 Enable-
        Capabilities: [70] Express Unknown type IRQ 0

00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02)
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Prefetchable memory behind bridge:
        00000000dfe00000-00000000dfefffff
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
        Queue=0/0 Enable-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown
        device 81ec
        Capabilities: [a0] Power Management version 2

00:1c.3 PCI bridge: Intel Corporation PCI Express Port 4 (rev 02)
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: f8a00000-f8afffff
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
        Queue=0/0 Enable-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown
        device 81ec
        Capabilities: [a0] Power Management version 2

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at d800 [size=32]

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 17
        I/O ports at d880 [size=32]

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at dc00 [size=32]

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev
02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0, IRQ 19
        Memory at febff000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if
01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        Memory behind bridge: f8b00000-feafffff
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown
        device 81ec

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 SATA controller: Intel Corporation SATA Controller AHCI (rev 02)
(prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 17
        I/O ports at ec00 [size=8]
        I/O ports at e880 [size=4]
        I/O ports at e800 [size=8]
        I/O ports at e480 [size=4]
        I/O ports at e400 [size=32]
        Memory at febff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
        Queue=0/4 Enable-
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] #12 [0010]

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Flags: medium devsel, IRQ 18
        Memory at 50000000 (32-bit, non-prefetchable) [size=256]
        I/O ports at 0400 [size=32]

01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7600
GT] (rev a1) (prog-if 00 [VGA])
        Subsystem: Giga-byte Technology Unknown device 3417
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at f6000000 (64-bit, non-prefetchable) [size=16M]
        I/O ports at bc00 [size=128]
        [virtual] Expansion ROM at f89e0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+
        Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint IRQ 0

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. Unknown
device 8168 (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8168
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at c800 [size=256]
        Memory at f8aff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at f8ac0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
        Queue=0/1 Enable-
        Capabilities: [60] Express Endpoint IRQ 0
        Capabilities: [84] Vendor Specific Information

04:02.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder (rev 05)
        Subsystem: DViCO Corporation FusionHDTV 5 Gold
        Flags: bus master, medium devsel, latency 64, IRQ 19
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

04:02.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [Audio Port] (rev 05)
        Subsystem: DViCO Corporation Unknown device d500
        Flags: bus master, medium devsel, latency 64, IRQ 7
        Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

04:02.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] (rev 05)
        Subsystem: DViCO Corporation DViCO FusionHDTV5 Gold
        Flags: bus master, medium devsel, latency 64, IRQ 19
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
--
Scott

