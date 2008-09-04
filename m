Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYIDXLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYIDXLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYIDXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:11:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:4675 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYIDXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:11:35 -0400
Message-ID: <1a9da18c0809041611r660a9b1dya33ec4e9760afc97@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:11:33 -0700
From: "=?UTF-8?Q?Masoud_Sharbiani?=
	=?UTF-8?Q?_\"=D9=85=D8=B3=D8=B9=D9=88=D8=AF_?=
	=?UTF-8?Q?=D8=B4=D8=B1=D8=A8=DB=8C=D8=A7=D9=86=DB=8C\"?=" 
	<masouds@masoud.ir>
To: bzolnier@gmail.com, sshtylyov@ru.mvista.com
Subject: Re: HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1a9da18c0809041610tb3f2a58r6acd6f10a3d50a91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a9da18c0809041610tb3f2a58r6acd6f10a3d50a91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending to the list as well this time)
>
> Hi there,
> Looks like your commit 74811f355f4f69a187fa74892dcf2a684b84ce99  (hpt366: convert to use ->host_priv)
> has caused the following crash:
> (Full dmesg follows, as captured from a serial console)
> ----
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Linux version 2.6.27-rc1 (root@rita.xxx.yyy.zzz) (gcc version
>  4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #22 SMP Thu Sep 4 11:35:28 PDT 2008
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000f7ff0000 (usable)
> [    0.000000]  BIOS-e820: 00000000f7ff0000 - 00000000f7fff000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000f7fff000 - 00000000f8000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000188000000 (usable)
> [    0.000000] last_pfn = 0x188000 max_arch_pfn = 0x1000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] RAMDISK: 34e87000 - 37fef019
> [    0.000000] DMI 2.3 present.
> [    0.000000] ACPI: RSDP 000F5360, 0014 (r0 ACPIAM)
> [    0.000000] ACPI: RSDT F7FF0000, 0030 (r1 A M I  OEMRSDT   3000424 MSFT
>  97)
> [    0.000000] ACPI: FACP F7FF0200, 0081 (r2 A M I  OEMFACP   3000424 MSFT
>  97)
> [    0.000000] ACPI: DSDT F7FF0420, 2DAE (r1  0ABBP 0ABBP018       18 INTL  2002
> 026)
> [    0.000000] ACPI: FACS F7FFF000, 0040
> [    0.000000] ACPI: APIC F7FF0390, 0084 (r1 A M I  OEMAPIC   3000424 MSFT
>  97)
> [    0.000000] ACPI: OEMB F7FFF040, 0040 (r1 A M I  AMI_OEM   3000424 MSFT
>  97)
> [    0.000000] 5376MB HIGHMEM available.
> [    0.000000] 896MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 38000000
> [    0.000000]   low ram: 00000000 - 38000000
> [    0.000000]   bootmap 00009000 - 00010000
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0038000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
>  0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 -
>  0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 -
>  0000007000]
> [    0.000000]   #3 [0000100000 - 0000562920]    TEXT DATA BSS ==> [0000100000 -
>  0000562920]
> [    0.000000]   #4 [0034e87000 - 0037fef019]          RAMDISK ==> [0034e87000 -
>  0037fef019]
> [    0.000000]   #5 [0000563000 - 000056a000]    INIT_PG_TABLE ==> [0000563000 -
>  000056a000]
> [    0.000000]   #6 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 -
>  0000100000]
> [    0.000000]   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 -
>  0000009000]
> [    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 -
>  0000010000]
> [    0.000000] found SMP MP-table at [c00ff780] 000ff780
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x00038000
> [    0.000000]   HighMem  0x00038000 -> 0x00188000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000f7ff0
> [    0.000000]     0: 0x00100000 -> 0x00188000
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
> [    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec80400] gsi_base[48])
> [    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec80400, GSI 48-71
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Enabling APIC mode:  Flat.  Using 3 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at f8800000 (gap: f8000000:6c00
> 000)
> [    0.000000] PERCPU: Allocating 44980 bytes of per cpu data
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pag
> es: 1560207
> [    0.000000] Kernel command line: root=/dev/sda1 console=ttyS0,115200n8 consol
> e=tty0 CONSOLE=/dev/ttyS0
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] TSC calibrated against PM_TIMER
> [    0.000000] Detected 2000.056 MHz processor.
> [    0.020000] Console: colour VGA+ 80x25
> [    0.020000] console [tty0] enabled
> [    0.020000] console [ttyS0] enabled
> [    0.020000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.020000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.020000] Memory: 6183704k/6422528k available (2365k kernel code, 106364k r
> eserved, 1126k data, 416k init, 5373888k highmem)
> [    0.020000] virtual kernel memory layout:
> [    0.020000]     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
> [    0.020000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
> [    0.020000]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
> [    0.020000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
> [    0.020000]       .init : 0xc046f000 - 0xc04d7000   ( 416 kB)
> [    0.020000]       .data : 0xc034f789 - 0xc0469260   (1126 kB)
> [    0.020000]       .text : 0xc0100000 - 0xc034f789   (2365 kB)
> [    0.020000] Checking if this processor honours the WP bit even in supervisor
> mode...Ok.
> [    0.020000] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4,
> Nodes=1
> [    0.027863] Calibrating delay loop (skipped), value calculated using timer fr
> equency.. 4000.11 BogoMIPS (lpj=20000560)
> [    0.038699] Security Framework initialized
> [    0.040000] SELinux:  Disabled at boot.
> [    0.040000] Mount-cache hash table entries: 512
> [    0.044504] Initializing cgroup subsys ns
> [    0.047713] Initializing cgroup subsys cpuacct
> [    0.051296] CPU: Trace cache: 12K uops, L1 D cache: 8K
> [    0.057179] CPU: L2 cache: 512K
> [    0.060779] CPU: Physical Processor ID: 0
> [    0.065590] Checking 'hlt' instruction... OK.
> [    0.107275] ACPI: Core revision 20080609
> [    0.120000] ENABLING IO-APIC IRQs
> [    0.123565] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.230000] CPU0: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
> [    0.240000] Booting processor 1/6 ip 6000
> [    0.250000] Initializing CPU#1
> [    0.395264] Calibrating delay using timer specific routine.. 4000.29 BogoMIPS
>  (lpj=20001485)
> [    0.395281] CPU: Trace cache: 12K uops, L1 D cache: 8K
> [    0.395286] CPU: L2 cache: 512K
> [    0.395289] CPU: Physical Processor ID: 3
> [    0.395744] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.393857] CPU1: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
> [    0.410000] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.420000] Booting processor 2/1 ip 6000
> [    0.430000] Initializing CPU#2
> [    0.571053] Calibrating delay using timer specific routine.. 4000.30 BogoMIPS
>  (lpj=20001529)
> [    0.571072] CPU: Trace cache: 12K uops, L1 D cache: 8K
> [    0.571078] CPU: L2 cache: 512K
> [    0.571081] CPU: Physical Processor ID: 0
> [    0.571568] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
> [    0.580000] CPU2: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
> [    0.590000] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> [    0.600000] Booting processor 3/7 ip 6000
> [    0.610000] Initializing CPU#3
> [    0.750754] Calibrating delay using timer specific routine.. 4000.30 BogoMIPS
>  (lpj=20001515)
> [    0.750770] CPU: Trace cache: 12K uops, L1 D cache: 8K
> [    0.750774] CPU: L2 cache: 512K
> [    0.750777] CPU: Physical Processor ID: 3
> [    0.751232] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
> [    0.760000] CPU3: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
> [    0.770000] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> [    0.780000] Brought up 4 CPUs
> [    0.780000] Total of 4 processors activated (16001.01 BogoMIPS).
> [    0.784171] net_namespace: 840 bytes
> [    0.788172] Booting paravirtualized kernel on bare hardware
> [    0.794700] NET: Registered protocol family 16
> [    0.799678] EISA bus registered
> [    0.802804] ACPI: bus type pci registered
> [    0.807824] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
> [    0.815206] PCI: Using configuration type 1 for base access
> [    0.836378] ACPI: Interpreter enabled
> [    0.840000] ACPI: (supports S0 S1 S4 S5)
> [    0.840000] ACPI: Using IOAPIC for interrupt routing
> [    0.858573] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.868111] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.870000] pci 0000:00:1d.7: PME# disabled
> [    0.874284] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH4 ACPI/GP
> IO/TCO
> [    0.880000] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
> [    0.886762] pci 0000:04:01.0: PME# supported from D0 D3hot D3cold
> [    0.890936] pci 0000:04:01.0: PME# disabled
> [    0.897378] pci 0000:04:01.1: PME# supported from D0 D3hot D3cold
> [    0.906489] pci 0000:04:01.1: PME# disabled
> [    0.910000] pci 0000:01:01.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.916351] pci 0000:01:01.0: PME# disabled
> [    0.920000] pci 0000:00:1e.0: transparent bridge
> [    0.929439] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.938083] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.947213] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.956925] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.966020] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *
> 0, disabled.
> [    0.975139] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *
> 0, disabled.
> [    0.980000] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *
> 0, disabled.
> [    0.988059] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.995268] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -
>  42, should be 3F [20080609]
> [    1.007256] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    1.014909] pnp: PnP ACPI init
> [    1.017598] ACPI: bus type pnp registered
> [    1.028881] pnp: PnP ACPI: found 11 devices
> [    1.034516] ACPI: ACPI bus type pnp unregistered
> [    1.038783] PnPBIOS: Disabled by ACPI PNP
> [    1.040353] PCI: Using ACPI for IRQ routing
> [    1.071083] NET: Registered protocol family 8
> [    1.075503] NET: Registered protocol family 20
> [    1.080000] NetLabel: Initializing
> [    1.083467] NetLabel:  domain hash size = 128
> [    1.087002] NetLabel:  protocols = UNLABELED CIPSOv4
> [    1.091055] NetLabel:  unlabeled traffic allowed by default
> [    1.097159] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    1.102596] hpet0: 3 64-bit timers, 14318180 Hz
> [    1.122008] system 00:06: ioport range 0x295-0x296 has been reserved
> [    1.128423] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
> [    1.134840] system 00:06: ioport range 0x800-0x87f has been reserved
> [    1.141255] system 00:06: ioport range 0x480-0x4bf has been reserved
> [    1.147680] system 00:07: ioport range 0x680-0x6ff has been reserved
> [    1.154109] system 00:08: iomem range 0xfec00000-0xfec00fff could not be rese
> rved
> [    1.161661] system 00:08: iomem range 0xfee00000-0xfee00fff could not be rese
> rved
> [    1.169213] system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
> [    1.176554] system 00:08: iomem range 0xfff002c0-0xffff0fff could not be rese
> rved
> [    1.184117] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
> [    1.190793] system 00:0a: iomem range 0xc0000-0xdffff could not be reserved
> [    1.197818] system 00:0a: iomem range 0xe0000-0xfffff could not be reserved
> [    1.204845] system 00:0a: iomem range 0x100000-0xf7ffffff could not be reserv
> ed
> [    1.243413] pci 0000:02:1d.0: PCI bridge, secondary bus 0000:04
> [    1.249398] pci 0000:02:1d.0:   IO window: 0xa000-0xafff
> [    1.254778] pci 0000:02:1d.0:   MEM window: 0xfe900000-0xfe9fffff
> [    1.260933] pci 0000:02:1d.0:   PREFETCH window: 0x000000ff800000-0x000000ff8
> fffff
> [    1.268584] pci 0000:02:1f.0: PCI bridge, secondary bus 0000:03
> [    1.274565] pci 0000:02:1f.0:   IO window: 0x5000-0x9fff
> [    1.279937] pci 0000:02:1f.0:   MEM window: 0xfe800000-0xfe8fffff
> [    1.286214] pci 0000:02:1f.0:   PREFETCH window: 0x000000ff700000-0x000000ff7
> fffff
> [    1.293859] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
> [    1.299838] pci 0000:00:02.0:   IO window: 0x5000-0xafff
> [    1.305217] pci 0000:00:02.0:   MEM window: 0xfe800000-0xfeafffff
> [    1.311371] pci 0000:00:02.0:   PREFETCH window: 0x000000ff700000-0x000000ff9
> fffff
> [    1.319016] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
> [    1.324997] pci 0000:00:1e.0:   IO window: 0x3000-0x4fff
> [    1.330369] pci 0000:00:1e.0:   MEM window: 0xfc700000-0xfe7fffff
> [    1.336538] pci 0000:00:1e.0:   PREFETCH window: 0x000000ff600000-0x000000ff6
> fffff
> [    1.344236] NET: Registered protocol family 2
> [    1.382093] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    1.389803] TCP established hash table entries: 131072 (order: 8, 1048576 byt
> es)
> [    1.398491] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    1.405860] TCP: Hash tables configured (established 131072 bind 65536)
> [    1.412558] TCP reno registered
> [    1.422161] NET: Registered protocol family 1
> [    1.426784] checking if image is initramfs...<7>Switched to high resolution m
> ode on CPU 1
> [    4.149987]  it is
> [    7.122899] Freeing initrd memory: 50592k freed
> [    7.129059] audit: initializing netlink socket (disabled)
> [    7.134550] type=2000 audit(1220568841.122:1): initialized
> [    7.147465] highmem bounce pool size: 64 pages
> [    7.151998] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    7.163271] VFS: Disk quotas dquot_6.5.1
> [    7.167730] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    7.174566] msgmni has been set to 1682
> [    7.178734] io scheduler noop registered
> [    7.182729] io scheduler anticipatory registered
> [    7.187407] io scheduler deadline registered (default)
> [    7.192632] io scheduler cfq registered
> [   17.191875] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> [   17.199160] pci 0000:01:01.0: Firmware left e100 interrupts enabled; disablin
> g
> [   17.207327] isapnp: Scanning for PnP cards...
> [   17.568775] isapnp: No Plug & Play device found
> [   17.635194] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> [   17.641544] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   17.649267] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   17.656419] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   17.662606] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   17.672077] brd: module loaded
> [   17.675335] input: Macintosh mouse button emulation as /class/input/input0
> [   17.682601] PNP: No PS/2 controller found. Probing ports directly.
> [   17.690837] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   17.695871] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   17.720058] mice: PS/2 mouse device common for all mice
> [   17.725671] EISA: Probing bus 0 at eisa.0
> [   17.729765] Cannot allocate resource for EISA slot 3
> [   17.734797] Cannot allocate resource for EISA slot 4
> [   17.739820] Cannot allocate resource for EISA slot 5
> [   17.744844] Cannot allocate resource for EISA slot 6
> [   17.749874] Cannot allocate resource for EISA slot 7
> [   17.754894] Cannot allocate resource for EISA slot 8
> [   17.759924] EISA: Detected 0 cards.
> [   17.763473] cpuidle: using governor ladder
> [   17.767629] cpuidle: using governor menu
> [   17.772706] Using IPI No-Shortcut mode
> [   17.776986] registered taskstats version 1
> [   17.781384] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
> [   17.788644] Freeing unused kernel memory: 416k freed
> [   18.105330] fuse init (API version 7.9)
> [   18.138063] processor ACPI0007:00: registered as cooling_device0
> [   18.144156] ACPI: Processor [CPU1] (supports 8 throttling states)
> [   18.150616] processor ACPI0007:01: registered as cooling_device1
> [   18.156810] processor ACPI0007:02: registered as cooling_device2
> [   18.163020] processor ACPI0007:03: registered as cooling_device3
> [   18.204288] md: linear personality registered for level -1
> [   18.217767] md: multipath personality registered for level -4
> [   18.230806] md: raid0 personality registered for level 0
> [   18.246444] md: raid1 personality registered for level 1
> [   18.258912] xor: automatically using best checksumming function: pIII_sse
> [   18.311146]    pIII_sse  :  2562.000 MB/sec
> [   18.315396] xor: using function: pIII_sse (2562.000 MB/sec)
> [   18.322442] async_tx: api initialized (sync-only)
> [   18.511161] raid6: int32x1    486 MB/s
> [   18.681157] raid6: int32x2    637 MB/s
> [   18.851173] raid6: int32x4    734 MB/s
> [   19.021144] raid6: int32x8    463 MB/s
> [   19.191158] raid6: mmxx1     1659 MB/s
> [   19.361142] raid6: mmxx2     2106 MB/s
> [   19.531186] raid6: sse1x1     996 MB/s
> [   19.701143] raid6: sse1x2    1839 MB/s
> [   19.871156] raid6: sse2x1    1382 MB/s
> [   20.041135] raid6: sse2x2    2254 MB/s
> [   20.044952] raid6: using algorithm sse2x2 (2254 MB/s)
> [   20.050058] md: raid6 personality registered for level 6
> [   20.055435] md: raid5 personality registered for level 5
> [   20.060809] md: raid4 personality registered for level 4
> [   20.107153] md: raid10 personality registered for level 10
> [   20.886491] usbcore: registered new interface driver usbfs
> [   20.892114] usbcore: registered new interface driver hub
> [   20.898018] No dock devices found.
> [   20.907877] usbcore: registered new device driver usb
> [   20.971810] SCSI subsystem initialized
> [   20.978732] USB Universal Host Controller Interface driver v3.0
> [   20.984841] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   20.992082] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [   20.997541] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus numbe
> r 1
> [   21.005087] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000c400
> [   21.011272] usb usb1: configuration #1 chosen from 1 choice
> [   21.017083] hub 1-0:1.0: USB hub found
> [   21.020925] hub 1-0:1.0: 2 ports detected
> [   21.089562] Uniform Multi-Platform E-IDE driver
> [   21.244280] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [   21.251523] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [   21.256947] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus numbe
> r 2
> [   21.264606] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c800
> [   21.270814] usb usb2: configuration #1 chosen from 1 choice
> [   21.276544] hub 2-0:1.0: USB hub found
> [   21.280363] hub 2-0:1.0: 2 ports detected
> [   21.284730] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
> [   21.290921] e100: Copyright(c) 1999-2006 Intel Corporation
> [   21.301288] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> [   21.307833] Copyright (c) 1999-2006 Intel Corporation.
> [   21.369791] usb 1-2: new full speed USB device using uhci_hcd and address 2
> [   21.390717] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [   21.397960] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [   21.403318] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus numbe
> r 3
> [   21.414691] ehci_hcd 0000:00:1d.7: debug port 1
> [   21.419312] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebffc00
> [   21.519886] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec
> 2004
> [   21.527728] usb usb3: configuration #1 chosen from 1 choice
> [   21.533439] hub 3-0:1.0: USB hub found
> [   21.537260] hub 3-0:1.0: 4 ports detected
> [   21.755396] e100 0000:01:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   21.853581] e100: 0000:01:01.0: e100_probe: Error clearing wake event
> [   21.860733] e100: eth0: e100_probe: addr 0xfe7fe000, irq 17, MAC addr 00:e0:8
> 1:2a:81:fc
> [   21.868995] e1000 0000:04:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
> [   21.929793] usb 1-2: device not accepting address 2, error -71
> [   21.999807] hub 1-0:1.0: unable to enumerate USB device on port 2
> [   22.140210] e1000: 0000:04:01.0: e1000_probe: (PCI-X:100MHz:64-bit) 00:e0:81:
> 2a:81:bc
> [   22.192055] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
> [   22.199114] e1000 0000:04:01.1: PCI INT B -> GSI 49 (level, low) -> IRQ 49
> [   22.199034] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
> [   22.199045] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [   22.199291] scsi0 : ata_piix
> [   22.199802] scsi1 : ata_piix
> [   22.201920] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> [   22.201925] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
> [   22.430562] ata1.00: ATA-6: ST3120022A, 3.04, max UDMA/100
> [   22.436114] ata1.00: 234441648 sectors, multi 16: LBA48
> [   22.488975] ata1.00: configured for UDMA/100
> [   22.497774] e1000: 0000:04:01.1: e1000_probe: (PCI-X:100MHz:64-bit) 00:e0:81:
> 2a:81:bd
> [   22.549478] e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
> [   22.555200] hpt366: HPT374 chipset detected
> [   22.559489] hpt366 0000:03:06.0: IDE controller (0x1103:0x0008 rev 0x07)
> [   22.566278] HPT366_IDE 0000:03:06.0: PCI INT A -> GSI 28 (level, low) -> IRQ
> 28
> [   22.573729] usb 1-2: new full speed USB device using uhci_hcd and address 4
> [   22.580726] pci 0000:03:06.1: PCI INT A -> GSI 28 (level, low) -> IRQ 28
> [   22.587529] hpt366 0000:03:06.0: DPLL base: 48 MHz, f_CNT: 142, assuming 33 M
> Hz PCI
> [   22.602705] hpt366 0000:03:06.0: using 50 MHz DPLL clock
> [   22.608181] hpt366 0000:03:06.0: 100% native mode on irq 28
> [   22.613831] hpt366 0000:03:06.1: no clock data saved by BIOS
> [   22.731015] usb 1-2: configuration #1 chosen from 1 choice
> [   22.737191] ata2.00: ATA-6: ST3120022A, 3.04, max UDMA/100
> [   22.738880] hub 1-2:1.0: USB hub found
> [   22.746597] ata2.00: 234441648 sectors, multi 16: LBA48
> [   22.747804] hpt366 0000:03:06.1: DPLL base: 33 MHz, f_CNT: 139, assuming 33 M
> Hz PCI
> [   22.747824] BUG: unable to handle kernel paging request at 03f88f9a
> [   22.747829] IP: [<f88f6174>] :hpt366:init_chipset_hpt366+0x284/0x710
> [   22.747841] *pdpt = 000000003701a001 *pde = 0000000000000000
> [   22.747848] Oops: 0000 [#1] SMP
> [   22.747852] Modules linked in: ata_piix(+) ehci_hcd(+) hpt366(+) e1000 e100 m
> ii ata_generic libata ide_core uhci_hcd scsi_mod dock usbcore raid10 raid456 asy
> nc_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal pro
> cessor fan thermal_sys fuse
> [   22.747876]
> [   22.747880] Pid: 2353, comm: modprobe Not tainted (2.6.27-rc1 #22)
> [   22.747883] EIP: 0060:[<f88f6174>] EFLAGS: 00010206 CPU: 0
> [   22.747890] EIP is at init_chipset_hpt366+0x284/0x710 [hpt366]
> [   22.747894] EAX: 03f88f82 EBX: 0000008b ECX: c011f0e0 EDX: 00000003
> [   22.747897] ESI: 00000002 EDI: f4963000 EBP: 00000021 ESP: f78cbb98
> [   22.747900]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   22.747904] Process modprobe (pid: 2353, ti=f78ca000 task=f49943f0 task.ti=f7
> 8ca000)
> [   22.747907] Stack: f88f6e34 f88f68d9 f49630f4 00000021 0000008b 00000021 f496
> 30f4 00008400
> [   22.747916]        f7932e61 00000121 00000002 00000001 00000000 3f324800 0000
> 0003 001f7f27
> [   22.747923]        f4962c00 0000001c 00000012 f78c008b f4963000 0000001c 0000
> 0000 f78cbd84
> [   22.747931] Call Trace:
> [   22.747936]  [<f8ac9fec>] do_ide_setup_pci_device+0x2c/0x100 [ide_core]
> [   22.747963]  [<f8acabd4>] ide_pci_init_two+0x124/0x180 [ide_core]
> [   22.747984]  [<f88f59be>] hpt366_init_one+0x20e/0x4b0 [hpt366]
> [   22.747991]  [<f88f5ef0>] init_chipset_hpt366+0x0/0x710 [hpt366]
> [   22.747997]  [<f88f5c60>] init_hwif_hpt366+0x0/0x120 [hpt366]
> [   22.748003]  [<f88f5d80>] init_dma_hpt366+0x0/0x170 [hpt366]
> [   22.748011]  [<c023fbd6>] pci_device_probe+0x56/0x80
> [   22.748023]  [<c02a0e92>] driver_probe_device+0x82/0x180
> [   22.748031]  [<c034af5a>] _spin_lock_irqsave+0x2a/0x40
> [   22.748038]  [<c02a0ffc>] __driver_attach+0x6c/0x70
> [   22.748043]  [<c02a063a>] bus_for_each_dev+0x3a/0x60
> [   22.748049]  [<c02a0d16>] driver_attach+0x16/0x20
> [   22.748053]  [<c02a0f90>] __driver_attach+0x0/0x70
> [   22.748057]  [<c02a0b71>] bus_add_driver+0x1a1/0x220
> [   22.748063]  [<c023fb20>] pci_device_remove+0x0/0x40
> [   22.748068]  [<c02a121d>] driver_register+0x4d/0x120
> [   22.748072]  [<c012b1c4>] try_to_wake_up+0xc4/0x160
> [   22.748083]  [<c023fe07>] __pci_register_driver+0x47/0x80
> [   22.748089]  [<c0156d62>] sys_init_module+0x122/0x1c50
> [   22.748099]  [<c0170520>] disable_irq+0x0/0x30
> [   22.748109]  [<c010a056>] syscall_call+0x7/0xb
> [   22.748114]  =======================
> [   22.748117] Code: 20 19 f6 83 e6 fe 83 c6 04 80 7a 05 7f 0f 84 0f 02 00 00 80
>  7c 24 36 00 74 0d c6 44 24 36 32 c7 44 24 38 03 00 00 00 8b 54 24 38 <8b> 4c 90
>  0c 85 c9 0f 85 08 02 00 00 8b 44 24 18 c7 44 24 04 d9
> [   22.748155] EIP: [<f88f6174>] init_chipset_hpt366+0x284/0x710 [hpt366] SS:ESP
>  0068:f78cbb98
> [   22.748165] ---[ end trace 2f3a4c41c18bdb5d ]---
> [   22.753758] hub 1-2:1.0: 4 ports detected
> [   23.030008] ata2.00: limited to UDMA/33 due to 40-wire cable
> [   23.079012] ata2.00: configured for UDMA/33
> [   23.084627] usb 1-2.1: new low speed USB device using uhci_hcd and address 5
> [   23.083510] scsi 0:0:0:0: Direct-Access     ATA      ST3120022A       3.04 PQ
> : 0 ANSI: 5
> [   23.083799] scsi 1:0:0:0: Direct-Access     ATA      ST3120022A       3.04 PQ
> : 0 ANSI: 5
> [   23.279482] usb 1-2.1: configuration #1 chosen from 1 choice
> [   23.326992] usbcore: registered new interface driver hiddev
> [   23.355811] input: SEJIN SEJIN USB joint Keyboard as /class/input/input1
> [   23.390096] input,hidraw0: USB HID v1.10 Keyboard [SEJIN SEJIN USB joint Keyb
> oard] on usb-0000:00:1d.0-2.1
> [   23.400113] usbcore: registered new interface driver usbhid
> [   23.405759] usbhid: v2.6:USB HID core driver
>
> Before the change above, the relevant parts of 'dmesg' look like this:
> [ 18.270601] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c800
> [   18.276680] usb usb3: configuration #1 chosen from 1 choice
> [   18.282382] hub 3-0:1.0: USB hub found
> [   18.286198] hub 3-0:1.0: 2 ports detected
> [   18.369962] usb 2-2: new full speed USB device using uhci_hcd and address 2
> [   18.392516] HPT374: IDE controller (0x1103:0x0008 rev 0x07) at  PCI slot 0000:03:06.0
> [   18.400535] HPT366_IDE 0000:03:06.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
> [   18.408030] pci 0000:03:06.1: PCI INT A -> GSI 28 (level, low) -> IRQ 28
> [   18.414873] HPT374: DPLL base: 48 MHz, f_CNT: 142, assuming 33 MHz PCI
> [   18.428733] HPT374: using 50 MHz DPLL clock
> [   18.433095] HPT374: 100% native mode on irq 28
> [   18.437616] HPT374: DPLL base: 48 MHz, f_CNT: 142, assuming 33 MHz PCI
> [   18.451947] HPT374: using 50 MHz DPLL clock
> [   18.456326]     ide2: BM-DMA at 0x6800-0x6807
> [   18.460766]     ide3: BM-DMA at 0x6808-0x680f
> [   18.465219]     ide0: BM-DMA at 0x8400-0x8407
> [   18.469667]     ide1: BM-DMA at 0x8408-0x840f
> [   18.474109] Probing IDE interface ide2...
> [   18.546660] usb 2-2: configuration #1 chosen from 1 choice
> [   18.554507] hub 2-2:1.0: USB hub found
> [   18.559437] hub 2-2:1.0: 4 ports detected
> ...
> Do you have any idea on how to fix it? The device itself is a
> --
> 03:06.0 RAID bus controller: HighPoint Technologies, Inc. HPT374 (rev 07)
> 03:06.1 RAID bus controller: HighPoint Technologies, Inc. HPT374 (rev 07)
> (With lspci -n, it becomes
> 03:06.0 0104: 1103:0008 (rev 07)
> 03:06.1 0104: 1103:0008 (rev 07)
> )
> Thanks!
> Masoud
> --
>
