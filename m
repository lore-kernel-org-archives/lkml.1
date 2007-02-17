Return-Path: <linux-kernel-owner+w=401wt.eu-S1946357AbXBQBSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946357AbXBQBSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946358AbXBQBSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:18:03 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:21136 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946357AbXBQBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type;
        b=RM1Adzr1P1DSziFLr2lxHa7l73gIgws2mPb0g4XujlFu4PjWvMkq98icX7/5zL9dPwjXr12Ygil4rM2Y28l7U0sLFfNmCVvhTZD7ss5vbEYK4KgJyPCBoKzQS7WUGBcQmVylVpfoTNEvqI5Z2VPogvjlAhAHddikrprHG6a2Ra8=
Message-ID: <45D657C2.4040304@gmail.com>
Date: Fri, 16 Feb 2007 18:17:54 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.20-mm1 USB-related OOPS
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060901040000070608050603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901040000070608050603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I get the following OOPS on boot, presumably connected with USB driver
loading.  I've attached the entire log.  Please CC on replies as I'm not
subscribed.

[  149.525742] Unable to handle kernel NULL pointer dereference at
0000000000000008 RIP:
[  149.531302]  [<ffffffff8887eec3>] :cdc_acm:acm_probe+0x1dd/0x741
[  149.539958] PGD 3d248067 PUD 3d23c067 PMD 0
[  149.544431] Oops: 0000 [1] PREEMPT SMP
[  149.548475] last sysfs file: /class/net/lo/operstate
[  149.553510] CPU 0
[  149.555618] Modules linked in: cdc_acm snd_rtctimer w83627ehf eeprom
i2c_isa nvidia(P) usb_storage usbhid 8139cp snd_hda_intel snd_hda_codec
snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd 8139too uhci_hcd
mii soundcore snd_page_alloc i2c_i801 evdev usbcore i2c_core floppy
[  149.587337] Pid: 1620, comm: modprobe Tainted: P       2.6.20-mm1 #3
[  149.593785] RIP: 0010:[<ffffffff8887eec3>]  [<ffffffff8887eec3>]
:cdc_acm:acm_probe+0x1dd/0x741
[  149.602650] RSP: 0018:ffff81003df29c98  EFLAGS: 00010246
[  149.608045] RAX: ffff81003eb14800 RBX: ffff81003eb14820 RCX:
ffff81003eb21008
[  149.615278] RDX: ffff81003eb14800 RSI: 0000000000000000 RDI:
0000000000000000
[  149.622507] RBP: 0000000000000000 R08: 0000000000000001 R09:
ffffffff88880d80
[  149.629730] R10: 0000000000000000 R11: ffffc2000019a7f8 R12:
ffffffff88880d80
[  149.636960] R13: ffff81003f555800 R14: 0000000000000000 R15:
ffff81003eb14800
[  149.644183] FS:  00002abc668716d0(0000) GS:ffffffff80544000(0000)
knlGS:0000000000000000
[  149.652393] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.658217] CR2: 0000000000000008 CR3: 000000003d25d000 CR4:
00000000000006e0
[  149.665458] Process modprobe (pid: 1620, threadinfo ffff81003df28000,
task ffff81003eeb0950)
[  149.674014] Stack:  ffff81003d21af20 ffff81003eb14800
ffff81003edf3418 ffff81003d21af20
[  149.682317]  00000000fffffff4 ffff81003d4e3820 00ffffff804db922
0000000000000001
[  149.689981]  0000001088880db0 ffff81003d21af20 ffffffff8801cbe5
ffff81003eb14820
[  149.697455] Call Trace:
[  149.700194]  [<ffffffff8801cbe5>] :usbcore:usb_match_one_id+0x26/0x84
[  149.706742]  [<ffffffff8801d78e>] :usbcore:usb_probe_interface+0x7d/0xa5
[  149.713544]  [<ffffffff8039ac88>] driver_probe_device+0xf6/0x17f
[  149.719654]  [<ffffffff8039ad94>] __driver_attach+0x0/0x93
[  149.725230]  [<ffffffff8039adee>] __driver_attach+0x5a/0x93
[  149.730893]  [<ffffffff8039a14e>] bus_for_each_dev+0x43/0x6e
[  149.736644]  [<ffffffff8039a48e>] bus_add_driver+0x6b/0x18d
[  149.742310]  [<ffffffff8801d2b0>] :usbcore:usb_register_driver+0x85/0xeb
[  149.749113]  [<ffffffff880560cc>] :cdc_acm:acm_init+0xcc/0x105
[  149.755037]  [<ffffffff8028dd0b>] sys_init_module+0x1572/0x16d2
[  149.761058]  [<ffffffff802561ce>] system_call+0x7e/0x83
[  149.766361]
[  149.767898]
[  149.767898] Code: 49 8b 46 08 80 78 05 0a 74 17 49 8b 47 08 80 78 05
0a 0f 85
[  149.777661] RIP  [<ffffffff8887eec3>] :cdc_acm:acm_probe+0x1dd/0x741
[  149.784146]  RSP <ffff81003df29c98>
[  149.787694] CR2: 0000000000000008

--------------060901040000070608050603
Content-Type: text/plain;
 name="oops"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="oops"

[    0.000000] Linux version 2.6.20-mm1 (root@luna) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #3 SMP PREEMPT Fri Feb 16 17:31:24 MST 2007
[    0.000000] Command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff80000 (usable)
[    0.000000]  BIOS-e820: 000000003ff80000 - 000000003ff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff8e000 - 000000003ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FF80100, 0064 (r1 NEC              1000724 MSFT       97)
[    0.000000] ACPI: FACP 3FF80290, 00F4 (r3 A_M_I_ OEMFACP   1000724 MSFT       97)
[    0.000000] ACPI: DSDT 3FF80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
[    0.000000] ACPI: FACS 3FF8E000, 0040
[    0.000000] ACPI: APIC 3FF80390, 0080 (r1 A_M_I_ OEMAPIC   1000724 MSFT       97)
[    0.000000] ACPI: SLIC 3FF80410, 0176 (r1 NEC              1000724 MSFT       97)
[    0.000000] ACPI: OEMB 3FF8E040, 0066 (r1 A_M_I_ AMI_OEM   1000724 MSFT       97)
[    0.000000] ACPI: HPET 3FF89AF0, 0038 (r1 A_M_I_ OEMHPET   1000724 MSFT       97)
[    0.000000] ACPI: MCFG 3FF89B30, 003C (r1 A_M_I_ OEMMCFG   1000724 MSFT       97)
[    0.000000] ACPI: SSDT 3FF8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[    0.000000] ACPI: SSDT 3FF8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262016
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e4000
[    0.000000] Nosave address range: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
[    0.000000] PERCPU: Allocating 32512 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 257358
[    0.000000] Kernel command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   55.972492] time.c: Detected 2803.022 MHz processor.
[   55.978185] Console: colour VGA+ 80x25
[   56.330253] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   56.337651] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   56.344845] Checking aperture...
[   56.355983] Memory: 1027632k/1048064k available (2321k kernel code, 19932k reserved, 1021k data, 208k init)
[   56.446402] Calibrating delay using timer specific routine.. 5611.70 BogoMIPS (lpj=9348326)
[   56.454868] Mount-cache hash table entries: 256
[   56.459513] CPU: L1 I cache: 32K, L1 D cache: 32K
[   56.464298] CPU: L2 cache: 2048K
[   56.467565] using mwait in idle threads.
[   56.471522] CPU: Physical Processor ID: 0
[   56.475566] CPU: Processor Core ID: 0
[   56.479267] CPU0: Thermal monitoring enabled (TM2)
[   56.484095] Freeing SMP alternatives: 24k freed
[   56.488669] ACPI: Core revision 20070126
[   56.529802] Using local APIC timer interrupts.
[   56.569927] result 25026969
[   56.572759] Detected 25.026 MHz APIC timer.
[   56.579666] Booting processor 1/2 APIC 0x1
[   56.594145] Initializing CPU#1
[   56.676195] Calibrating delay using timer specific routine.. 5608.69 BogoMIPS (lpj=9343519)
[   56.676199] CPU: L1 I cache: 32K, L1 D cache: 32K
[   56.676200] CPU: L2 cache: 2048K
[   56.676202] CPU: Physical Processor ID: 0
[   56.676203] CPU: Processor Core ID: 1
[   56.676207] CPU1: Thermal monitoring enabled (TM2)
[   56.676404] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[   56.676497] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   56.742810] Brought up 2 CPUs
[   56.796188] migration_cost=19
[   56.799393] NET: Registered protocol family 16
[   56.803923] ACPI: bus type pci registered
[   56.807975] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[   56.814449] PCI: Not using MMCONFIG.
[   56.818057] PCI: Using configuration type 1
[   56.829959] ACPI: Interpreter enabled
[   56.833661] ACPI: Using IOAPIC for interrupt routing
[   56.844613] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   56.849803] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   56.856517] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   56.862252] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[   56.868386] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[   56.874509] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[   56.880634] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[   56.887146] PCI: Transparent bridge - 0000:00:1e.0
[   56.893980] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   56.901658] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[   56.909339] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   56.917018] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   56.924698] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   56.932380] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   56.940371] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   56.948054] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   56.960972] Linux Plug and Play Support v0.97 (c) Adam Belay
[   56.966670] pnp: PnP ACPI init
[   56.971852] pnp: PnP ACPI: found 15 devices
[   56.976162] SCSI subsystem initialized
[   56.979997] PCI: Using ACPI for IRQ routing
[   56.984216] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   56.992572] PCI-GART: No AMD northbridge found.
[   56.997137] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   57.002222] hpet0: 3 64-bit timers, 14318180 Hz
[   57.007808] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[   57.014807] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[   57.021021] pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   57.028016] pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[   57.035004] pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
[   57.041992] pnp: 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
[   57.048984] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   57.055977] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[   57.062967] pnp: 00:0d: iomem range 0xf0000000-0xf3ffffff has been reserved
[   57.069963] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   57.076438] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[   57.082906] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[   57.089721] pnp: 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
[   57.097048] PCI: Bridge: 0000:00:01.0
[   57.100748]   IO window: disabled.
[   57.104188]   MEM window: faa00000-feafffff
[   57.108637]   PREFETCH window: cff00000-efefffff
[   57.113289] PCI: Bridge: 0000:00:1c.0
[   57.116984]   IO window: disabled.
[   57.120424]   MEM window: disabled.
[   57.123948]   PREFETCH window: cfe00000-cfefffff
[   57.128600] PCI: Bridge: 0000:00:1e.0
[   57.132293]   IO window: b000-cfff
[   57.135734]   MEM window: fa800000-fa9fffff
[   57.139951]   PREFETCH window: 50000000-500fffff
[   57.144608] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   57.152098] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   57.159603] NET: Registered protocol family 2
[   57.195898] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   57.203148] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[   57.211740] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   57.218992] TCP: Hash tables configured (established 131072 bind 65536)
[   57.225633] TCP reno registered
[   57.239915] audit: initializing netlink socket (disabled)
[   57.245355] audit(1171647969.809:1): initialized
[   57.250138] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[   57.257448] io scheduler noop registered
[   57.261447] io scheduler anticipatory registered (default)
[   57.289411] assign_interrupt_mode Found MSI capability
[   57.294680] assign_interrupt_mode Found MSI capability
[   57.300033] input: Power Button (FF) as /class/input/input0
[   57.305633] ACPI: Power Button (FF) [PWRF]
[   57.309828] input: Power Button (CM) as /class/input/input1
[   57.315435] ACPI: Power Button (CM) [PWRB]
[   57.319747] ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  00, should be F7 [20070126]
[   57.329532] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._OSC] (Node ffff810001fe8b30), AE_ALREADY_EXISTS
[   57.341355] ACPI: Marking method _OSC as Serialized
[   57.346385] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff810001fe8b50), AE_ALREADY_EXISTS
[   57.358207] ACPI: Marking method _PDC as Serialized
[   57.363412] ACPI: Processor [CPU1] (supports 8 throttling states)
[   57.369755] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._OSC] (Node ffff810001fe8a10), AE_ALREADY_EXISTS
[   57.381577] ACPI: Marking method _OSC as Serialized
[   57.386601] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff810001fe8a30), AE_ALREADY_EXISTS
[   57.398427] ACPI: Marking method _PDC as Serialized
[   57.403635] ACPI: Processor [CPU2] (supports 8 throttling states)
[   57.411226] Real Time Clock Driver v1.12ac
[   57.415481] intel_rng: FWH not detected
[   57.419358] Linux agpgart interface v0.102 (c) Dave Jones
[   57.424792] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   57.432747] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   57.439089] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   57.444795] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   57.451178] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   57.459232] ICH7: IDE controller at PCI slot 0000:00:1f.1
[   57.464670] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
[   57.472155] ICH7: chipset revision 1
[   57.475764] ICH7: not 100% native mode: will probe irqs later
[   57.481547]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:DMA
[   57.488909]     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
[   58.200206] hda: LITE-ON LTR-48246S, ATAPI CD/DVD-ROM drive
[   58.951133] hdb: _NEC DVD_RW ND-3520AW, ATAPI CD/DVD-ROM drive
[   59.009722] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   59.569511] hda: ATAPI 48X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
[   59.576470] Uniform CD-ROM driver Revision: 3.20
[   59.619699] hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
[   59.629309] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[   59.846470] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   59.846471]         <Adaptec 2940 Ultra2 SCSI adapter>
[   59.846471]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   59.846472] 
[   59.867316] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
[   60.126942] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[   60.135070] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[   60.140554]  target0:0:1: Beginning Domain Validation
[   60.152060]  target0:0:1: wide asynchronous
[   60.160960]  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[   60.172180]  target0:0:1: Domain Validation skipping write tests
[   60.178215]  target0:0:1: Ending Domain Validation
[   60.186023] scsi 0:0:2:0: Direct-Access     SGI      SEAGATE ST39102L 2702 PQ: 0 ANSI: 2
[   60.194150] scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
[   60.199633]  target0:0:2: Beginning Domain Validation
[   60.209983]  target0:0:2: wide asynchronous
[   60.218053]  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[   60.228445]  target0:0:2: Domain Validation skipping write tests
[   60.234480]  target0:0:2: Ending Domain Validation
[   60.904175] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   60.912308] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
[   60.918907] ata1: SATA max UDMA/133 cmd 0xffffc2000002a900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 317
[   60.929330] ata2: SATA max UDMA/133 cmd 0xffffc2000002a980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 317
[   60.939743] ata3: SATA max UDMA/133 cmd 0xffffc2000002aa00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 317
[   60.950166] ata4: SATA max UDMA/133 cmd 0xffffc2000002aa80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 317
[   60.960553] scsi1 : ahci
[   61.436882] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   61.449378] ata1.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
[   61.455940] ata1.00: 72303840 sectors, multi 16: LBA48 
[   61.468506] ata1.00: configured for UDMA/133
[   61.472815] scsi2 : ahci
[   61.956423] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   63.313888] SCSI device sda: 17774160 512-byte hdwr sectors (9100 MB)
[   63.322346] sda: Write Protect is off
[   63.327624] SCSI device sda: write cache: enabled, read cache: enabled, supports DPO and FUA
[   63.336862] SCSI device sda: 17774160 512-byte hdwr sectors (9100 MB)
[   63.345301] sda: Write Protect is off
[   63.350573] SCSI device sda: write cache: enabled, read cache: enabled, supports DPO and FUA
[   63.359052]  sda: sda1 sda2
[   63.368204] sd 0:0:1:0: Attached scsi disk sda
[   63.372724] sd 0:0:1:0: Attached scsi generic sg0 type 0
[   63.378877] SCSI device sdb: 17781520 512-byte hdwr sectors (9104 MB)
[   63.388720] sdb: Write Protect is off
[   63.396188] SCSI device sdb: write cache: enabled, read cache: enabled, supports DPO and FUA
[   63.405418] SCSI device sdb: 17781520 512-byte hdwr sectors (9104 MB)
[   63.415261] sdb: Write Protect is off
[   63.422729] SCSI device sdb: write cache: enabled, read cache: enabled, supports DPO and FUA
[   63.431207]  sdb: sdb1
[   63.439369] sd 0:0:2:0: Attached scsi disk sdb
[   63.443882] sd 0:0:2:0: Attached scsi generic sg1 type 0
[   91.977919] ata2.00: qc timeout (cmd 0xec)
[   91.982052] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   99.961107] ata2: port is slow to respond, please be patient (Status 0x80)
[  122.944722] ata2: port failed to respond (30 secs, Status 0x80)
[  122.950671] ata2: COMRESET failed (device not ready)
[  122.955668] ata2: hardreset failed, retrying in 5 secs
[  128.809132] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  128.819349] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
[  128.825389] ata2.00: 640 sectors, multi 1: LBA 
[  128.833945] ata2.00: configured for UDMA/133
[  128.838257] scsi3 : ahci
[  129.321984] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  129.332897] ata3.00: ATA-7: ST3250823AS, 3.03, max UDMA/133
[  129.338499] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[  129.350042] ata3.00: configured for UDMA/133
[  129.354345] scsi4 : ahci
[  129.677153] ata4: SATA link down (SStatus 0 SControl 300)
[  129.682627] scsi 1:0:0:0: Direct-Access     ATA      WDC WD360GD-00FL 31.0 PQ: 0 ANSI: 5
[  129.690802] SCSI device sdc: 72303840 512-byte hdwr sectors (37020 MB)
[  129.697364] sdc: Write Protect is off
[  129.701069] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  129.710083] SCSI device sdc: 72303840 512-byte hdwr sectors (37020 MB)
[  129.716645] sdc: Write Protect is off
[  129.720363] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  129.729358]  sdc: sdc1 sdc2
[  129.739045] sd 1:0:0:0: Attached scsi disk sdc
[  129.743567] sd 1:0:0:0: Attached scsi generic sg2 type 0
[  129.748955] scsi 2:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
[  129.757131] SCSI dev Adt6c0e 1sbse diwresctors (0 MB)
[  129.762910] sdd: Write rbocdt is off
[  129.766621] SCSI device sdd: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  129.775717] SCSI device sdd: 640 512-byte hdwr sectors (0 MB)
[  129.781507] sdd: Write Protect is off
[  129.785210] SCSI device sdd:rIite cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  129.794290]  sdd: unknown partition table
[  129.798563] sd 2:0:0:0: Attached scsi disk sdd
[  129.803079] sd 2:0:0:0: Atc2hed scsi generic sg3 type 0
[  129.808467] scsi 3:0:0:0: Direct-Access     ATA      ST3250823AS      3.03 PQ: 0 ANSI: 5
[  129.816646] SCSI device sde: 4881d6 :5-0byte hdwr sectors (250059 MB)
[  129.823386] sde: Write Protect is off
[  129.827093] SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  129.836109] SCSI device sde: 8s397168 512-byte hdwr sectors (250059 MB)
[  129.842841] sde: Write Protect is off
[  129.846550] SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or UPA[o  129.855545]  sde: sde1 sde2
[  129.869263] sd 3:0:0:0: Attached scsi disk sde
[  129.873780] sd 3:0:0:0: Attached scsi generic sg4 type 0
[  129.879170] sil680: BA5_EN = 1 clock = 00
[  129.883217] sil680: BA5_EN = 1 clock = 10
[  129.887268] sil680: 133MHz clock.
[  129.890627] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[  129.898128] ata5: PATA max UDMA/133 cmd 0x000000000001cc00 ctl 0x000000000001c882 bmdma 0x000000000001c400 irq 21
[  129.908445] ata6: PATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c482 bmdma 0x000000000001c408 irq 21
[  129.918751] scsi5 : pata_sil680
[  130.131948] ata5.00: ATA-0: SAMSUNG WN316025A (1.6 GB), GF102, max MWDMA2
[  130.138763] ata5.00: 3145968 sectors, multi 16: LBA 
[  130.165287] ata5.00: configured for MWDMA2
[  130.169424] scsi6 : pata_sil680
[  130.333105] ata6.00: ATA-5: MAXTOR 6L040J2, A93.0500, max UDMA/133
[  130.339316] ata6.00: 78198750 sectors, multi 16: LBA 
[  130.353083] ata6.00: configured for UDMA/133
[  130.357420] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG WN316025 GF10 PQ: 0 ANSI: 5
[  130.365596] SCSI device sdf: 3145968 512-byte hdwr sectors (1611 MB)
[  130.371984] sdf: Write Protect is off
[  130.375689] SCSI device sdf: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  130.384789] SCSI device sdf: 3145968 512-byte hdwr sectors (1611 MB)
[  130.391180] sdf: Write Protect is off
[  130.394887] SCSI device sdf: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  130.403967]  sdf: sdf1
[  130.418184] sd 5:0:0:0: Attached scsi disk sdf
[  130.422710] sd 5:0:0:0: Attached scsi generic sg5 type 0
[  130.428093] scsi 6:0:0:0: Direct-Access     ATA      MAXTOR 6L040J2   A93. PQ: 0 ANSI: 5
[  130.436271] SCSI device sdg: 78198750 512-byte hdwr sectors (40038 MB)
[  130.442832] sdg: Write Protect is off
[  130.446537] SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  130.455551] SCSI device sdg: 78198750 512-byte hdwr sectors (40038 MB)
[  130.462114] sdg: Write Protect is off
[  130.465827] SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  130.474826]  sdg: sdg1
[  130.478944] sd 6:0:0:0: Attached scsi disk sdg
[  130.483463] sd 6:0:0:0: Attached scsi generic sg6 type 0
[  130.488864] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[  130.495076] PNP: PS/2 controller doesn't have AUX irq; using default 12
[  130.504388] serio: i8042 KBD port at 0x60,0x64 irq 1
[  130.509402] serio: i8042 AUX port at 0x60,0x64 irq 12
[  130.514558] mice: PS/2 mouse device common for all mice
[  130.519845] async_tx: api initialized (async)
[  130.524246] xor: automatically using best checksumming function: generic_sse
[  130.547695]    generic_sse: 10130.400 MB/sec
[  130.552030] xor: using function: generic_sse (10130.400 MB/sec)
[  130.557990] input: AT Translated Set 2 keyboard as /class/input/input2
[  130.564612] EDAC MC: Ver: 2.0.1 Feb 16 2007
[  130.568926] TCP cubic registered
[  130.572190] Initializing XFRM netlink socket
[  130.576612] NET: Registered protocol family 1
[  130.581008] NET: Registered protocol family 17
[  130.585483] NET: Registered protocol family 15
[  130.590594] reiser4: sdc1: found disk format 4.0.0.
[  130.595510] Time: tsc clocksource has been installed.
[  131.821999] VFS: Mounted root (reiser4 filesystem) readonly.
[  131.827711] Freeing unused kernel memory: 208k freed
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[  133.701731] Floppy drive(s): fd0 is 1.44M
[  133.722536] FDC 0 is a post-1991 82077
[  133.806755] usbcore: registered new interface driver usbfs
[  133.812378] usbcore: registered new interface driver hub
[  133.817802] usbcore: registered new device driver usb
[  133.955923] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 23
[  133.966440] USB Universal Host Controller Interface driver v3.0
[  133.972576] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[  133.980195] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[  133.985658] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[  133.993204] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480
[  133.999117] usb usb1: new device found, idVendor=0000, idProduct=0000
[  133.999119] 8139too Fast Ethernet driver 0.9.28
[  134.010254] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[  134.017226] usb usb1: Product: UHCI Host Controller
[  134.022189] usb usb1: Manufacturer: Linux 2.6.20-mm1 uhci_hcd
[  134.028029] usb usb1: SerialNumber: 0000:00:1d.0
[  134.032854] usb usb1: configuration #1 chosen from 1 choice
[  134.038536] hub 1-0:1.0: USB hub found
[  134.042368] hub 1-0:1.0: 2 ports detected
[  134.147950] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[  134.155502] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[  134.160838] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[  134.168353] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800
[  134.174247] usb usb2: new device found, idVendor=0000, idProduct=0000
[  134.180781] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[  134.187747] usb usb2: Product: UHCI Host Controller
[  134.192710] usb usb2: Manufacturer: Linux 2.6.20-mm1 uhci_hcd
[  134.198535] usb usb2: SerialNumber: 0000:00:1d.1
[  134.203263] usb usb2: configuration #1 chosen from 1 choice
[  134.208931] hub 2-0:1.0: USB hub found
[  134.212743] hub 2-0:1.0: 2 ports detected
[  134.318294] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[  134.325890] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[  134.331213] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[  134.338738] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880
[  134.344592] usb usb3: new device found, idVendor=0000, idProduct=0000
[  134.351126] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
[  134.358087] usb usb3: Product: UHCI Host Controller
[  134.363047] usb usb3: Manufacturer: Linux 2.6.20-mm1 uhci_hcd
[  134.368893] usb usb3: SerialNumber: 0000:00:1d.2
[  134.373628] usb usb3: configuration #1 chosen from 1 choice
[  134.379287] usb 1-1: new low speed USB device using uhci_hcd and address 2
[  134.386312] hub 3-0:1.0: USB hub found
[  134.390134] hub 3-0:1.0: 2 ports detected
[  134.495629] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
[  134.503174] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[  134.508512] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[  134.516031] uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00
[  134.521880] usb usb4: new device found, idVendor=0000, idProduct=0000
[  134.528415] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
[  134.535394] usb usb4: Product: UHCI Host Controller
[  134.540369] usb usb4: Manufacturer: Linux 2.6.20-mm1 uhci_hcd
[  134.546210] usb usb4: SerialNumber: 0000:00:1d.3
[  134.550945] usb usb4: configuration #1 chosen from 1 choice
[  134.556628] hub 4-0:1.0: USB hub found
[  134.560450] hub 4-0:1.0: 2 ports detected
[  134.575606] usb 1-1: new device found, idVendor=045e, idProduct=001e
[  134.582050] usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[  134.588946] usb 1-1: Product: Microsoft IntelliMouse® Explorer
[  134.594869] usb 1-1: Manufacturer: Microsoft
[  134.599242] usb 1-1: configuration #1 chosen from 1 choice
[  134.607594] hub 1-1:1.0: USB hub found
[  134.619567] hub 1-1:1.0: config failed, can't read hub descriptor (err -22)
[  134.686359] ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 23 (level, low) -> IRQ 23
[  134.694516] eth0: RealTek RTL8139 at 0xffffc20000052800, 00:e0:4e:03:18:39, IRQ 23
[  134.707974] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19 (level, low) -> IRQ 19
[  134.716169] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[  134.870281] usb 1-2: new low speed USB device using uhci_hcd and address 3
[  135.036209] usb 1-2: new device found, idVendor=0d3d, idProduct=0001
[  135.042680] usb 1-2: new device strings: Mfr=0, Product=2, SerialNumber=0
[  135.049571] usb 1-2: Product: USBPS2
[  135.053293] usb 1-2: configuration #1 chosen from 1 choice
[  135.071200] hub 1-2:1.0: USB hub found
[  135.083162] hub 1-2:1.0: config failed, can't read hub descriptor (err -22)
[  135.096198] hub 1-2:1.1: USB hub found
[  135.108140] hub 1-2:1.1: config failed, can't read hub descriptor (err -22)
[  135.349926] usb 2-1: new full speed USB device using uhci_hcd and address 2
[  135.517078] usb 2-1: new device found, idVendor=07af, idProduct=0006
[  135.523529] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[  135.530444] usb 2-1: Product: DPCM-USB
[  135.534265] usb 2-1: Manufacturer: Microtech International, Inc
[  135.540382] usb 2-1: configuration #1 chosen from 1 choice
[  135.553073] hub 2-1:1.0: bad descriptor, ignoring hub
[  135.558223] hub: probe of 2-1:1.0 failed with error -5
[  135.571473] Initializing USB Mass Storage driver...
[  135.795307] usb 2-2: new full speed USB device using uhci_hcd and address 3
[  140.991272] usb 2-2: new device found, idVendor=03f0, idProduct=0102
[  140.997727] usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=3
[  141.004609] usb 2-2: Product: HP PhotoSmart C5101A - S20
[  141.009999] usb 2-2: Manufacturer: HEWLETT-PACKARD
[  141.014882] usb 2-2: SerialNumber: C0157308
[  141.019198] usb 2-2: configuration #1 chosen from 1 choice
[  141.027266] hub 2-2:1.0: bad descriptor, ignoring hub
[  141.032398] hub: probe of 2-2:1.0 failed with error -5
[  141.263832] usb 3-1: new full speed USB device using uhci_hcd and address 2
[  146.459973] usb 3-1: new device found, idVendor=03f0, idProduct=0401
[  146.466436] usb 3-1: new device strings: Mfr=1, Product=2, SerialNumber=3
[  146.473337] usb 3-1: Product: HP ScanJet 5200C
[  146.477858] usb 3-1: Manufacturer: Hewlett-Packard
[  146.482736] usb 3-1: SerialNumber: SG91U161Z2HT
[  146.487409] usb 3-1: configuration #1 chosen from 1 choice
[  146.495963] hub 3-1:1.0: bad descriptor, ignoring hub
[  146.501143] hub: probe of 3-1:1.0 failed with error -5
[  146.506492] usb-storage: probe of 1-1:1.0 failed with error -5
[  146.732344] usb 4-1: new full speed USB device using uhci_hcd and address 2
[  146.900032] usb 4-1: new device found, idVendor=05e3, idProduct=0606
[  146.906491] usb 4-1: new device strings: Mfr=0, Product=1, SerialNumber=0
[  146.913382] usb 4-1: Product: USB2.0 Hub
[  146.917437] usb 4-1: configuration #1 chosen from 1 choice
[  146.927032] hub 4-1:1.0: USB hub found
[  146.933004] hub 4-1:1.0: 4 ports detected
[  147.246728] usb 4-1.3: new full speed USB device using uhci_hcd and address 3
[  147.387604] usb 4-1.3: new device found, idVendor=0bda, idProduct=8187
[  147.394228] usb 4-1.3: new device strings: Mfr=1, Product=2, SerialNumber=3
[  147.401295] usb 4-1.3: Product: RTL8187_Wireless
[  147.405984] usb 4-1.3: Manufacturer: Manufacturer_Realtek_RTL8187_
[  147.412252] usb 4-1.3: SerialNumber: 0015AF09B434
[  147.417098] usb 4-1.3: configuration #1 chosen from 1 choice
[  147.428593] hub 4-1.3:1.0: bad descriptor, ignoring hub
[  147.433956] hub: probe of 4-1.3:1.0 failed with error -5
[  147.442576] usbcore: registered new interface driver hiddev
[  147.448355] usb-storage: probe of 1-2:1.0 failed with error -5
[  147.454328] usb-storage: probe of 1-2:1.1 failed with error -5
[  147.460269] usb-storage: probe of 2-1:1.0 failed with error -5
[  147.466324] usb-storage: probe of 2-2:1.0 failed with error -5
[  147.466363] input: Microsoft Microsoft IntelliMouse® Explorer as /class/input/input3
[  147.466386] input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Explorer] on usb-0000:00:1d.0-1
[  147.489918] usb-storage: probe of 3-1:1.0 failed with error -5
[  147.495871] usb-storage: probe of 4-1.3:1.0 failed with error -5
[  147.501988] usbcore: registered new interface driver usb-storage
[  147.502058] input: USBPS2 as /class/input/input4
[  147.502078] input: USB HID v1.00 Keyboard [USBPS2] on usb-0000:00:1d.0-2
[  147.519593] USB Mass Storage support registered.
[  147.538372] input: USBPS2 as /class/input/input5
[  147.543103] input: USB HID v1.00 Mouse [USBPS2] on usb-0000:00:1d.0-2
[  147.549772] usbcore: registered new interface driver usbhid
[  147.555440] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
done.
Setting parameters of disc: (none).
Activating swap:swapon on /dev/sdc2
[  148.226072] Adding 1959920k swap on /dev/sdc2.  Priority:-1 extents:1 across:1959920k
.
Will now check root file system:fsck 1.40-WIP (14-Nov-2006)
[/sbin/fsck.reiser4 (1) -- /] fsck.reiser4 -a /dev/sdc1 
fsck.reiser4 /dev/sdc1 
.
Setting the system clock..
System Clock set. Local time: Fri Feb 16 17:47:43 MST 2007.
Cleaning up ifupdown....
Loading kernel module nvidia.
[  149.135709] nvidia: module license 'NVIDIA' taints kernel.
[  149.395553] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[  149.403157] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
Loading kernel module 8139too.
Loading kernel module i2c-i801.
Loading kernel module i2c-isa.
Loading kernel module eeprom.
Loading kernel module w83627ehf.
Loading kernel module snd-rtctimer.
Loading kernel module cdc-acm.
[  149.525742] Unable to handle kernel NULL pointer dereference at 0000000000000008 RIP: 
[  149.531302]  [<ffffffff8887eec3>] :cdc_acm:acm_probe+0x1dd/0x741
[  149.539958] PGD 3d248067 PUD 3d23c067 PMD 0 
[  149.544431] Oops: 0000 [1] PREEMPT SMP 
[  149.548475] last sysfs file: /class/net/lo/operstate
[  149.553510] CPU 0 
[  149.555618] Modules linked in: cdc_acm snd_rtctimer w83627ehf eeprom i2c_isa nvidia(P) usb_storage usbhid 8139cp snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd 8139too uhci_hcd mii soundcore snd_page_alloc i2c_i801 evdev usbcore i2c_core floppy
[  149.587337] Pid: 1620, comm: modprobe Tainted: P       2.6.20-mm1 #3
[  149.593785] RIP: 0010:[<ffffffff8887eec3>]  [<ffffffff8887eec3>] :cdc_acm:acm_probe+0x1dd/0x741
[  149.602650] RSP: 0018:ffff81003df29c98  EFLAGS: 00010246
[  149.608045] RAX: ffff81003eb14800 RBX: ffff81003eb14820 RCX: ffff81003eb21008
[  149.615278] RDX: ffff81003eb14800 RSI: 0000000000000000 RDI: 0000000000000000
[  149.622507] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffff88880d80
[  149.629730] R10: 0000000000000000 R11: ffffc2000019a7f8 R12: ffffffff88880d80
[  149.636960] R13: ffff81003f555800 R14: 0000000000000000 R15: ffff81003eb14800
[  149.644183] FS:  00002abc668716d0(0000) GS:ffffffff80544000(0000) knlGS:0000000000000000
[  149.652393] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.658217] CR2: 0000000000000008 CR3: 000000003d25d000 CR4: 00000000000006e0
[  149.665458] Process modprobe (pid: 1620, threadinfo ffff81003df28000, task ffff81003eeb0950)
[  149.674014] Stack:  ffff81003d21af20 ffff81003eb14800 ffff81003edf3418 ffff81003d21af20
[  149.682317]  00000000fffffff4 ffff81003d4e3820 00ffffff804db922 0000000000000001
[  149.689981]  0000001088880db0 ffff81003d21af20 ffffffff8801cbe5 ffff81003eb14820
[  149.697455] Call Trace:
[  149.700194]  [<ffffffff8801cbe5>] :usbcore:usb_match_one_id+0x26/0x84
[  149.706742]  [<ffffffff8801d78e>] :usbcore:usb_probe_interface+0x7d/0xa5
[  149.713544]  [<ffffffff8039ac88>] driver_probe_device+0xf6/0x17f
[  149.719654]  [<ffffffff8039ad94>] __driver_attach+0x0/0x93
[  149.725230]  [<ffffffff8039adee>] __driver_attach+0x5a/0x93
[  149.730893]  [<ffffffff8039a14e>] bus_for_each_dev+0x43/0x6e
[  149.736644]  [<ffffffff8039a48e>] bus_add_driver+0x6b/0x18d
[  149.742310]  [<ffffffff8801d2b0>] :usbcore:usb_register_driver+0x85/0xeb
[  149.749113]  [<ffffffff880560cc>] :cdc_acm:acm_init+0xcc/0x105
[  149.755037]  [<ffffffff8028dd0b>] sys_init_module+0x1572/0x16d2
[  149.761058]  [<ffffffff802561ce>] system_call+0x7e/0x83
[  149.766361] 
[  149.767898] 
[  149.767898] Code: 49 8b 46 08 80 78 05 0a 74 17 49 8b 47 08 80 78 05 0a 0f 85 
[  149.777661] RIP  [<ffffffff8887eec3>] :cdc_acm:acm_probe+0x1dd/0x741
[  149.784146]  RSP <ffff81003df29c98>
[  149.787694] CR2: 0000000000000008
/etc/rcS.d/S20module-init-tools: line 36:  1620 Killed                  modprobe $module $args
Loading kernel module uhci-hcd.
Loading device-mapper support.
Will now check all file systems.
fsck 1.40-WIP (14-Nov-2006)
Checking all file systems.
Done checking file systems. 
A log is being saved in /var/log/fsck/checkfs if that location is writable.
Setting kernel variables...done.
Will now mount local filesystems:[  149.933025] ReiserFS: sde1: found reiserfs format "3.6" with standard journal
[  149.940270] ReiserFS: sde1: using ordered data mode
[  149.952096] ReiserFS: sde1: journal params: device sde1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[  149.967046] ReiserFS: sde1: checking transaction log (sde1)
[  150.037062] ReiserFS: sde1: Using r5 hash to sort names
[  150.090239] reiser4: sda1: found disk format 4.0.0.
[  150.384581] logsave[1509]: segfault at 0000000000000000 rip 0000000000000000 rsp 00007fff8ed0f858 error 4
.
Will now activate swapfile swap:done.
Cleaning /tmp...done.
Cleaning /var/run...done.
Cleaning /var/lock...done.
Setting up networking....
Configuring network interfaces...[  151.161091] eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
done.
Starting portmap daemon....
Setting sensors limits: done.
Setting console screen modes and fonts.
Setting up ALSA...done.
Initializing random number generator...done.
Recovering nvi editor sessions...none found.
Setting up X server socket directory /tmp/.X11-unix....
Setting up ICE socket directory /tmp/.ICE-unix....
Recovering schroot sessions:.
INIT: Entering runlevel: 2
Starting system log daemon....
Starting kernel log daemon....
Loading ACPI modules:
Starting Advanced Configuration and Power Interface daemon: acpid.
Starting Common Unix Printing System: cupsd.
Starting system message bus: dbus.
Starting Hardware abstraction layer: hald.
Starting Avahi mDNS/DNS-SD Daemon: avahi-daemon.
Starting DirMngr: dirmngr.
Starting mouse interface server: gpm.
Starting disk temperature monitoring daemon: hddtemp:[  159.061948] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  159.068493] ata2.00: (irq_stat 0x40000001)
[  159.072676] ata2.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 0 
[  159.072677]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  159.096306] ata2.00: configured for UDMA/133
[  159.100653] ata2: EH complete
[  159.103721] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  159.110296] ata2.00: (irq_stat 0x40000001)
[  159.114462] ata2.00: cmd b0/d0:01:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
[  159.114463]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  159.138409] ata2.00: configured for UDMA/133
[  159.142760] ata2: EH complete
[  159.145849] SCSI device sdd: 640 512-byte hdwr sectors (0 MB)
[  159.151703] sdd: Write Protect is off
[  159.155437] sdd: Mode Sense: 00 3a 00 00
[  159.159465] SCSI device sdd: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  159.168688] SCSI device sdd: 640 512-byte hdwr sectors (0 MB)
[  159.174533] sdd: Write Protect is off
[  159.178276] sdd: Mode Sense: 00 3a 00 00
[  159.182284] SCSI device sdd: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  /dev/sdc /dev/sde /dev/sdg..
Starting internet superserver: inetd.
Starting Postfix Mail Transport Agent: postfix.
Starting Samba daemons: nmbd smbd.
Starting sensor daemon: sensord.
Starting OpenBSD Secure Shell server: sshd.
Setting up X font server socket directory /tmp/.font-unix...done.
Starting X font server: xfs.
Starting NFS common utilities: statd.
Starting NTP server: ntpd.
Starting deferred execution scheduler: atd.
Starting periodic command scheduler: crond.
Starting MLDonkey: mlnet configuration file prevent mlnet to be started (use force-start).
Starting K Display Manager: kdm.
Running local boot scripts (/etc/rc.local).

Debian GNU/Linux 4.0 luna ttyS0

luna login: [  164.079044] I2C adapter driver [NVIDIA i2c adapter 0 at 3:00.0] forgot to specify physical device
[  164.088018]  i2c-1: adapter [NVIDIA i2c adapter 0 at 3:00.0] registered
[  164.094691]  i2c-1: found normal entry for adapter 1, addr 0x50
[  164.100653]  i2c-1: found normal entry for adapter 1, addr 0x51
[  164.106621]  i2c-1: found normal entry for adapter 1, addr 0x52
[  164.112606]  i2c-1: found normal entry for adapter 1, addr 0x53
[  164.118596]  i2c-1: found normal entry for adapter 1, addr 0x54
[  164.124560]  i2c-1: found normal entry for adapter 1, addr 0x55
[  164.130528]  i2c-1: found normal entry for adapter 1, addr 0x56
[  164.136504]  i2c-1: found normal entry for adapter 1, addr 0x57
[  164.142471]  i2c-1: attach_adapter failed (-16) for driver [w83627ehf]
[  164.149060] I2C adapter driver [NVIDIA i2c adapter 1 at 3:00.0] forgot to specify physical device
[  164.158004]  i2c-2: adapter [NVIDIA i2c adapter 1 at 3:00.0] registered
[  164.164690]  i2c-2: found normal entry for adapter 2, addr 0x50
[  164.170665]  i2c-2: found normal entry for adapter 2, addr 0x51
[  164.176627]  i2c-2: found normal entry for adapter 2, addr 0x52
[  164.182606]  i2c-2: found normal entry for adapter 2, addr 0x53
[  164.188589]  i2c-2: found normal entry for adapter 2, addr 0x54
[  164.194556]  i2c-2: found normal entry for adapter 2, addr 0x55
[  164.200518]  i2c-2: found normal entry for adapter 2, addr 0x56
[  164.206494]  i2c-2: found normal entry for adapter 2, addr 0x57
[  164.212478]  i2c-2: attach_adapter failed (-16) for driver [w83627ehf]
[  164.219051] I2C adapter driver [NVIDIA i2c adapter 2 at 3:00.0] forgot to specify physical device
[  164.228003]  i2c-3: adapter [NVIDIA i2c adapter 2 at 3:00.0] registered
[  164.234688]  i2c-3: found normal entry for adapter 3, addr 0x50
[  164.240661]  i2c-3: found normal entry for adapter 3, addr 0x51
[  164.246629]  i2c-3: found normal entry for adapter 3, addr 0x52
[  164.252612]  i2c-3: found normal entry for adapter 3, addr 0x53
[  164.258587]  i2c-3: found normal entry for adapter 3, addr 0x54
[  164.264560]  i2c-3: found normal entry for adapter 3, addr 0x55
[  164.270536]  i2c-3: found normal entry for adapter 3, addr 0x56
[  164.276510]  i2c-3: found normal entry for adapter 3, addr 0x57
[  164.282486]  i2c-3: attach_adapter failed (-16) for driver [w83627ehf]

--------------060901040000070608050603--
