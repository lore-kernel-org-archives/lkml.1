Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbXLPFiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbXLPFiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 00:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXLPFiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 00:38:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:59511 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXLPFiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 00:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qu6dQIKQdB1lOiDJjrbCgJ2BRkiw/pvkJs346gDrKcP1CoTDBTremxigCcXHHvci98PvTtrnf960MlzG9MFlSXKqHP9IM+HSzDQMkkDbLjtxKTBuv9n9wE5yHwP9286vQ2t+rx6MuJJHLM/p0idgvGWk1fwNSWMQ47J2rmXaO7s=
Message-ID: <9a8cbed90712152138n2a195eaag790944c231d2e641@mail.gmail.com>
Date: Sun, 16 Dec 2007 00:38:13 -0500
From: "Arun Thomas" <arun.thomas@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200712150107.20400.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
	 <200712150107.20400.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 15, 2007 1:07 AM, Len Brown <lenb@kernel.org> wrote:
<snip>
>
> try CONFIG_HIGH_RES_TIMERS=n
> try "hpet=disable"

The problem still manifests when I unset CONFIG_HIGH_RES_TIMERS,
CONFIG_HPET_TIMER, and CONFIG_NO_HZ (for good measure) in the  kernel
config. The delay occurs later in the bootup process now. Here's a
dmesg snippet:

[   31.895755] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   31.896046] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   31.896203] TCP: Hash tables configured (established 131072 bind 65536)
[   31.896244] TCP reno registered
[   31.907674] checking if image is initramfs... it is
[  541.796307] Freeing initrd memory: 44299k freed
[  541.796748] audit: initializing netlink socket (disabled)
[  541.796798] audit(1197764951.576:1): initialized

Thanks,
Arun

=====================

Full dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.24-rc5 (root@machine) (gcc version
4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #2 SMP Sat Dec
15 23:38:57 EST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099c00 (usable)
[    0.000000]  BIOS-e820: 0000000000099c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe90000 (usable)
[    0.000000]  BIOS-e820: 000000007fe90000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f3f00
[    0.000000] Entering add_active_range(0, 0, 523920) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   523920
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   523920
[    0.000000] On node 0 totalpages: 523920
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2301 pages used for memmap
[    0.000000]   HighMem zone: 292243 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F97A0, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7FEE3080, 005C (r1 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: FACP 7FEE7200, 00F4 (r3 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: DSDT 7FEE3200, 3FFC (r1 DELL   AWRDACPI     1000
MSFT  3000000)
[    0.000000] ACPI: FACS 7FE90000, 0040
[    0.000000] ACPI: HPET 7FEE73C0, 0038 (r1 DELL    FX09    42302E31
AWRD       98)
[    0.000000] ACPI: MCFG 7FEE7400, 003C (r1 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: SLIC 7FEE7440, 0176 (r1 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: DMY2 7FEE75C0, 0080 (r1 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: APIC 7FEE7300, 0084 (r1 DELL    FX09    42302E31
AWRD        0)
[    0.000000] ACPI: SSDT 7FEE7CA0, 0380 (r1  PmRef    CpuPm     3000
INTL 20041203)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
7ff00000:60100000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 519827
[    0.000000] Kernel command line:
root=UUID=8420f2d5-9569-476d-b3fc-6365a9987426 ro
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2992.589 MHz processor.
[   31.280619] Console: colour VGA+ 80x25
[   31.280621] console [tty0] enabled
[   31.283054] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   31.283251] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   31.342926] Memory: 2028880k/2095680k available (2049k kernel code,
65480k reserved, 949k data, 360k init, 1178176k highmem)
[   31.342982] virtual kernel memory layout:
[   31.342983]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[   31.342983]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   31.342984]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   31.342985]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   31.342985]       .init : 0xc03f3000 - 0xc044d000   ( 360 kB)
[   31.342986]       .data : 0xc0300798 - 0xc03edd84   ( 949 kB)
[   31.342986]       .text : 0xc0100000 - 0xc0300798   (2049 kB)
[   31.343295] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   31.343395] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4,
CPUs=2, Nodes=1
[   31.423420] Calibrating delay using timer specific routine..
5989.37 BogoMIPS (lpj=11978751)
[   31.423512] Security Framework initialized
[   31.423553] SELinux:  Disabled at boot.
[   31.423593] Capability LSM initialized
[   31.423636] Mount-cache hash table entries: 512
[   31.423747] Initializing cgroup subsys cpuacct
[   31.423791] CPU: After generic identify, caps: bfebfbff 20100000
00000000 00000000 0000e3fd 00000000 00000001 00000000
[   31.423795] monitor/mwait feature present.
[   31.423833] using mwait in idle threads.
[   31.423873] CPU: L1 I cache: 32K, L1 D cache: 32K
[   31.423938] CPU: L2 cache: 4096K
[   31.423976] CPU: Physical Processor ID: 0
[   31.424014] CPU: Processor Core ID: 0
[   31.424051] CPU: After all inits, caps: bfebfbff 20100000 00000000
00003940 0000e3fd 00000000 00000001 00000000
[   31.424056] Compat vDSO mapped to ffffe000.
[   31.424101] Checking 'hlt' instruction... OK.
[   31.439705] SMP alternatives: switching to UP code
[   31.440655] ACPI: Core revision 20070126
[   31.497466] CPU0: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
[   31.497566] SMP alternatives: switching to SMP code
[   31.497877] Booting processor 1/1 eip 3000
[   31.508358] Initializing CPU#1
[   31.587337] Calibrating delay using timer specific routine..
5985.38 BogoMIPS (lpj=11970776)
[   31.587341] CPU: After generic identify, caps: bfebfbff 20100000
00000000 00000000 0000e3fd 00000000 00000001 00000000
[   31.587344] monitor/mwait feature present.
[   31.587346] CPU: L1 I cache: 32K, L1 D cache: 32K
[   31.587347] CPU: L2 cache: 4096K
[   31.587348] CPU: Physical Processor ID: 0
[   31.587349] CPU: Processor Core ID: 1
[   31.587350] CPU: After all inits, caps: bfebfbff 20100000 00000000
00003940 0000e3fd 00000000 00000001 00000000
[   31.587852] CPU1: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
[   31.588225] Total of 2 processors activated (11974.76 BogoMIPS).
[   31.588398] ENABLING IO-APIC IRQs
[   31.588590] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   31.735333] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   31.755397] Brought up 2 CPUs
[   31.755450] CPU0 attaching sched-domain:
[   31.755451]  domain 0: span 03
[   31.755452]   groups: 01 02
[   31.755454] CPU1 attaching sched-domain:
[   31.755455]  domain 0: span 03
[   31.755456]   groups: 02 01
[   31.755581] net_namespace: 64 bytes
[   31.755622] Booting paravirtualized kernel on bare hardware
[   31.755916] Time:  0:20:42  Date: 12/16/07
[   31.755981] NET: Registered protocol family 16
[   31.756111] EISA bus registered
[   31.756150] ACPI: bus type pci registered
[   31.756230] PCI: Using MMCONFIG
[   31.756588] Setting up standard PCI resources
[   31.757730] mtrr: your CPUs had inconsistent fixed MTRR settings
[   31.757769] mtrr: probably your BIOS does not setup all CPUs.
[   31.757809] mtrr: corrected configuration.
[   31.758568] ACPI: EC: Look up EC in DSDT
[   31.760761] ACPI: Interpreter enabled
[   31.760800] ACPI: (supports S0 S3 S5)
[   31.760920] ACPI: Using IOAPIC for interrupt routing
[   31.763322] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   31.763929] PCI: Transparent bridge - 0000:00:1e.0
[   31.763982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   31.764081] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   31.772299] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[   31.772714] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11
12 14 15) *0, disabled.
[   31.773188] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[   31.773600] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[   31.774015] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[   31.774428] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[   31.774841] ACPI: PCI Interrupt Link [LNK0] (IRQs *3 4 5 7 9 10 11 12 14 15)
[   31.775256] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 *4 5 7 9 10 11 12 14 15)
[   31.775673] Linux Plug and Play Support v0.97 (c) Adam Belay
[   31.775726] pnp: PnP ACPI init
[   31.775766] ACPI: bus type pnp registered
[   31.776735] pnpacpi: exceeded the max number of mem resources: 12
[   31.776806] pnp: PnP ACPI: found 11 devices
[   31.776844] ACPI: ACPI bus type pnp unregistered
[   31.776883] PnPBIOS: Disabled by ACPI PNP
[   31.777005] PCI: Using ACPI for IRQ routing
[   31.777044] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   31.803468] NET: Registered protocol family 8
[   31.803508] NET: Registered protocol family 20
[   31.807325] Time: tsc clocksource has been installed.
[   31.823514] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   31.823557] system 00:01: ioport range 0x800-0x87f has been reserved
[   31.823603] system 00:01: ioport range 0x290-0x297 has been reserved
[   31.823644] system 00:01: ioport range 0x880-0x88f has been reserved
[   31.823687] system 00:07: ioport range 0x400-0x4bf has been reserved
[   31.823730] system 00:09: iomem range 0xe0000000-0xefffffff could
not be reserved
[   31.823780] system 00:0a: iomem range 0xf0000-0xfffff could not be reserved
[   31.823822] system 00:0a: iomem range 0x7ff00000-0x7fffffff has been reserved
[   31.823863] system 00:0a: iomem range 0xfed00000-0xfed000ff could
not be reserved
[   31.823912] system 00:0a: iomem range 0x7fe90000-0x7fefffff could
not be reserved
[   31.823961] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[   31.824002] system 00:0a: iomem range 0x100000-0x7fe8ffff could not
be reserved
[   31.824051] system 00:0a: iomem range 0xfec00000-0xfec00fff could
not be reserved
[   31.824100] system 00:0a: iomem range 0xfed14000-0xfed1dfff could
not be reserved
[   31.824149] system 00:0a: iomem range 0xfed20000-0xfed9ffff could
not be reserved
[   31.824198] system 00:0a: iomem range 0xfee00000-0xfee00fff could
not be reserved
[   31.824247] system 00:0a: iomem range 0xffb00000-0xffb7ffff could
not be reserved
[   31.824296] system 00:0a: iomem range 0xfff00000-0xffffffff could
not be reserved
[   31.854532] PCI: Bridge: 0000:00:01.0
[   31.854569]   IO window: d000-dfff
[   31.854607]   MEM window: f8000000-fbffffff
[   31.854645]   PREFETCH window: d0000000-dfffffff
[   31.854684] PCI: Bridge: 0000:00:1e.0
[   31.854722]   IO window: c000-cfff
[   31.854761]   MEM window: fdd00000-fddfffff
[   31.854799]   PREFETCH window: fde00000-fdefffff
[   31.854842] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   31.854918] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   31.854923] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   31.854928] NET: Registered protocol family 2
[   31.895598] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   31.895755] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   31.896046] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   31.896203] TCP: Hash tables configured (established 131072 bind 65536)
[   31.896244] TCP reno registered
[   31.907674] checking if image is initramfs... it is
[  541.796307] Freeing initrd memory: 44299k freed
[  541.796748] audit: initializing netlink socket (disabled)
[  541.796798] audit(1197764951.576:1): initialized
[  541.796967] highmem bounce pool size: 64 pages
[  541.797994] VFS: Disk quotas dquot_6.5.1
[  541.798068] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[  541.798179] io scheduler noop registered
[  541.798217] io scheduler anticipatory registered
[  541.798256] io scheduler deadline registered
[  541.798299] io scheduler cfq registered (default)
[  541.798428] Boot video device is 0000:01:00.0
[  541.798477] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  541.798487] assign_interrupt_mode Found MSI capability
[  541.798535] Allocate Port Service[0000:00:01.0:pcie00]
[  541.798553] Allocate Port Service[0000:00:01.0:pcie03]
[  541.798659] isapnp: Scanning for PnP cards...
[  542.151548] isapnp: No Plug & Play device found
[  542.161922] Real Time Clock Driver v1.12ac
[  542.161963] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
[  542.162597] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[  542.162678] input: Macintosh mouse button emulation as /class/input/input0
[  542.162785] PNP: No PS/2 controller found. Probing ports directly.
[  542.163089] serio: i8042 KBD port at 0x60,0x64 irq 1
[  542.163132] serio: i8042 AUX port at 0x60,0x64 irq 12
[  542.192724] mice: PS/2 mouse device common for all mice
[  542.192821] EISA: Probing bus 0 at eisa.0
[  542.192879] EISA: Detected 0 cards.
[  542.192958] TCP cubic registered
[  542.192999] NET: Registered protocol family 1
[  542.193051] Using IPI No-Shortcut mode
[  542.193155]   Magic number: 3:506:304
[  542.193217]   hash matches device tty33
[  542.193362] Freeing unused kernel memory: 360k freed
[  542.300168] fuse init (API version 7.9)
[  542.302846] ACPI: Fan [FAN] (on)
[  542.305823] ACPI: SSDT 7FEE7680, 022A (r1  PmRef  Cpu0Ist     3000
INTL 20040311)
[  542.306072] ACPI: SSDT 7FEE7B40, 0152 (r1  PmRef  Cpu1Ist     3000
INTL 20040311)
[  542.306242] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[  542.306350] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[  542.307254] ACPI: Thermal Zone [THRM] (40 C)
[  542.585020] usbcore: registered new interface driver usbfs
[  542.585078] usbcore: registered new interface driver hub
[  542.585223] usbcore: registered new device driver usb
[  542.586051] USB Universal Host Controller Interface driver v3.0
[  542.586121] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level,
low) -> IRQ 16
[  542.586202] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[  542.586204] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[  542.586341] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[  542.586410] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fe00
[  542.586519] usb usb1: configuration #1 chosen from 1 choice
[  542.586571] hub 1-0:1.0: USB hub found
[  542.586610] hub 1-0:1.0: 2 ports detected
[  542.628698] SCSI subsystem initialized
[  542.638501] libata version 3.00 loaded.
[  542.688450] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level,
low) -> IRQ 17
[  542.688538] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[  542.688541] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[  542.688603] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 2
[  542.688675] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000fd00
[  542.688775] usb usb2: configuration #1 chosen from 1 choice
[  542.688826] hub 2-0:1.0: USB hub found
[  542.688866] hub 2-0:1.0: 2 ports detected
[  542.792623] ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19 (level,
low) -> IRQ 18
[  542.792705] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[  542.792708] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[  542.792772] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 3
[  542.792838] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000fc00
[  542.792932] usb usb3: configuration #1 chosen from 1 choice
[  542.792983] hub 3-0:1.0: USB hub found
[  542.793022] hub 3-0:1.0: 2 ports detected
[  542.896839] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 19
[  542.896921] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  542.896923] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[  542.896987] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[  542.897052] uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000fb00
[  542.897149] usb usb4: configuration #1 chosen from 1 choice
[  542.897202] hub 4-0:1.0: USB hub found
[  542.897242] hub 4-0:1.0: 2 ports detected
[  543.001054] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 18
[  543.001136] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  543.001138] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[  543.001194] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 5
[  543.001264] uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000fa00
[  543.001363] usb usb5: configuration #1 chosen from 1 choice
[  543.001414] hub 5-0:1.0: USB hub found
[  543.001453] hub 5-0:1.0: 2 ports detected
[  543.033190] usb 2-2: new full speed USB device using uhci_hcd and address 2
[  543.105300] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 20
[  543.105382] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  543.105385] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[  543.105442] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 6
[  543.105514] uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000f900
[  543.105609] usb usb6: configuration #1 chosen from 1 choice
[  543.105660] hub 6-0:1.0: USB hub found
[  543.105699] hub 6-0:1.0: 2 ports detected
[  543.176521] usb 2-2: configuration #1 chosen from 1 choice
[  543.179481] hub 2-2:1.0: USB hub found
[  543.181464] hub 2-2:1.0: 2 ports detected
[  543.209917] ahci 0000:00:1f.2: version 3.0
[  543.209929] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level,
low) -> IRQ 18
[  543.488295] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
[  543.610292] usb 2-2.1: configuration #1 chosen from 1 choice
[  543.613243] hub 2-2.1:1.0: USB hub found
[  543.615223] hub 2-2.1:1.0: 4 ports detected
[  543.945043] usb 2-2.1.1: new full speed USB device using uhci_hcd
and address 4
[  544.145997] usb 2-2.1.1: configuration #1 chosen from 1 choice
[  544.216937] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
Gbps 0x3f impl RAID mode
[  544.216997] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp
pio slum part
[  544.217047] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[  544.217222] scsi0 : ahci
[  544.217337] scsi1 : ahci
[  544.217437] scsi2 : ahci
[  544.217536] scsi3 : ahci
[  544.217635] scsi4 : ahci
[  544.217736] scsi5 : ahci
[  544.217829] ata1: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc100 irq 222
[  544.217878] ata2: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc180 irq 222
[  544.217927] ata3: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc200 irq 222
[  544.217977] ata4: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc280 irq 222
[  544.218027] ata5: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc300 irq 222
[  544.218077] ata6: SATA max UDMA/133 abar m2048@0xfdffc000 port
0xfdffc380 irq 222
[  544.370809] usb 2-2.1.3: new low speed USB device using uhci_hcd
and address 5
[  544.501803] usb 2-2.1.3: configuration #1 chosen from 1 choice
[  544.723612] usb 2-2.1.4: new low speed USB device using uhci_hcd
and address 6
[  544.894587] usb 2-2.1.4: configuration #1 chosen from 1 choice
[  544.932540] usbcore: registered new interface driver hiddev
[  544.932542] usbcore: registered new interface driver libusual
[  544.936026] Initializing USB Mass Storage driver...
[  544.936103] scsi6 : SCSI emulation for USB Mass Storage devices
[  544.936175] usb-storage: device found at 4
[  544.936176] usb-storage: waiting for device to settle before scanning
[  544.945628] input: USB Optical Mouse as /class/input/input1
[  544.971371] input: USB HID v1.11 Mouse [USB Optical Mouse] on
usb-0000:00:1a.1-2.1.3
[  545.003628] input: Dell Dell USB Keyboard as /class/input/input2
[  545.015490] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard]
on usb-0000:00:1a.1-2.1.4
[  545.015611] usbcore: registered new interface driver usbhid
[  545.015614] usbcore: registered new interface driver usb-storage
[  545.015618] USB Mass Storage support registered.
[  545.015737] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[  545.869242] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  545.886749] ata1.00: ATA-8: SAMSUNG HD321KJ, CP100-12, max UDMA7
[  545.886792] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[  545.888812] ata1.00: configured for UDMA/133
[  547.536852] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  547.693849] ata2.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, max UDMA/100
[  547.850200] ata2.00: configured for UDMA/100
[  548.170055] ata3: SATA link down (SStatus 0 SControl 300)
[  548.490720] ata4: SATA link down (SStatus 0 SControl 300)
[  549.952738] usb-storage: device scan complete
[  549.956746] scsi 6:0:0:0: Direct-Access     Generic  Flash HS-CF
  4.44 PQ: 0 ANSI: 0
[  549.960739] scsi 6:0:0:1: Direct-Access     Generic  Flash HS-COMBO
  4.44 PQ: 0 ANSI: 0
[  549.968762] sd 6:0:0:0: [sda] Attached SCSI removable disk
[  550.018730] sd 6:0:0:1: [sdb] Attached SCSI removable disk
[  550.021211] sd 6:0:0:0: Attached scsi generic sg0 type 0
[  550.021263] sd 6:0:0:1: Attached scsi generic sg1 type 0
[  550.142456] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  550.300526] ata5.00: ATAPI: HL-DT-ST DVD+/-RW GSA-H73N, B103, max UDMA/100
[  550.456962] ata5.00: configured for UDMA/100
[  550.775788] ata6: SATA link down (SStatus 0 SControl 300)
[  550.775911] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
HD321KJ  CP10 PQ: 0 ANSI: 5
[  550.776023] sd 0:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[  550.776071] sd 0:0:0:0: [sdc] Write Protect is off
[  550.776110] sd 0:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  550.776123] sd 0:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  550.776197] sd 0:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[  550.776243] sd 0:0:0:0: [sdc] Write Protect is off
[  550.776282] sd 0:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  550.776294] sd 0:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  550.776344]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 >
[  550.877505] sd 0:0:0:0: [sdc] Attached SCSI disk
[  550.877562] sd 0:0:0:0: Attached scsi generic sg2 type 0
[  550.878917] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM
GDRH20N  0D04 PQ: 0 ANSI: 5
[  550.879022] scsi 1:0:0:0: Attached scsi generic sg3 type 5
[  550.880504] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD+-RW
GSA-H73N B103 PQ: 0 ANSI: 5
[  550.880611] scsi 4:0:0:0: Attached scsi generic sg4 type 5
[  550.880827] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level,
low) -> IRQ 20
[  550.880908] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[  550.880910] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[  550.880964] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 7
[  550.884903] PCI: cache line size of 32 is not supported by device
0000:00:1a.7
[  550.884907] ehci_hcd 0000:00:1a.7: irq 20, io mem 0xfdffe000
[  550.899634] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[  550.899677] Uniform CD-ROM driver Revision: 3.20
[  550.899739] sr 1:0:0:0: Attached scsi CD-ROM sr0
[  550.900190] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[  550.900311] usb usb7: configuration #1 chosen from 1 choice
[  550.900364] hub 7-0:1.0: USB hub found
[  550.900404] hub 7-0:1.0: 6 ports detected
[  550.905741] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[  550.905806] sr 4:0:0:0: Attached scsi CD-ROM sr1
[  551.004505] usb 2-2: USB disconnect, address 2
[  551.004549] usb 2-2.1: USB disconnect, address 3
[  551.004589] usb 2-2.1.1: USB disconnect, address 4
[  551.004734] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 19
[  551.004821] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  551.004823] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[  551.004878] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 8
[  551.005010] usb 2-2.1.3: USB disconnect, address 5
[  551.008829] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[  551.008832] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfdffd000
[  551.024639] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[  551.024761] usb usb8: configuration #1 chosen from 1 choice
[  551.024814] hub 8-0:1.0: USB hub found
[  551.024854] hub 8-0:1.0: 6 ports detected
[  551.028654] usb 2-2.1.4: USB disconnect, address 6
[  551.179613] kjournald starting.  Commit interval 5 seconds
[  551.179619] EXT3-fs: mounted filesystem with ordered data mode.
[  551.429834] usb 7-4: new high speed USB device using ehci_hcd and address 2
[  551.562688] usb 7-4: configuration #1 chosen from 1 choice
[  551.562890] hub 7-4:1.0: USB hub found
[  551.562994] hub 7-4:1.0: 2 ports detected
[  551.867457] usb 7-4.1: new high speed USB device using ehci_hcd and address 3
[  551.960221] usb 7-4.1: configuration #1 chosen from 1 choice
[  551.960422] hub 7-4.1:1.0: USB hub found
[  551.960526] hub 7-4.1:1.0: 4 ports detected
[  552.264984] usb 7-4.1.1: new high speed USB device using ehci_hcd
and address 4
[  552.444197] usb 7-4.1.1: configuration #1 chosen from 1 choice
[  552.444444] scsi7 : SCSI emulation for USB Mass Storage devices
[  552.444520] usb-storage: device found at 4
[  552.444522] usb-storage: waiting for device to settle before scanning
[  552.642526] usb 7-4.1.3: new low speed USB device using ehci_hcd
and address 5
[  552.738030] usb 7-4.1.3: configuration #1 chosen from 1 choice
[  552.739860] input: USB Optical Mouse as /class/input/input3
[  552.750913] input: USB HID v1.11 Mouse [USB Optical Mouse] on
usb-0000:00:1a.7-4.1.3
[  552.951980] usb 7-4.1.4: new low speed USB device using ehci_hcd
and address 6
[  553.074968] usb 7-4.1.4: configuration #1 chosen from 1 choice
[  553.087950] input: Dell Dell USB Keyboard as /class/input/input4
[  553.100372] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard]
on usb-0000:00:1a.7-4.1.4
[  557.293650] iTCO_vendor_support: vendor-support=0
[  557.450277] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[  557.450375] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0460)
[  557.450440] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[  557.471135] usb-storage: device scan complete
[  557.474372] scsi 7:0:0:0: Direct-Access     Generic  Flash HS-CF
  4.44 PQ: 0 ANSI: 0
[  557.477622] scsi 7:0:0:1: Direct-Access     Generic  Flash HS-COMBO
  4.44 PQ: 0 ANSI: 0
[  557.481879] sd 7:0:0:0: [sda] Attached SCSI removable disk
[  557.481944] sd 7:0:0:0: Attached scsi generic sg0 type 0
[  557.531359] sd 7:0:0:1: [sdb] Attached SCSI removable disk
[  557.531423] sd 7:0:0:1: Attached scsi generic sg1 type 0
[  557.558508] input: Power Button (FF) as /class/input/input5
[  557.599211] ACPI: Power Button (FF) [PWRF]
[  557.599297] input: Power Button (CM) as /class/input/input6
[  557.655383] ACPI: Power Button (CM) [PWRB]
[  557.668439] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[  557.668481] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[  557.668551] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level,
low) -> IRQ 21
[  557.668636] PCI: Setting latency timer of device 0000:00:19.0 to 64
[  557.689999] Linux agpgart interface v0.102
[  557.710727] input: PC Speaker as /class/input/input7
[  557.752890] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  557.757628] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1)
00:1a:a0:9e:5d:da
[  557.757678] 0000:00:19.0: eth0: Intel(R) PRO/10/100 Network Connection
[  557.757738] 0000:00:19.0: eth0: MAC: 5, PHY: 7, PBA No: ffffff-0ff
[  557.763758] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  558.463971] lp: driver loaded but no devices found
[  558.567849] Adding 4192924k swap on /dev/sdc6.  Priority:-1
extents:1 across:4192924k
[  558.778771] EXT3 FS on sdc7, internal journal
[  559.111052] kjournald starting.  Commit interval 5 seconds
[  559.111272] EXT3 FS on sdc5, internal journal
[  559.111275] EXT3-fs: mounted filesystem with ordered data mode.
[  560.148929] No dock devices found.
[  560.242879] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[  562.327992] NET: Registered protocol family 10
[  562.328111] lo: Disabled Privacy Extensions
[  562.328313] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  562.476637] ppdev: user-space parallel port driver
[  562.867975] 0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex,
Flow Control: RX/TX
[  562.867978] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[  562.868753] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  562.961715] Bluetooth: Core ver 2.11
[  562.961751] NET: Registered protocol family 31
[  562.961752] Bluetooth: HCI device and connection manager initialized
[  562.961755] Bluetooth: HCI socket layer initialized
[  562.974402] Bluetooth: L2CAP ver 2.9
[  562.974405] Bluetooth: L2CAP socket layer initialized
[  563.056090] Bluetooth: RFCOMM socket layer initialized
[  563.056099] Bluetooth: RFCOMM TTY layer initialized
[  563.056100] Bluetooth: RFCOMM ver 1.8
[  567.180365] NET: Registered protocol family 17
[  579.175070] eth0: no IPv6 routers present
