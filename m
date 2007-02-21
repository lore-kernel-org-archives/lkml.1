Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbXBUXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbXBUXur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXBUXur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:50:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:59828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXBUXup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:50:45 -0500
Date: Wed, 21 Feb 2007 15:49:06 -0800
From: Greg KH <greg@kroah.com>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21rc1 git usb mouse stops working after resume from ram
Message-ID: <20070221234905.GB7133@kroah.com>
References: <200702212314.56958.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702212314.56958.arekm@maven.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:14:56PM +0100, Arkadiusz Miskiewicz wrote:
> Hello,
> 
> Today version of Linus git tree has a problem with resuming of usb devices. My 
> trackball is no longer working after resume from ram. It not even seen by lsusb.  Newly
> plugged devices are no longer detected (ie. my usb camera) after resume.
> 
> Reloading all usb + ohci/ehci modules doesn't fix the problem. I need to reboot entire 
> machine (thinkpad z60m).

If you disable CONFIG_USB_SUSPEND, does it work properly for you?

(rest of the boot log left below for the benifit of the linux-usb-devel
mailing list readers.)

thanks,

greg k-h


> Log, lines prefixed with plus character are things new in dmesg after resume
> 
> [    3.615018] ata1.00: configured for UDMA/100
> [    3.615069] scsi1 : ata_piix
> [    3.626792] Switched to high resolution mode on CPU 0
> [    3.931519] ata2.00: ATAPI, max UDMA/33
> [    4.095266] ata2.00: configured for UDMA/33
> [    4.095391] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZI PQ: 0 ANSI: 5
> [    4.097362] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-830Sx 1.00 PQ: 0 ANSI: 5
> [    4.098744] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
> [    4.098801] sda: Write Protect is off
> [    4.098848] sda: Mode Sense: 00 3a 00 00
> [    4.098857] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.098951] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
> [    4.099006] sda: Write Protect is off
> [    4.099052] sda: Mode Sense: 00 3a 00 00
> [    4.099062] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.099118]  sda: sda1 sda2 sda3 sda4
> [    4.142831] sd 0:0:0:0: Attached scsi disk sda
> [    4.146811] SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
> [    4.146970] SGI XFS Quota Management subsystem
> [    4.201303] XFS mounting filesystem sda4
> [    4.288302] Ending clean XFS mount for filesystem: sda4
> [    4.288341] VFS: Mounted root (xfs filesystem) readonly.
> [    4.288391] Trying to move old root to /initrd ... okay
> [    4.343229] Freeing unused kernel memory: 172k freed
> [    7.637854] input: PC Speaker as /class/input/input1
> [    7.735476] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    7.736402] pnp: Device 00:06 does not support disabling.
> [    7.736406] rtc_cmos: probe of 00:06 failed with error -16
> [    7.833604] NET: Registered protocol family 23
> [    7.851428] iTCO_vendor_support: vendor-support=0
> [    7.857586] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
> [    7.857652] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
> [    7.857682] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    7.886626] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    7.886630] Uniform CD-ROM driver Revision: 3.20
> [    7.886666] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    7.924750] ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 20
> [    7.946495] Linux agpgart interface v0.102 (c) Dave Jones
> [    7.947737] agpgart: Detected an Intel 915GM Chipset.
> [    7.964596] agpgart: AGP aperture is 256M @ 0x0
> [    7.975818] intel_rng: FWH not detected
> [    7.997483] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> [    7.997488] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> [    8.158754] tg3.c:v3.73 (February 12, 2007)
> [    8.158776] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    8.158788] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [    8.198346] eth0: Tigon3 [partno(BCM95751M) rev 4101 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:c0:9f:ed:33:cc
> [    8.198352] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[1] 
> [    8.198355] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> [    8.233994] usbcore: registered new interface driver usbfs
> [    8.234013] usbcore: registered new interface driver hub
> [    8.234028] usbcore: registered new device driver usb
> [    8.314778] sdhci: Secure Digital Host Controller Interface driver
> [    8.314782] sdhci: Copyright(c) Pierre Ossman
> [    8.314802] sdhci: SDHCI controller found at 0000:14:00.2 [1180:0822] (rev 17)
> [    8.314824] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 21
> [    8.315836] sdhci:slot0: Controller reports > 25 MHz base clock, but no high speed support.
> [    8.317907] mmc0: SDHCI at 0xc0001800 irq 21 DMA
> [    8.438883] pnp: Device 00:09 activated.
> [    8.438901] nsc-ircc, chip->init
> [    8.438913] nsc-ircc, Found chip at base=0x164e
> [    8.438948] nsc-ircc, driver loaded (Dag Brattli)
> [    8.490724] IrDA: Registered device irda0
> [    8.490726] nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
> [    8.800531] USB Universal Host Controller Interface driver v3.0
> [    8.800576] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    8.800586] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    8.800589] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    8.800814] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> [    8.800843] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
> [    8.800938] usb usb1: configuration #1 chosen from 1 choice
> [    8.800958] hub 1-0:1.0: USB hub found
> [    8.800963] hub 1-0:1.0: 2 ports detected
> [    8.904072] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
> [    8.904083] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    8.904086] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    8.904103] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> [    8.904132] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001820
> [    8.904202] usb usb2: configuration #1 chosen from 1 choice
> [    8.904222] hub 2-0:1.0: USB hub found
> [    8.904226] hub 2-0:1.0: 2 ports detected
> [    8.919830] ieee1394: Initialized config rom entry `ip1394'
> [    8.991284] ieee80211_crypt: registered algorithm 'NULL'
> [    9.000748] ieee80211: 802.11 data/management/control stack, git-1.1.13
> [    9.000751] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> [    9.008022] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 21
> [    9.008032] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    9.008035] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    9.008052] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> [    9.008077] uhci_hcd 0000:00:1d.2: irq 21, io base 0x00001840
> [    9.008149] usb usb3: configuration #1 chosen from 1 choice
> [    9.008169] hub 3-0:1.0: USB hub found
> [    9.008173] hub 3-0:1.0: 2 ports detected
> [    9.111947] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 23
> [    9.111958] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [    9.111962] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    9.111980] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> [    9.112024] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
> [    9.112096] usb usb4: configuration #1 chosen from 1 choice
> [    9.112116] hub 4-0:1.0: USB hub found
> [    9.112120] hub 4-0:1.0: 2 ports detected
> [    9.117662] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kmprq
> [    9.117666] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [    9.216247] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
> [    9.216259] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    9.216262] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    9.216262] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>  [    9.216282] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
>  [    9.216311] ehci_hcd 0000:00:1d.7: debug port 1
>  [    9.216316] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> [    9.216323] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xb0004000
> [    9.220219] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    9.220281] usb usb5: configuration #1 chosen from 1 choice
> [    9.220302] hub 5-0:1.0: USB hub found
> [    9.220307] hub 5-0:1.0: 8 ports detected
> [    9.247800] usb 2-1: new low speed USB device using uhci_hcd and address 2
> [    9.323904] ACPI: PCI Interrupt 0000:14:00.1[B] -> GSI 17 (level, low) -> IRQ 22
> [    9.376775] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [    9.383999] Yenta: CardBus bridge found at 0000:14:00.0 [1014:056c]
> [    9.500390] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
> [    9.500395] serio: Synaptics pass-through port at isa0060/serio1/input0
> [    9.512408] Yenta: ISA IRQ mask 0x04b0, PCI irq 16
> [    9.512411] Socket status: 30000820
> [    9.512474] pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
> [    9.512477] pcmcia: parent PCI bridge Memory window: 0xb8000000 - 0xc00fffff
> [    9.512479] pcmcia: parent PCI bridge Memory window: 0xd8000000 - 0xdfffffff
> [    9.521394] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 18
> [    9.521422] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
> [    9.521489] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    9.521501] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    9.545169] input: SynPS/2 Synaptics TouchPad as /class/input/input2
> [    9.762260] ipw2200: Radio Frequency Kill Switch is On:
> [    9.762262] Kill switch must be turned off for wireless networking to work.
> [    9.762451] ipw2200: Detected geography ZZE (13 802.11bg channels, 19 802.11a channels)
> [   10.207282] pccard: CardBus card inserted into slot 0
> [   10.207433] usb 2-1: new low speed USB device using uhci_hcd and address 3
> [   10.380406] usb 2-1: configuration #1 chosen from 1 choice
> [   10.623071] usb 3-2: new full speed USB device using uhci_hcd and address 2
> [   10.655128] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00061b002020c273]
> [   10.742663] eth1394: eth2: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
> [   10.801173] usb 3-2: configuration #1 chosen from 1 choice
> [   10.804247] input: Logitech Trackball as /class/input/input3
> [   10.804276] usbcore: registered new interface driver usbmouse
> [   10.804279] drivers/usb/input/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
> [   10.880672] usbcore: registered new interface driver hiddev
> [   10.880684] usbcore: registered new interface driver usbhid
> [   10.880686] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> [   11.750191] Adding 997912k swap on /dev/sda3.  Priority:-1 extents:1 across:997912k
> [   13.868025] tun: Universal TUN/TAP device driver, 1.6
> [   13.868028] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   13.912060] ibm_acpi: IBM ThinkPad ACPI Extras v0.13
> [   13.912063] ibm_acpi: http://ibm-acpi.sf.net/
> [   13.912065] ibm_acpi: ThinkPad EC firmware 77HT58WW-1.18
> [   13.936339] Non-volatile memory driver v1.2
> [   13.989054] ACPI: AC Adapter [AC] (on-line)
> [   14.016434] ACPI: Battery Slot [BAT0] (battery present)
> [   14.057622] input: Power Button (FF) as /class/input/input4
> [   14.060804] ACPI: Power Button (FF) [PWRF]
> [   14.081651] input: Lid Switch as /class/input/input5
> [   14.085310] ACPI: Lid Switch [LID]
> [   14.105386] input: Sleep Button (CM) as /class/input/input6
> [   14.108656] ACPI: Sleep Button (CM) [SLPB]
> [   14.151484] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [   14.151489] ACPI: Processor [CPU] (supports 8 throttling states)
> [   14.167656] ACPI: Thermal Zone [THM0] (59 C)
> [   14.169182] Time: acpi_pm clocksource has been installed.
> [   14.178983] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [   14.179138] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [   14.245566] hdaps: IBM ThinkPad Z60m detected.
> [   14.251307] hdaps: initial latch check good (0x01).
> [   15.010191] IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [   15.272912] input: TPPS/2 IBM TrackPoint as /class/input/input7
> [   15.880641] hdaps: device successfully initialized.
> [   15.904066] input: hdaps as /class/input/input8
> [   15.907700] hdaps: driver successfully loaded.
> [   16.007543] IrCOMM protocol (Dag Brattli)
> [   16.055084] Bluetooth: Core ver 2.11
> [   16.057444] NET: Registered protocol family 31
> [   16.057447] Bluetooth: HCI device and connection manager initialized
> [   16.057450] Bluetooth: HCI socket layer initialized
> [   16.061505] Bluetooth: L2CAP ver 2.8
> [   16.061507] Bluetooth: L2CAP socket layer initialized
> [   16.084036] Bluetooth: RFCOMM socket layer initialized
> [   16.084060] Bluetooth: RFCOMM TTY layer initialized
> [   16.084062] Bluetooth: RFCOMM ver 1.8
> [   19.492240] tg3: eth0: Link is up at 100 Mbps, full duplex.
> [   19.492243] tg3: eth0: Flow control is on for TX and on for RX.
> [   30.153806] NET: Registered protocol family 10
> [   30.153862] lo: Disabled Privacy Extensions
> [   30.153898] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   30.153902] Mobile IPv6
>  [   75.003909] Clocksource tsc unstable (delta = -100632371 ns)
>  [  100.623070] eth0: no IPv6 routers present
> +[  111.340754] ehci_hcd 0000:00:1d.7: remove, state 4
> +[  111.340918] usb usb5: USB disconnect, address 1
> +[  111.354576] ehci_hcd 0000:00:1d.7: USB bus 5 deregistered
> +[  111.356180] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> +[  111.359987] uhci_hcd 0000:00:1d.3: remove, state 4
> +[  111.360122] usb usb4: USB disconnect, address 1
> +[  111.368988] uhci_hcd 0000:00:1d.3: USB bus 4 deregistered
> +[  111.370543] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
> +[  111.370668] uhci_hcd 0000:00:1d.2: remove, state 4
> +[  111.370756] usb usb3: USB disconnect, address 1
> +[  111.370838] usb 3-2: USB disconnect, address 2
> +[  111.390422] uhci_hcd 0000:00:1d.2: USB bus 3 deregistered
> +[  111.391944] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> +[  111.392068] uhci_hcd 0000:00:1d.1: remove, state 1
> +[  111.392156] usb usb2: USB disconnect, address 1
> +[  111.392239] usb 2-1: USB disconnect, address 3
> +[  111.414928] uhci_hcd 0000:00:1d.1: USB bus 2 deregistered
> +[  111.416404] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> +[  111.416529] uhci_hcd 0000:00:1d.0: remove, state 4
> +[  111.416617] usb usb1: USB disconnect, address 1
> +[  111.425941] uhci_hcd 0000:00:1d.0: USB bus 1 deregistered
> +[  111.427400] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> +[  113.789994] Stopping tasks ... done.
> +[  113.822883] Suspending console(s)
> +[  113.989033] pnp: Device 00:09 disabled.
> +[  113.989043] eth1: Going into suspend...
> +[  113.989103] ACPI: PCI interrupt for device 0000:14:02.0 disabled
> +[  113.990333] ACPI: PCI interrupt for device 0000:14:00.2 disabled
> +[  114.171357] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> +[    0.955069] Intel machine check architecture supported.
> +[    0.955085] Intel machine check reporting enabled on CPU#0.
> +[    0.955105] Back to C!
> +[    0.510531] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 20002020, writing 2020)
> +[    0.510536] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
> +[    0.510545] PCI: Setting latency timer of device 0000:00:01.0 to 64
> +[    0.520881] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
> +[    0.520899] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> +[    0.520904] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> +[    0.523276] PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was f0, writing 200000f0)
> +[    0.523284] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
> +[    0.523307] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> +[    0.523325] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
> +[    0.523348] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> +[    0.523367] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
> +[    0.523389] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> +[    0.523408] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
> +[    0.523430] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> +[    0.523435] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
> +[    0.523455] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
> +[    0.523474] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
> +[    0.523493] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
> +[    0.523516] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
> +[    0.523529] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
> +[    0.523536] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
> +[    0.523579] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> +[    0.524168] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
> +[    0.524183] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> +[    0.524222] ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 20
> +[    0.524283] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
> +[    0.526230] tg3: eth0: Link is down.
> +[    0.527119] PM: Writing back config space on device 0000:02:00.0 at offset c (was fcff0000, writing 0)
> +[    2.009424] ipw2200: Radio Frequency Kill Switch is On:
> +[    2.009427] Kill switch must be turned off for wireless networking to work.
> +[    2.009463] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
> +[    2.009472] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
> +[    2.009483] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
> +[    2.062412] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> +[    2.092856] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
> +[    2.092865] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
> +[    2.092876] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
> +[    2.092900] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 21
> +[    2.115057] eth1: Coming out of suspend...
> +[    2.117263] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 18
> +[    2.237894] ipw2200: Radio Frequency Kill Switch is On:
> +[    2.237897] Kill switch must be turned off for wireless networking to work.
> +[    2.238073] pnp: Device 00:07 does not support activation.
> +[    2.238077] pnp: Device 00:08 does not support activation.
> +[    2.239018] pnp: Device 00:09 activated.
> +[    2.411652] tg3: eth0: Link is up at 100 Mbps, full duplex.
> +[    2.411657] tg3: eth0: Flow control is on for TX and on for RX.
> +[    2.413444] ata1: soft resetting port
> +[    2.413545] ata2: soft resetting port
> +[    2.506309] ata1.00: configured for UDMA/100
> +[    2.506315] ata1: EH complete
> +[    2.506573] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
> +[    2.506590] sda: Write Protect is off
> +[    2.506594] sda: Mode Sense: 00 3a 00 00
> +[    2.506617] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> +[    2.529428] ata2.00: configured for UDMA/33
> +[    2.529434] ata2: EH complete
> +[    2.758683] PM: Writing back config space on device 0000:15:00.0 at offset f (was 100, writing 110)
> +[    2.758715] PM: Writing back config space on device 0000:15:00.0 at offset 4 (was 0, writing b8000000)
> +[    2.758832] hdaps: initial latch check good (0x02).
> +[    2.856420] Restarting tasks ... done.
> +[    2.915161] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
> +[    2.915336] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> +[    2.915343] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> +[    2.916872] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> +[    2.917066] ehci_hcd 0000:00:1d.7: debug port 1
> +[    2.917075] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> +[    2.917244] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xb0004000
> +[    2.921126] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> +[    2.921985] usb usb1: configuration #1 chosen from 1 choice
> +[    2.922288] hub 1-0:1.0: USB hub found
> +[    2.922386] hub 1-0:1.0: 8 ports detected
> +[    3.050006] USB Universal Host Controller Interface driver v3.0
> +[    3.050553] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
> +[    3.050667] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> +[    3.050687] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> +[    3.051194] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> +[    3.051321] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
> +[    3.051816] usb usb2: configuration #1 chosen from 1 choice
> +[    3.051959] hub 2-0:1.0: USB hub found
> +[    3.052052] hub 2-0:1.0: 2 ports detected
> +[    3.154817] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
> +[    3.154999] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> +[    3.155006] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> +[    3.155195] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> +[    3.155317] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001820
> +[    3.155556] usb usb3: configuration #1 chosen from 1 choice
> +[    3.155703] hub 3-0:1.0: USB hub found
> +[    3.155796] hub 3-0:1.0: 2 ports detected
> +[    3.258777] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 21
> +[    3.258968] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> +[    3.258976] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> +[    3.259168] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> +[    3.259288] uhci_hcd 0000:00:1d.2: irq 21, io base 0x00001840
> +[    3.259524] usb usb4: configuration #1 chosen from 1 choice
> +[    3.259674] hub 4-0:1.0: USB hub found
> +[    3.259767] hub 4-0:1.0: 2 ports detected
> +[    1.386347] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 23
> +[    1.386473] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> +[    1.386477] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> +[    1.386568] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> +[    1.386636] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
> +[    1.386752] usb usb5: configuration #1 chosen from 1 choice
> +[    1.386815] hub 5-0:1.0: USB hub found
> +[    1.386859] hub 5-0:1.0: 2 ports detected
> +[    1.670020] usb 4-2: new full speed USB device using uhci_hcd and address 2
> +[    1.844680] usb 4-2: configuration #1 chosen from 1 choice
> +[    3.872750] ADDRCONF(NETDEV_UP): eth0: link is not ready
> +[    9.886105] tg3: eth0: Link is up at 100 Mbps, full duplex.
> +[    9.886112] tg3: eth0: Flow control is on for TX and on for RX.
> +[    9.886134] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> +[   10.474179] ADDRCONF(NETDEV_UP): eth1: link is not ready
> 
> 

