Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbXEVCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbXEVCgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXEVCgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:36:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:3950 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363AbXEVCgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Yq1OCa3PcEDTGk7+J4Rw7KJq/beHD6QavoXBgytJ2yPX3/ed6KqYucHv30cuSDsCBbXvXF+dzKQfyAnDfzzS5ncEjgtTxifBOwR/Y12JbWHUHFOqjUAR5wvYEkzRFaKqaHHcleedD9xDo62vyASA6AdJbetefwl0ZgCOSuVJGTI=
Message-ID: <46525710.7050803@gmail.com>
Date: Mon, 21 May 2007 19:36:00 -0700
From: Wayne Sherman <wsherman@gmail.com>
Organization: System Design Works
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region,
 resource collisions
References: <46524A6D.5050601@gmail.com> <200705211903.46678.jbarnes@virtuousgeek.org>
In-Reply-To: <200705211903.46678.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> There's a recent thread about PCI resource assignment (sounds like your 
> BIOS might be buggy btw, or you're somehow running out of space), search 
> for the title "PCI bridge range sizing bug".  You may need the kernel to 
> reassign the resource for your NIC before you can use it.  I think Ivan 
> has some test patches along these lines.
> 
> If you can find out what resource it's colliding with, that might give you 
> a clue.

I don't have anything else plugged in to the PC (except a USB drive). 
BIOS is set to PNP OS.  How do I find out what it is colliding with?

Here is a full lspci output:

# lspci -v

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 10)
	Subsystem: ATI Technologies Inc RS480 Host Bridge
	Flags: bus master, 66MHz, medium devsel, latency 0

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 
[Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: ff400000-ff4fffff
	Prefetchable memory behind bridge: 00000000fab00000-00000000fea00000
	Capabilities: [44] HyperTransport: MSI Mapping
	Capabilities: [b0] #0d [0000]

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA 
(prog-if 01 [AHCI 1.0])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7244
	Flags: bus master, 66MHz, medium devsel, latency 96, IRQ 18
	I/O ports at e800 [size=8]
	I/O ports at e400 [size=4]
	I/O ports at e000 [size=8]
	I/O ports at dc00 [size=4]
	I/O ports at d800 [size=16]
	Memory at ff6ffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/2 Enable-
	Capabilities: [70] #12 [0010]

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 
10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at ff6fe000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 
10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 21
	Memory at ff6fd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 
10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 22
	Memory at ff6fc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 
10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 21
	Memory at ff6fb000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 
10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 22
	Memory at ff6fa000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI) 
(prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 20
	Memory at ff6ff800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
	Capabilities: [e4] Debug port

00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: 66MHz, medium devsel
	I/O ports at 0b00 [size=16]
	Capabilities: [b0] HyperTransport: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a 
[Master SecP PriP])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at ff00 [size=16]
	Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge 
(prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: ff500000-ff5fffff
	Prefetchable memory behind bridge: 40000000-400fffff

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] #0f [0010]

01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon 
Xpress 200] (prog-if 00 [VGA])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 10
	Memory at fc000000 (32-bit, prefetchable) [size=32M]
	I/O ports at a800 [size=256]
	Memory at ff4f0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at ff4c0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2

02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host 
Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 242d
	Flags: bus master, medium devsel, latency 64, IRQ 16
	Memory at ff5ff800 (32-bit, non-prefetchable) [size=2K]
	I/O ports at bc00 [size=128]
	Capabilities: [50] Power Management version 2

02:02.0 Non-VGA unclassified device: D-Link System Inc Unknown device 
4901 (rev 11)
	Subsystem: D-Link System Inc Unknown device 4901
	Flags: bus master, 66MHz, fast devsel, latency 64, IRQ 11
	Memory at <ignored> (32-bit, non-prefetchable)
	I/O ports at b800 [size=256]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data

02:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. Unknown 
device 8167 (rev 10)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 242c
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	I/O ports at b400 [size=256]
	Memory at ff5ff400 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 40000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2

Thanks,

Wayne
