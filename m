Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbXHKJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbXHKJEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXHKJEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:04:39 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:31378 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXHKJEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:04:38 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: resume from ram much slower
Date: Sat, 11 Aug 2007 11:04:28 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708101848.37222.arekm@maven.pl> <200708102200.10840.rjw@sisk.pl>
In-Reply-To: <200708102200.10840.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200708111104.29138.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 of August 2007, Rafael J. Wysocki wrote:
> On Friday, 10 August 2007 18:48, Arkadiusz Miskiewicz wrote:
> > Hi,
> >
> > Starting 1-2 weeks ago I have very long resume from
> > ram times. It takes more than 1 min to resume. Does anyone see such
> > behaviour?
> >
> > Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> >
> > "ACPI handle has no context!" are interesting btw.
>
> Let's try to find out something.
>
> Please apply the patch below and see if anything changes.

dmesg below. Nothing changes. I guess bisecting is going to be needed.

[   24.913452] tun0: Disabled Privacy Extensions
[   32.069393] eth1: no IPv6 routers present
[   32.975171] ehci_hcd 0000:00:1d.7: remove, state 4
[   32.975182] usb usb1: USB disconnect, address 1
[   33.042655] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
[   33.043371] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[   33.045553] uhci_hcd 0000:00:1d.3: remove, state 4
[   33.045563] usb usb5: USB disconnect, address 1
[   33.045899] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
[   33.045940] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
[   33.056364] uhci_hcd 0000:00:1d.2: remove, state 1
[   33.056527] usb usb4: USB disconnect, address 1
[   33.056618] usb 4-1: USB disconnect, address 2
[   13.345228] usb 4-2: USB disconnect, address 3
[   13.345652] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
[   13.345725] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[   13.345778] uhci_hcd 0000:00:1d.1: remove, state 1
[   13.345820] usb usb3: USB disconnect, address 1
[   13.345861] usb 3-1: USB disconnect, address 2
[   13.363517] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
[   13.368510] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[   13.370151] uhci_hcd 0000:00:1d.0: remove, state 4
[   13.370207] usb usb2: USB disconnect, address 1
[   13.370420] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
[   13.371608] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[   13.886551] Stopping tasks ... done.
[   15.057017] Suspending console(s)
[   15.163956] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   15.164039] sd 0:0:0:0: [sda] Stopping disk
[   39.102495] pnp: Device 00:09 disabled.
[   39.102518] eth1: Going into suspend...
[   39.105275] ACPI: PCI interrupt for device 0000:14:02.0 disabled
[   39.105285] ACPI handle has no context!
[   39.119631] ACPI handle has no context!
[   39.119656] ACPI: PCI interrupt for device 0000:14:00.2 disabled
[   39.119665] ACPI handle has no context!
[   39.136949] ACPI handle has no context!
[   39.290491] ACPI handle has no context!
[   39.310814] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[    0.955410] Intel machine check architecture supported.
[    0.955426] Intel machine check reporting enabled on CPU#0.
[    0.955447] Back to C!
[    0.389962] PM: Writing back config space on device 0000:00:01.0 at offset 
1 (was 100107, writing 100507)
[    0.389972] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   44.479003] PM: Writing back config space on device 0000:00:1b.0 at offset 
1 (was 100006, writing 100002)
[   44.479029] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> 
IRQ 16
[   44.479039] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   44.587216] PM: Writing back config space on device 0000:00:1c.0 at offset 
1 (was 100107, writing 100507)
[   44.587252] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   44.587283] PM: Writing back config space on device 0000:00:1c.1 at offset 
1 (was 100107, writing 100507)
[   44.587318] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   44.587348] PM: Writing back config space on device 0000:00:1c.2 at offset 
1 (was 100107, writing 100507)
[   44.587384] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   44.587414] PM: Writing back config space on device 0000:00:1c.3 at offset 
1 (was 100107, writing 100507)
[   44.587449] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   44.587459] PM: Writing back config space on device 0000:00:1d.0 at offset 
f (was 100, writing 10b)
[   44.587488] PM: Writing back config space on device 0000:00:1d.1 at offset 
f (was 200, writing 20b)
[   44.587518] PM: Writing back config space on device 0000:00:1d.2 at offset 
f (was 300, writing 30b)
[   44.587547] PM: Writing back config space on device 0000:00:1d.3 at offset 
f (was 400, writing 40b)
[   44.587582] PM: Writing back config space on device 0000:00:1d.7 at offset 
f (was 400, writing 40b)
[   44.587603] PM: Writing back config space on device 0000:00:1d.7 at offset 
4 (was 0, writing b0004000)
[   44.587614] PM: Writing back config space on device 0000:00:1d.7 at offset 
1 (was 2900000, writing 2900102)
[   44.587668] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   44.587882] PM: Writing back config space on device 0000:00:1f.2 at offset 
1 (was 2b00005, writing 2b80005)
[   44.587905] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   44.588290] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> 
IRQ 16
[   44.588324] PM: Writing back config space on device 0000:02:00.0 at offset 
c (was 0, writing f4ff0000)
[   44.588353] PM: Writing back config space on device 0000:02:00.0 at offset 
1 (was 100102, writing 100106)
[   47.765543] ata1.00: configured for UDMA/100
[   47.765593] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 
MB)
[   47.765615] sd 0:0:0:0: [sda] Write Protect is off
[   47.765620] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   47.765653] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   48.018381] PM: Writing back config space on device 0000:14:00.1 at offset 
4 (was 0, writing c0001000)
[   48.018391] PM: Writing back config space on device 0000:14:00.1 at offset 
3 (was 800000, writing 804000)
[   48.018401] PM: Writing back config space on device 0000:14:00.1 at offset 
1 (was 2100000, writing 2100106)
[   48.071492] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  
MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[   48.177500] PM: Writing back config space on device 0000:14:00.2 at offset 
4 (was 0, writing c0001800)
[   48.177510] PM: Writing back config space on device 0000:14:00.2 at offset 
3 (was 800000, writing 804000)
[   48.177521] PM: Writing back config space on device 0000:14:00.2 at offset 
1 (was 2100000, writing 2100106)
[   48.177546] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> 
IRQ 22
[   48.178615] eth1: Coming out of suspend...
[   48.284496] ata2.00: configured for UDMA/33
[   48.702888] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> 
IRQ 18
[   48.834567] pnp: Device 00:09 activated.
[   49.311920] sd 0:0:0:0: [sda] Starting disk
[   50.999649] Restarting tasks ... done.
[   51.049084] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> 
IRQ 23
[   51.049266] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   51.049275] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   51.063848] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 1
[   51.064072] ehci_hcd 0000:00:1d.7: debug port 1
[   51.064082] PCI: cache line size of 32 is not supported by device 
0000:00:1d.7
[   51.064254] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xb0004000
[   51.068163] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   51.082807] usb usb1: configuration #1 chosen from 1 choice
[   51.111129] hub 1-0:1.0: USB hub found
[   51.111264] hub 1-0:1.0: 8 ports detected
[   51.244457] USB Universal Host Controller Interface driver v3.0
[   51.246268] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> 
IRQ 16
[   51.246404] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   51.246412] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   51.248035] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 2
[   51.248188] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
[   51.258167] usb usb2: configuration #1 chosen from 1 choice
[   51.258730] hub 2-0:1.0: USB hub found
[   51.258838] hub 2-0:1.0: 2 ports detected
[   51.364158] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> 
IRQ 21
[   51.364337] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   51.364346] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   51.365438] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 3
[   51.365474] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[   51.365671] usb usb3: configuration #1 chosen from 1 choice
[   51.365722] hub 3-0:1.0: USB hub found
[   51.365733] hub 3-0:1.0: 2 ports detected
[   51.470209] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> 
IRQ 22
[   51.470232] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   51.470239] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   51.470282] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 4
[   51.470315] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[   51.470509] usb usb4: configuration #1 chosen from 1 choice
[   51.470560] hub 4-0:1.0: USB hub found
[   51.470576] hub 4-0:1.0: 2 ports detected
[   20.660855] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> 
IRQ 23
[   20.660869] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   20.660872] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   20.660895] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus 
number 5
[   20.660920] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[   20.661011] usb usb5: configuration #1 chosen from 1 choice
[   20.661033] hub 5-0:1.0: USB hub found
[   20.661038] hub 5-0:1.0: 2 ports detected
[   20.722226] [drm] Loading R300 Microcode
[   21.189182] usb 3-1: new low speed USB device using uhci_hcd and address 2
[   21.356594] usb 3-1: configuration #1 chosen from 1 choice
[   21.378739] input: Logitech Trackball 
as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input11
[   21.379033] input: USB HID v1.10 Mouse [Logitech Trackball] on 
usb-0000:00:1d.1-1
[   21.604901] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   21.771236] usb 4-1: configuration #1 chosen from 1 choice
[   22.000826] usb 4-2: new full speed USB device using uhci_hcd and address 3
[   22.168027] usb 4-2: configuration #1 chosen from 1 choice
[   59.646477] [drm] Loading R300 Microcode
[   60.420987] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.752881] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   69.429282] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready


> Greetings,
> Rafael

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
