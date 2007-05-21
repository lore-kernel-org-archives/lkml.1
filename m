Return-Path: <linux-kernel-owner+w=401wt.eu-S1765132AbXEUW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765132AbXEUW33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbXEUW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:29:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:41003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759804AbXEUW27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:28:59 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 22 May 2007 00:28:57 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070521222857.87180@gmx.net>
MIME-Version: 1.0
Subject: Kernel Oops with 2.6.21.1 on an AMD K7 machine
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+BGfxI3OGBaZEmAGJe8VTp7B7nkEYi9MyB/0jj/R
 9oWGvoSp2LM8922ryuT6j28zm2Nisf6NBs4w== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: ES9rczVveWUoQ2zvDHVz+5IxU3U4N091
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

kernel 2.6.21.1 makes my machine Oops about 20 seconds after KDE 3,5 is brought up showing its graphical login (kdm):

lspci -v, based on a "sane" kernel 2.6.22-rc2 or 2.6.20.11 (with both of them the Oops does not happen at all) looks like this:

00:00.0 Host bridge: Silicon Integrated Systems [SiS] 740 Host (rev 01)
	Flags: bus master, medium devsel, latency 32
	Memory at d0000000 (32-bit, non-prefetchable) [size=64M]
	Capabilities: [c0] AGP version 2.0

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge (AGP) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=64
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: cfd00000-cfefffff
	Prefetchable memory behind bridge: bfa00000-cfbfffff

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS962 [MuTIOL Media IO] (rev 04)
	Flags: bus master, medium devsel, latency 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
	Flags: medium devsel
	I/O ports at 0c00 [size=32]

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (prog-if 80 [Master])
	Flags: bus master, medium devsel, latency 128
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at ff00 [size=16]

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] AC'97 Sound Controller (rev a0)
	Subsystem: C-Media Electronics Inc Unknown device 0300
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at d800 [size=256]
	I/O ports at d400 [size=128]
	Capabilities: [48] Power Management version 2

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. K7SOM+ 5.2C Motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 5
	Memory at cfff7000 (32-bit, non-prefetchable) [size=4K]

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. K7SOM+ 5.2C Motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at cfff8000 (32-bit, non-prefetchable) [size=4K]

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. K7SOM+ 5.2C Motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at cfff9000 (32-bit, non-prefetchable) [size=4K]

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller (prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 5470
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at cfffa000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 2

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast Ethernet (rev 90)
	Subsystem: Silicon Integrated Systems [SiS] SiS900 10/100 Ethernet Adapter
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at d000 [size=256]
	Memory at cfff6000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at cffc0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2

00:09.0 SCSI storage controller: Adaptec AIC-7861 (rev 01)
	Flags: bus master, medium devsel, latency 64, IRQ 5
	I/O ports at dc00 [disabled] [size=256]
	Memory at cfffb000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at cffe0000 [disabled] [size=64K]

00:0b.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
	Subsystem: 3Com Corporation 3C905B Fast Etherlink XL 10/100
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at cc00 [size=128]
	Memory at cfff5f80 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at cffa0000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 1

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS] 65x/M650/740 PCI/AGP VGA Display Adapter (prog-if 00 [VGA])
	Subsystem: Silicon Integrated Systems [SiS] 65x/M650/740 PCI/AGP VGA Display Adapter
	Flags: 66MHz, medium devsel
	BIST result: 00
	Memory at c0000000 (32-bit, prefetchable) [size=128M]
	Memory at cfee0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at ac00 [size=128]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] AGP version 2.0

Please notice:

On an Intel P4 machine with but Intel chipset and Broadcom b44 NIC that Oops does not happen in connection with 2.6.21.1!


Questions:

1. Does anyone have a similar machine (AMD Athlon 1800 XP processor) with similar hardware configuration?

2. If yes, can anyone confirm that Oops problem in connection with that similar hardware architecture and kernel 2.6.21.1.

Regards

Uwe

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kanns mit allen: http://www.gmx.net/de/go/multimessenger
