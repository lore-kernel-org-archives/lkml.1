Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbXE2Ibq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbXE2Ibq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXE2Ibi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:31:38 -0400
Received: from ic0245.upco.es ([130.206.70.245]:58985 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXE2Ibg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:31:36 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Romano Giannetti <romanol@upcomillas.es>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Chris Wright <chrisw@sous-sol.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070527184402.GA21161@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> 
	<alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> 
	<20070527164300.GA20355@srcf.ucam.org> <200705272032.15971.rjw@sisk.pl> 
	<20070527184402.GA21161@srcf.ucam.org>
Content-Type: text/plain;
	charset=utf-8
Date: Tue, 29 May 2007 10:31:32 +0200
Message-Id: <1180427492.21686.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 19:44 +0100, Matthew Garrett wrote:
>
> Anyway. I've tested the following patch on a dual-core x86. No obvious
> issues yet, but I'll try to put it through a few hundred cycles.
[patch to disable freezer deleted]

First of all, excuse me for being a quite lousy tester. Could not come
around to try bisecting, no time at all. Yesterday in the autobus I gave
a shot to this "wild test" and I report the results here.

- The good (?) news. I have made 7 suspend/resume cycle (to ram, I
haven't tested hibernation) with a 2.6.21.2 with that patch, applied
manually. The system did suspend and resume nicely even compiling a
kernel and opening openoffice. Normally (le me stress _normally_) no
delay was apparent on resume. I do not know how dangerous is this... :-)

- The bad (?) news. One time out of 7 I had the 60 seconds delay. I
attach here the dmesg(s) of the resumes,  a good one, a delayed one, and
another good one after a reboot (where you can, by the way, see the
dancing serial effect... the card is sometime /dev/ttyS1,
sometime /dev/ttyS2). 


[ 1112.984000] Back to C!
[ 1112.985000] Applying VIA southbridge workaround.
[ 1112.985000] PCI: Disabling Via external APIC routing
[ 1113.418000] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 2100006, writing 12100006)
[ 1113.418000] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was fff0, writing 38003800)
[ 1113.418000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[ 1114.408000] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 1114.408000] PCI: Setting latency timer of device 0000:00:07.2 to 64
[ 1114.408000] usb usb1: root hub lost power or was reset
[ 1114.481000] ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 1114.481000] PCI: Setting latency timer of device 0000:00:07.3 to 64
[ 1114.481000] usb usb2: root hub lost power or was reset
[ 1114.657000] ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
[ 1114.657000] PCI: Setting latency timer of device 0000:00:07.5 to 64
[ 1115.347000] pccard: PCMCIA card inserted into slot 1
[ 1115.347000] pcmcia: registering new device pcmcia1.0
[ 1115.459000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 1115.459000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 1115.504000] eth0: 3Com 3c589, io 0x300, irq 3, hw_addr 00:00:86:1A:4E:A8
[ 1115.504000]   8K FIFO split 5:3 Rx:Tx, auto xcvr
[ 1115.504000] pcmcia: registering new device pcmcia1.1
[ 1115.504000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 1115.504000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 1115.545000] 1.1: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
[ 1115.558000] PM: Writing back config space on device 0000:00:0e.0 at offset 3 (was 8, writing 4008)
[ 1115.558000] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was 2100012, writing 2100016)
[ 1115.609000] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[9]  MMIO=[e8004000-e80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[ 1115.615000] PM: Writing back config space on device 0000:00:10.0 at offset 5 (was 0, writing e8004800)
[ 1115.615000] PM: Writing back config space on device 0000:00:10.0 at offset 4 (was 1, writing 1801)
[ 1115.615000] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2900000, writing 2900003)
[ 1115.670000] pnp: Device 00:08 activated.
[ 1115.670000] pnp: Failed to activate device 00:0a.
[ 1115.670000] pnp: Failed to activate device 00:0b.
[ 1117.648000] 8139too Fast Ethernet driver 0.9.28
[ 1117.650000] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[ 1117.653000] eth0: RealTek RTL8139 at 0xe0a72800, 08:00:46:6e:93:a8, IRQ 10
[ 1117.653000] eth0:  Identified 8139 chip type 'RTL-8139C'
[ 1118.403000] input: Power Button (FF) as /class/input/input13
[ 1118.404000] ACPI: Power Button (FF) [PWRF]
[ 1118.404000] input: Sleep Button (CM) as /class/input/input14
[ 1118.405000] ACPI: Sleep Button (CM) [SBTN]
[ 1118.406000] input: Lid Switch as /class/input/input15
[ 1118.407000] ACPI: Lid Switch [LID]
[ 1118.830000] ACPI: Thermal Zone [THRM] (36 C)
[ 1119.431000] ACPI: AC Adapter [ACAD] (off-line)
[ 1119.899000] ACPI: Battery Slot [BAT1] (battery present)
[ 1119.904000] ACPI: Battery Slot [BAT2] (battery absent)
[ 1126.226000] eth1: no IPv6 routers present

suspend...

[ 2019.310000] pccard: card ejected from slot 0
[ 2019.345000] PCMCIA: socket dc99bc28: *** DANGER *** unable to remove socket power
[ 2019.346000] pccard: card ejected from slot 1
[ 2020.041000] ACPI: PCI interrupt for device 0000:00:10.0 disabled
[ 2024.641000] Suspending console(s)
[ 2024.656000]  usbdev2.1: PM: suspend 0->2, parent usb2 already 2
[ 2024.656000]  usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
[ 2024.656000] hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
[ 2024.656000]  usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
[ 2026.121000] pnp: Device 00:08 disabled.
[ 2026.137000] ACPI: PCI interrupt for device 0000:00:07.5 disabled
[ 2026.158000] ACPI: PCI interrupt for device 0000:00:07.3 disabled
[ 2026.169000] ACPI: PCI interrupt for device 0000:00:07.2 disabled
[ 2026.191000] Back to C!
[ 2026.191000] Applying VIA southbridge workaround.
[ 2026.191000] PCI: Disabling Via external APIC routing
[ 2026.247000] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 2100006, writing 12100006)
[ 2026.247000] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was fff0, writing 38003800)
[ 2026.247000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[ 2026.258000] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 2026.258000] PCI: Setting latency timer of device 0000:00:07.2 to 64
[ 2026.258000] usb usb1: root hub lost power or was reset
[ 2026.269000] ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 2026.269000] PCI: Setting latency timer of device 0000:00:07.3 to 64
[ 2026.269000] usb usb2: root hub lost power or was reset
[ 2026.282000] ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
[ 2026.282000] PCI: Setting latency timer of device 0000:00:07.5 to 64
[ 2027.240000] pccard: CardBus card inserted into slot 0
[ 2027.844000] pccard: PCMCIA card inserted into slot 1
[ 2027.844000] pcmcia: registering new device pcmcia1.0

YEP! Again!

[ 2087.910000] PM: Writing back config space on device 0000:00:0e.0 at offset 3 (was 8, writing 4008)
[ 2087.910000] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was 2100012, writing 2100016)
[ 2087.961000] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[9]  MMIO=[e8004000-e80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[ 2087.965000] PM: Writing back config space on device 0000:00:10.0 at offset 5 (was 0, writing e8004800)
[ 2087.965000] PM: Writing back config space on device 0000:00:10.0 at offset 4 (was 1, writing 1801)
[ 2087.965000] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2900000, writing 2900003)
[ 2087.967000] pnp: Device 00:08 activated.
[ 2087.967000] pnp: Failed to activate device 00:0a.
[ 2087.967000] pnp: Failed to activate device 00:0b.
[ 2089.036000]  usbdev1.2_ep00: PM: resume from 0, parent 1-2 still 2
[ 2089.036000] usbhid 1-2:1.0: PM: resume from 2, parent 1-2 still 2
[ 2089.036000]  usbdev1.2_ep81: PM: resume from 0, parent 1-2:1.0 still 2
[ 2089.036000]  usbdev1.2: PM: resume from 0, parent 1-2 still 2
[ 2089.108000] usb 1-2: USB disconnect, address 2
[ 2089.314000] usb 1-2: new low speed USB device using uhci_hcd and address 3
[ 2089.332000] pcmcia: registering new device pcmcia1.1
[ 2089.332000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 2089.332000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 2089.372000] 1.1: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
[ 2089.374000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 2089.374000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 2089.417000] eth0: 3Com 3c589, io 0x300, irq 3, hw_addr 00:00:86:1A:4E:A8
[ 2089.417000]   8K FIFO split 5:3 Rx:Tx, auto xcvr
[ 2089.458000] usb 1-2: configuration #1 chosen from 1 choice
[ 2089.474000] input: HID 062a:0001 as /class/input/input17
[ 2089.474000] input: USB HID v1.10 Mouse [HID 062a:0001] on usb-0000:00:07.2-2
[ 2093.871000] 8139too Fast Ethernet driver 0.9.28
[ 2093.873000] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[ 2093.874000] eth0: RealTek RTL8139 at 0xe0a72800, 08:00:46:6e:93:a8, IRQ 10
[ 2093.874000] eth0:  Identified 8139 chip type 'RTL-8139C'
[ 2095.392000] input: Power Button (FF) as /class/input/input18
[ 2095.393000] ACPI: Power Button (FF) [PWRF]
[ 2095.394000] input: Sleep Button (CM) as /class/input/input19
[ 2095.396000] ACPI: Sleep Button (CM) [SBTN]
[ 2095.397000] input: Lid Switch as /class/input/input20
[ 2095.398000] ACPI: Lid Switch [LID]
[ 2095.693000] ACPI: Thermal Zone [THRM] (62 C)
[ 2095.807000] ACPI: AC Adapter [ACAD] (on-line)
[ 2098.010000] ACPI: Battery Slot [BAT1] (battery present)
[ 2098.038000] ACPI: Battery Slot [BAT2] (battery absent)
[ 2102.654000] eth1: no IPv6 routers present
[ 2154.791000] pccard: card ejected from slot 0
[ 2174.376000] pccard: card ejected from slot 1
[ 2175.533000] ACPI: PCI interrupt for device 0000:00:10.0 disabled
[ 2178.997000] Suspending console(s)
[ 2179.010000]  usbdev2.1: PM: suspend 0->2, parent usb2 already 2
[ 2179.010000]  usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
[ 2179.010000] hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
[ 2179.010000]  usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
[ 2180.469000] pnp: Device 00:08 disabled.
[ 2180.485000] ACPI: PCI interrupt for device 0000:00:07.5 disabled
[ 2180.498000] ACPI: PCI interrupt for device 0000:00:07.3 disabled
[ 2180.509000] ACPI: PCI interrupt for device 0000:00:07.2 disabled
[ 2180.531000] Back to C!
[ 2180.535000] Applying VIA southbridge workaround.
[ 2180.535000] PCI: Disabling Via external APIC routing
[ 2181.319000] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 2100006, writing 12100006)
[ 2181.319000] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was fff0, writing 38003800)
[ 2181.319000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[ 2181.330000] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 2181.330000] PCI: Setting latency timer of device 0000:00:07.2 to 64
[ 2181.330000] usb usb1: root hub lost power or was reset
[ 2181.356000] ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[ 2181.356000] PCI: Setting latency timer of device 0000:00:07.3 to 64
[ 2181.356000] usb usb2: root hub lost power or was reset
[ 2182.038000] ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
[ 2182.038000] PCI: Setting latency timer of device 0000:00:07.5 to 64
[ 2182.676000] pccard: PCMCIA card inserted into slot 1
[ 2182.676000] pcmcia: registering new device pcmcia1.0
[ 2182.734000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 2182.734000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 2182.777000] eth0: 3Com 3c589, io 0x300, irq 3, hw_addr 00:00:86:1A:4E:A8
[ 2182.777000]   8K FIFO split 5:3 Rx:Tx, auto xcvr
[ 2182.777000] pcmcia: registering new device pcmcia1.1
[ 2182.777000] pcmcia: request for exclusive IRQ could not be fulfilled.
[ 2182.777000] pcmcia: the driver needs updating to supported shared IRQ lines.
[ 2182.818000] 1.1: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
[ 2182.831000] PM: Writing back config space on device 0000:00:0e.0 at offset 3 (was 8, writing 4008)
[ 2182.831000] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was 2100012, writing 2100016)
[ 2182.882000] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[9]  MMIO=[e8004000-e80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[ 2182.886000] PM: Writing back config space on device 0000:00:10.0 at offset 5 (was 0, writing e8004800)
[ 2182.886000] PM: Writing back config space on device 0000:00:10.0 at offset 4 (was 1, writing 1801)
[ 2182.886000] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2900000, writing 2900003)
[ 2182.888000] pnp: Device 00:08 activated.
[ 2182.888000] pnp: Failed to activate device 00:0a.
[ 2182.888000] pnp: Failed to activate device 00:0b.
[ 2183.798000] usb 1-2: USB disconnect, address 3
[ 2184.004000] usb 1-2: new low speed USB device using uhci_hcd and address 4
[ 2184.146000] usb 1-2: configuration #1 chosen from 1 choice
[ 2184.162000] input: HID 062a:0001 as /class/input/input21
[ 2184.162000] input: USB HID v1.10 Mouse [HID 062a:0001] on usb-0000:00:07.2-2
[ 2186.486000] 8139too Fast Ethernet driver 0.9.28
[ 2186.487000] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[ 2186.489000] eth0: RealTek RTL8139 at 0xe0a72800, 08:00:46:6e:93:a8, IRQ 10
[ 2186.489000] eth0:  Identified 8139 chip type 'RTL-8139C'
[ 2188.033000] input: Power Button (FF) as /class/input/input22
[ 2188.034000] ACPI: Power Button (FF) [PWRF]
[ 2188.035000] input: Sleep Button (CM) as /class/input/input23
[ 2188.035000] ACPI: Sleep Button (CM) [SBTN]
[ 2188.036000] input: Lid Switch as /class/input/input24
[ 2188.037000] ACPI: Lid Switch [LID]
[ 2188.675000] ACPI: Thermal Zone [THRM] (57 C)
[ 2188.718000] ACPI: AC Adapter [ACAD] (on-line)
[ 2194.020000] eth1: no IPv6 routers present
[ 2200.209000] ACPI: Battery Slot [BAT1] (battery present)
[ 2200.213000] ACPI: Battery Slot [BAT2] (battery absent)
[ 2262.913000] pccard: card ejected from slot 1
[ 2263.924000] ACPI: PCI interrupt for device 0000:00:10.0 disabled
[ 2267.459000] Suspending console(s)
[ 2267.472000]  usbdev2.1: PM: suspend 0->2, parent usb2 already 2
[ 2267.472000]  usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
[ 2267.472000] hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
[ 2267.472000]  usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
[ 2268.920000] pnp: Device 00:08 disabled.
[ 2268.936000] ACPI: PCI interrupt for device 0000:00:07.5 disabled
[ 2268.949000] ACPI: PCI interrupt for device 0000:00:07.3 disabled
[ 2268.960000] ACPI: PCI interrupt for device 0000:00:07.2 disabled

I recompiled with wireless, rebooted and it's all ok:

[  364.711000] Back to C!
[  364.712000] Applying VIA southbridge workaround.
[  364.712000] PCI: Disabling Via external APIC routing
[  364.741000] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 2100006, writing b2100006)
[  364.741000] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was fff0, writing 38003800)
[  364.741000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  364.754000] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[  364.755000] PCI: Setting latency timer of device 0000:00:07.2 to 64
[  364.755000] usb usb1: root hub lost power or was reset
[  364.766000] ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
[  364.766000] PCI: Setting latency timer of device 0000:00:07.3 to 64
[  364.766000] usb usb2: root hub lost power or was reset
[  364.803000] ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
[  364.803000] PCI: Setting latency timer of device 0000:00:07.5 to 64
[  365.761000] pccard: CardBus card inserted into slot 0
[  365.819000] rtl8180: Configuring chip resources
[  365.819000] PCI: Enabling device 0000:02:00.0 (0000 -> 0003)
[  365.819000] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 9 (level, low) -> IRQ 9
[  365.819000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[  365.819000] rtl8180: Memory mapped space @ 0x34000000
[  365.819000] rtl8180: MAC controller is a RTL8180 (v. F)

(rtl8180 deleted)

[  367.007000] pccard: PCMCIA card inserted into slot 1
[  367.007000] pcmcia: registering new device pcmcia1.0
[  367.061000] pcmcia: request for exclusive IRQ could not be fulfilled.
[  367.061000] pcmcia: the driver needs updating to supported shared IRQ lines.
[  367.112000] eth0: 3Com 3c589, io 0x300, irq 3, hw_addr 00:00:86:1A:4E:A8
[  367.112000]   8K FIFO split 5:3 Rx:Tx, auto xcvr
[  367.112000] pcmcia: registering new device pcmcia1.1
[  367.112000] pcmcia: request for exclusive IRQ could not be fulfilled.
[  367.112000] pcmcia: the driver needs updating to supported shared IRQ lines.
[  367.153000] 1.1: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

well, now the modem is S1. Not too much trouble, it's doing this since
immemorial time.

[  367.165000] PM: Writing back config space on device 0000:00:0e.0 at offset 3 (was 8, writing 4008)
[  367.165000] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was 2100012, writing 2100016)
[  367.216000] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[9]  MMIO=[e8004000-e80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  367.222000] PM: Writing back config space on device 0000:00:10.0 at offset 5 (was 0, writing e8004800)
[  367.222000] PM: Writing back config space on device 0000:00:10.0 at offset 4 (was 1, writing 1801)
[  367.222000] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2900000, writing 2900003)
[  367.223000] pnp: Device 00:08 activated.
[  367.223000] pnp: Failed to activate device 00:0a.
[  367.223000] pnp: Failed to activate device 00:0b.
[  368.041000] Associated successfully
[  368.041000] Using B rates
[  368.080000]  usbdev1.2_ep00: PM: resume from 0, parent 1-2 still 2
[  368.080000] usbhid 1-2:1.0: PM: resume from 2, parent 1-2 still 2
[  368.080000]  usbdev1.2_ep81: PM: resume from 0, parent 1-2:1.0 still 2
[  368.080000]  usbdev1.2: PM: resume from 0, parent 1-2 still 2
[  368.151000] usb 1-2: USB disconnect, address 2
[  368.357000] usb 1-2: new low speed USB device using uhci_hcd and address 3
[  368.498000] usb 1-2: configuration #1 chosen from 1 choice
[  368.515000] input: HID 062a:0001 as /class/input/input8
[  368.515000] input: USB HID v1.10 Mouse [HID 062a:0001] on usb-0000:00:07.2-2
[  369.826000] 8139too Fast Ethernet driver 0.9.28
[  369.827000] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[  369.828000] eth0: RealTek RTL8139 at 0xe0a98800, 08:00:46:6e:93:a8, IRQ 10
[  369.828000] eth0:  Identified 8139 chip type 'RTL-8139C'
[  371.247000] input: Power Button (FF) as /class/input/input9
[  371.297000] ACPI: Power Button (FF) [PWRF]
[  371.359000] input: Sleep Button (CM) as /class/input/input10
[  371.359000] ACPI: Sleep Button (CM) [SBTN]
[  371.402000] input: Lid Switch as /class/input/input11
[  371.403000] ACPI: Lid Switch [LID]
[  371.607000] ACPI: Thermal Zone [THRM] (54 C)
[  371.661000] ACPI: AC Adapter [ACAD] (on-line)
[  372.010000] ACPI: Battery Slot [BAT1] (battery present)
[  372.020000] ACPI: Battery Slot [BAT2] (battery absent)



--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

