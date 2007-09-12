Return-Path: <linux-kernel-owner+w=401wt.eu-S968353AbXILQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968353AbXILQrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXILQqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:46:53 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:30234 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXILQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rjdmW9WOLYQDij3jWHdDFN7DRy0bHG/sduD74kJTvK54zYbToknf7zlBnKtTttB3tAlaF9kQYSfyuTwPYiwobI4CP7aE/f7lccKhwriMsQ2I6GjQC3ucCESsrlkj7KSBuTYLlY5J2PqlmwYVIvYYMYbL2zb9nOSTeTna4tL8SSc=
Message-ID: <64bb37e0709120946x7513fd6bg3a1c5ffee8ab64cf@mail.gmail.com>
Date: Wed, 12 Sep 2007 18:46:48 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: sk98lin for 2.6.23-rc1
Cc: "Rob Sims" <lkml-z@robsims.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Kyle Rose" <krose@akamai.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070905102230.10b0bdcf@oldman>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A8BAD4.8020004@akamai.com> <20070726165701.GM3572@stusta.de>
	 <20070730030130.GA6893@robsims.com> <20070905102230.10b0bdcf@oldman>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>
> The only known outstanding problems on 2.62.22.6 of sky2 are:
>  * problems with fibre PHY based systems
>  * suspend/resume issues, missing multicast reinitalization, etc.
> The previous stability problems have been addressed.

Sorry to disappoint you, but it just hung for me again.
After seeing the backport of commit  c59697e06058fc2361da8cefcfa3de85ac107582 as
"sky2: restore workarounds for lost interrupts" going into 2.6.22.5 I
decided to give it another try.

First tests worked and for two days I had no trouble, but today the
network hung again, until I removed and reinserted the sky2 module.

I'm using the Gentoo kernel 2.6.22-gentoo-r6 which is based on
2.6.22.6. (All patches at
http://dev.gentoo.org/~dsd/genpatches/patches-2.6.22-7.htm )
This is as x86_64 kernel but with a 32bit userland.

My hardware:
00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory
Controller Hub (rev 04)
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL
Integrated Graphics Controller (rev 04)
00:02.1 Display controller: Intel Corporation 82915G Integrated
Graphics Controller (rev 04)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC
Interface Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 03)
01:04.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)
01:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 19)

The Marvell controller is onboard, more info:
linux ~ # lspci -vxxx -s 02:00.0
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 19)
        Subsystem: ASUSTeK Computer Inc. Marvell 88E8053 Gigabit
Ethernet controller PCIe (Asus)
        Flags: bus master, fast devsel, latency 0, IRQ 318
        Memory at cfffc000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at e800 [size=256]
        Expansion ROM at cffc0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
00: ab 11 62 43 07 04 10 00 19 00 00 02 04 00 00 00
10: 04 c0 ff cf 00 00 00 00 01 e8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 42 81
30: 00 00 fc cf 48 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 f0 01 00 80 a0 01 01 50 02 fe 00 20 00 13
50: 03 5c 00 80 00 00 00 01 00 00 00 01 05 e0 83 00
60: 0c 30 e0 fe 00 00 00 00 89 41 00 00 00 00 00 00
70: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 10 00 11 00 c0 0f 00 00 00 20 1b 00 11 a4 03 00
f0: 08 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00

>From /proc/interrupts
318:     230462          0   PCI-MSI-edge      eth2

>From syslog:
Sep 12 11:01:27 linux [ 9580.538373]  CIFS VFS: server not responding
Sep 12 11:01:27 linux [ 9580.538385]  CIFS VFS: No response for cmd 50 mid 34863

Now the network was dead, I tried to restart it with ifconfig down &&
ifconfig up

Sep 12 11:03:54 linux [ 9727.917997] sky2 eth2: disabling interface
Sep 12 11:03:55 linux [ 9728.270436] sky2 eth2: enabling interface
Sep 12 11:03:55 linux [ 9728.272401] sky2 eth2: ram buffer 48K
Sep 12 11:03:56 linux [ 9730.016797] sky2 eth2: Link is up at 100
Mbps, full duplex, flow control both

As that did not help, I removed the sky2 module and reinserted it:

Sep 12 11:04:12 linux [ 9745.832197] sky2 eth2: disabling interface
Sep 12 11:04:18 linux [ 9751.197733] ACPI: PCI interrupt for device
0000:02:00.0 disabled
Sep 12 11:04:25 linux [ 9758.264714] ACPI: PCI Interrupt
0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Sep 12 11:04:25 linux [ 9758.264736] PCI: Setting latency timer of
device 0000:02:00.0 to 64
Sep 12 11:04:25 linux [ 9758.265409] sky2 0000:02:00.0: v1.14 addr
0xcfffc000 irq 16 Yukon-EC (0xb6) rev 2
Sep 12 11:04:25 linux [ 9758.265910] sky2 eth0: addr 00:15:f2:55:ce:f9
Sep 12 11:04:25 linux [ 9758.267754] udev: renamed network interface
eth0 to eth2
Sep 12 11:04:25 linux [ 9758.705240] sky2 eth2: enabling interface
Sep 12 11:04:25 linux [ 9758.707076] sky2 eth2: ram buffer 48K
Sep 12 11:04:27 linux [ 9760.592061] sky2 eth2: Link is up at 100
Mbps, full duplex, flow control both

Now the network was up again, but around one hour later it hung again.
Again after removing and reinserting the module it started to work
again, this time until I went home.

I switched back to the Realtek 8139, as that card works.

I can provide more info about the hardware, but I can't test any
patches, as this server is needed for work and random hangs after
hours of working are not really the nicest things to debug.

Torsten
