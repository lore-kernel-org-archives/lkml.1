Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZCNHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZCNHlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCNHlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:41:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:56781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZCNHlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:41:39 -0400
Subject: more than 50 percent of dmesg belongs only to PCI and USB
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 13:11:25 +0530
Message-Id: <1237016485.2935.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we make dmesg little bit better and remove some noise and put these
debug messages on /sys/kernel/debug/ :

[    0.103854] ACPI: bus type pci registered
[    0.105836] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
[    0.105914] PCI: Using configuration type 1 for base access
[    0.115329] bio: create slab <bio-0> at 0
[    0.116755] ACPI: EC: Look up EC in DSDT
[    0.126200] ACPI: Interpreter enabled
[    0.126269] ACPI: (supports S0 S5)
[    0.126414] ACPI: Using IOAPIC for interrupt routing
[    0.138473] ACPI: No dock devices found.
[    0.138568] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.138764] pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
[    0.138928] pci 0000:00:1d.0: reg 20 io port: [0xcc00-0xcc1f]
[    0.138991] pci 0000:00:1d.1: reg 20 io port: [0xd000-0xd01f]
[    0.139094] pci 0000:00:1d.2: reg 20 io port: [0xd400-0xd41f]
[    0.139156] pci 0000:00:1d.3: reg 20 io port: [0xd800-0xd81f]
[    0.139226] pci 0000:00:1d.7: reg 10 32bit mmio: [0xffaffc00-0xffafffff]
[    0.139294] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.139368] pci 0000:00:1d.7: PME# disabled
[    0.139535] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[    0.139636] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH4 GPIO
[    0.139732] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.139742] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.139751] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.139760] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.139769] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
[    0.139779] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.139814] pci 0000:00:1f.2: reg 10 io port: [0xec00-0xec07]
[    0.139823] pci 0000:00:1f.2: reg 14 io port: [0xe800-0xe803]
[    0.139832] pci 0000:00:1f.2: reg 18 io port: [0xe400-0xe407]
[    0.139840] pci 0000:00:1f.2: reg 1c io port: [0xe000-0xe003]
[    0.139849] pci 0000:00:1f.2: reg 20 io port: [0xdc00-0xdc0f]
[    0.139917] pci 0000:00:1f.3: reg 20 io port: [0xc800-0xc81f]
[    0.139983] pci 0000:00:1f.5: reg 18 32bit mmio: [0xffaff800-0xffaff9ff]
[    0.139992] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xffaff400-0xffaff4ff]
[    0.140037] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.140110] pci 0000:00:1f.5: PME# disabled
[    0.140224] pci 0000:01:00.0: reg 10 32bit mmio: [0xe0000000-0xefffffff]
[    0.140233] pci 0000:01:00.0: reg 14 io port: [0xa800-0xa8ff]
[    0.140241] pci 0000:01:00.0: reg 18 32bit mmio: [0xff8f0000-0xff8fffff]
[    0.140261] pci 0000:01:00.0: reg 30 32bit mmio: [0xff8c0000-0xff8dffff]
[    0.140287] pci 0000:01:00.0: supports D1 D2
[    0.140332] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    0.140337] pci 0000:00:01.0: bridge 32bit mmio: [0xff800000-0xff8fffff]
[    0.140344] pci 0000:00:01.0: bridge 32bit mmio pref: [0xd6b00000-0xf6afffff]
[    0.140388] pci 0000:02:02.0: reg 10 io port: [0xb800-0xb8ff]
[    0.140398] pci 0000:02:02.0: reg 14 32bit mmio: [0xff9ffc00-0xff9ffcff]
[    0.140427] pci 0000:02:02.0: reg 30 32bit mmio: [0xff9c0000-0xff9dffff]
[    0.140449] pci 0000:02:02.0: supports D1 D2
[    0.140452] pci 0000:02:02.0: PME# supported from D1 D2 D3hot D3cold
[    0.140526] pci 0000:02:02.0: PME# disabled
[    0.140634] pci 0000:00:1e.0: transparent bridge
[    0.140704] pci 0000:00:1e.0: bridge io port: [0xb000-0xbfff]
[    0.140710] pci 0000:00:1e.0: bridge 32bit mmio: [0xff900000-0xff9fffff]
[    0.140729] pci_bus 0000:00: on NUMA node 0
[    0.140738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.140854] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.140931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.145742] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.146474] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.147250] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.148051] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.148791] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.149603] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.150404] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.151218] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.152020] ACPI: Power Resource [URP1] (off)
[    0.152147] ACPI: Power Resource [FDDP] (off)
[    0.152268] ACPI: Power Resource [LPTP] (off)
[    0.153269] usbcore: registered new interface driver usbfs
[    0.153483] usbcore: registered new interface driver hub
[    0.153659] usbcore: registered new device driver usb
[    0.154243] PCI: Using ACPI for IRQ routing
[    0.158190] Warning: could not register annotated branches stats
..
[    0.204832] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.204909] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    0.204982] pci 0000:00:01.0:   MEM window: 0xff800000-0xff8fffff
[    0.205063] pci 0000:00:01.0:   PREFETCH window: 0x000000d6b00000-0x000000f6afffff
[    0.205169] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.205242] pci 0000:00:1e.0:   IO window: 0xb000-0xbfff
[    0.205315] pci 0000:00:1e.0:   MEM window: 0xff900000-0xff9fffff
[    0.205388] pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
[    0.205503] pci 0000:00:1e.0: setting latency timer to 64
[    0.205510] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.205515] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.205519] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    0.205524] pci_bus 0000:01: resource 1 mem: [0xff800000-0xff8fffff]
[    0.205528] pci_bus 0000:01: resource 2 mem: [0xd6b00000-0xf6afffff]
[    0.205532] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.205536] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.205541] pci_bus 0000:02: resource 1 mem: [0xff900000-0xff9fffff]
[    0.205545] pci_bus 0000:02: resource 2 mem: [0x50000000-0x500fffff]
[    0.205549] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.205553] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
..
[    0.377554] pci 0000:01:00.0: Boot video device
[    0.378073] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.378144] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
--
[    0.400711] Linux agpgart interface v0.103
[    0.400905] agpgart-intel 0000:00:00.0: Intel 865 Chipset
[    0.404237] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    0.404489] [drm] Initialized drm 1.1.0 20060810
[    0.405120] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
..
[    0.658184] Linux video capture interface: v2.00
[    0.658324] gspca: main v2.4.0 registered
[    0.658473] usbcore: registered new interface driver ov519
[    0.658546] ov519: registered
..
[    3.028606] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.028716] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.028810] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.028817] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.028998] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.033030] ehci_hcd 0000:00:1d.7: debug port 1
[    3.033104] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[    3.033126] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffaffc00
[    3.043014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.043286] usb usb1: configuration #1 chosen from 1 choice
[    3.043468] hub 1-0:1.0: USB hub found
[    3.043547] hub 1-0:1.0: 8 ports detected
[    3.044130] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.044290] uhci_hcd: USB Universal Host Controller Interface driver
[    3.044408] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.044487] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.044492] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.044653] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.044784] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000cc00
[    3.045057] usb usb2: configuration #1 chosen from 1 choice
[    3.045234] hub 2-0:1.0: USB hub found
[    3.045316] hub 2-0:1.0: 2 ports detected
[    3.045729] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.045808] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.045813] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.045972] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.046115] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d000
[    3.046382] usb usb3: configuration #1 chosen from 1 choice
[    3.046557] hub 3-0:1.0: USB hub found
[    3.046635] hub 3-0:1.0: 2 ports detected
[    3.047066] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.047144] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.047150] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.047327] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.047456] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d400
[    3.047707] usb usb4: configuration #1 chosen from 1 choice
[    3.047885] hub 4-0:1.0: USB hub found
[    3.047963] hub 4-0:1.0: 2 ports detected
[    3.048382] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.048463] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.048468] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.048630] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.048751] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d800
[    3.049050] usb usb5: configuration #1 chosen from 1 choice
[    3.049228] hub 5-0:1.0: USB hub found
[    3.049309] hub 5-0:1.0: 2 ports detected
[    3.049903] usbcore: registered new interface driver libusual
..
[    3.099272] usbcore: registered new interface driver hiddev
[    3.099427] usbcore: registered new interface driver usbhid
[    3.099502] usbhid: v2.6:USB HID core driver

Thanks,
--
JSR

