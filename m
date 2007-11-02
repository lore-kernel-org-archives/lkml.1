Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXKBVRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXKBVRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXKBVRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:17:03 -0400
Received: from msgbas2x.cos.agilent.com ([192.25.240.37]:63343 "EHLO
	msgbas2x.cos.agilent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbXKBVQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:16:57 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: PROBLEM:  fakephp hangs terminal in 2.6.22 (and 2.6.21), does not Hot Plug
Date: Fri, 2 Nov 2007 15:16:53 -0600
Message-ID: <BD63C848ECB98D4582D05FFF2C79CFF2478356@cos-us-mb01.cos.agilent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM:  fakephp hangs terminal in 2.6.22 (and 2.6.21), does not Hot Plug
Thread-Index: AcgdlbEkmRmY07ZbTeeBGOLsVwqWig==
From: <john_flowers@agilent.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Nov 2007 21:16:54.0973 (UTC) FILETIME=[B1C2DED0:01C81D95]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "Fake" PCI Hot Plug module fakephp does not complete the slot shutdown and will hang a terminal. 


I am attempting to use the fakephp module to shutdown and restart a PCI Express FPGA board when the FPGA is reloaded. Using 2.6.22 (Ubuntu 7.10) or 2.6.21 (Fedora Core 7) I cannot get this functionality to work. Sending a '1' to the power file causes no change or debug output in dmesg and sending a '0' causes the terminal to hang. Please CC me as I am not subscribed to the mailing list.

Keywords: linux kernel module PCI

Linux nsafm01 2.6.21-1.3194.fc7 #1 SMP Wed May 23 22:35:01 EDT 2007 i686 i686 i386 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.12-4
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre11
e2fsprogs              1.39
pcmciautils            014
quota-tools            3.14.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        > libc.2.6
Dynamic linker (ldd)   2.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   106
wireless-tools         28
Modules Loaded         fakephp i915 drm autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand acpi_cpufreq dm_multipath video sbs i2c_ec button dock battery ac ipv6 lp loop snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sr_mod fw_ohci cdrom serio_raw snd_timer iTCO_wdt parport_pc snd iTCO_vendor_support fw_core ata_generic parport i2c_i801 i2c_core e1000 soundcore pcspkr snd_page_alloc sg dm_snapshot dm_zero dm_mirror dm_mod pata_marvell ahci libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd

How to reproduce:

modprobe fakephp debug=1
echo 8 > /proc/sysrq-trigger
echo -n 0 > /sys/bus/pci/slots ... & (wanted to get the command line back)
alt-sysrq-t
dmesg 


[    0.000000] Linux version 2.6.22-14-generic (buildd@palmer) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun Oct 14 23:05:12 GMT 2007 (Ubuntu 2.6.22-14.46-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003e561000 (usable)
[    0.000000]  BIOS-e820: 000000003e561000 - 000000003e56e000 (reserved)
[    0.000000]  BIOS-e820: 000000003e56e000 - 000000003e61d000 (usable)
[    0.000000]  BIOS-e820: 000000003e61d000 - 000000003e6e9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003e6e9000 - 000000003e6ed000 (usable)
[    0.000000]  BIOS-e820: 000000003e6ed000 - 000000003e6f2000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003e6f2000 - 000000003e6f3000 (usable)
[    0.000000]  BIOS-e820: 000000003e6f3000 - 000000003e6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003e6ff000 - 000000003e700000 (usable)
[    0.000000]  BIOS-e820: 000000003e700000 - 000000003f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] 103MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe200
[    0.000000] Entering add_active_range(0, 0, 255744) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   255744
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   255744
[    0.000000] On node 0 totalpages: 255744
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 206 pages used for memmap
[    0.000000]   HighMem zone: 26162 pages, LIFO batch:7
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xC00FE020 checksum 0
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 3E6FD038, 004C (r1 INTEL  DG965RY       697       1000013)
[    0.000000] ACPI: FACP 3E6FC000, 0074 (r1 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: DSDT 3E6F7000, 40ED (r1 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: FACS 3E6A0000, 0040
[    0.000000] ACPI: APIC 3E6F6000, 0078 (r1 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: WDDT 3E6F5000, 0040 (r1 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: MCFG 3E6F4000, 003C (r1 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: ASF! 3E6F3000, 00A6 (r32 INTEL  DG965RY       697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6F1000, 01BC (r1 INTEL     CpuPm      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6F0000, 0175 (r1 INTEL   Cpu0Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6EF000, 0175 (r1 INTEL   Cpu1Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6EE000, 0175 (r1 INTEL   Cpu2Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6ED000, 0175 (r1 INTEL   Cpu3Ist      697 MSFT  1000013)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f000000:c0f00000)
[    0.000000] Built 1 zonelists.  Total pages: 253746
[    0.000000] Kernel command line: root=UUID=7b59a6d3-7a2f-43f6-9787-c8fddc2479c9 ro single
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2131.356 MHz processor.
[   14.835837] Console: colour VGA+ 80x25
[   14.838853] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   14.839129] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   14.861931] Memory: 1001228k/1022976k available (2015k kernel code, 20048k reserved, 916k data, 364k init, 104536k highmem)
[   14.862010] virtual kernel memory layout:
[   14.862011]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   14.862011]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   14.862012]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   14.862013]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   14.862014]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   14.862015]       .data : 0xc02f7d26 - 0xc03dce84   ( 916 kB)
[   14.862016]       .text : 0xc0100000 - 0xc02f7d26   (2015 kB)
[   14.862370] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   14.862478] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   14.942483] Calibrating delay using timer specific routine.. 4265.73 BogoMIPS (lpj=8531476)
[   14.942585] Security Framework v1.0.0 initialized
[   14.942631] SELinux:  Disabled at boot.
[   14.942682] Mount-cache hash table entries: 512
[   14.942810] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   14.942816] monitor/mwait feature present.
[   14.942860] using mwait in idle threads.
[   14.942903] CPU: L1 I cache: 32K, L1 D cache: 32K
[   14.942965] CPU: L2 cache: 4096K
[   14.943006] CPU: Physical Processor ID: 0
[   14.943049] CPU: Processor Core ID: 0
[   14.943090] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   14.943097] Compat vDSO mapped to ffffe000.
[   14.943148] Checking 'hlt' instruction... OK.
[   14.958595] SMP alternatives: switching to UP code
[   14.958960] Early unpacking initramfs... done
[   15.223928] ACPI: Core revision 20070126
[   15.224002] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   15.226793] CPU0: Intel(R) Core(TM)2 CPU          6420  @ 2.13GHz stepping 06
[   15.226890] SMP alternatives: switching to SMP code
[   15.226986] Booting processor 1/1 eip 3000
[   15.237336] Initializing CPU#1
[   15.314132] Calibrating delay using timer specific routine.. 4262.73 BogoMIPS (lpj=8525476)
[   15.314137] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   15.314141] monitor/mwait feature present.
[   15.314143] CPU: L1 I cache: 32K, L1 D cache: 32K
[   15.314145] CPU: L2 cache: 4096K
[   15.314146] CPU: Physical Processor ID: 0
[   15.314148] CPU: Processor Core ID: 1
[   15.314149] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   15.314763] CPU1: Intel(R) Core(TM)2 CPU          6420  @ 2.13GHz stepping 06
[   15.315169] Total of 2 processors activated (8528.47 BogoMIPS).
[   15.315351] ENABLING IO-APIC IRQs
[   15.315555] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   15.462076] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   15.482137] Brought up 2 CPUs
[   15.592964] migration_cost=50
[   15.593154] Booting paravirtualized kernel on bare hardware
[   15.593249] Time: 21:43:57  Date: 09/31/107
[   15.593305] NET: Registered protocol family 16
[   15.593414] EISA bus registered
[   15.593457] ACPI: bus type pci registered
[   15.594942] PCI: Using configuration type 1
[   15.594984] Setting up standard PCI resources
[   15.601220] ACPI: EC: Look up EC in DSDT
[   15.602776] ACPI: Interpreter enabled
[   15.602819] ACPI: (supports S0 S3 S4 S5)
[   15.602961] ACPI: Using IOAPIC for interrupt routing
[   15.606673] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   15.606735] PCI: Probing PCI hardware (bus 00)
[   15.607388] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[   15.607437] PCI quirk: region 0500-053f claimed by ICH6 GPIO
[   15.608058] PCI: Transparent bridge - 0000:00:1e.0
[   15.608161] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   15.608439] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[   15.608644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   15.608728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[   15.608811] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[   15.608893] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[   15.608975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   15.612546] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[   15.612846] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[   15.613144] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[   15.613443] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[   15.613741] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[   15.614066] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[   15.614366] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[   15.614666] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[   15.614983] Linux Plug and Play Support v0.97 (c) Adam Belay
[   15.615035] pnp: PnP ACPI init
[   15.615082] ACPI: bus type pnp registered
[   15.617115] pnp: PnP ACPI: found 12 devices
[   15.617159] ACPI: ACPI bus type pnp unregistered
[   15.617204] PnPBIOS: Disabled by ACPI PNP
[   15.617275] PCI: Using ACPI for IRQ routing
[   15.617318] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   15.617455] NET: Registered protocol family 8
[   15.617498] NET: Registered protocol family 20
[   15.617579] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
[   15.617629] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[   15.617678] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[   15.617727] pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[   15.617780] pnp: 00:06: ioport range 0x500-0x53f has been reserved
[   15.617827] pnp: 00:06: ioport range 0x400-0x47f has been reserved
[   15.617875] Time: tsc clocksource has been installed.
[   15.617941] pnp: 00:06: ioport range 0x680-0x6ff has been reserved
[   15.648197] PCI: Bridge: 0000:00:1c.0
[   15.648238]   IO window: disabled.
[   15.648282]   MEM window: disabled.
[   15.648324]   PREFETCH window: disabled.
[   15.648369] PCI: Bridge: 0000:00:1c.1
[   15.648411]   IO window: 1000-1fff
[   15.648455]   MEM window: 50100000-501fffff
[   15.648499]   PREFETCH window: disabled.
[   15.648543] PCI: Bridge: 0000:00:1c.2
[   15.648584]   IO window: disabled.
[   15.648627]   MEM window: disabled.
[   15.648670]   PREFETCH window: disabled.
[   15.648714] PCI: Bridge: 0000:00:1c.3
[   15.648755]   IO window: disabled.
[   15.648798]   MEM window: disabled.
[   15.648840]   PREFETCH window: disabled.
[   15.648884] PCI: Bridge: 0000:00:1c.4
[   15.648926]   IO window: disabled.
[   15.648969]   MEM window: disabled.
[   15.649011]   PREFETCH window: disabled.
[   15.649056] PCI: Bridge: 0000:00:1e.0
[   15.649097]   IO window: disabled.
[   15.649140]   MEM window: 50000000-500fffff
[   15.649184]   PREFETCH window: disabled.
[   15.649242] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
[   15.649328] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   15.649343] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 17
[   15.649428] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   15.649442] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   15.650146] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   15.650160] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[   15.650245] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   15.650258] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 16
[   15.650343] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   15.650352] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   15.650359] NET: Registered protocol family 2
[   15.690011] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   15.690106] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[   15.690691] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   15.690909] TCP: Hash tables configured (established 131072 bind 65536)
[   15.690957] TCP reno registered
[   15.702165] checking if image is initramfs... it is
[   16.145786] Switched to high resolution mode on CPU 1
[   16.149629] Switched to high resolution mode on CPU 0
[   16.229027] Freeing initrd memory: 7333k freed
[   16.229562] audit: initializing netlink socket (disabled)
[   16.229621] audit(1193867037.136:1): initialized
[   16.229740] highmem bounce pool size: 64 pages
[   16.231293] VFS: Disk quotas dquot_6.5.1
[   16.231369] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   16.231481] io scheduler noop registered
[   16.231523] io scheduler anticipatory registered
[   16.231567] io scheduler deadline registered
[   16.231618] io scheduler cfq registered (default)
[   16.231672] Boot video device is 0000:00:02.0
[   16.232027] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   16.232062] assign_interrupt_mode Found MSI capability
[   16.232107] Allocate Port Service[0000:00:1c.0:pcie00]
[   16.232135] Allocate Port Service[0000:00:1c.0:pcie02]
[   16.232200] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   16.232234] assign_interrupt_mode Found MSI capability
[   16.232279] Allocate Port Service[0000:00:1c.1:pcie00]
[   16.232304] Allocate Port Service[0000:00:1c.1:pcie02]
[   16.232367] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   16.232400] assign_interrupt_mode Found MSI capability
[   16.232446] Allocate Port Service[0000:00:1c.2:pcie00]
[   16.232471] Allocate Port Service[0000:00:1c.2:pcie02]
[   16.232535] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   16.232568] assign_interrupt_mode Found MSI capability
[   16.232613] Allocate Port Service[0000:00:1c.3:pcie00]
[   16.232638] Allocate Port Service[0000:00:1c.3:pcie02]
[   16.232701] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   16.232734] assign_interrupt_mode Found MSI capability
[   16.232779] Allocate Port Service[0000:00:1c.4:pcie00]
[   16.232805] Allocate Port Service[0000:00:1c.4:pcie02]
[   16.232921] isapnp: Scanning for PnP cards...
[   16.585494] isapnp: No Plug & Play device found
[   16.601613] Real Time Clock Driver v1.12ac
[   16.601736] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   16.601882] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.602420] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.602970] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   16.603132] input: Macintosh mouse button emulation as /class/input/input0
[   16.603244] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   16.606161] serio: i8042 KBD port at 0x60,0x64 irq 1
[   16.606208] serio: i8042 AUX port at 0x60,0x64 irq 12
[   16.606333] mice: PS/2 mouse device common for all mice
[   16.606459] EISA: Probing bus 0 at eisa.0
[   16.606505] Cannot allocate resource for EISA slot 1
[   16.606549] Cannot allocate resource for EISA slot 2
[   16.606611] EISA: Detected 0 cards.
[   16.606711] TCP cubic registered
[   16.606761] NET: Registered protocol family 1
[   16.606818] Using IPI No-Shortcut mode
[   16.606994]   Magic number: 11:268:754
[   16.607226] Freeing unused kernel memory: 364k freed
[   16.636900] input: AT Translated Set 2 keyboard as /class/input/input1
[   16.757231] AppArmor: AppArmor initialized<5>audit(1193867037.636:2):  type=1505 info="AppArmor initialized" pid=1211
[   16.763188] fuse init (API version 7.8)
[   16.767265] Failure registering capabilities with primary security module.
[   16.799788] ACPI: Processor [CPU0] (supports 8 throttling states)
[   16.799931] ACPI: Processor [CPU1] (supports 8 throttling states)
[   16.800020] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   16.800132] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   17.111050] usbcore: registered new interface driver usbfs
[   17.111117] usbcore: registered new interface driver hub
[   17.111176] usbcore: registered new device driver usb
[   17.111765] USB Universal Host Controller Interface driver v3.0
[   17.111855] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 17
[   17.111944] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   17.111947] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   17.112084] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   17.112171] uhci_hcd 0000:00:1a.0: irq 17, io base 0x000020a0
[   17.112290] usb usb1: configuration #1 chosen from 1 choice
[   17.112356] hub 1-0:1.0: USB hub found
[   17.112419] hub 1-0:1.0: 2 ports detected
[   17.113638] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   17.113687] Copyright (c) 1999-2006 Intel Corporation.
[   17.155125] SCSI subsystem initialized
[   17.158856] libata version 2.21 loaded.
[   17.216573] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 20
[   17.216667] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   17.216670] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   17.216817] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[   17.216904] uhci_hcd 0000:00:1a.1: irq 20, io base 0x00002080
[   17.217187] usb usb2: configuration #1 chosen from 1 choice
[   17.217336] hub 2-0:1.0: USB hub found
[   17.217380] hub 2-0:1.0: 2 ports detected
[   17.320319] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
[   17.320414] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.320418] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.320489] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[   17.320575] uhci_hcd 0000:00:1d.0: irq 21, io base 0x00002060
[   17.320689] usb usb3: configuration #1 chosen from 1 choice
[   17.320752] hub 3-0:1.0: USB hub found
[   17.320797] hub 3-0:1.0: 2 ports detected
[   17.424193] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   17.424286] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.424289] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.424360] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[   17.424446] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
[   17.424562] usb usb4: configuration #1 chosen from 1 choice
[   17.424627] hub 4-0:1.0: USB hub found
[   17.424672] hub 4-0:1.0: 2 ports detected
[   17.528087] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   17.528180] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   17.528183] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.528253] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[   17.528338] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
[   17.528452] usb usb5: configuration #1 chosen from 1 choice
[   17.528518] hub 5-0:1.0: USB hub found
[   17.528562] hub 5-0:1.0: 2 ports detected
[   17.632086] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 22
[   17.632188] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   17.660571] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:19:d1:a9:df:5c
[   17.749723] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   17.749814] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   17.749904] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   17.749907] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   17.749972] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[   17.750058] ehci_hcd 0000:00:1a.7: debug port 1
[   17.750105] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   17.750110] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x50325400
[   17.754027] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.754152] usb usb6: configuration #1 chosen from 1 choice
[   17.754217] hub 6-0:1.0: USB hub found
[   17.754263] hub 6-0:1.0: 4 ports detected
[   17.855793] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
[   17.855886] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   17.855890] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.855963] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[   17.856048] ehci_hcd 0000:00:1d.7: debug port 1
[   17.856095] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   17.856099] ehci_hcd 0000:00:1d.7: irq 21, io mem 0x50325000
[   17.860030] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.860148] usb usb7: configuration #1 chosen from 1 choice
[   17.860212] hub 7-0:1.0: USB hub found
[   17.860257] hub 7-0:1.0: 6 ports detected
[   17.963688] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   18.013492] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[50004000-500047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.014802] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 16
[   18.014907] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   18.014954] scsi0 : pata_marvell
[   18.015026] scsi1 : pata_marvell
[   18.015086] ata1: PATA max UDMA/100 cmd 0x00011018 ctl 0x00011026 bmdma 0x00011000 irq 16
[   18.015155] ata2: DUMMY
[   18.015209] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   18.351548] ata1.00: ATAPI: ATAPI   DVD D  DH16D2P, HP53, max UDMA/33
[   18.539363] ata1.00: configured for UDMA/33
[   18.540710] scsi 0:0:0:0: CD-ROM            ATAPI    DVD D  DH16D2P   HP53 PQ: 0 ANSI: 5
[   18.541081] ata_piix 0000:00:1f.2: version 2.11
[   18.541086] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   18.541237] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[   18.541339] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   18.541359] scsi2 : ata_piix
[   18.541507] scsi3 : ata_piix
[   18.541702] ata3: SATA max UDMA/133 cmd 0x00012438 ctl 0x00012456 bmdma 0x00012410 irq 19
[   18.541769] ata4: SATA max UDMA/133 cmd 0x00012430 ctl 0x00012452 bmdma 0x00012418 irq 19
[   18.552846] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[   18.552897] Uniform CD-ROM driver Revision: 3.20
[   18.553089] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   18.555905] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   18.744293] ata3.00: ATA-7: ST380815AS, 3.AAD, max UDMA/133
[   18.744345] ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   18.810856] ata3.00: configured for UDMA/133
[   18.977245] scsi 2:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
[   18.977350] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[   18.977412] ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
[   18.977561] ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 19 (level, low) -> IRQ 19
[   18.977663] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   18.977907] scsi4 : ata_piix
[   18.978048] scsi5 : ata_piix
[   18.978143] ata5: SATA max UDMA/133 cmd 0x00012428 ctl 0x0001244e bmdma 0x000120f0 irq 19
[   18.978211] ata6: SATA max UDMA/133 cmd 0x00012420 ctl 0x0001244a bmdma 0x000120f8 irq 19
[   19.282357] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001e88fa8]
[   19.310378] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   19.310435] sd 2:0:0:0: [sda] Write Protect is off
[   19.310480] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   19.310492] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.310592] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   19.310647] sd 2:0:0:0: [sda] Write Protect is off
[   19.310691] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   19.310702] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.310771]  sda: sda1 sda2 < sda5 >
[   19.357488] sd 2:0:0:0: [sda] Attached SCSI disk
[   19.549675] Attempting manual resume
[   19.549718] swsusp: Resume From Partition 8:5
[   19.549719] PM: Checking swsusp image.
[   19.549849] PM: Resume from disk failed.
[   19.588671] kjournald starting.  Commit interval 5 seconds
[   19.588676] EXT3-fs: mounted filesystem with ordered data mode.
[   25.576460] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   25.576551] e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
[   26.234549] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   26.344622] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   26.497818] Linux agpgart interface v0.102 (c) Dave Jones
[   26.591520] heci: Intel(R) AMT Management Interface - version 3.1.0.31
[   26.591573] heci: Copyright (c) 2003 - 2007 Intel Corporation.
[   26.591650] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 17
[   26.591744] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   26.592474] heci: link layer has been established.
[   26.695144] heci: heci driver initialization successful.
[   26.734139] iTCO_vendor_support: vendor-support=0
[   26.734905] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   26.735019] iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0460)
[   26.735120] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   26.771482] NET: Registered protocol family 10
[   26.771591] lo: Disabled Privacy Extensions
[   26.776899] input: PC Speaker as /class/input/input2
[   26.857119] agpgart: Detected an Intel 965G Chipset.
[   26.858768] agpgart: Detected 7676K stolen memory.
[   26.871061] agpgart: AGP aperture is 256M @ 0x40000000
[   27.067329] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 23
[   27.067436] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   27.457993] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[   27.460451] parport_pc 00:07: reported by Plug and Play ACPI
[   27.460586] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   28.470573] lp0: using parport0 (interrupt-driven).
[   28.528800] Adding 2955920k swap on /dev/sda5.  Priority:-1 extents:1 across:2955920k
[   28.770849] EXT3 FS on sda1, internal journal
[   36.980850] eth0: no IPv6 routers present
[   44.520564] fakephp: Fake PCI Hot Plug Controller Driver
[   44.520567] fakephp: slot->name = 0000:00:00.0
[   44.520578] fakephp: slot->name = 0000:00:02.0
[   44.520585] fakephp: slot->name = 0000:00:03.0
[   44.520593] fakephp: slot->name = 0000:00:19.0
[   44.520601] fakephp: slot->name = 0000:00:1a.0
[   44.520610] fakephp: slot->name = 0000:00:1a.1
[   44.520617] fakephp: slot->name = 0000:00:1a.7
[   44.520624] fakephp: slot->name = 0000:00:1b.0
[   44.520631] fakephp: slot->name = 0000:00:1c.0
[   44.520639] fakephp: slot->name = 0000:00:1c.1
[   44.520646] fakephp: slot->name = 0000:00:1c.2
[   44.520653] fakephp: slot->name = 0000:00:1c.3
[   44.520660] fakephp: slot->name = 0000:00:1c.4
[   44.520667] fakephp: slot->name = 0000:00:1d.0
[   44.520674] fakephp: slot->name = 0000:00:1d.1
[   44.520681] fakephp: slot->name = 0000:00:1d.2
[   44.520688] fakephp: slot->name = 0000:00:1d.7
[   44.520697] fakephp: slot->name = 0000:00:1e.0
[   44.520705] fakephp: slot->name = 0000:00:1f.0
[   44.520713] fakephp: slot->name = 0000:00:1f.2
[   44.520720] fakephp: slot->name = 0000:00:1f.3
[   44.520728] fakephp: slot->name = 0000:00:1f.5
[   44.520737] fakephp: slot->name = 0000:02:00.0
[   44.520744] fakephp: slot->name = 0000:06:03.0
[   71.408043] SysRq : Changing Loglevel
[   71.408109] Loglevel set to 8
[   83.457370] fakephp: disable_slot - physical_slot = 0000:06:03.0
[   83.457433] fakephp: No device in slot found
[   83.457475] fakephp: No device in slot found
[   83.457519] fakephp: No device in slot found
[   83.457561] fakephp: No device in slot found
[   83.457604] fakephp: No device in slot found
[   83.457646] fakephp: No device in slot found
[   83.457689] fakephp: No device in slot found
[   83.457770] ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[0090270001e88fa8]
[   83.457957] fakephp: removing slot 0000:06:03.0
[   90.350950] SysRq : Show State
[   90.351014] 
[   90.351015]                          free                        sibling
[   90.351103]   task             PC    stack   pid father child younger older
[   90.351156] init          S C18F3B2C     0     1      0 (NOTLB)
[   90.351268]        c18f3b40 00000086 00000002 c18f3b2c c18f3b28 00000000 00000000 d79b51c7 
[   90.351466]        00000006 00000007 5da79330 0000000a 0000606f df882110 c17d9b00 00000000 
[   90.351697]        00001d14 00000000 c1bc38c0 fffef7e8 00000000 c17d9b4c 000000ff 00000000 
[   90.351927] Call Trace:
[   90.352011]  [<c02f2d88>] schedule_timeout+0x78/0xd0
[   90.352077]  [<f89173c1>] ata_qc_issue_prot+0x1d1/0x250 [libata]
[   90.352153]  [<c013bfea>] remove_wait_queue+0x1a/0x50
[   90.352219]  [<c013c08d>] add_wait_queue+0x1d/0x50
[   90.352283]  [<c01863ce>] pipe_poll+0x2e/0x90
[   90.352346]  [<c018db80>] do_select+0x3a0/0x490
[   90.352413]  [<c018e270>] __pollwait+0x0/0xf0
[   90.352476]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.352541]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.352606]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.352672]  [<c01effd1>] __make_request+0xc1/0x550
[   90.352736]  [<c0161652>] mempool_alloc+0x32/0x100
[   90.352801]  [<f89f20c3>] ext3_getblk+0xe3/0x270 [ext3]
[   90.352872]  [<c02e6372>] unix_find_other+0x72/0x190
[   90.352937]  [<c027f457>] __alloc_skb+0x57/0x120
[   90.353001]  [<c02e8768>] unix_write_space+0x18/0x80
[   90.353065]  [<c027b59b>] sock_alloc_send_skb+0x16b/0x1c0
[   90.353130]  [<c027d188>] sock_wfree+0x38/0x40
[   90.353193]  [<c02e675a>] unix_dgram_sendmsg+0x2ca/0x550
[   90.353262]  [<c0279022>] sock_sendmsg+0x112/0x130
[   90.353329]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.353396]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.354080]  [<c011fc6e>] kunmap_atomic+0x5e/0xa0
[   90.354143]  [<c011fc7a>] kunmap_atomic+0x6a/0xa0
[   90.354207]  [<c01fed0e>] copy_from_user+0x2e/0x70
[   90.354272]  [<c018de38>] core_sys_select+0x1c8/0x300
[   90.354337]  [<c02f3078>] mutex_lock+0x8/0x20
[   90.354399]  [<c01874d2>] pipe_read+0x2b2/0x400
[   90.354463]  [<c01fe05b>] vsnprintf+0x54b/0x630
[   90.354529]  [<c01923cb>] d_lookup+0x1b/0x40
[   90.354591]  [<c01b6cac>] proc_flush_task+0x4c/0x1f0
[   90.354657]  [<c013bfea>] remove_wait_queue+0x1a/0x50
[   90.354722]  [<c012afc7>] do_wait+0x737/0xb70
[   90.354786]  [<c018e3ab>] sys_select+0x4b/0x1b0
[   90.354851]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   90.354918]  =======================
[   90.354960] kthreadd      S 00001AF4     0     2      0 (L-TLB)
[   90.355061]        c18f5fd0 00000046 0000000a 00001af4 df882640 c17d9b00 00000000 c013bad0 
[   90.355259]        00000082 0000000a 5da18fea 0000000a 00000245 df882640 c17d9b00 00000000 
[   90.355489]        00000003 f70d9e74 dff51700 f70d9e70 00000292 c18f5fd0 c01205c0 00000000 
[   90.355720] Call Trace:
[   90.355793]  [<c013bad0>] kthread+0x0/0x70
[   90.355857]  [<c01205c0>] complete+0x40/0x60
[   90.355919]  [<c013bc45>] kthreadd+0x105/0x110
[   90.355982]  [<c013bb40>] kthreadd+0x0/0x110
[   90.356044]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.356109]  =======================
[   90.356150] migration/0   S C18FBF8C     0     3      2 (L-TLB)
[   90.356251]        c18fbfa0 00000046 00000002 c18fbf8c c18fbf88 00000000 c18fbfa0 dbf798d4 
[   90.356449]        00000086 00000001 fa98c3bd 0000000c 000004fb df8830a0 c17d9b00 00000000 
[   90.356679]        00000003 f724df6c dfca5540 fffef7f4 00000000 c18fbfa0 000000ff 00000000 
[   90.356909] Call Trace:
[   90.356986]  [<c0124d14>] migration_thread+0x114/0x230
[   90.357052]  [<c0124c00>] migration_thread+0x0/0x230
[   90.357115]  [<c013bb12>] kthread+0x42/0x70
[   90.357177]  [<c013bad0>] kthread+0x0/0x70
[   90.357239]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.357303]  =======================
[   90.357345] ksoftirqd/0   S C18FDFB0     0     4      2 (L-TLB)
[   90.357446]        c18fdfc4 00000046 00000002 c18fdfb0 c18fdfac 00000000 00000100 c046ef80 
[   90.357644]        c01312ab 0000000a 54c6d1cb 00000012 000006c8 df8835d0 c17d9b00 00000000 
[   90.357874]        00000001 c03d2308 dfca5540 ffff1236 00000000 0000000a 000000ff 00000000 
[   90.358104] Call Trace:
[   90.358177]  [<c01312ab>] run_timer_softirq+0x15b/0x1c0
[   90.358245]  [<c012da90>] ksoftirqd+0x0/0xf0
[   90.358307]  [<c012db4b>] ksoftirqd+0xbb/0xf0
[   90.358369]  [<c013bb12>] kthread+0x42/0x70
[   90.358430]  [<c013bad0>] kthread+0x0/0x70
[   90.358492]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.358557]  =======================
[   90.358598] watchdog/0    S 00000046     0     5      2 (L-TLB)
[   90.358699]        c18fffc8 00000046 c18fffd0 00000046 00000000 999c19e1 00000003 999c2e13 
[   90.358898]        00000003 00000001 999c3322 00000003 00000667 df883b00 c17d9b00 00000000 
[   90.359129]        00000222 00000000 c03ae180 00000000 00000078 c17d9b4c c010a65a c043cb4c 
[   90.359359] Call Trace:
[   90.359435]  [<c010a65a>] sched_clock+0x1a/0x70
[   90.359498]  [<c015a770>] watchdog+0x0/0x60
[   90.359560]  [<c015a7b8>] watchdog+0x48/0x60
[   90.359622]  [<c013bb12>] kthread+0x42/0x70
[   90.359683]  [<c013bad0>] kthread+0x0/0x70
[   90.359745]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.359810]  =======================
[   90.359851] migration/1   S DF803F8C     0     6      2 (L-TLB)
[   90.359952]        df803fa0 00000046 00000002 df803f8c df803f88 00000000 df882c20 df882a60 
[   90.360150]        00000086 00000001 2beaed76 00000014 000004ec df800110 c17e3b00 00000001 
[   90.360380]        00000003 f789ff6c f7a31700 ffff2115 00000000 df803fa0 000000ff 00000000 
[   90.360610] Call Trace:
[   90.360687]  [<c0124c00>] migration_thread+0x0/0x230
[   90.360751]  [<c0124d14>] migration_thread+0x114/0x230
[   90.360816]  [<c01205c0>] complete+0x40/0x60
[   90.360879]  [<c0124c00>] migration_thread+0x0/0x230
[   90.360942]  [<c013bb12>] kthread+0x42/0x70
[   90.361004]  [<c013bad0>] kthread+0x0/0x70
[   90.361066]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.361130]  =======================
[   90.361173] ksoftirqd/1   S DF805FB0     0     7      2 (L-TLB)
[   90.361274]        df805fc4 00000046 00000002 df805fb0 df805fac 00000000 c0139679 00000000 
[   90.361471]        007e4960 0000000a c3217ffd 00000012 000004fb df800640 c17e3b00 00000001 
[   90.361702]        00000001 c03d2328 dfca5e00 ffff1a55 00000000 0000000a 000000ff 00000000 
[   90.361932] Call Trace:
[   90.362006]  [<c0139679>] __rcu_process_callbacks+0x69/0x1d0
[   90.362074]  [<c012da90>] ksoftirqd+0x0/0xf0
[   90.362136]  [<c012db4b>] ksoftirqd+0xbb/0xf0
[   90.362198]  [<c013bb12>] kthread+0x42/0x70
[   90.362260]  [<c013bad0>] kthread+0x0/0x70
[   90.362321]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.362386]  =======================
[   90.362427] watchdog/1    S 00000046     0     8      2 (L-TLB)
[   90.362528]        df809fc8 00000046 df809fd0 00000046 00000000 999c8721 00000003 fffffff7 
[   90.362726]        ffffffff 00000001 9aceb49e 00000003 000005d8 df800b70 c17e3b00 00000001 
[   90.362956]        c01225f9 df809fd0 c03ae180 ffff161d 00000078 ffffffff c010a65a c043cb4c 
[   90.363187] Call Trace:
[   90.363262]  [<c01225f9>] sched_setscheduler+0x1c9/0x250
[   90.363328]  [<c010a65a>] sched_clock+0x1a/0x70
[   90.363391]  [<c015a770>] watchdog+0x0/0x60
[   90.363452]  [<c015a7b8>] watchdog+0x48/0x60
[   90.363514]  [<c013bb12>] kthread+0x42/0x70
[   90.363575]  [<c013bad0>] kthread+0x0/0x70
[   90.363637]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.363702]  =======================
[   90.363743] events/0      R running     0     9      2 (L-TLB)
[   90.363844] events/1      S DF82BF98     0    10      2 (L-TLB)
[   90.363945]        df82bfac 00000046 00000002 df82bf98 df82bf94 00000000 c17e4ca0 c17e4cb0 
[   90.364143]        dfffd740 0000000a a785ec19 00000014 00000821 df8015d0 c17e3b00 00000001 
[   90.364373]        000000fa dfffa480 f7a31700 ffff2123 00000000 0000033d 000000ff 00000000 
[   90.364603] Call Trace:
[   90.364680]  [<c0138d30>] worker_thread+0x0/0x100
[   90.364743]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.364806]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.364871]  [<c0138d30>] worker_thread+0x0/0x100
[   90.364934]  [<c013bb12>] kthread+0x42/0x70
[   90.364995]  [<c013bad0>] kthread+0x0/0x70
[   90.365057]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.365122]  =======================
[   90.365164] khelper       S 00000000     0    11      2 (L-TLB)
[   90.365265]        df82dfac 00000046 00000000 00000000 0000007b 0000007b 000000d8 ffffffff 
[   90.365462]        c0105480 0000000a 4873e94c 00000006 000017d9 df801b00 c17d9b00 00000000 
[   90.365692]        dfffa504 c0137d24 f784c8c0 f7817ec0 c013834a c17d9b4c 000000ff 00000246 
[   90.365923] Call Trace:
[   90.365997]  [<c0105480>] kernel_thread_helper+0x0/0x10
[   90.366062]  [<c0137d24>] __call_usermodehelper+0x24/0x70
[   90.366127]  [<c013834a>] run_workqueue+0x9a/0x110
[   90.366190]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.366254]  [<c0138d30>] worker_thread+0x0/0x100
[   90.366317]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.366380]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.366446]  [<c0138d30>] worker_thread+0x0/0x100
[   90.366508]  [<c013bb12>] kthread+0x42/0x70
[   90.366570]  [<c013bad0>] kthread+0x0/0x70
[   90.366632]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.366697]  =======================
[   90.366738] kblockd/0     S DF863F98     0    31      2 (L-TLB)
[   90.366839]        df863fac 00000046 00000002 df863f98 df863f94 00000000 f88abd99 effadf05 
[   90.367037]        00000006 0000000a 69806103 00000008 0000bd7a df85a640 c17d9b00 00000000 
[   90.367267]        c01ee881 c01f5fa1 dfca5380 fffeefb6 00000000 c17d9fc4 000000ff 00000000 
[   90.367497] Call Trace:
[   90.367570]  [<f88abd99>] scsi_request_fn+0x249/0x360 [scsi_mod]
[   90.367647]  [<c01ee881>] blk_start_queueing+0x11/0x20
[   90.367710]  [<c01f5fa1>] cfq_kick_queue+0x21/0x40
[   90.367776]  [<c0138d30>] worker_thread+0x0/0x100
[   90.367839]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.367902]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.367968]  [<c0138d30>] worker_thread+0x0/0x100
[   90.368030]  [<c013bb12>] kthread+0x42/0x70
[   90.368092]  [<c013bad0>] kthread+0x0/0x70
[   90.368154]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.368219]  =======================
[   90.368260] kblockd/1     S DF865F98     0    32      2 (L-TLB)
[   90.368361]        df865fac 00000046 00000002 df865f98 df865f94 00000000 f88abd99 8756fa2f 
[   90.368559]        00000004 0000000a 00ba2ff4 00000006 0000b632 df85ab70 c17e3b00 00000001 
[   90.368789]        c01ee881 c01f5fa1 f784c540 fffee597 00000000 c17e3fc4 000000ff 00000000 
[   90.369636] Call Trace:
[   90.369709]  [<f88abd99>] scsi_request_fn+0x249/0x360 [scsi_mod]
[   90.369784]  [<c01ee881>] blk_start_queueing+0x11/0x20
[   90.369848]  [<c01f5fa1>] cfq_kick_queue+0x21/0x40
[   90.369912]  [<c0138d30>] worker_thread+0x0/0x100
[   90.369975]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.370038]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.370104]  [<c0138d30>] worker_thread+0x0/0x100
[   90.370167]  [<c013bb12>] kthread+0x42/0x70
[   90.370228]  [<c013bad0>] kthread+0x0/0x70
[   90.370290]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.370355]  =======================
[   90.370396] kacpid        S DF8821C0     0    33      2 (L-TLB)
[   90.370497]        df869fac 00000046 df85af90 df8821c0 df882000 df85af90 00000000 a1db8d32 
[   90.370695]        00000003 00000001 a1db8f28 00000003 00000206 df85b0a0 c17d9b00 00000000 
[   90.370925]        000000d3 00000000 c03ae180 a1db8460 00000003 c17d9b4c df85b0a0 00000246 
[   90.371156] Call Trace:
[   90.371232]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.371296]  [<c0138d30>] worker_thread+0x0/0x100
[   90.371359]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.371422]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.371488]  [<c0138d30>] worker_thread+0x0/0x100
[   90.371551]  [<c013bb12>] kthread+0x42/0x70
[   90.371612]  [<c013bad0>] kthread+0x0/0x70
[   90.371674]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.371739]  =======================
[   90.371781] kacpi_notify  S DF86BF98     0    34      2 (L-TLB)
[   90.371882]        df86bfac 00000046 00000002 df86bf98 df86bf94 00000000 00000000 c18f9f9c 
[   90.372079]        c02f1f8a 00000001 a1f3ed4f 00000003 000001f2 df85b5d0 c17e3b00 00000001 
[   90.372309]        00ce0145 00000082 c03ae180 fffedba4 00000000 00000348 000000ff 00000000 
[   90.372540] Call Trace:
[   90.372613]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.372678]  [<c0138d30>] worker_thread+0x0/0x100
[   90.372741]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.372805]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.372870]  [<c0138d30>] worker_thread+0x0/0x100
[   90.372933]  [<c013bb12>] kthread+0x42/0x70
[   90.372994]  [<c013bad0>] kthread+0x0/0x70
[   90.373056]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.373121]  =======================
[   90.373162] kseriod       S 00000000     0   145      2 (L-TLB)
[   90.373264]        df83bf98 00000046 00000000 00000000 00000003 00000286 dfa32a84 dfa32808 
[   90.373461]        f8a4aee8 0000000a 64c35cc0 00000006 000010ef df8515d0 c17d9b00 00000000 
[   90.373691]        f8a4aee8 c03c3820 f7f86700 c026050f c1033e40 00000287 c03d9a70 00000246 
[   90.373922] Call Trace:
[   90.373997]  [<c026050f>] bus_for_each_dev+0x4f/0x60
[   90.374063]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.374127]  [<c0269731>] serio_thread+0xd1/0x340
[   90.374192]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.374257]  [<c0269660>] serio_thread+0x0/0x340
[   90.374320]  [<c013bb12>] kthread+0x42/0x70
[   90.374381]  [<c013bad0>] kthread+0x0/0x70
[   90.374444]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.374509]  =======================
[   90.374550] pdflush       S DF870A60     0   172      2 (L-TLB)
[   90.374651]        df877fa8 00000046 c010320a df870a60 df8826f0 df882530 df870a60 00000000 
[   90.374849]        c18f5fac 00000005 c75db9f0 00000003 000004d2 df870b70 c17d9b00 00000000 
[   90.375079]        00000003 df877f8c c03ae180 00000005 00000005 00000282 c0120900 00000000 
[   90.375310] Call Trace:
[   90.375382]  [<c010320a>] __switch_to+0xaa/0x1d0
[   90.375448]  [<c0120900>] set_user_nice+0xb0/0xf0
[   90.375511]  [<c0165000>] pdflush+0x0/0x200
[   90.375573]  [<c01650c5>] pdflush+0xc5/0x200
[   90.375636]  [<c013bb12>] kthread+0x42/0x70
[   90.375697]  [<c013bad0>] kthread+0x0/0x70
[   90.375759]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.375824]  =======================
[   90.375865] pdflush       S DF879F94     0   173      2 (L-TLB)
[   90.375967]        df879fa8 00000046 00000002 df879f94 df879f90 00000000 c013192f 00000000 
[   90.376165]        00000282 0000000a f3bde377 00000014 00000c46 df8710a0 c17d9b00 00000000 
[   90.376396]        df879f9c 00000400 dfca5e00 ffff2123 00000000 00000000 000000ff 00000000 
[   90.376626] Call Trace:
[   90.376699]  [<c013192f>] __mod_timer+0x9f/0xb0
[   90.376765]  [<c0165000>] pdflush+0x0/0x200
[   90.376827]  [<c01650c5>] pdflush+0xc5/0x200
[   90.376890]  [<c013bb12>] kthread+0x42/0x70
[   90.376952]  [<c013bad0>] kthread+0x0/0x70
[   90.377013]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.377078]  =======================
[   90.377119] kswapd0       S DF87BF34     0   174      2 (L-TLB)
[   90.377220]        df87bf48 00000046 00000002 df87bf34 df87bf30 00000000 ffffffff ffffffff 
[   90.377418]        00000002 00000005 c75e018d 00000003 00000641 df8715d0 c17d9b00 00000000 
[   90.377648]        00000003 00000046 c03ae180 fffedc3d 00000000 00000000 000000ff 00000000 
[   90.377878] Call Trace:
[   90.377955]  [<c0167f30>] kswapd+0x0/0x470
[   90.378017]  [<c016838c>] kswapd+0x45c/0x470
[   90.378079]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.378144]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.378210]  [<c01205c0>] complete+0x40/0x60
[   90.378272]  [<c0167f30>] kswapd+0x0/0x470
[   90.378334]  [<c013bb12>] kthread+0x42/0x70
[   90.378395]  [<c013bad0>] kthread+0x0/0x70
[   90.378457]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.378522]  =======================
[   90.378563] aio/0         S C03AE500     0   225      2 (L-TLB)
[   90.378664]        c1941fac 00000046 dff3c530 c03ae500 c03ae340 dff3c530 00000000 c7759e7f 
[   90.378862]        00000003 00000005 c775960b 00000003 000003cf dff3c640 c17d9b00 00000000 
[   90.379092]        00000000 00000000 c03ae180 c77584be 00000003 c17d9b4c dff3c640 00000246 
[   90.379322] Call Trace:
[   90.379398]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.379462]  [<c0138d30>] worker_thread+0x0/0x100
[   90.379525]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.379588]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.379653]  [<c0138d30>] worker_thread+0x0/0x100
[   90.379716]  [<c013bb12>] kthread+0x42/0x70
[   90.379778]  [<c013bad0>] kthread+0x0/0x70
[   90.379839]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.379905]  =======================
[   90.379946] aio/1         S C1943F98     0   226      2 (L-TLB)
[   90.380047]        c1943fac 00000046 00000002 c1943f98 c1943f94 00000000 00000000 c18f3e6c 
[   90.380245]        c02f1f8a 00000005 c776c9ec 00000003 0000039a dff3cb70 c17e3b00 00000001 
[   90.380475]        c1943fb8 00000082 c03ae180 fffedc41 00000000 0000032a 000000ff 00000000 
[   90.380705] Call Trace:
[   90.380778]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.380844]  [<c0138d30>] worker_thread+0x0/0x100
[   90.380907]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.380970]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.381036]  [<c0138d30>] worker_thread+0x0/0x100
[   90.381098]  [<c013bb12>] kthread+0x42/0x70
[   90.381160]  [<c013bad0>] kthread+0x0/0x70
[   90.381222]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.381287]  =======================
[   90.381328] ksuspend_usbd S DFCE3F98     0  2080      2 (L-TLB)
[   90.381429]        dfce3fac 00000046 00000002 dfce3f98 dfce3f94 00000000 00000002 df945c00 
[   90.381627]        df945f14 0000000a a5d071a6 00000004 000043d3 dfd94110 c17e3b00 00000001 
[   90.381857]        df81ac80 df945f14 c1bc3380 fffedfe0 00000000 00000314 000000ff 00000000 
[   90.382087] Call Trace:
[   90.382163]  [<c0138d30>] worker_thread+0x0/0x100
[   90.382226]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.382290]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.382355]  [<c0138d30>] worker_thread+0x0/0x100
[   90.382418]  [<c013bb12>] kthread+0x42/0x70
[   90.382479]  [<c013bad0>] kthread+0x0/0x70
[   90.382541]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.382606]  =======================
[   90.382647] khubd         S F888A122     0  2081      2 (L-TLB)
[   90.382748]        dfd45f48 00000046 00000001 f888a122 fffeddf3 df945c00 df9a9200 00000000 
[   90.382946]        df945c00 0000000a 2eb7ef80 00000004 00003745 c1b14640 c17e3b00 00000001 
[   90.383176]        00000000 00000006 dff51380 df945c00 df9a9200 00000000 ffffffed 00000246 
[   90.383406] Call Trace:
[   90.383478]  [<f888a122>] autosuspend_check+0x102/0x110 [usbcore]
[   90.383558]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.383622]  [<f8884b80>] hub_thread+0x3a0/0xc30 [usbcore]
[   90.383695]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.383760]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.383826]  [<c01205c0>] complete+0x40/0x60
[   90.383888]  [<f88847e0>] hub_thread+0x0/0xc30 [usbcore]
[   90.383960]  [<c013bb12>] kthread+0x42/0x70
[   90.384628]  [<c013bad0>] kthread+0x0/0x70
[   90.384689]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.384754]  =======================
[   90.384796] ata/0         S C01FE677     0  2143      2 (L-TLB)
[   90.384897]        c1b0ffac 00000046 ffffffec c01fe677 00000060 00000283 000052a7 df884000 
[   90.385094]        df884000 0000000a f609146e 00000005 00004da0 df850110 c17d9b00 00000000 
[   90.385325]        00000200 df81af80 f784b380 f8917500 c013834a c17d9b4c 000000ff 00000246 
[   90.385555] Call Trace:
[   90.385627]  [<c01fe677>] delay_tsc+0x27/0x50
[   90.385692]  [<f8917500>] ata_pio_task+0x0/0xf0 [libata]
[   90.385763]  [<c013834a>] run_workqueue+0x9a/0x110
[   90.385828]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.385891]  [<c0138d30>] worker_thread+0x0/0x100
[   90.385954]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.386017]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.386083]  [<c0138d30>] worker_thread+0x0/0x100
[   90.386146]  [<c013bb12>] kthread+0x42/0x70
[   90.386207]  [<c013bad0>] kthread+0x0/0x70
[   90.386269]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.386334]  =======================
[   90.386375] ata/1         S DFF3DBB0     0  2144      2 (L-TLB)
[   90.386476]        dfdb9fac 00000046 df850530 dff3dbb0 dff3d9f0 df850530 00005298 df884000 
[   90.386674]        df884000 0000000a 51ca9070 00000004 00005584 df850640 c17e3b00 00000001 
[   90.386904]        df8500b8 df81a780 c1bc3a80 f8917500 c013834a 00000357 df850640 00000246 
[   90.387135] Call Trace:
[   90.387210]  [<f8917500>] ata_pio_task+0x0/0xf0 [libata]
[   90.387281]  [<c013834a>] run_workqueue+0x9a/0x110
[   90.387345]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.387409]  [<c0138d30>] worker_thread+0x0/0x100
[   90.387472]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.387535]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.387601]  [<c0138d30>] worker_thread+0x0/0x100
[   90.387663]  [<c013bb12>] kthread+0x42/0x70
[   90.387725]  [<c013bad0>] kthread+0x0/0x70
[   90.387787]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.387852]  =======================
[   90.387893] ata_aux       S DFCE61C0     0  2145      2 (L-TLB)
[   90.387994]        dfdbffac 00000046 dfdbc000 dfce61c0 dfce6000 dfdbc000 00000000 dfa4feac 
[   90.388192]        c02f1f8a 00000001 febf6518 00000003 00000182 dfdbc110 c17d9b00 00000000 
[   90.388422]        df851048 00000082 dfedcc40 febf5708 00000003 0000032a dfdbc110 00000246 
[   90.388653] Call Trace:
[   90.388726]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.388791]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.388854]  [<c0138d30>] worker_thread+0x0/0x100
[   90.388917]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.388980]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.389046]  [<c0138d30>] worker_thread+0x0/0x100
[   90.389108]  [<c013bb12>] kthread+0x42/0x70
[   90.389170]  [<c013bad0>] kthread+0x0/0x70
[   90.389232]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.389296]  =======================
[   90.389338] khpsbpkt      S 7D507D12     0  2211      2 (L-TLB)
[   90.389439]        dfc31fb8 00000046 c17da4c0 7d507d12 00000004 c02f1f8a dfc31fd0 00000046 
[   90.389637]        00000082 0000000a 7d50cceb 00000004 00000290 dfd890a0 c17d9b00 00000000 
[   90.389867]        00000003 c196de70 dffed700 c196de6c 00000282 dfc31fb8 c01205c0 00000000 
[   90.390097] Call Trace:
[   90.390170]  [<c02f1f8a>] schedule+0x2ca/0x890
[   90.390235]  [<c01205c0>] complete+0x40/0x60
[   90.390297]  [<f89319fb>] hpsbpkt_thread+0x11b/0x120 [ieee1394]
[   90.390370]  [<f89318e0>] hpsbpkt_thread+0x0/0x120 [ieee1394]
[   90.390440]  [<c013bb12>] kthread+0x42/0x70
[   90.390502]  [<c013bad0>] kthread+0x0/0x70
[   90.390564]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.390629]  =======================
[   90.390671] scsi_eh_0     S DFE8BF34     0  2285      2 (L-TLB)
[   90.390772]        dfe8bf74 00000046 00000000 dfe8bf34 c0120688 00000000 00000000 00000003 
[   90.390969]        00000096 0000000a f607cbc3 00000005 0000292a dfcf8640 c17d9b00 00000000 
[   90.391199]        c1b1b400 f88a510e f785a8c0 00000000 f88a5293 00000286 c1b1b400 dfd53c00 
[   90.391430] Call Trace:
[   90.391502]  [<c0120688>] __wake_up+0x38/0x50
[   90.391566]  [<f88a510e>] scsi_device_put+0x3e/0x40 [scsi_mod]
[   90.391639]  [<f88a5293>] __scsi_iterate_devices+0x53/0x70 [scsi_mod]
[   90.391715]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.391791]  [<c01205c0>] complete+0x40/0x60
[   90.391853]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.391926]  [<c013bb12>] kthread+0x42/0x70
[   90.391988]  [<c013bad0>] kthread+0x0/0x70
[   90.392050]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.392115]  =======================
[   90.392156] scsi_eh_1     S DF9A1F34     0  2286      2 (L-TLB)
[   90.392257]        df9a1f74 00000046 00000000 df9a1f34 c0120688 00000000 00000000 00000003 
[   90.392456]        00000096 0000000a 510904be 00000004 0000090d dfcf95d0 c17d9b00 00000000 
[   90.392687]        df945050 00000000 dfedcc40 00000246 f88a5288 00000246 00000293 df945000 
[   90.392917] Call Trace:
[   90.392990]  [<c0120688>] __wake_up+0x38/0x50
[   90.393054]  [<f88a5288>] __scsi_iterate_devices+0x48/0x70 [scsi_mod]
[   90.393129]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.393202]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.393275]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.393350]  [<c01205c0>] complete+0x40/0x60
[   90.393413]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.393486]  [<c013bb12>] kthread+0x42/0x70
[   90.393547]  [<c013bad0>] kthread+0x0/0x70
[   90.393609]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.393674]  =======================
[   90.393715] scsi_eh_2     S DF9ABF34     0  2326      2 (L-TLB)
[   90.393816]        df9abf74 00000046 00000000 df9abf34 c0120688 00000000 00000000 00000003 
[   90.394014]        00000096 0000000a 6137a020 00000004 0000d13d dfc395d0 c17d9b00 00000000 
[   90.394244]        c1b1b850 00000000 dfedc380 00000246 f88a5288 00000246 00000293 c1b1b800 
[   90.394474] Call Trace:
[   90.394547]  [<c0120688>] __wake_up+0x38/0x50
[   90.394611]  [<f88a5288>] __scsi_iterate_devices+0x48/0x70 [scsi_mod]
[   90.394685]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.394759]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.394832]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.394907]  [<c01205c0>] complete+0x40/0x60
[   90.394969]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.395042]  [<c013bb12>] kthread+0x42/0x70
[   90.395104]  [<c013bad0>] kthread+0x0/0x70
[   90.395166]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.395231]  =======================
[   90.395272] scsi_eh_3     S DFCDDF34     0  2327      2 (L-TLB)
[   90.395373]        dfcddf74 00000046 00000000 dfcddf34 c0120688 00000000 00000000 00000003 
[   90.395571]        00000096 0000000a 6b20df2e 00000004 00a1a7a7 dfc38110 c17d9b00 00000000 
[   90.395802]        c1b1bc50 00000000 dfedc380 00000246 f88a5288 00000246 00000293 c1b1bc00 
[   90.396032] Call Trace:
[   90.396105]  [<c0120688>] __wake_up+0x38/0x50
[   90.396169]  [<f88a5288>] __scsi_iterate_devices+0x48/0x70 [scsi_mod]
[   90.396244]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.396317]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.396390]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.396466]  [<c01205c0>] complete+0x40/0x60
[   90.396528]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.396601]  [<c013bb12>] kthread+0x42/0x70
[   90.396662]  [<c013bad0>] kthread+0x0/0x70
[   90.396724]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.396789]  =======================
[   90.396830] scsi_eh_4     S DFE89F60     0  2385      2 (L-TLB)
[   90.396931]        dfe89f74 00000046 00000002 dfe89f60 dfe89f5c 00000000 00000000 00000003 
[   90.397128]        00000096 0000000a 74e543d6 00000004 00a17153 dfd895d0 c17e3b00 00000001 
[   90.397359]        dfcfa450 00000000 c1bc3540 fffedf07 00000000 00000246 000000ff 00000000 
[   90.397589] Call Trace:
[   90.397666]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.397739]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.397815]  [<c01205c0>] complete+0x40/0x60
[   90.397877]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.397950]  [<c013bb12>] kthread+0x42/0x70
[   90.398012]  [<c013bad0>] kthread+0x0/0x70
[   90.398074]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.398138]  =======================
[   90.398180] scsi_eh_5     S DF9A3F60     0  2386      2 (L-TLB)
[   90.398281]        df9a3f74 00000046 00000002 df9a3f60 df9a3f5c 00000000 00000000 00000003 
[   90.398478]        00000096 0000000a 7ea9c834 00000004 00a15f07 dfd88640 c17e3b00 00000001 
[   90.398708]        dfcfa850 00000000 c1bc31c0 fffedf36 00000000 00000246 000000ff 00000000 
[   90.398939] Call Trace:
[   90.399015]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.399089]  [<f88a9876>] scsi_error_handler+0x46/0x510 [scsi_mod]
[   90.399164]  [<c01205c0>] complete+0x40/0x60
[   90.399227]  [<f88a9830>] scsi_error_handler+0x0/0x510 [scsi_mod]
[   90.399299]  [<c013bb12>] kthread+0x42/0x70
[   90.399976]  [<c013bad0>] kthread+0x0/0x70
[   90.400037]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.400102]  =======================
[   90.400143] kjournald     S DFD9DF88     0  2541      2 (L-TLB)
[   90.400245]        dfd9df9c 00000046 00000002 dfd9df88 dfd9df84 00000000 00000000 dfd87000 
[   90.400442]        00000000 0000000a 24449ddf 0000000e 000012b1 dfc40b70 c17d9b00 00000000 
[   90.400673]        c1b0c850 00000000 dfca5540 ffff02f0 00000000 00000000 000000ff 00000000 
[   90.400903] Call Trace:
[   90.400980]  [<f89bbdc6>] kjournald+0x1d6/0x1f0 [jbd]
[   90.401049]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.401115]  [<f89bbbf0>] kjournald+0x0/0x1f0 [jbd]
[   90.401181]  [<c013bb12>] kthread+0x42/0x70
[   90.401242]  [<c013bad0>] kthread+0x0/0x70
[   90.401304]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.401369]  =======================
[   90.401410] udevd         S F7F5DB2C     0  2803      1 (NOTLB)
[   90.401511]        f7f5db40 00000082 00000002 f7f5db2c f7f5db28 00000000 00000000 d92a4dac 
[   90.401709]        00000006 00000001 6ea2f23f 00000013 0001b4bb df85a110 c17e3b00 00000001 
[   90.401939]        00040fce 00000000 c1bc3380 ffff1dfa 00000000 c17d9b4c 000000ff 00000000 
[   90.402169] Call Trace:
[   90.402245]  [<c02f2d88>] schedule_timeout+0x78/0xd0
[   90.402310]  [<c013bfea>] remove_wait_queue+0x1a/0x50
[   90.402374]  [<c013c08d>] add_wait_queue+0x1d/0x50
[   90.402437]  [<c01863ce>] pipe_poll+0x2e/0x90
[   90.402500]  [<c018db80>] do_select+0x3a0/0x490
[   90.402566]  [<c018e270>] __pollwait+0x0/0xf0
[   90.402629]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.402694]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.402759]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.402823]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.402889]  [<c02f5d99>] do_page_fault+0x389/0x690
[   90.402953]  [<c012dc04>] tasklet_action+0x54/0xc0
[   90.403022]  [<c0162e9f>] __pagevec_free+0x1f/0x30
[   90.403085]  [<c0165c75>] release_pages+0x145/0x180
[   90.403151]  [<c011fc6e>] kunmap_atomic+0x5e/0xa0
[   90.403213]  [<c011fc7a>] kunmap_atomic+0x6a/0xa0
[   90.403276]  [<c016ae72>] do_wp_page+0x282/0x530
[   90.403339]  [<c01943e2>] iget_locked+0x72/0x140
[   90.403404]  [<c016d38b>] __handle_mm_fault+0x7fb/0xb00
[   90.403470]  [<c0163571>] get_page_from_freelist+0x2c1/0x3a0
[   90.403538]  [<c02f5d99>] do_page_fault+0x389/0x690
[   90.403601]  [<c016369f>] __alloc_pages+0x4f/0x340
[   90.403666]  [<c0192329>] __d_lookup+0x89/0x110
[   90.403729]  [<c018de38>] core_sys_select+0x1c8/0x300
[   90.403795]  [<c0189a19>] __link_path_walk+0x269/0xe70
[   90.403860]  [<c017740f>] shmem_truncate_range+0x2f/0x830
[   90.403926]  [<c0196cc4>] mntput_no_expire+0x24/0xa0
[   90.403990]  [<c018a685>] link_path_walk+0x65/0xc0
[   90.404054]  [<c0192329>] __d_lookup+0x89/0x110
[   90.404118]  [<c018815e>] permission+0x10e/0x120
[   90.404181]  [<c0192c14>] shrink_dcache_parent+0x14/0xf0
[   90.404246]  [<c013bfea>] remove_wait_queue+0x1a/0x50
[   90.404310]  [<c012ae53>] do_wait+0x5c3/0xb70
[   90.404372]  [<c01928b7>] dput+0x87/0x100
[   90.404434]  [<c0196cc4>] mntput_no_expire+0x24/0xa0
[   90.404500]  [<c018e3ab>] sys_select+0x4b/0x1b0
[   90.404563]  [<c012b431>] sys_wait4+0x31/0x40
[   90.404626]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   90.404693]  =======================
[   90.404734] kpsmoused     S DF851150     0  3894      2 (L-TLB)
[   90.404835]        f7a17fac 00000046 f79a19f0 df851150 df850f90 f79a19f0 00000000 41b1f200 
[   90.405033]        00000006 00000001 41d4b42b 00000006 00000314 f79a1b00 c17e3b00 00000001 
[   90.405263]        000ead00 00000000 f7a681c0 41a3afd1 00000006 c17e3fc4 f79a1b00 00000246 
[   90.405493] Call Trace:
[   90.405569]  [<c013bf80>] prepare_to_wait+0x20/0x70
[   90.405633]  [<c0138d30>] worker_thread+0x0/0x100
[   90.405695]  [<c0138e07>] worker_thread+0xd7/0x100
[   90.405759]  [<c013bdd0>] autoremove_wake_function+0x0/0x50
[   90.405824]  [<c0138d30>] worker_thread+0x0/0x100
[   90.405887]  [<c013bb12>] kthread+0x42/0x70
[   90.405948]  [<c013bad0>] kthread+0x0/0x70
[   90.406010]  [<c0105487>] kernel_thread_helper+0x7/0x10
[   90.406075]  =======================
[   90.406116] sh            S F74C3F28     0  4655      1 (NOTLB)
[   90.406217]        f74c3f3c 00000082 00000002 f74c3f28 f74c3f24 00000000 00000000 fffa7000 
[   90.406414]        00000007 00000001 f1b910a3 00000006 0000249b f71a55d0 c17e3b00 00000001 
[   90.406645]        3d161065 dff3cf90 dfca5a80 fffee98c 00000000 c010320a 000000ff 00000000 
[   90.406875] Call Trace:
[   90.406950]  [<c010320a>] __switch_to+0xaa/0x1d0
[   90.407014]  [<c012aef6>] do_wait+0x666/0xb70
[   90.407079]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.407145]  [<c012b431>] sys_wait4+0x31/0x40
[   90.407208]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   90.407273]  [<c02f0000>] clip_ioctl+0x500/0x510
[   90.407337]  =======================
[   90.407378] bash          S F7AD7EA4     0  4657   4655 (NOTLB)
[   90.407479]        f7ad7eb8 00000086 00000002 f7ad7ea4 f7ad7ea0 00000000 c00bea5e 00000010 
[   90.407676]        00000000 00000009 2e26eff2 00000014 0001795c dff3d0a0 c17d9b00 00000000 
[   90.407907]        dfca01ff c01323e9 dfca5e00 ffff2115 00000000 dfd8780c 000000ff 00000000 
[   90.408137] Call Trace:
[   90.408212]  [<c01323e9>] __dequeue_signal+0xd9/0x160
[   90.408278]  [<c02f2d88>] schedule_timeout+0x78/0xd0
[   90.408342]  [<c0216f6b>] vgacon_set_cursor_size+0x9b/0x140
[   90.408407]  [<c01286f7>] release_console_sem+0x1c7/0x1f0
[   90.408472]  [<c013c08d>] add_wait_queue+0x1d/0x50
[   90.408535]  [<c0247a3d>] read_chan+0x1dd/0x630
[   90.408600]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.408665]  [<c02446ad>] tty_read+0x8d/0xd0
[   90.408727]  [<c0247860>] read_chan+0x0/0x630
[   90.408789]  [<c0180dbc>] vfs_read+0xbc/0x160
[   90.408851]  [<c0244620>] tty_read+0x0/0xd0
[   90.408913]  [<c01812f1>] sys_read+0x41/0x70
[   90.408976]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   90.409040]  [<c02f0000>] clip_ioctl+0x500/0x510
[   90.409104]  =======================
[   90.409145] bash          D 00000046     0  4698   4657 (NOTLB)
[   90.409246]        f724de58 00000086 c0216f6b 00000046 c17ec000 c17ec000 0000000a 6e7a4da7 
[   90.409444]        00000013 00000008 6e7c0cb1 00000013 000392f8 f79a0640 c17e3b00 00000001 
[   90.409674]        0000bcbf 00000000 dfa0ee00 c024f410 0000792d c17e3fc4 c01282b3 00007960 
[   90.409905] Call Trace:
[   90.409977]  [<c0216f6b>] vgacon_set_cursor_size+0x9b/0x140
[   90.410045]  [<c024f410>] vt_console_print+0x0/0x2b0
[   90.410109]  [<c01282b3>] __call_console_drivers+0x53/0x60
[   90.410175]  [<c02f3d8c>] __down+0x8c/0xf4
[   90.410236]  [<c0122bc0>] default_wake_function+0x0/0x10
[   90.410301]  [<c02f3b37>] __down_failed+0x7/0x10
[   90.410364]  [<c01c294b>] sysfs_drop_dentry+0x13b/0x190
[   90.410430]  [<c01c2ac1>] sysfs_hash_and_remove+0xd1/0x130
[   90.410496]  [<f89749bd>] pci_hp_deregister+0x10d/0x1b0 [pci_hotplug]
[   90.410567]  [<f89c8017>] remove_slot+0x17/0x60 [fakephp]
[   90.410633]  [<f89c814b>] disable_slot+0xab/0x140 [fakephp]
[   90.410699]  [<f8974e03>] power_write_file+0xb3/0x110 [pci_hotplug]
[   90.410768]  [<f8974d50>] power_write_file+0x0/0x110 [pci_hotplug]
[   90.410836]  [<f8974059>] hotplug_slot_attr_store+0x29/0x40 [pci_hotplug]
[   90.410905]  [<c01c30ab>] sysfs_write_file+0xab/0x110
[   90.410971]  [<c0180c4e>] vfs_write+0xbe/0x170
[   90.411033]  [<c01c3000>] sysfs_write_file+0x0/0x110
[   90.411098]  [<c0181361>] sys_write+0x41/0x70
[   90.411161]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[   90.411226]  [<c02f0000>] clip_ioctl+0x500/0x510
[   90.411290]  =======================


