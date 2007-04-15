Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXDOTPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXDOTPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXDOTPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:15:02 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:4857 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbXDOTO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:14:58 -0400
Date: Sun, 15 Apr 2007 20:50:00 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dtor@insightbb.com>, pavel@suse.cz,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070415184959.GA26517@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Dmitry Torokhov <dtor@insightbb.com>, pavel@suse.cz,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151316.26136.rjw@sisk.pl> <200704151019.37074.dtor@insightbb.com> <200704151753.00584.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200704151753.00584.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 15 April 2007 16:19, Dmitry Torokhov wrote:
> > On Sunday 15 April 2007 07:16, Rafael J. Wysocki wrote:
> > > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > > 
> > > > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > > > This is kinda interesting because I'm normally using a USB keyboard
> > > > > and sure enough, if I hook up a normal keyboard and disable USB
> > > > > legacy support in the BIOS, then suspend to disk works multiple
> > > > > times. I'd still rather like to use my USB keyboard though. ;)
> > > 
> > > Well, I think that when you're using the USB keyboard and the USB legacy
> > > support, the i8042 driver thinks it has a keyboard to handle and tries to
> > > handle it during the suspend, which fails.  I don't know why it fails during
> > > the second suspend, though.
> > > 
> > > Dmitry, could you please have a look?
> > > 
> > 
> > This is wierd as i8042 does not use suspend_late/resume_early hooks and
> > so it is impossible for it to hang there. None of input drivers use these
> > hooks. Could it be that some other driver _after_ i8042 hangs?
> 
> Yes.
> 
> Tobias, can you please post the dmesg output from after a successful
> suspend/resume cycle with CONFIG_PM_DEBUG=y in the 'platform' mode?

Here you go:

[    0.000000] Linux version 2.6.21-rc6 (ranma@melchior) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #16 PREEMPT Sun Apr 15 09:39:32 CEST 2007
[    0.000000] Command line: root=/dev/sda5 resume=/dev/sda6 vga=6 apic=verbose ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261856) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7B80, 0024 (r2 Nvidia)
[    0.000000] ACPI: XSDT 3FEE30C0, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FEEC540, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FEE3240, 92AD (r1 NVIDIA AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS 3FEE0000, 0040
[    0.000000] ACPI: SSDT 3FEEC740, 00F4 (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET 3FEEC880, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG 3FEEC900, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3FEEC680, 007C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261856) 1 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   261856
[    0.000000] On node 0 totalpages: 261759
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1609 pages reserved
[    0.000000]   DMA zone: 2334 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3524 pages used for memmap
[    0.000000]   DMA32 zone: 254236 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffffffff5fd000 (        fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fc000 (00000000fec00000)
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000f0000
[    0.000000] Nosave address range: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3ff00000:b0100000)
[    0.000000] Built 1 zonelists.  Total pages: 256570
[    0.000000] Kernel command line: root=/dev/sda5 resume=/dev/sda6 vga=6 apic=verbose ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[   27.123582] time.c: Detected 2009.259 MHz processor.
[   27.129015] Console: colour VGA+ 80x60
[   27.132450] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   27.133272] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   27.133524] Checking aperture...
[   27.133631] CPU 0: aperture @ b0ca000000 size 32 MB
[   27.133738] Aperture too small (32 MB)
[   27.138530] No AGP bridge found
[   27.146414] Memory: 1024344k/1047424k available (4046k kernel code, 22448k reserved, 1571k data, 208k init)
[   27.227018] Calibrating delay using timer specific routine.. 4022.53 BogoMIPS (lpj=6701652)
[   27.227270] Mount-cache hash table entries: 256
[   27.227455] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   27.227563] CPU: L2 Cache: 512K (64 bytes/line)
[   27.227678] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 02
[   27.227830] ACPI: Core revision 20070126
[   27.233669] enabled ExtINT on CPU#0
[   27.233783] ESR value after enabling vector: 00000000, after 00000004
[   27.234118] ENABLING IO-APIC IRQs
[   27.234224] init IO_APIC IRQs
[   27.234226]  IO-APIC (apicid-pin) 2-0<7>IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[   27.234237] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[   27.234244] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[   27.234251] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[   27.234258] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[   27.234265] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[   27.234272] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[   27.234278] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[   27.234285] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[   27.234293] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[   27.234300] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[   27.234307] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[   27.234314] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[   27.234321] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[   27.234328] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[   27.234334] , 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   27.234730] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[   27.267820] Using local APIC timer interrupts.
[   27.317634] result 12557883
[   27.317740] Detected 12.557 MHz APIC timer.
[   27.320260] PM: Adding info for No Bus:platform
[   27.320335] NET: Registered protocol family 16
[   27.320470] PM: Adding info for No Bus:vtcon0
[   27.320513] ACPI: bus type pci registered
[   27.321307] PCI: Using MMCONFIG at f0000000 - f3ffffff
[   27.321431] PCI: No mmconfig possible on device 00:18
[   27.329056] ACPI: Interpreter enabled
[   27.329166] ACPI: (supports S0 S1 S3 S4 S5)
[   27.329406] ACPI: Using IOAPIC for interrupt routing
[   27.329599] PM: Adding info for acpi:acpi_system:00
[   27.329643] PM: Adding info for acpi:button_power:00
[   27.329677] PM: Adding info for acpi:ACPI0007:00
[   27.329707] PM: Adding info for acpi:ACPI0007:01
[   27.329750] PM: Adding info for acpi:device:00
[   27.329888] PM: Adding info for acpi:PNP0C0C:00
[   27.330089] PM: Adding info for acpi:PNP0A08:00
[   27.330127] PM: Adding info for acpi:PNP0C02:00
[   27.330272] PM: Adding info for acpi:device:01
[   27.330314] PM: Adding info for acpi:device:02
[   27.330349] PM: Adding info for acpi:device:03
[   27.330385] PM: Adding info for acpi:device:04
[   27.330422] PM: Adding info for acpi:device:05
[   27.330456] PM: Adding info for acpi:device:06
[   27.330493] PM: Adding info for acpi:device:07
[   27.330528] PM: Adding info for acpi:device:08
[   27.330564] PM: Adding info for acpi:device:09
[   27.330600] PM: Adding info for acpi:device:0a
[   27.330635] PM: Adding info for acpi:device:0b
[   27.330674] PM: Adding info for acpi:device:0c
[   27.330709] PM: Adding info for acpi:device:0d
[   27.330744] PM: Adding info for acpi:device:0e
[   27.330780] PM: Adding info for acpi:device:0f
[   27.330816] PM: Adding info for acpi:device:10
[   27.330857] PM: Adding info for acpi:device:11
[   27.330894] PM: Adding info for acpi:device:12
[   27.330930] PM: Adding info for acpi:device:13
[   27.330966] PM: Adding info for acpi:device:14
[   27.331002] PM: Adding info for acpi:device:15
[   27.331037] PM: Adding info for acpi:device:16
[   27.331075] PM: Adding info for acpi:device:17
[   27.331113] PM: Adding info for acpi:device:18
[   27.331155] PM: Adding info for acpi:device:19
[   27.331200] PM: Adding info for acpi:device:1a
[   27.331241] PM: Adding info for acpi:device:1b
[   27.331283] PM: Adding info for acpi:device:1c
[   27.331326] PM: Adding info for acpi:device:1d
[   27.331368] PM: Adding info for acpi:device:1e
[   27.331412] PM: Adding info for acpi:device:1f
[   27.331456] PM: Adding info for acpi:device:20
[   27.331496] PM: Adding info for acpi:device:21
[   27.331540] PM: Adding info for acpi:device:22
[   27.331584] PM: Adding info for acpi:device:23
[   27.331627] PM: Adding info for acpi:device:24
[   27.331671] PM: Adding info for acpi:device:25
[   27.331714] PM: Adding info for acpi:device:26
[   27.331756] PM: Adding info for acpi:device:27
[   27.331800] PM: Adding info for acpi:device:28
[   27.331842] PM: Adding info for acpi:device:29
[   27.331883] PM: Adding info for acpi:device:2a
[   27.331925] PM: Adding info for acpi:device:2b
[   27.331964] PM: Adding info for acpi:PNP0C02:01
[   27.332001] PM: Adding info for acpi:PNP0000:00
[   27.332037] PM: Adding info for acpi:PNP0200:00
[   27.332075] PM: Adding info for acpi:PNP0100:00
[   27.332273] PM: Adding info for acpi:PNP0103:00
[   27.332311] PM: Adding info for acpi:PNP0B00:00
[   27.332350] PM: Adding info for acpi:PNP0800:00
[   27.332389] PM: Adding info for acpi:PNP0C04:00
[   27.333170] PM: Adding info for acpi:PNP0501:00
[   27.334233] PM: Adding info for acpi:PNP0303:00
[   27.334457] PM: Adding info for acpi:device:2c
[   27.334603] PM: Adding info for acpi:device:2d
[   27.334647] PM: Adding info for acpi:device:2e
[   27.334691] PM: Adding info for acpi:device:2f
[   27.334736] PM: Adding info for acpi:device:30
[   27.334849] PM: Adding info for acpi:ATK0110:00
[   27.335028] PM: Adding info for acpi:PNP0C0F:00
[   27.335189] PM: Adding info for acpi:PNP0C0F:01
[   27.335348] PM: Adding info for acpi:PNP0C0F:02
[   27.335511] PM: Adding info for acpi:PNP0C0F:03
[   27.335671] PM: Adding info for acpi:PNP0C0F:04
[   27.335832] PM: Adding info for acpi:PNP0C0F:05
[   27.335992] PM: Adding info for acpi:PNP0C0F:06
[   27.336153] PM: Adding info for acpi:PNP0C0F:07
[   27.336317] PM: Adding info for acpi:PNP0C0F:08
[   27.336477] PM: Adding info for acpi:PNP0C0F:09
[   27.336638] PM: Adding info for acpi:PNP0C0F:0a
[   27.336799] PM: Adding info for acpi:PNP0C0F:0b
[   27.336982] PM: Adding info for acpi:PNP0C0F:0c
[   27.337144] PM: Adding info for acpi:PNP0C0F:0d
[   27.337305] PM: Adding info for acpi:PNP0C0F:0e
[   27.337470] PM: Adding info for acpi:PNP0C0F:0f
[   27.337632] PM: Adding info for acpi:PNP0C0F:10
[   27.337794] PM: Adding info for acpi:PNP0C0F:11
[   27.337957] PM: Adding info for acpi:PNP0C0F:12
[   27.338122] PM: Adding info for acpi:PNP0C0F:13
[   27.338298] PM: Adding info for acpi:PNP0C0F:14
[   27.338473] PM: Adding info for acpi:PNP0C0F:15
[   27.338648] PM: Adding info for acpi:PNP0C0F:16
[   27.338824] PM: Adding info for acpi:PNP0C0F:17
[   27.338998] PM: Adding info for acpi:PNP0C0F:18
[   27.339174] PM: Adding info for acpi:PNP0C0F:19
[   27.339351] PM: Adding info for acpi:PNP0C0F:1a
[   27.339527] PM: Adding info for acpi:PNP0C0F:1b
[   27.339701] PM: Adding info for acpi:PNP0C0F:1c
[   27.339878] PM: Adding info for acpi:PNP0C0F:1d
[   27.340053] PM: Adding info for acpi:PNP0C0F:1e
[   27.340250] PM: Adding info for acpi:PNP0C0F:1f
[   27.340426] PM: Adding info for acpi:PNP0C0F:20
[   27.340605] PM: Adding info for acpi:PNP0C0F:21
[   27.340780] PM: Adding info for acpi:PNP0C0F:22
[   27.340956] PM: Adding info for acpi:PNP0C0F:23
[   27.341135] PM: Adding info for acpi:PNP0C0F:24
[   27.341311] PM: Adding info for acpi:PNP0C0F:25
[   27.341488] PM: Adding info for acpi:PNP0C0F:26
[   27.341667] PM: Adding info for acpi:PNP0C0F:27
[   27.341713] PM: Adding info for acpi:PNP0C02:02
[   27.341759] PM: Adding info for acpi:PNP0C01:00
[   27.341798] PM: Adding info for acpi:thermal:00
[   27.341839] PM: Adding info for acpi:PNP0C0B:00
[   27.341873] PM: Adding info for acpi:thermal:01
[   27.342039] PM: Adding info for acpi:AWY0001:00
[   27.342160] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   27.342277] PCI: Probing PCI hardware (bus 00)
[   27.342286] PM: Adding info for No Bus:pci0000:00
[   27.342495] 0000:00:04.0: cannot adjust BAR0 (not I/O)
[   27.342602] 0000:00:04.0: cannot adjust BAR1 (not I/O)
[   27.342709] 0000:00:04.0: cannot adjust BAR2 (not I/O)
[   27.342815] 0000:00:04.0: cannot adjust BAR3 (not I/O)
[   27.343123] PCI: Firmware left 0000:01:07.0 e100 interrupts enabled, disabling
[   27.343425] PCI: Transparent bridge - 0000:00:06.0
[   27.344025] Boot video device is 0000:07:00.0
[   27.344105] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   27.344517] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   27.347888] PM: Adding info for pci:0000:00:00.0
[   27.351008] PM: Adding info for pci:0000:00:01.0
[   27.354090] PM: Adding info for pci:0000:00:01.1
[   27.357163] PM: Adding info for pci:0000:00:01.2
[   27.360277] PM: Adding info for pci:0000:00:02.0
[   27.363349] PM: Adding info for pci:0000:00:02.1
[   27.366413] PM: Adding info for pci:0000:00:04.0
[   27.369528] PM: Adding info for pci:0000:00:06.0
[   27.372590] PM: Adding info for pci:0000:00:06.1
[   27.375664] PM: Adding info for pci:0000:00:08.0
[   27.378777] PM: Adding info for pci:0000:00:09.0
[   27.381841] PM: Adding info for pci:0000:00:0a.0
[   27.384915] PM: Adding info for pci:0000:00:0b.0
[   27.388019] PM: Adding info for pci:0000:00:0c.0
[   27.391095] PM: Adding info for pci:0000:00:0d.0
[   27.394201] PM: Adding info for pci:0000:00:0e.0
[   27.397278] PM: Adding info for pci:0000:00:0f.0
[   27.400393] PM: Adding info for pci:0000:00:18.0
[   27.403486] PM: Adding info for pci:0000:00:18.1
[   27.406561] PM: Adding info for pci:0000:00:18.2
[   27.409677] PM: Adding info for pci:0000:00:18.3
[   27.409712] PM: Adding info for pci:0000:01:07.0
[   27.409745] PM: Adding info for pci:0000:01:08.0
[   27.409778] PM: Adding info for pci:0000:01:08.1
[   27.409810] PM: Adding info for pci:0000:01:0b.0
[   27.409846] PM: Adding info for pci:0000:06:00.0
[   27.409880] PM: Adding info for pci:0000:06:00.1
[   27.409913] PM: Adding info for pci:0000:07:00.0
[   27.409944] PM: Adding info for pci:0000:07:00.1
[   27.410210] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.410855] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
[   27.411370] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 *7 9 10 11 14 15)
[   27.411884] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.412521] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.413160] ACPI: PCI Interrupt Link [LNK6] (IRQs *5 7 9 10 11 14 15)
[   27.413685] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
[   27.414200] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.414838] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.415476] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
[   27.415990] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
[   27.416505] ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 *10 11 14 15)
[   27.417023] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[   27.417541] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.418180] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
[   27.418699] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 *7 9 10 11 14 15)
[   27.419217] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.419855] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.420496] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.421134] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   27.421812] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   27.422278] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[   27.422724] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[   27.423167] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   27.423634] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[   27.424098] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
[   27.424542] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[   27.424986] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[   27.425450] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[   27.425955] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[   27.426460] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0
[   27.426967] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[   27.427492] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[   27.427997] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[   27.428502] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[   27.429007] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[   27.429532] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[   27.430057] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[   27.430586] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[   27.431111] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0, disabled.
[   27.431488] Linux Plug and Play Support v0.97 (c) Adam Belay
[   27.431601] pnp: PnP ACPI init
[   27.431712] PM: Adding info for No Bus:pnp0
[   27.432404] PM: Adding info for pnp:00:00
[   27.432498] PM: Adding info for pnp:00:01
[   27.432640] PM: Adding info for pnp:00:02
[   27.432674] PM: Adding info for pnp:00:03
[   27.432842] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[   27.432857] PM: Adding info for pnp:00:04
[   27.432959] PM: Adding info for pnp:00:05
[   27.432993] PM: Adding info for pnp:00:06
[   27.433021] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[   27.433032] PM: Adding info for pnp:00:07
[   27.433816] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[   27.433836] PM: Adding info for pnp:00:08
[   27.434724] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[   27.434735] PM: Adding info for pnp:00:09
[   27.437439] PM: Adding info for pnp:00:0a
[   27.437621] PM: Adding info for pnp:00:0b
[   27.437713] pnp: PnP ACPI: found 12 devices
[   27.437927] SCSI subsystem initialized
[   27.438057] libata version 2.20 loaded.
[   27.438104] usbcore: registered new interface driver usbfs
[   27.438238] usbcore: registered new interface driver hub
[   27.438370] usbcore: registered new device driver usb
[   27.438525] PCI: Using ACPI for IRQ routing
[   27.438634] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   27.438826] number of MP IRQ sources: 15.
[   27.438828] number of IO-APIC #2 registers: 24.
[   27.438830] testing the IO APIC.......................
[   27.438941] 
[   27.439046] IO APIC #2......
[   27.439048] .... register #00: 02000000
[   27.439050] .......    : physical APIC id: 02
[   27.439052] .... register #01: 00170011
[   27.439054] .......     : max redirection entries: 0017
[   27.439056] .......     : PRQ implemented: 0
[   27.439058] .......     : IO APIC version: 0011
[   27.439060] .... register #02: 02000000
[   27.439061] .......     : arbitration: 02
[   27.439063] .... IRQ redirection table:
[   27.439065]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[   27.439070]  00 000 1    0    0   0   0    0    0    00
[   27.439077]  01 001 0    0    0   0   0    1    1    31
[   27.439083]  02 001 0    0    0   0   0    1    1    30
[   27.439090]  03 001 0    0    0   0   0    1    1    33
[   27.439096]  04 001 0    0    0   0   0    1    1    34
[   27.439102]  05 001 1    0    0   0   0    1    1    35
[   27.439109]  06 001 0    0    0   0   0    1    1    36
[   27.439115]  07 001 1    0    0   0   0    1    1    37
[   27.439121]  08 001 0    0    0   0   0    1    1    38
[   27.439128]  09 001 0    1    0   0   0    1    1    39
[   27.439134]  0a 001 1    0    0   0   0    1    1    3A
[   27.439141]  0b 001 1    0    0   0   0    1    1    3B
[   27.439147]  0c 001 0    0    0   0   0    1    1    3C
[   27.439153]  0d 001 0    0    0   0   0    1    1    3D
[   27.439160]  0e 001 0    0    0   0   0    1    1    3E
[   27.439166]  0f 001 0    0    0   0   0    1    1    3F
[   27.439173]  10 000 1    0    0   0   0    0    0    00
[   27.439179]  11 000 1    0    0   0   0    0    0    00
[   27.439185]  12 000 1    0    0   0   0    0    0    00
[   27.439191]  13 000 1    0    0   0   0    0    0    00
[   27.439198]  14 000 1    0    0   0   0    0    0    00
[   27.439204]  15 000 1    0    0   0   0    0    0    00
[   27.439210]  16 000 1    0    0   0   0    0    0    00
[   27.439216]  17 000 1    0    0   0   0    0    0    00
[   27.439219] IRQ to pin mappings:
[   27.439221] IRQ0 -> 0:2
[   27.439223] IRQ1 -> 0:1
[   27.439225] IRQ3 -> 0:3
[   27.439227] IRQ4 -> 0:4
[   27.439229] IRQ5 -> 0:5
[   27.439231] IRQ6 -> 0:6
[   27.439233] IRQ7 -> 0:7
[   27.439235] IRQ8 -> 0:8
[   27.439236] IRQ9 -> 0:9
[   27.439238] IRQ10 -> 0:10
[   27.439241] IRQ11 -> 0:11
[   27.439243] IRQ12 -> 0:12
[   27.439245] IRQ13 -> 0:13
[   27.439247] IRQ14 -> 0:14
[   27.439249] IRQ15 -> 0:15
[   27.439252] .................................... done.
[   27.536630] Bluetooth: Core ver 2.11
[   27.536743] PM: Adding info for platform:bluetooth
[   27.536771] NET: Registered protocol family 31
[   27.536878] Bluetooth: HCI device and connection manager initialized
[   27.536986] Bluetooth: HCI socket layer initialized
[   27.537139] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[   27.537327] hpet0: 3 32-bit timers, 25000000 Hz
[   27.538469] pnp: 00:01: ioport range 0x1000-0x107f has been reserved
[   27.538577] pnp: 00:01: ioport range 0x1080-0x10ff has been reserved
[   27.538686] pnp: 00:01: ioport range 0x1400-0x147f has been reserved
[   27.538794] pnp: 00:01: ioport range 0x1480-0x14ff has been reserved
[   27.538901] pnp: 00:01: ioport range 0x1800-0x187f has been reserved
[   27.539009] pnp: 00:01: ioport range 0x1880-0x18ff has been reserved
[   27.539125] pnp: 00:0a: iomem range 0xf0000000-0xf3ffffff could not be reserved
[   27.539319] pnp: 00:0b: iomem range 0xf0000-0xf3fff could not be reserved
[   27.539427] pnp: 00:0b: iomem range 0xf4000-0xf7fff could not be reserved
[   27.539535] pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
[   27.539644] pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
[   27.539762] PM: Adding info for No Bus:mem
[   27.539787] PM: Adding info for No Bus:kmem
[   27.539809] PM: Adding info for No Bus:null
[   27.539830] PM: Adding info for No Bus:port
[   27.539851] PM: Adding info for No Bus:zero
[   27.539874] PM: Adding info for No Bus:full
[   27.539895] PM: Adding info for No Bus:random
[   27.539919] PM: Adding info for No Bus:urandom
[   27.539943] PM: Adding info for No Bus:kmsg
[   27.539952] Time: tsc clocksource has been installed.
[   27.540097] PCI: Bridge: 0000:00:06.0
[   27.540204]   IO window: d000-dfff
[   27.540311]   MEM window: fdc00000-fdefffff
[   27.540418]   PREFETCH window: 40000000-400fffff
[   27.540526] PCI: Bridge: 0000:00:0a.0
[   27.540631]   IO window: disabled.
[   27.546605]   MEM window: disabled.
[   27.546719]   PREFETCH window: disabled.
[   27.546826] PCI: Bridge: 0000:00:0b.0
[   27.546932]   IO window: disabled.
[   27.547038]   MEM window: disabled.
[   27.547144]   PREFETCH window: disabled.
[   27.547251] PCI: Bridge: 0000:00:0c.0
[   27.547356]   IO window: disabled.
[   27.547462]   MEM window: disabled.
[   27.547568]   PREFETCH window: disabled.
[   27.547675] PCI: Bridge: 0000:00:0d.0
[   27.547781]   IO window: disabled.
[   27.547887]   MEM window: disabled.
[   27.547993]   PREFETCH window: disabled.
[   27.548100] PCI: Bridge: 0000:00:0e.0
[   27.548207]   IO window: b000-cfff
[   27.548314]   MEM window: fdb00000-fdbfffff
[   27.548420]   PREFETCH window: disabled.
[   27.548527] PCI: Bridge: 0000:00:0f.0
[   27.548633]   IO window: a000-afff
[   27.548740]   MEM window: fda00000-fdafffff
[   27.548847]   PREFETCH window: e8000000-efffffff
[   27.548959] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   27.548965] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   27.548970] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   27.548975] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   27.548979] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   27.548984] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   27.548989] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   27.549010] NET: Registered protocol family 2
[   27.579924] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   27.580217] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   27.581250] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   27.581605] TCP: Hash tables configured (established 131072 bind 65536)
[   27.581713] TCP reno registered
[   27.590063] PM: Adding info for No Bus:mcelog
[   27.590233] PM: Adding info for platform:pcspkr
[   27.590344] PM: Adding info for No Bus:snapshot
[   27.590574] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   27.590858] JFFS2 version 2.2. (NAND) (C) 2001-2006 Red Hat, Inc.
[   27.591012] fuse init (API version 7.8)
[   27.591135] PM: Adding info for No Bus:fuse
[   27.591169] SGI XFS with large block/inode numbers, no debug enabled
[   27.591403] io scheduler noop registered
[   27.591510] io scheduler anticipatory registered
[   27.591616] io scheduler deadline registered
[   27.591733] io scheduler cfq registered (default)
[   27.613372] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   27.613385] assign_interrupt_mode Found MSI capability
[   27.613509] Allocate Port Service[0000:00:0a.0:pcie00]
[   27.613515] PM: Adding info for pci_express:0000:00:0a.0:pcie00
[   27.613538] Allocate Port Service[0000:00:0a.0:pcie03]
[   27.613543] PM: Adding info for pci_express:0000:00:0a.0:pcie03
[   27.613578] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   27.613591] assign_interrupt_mode Found MSI capability
[   27.613706] Allocate Port Service[0000:00:0b.0:pcie00]
[   27.613711] PM: Adding info for pci_express:0000:00:0b.0:pcie00
[   27.613733] Allocate Port Service[0000:00:0b.0:pcie03]
[   27.613740] PM: Adding info for pci_express:0000:00:0b.0:pcie03
[   27.613774] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   27.613787] assign_interrupt_mode Found MSI capability
[   27.613902] Allocate Port Service[0000:00:0c.0:pcie00]
[   27.613907] PM: Adding info for pci_express:0000:00:0c.0:pcie00
[   27.613929] Allocate Port Service[0000:00:0c.0:pcie03]
[   27.613934] PM: Adding info for pci_express:0000:00:0c.0:pcie03
[   27.613968] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   27.613981] assign_interrupt_mode Found MSI capability
[   27.614096] Allocate Port Service[0000:00:0d.0:pcie00]
[   27.614101] PM: Adding info for pci_express:0000:00:0d.0:pcie00
[   27.614125] Allocate Port Service[0000:00:0d.0:pcie03]
[   27.614130] PM: Adding info for pci_express:0000:00:0d.0:pcie03
[   27.614164] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   27.614177] assign_interrupt_mode Found MSI capability
[   27.614292] Allocate Port Service[0000:00:0e.0:pcie00]
[   27.614297] PM: Adding info for pci_express:0000:00:0e.0:pcie00
[   27.614318] Allocate Port Service[0000:00:0e.0:pcie03]
[   27.614323] PM: Adding info for pci_express:0000:00:0e.0:pcie03
[   27.614358] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   27.614371] assign_interrupt_mode Found MSI capability
[   27.614486] Allocate Port Service[0000:00:0f.0:pcie00]
[   27.614494] PM: Adding info for pci_express:0000:00:0f.0:pcie00
[   27.614515] Allocate Port Service[0000:00:0f.0:pcie03]
[   27.614520] PM: Adding info for pci_express:0000:00:0f.0:pcie03
[   27.614621] PM: Adding info for platform:vesafb.0
[   27.614736] input: Power Button (FF) as /class/input/input0
[   27.614843] ACPI: Power Button (FF) [PWRF]
[   27.615009] input: Power Button (CM) as /class/input/input1
[   27.615117] ACPI: Power Button (CM) [PWRB]
[   27.615293] ACPI: Fan [FAN] (on)
[   27.616436] ACPI: Thermal Zone [THRM] (40 C)
[   27.616577] PM: Adding info for No Bus:tty
[   27.616604] PM: Adding info for No Bus:console
[   27.616627] PM: Adding info for No Bus:ptmx
[   27.616652] PM: Adding info for No Bus:tty0
[   27.616681] PM: Adding info for No Bus:vcs
[   27.616704] PM: Adding info for No Bus:vcsa
[   27.616732] PM: Adding info for No Bus:tty1
[   27.616754] PM: Adding info for No Bus:tty2
[   27.616776] PM: Adding info for No Bus:tty3
[   27.616801] PM: Adding info for No Bus:tty4
[   27.616824] PM: Adding info for No Bus:tty5
[   27.616847] PM: Adding info for No Bus:tty6
[   27.616870] PM: Adding info for No Bus:tty7
[   27.616894] PM: Adding info for No Bus:tty8
[   27.616917] PM: Adding info for No Bus:tty9
[   27.616941] PM: Adding info for No Bus:tty10
[   27.616967] PM: Adding info for No Bus:tty11
[   27.616990] PM: Adding info for No Bus:tty12
[   27.617014] PM: Adding info for No Bus:tty13
[   27.617037] PM: Adding info for No Bus:tty14
[   27.617062] PM: Adding info for No Bus:tty15
[   27.617086] PM: Adding info for No Bus:tty16
[   27.617110] PM: Adding info for No Bus:tty17
[   27.617137] PM: Adding info for No Bus:tty18
[   27.617161] PM: Adding info for No Bus:tty19
[   27.617185] PM: Adding info for No Bus:tty20
[   27.617209] PM: Adding info for No Bus:tty21
[   27.617235] PM: Adding info for No Bus:tty22
[   27.617258] PM: Adding info for No Bus:tty23
[   27.617283] PM: Adding info for No Bus:tty24
[   27.617309] PM: Adding info for No Bus:tty25
[   27.617333] PM: Adding info for No Bus:tty26
[   27.617358] PM: Adding info for No Bus:tty27
[   27.617382] PM: Adding info for No Bus:tty28
[   27.617411] PM: Adding info for No Bus:tty29
[   27.617435] PM: Adding info for No Bus:tty30
[   27.617460] PM: Adding info for No Bus:tty31
[   27.617488] PM: Adding info for No Bus:tty32
[   27.617514] PM: Adding info for No Bus:tty33
[   27.617540] PM: Adding info for No Bus:tty34
[   27.617564] PM: Adding info for No Bus:tty35
[   27.617592] PM: Adding info for No Bus:tty36
[   27.617618] PM: Adding info for No Bus:tty37
[   27.617643] PM: Adding info for No Bus:tty38
[   27.617670] PM: Adding info for No Bus:tty39
[   27.617696] PM: Adding info for No Bus:tty40
[   27.617722] PM: Adding info for No Bus:tty41
[   27.617747] PM: Adding info for No Bus:tty42
[   27.617775] PM: Adding info for No Bus:tty43
[   27.617801] PM: Adding info for No Bus:tty44
[   27.617827] PM: Adding info for No Bus:tty45
[   27.617855] PM: Adding info for No Bus:tty46
[   27.617881] PM: Adding info for No Bus:tty47
[   27.617908] PM: Adding info for No Bus:tty48
[   27.617934] PM: Adding info for No Bus:tty49
[   27.617962] PM: Adding info for No Bus:tty50
[   27.617988] PM: Adding info for No Bus:tty51
[   27.618015] PM: Adding info for No Bus:tty52
[   27.618043] PM: Adding info for No Bus:tty53
[   27.618069] PM: Adding info for No Bus:tty54
[   27.618096] PM: Adding info for No Bus:tty55
[   27.618122] PM: Adding info for No Bus:tty56
[   27.618151] PM: Adding info for No Bus:tty57
[   27.618179] PM: Adding info for No Bus:tty58
[   27.618206] PM: Adding info for No Bus:tty59
[   27.618235] PM: Adding info for No Bus:tty60
[   27.618263] PM: Adding info for No Bus:tty61
[   27.618289] PM: Adding info for No Bus:tty62
[   27.618316] PM: Adding info for No Bus:tty63
[   27.618393] PM: Adding info for No Bus:rtc
[   27.618422] Real Time Clock Driver v1.12ac
[   27.618535] PM: Adding info for No Bus:hpet
[   27.618704] hpet_resources: 0xfefff000 is busy
[   27.618724] Linux agpgart interface v0.102 (c) Dave Jones
[   27.619037] loop: loaded (max 8 devices)
[   27.619144] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
[   27.619251] e100: Copyright(c) 1999-2006 Intel Corporation
[   27.619787] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   27.619913] IOAPIC[0]: Set routing entry (2-17 -> 0x79 -> IRQ 17 Mode:1 Active:1)
[   27.619920] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
[   27.639126] PM: Adding info for No Bus:eth0
[   27.639169] e100: eth0: e100_probe: addr 0xfdeff000, irq 17, MAC addr 00:02:B3:1C:8B:4F
[   27.639399] PM: Adding info for No Bus:lo
[   27.639427] tun: Universal TUN/TAP device driver, 1.6
[   27.639534] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   27.639647] PM: Adding info for No Bus:tun
[   27.639772] ahci 0000:06:00.0: version 2.1
[   27.640163] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   27.640272] IOAPIC[0]: Set routing entry (2-16 -> 0x81 -> IRQ 16 Mode:1 Active:1)
[   27.640278] ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
[   28.641915] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   28.641922] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   28.642115] ahci 0000:06:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   28.642336] ata1: SATA max UDMA/133 cmd 0xffffc20000070100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
[   28.642617] ata2: SATA max UDMA/133 cmd 0xffffc20000070180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
[   28.642818] scsi0 : ahci
[   28.642935] PM: Adding info for No Bus:host0
[   28.954838] ata1: SATA link down (SStatus 0 SControl 300)
[   28.954953] scsi1 : ahci
[   28.955061] PM: Adding info for No Bus:host1
[   29.434243] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   29.437236] ata2.00: ATA-7: SAMSUNG SP2504C, VT100-41, max UDMA7
[   29.437344] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   29.464325] ata2.00: configured for UDMA/133
[   29.464439] PM: Adding info for No Bus:target1:0:0
[   29.464500] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
[   29.464697] PM: Adding info for scsi:1:0:0:0
[   29.464764] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   29.464878] sda: Write Protect is off
[   29.464984] sda: Mode Sense: 00 3a 00 00
[   29.464996] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.465219] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   29.465332] sda: Write Protect is off
[   29.465438] sda: Mode Sense: 00 3a 00 00
[   29.465449] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.465642]  sda: sda1 sda2 sda4 < sda5 sda6 >
[   29.501779] sd 1:0:0:0: Attached scsi disk sda
[   29.501928] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   29.502115] block2mtd: version $Revision: 1.30 $
[   29.502299] PM: Adding info for No Bus:kvm
[   29.502776] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
[   29.502886] IOAPIC[0]: Set routing entry (2-23 -> 0x89 -> IRQ 23 Mode:1 Active:1)
[   29.502893] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   29.503134] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   29.503137] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   29.503283] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   29.503500] ehci_hcd 0000:00:02.1: debug port 1
[   29.503608] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   29.503617] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe02e000
[   29.503728] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   29.503937] PM: Adding info for usb:usb1
[   29.503990] PM: Adding info for No Bus:usbdev1.1_ep00
[   29.504016] usb usb1: configuration #1 chosen from 1 choice
[   29.504131] PM: Adding info for usb:1-0:1.0
[   29.504168] hub 1-0:1.0: USB hub found
[   29.504280] hub 1-0:1.0: 10 ports detected
[   29.607357] PM: Adding info for No Bus:usbdev1.1_ep81
[   29.607388] PM: Adding info for No Bus:usbdev1.1
[   29.607428] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   29.607833] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[   29.607942] IOAPIC[0]: Set routing entry (2-22 -> 0x91 -> IRQ 22 Mode:1 Active:1)
[   29.607948] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   29.608186] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   29.608188] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   29.608324] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   29.608527] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[   29.662626] PM: Adding info for usb:usb2
[   29.662667] PM: Adding info for No Bus:usbdev2.1_ep00
[   29.662689] usb usb2: configuration #1 chosen from 1 choice
[   29.662802] PM: Adding info for usb:2-0:1.0
[   29.662825] hub 2-0:1.0: USB hub found
[   29.662938] hub 2-0:1.0: 10 ports detected
[   29.763821] PM: Adding info for No Bus:usbdev2.1_ep81
[   29.763851] PM: Adding info for No Bus:usbdev2.1
[   29.763892] USB Universal Host Controller Interface driver v3.0
[   29.833724] usb 1-1: new high speed USB device using ehci_hcd and address 2
[   29.958167] PM: Adding info for usb:1-1
[   29.958206] PM: Adding info for No Bus:usbdev1.2_ep00
[   29.958228] usb 1-1: configuration #1 chosen from 1 choice
[   29.958541] PM: Adding info for usb:1-1:1.0
[   29.958566] hub 1-1:1.0: USB hub found
[   29.958912] hub 1-1:1.0: 4 ports detected
[   30.063444] PM: Adding info for No Bus:usbdev1.2_ep81
[   30.063475] PM: Adding info for No Bus:usbdev1.2
[   30.250171] usb 1-1.3: new low speed USB device using ehci_hcd and address 3
[   30.338436] PM: Adding info for usb:1-1.3
[   30.338473] PM: Adding info for No Bus:usbdev1.3_ep00
[   30.338501] usb 1-1.3: configuration #1 chosen from 1 choice
[   30.338938] PM: Adding info for usb:1-1.3:1.0
[   30.338971] PM: Adding info for No Bus:usbdev1.3_ep81
[   30.339000] PM: Adding info for No Bus:usbdev1.3
[   30.526445] usb 1-1.4: new low speed USB device using ehci_hcd and address 4
[   30.616586] PM: Adding info for usb:1-1.4
[   30.616621] PM: Adding info for No Bus:usbdev1.4_ep00
[   30.616645] usb 1-1.4: configuration #1 chosen from 1 choice
[   30.617209] PM: Adding info for usb:1-1.4:1.0
[   30.617242] PM: Adding info for No Bus:usbdev1.4_ep81
[   30.617271] PM: Adding info for No Bus:usbdev1.4
[   30.617588] usbcore: registered new interface driver usblp
[   30.617696] drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
[   30.620360] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   30.620470] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-1.3
[   30.625089] input: HID 046a:0001 as /class/input/input3
[   30.625205] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-1.4
[   30.625443] usbcore: registered new interface driver usbhid
[   30.625551] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   30.625708] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   30.625816] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   30.625948] PM: Adding info for platform:i8042
[   30.626142] serio: i8042 KBD port at 0x60,0x64 irq 1
[   30.626255] PM: Adding info for serio:serio0
[   30.626267] serio: i8042 AUX port at 0x60,0x64 irq 12
[   30.626404] PM: Adding info for serio:serio1
[   30.626461] PM: Adding info for No Bus:psaux
[   30.626478] mice: PS/2 mouse device common for all mice
[   30.646578] input: AT Translated Set 2 keyboard as /class/input/input4
[   30.702726] i2c /dev entries driver
[   30.702867] PM: Adding info for No Bus:i2c-9191
[   30.702921] PM: Adding info for No Bus:i2c-0
[   30.702950] PM: Adding info for No Bus:i2c-0
[   30.702969] i2c_adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[   30.703080] PM: Adding info for No Bus:i2c-1
[   30.703104] PM: Adding info for No Bus:i2c-1
[   30.703123] i2c_adapter i2c-1: nForce2 SMBus adapter at 0x1c40
[   30.703273] it87: Found IT8716F chip at 0x290, revision 0
[   30.703386] it87: in3 is VCC (+5V)
[   30.709361] it87: in7 is VCCH (+5V Stand-By)
[   30.709502] PM: Adding info for i2c:9191-0290
[   30.709701] md: raid1 personality registered for level 1
[   30.709841] PM: Adding info for No Bus:device-mapper
[   30.709864] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   30.710112] Bluetooth: HCI USB driver ver 2.9
[   30.710245] usbcore: registered new interface driver hci_usb
[   30.710353] Bluetooth: HCI UART driver ver 2.2
[   30.710460] Bluetooth: HCI H4 protocol initialized
[   30.710566] Bluetooth: HCI BCSP protocol initialized
[   30.710699] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[   30.710902] PM: Adding info for No Bus:timer
[   30.710936] PM: Adding info for No Bus:sequencer
[   30.710961] PM: Adding info for No Bus:sequencer2
[   30.711030] PM: Adding info for No Bus:seq
[   30.711059] ALSA device list:
[   30.711165]   No soundcards found.
[   30.711286] GACT probability on
[   30.711393] Mirror/redirect action on
[   30.711529] PM: Adding info for No Bus:teql0
[   30.711566] u32 classifier
[   30.711672]     Performance counters on
[   30.711778]     input device check on 
[   30.711884]     Actions configured 
[   30.711996] IPv4 over IPv4 tunneling driver
[   30.712124] PM: Adding info for No Bus:tunl0
[   30.712187] ip_tables: (C) 2000-2006 Netfilter Core Team
[   30.712315] TCP bic registered
[   30.712421] TCP cubic registered
[   30.712527] TCP westwood registered
[   30.712640] TCP htcp registered
[   30.712746] TCP vegas registered
[   30.712852] Initializing XFRM netlink socket
[   30.712966] NET: Registered protocol family 1
[   30.713105] NET: Registered protocol family 10
[   30.713314] IPv6 over IPv4 tunneling driver
[   30.713441] PM: Adding info for No Bus:sit0
[   30.713506] PM: Adding info for No Bus:ip6tnl0
[   30.713543] NET: Registered protocol family 17
[   30.713651] NET: Registered protocol family 15
[   30.713767] Bridge firewalling registered
[   30.713876] Bluetooth: L2CAP ver 2.8
[   30.713982] Bluetooth: L2CAP socket layer initialized
[   30.714089] Bluetooth: SCO (Voice Link) ver 0.5
[   30.714195] Bluetooth: SCO socket layer initialized
[   30.714308] Bluetooth: RFCOMM socket layer initialized
[   30.714423] Bluetooth: RFCOMM TTY layer initialized
[   30.714529] Bluetooth: RFCOMM ver 1.8
[   30.714636] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   30.714742] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   30.714885] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   30.714992] All bugs added by David S. Miller <davem@redhat.com>
[   30.715105] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (version 2.00.00)
[   30.715324] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
[   30.715432] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
[   30.715539] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   30.715754] swsusp: Resume From Partition /dev/sda6
[   30.715756] PM: Checking swsusp image.
[   30.715949] PM: Resume from disk failed.
[   30.819186] md: Autodetecting RAID arrays.
[   30.819294] md: autorun ...
[   30.819399] md: ... autorun DONE.
[   30.829761] EXT3-fs: INFO: recovery required on readonly filesystem.
[   30.829869] EXT3-fs: write access will be enabled during recovery.
[   30.860582] kjournald starting.  Commit interval 5 seconds
[   30.860700] EXT3-fs: recovery complete.
[   30.861073] EXT3-fs: mounted filesystem with ordered data mode.
[   30.861228] VFS: Mounted root (ext3 filesystem) readonly.
[   30.861375] Freeing unused kernel memory: 208k freed
[   30.883158] PM: Adding info for No Bus:vcs1
[   30.899901] PM: Adding info for No Bus:vcsa1
[   31.159329] PM: Removing info for No Bus:vcs1
[   31.159379] PM: Removing info for No Bus:vcsa1
[   31.159420] PM: Adding info for No Bus:vcs1
[   31.159444] PM: Adding info for No Bus:vcsa1
[   31.159478] PM: Removing info for No Bus:vcs1
[   31.159499] PM: Removing info for No Bus:vcsa1
[   31.188358] PM: Adding info for No Bus:vcs1
[   31.188381] PM: Adding info for No Bus:vcsa1
[   31.188433] PM: Removing info for No Bus:vcs1
[   31.188453] PM: Removing info for No Bus:vcsa1
[   31.188481] PM: Adding info for No Bus:vcs1
[   31.188502] PM: Adding info for No Bus:vcsa1
[   31.188548] PM: Removing info for No Bus:vcs1
[   31.188568] PM: Removing info for No Bus:vcsa1
[   31.188597] PM: Adding info for No Bus:vcs1
[   31.188619] PM: Adding info for No Bus:vcsa1
[   31.188772] PM: Removing info for No Bus:vcs1
[   31.188794] PM: Removing info for No Bus:vcsa1
[   31.211795] PM: Adding info for No Bus:vcs1
[   31.211876] PM: Adding info for No Bus:vcsa1
[   32.566267] pata_amd 0000:00:04.0: version 0.2.8
[   32.566290] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   32.566332] ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001f000 irq 14
[   32.566553] ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001f008 irq 15
[   32.566764] scsi2 : pata_amd
[   32.566876] PM: Adding info for No Bus:host2
[   32.701244] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
[   33.039833] ata3.00: ATAPI, max UDMA/33
[   33.039946] ata3.01: ATAPI, max UDMA/66
[   33.199628] ata3.00: configured for UDMA/33
[   33.359447] ata3.01: configured for UDMA/66
[   33.359559] scsi3 : pata_amd
[   33.359676] PM: Adding info for No Bus:host3
[   33.359712] ata4: port disabled. ignoring.
[   33.359735] PM: Adding info for No Bus:target2:0:0
[   33.360529] scsi 2:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.1A PQ: 0 ANSI: 5
[   33.360737] PM: Adding info for scsi:2:0:0:0
[   33.363592] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   33.363702] Uniform CD-ROM driver Revision: 3.20
[   33.363844] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   33.363873] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   33.363997] PM: Adding info for No Bus:target2:0:1
[   33.365150] scsi 2:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-106  1.22 PQ: 0 ANSI: 5
[   33.365358] PM: Adding info for scsi:2:0:1:0
[   33.369396] sr1: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   33.369551] sr 2:0:1:0: Attached scsi CD-ROM sr1
[   33.369578] sr 2:0:1:0: Attached scsi generic sg2 type 5
[   33.370221] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
[   33.370331] IOAPIC[0]: Set routing entry (2-21 -> 0x99 -> IRQ 21 Mode:1 Active:1)
[   33.370338] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   33.370573] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   33.370580] forcedeth: using HIGHDMA
[   33.885522] PM: Adding info for No Bus:eth0
[   33.885596] eth0: forcedeth.c: subsystem: 01043:8239 bound to 0000:00:08.0
[   33.886148] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 20
[   33.886258] IOAPIC[0]: Set routing entry (2-20 -> 0xa1 -> IRQ 20 Mode:1 Active:1)
[   33.886265] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AMC1] -> GSI 20 (level, low) -> IRQ 20
[   33.886499] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   33.886506] forcedeth: using HIGHDMA
[   34.401518] PM: Adding info for No Bus:eth1
[   34.401647] eth1: forcedeth.c: subsystem: 01043:8239 bound to 0000:00:09.0
[   34.416194] gameport: EMU10K1 is pci0000:01:08.1/gameport0, io 0xd400, speed 1200kHz
[   34.416390] PM: Adding info for gameport:gameport0
[   34.417079] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   34.417191] IOAPIC[0]: Set routing entry (2-18 -> 0xa9 -> IRQ 18 Mode:1 Active:1)
[   34.417197] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   34.417438] ALSA sound/pci/emu10k1/emu10k1_main.c:1536: vendor=0x1102, device=0x2, subsystem_vendor_id=0x80641102, subsystem_id=0x8064
[   34.417654] ALSA sound/pci/emu10k1/emu10k1_main.c:1561: Sound card name=SB Live 5.1
[   34.455639] PM: Adding info for No Bus:card0
[   34.455796] PM: Adding info for No Bus:hwC0D0
[   34.455884] PM: Adding info for No Bus:midiC0D0
[   34.455978] PM: Adding info for No Bus:midi
[   34.456062] PM: Adding info for No Bus:dmmidi
[   34.456170] PM: Adding info for No Bus:pcmC0D3p
[   34.456260] PM: Adding info for ac97:0-0:EM28028
[   34.456348] PM: Adding info for No Bus:pcmC0D2p
[   34.456446] PM: Adding info for No Bus:pcmC0D2c
[   34.456533] PM: Adding info for No Bus:pcmC0D1c
[   34.456624] PM: Adding info for No Bus:adsp
[   34.456710] PM: Adding info for No Bus:pcmC0D0p
[   34.456847] PM: Adding info for No Bus:pcmC0D0c
[   34.456940] PM: Adding info for No Bus:dsp
[   34.457028] PM: Adding info for No Bus:audio
[   34.457124] PM: Adding info for No Bus:controlC0
[   34.457218] PM: Adding info for No Bus:mixer
[   34.539345] PM: Adding info for No Bus:hwC0D2
[   34.539538] PM: Adding info for No Bus:midiC0D1
[   34.539632] PM: Adding info for No Bus:amidi
[   34.539731] PM: Adding info for No Bus:admmidi
[   34.539835] PM: Adding info for No Bus:midiC0D2
[   34.772127] Adding 1951856k swap on /dev/sda6.  Priority:-1 extents:1 across:1951856k
[   34.933395] EXT3 FS on sda5, internal journal
[  277.287851] kjournald starting.  Commit interval 5 seconds
[  277.287861] EXT3-fs: mounted filesystem with ordered data mode.
[  277.330600] kjournald starting.  Commit interval 5 seconds
[  277.330809] EXT3 FS on dm-2, internal journal
[  277.330814] EXT3-fs: mounted filesystem with ordered data mode.
[  277.354019] kjournald starting.  Commit interval 5 seconds
[  277.354195] EXT3 FS on dm-1, internal journal
[  277.354199] EXT3-fs: mounted filesystem with ordered data mode.
[  277.374442] kjournald starting.  Commit interval 5 seconds
[  277.374452] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[  277.374718] EXT3 FS on dm-3, internal journal
[  277.374723] EXT3-fs: mounted filesystem with ordered data mode.
[  277.391612] ReiserFS: dm-4: found reiserfs format "3.6" with standard journal
[  277.391622] ReiserFS: dm-4: using ordered data mode
[  277.395450] ReiserFS: dm-4: journal params: device dm-4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[  277.396587] ReiserFS: dm-4: checking transaction log (dm-4)
[  277.401411] ReiserFS: dm-4: replayed 1 transactions in 0 seconds
[  277.429313] ReiserFS: dm-4: Using r5 hash to sort names
[  282.425856] PM: Adding info for No Bus:vcs2
[  282.425955] PM: Adding info for No Bus:vcsa2
[  282.428330] PM: Removing info for No Bus:vcs2
[  282.428427] PM: Removing info for No Bus:vcsa2
[  282.430460] PM: Adding info for No Bus:vcs3
[  282.430553] PM: Adding info for No Bus:vcsa3
[  282.432965] PM: Removing info for No Bus:vcs3
[  282.433062] PM: Removing info for No Bus:vcsa3
[  282.435168] PM: Adding info for No Bus:vcs4
[  282.435261] PM: Adding info for No Bus:vcsa4
[  282.437625] PM: Removing info for No Bus:vcs4
[  282.437722] PM: Removing info for No Bus:vcsa4
[  282.439812] PM: Adding info for No Bus:vcs5
[  282.439904] PM: Adding info for No Bus:vcsa5
[  282.442340] PM: Removing info for No Bus:vcs5
[  282.442435] PM: Removing info for No Bus:vcsa5
[  282.444457] PM: Adding info for No Bus:vcs6
[  282.444551] PM: Adding info for No Bus:vcsa6
[  282.446930] PM: Removing info for No Bus:vcs6
[  282.447026] PM: Removing info for No Bus:vcsa6
[  284.642859] PM: Removing info for No Bus:vcs1
[  284.642968] PM: Removing info for No Bus:vcsa1
[  284.661395] PM: Adding info for No Bus:vcs1
[  284.661475] PM: Adding info for No Bus:vcsa1
[  284.661979] PM: Removing info for No Bus:vcs1
[  284.661998] PM: Removing info for No Bus:vcsa1
[  284.662030] PM: Adding info for No Bus:vcs1
[  284.662042] PM: Adding info for No Bus:vcsa1
[  284.662078] PM: Removing info for No Bus:vcs1
[  284.662088] PM: Removing info for No Bus:vcsa1
[  284.662109] PM: Adding info for No Bus:vcs1
[  284.662119] PM: Adding info for No Bus:vcsa1
[  284.662258] PM: Removing info for No Bus:vcs1
[  284.662269] PM: Removing info for No Bus:vcsa1
[  284.662478] PM: Adding info for No Bus:vcs1
[  284.662490] PM: Adding info for No Bus:vcsa1
[  284.679513] Time: hpet clocksource has been installed.
[  286.823474] eth0: no IPv6 routers present
[  289.929349] PM: Removing info for No Bus:vcs1
[  289.929635] PM: Removing info for No Bus:vcsa1
[  289.931686] PM: Adding info for No Bus:vcs1
[  289.931817] PM: Adding info for No Bus:vcsa1
[  289.947635] PM: Adding info for No Bus:vcs2
[  289.947893] PM: Adding info for No Bus:vcsa2
[  289.949695] PM: Adding info for No Bus:vcs3
[  289.949895] PM: Adding info for No Bus:vcsa3
[  289.952890] PM: Adding info for No Bus:vcs4
[  289.953090] PM: Adding info for No Bus:vcsa4
[  289.955559] PM: Adding info for No Bus:vcs5
[  289.955764] PM: Adding info for No Bus:vcsa5
[  289.958596] PM: Adding info for No Bus:vcs6
[  289.958800] PM: Adding info for No Bus:vcsa6
[  294.376450] PM: Adding info for No Bus:vcs7
[  294.376663] PM: Adding info for No Bus:vcsa7
[  294.646022] [drm] Initialized drm 1.1.0 20060810
[  294.657451] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[  294.657577] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[  294.658757] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[  302.092400] [drm] Setting GART location based on new memory map
[  302.092695] [drm] Loading R300 Microcode
[  302.092841] [drm] writeback test succeeded in 1 usecs
[  341.218604] nfs: server nukunuku not responding, still trying
[  342.317217] nfs: server nukunuku not responding, still trying
[  343.415831] nfs: server nukunuku not responding, still trying
[  345.613057] nfs: server nukunuku not responding, still trying
[  360.922130] device eth0 entered promiscuous mode
[  364.576039] device eth0 left promiscuous mode
[  365.717731] device eth0 entered promiscuous mode
[  365.722746] device eth0 left promiscuous mode
[  368.162977] device eth0 entered promiscuous mode
[  380.348279] eth0: link down.
[  382.557492] eth0: link up.
[  382.966752] nfs: server nukunuku OK
[  382.967010] nfs: server nukunuku OK
[  382.967044] nfs: server nukunuku OK
[  382.967134] nfs: server nukunuku OK
[  394.784776] device eth0 left promiscuous mode
[ 7849.828098] usb 2-2: new full speed USB device using ohci_hcd and address 2
[ 7849.905471] PM: Adding info for usb:2-2
[ 7849.905520] PM: Adding info for No Bus:usbdev2.2_ep00
[ 7849.905536] usb 2-2: configuration #1 chosen from 1 choice
[ 7849.906976] PM: Adding info for usb:2-2:1.0
[ 7849.908477] PM: Adding info for No Bus:usbdev2.2_ep01
[ 7849.908507] PM: Adding info for No Bus:usbdev2.2_ep81
[ 7849.909977] PM: Adding info for No Bus:lp0
[ 7849.909994] drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0217
[ 7849.910013] PM: Adding info for No Bus:usbdev2.2
[ 7904.191923] usb 2-2: USB disconnect, address 2
[ 7904.191940] PM: Removing info for No Bus:usbdev2.2_ep01
[ 7904.191970] PM: Removing info for No Bus:usbdev2.2_ep81
[ 7904.191994] PM: Removing info for No Bus:lp0
[ 7904.192012] drivers/usb/class/usblp.c: usblp0: removed
[ 7904.192015] PM: Removing info for usb:2-2:1.0
[ 7904.192042] PM: Removing info for No Bus:usbdev2.2
[ 7904.192060] PM: Removing info for No Bus:usbdev2.2_ep00
[ 7904.192079] PM: Removing info for usb:2-2
[10229.850044] PM: suspend-to-disk mode set to 'platform'
[10232.599995] Stopping tasks ... done.
[10232.607971] Shrinking memory...  -\|/-\|/done (52506 pages freed)
[10233.144153] Freed 210024 kbytes in 0.53 seconds (396.27 MB/s)
[10233.144849] ac97 0-0:EM28028: freeze
[10233.144878] sr 2:0:1:0: freeze
[10233.144920] sr 2:0:0:0: freeze
[10233.144950] it87-isa 9191-0290: freeze
[10233.144974] serio serio1: freeze
[10233.144997] atkbd serio0: freeze
[10233.145020] i8042 i8042: freeze
[10233.145043] usbhid 1-1.4:1.0: freeze
[10233.145066] usb 1-1.4: freeze
[10233.145097] usbhid 1-1.3:1.0: freeze
[10233.145120] usb 1-1.3: freeze
[10233.145143] hub 1-1:1.0: freeze
[10233.145166] usb 1-1: freeze
[10233.145246] hub 2-0:1.0: freeze
[10233.145269] usb usb2: freeze
[10233.145295] hub 1-0:1.0: freeze
[10233.145317] usb usb1: freeze
[10233.145350] sd 1:0:0:0: freeze
[10233.145395] platform vesafb.0: freeze
[10233.145418] pci_express 0000:00:0f.0:pcie03: freeze
[10233.145441] pci_express 0000:00:0f.0:pcie00: freeze
[10233.145464] pci_express 0000:00:0e.0:pcie03: freeze
[10233.145487] pci_express 0000:00:0e.0:pcie00: freeze
[10233.145511] pci_express 0000:00:0d.0:pcie03: freeze
[10233.145534] pci_express 0000:00:0d.0:pcie00: freeze
[10233.145557] pci_express 0000:00:0c.0:pcie03: freeze
[10233.145580] pci_express 0000:00:0c.0:pcie00: freeze
[10233.145603] pci_express 0000:00:0b.0:pcie03: freeze
[10233.145626] pci_express 0000:00:0b.0:pcie00: freeze
[10233.145649] pci_express 0000:00:0a.0:pcie03: freeze
[10233.145672] pci_express 0000:00:0a.0:pcie00: freeze
[10233.145696] platform pcspkr: freeze
[10233.145720] platform bluetooth: freeze
[10233.145742] system 00:0b: freeze
[10233.145765] system 00:0a: freeze
[10233.145788] i8042 kbd 00:09: freeze
[10233.145810] pnp 00:08: freeze
[10233.145833] pnp 00:07: freeze
[10233.145855] pnp 00:06: freeze
[10233.145877] pnp 00:05: freeze
[10233.145899] pnp 00:04: freeze
[10233.145922] pnp 00:03: freeze
[10233.145944] system 00:02: freeze
[10233.145966] system 00:01: freeze
[10233.145989] pnp 00:00: freeze
[10233.146011] pci 0000:07:00.1: freeze
[10233.146050] pci 0000:07:00.0: freeze
[10233.146089] pci 0000:06:00.1: freeze
[10233.146135] ahci 0000:06:00.0: freeze
[10233.146222] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[10233.146245] pci 0000:01:0b.0: freeze
[10233.146282] Emu10k1_gameport 0000:01:08.1: freeze
[10233.146317] EMU10K1_Audigy 0000:01:08.0: freeze
[10233.152888] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[10233.164144] e100 0000:01:07.0: freeze
[10233.164194] ACPI: PCI interrupt for device 0000:01:07.0 disabled
[10233.164218] Trying to free already-free IRQ 17
[10233.177460] k8temp 0000:00:18.3: freeze
[10233.177572] pci 0000:00:18.2: freeze
[10233.177682] pci 0000:00:18.1: freeze
[10233.177792] pci 0000:00:18.0: freeze
[10233.177904] pcieport-driver 0000:00:0f.0: freeze
[10233.178020] pcieport-driver 0000:00:0e.0: freeze
[10233.178135] pcieport-driver 0000:00:0d.0: freeze
[10233.178250] pcieport-driver 0000:00:0c.0: freeze
[10233.178365] pcieport-driver 0000:00:0b.0: freeze
[10233.178479] pcieport-driver 0000:00:0a.0: freeze
[10233.178594] forcedeth 0000:00:09.0: freeze
[10233.178701] forcedeth 0000:00:08.0: freeze
[10233.190776] pci 0000:00:06.1: freeze
[10233.190893] pci 0000:00:06.0: freeze
[10233.191004] pata_amd 0000:00:04.0: freeze
[10233.191141] ehci_hcd 0000:00:02.1: freeze
[10233.191259] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[10233.204097] ohci_hcd 0000:00:02.0: freeze
[10233.204214] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[10233.217414] pci 0000:00:01.2: freeze
[10233.217527] nForce2_smbus 0000:00:01.1: freeze
[10233.217649] pci 0000:00:01.0: freeze
[10233.217760] pci 0000:00:00.0: freeze
[10233.217915] acpi AWY0001:00: freeze
[10233.218022] thermal thermal:01: freeze
[10233.218129] fan PNP0C0B:00: freeze
[10233.218235] acpi thermal:00: freeze
[10233.218342] acpi PNP0C01:00: freeze
[10233.218448] acpi PNP0C02:02: freeze
[10233.218554] pci_link PNP0C0F:27: freeze
[10233.218661] pci_link PNP0C0F:26: freeze
[10233.218767] pci_link PNP0C0F:25: freeze
[10233.218874] pci_link PNP0C0F:24: freeze
[10233.218981] pci_link PNP0C0F:23: freeze
[10233.219087] pci_link PNP0C0F:22: freeze
[10233.219194] pci_link PNP0C0F:21: freeze
[10233.219300] pci_link PNP0C0F:20: freeze
[10233.219407] pci_link PNP0C0F:1f: freeze
[10233.219513] pci_link PNP0C0F:1e: freeze
[10233.219620] pci_link PNP0C0F:1d: freeze
[10233.219727] pci_link PNP0C0F:1c: freeze
[10233.219833] pci_link PNP0C0F:1b: freeze
[10233.219939] pci_link PNP0C0F:1a: freeze
[10233.220046] pci_link PNP0C0F:19: freeze
[10233.220152] pci_link PNP0C0F:18: freeze
[10233.220259] pci_link PNP0C0F:17: freeze
[10233.220366] pci_link PNP0C0F:16: freeze
[10233.220473] pci_link PNP0C0F:15: freeze
[10233.220579] pci_link PNP0C0F:14: freeze
[10233.220685] pci_link PNP0C0F:13: freeze
[10233.220794] pci_link PNP0C0F:12: freeze
[10233.220901] pci_link PNP0C0F:11: freeze
[10233.221007] pci_link PNP0C0F:10: freeze
[10233.221114] pci_link PNP0C0F:0f: freeze
[10233.221220] pci_link PNP0C0F:0e: freeze
[10233.221326] pci_link PNP0C0F:0d: freeze
[10233.221433] pci_link PNP0C0F:0c: freeze
[10233.221539] pci_link PNP0C0F:0b: freeze
[10233.221666] pci_link PNP0C0F:0a: freeze
[10233.221773] pci_link PNP0C0F:09: freeze
[10233.221881] pci_link PNP0C0F:08: freeze
[10233.221988] pci_link PNP0C0F:07: freeze
[10233.222094] pci_link PNP0C0F:06: freeze
[10233.222201] pci_link PNP0C0F:05: freeze
[10233.222308] pci_link PNP0C0F:04: freeze
[10233.222415] pci_link PNP0C0F:03: freeze
[10233.222522] pci_link PNP0C0F:02: freeze
[10233.222629] pci_link PNP0C0F:01: freeze
[10233.222736] pci_link PNP0C0F:00: freeze
[10233.222843] acpi ATK0110:00: freeze
[10233.222950] acpi device:30: freeze
[10233.223057] acpi device:2f: freeze
[10233.223163] acpi device:2e: freeze
[10233.223270] acpi device:2d: freeze
[10233.223377] acpi device:2c: freeze
[10233.223484] acpi PNP0303:00: freeze
[10233.223590] acpi PNP0501:00: freeze
[10233.223698] acpi PNP0C04:00: freeze
[10233.223804] acpi PNP0800:00: freeze
[10233.223911] acpi PNP0B00:00: freeze
[10233.224017] acpi PNP0103:00: freeze
[10233.224126] acpi PNP0100:00: freeze
[10233.224233] acpi PNP0200:00: freeze
[10233.224340] acpi PNP0000:00: freeze
[10233.224447] acpi PNP0C02:01: freeze
[10233.224553] acpi device:2b: freeze
[10233.224660] acpi device:2a: freeze
[10233.224766] acpi device:29: freeze
[10233.224873] acpi device:28: freeze
[10233.224980] acpi device:27: freeze
[10233.225086] acpi device:26: freeze
[10233.225193] acpi device:25: freeze
[10233.225300] acpi device:24: freeze
[10233.225406] acpi device:23: freeze
[10233.225513] acpi device:22: freeze
[10233.225620] acpi device:21: freeze
[10233.225726] acpi device:20: freeze
[10233.225833] acpi device:1f: freeze
[10233.225940] acpi device:1e: freeze
[10233.226046] acpi device:1d: freeze
[10233.226153] acpi device:1c: freeze
[10233.226260] acpi device:1b: freeze
[10233.226367] acpi device:1a: freeze
[10233.226473] acpi device:19: freeze
[10233.226580] acpi device:18: freeze
[10233.226687] acpi device:17: freeze
[10233.226794] acpi device:16: freeze
[10233.226900] acpi device:15: freeze
[10233.227008] acpi device:14: freeze
[10233.227114] acpi device:13: freeze
[10233.227221] acpi device:12: freeze
[10233.227328] acpi device:11: freeze
[10233.227437] acpi device:10: freeze
[10233.227544] acpi device:0f: freeze
[10233.227650] acpi device:0e: freeze
[10233.227757] acpi device:0d: freeze
[10233.227864] acpi device:0c: freeze
[10233.227970] acpi device:0b: freeze
[10233.228077] acpi device:0a: freeze
[10233.228184] acpi device:09: freeze
[10233.228290] acpi device:08: freeze
[10233.228397] acpi device:07: freeze
[10233.228504] acpi device:06: freeze
[10233.228610] acpi device:05: freeze
[10233.228717] acpi device:04: freeze
[10233.228823] acpi device:03: freeze
[10233.228930] acpi device:02: freeze
[10233.229036] acpi device:01: freeze
[10233.229143] acpi PNP0C02:00: freeze
[10233.229250] pci_root PNP0A08:00: freeze
[10233.229357] button PNP0C0C:00: freeze
[10233.229464] acpi device:00: freeze
[10233.229571] processor ACPI0007:01: freeze
[10233.229678] processor ACPI0007:00: freeze
[10233.229785] button button_power:00: freeze
[10233.229892] acpi acpi_system:00: freeze
[10233.229999] PM: snapshotting memory.
[10233.230120] platform vesafb.0: LATE freeze
[10233.230228] platform pcspkr: LATE freeze
[10233.230336] platform bluetooth: LATE freeze
[10233.230444] pci 0000:07:00.1: LATE freeze
[10233.230551] pci 0000:07:00.0: LATE freeze
[10233.230658] pci 0000:06:00.1: LATE freeze
[10233.230765] pci 0000:01:0b.0: LATE freeze
[10233.236739] Emu10k1_gameport 0000:01:08.1: LATE freeze
[10233.236847] EMU10K1_Audigy 0000:01:08.0: LATE freeze
[10233.236954] e100 0000:01:07.0: LATE freeze
[10233.237061] k8temp 0000:00:18.3: LATE freeze
[10233.237168] pci 0000:00:18.2: LATE freeze
[10233.237275] pci 0000:00:18.1: LATE freeze
[10233.237382] pci 0000:00:18.0: LATE freeze
[10233.237489] pcieport-driver 0000:00:0f.0: LATE freeze
[10233.237596] pcieport-driver 0000:00:0e.0: LATE freeze
[10233.237703] pcieport-driver 0000:00:0d.0: LATE freeze
[10233.237811] pcieport-driver 0000:00:0c.0: LATE freeze
[10233.237918] pcieport-driver 0000:00:0b.0: LATE freeze
[10233.238025] pcieport-driver 0000:00:0a.0: LATE freeze
[10233.238132] forcedeth 0000:00:09.0: LATE freeze
[10233.238240] forcedeth 0000:00:08.0: LATE freeze
[10233.238347] pci 0000:00:06.1: LATE freeze
[10233.238453] pci 0000:00:06.0: LATE freeze
[10233.238560] pci 0000:00:01.2: LATE freeze
[10233.238667] nForce2_smbus 0000:00:01.1: LATE freeze
[10233.238774] pci 0000:00:01.0: LATE freeze
[10233.238881] pci 0000:00:00.0: LATE freeze
[10233.239099] Extended CMOS year: 2000
[10233.239209] swsusp: critical section: 
[10233.253579] swsusp: Need to copy 125818 pages
[10233.253688] swsusp: Normal pages needed: 125818 + 1024 + 22, available pages: 135940
[   43.795445] Extended CMOS year: 2000
[   43.798813] svm_cpu_init: svm_data is NULL on 0
[   43.800886] pci 0000:00:00.0: EARLY resume
[   43.800994] pci 0000:00:01.0: EARLY resume
[   43.801102] nForce2_smbus 0000:00:01.1: EARLY resume
[   43.801210] pci 0000:00:01.2: EARLY resume
[   43.801317] ohci_hcd 0000:00:02.0: EARLY resume
[   43.801425] ehci_hcd 0000:00:02.1: EARLY resume
[   43.801532] pata_amd 0000:00:04.0: EARLY resume
[   43.801640] pci 0000:00:06.0: EARLY resume
[   43.801747] pci 0000:00:06.1: EARLY resume
[   43.801854] forcedeth 0000:00:08.0: EARLY resume
[   43.801962] forcedeth 0000:00:09.0: EARLY resume
[   43.802070] pcieport-driver 0000:00:0a.0: EARLY resume
[   43.802177] pcieport-driver 0000:00:0b.0: EARLY resume
[   43.802289] pcieport-driver 0000:00:0c.0: EARLY resume
[   43.802398] pcieport-driver 0000:00:0d.0: EARLY resume
[   43.802506] pcieport-driver 0000:00:0e.0: EARLY resume
[   43.802613] pcieport-driver 0000:00:0f.0: EARLY resume
[   43.802721] pci 0000:00:18.0: EARLY resume
[   43.802828] pci 0000:00:18.1: EARLY resume
[   43.802935] pci 0000:00:18.2: EARLY resume
[   43.803043] k8temp 0000:00:18.3: EARLY resume
[   43.803150] e100 0000:01:07.0: EARLY resume
[   43.803257] EMU10K1_Audigy 0000:01:08.0: EARLY resume
[   43.803365] Emu10k1_gameport 0000:01:08.1: EARLY resume
[   43.803473] pci 0000:01:0b.0: EARLY resume
[   43.803580] ahci 0000:06:00.0: EARLY resume
[   43.803695] pci 0000:06:00.1: EARLY resume
[   43.803802] pci 0000:07:00.0: EARLY resume
[   43.803910] pci 0000:07:00.1: EARLY resume
[   43.804018] platform bluetooth: EARLY resume
[   43.804126] platform pcspkr: EARLY resume
[   43.804233] platform vesafb.0: EARLY resume
[   43.804348] i8042 i8042: EARLY resume
[   43.804460] PM: Image restored successfully.
[   43.924837] acpi acpi_system:00: resuming
[   43.924946] button button_power:00: resuming
[   43.925054] processor ACPI0007:00: resuming
[   43.925161] processor ACPI0007:01: resuming
[   43.925268] acpi device:00: resuming
[   43.925375] button PNP0C0C:00: resuming
[   43.925485] pci_root PNP0A08:00: resuming
[   43.925592] acpi PNP0C02:00: resuming
[   43.925699] acpi device:01: resuming
[   43.925806] acpi device:02: resuming
[   43.925913] acpi device:03: resuming
[   43.926020] acpi device:04: resuming
[   43.926127] acpi device:05: resuming
[   43.926234] acpi device:06: resuming
[   43.926341] acpi device:07: resuming
[   43.926448] acpi device:08: resuming
[   43.926554] acpi device:09: resuming
[   43.926661] acpi device:0a: resuming
[   43.926768] acpi device:0b: resuming
[   43.926875] acpi device:0c: resuming
[   43.926982] acpi device:0d: resuming
[   43.927088] acpi device:0e: resuming
[   43.927195] acpi device:0f: resuming
[   43.927302] acpi device:10: resuming
[   43.927409] acpi device:11: resuming
[   43.927516] acpi device:12: resuming
[   43.927623] acpi device:13: resuming
[   43.927730] acpi device:14: resuming
[   43.927836] acpi device:15: resuming
[   43.927943] acpi device:16: resuming
[   43.928050] acpi device:17: resuming
[   43.928157] acpi device:18: resuming
[   43.928264] acpi device:19: resuming
[   43.928371] acpi device:1a: resuming
[   43.928478] acpi device:1b: resuming
[   43.928584] acpi device:1c: resuming
[   43.928691] acpi device:1d: resuming
[   43.928800] acpi device:1e: resuming
[   43.928907] acpi device:1f: resuming
[   43.929014] acpi device:20: resuming
[   43.929121] acpi device:21: resuming
[   43.929228] acpi device:22: resuming
[   43.929335] acpi device:23: resuming
[   43.929442] acpi device:24: resuming
[   43.929549] acpi device:25: resuming
[   43.929656] acpi device:26: resuming
[   43.929762] acpi device:27: resuming
[   43.929869] acpi device:28: resuming
[   43.929976] acpi device:29: resuming
[   43.930083] acpi device:2a: resuming
[   43.930190] acpi device:2b: resuming
[   43.930297] acpi PNP0C02:01: resuming
[   43.930404] acpi PNP0000:00: resuming
[   43.930510] acpi PNP0200:00: resuming
[   43.930617] acpi PNP0100:00: resuming
[   43.930724] acpi PNP0103:00: resuming
[   43.930831] acpi PNP0B00:00: resuming
[   43.930937] acpi PNP0800:00: resuming
[   43.931044] acpi PNP0C04:00: resuming
[   43.931151] acpi PNP0501:00: resuming
[   43.931258] acpi PNP0303:00: resuming
[   43.931364] acpi device:2c: resuming
[   43.931472] acpi device:2d: resuming
[   43.931578] acpi device:2e: resuming
[   43.931685] acpi device:2f: resuming
[   43.931792] acpi device:30: resuming
[   43.931899] acpi ATK0110:00: resuming
[   43.932006] pci_link PNP0C0F:00: resuming
[   43.932115] pci_link PNP0C0F:01: resuming
[   43.932222] pci_link PNP0C0F:02: resuming
[   43.932330] pci_link PNP0C0F:03: resuming
[   43.932437] pci_link PNP0C0F:04: resuming
[   43.932544] pci_link PNP0C0F:05: resuming
[   43.932651] pci_link PNP0C0F:06: resuming
[   43.932758] pci_link PNP0C0F:07: resuming
[   43.932865] pci_link PNP0C0F:08: resuming
[   43.932972] pci_link PNP0C0F:09: resuming
[   43.933079] pci_link PNP0C0F:0a: resuming
[   43.933185] pci_link PNP0C0F:0b: resuming
[   43.933292] pci_link PNP0C0F:0c: resuming
[   43.933400] pci_link PNP0C0F:0d: resuming
[   43.933507] pci_link PNP0C0F:0e: resuming
[   43.933614] pci_link PNP0C0F:0f: resuming
[   43.939590] pci_link PNP0C0F:10: resuming
[   43.939698] pci_link PNP0C0F:11: resuming
[   43.939805] pci_link PNP0C0F:12: resuming
[   43.939912] pci_link PNP0C0F:13: resuming
[   43.940019] pci_link PNP0C0F:14: resuming
[   43.940127] pci_link PNP0C0F:15: resuming
[   43.940234] pci_link PNP0C0F:16: resuming
[   43.940341] pci_link PNP0C0F:17: resuming
[   43.940448] pci_link PNP0C0F:18: resuming
[   43.940555] pci_link PNP0C0F:19: resuming
[   43.940662] pci_link PNP0C0F:1a: resuming
[   43.940769] pci_link PNP0C0F:1b: resuming
[   43.940877] pci_link PNP0C0F:1c: resuming
[   43.940984] pci_link PNP0C0F:1d: resuming
[   43.941091] pci_link PNP0C0F:1e: resuming
[   43.941198] pci_link PNP0C0F:1f: resuming
[   43.941305] pci_link PNP0C0F:20: resuming
[   43.941413] pci_link PNP0C0F:21: resuming
[   43.941520] pci_link PNP0C0F:22: resuming
[   43.941627] pci_link PNP0C0F:23: resuming
[   43.941734] pci_link PNP0C0F:24: resuming
[   43.941841] pci_link PNP0C0F:25: resuming
[   43.941948] pci_link PNP0C0F:26: resuming
[   43.942057] pci_link PNP0C0F:27: resuming
[   43.942164] acpi PNP0C02:02: resuming
[   43.942272] acpi PNP0C01:00: resuming
[   43.942379] acpi thermal:00: resuming
[   43.942486] fan PNP0C0B:00: resuming
[   43.942594] thermal thermal:01: resuming
[   43.942965] ACPI: Unable to turn cooling device [ffff81003fe80890] 'off'
[   43.943074] acpi AWY0001:00: resuming
[   43.943181] pci 0000:00:00.0: resuming
[   43.943339] pci 0000:00:01.0: resuming
[   43.943452] nForce2_smbus 0000:00:01.1: resuming
[   43.943574] pci 0000:00:01.2: resuming
[   43.943689] ohci_hcd 0000:00:02.0: resuming
[   43.955366] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   43.955477] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   43.955713] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   43.955824] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010b)
[   43.956022] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   43.956218] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   43.956416] ehci_hcd 0000:00:02.1: resuming
[   43.968682] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   43.968918] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   43.969035] usb usb1: root hub lost power or was reset
[   43.969148] ehci_hcd 0000:00:02.1: debug port 1
[   43.969256] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   43.969450] pata_amd 0000:00:04.0: resuming
[   43.969561] PM: Writing back config space on device 0000:00:04.0 at offset b (was 82391043, writing 8239f043)
[   43.969762] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   43.969886] ata4: port disabled. ignoring.
[   43.970010] pci 0000:00:06.0: resuming
[   43.970124] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   43.970233] pci 0000:00:06.1: resuming
[   43.970351] forcedeth 0000:00:08.0: resuming
[   43.982673] forcedeth 0000:00:09.0: resuming
[   43.982781] pcieport-driver 0000:00:0a.0: resuming
[   43.982900] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   43.983009] pcieport-driver 0000:00:0b.0: resuming
[   43.983128] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   43.983237] pcieport-driver 0000:00:0c.0: resuming
[   43.983355] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   43.983464] pcieport-driver 0000:00:0d.0: resuming
[   43.983582] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   43.983690] pcieport-driver 0000:00:0e.0: resuming
[   43.983808] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   43.983917] pcieport-driver 0000:00:0f.0: resuming
[   43.984035] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   43.984144] pci 0000:00:18.0: resuming
[   43.984257] pci 0000:00:18.1: resuming
[   43.984368] pci 0000:00:18.2: resuming
[   43.984479] k8temp 0000:00:18.3: resuming
[   43.984591] e100 0000:01:07.0: resuming
[   43.995319] PM: Writing back config space on device 0000:01:07.0 at offset f (was 38080100, writing 3808010a)
[   43.995516] PM: Writing back config space on device 0000:01:07.0 at offset c (was 0, writing fdc00000)
[   43.995714] PM: Writing back config space on device 0000:01:07.0 at offset 6 (was 0, writing fdd00000)
[   43.995909] PM: Writing back config space on device 0000:01:07.0 at offset 5 (was 1, writing dc01)
[   43.996105] PM: Writing back config space on device 0000:01:07.0 at offset 4 (was 0, writing fdeff000)
[   43.996300] PM: Writing back config space on device 0000:01:07.0 at offset 3 (was 0, writing 2008)
[   43.996496] PM: Writing back config space on device 0000:01:07.0 at offset 1 (was 2900000, writing 2900007)
[   43.996696] EMU10K1_Audigy 0000:01:08.0: resuming
[   44.008642] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   44.008841] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   44.016992] Emu10k1_gameport 0000:01:08.1: resuming
[   44.017116] pci 0000:01:0b.0: resuming
[   44.017236] ahci 0000:06:00.0: resuming
[   44.017365] PM: Writing back config space on device 0000:06:00.0 at offset 1 (was 100003, writing 100007)
[   44.017570] ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
[   44.017807] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   44.017937] pci 0000:06:00.1: resuming
[   44.018068] pci 0000:07:00.0: resuming
[   44.018194] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   44.018428] pci 0000:07:00.1: resuming
[   44.018545] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   44.018746] pnp 00:00: resuming
[   44.018853] system 00:01: resuming
[   44.018960] system 00:02: resuming
[   44.019067] pnp 00:03: resuming
[   44.019173] pnp 00:04: resuming
[   44.019280] pnp 00:05: resuming
[   44.019386] pnp 00:06: resuming
[   44.019493] pnp 00:07: resuming
[   44.019599] pnp 00:08: resuming
[   44.019706] i8042 kbd 00:09: resuming
[   44.019824] pnp: Failed to activate device 00:09.
[   44.019931] system 00:0a: resuming
[   44.020038] system 00:0b: resuming
[   44.020145] platform bluetooth: resuming
[   44.020253] platform pcspkr: resuming
[   44.020361] pci_express 0000:00:0a.0:pcie00: resuming
[   44.020469] pci_express 0000:00:0a.0:pcie03: resuming
[   44.020576] pci_express 0000:00:0b.0:pcie00: resuming
[   44.020684] pci_express 0000:00:0b.0:pcie03: resuming
[   44.020791] pci_express 0000:00:0c.0:pcie00: resuming
[   44.020899] pci_express 0000:00:0c.0:pcie03: resuming
[   44.021006] pci_express 0000:00:0d.0:pcie00: resuming
[   44.021114] pci_express 0000:00:0d.0:pcie03: resuming
[   44.021221] pci_express 0000:00:0e.0:pcie00: resuming
[   44.021329] pci_express 0000:00:0e.0:pcie03: resuming
[   44.021437] pci_express 0000:00:0f.0:pcie00: resuming
[   44.021544] pci_express 0000:00:0f.0:pcie03: resuming
[   44.021651] platform vesafb.0: resuming
[   44.021767] sd 1:0:0:0: resuming
[   44.021878] usb usb1: resuming
[   44.058569] hub 1-0:1.0: resuming
[   44.058676] usb usb2: resuming
[   44.058786] usb usb2: root hub lost power or was reset
[   44.125151] hub 2-0:1.0: resuming
[   44.125258] usb 1-1: resuming
[   44.125366]  usbdev1.2_ep00: PM: resume from 0, parent 1-1 still 1
[   44.125474] hub 1-1:1.0: PM: resume from 1, parent 1-1 still 1
[   44.125582] hub 1-1:1.0: resuming
[   44.125689]  usbdev1.2_ep81: PM: resume from 0, parent 1-1:1.0 still 1
[   44.125798]  usbdev1.2: PM: resume from 0, parent 1-1 still 1
[   44.125906] usb 1-1.3: PM: resume from 1, parent 1-1 still 1
[   44.126013] usb 1-1.3: resuming
[   44.126120]  usbdev1.3_ep00: PM: resume from 0, parent 1-1.3 still 1
[   44.126229] usbhid 1-1.3:1.0: PM: resume from 1, parent 1-1.3 still 1
[   44.126337] usbhid 1-1.3:1.0: resuming
[   44.126444]  usbdev1.3_ep81: PM: resume from 0, parent 1-1.3:1.0 still 1
[   44.126553]  usbdev1.3: PM: resume from 0, parent 1-1.3 still 1
[   44.126662] usb 1-1.4: PM: resume from 1, parent 1-1 still 1
[   44.126769] usb 1-1.4: resuming
[   44.126876]  usbdev1.4_ep00: PM: resume from 0, parent 1-1.4 still 1
[   44.126985] usbhid 1-1.4:1.0: PM: resume from 1, parent 1-1.4 still 1
[   44.127093] usbhid 1-1.4:1.0: resuming
[   44.127200]  usbdev1.4_ep81: PM: resume from 0, parent 1-1.4:1.0 still 1
[   44.127308]  usbdev1.4: PM: resume from 0, parent 1-1.4 still 1
[   44.127416] i8042 i8042: resuming
[   44.127549] atkbd serio0: resuming
[   44.159353] serio serio1: resuming
[   44.159462] it87-isa 9191-0290: resuming
[   44.159571] sr 2:0:0:0: resuming
[   44.159680] sr 2:0:1:0: resuming
[   44.159790] ac97 0-0:EM28028: resuming
[   44.159901] Restarting tasks ... done.
[   44.348210] ata1: SATA link down (SStatus 0 SControl 300)
[   45.055655] usb 1-1: USB disconnect, address 2
[   45.055658] usb 1-1.3: USB disconnect, address 3
[   45.055672] PM: Removing info for No Bus:usbdev1.3_ep81
[   45.055769] PM: Removing info for usb:1-1.3:1.0
[   45.055793] PM: Removing info for No Bus:usbdev1.3
[   45.055811] PM: Removing info for No Bus:usbdev1.3_ep00
[   45.055831] PM: Removing info for usb:1-1.3
[   45.055843] usb 1-1.4: USB disconnect, address 4
[   45.055853] PM: Removing info for No Bus:usbdev1.4_ep81
[   45.055925] PM: Removing info for usb:1-1.4:1.0
[   45.055944] PM: Removing info for No Bus:usbdev1.4
[   45.055959] PM: Removing info for No Bus:usbdev1.4_ep00
[   45.055977] PM: Removing info for usb:1-1.4
[   45.055995] PM: Removing info for No Bus:usbdev1.2_ep81
[   45.056012] PM: Removing info for usb:1-1:1.0
[   45.056034] PM: Removing info for No Bus:usbdev1.2
[   45.056051] PM: Removing info for No Bus:usbdev1.2_ep00
[   45.056067] PM: Removing info for usb:1-1
[   45.135558] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   45.156472] ata2.00: configured for UDMA/133
[   45.156505] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   45.156515] sda: Write Protect is off
[   45.156518] sda: Mode Sense: 00 3a 00 00
[   45.156530] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   45.168841] usb 1-1: new high speed USB device using ehci_hcd and address 6
[   45.193919] ata3.00: configured for UDMA/33
[   45.231082] PM: Adding info for usb:1-1
[   45.231120] PM: Adding info for No Bus:usbdev1.6_ep00
[   45.231134] usb 1-1: configuration #1 chosen from 1 choice
[   45.231262] PM: Adding info for usb:1-1:1.0
[   45.231279] hub 1-1:1.0: USB hub found
[   45.231445] hub 1-1:1.0: 4 ports detected
[   45.273819] ata3.01: configured for UDMA/66
[   45.283720] PM: Adding info for No Bus:usbdev1.6_ep81
[   45.283747] PM: Adding info for No Bus:usbdev1.6
[   45.377016] usb 1-1.3: new low speed USB device using ehci_hcd and address 7
[   45.421221] PM: Adding info for usb:1-1.3
[   45.421263] PM: Adding info for No Bus:usbdev1.7_ep00
[   45.421278] usb 1-1.3: configuration #1 chosen from 1 choice
[   45.421462] PM: Adding info for usb:1-1.3:1.0
[   45.422919] input: Logitech USB-PS/2 Optical Mouse as /class/input/input5
[   45.422945] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-1.3
[   45.422966] PM: Adding info for No Bus:usbdev1.7_ep81
[   45.422990] PM: Adding info for No Bus:usbdev1.7
[   45.516840] usb 1-1.4: new low speed USB device using ehci_hcd and address 8
[   45.560364] PM: Adding info for usb:1-1.4
[   45.560407] PM: Adding info for No Bus:usbdev1.8_ep00
[   45.560422] usb 1-1.4: configuration #1 chosen from 1 choice
[   45.560662] PM: Adding info for usb:1-1.4:1.0
[   45.562572] input: HID 046a:0001 as /class/input/input6
[   45.562598] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-1.4
[   45.562622] PM: Adding info for No Bus:usbdev1.8_ep81
[   45.562649] PM: Adding info for No Bus:usbdev1.8
[   48.844298] [drm] Loading R300 Microcode

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
