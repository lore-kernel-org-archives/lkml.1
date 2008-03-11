Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYCKMF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYCKMF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYCKMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:05:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:57291 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYCKMFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:05:48 -0400
Date: Tue, 11 Mar 2008 08:05:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: 2.6.24.3: WARNING: native_smp_call_function_mask() at boot
 time
In-Reply-To: <alpine.DEB.1.00.0803110751470.10032@p34.internal.lan>
Message-ID: <alpine.DEB.1.00.0803110803270.16072@p34.internal.lan>
References: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan> <alpine.LFD.1.00.0803111104550.3781@apollo.tec.linutronix.de> <alpine.DEB.1.00.0803110751470.10032@p34.internal.lan>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Mar 2008, Justin Piszcz wrote:

>
>
> On Tue, 11 Mar 2008, Thomas Gleixner wrote:
>
>> On Mon, 10 Mar 2008, Justin Piszcz wrote:
>>> Running kernel 2.6.24.3 on Debian Testing here..
>>> 
>>> [   19.141846] WARNING: at arch/x86/kernel/smp_32.c:561
>>> native_smp_call_function_mask()
>>> [   19.141896] Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
>>> [   19.141937]  [<c010e50b>] native_smp_call_function_mask+0x14b/0x150
>>> [   19.142009]  [<c01036c3>] common_interrupt+0x23/0x28
>>> [   19.142076]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
>>> [   19.142144]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
>>> [   19.142212]  [<c010e8fc>] smp_call_function+0x1c/0x30
>>> [   19.142279]  [<c012196c>] on_each_cpu+0x2c/0x60
>>> [   19.142346]  [<c0110840>] setup_nmi+0x30/0x50
>> 
>> Can you please try the backported patch below.
>> 
>> Thanks,
>> 	tglx
>> 
>
> Patching now and will have the result shortly.
>
> # patch -p1 < ../patch
> patching file arch/x86/kernel/apic_32.c
> patching file arch/x86/kernel/apic_64.c
> patching file arch/x86/kernel/io_apic_32.c
> patching file arch/x86/kernel/io_apic_64.c
> patching file arch/x86/kernel/smpboot_32.c
> patching file arch/x86/kernel/smpboot_64.c
> patching file include/asm-x86/apic_32.h
> patching file include/asm-x86/io_apic_64.h
> #
>
>

Patched, problem resolved.  Thomas, will this patch be included in 
2.6.24.4?  Thanks!

Dmesg output:

[    0.000000] Linux version 2.6.24.3 (root@hostname) (gcc version 4.2.3 (Debian 4.2.3-2)) #2 SMP PREEMPT Tue Mar 11 07:53:59 EDT 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] 3200MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f3430
[    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 6400 pages used for memmap
[    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP 000F7330, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT CFEE3040, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP CFEE30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT CFEE3180, 485D (r1 INTELR AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: MCFG CFEE7B40, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC CFEE7A40, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: SSDT CFEE7BC0, 019E (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
[    0.000000] ACPI: SSDT CFEE8050, 02F1 (r1  PmRef    CpuPm     3000 INTL 20041203)
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
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cff00000:10100000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.24.3-2 ro root=802 netconsole=4444@192.168.0.1/eth0,514@192.168.0.254/00:19:D1:6E:9D:43 nmi_watchdog=1
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2720.540 MHz processor.
[   18.907116] Console: colour VGA+ 80x25
[   18.907118] console [tty0] enabled
[   18.909743] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   18.909970] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   19.047676] Memory: 3367044k/4194304k available (3253k kernel code, 38552k reserved, 1071k data, 224k init, 2489216k highmem)
[   19.047733] virtual kernel memory layout:
[   19.047734]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[   19.047735]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   19.047735]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   19.047736]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   19.047737]       .init : 0xc0540000 - 0xc0578000   ( 224 kB)
[   19.047737]       .data : 0xc042d4a4 - 0xc053930c   (1071 kB)
[   19.047738]       .text : 0xc0100000 - 0xc042d4a4   (3253 kB)
[   19.048048] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   19.048153] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   19.108145] Calibrating delay using timer specific routine.. 5443.07 BogoMIPS (lpj=2721535)
[   19.108244] Mount-cache hash table entries: 512
[   19.108375] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[   19.108380] monitor/mwait feature present.
[   19.108419] using mwait in idle threads.
[   19.108459] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.108525] CPU: L2 cache: 4096K
[   19.108564] CPU: Physical Processor ID: 0
[   19.108602] CPU: Processor Core ID: 0
[   19.108640] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[   19.108644] Intel machine check architecture supported.
[   19.108685] Intel machine check reporting enabled on CPU#0.
[   19.108726] Compat vDSO mapped to ffffe000.
[   19.108773] Checking 'hlt' instruction... OK.
[   19.112431] Freeing SMP alternatives: 13k freed
[   19.112471] ACPI: Core revision 20070126
[   19.116541] CPU0: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 06
[   19.116648] Booting processor 1/1 eip 2000
[   19.127530] Initializing CPU#1
[   19.187046] Calibrating delay using timer specific routine.. 5440.15 BogoMIPS (lpj=2720077)
[   19.187050] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[   19.187053] monitor/mwait feature present.
[   19.187055] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.187056] CPU: L2 cache: 4096K
[   19.187058] CPU: Physical Processor ID: 0
[   19.187058] CPU: Processor Core ID: 1
[   19.187059] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[   19.187062] Intel machine check architecture supported.
[   19.187064] Intel machine check reporting enabled on CPU#1.
[   19.187491] CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 06
[   19.187941] Total of 2 processors activated (10883.22 BogoMIPS).
[   19.188126] ENABLING IO-APIC IRQs
[   19.188321] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   19.299909] APIC timer registered as dummy, due to nmi_watchdog=1!
[   19.300012] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   19.320069] Brought up 2 CPUs
[   19.320215] net_namespace: 64 bytes
[   19.320460] NET: Registered protocol family 16
[   19.320580] ACPI: bus type pci registered
[   19.320625] PCI: Using MMCONFIG
[   19.321025] Setting up standard PCI resources
[   19.321730] mtrr: your CPUs had inconsistent variable MTRR settings
[   19.321771] mtrr: probably your BIOS does not setup all CPUs.
[   19.321811] mtrr: corrected configuration.
[   19.322962] ACPI: EC: Look up EC in DSDT
[   19.325653] ACPI: Interpreter enabled
[   19.325692] ACPI: (supports S0 S5)
[   19.325786] ACPI: Using IOAPIC for interrupt routing
[   19.328901] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.329277] Force enabled HPET at base address 0xfed00000
[   19.329281] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[   19.329323] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   19.329822] PCI: Transparent bridge - 0000:00:1e.0
[   19.329880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   19.329990] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   19.330042] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[   19.330094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   19.330145] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   19.338215] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 9 *10 11 12 14 15)
[   19.338621] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *5 7 9 10 11 12 14 15)
[   19.339036] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 *7 9 10 11 12 14 15)
[   19.339440] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9 10 *11 12 14 15)
[   19.339845] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 9 10 11 12 14 15) *0, disabled.
[   19.340317] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 9 10 11 12 14 15) *0, disabled.
[   19.340784] ACPI: PCI Interrupt Link [LNK0] (IRQs 4 5 7 9 10 11 12 14 15) *0, disabled.
[   19.341256] ACPI: PCI Interrupt Link [LNK1] (IRQs *4 5 7 9 10 11 12 14 15)
[   19.341667] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.341723] pnp: PnP ACPI init
[   19.341765] ACPI: bus type pnp registered
[   19.343344] pnpacpi: exceeded the max number of mem resources: 12
[   19.343420] pnp: PnP ACPI: found 13 devices
[   19.343459] ACPI: ACPI bus type pnp unregistered
[   19.343597] SCSI subsystem initialized
[   19.343652] libata version 3.00 loaded.
[   19.343708] usbcore: registered new interface driver usbfs
[   19.343779] usbcore: registered new interface driver hub
[   19.343842] usbcore: registered new device driver usb
[   19.343976] PCI: Using ACPI for IRQ routing
[   19.344015] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   19.348007] hpet clockevent registered
[   19.348010] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   19.348159] hpet0: 3 64-bit timers, 14318180 Hz
[   19.350007] Time: tsc clocksource has been installed.
[   19.353024] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   19.353066] system 00:01: ioport range 0x880-0x88f has been reserved
[   19.353110] system 00:08: ioport range 0x400-0x4bf could not be reserved
[   19.353154] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[   19.353205] system 00:0c: iomem range 0x636500-0xd1ccff could not be reserved
[   19.353247] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[   19.353288] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[   19.353330] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[   19.353371] system 00:0c: iomem range 0xcfee0000-0xcfefffff could not be reserved
[   19.353420] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   19.353462] system 00:0c: iomem range 0x100000-0xcfedffff could not be reserved
[   19.353511] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[   19.354394] system 00:0c: iomem range 0xfed13000-0xfed1dfff could not be reserved
[   19.354443] system 00:0c: iomem range 0xfed20000-0xfed8ffff could not be reserved
[   19.354492] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[   19.354541] system 00:0c: iomem range 0xffb00000-0xffb7ffff could not be reserved
[   19.384785] PCI: Bridge: 0000:00:01.0
[   19.384823]   IO window: b000-bfff
[   19.384862]   MEM window: f8000000-fbffffff
[   19.384901]   PREFETCH window: d0000000-dfffffff
[   19.384940] PCI: Bridge: 0000:00:1c.0
[   19.384984]   IO window: a000-afff
[   19.385023]   MEM window: fda00000-fdafffff
[   19.385063]   PREFETCH window: fd700000-fd7fffff
[   19.385103] PCI: Bridge: 0000:00:1c.2
[   19.385141]   IO window: e000-efff
[   19.385181]   MEM window: fde00000-fdefffff
[   19.385220]   PREFETCH window: fdd00000-fddfffff
[   19.385260] PCI: Bridge: 0000:00:1c.4
[   19.385299]   IO window: d000-dfff
[   19.385338]   MEM window: fdc00000-fdcfffff
[   19.385377]   PREFETCH window: fdb00000-fdbfffff
[   19.385418] PCI: Bridge: 0000:00:1e.0
[   19.385456]   IO window: c000-cfff
[   19.385496]   MEM window: fd900000-fd9fffff
[   19.385535]   PREFETCH window: fd800000-fd8fffff
[   19.385579] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.385656] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   19.385666] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.385743] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   19.385753] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 17
[   19.385830] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   19.385839] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[   19.385917] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   19.385922] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   19.385928] NET: Registered protocol family 2
[   19.394986] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   19.395148] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   19.395493] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[   19.395743] TCP: Hash tables configured (established 131072 bind 65536)
[   19.395784] TCP reno registered
[   19.399482] highmem bounce pool size: 64 pages
[   19.400983] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   19.401153] SGI XFS with no debug enabled
[   19.401536] io scheduler noop registered
[   19.401611] io scheduler cfq registered (default)
[   19.401712] Boot video device is 0000:01:00.0
[   19.401766] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   19.401777] assign_interrupt_mode Found MSI capability
[   19.401826] Allocate Port Service[0000:00:01.0:pcie00]
[   19.401845] Allocate Port Service[0000:00:01.0:pcie03]
[   19.401879] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   19.401902] assign_interrupt_mode Found MSI capability
[   19.401963] Allocate Port Service[0000:00:1c.0:pcie00]
[   19.401989] Allocate Port Service[0000:00:1c.0:pcie02]
[   19.402007] Allocate Port Service[0000:00:1c.0:pcie03]
[   19.402051] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   19.402074] assign_interrupt_mode Found MSI capability
[   19.402130] Allocate Port Service[0000:00:1c.2:pcie00]
[   19.402148] Allocate Port Service[0000:00:1c.2:pcie02]
[   19.402167] Allocate Port Service[0000:00:1c.2:pcie03]
[   19.402212] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   19.402235] assign_interrupt_mode Found MSI capability
[   19.402291] Allocate Port Service[0000:00:1c.4:pcie00]
[   19.402309] Allocate Port Service[0000:00:1c.4:pcie02]
[   19.402327] Allocate Port Service[0000:00:1c.4:pcie03]
[   19.402454] input: Power Button (FF) as /devices/virtual/input/input0
[   19.402495] ACPI: Power Button (FF) [PWRF]
[   19.402572] input: Power Button (CM) as /devices/virtual/input/input1
[   19.402613] ACPI: Power Button (CM) [PWRB]
[   19.412000] Real Time Clock Driver v1.12ac
[   19.412085] Linux agpgart interface v0.102
[   19.412170] Floppy drive(s): fd0 is 1.44M
[   19.426565] FDC 0 is a post-1991 82077
[   19.427669] loop: module loaded
[   19.427743] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   19.427784] Copyright (c) 1999-2006 Intel Corporation.
[   19.427859] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.427945] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   19.484025] e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:1b:21:02:86:95
[   19.541401] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   19.541449] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   19.541489] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   19.541554] netconsole: local port 4444
[   19.541593] netconsole: local IP 192.168.0.1
[   19.541631] netconsole: interface eth0
[   19.541669] netconsole: remote port 514
[   19.541708] netconsole: remote IP 192.168.0.254
[   19.541747] netconsole: remote ethernet address 00:19:d1:6e:9d:43
[   19.541788] netconsole: device eth0 not up yet, forcing it
[   19.848460] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
[   19.848464] Could not switch to high resolution mode on CPU 1
[   19.848580]  lapic is not functional.
[   19.848618] Could not switch to high resolution mode on CPU 0
[   22.620889] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   22.623419] console [netcon0] enabled
[   22.634382] netconsole: network logging started
[   22.634443] Driver 'sd' needs updating - please use bus_type methods
[   22.634505] Driver 'sr' needs updating - please use bus_type methods
[   22.634581] ahci 0000:00:1f.2: version 3.0
[   22.634593] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 18
[   23.634323] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   23.634374] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
[   23.635250] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   23.635385] scsi0 : ahci
[   23.635466] scsi1 : ahci
[   23.635535] scsi2 : ahci
[   23.635615] scsi3 : ahci
[   23.635707] ata1: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe100 irq 218
[   23.635760] ata2: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe180 irq 218
[   23.635815] ata3: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe200 irq 218
[   23.635870] ata4: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe280 irq 218
[   24.090812] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   24.101764] ata1.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
[   24.101811] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   24.102638] ata1.00: configured for UDMA/133
[   24.557299] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   24.711312] ata2.00: ATAPI: TSSTcorpCD/DVDW SH-S183L, SB02, max UDMA/33, ATAPI AN
[   24.711362] ata2.00: applying bridge limits
[   24.864961] ata2.00: configured for UDMA/33
[   25.167629] ata3: SATA link down (SStatus 0 SControl 300)
[   25.470297] ata4: SATA link down (SStatus 0 SControl 300)
[   25.470401] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
[   25.470516] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   25.470574] sd 0:0:0:0: [sda] Write Protect is off
[   25.470614] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   25.470624] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   25.470705] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   25.470763] sd 0:0:0:0: [sda] Write Protect is off
[   25.470803] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   25.470812] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   25.470868]  sda: sda1 sda2
[   25.475679] sd 0:0:0:0: [sda] Attached SCSI disk
[   25.476520] scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S183L SB02 PQ: 0 ANSI: 5
[   25.484713] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   25.484764] Uniform CD-ROM driver Revision: 3.20
[   25.484854] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   25.484911] ata_piix 0000:00:1f.1: version 2.12
[   25.484918] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
[   25.485018] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   25.485050] scsi4 : ata_piix
[   25.485123] scsi5 : ata_piix
[   25.485474] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfb00 irq 14
[   25.485517] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfb08 irq 15
[   25.636176] ata6: port disabled. ignoring.
[   25.647236] ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 17 (level, low) -> IRQ 19
[   25.697389] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[fd9ff000-fd9ff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   25.697520] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
[   25.697601] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   25.697603] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   25.697685] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   25.701621] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   25.701626] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfdfff000
[   25.711031] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   25.711188] usb usb1: configuration #1 chosen from 1 choice
[   25.711251] hub 1-0:1.0: USB hub found
[   25.711299] hub 1-0:1.0: 8 ports detected
[   25.811993] USB Universal Host Controller Interface driver v3.0
[   25.812065] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
[   25.812145] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   25.812147] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   25.812221] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   25.812287] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000ff00
[   25.812423] usb usb2: configuration #1 chosen from 1 choice
[   25.812486] hub 2-0:1.0: USB hub found
[   25.812534] hub 2-0:1.0: 2 ports detected
[   25.912874] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
[   25.912960] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   25.912962] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   25.913028] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   25.913102] uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000fe00
[   25.913234] usb usb3: configuration #1 chosen from 1 choice
[   25.913297] hub 3-0:1.0: USB hub found
[   25.913344] hub 3-0:1.0: 2 ports detected
[   26.013762] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
[   26.013848] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   26.013850] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   26.013923] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   26.013990] uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000fd00
[   26.014124] usb usb4: configuration #1 chosen from 1 choice
[   26.014187] hub 4-0:1.0: USB hub found
[   26.014234] hub 4-0:1.0: 2 ports detected
[   26.114653] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[   26.114733] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   26.114735] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   26.114805] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   26.114873] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fc00
[   26.115006] usb usb5: configuration #1 chosen from 1 choice
[   26.115069] hub 5-0:1.0: USB hub found
[   26.115116] hub 5-0:1.0: 2 ports detected
[   26.215544] Initializing USB Mass Storage driver...
[   26.327355] usb 2-2: new low speed USB device using uhci_hcd and address 2
[   26.496696] usb 2-2: configuration #1 chosen from 1 choice
[   26.704941] usb 3-1: new low speed USB device using uhci_hcd and address 2
[   26.868222] usb 3-1: configuration #1 chosen from 1 choice
[   26.871262] usbcore: registered new interface driver usb-storage
[   26.871304] USB Mass Storage support registered.
[   26.871399] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   26.871440] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   26.871986] serio: i8042 KBD port at 0x60,0x64 irq 1
[   26.872070] mice: PS/2 mouse device common for all mice
[   26.901335] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[   26.903780] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   26.951745] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00508d0000994687]
[   26.954467] abituguru3: found Abit uGuru3, motherboard ID: 0016 (AW9D-MAX)
[   26.954914] coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
[   26.955009] coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
[   26.955105] usbcore: registered new interface driver hiddev
[   26.970285] input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
[   26.973665] input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-2
[   27.245803] hiddev96: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:1d.1-1
[   27.245923] usbcore: registered new interface driver usbhid
[   27.245970] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   27.246044] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
[   27.246223] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   27.246313] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   27.297291] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[   27.337324] ALSA device list:
[   27.337363]   #0: HDA Intel at 0xfdff8000 irq 16
[   27.337412] TCP cubic registered
[   27.337466] NET: Registered protocol family 1
[   27.337519] NET: Registered protocol family 17
[   27.337646] RPC: Registered udp transport module.
[   27.337686] RPC: Registered tcp transport module.
[   27.337726] Testing NMI watchdog ... OK.
[   27.357790] Starting balanced_irq
[   27.357841] Using IPI Shortcut mode
[   27.387094] UDF-fs: No VRS found
[   27.424901] XFS mounting filesystem sda2
[   27.514808] Ending clean XFS mount for filesystem: sda2
[   27.514824] VFS: Mounted root (xfs filesystem) readonly.
[   27.514945] Freeing unused kernel memory: 224k freed
[   30.284544] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 18
[   31.387267] Adding 8393920k swap on /dev/sda1.  Priority:-1 extents:1 across:8393920k
[   46.280624] warning: process `nvidia-installe' used the deprecated sysctl system call with 1.23.
[   46.280777] warning: process `nvidia-installe' used the deprecated sysctl system call with 1.23.
[   46.323310] nvidia: module license 'NVIDIA' taints kernel.
[   46.577240] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   46.577247] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   46.577313] NVRM: loading NVIDIA UNIX x86 Kernel Module  171.05  Tue Jan 22 18:08:39 PST 2008
[   46.597356] warning: process `nvidia-installe' used the deprecated sysctl system call with 1.23.
[  101.219512] PCI: Setting latency timer of device 0000:01:00.0 to 64
[  101.219618] NVRM: loading NVIDIA UNIX x86 Kernel Module  171.05  Tue Jan 22 18:08:39 PST 2008
