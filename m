Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbXKGGSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbXKGGSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXKGGSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:18:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbXKGGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:18:00 -0500
Date: Tue, 6 Nov 2007 22:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jordan Russell <jr-list-2007@quo.to>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.23.1: Random hangs during boot with "tsc" clocksource
Message-Id: <20071106221548.c8d7b41b.akpm@linux-foundation.org>
In-Reply-To: <472B59E8.3080709@quo.to>
References: <472B59E8.3080709@quo.to>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 02 Nov 2007 12:10:00 -0500 Jordan Russell <jr-list-2007@quo.to> wrote:
> Hi,
> 
> With 2.6.23.1 (stock and Fedora), roughly 50% of the time my system
> hangs indefinitely during the kernel boot process. The hangs occur in
> places where normally a brief delay is seen, such as when detecting
> serial ports, ATA devices, and USB hubs. SysRq+W, when it works, shows
> tasks stuck inside schedule_timeout and lock_timer_base.
> 
> I've found, however, that if I override the default "tsc" clocksource
> with "acpi_pm" by adding "clocksource=acpi_pm" to the kernel command
> line, the system comes up fine every time. (Zero hangs in ~50 tries.)
> 
> I never had to do this with stock kernels based on 2.6.22.10 and
> earlier, which also defaulted to "tsc" on my system.
> 
> I came across this thread:
>   http://lkml.org/lkml/2007/10/16/339
> but I'm not sure if it's the same issue. I've never seen a "Clocksource
> tsc unstable" message, and the kernel doesn't appear to unwedge itself
> after 5 minutes (I waited 20 minutes once).
> 
> Any ideas?
> 
> Thanks,
> Jordan Russell
> 
> --------------------------------------------------------------------
> 
> Motherboard: Supermicro X6DLP-EG2
> CPU: Intel Xeon LV (essentially a rebranded mobile Core Duo)
> 
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 14
> model name      : Intel(R) Xeon(TM) CPU                 @ 1.66GHz
> stepping        : 8
> cpu MHz         : 1666.846
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
> bogomips        : 3335.39
> clflush size    : 64
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 14
> model name      : Intel(R) Xeon(TM) CPU                 @ 1.66GHz
> stepping        : 8
> cpu MHz         : 1666.846
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
> bogomips        : 3333.68
> clflush size    : 64
> 
> --------------------------------------------------------------------
> 
> dmesg (from a non-hanging boot without "clocksource=acpi_pm"):
> 
> Linux version 2.6.23.1x (root@hostname) (gcc version 4.1.2 20070925 (Red
> Hat 4.1.2-27)) #3 SMP Tue Oct 30 18:21:58 CDT 2007
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003ffe0000 (usable)
>  BIOS-e820: 000000003ffe0000 - 000000003ffef000 (ACPI data)
>  BIOS-e820: 000000003ffef000 - 000000003ffff6d0 (ACPI NVS)
>  BIOS-e820: 000000003ffff6d0 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec86000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> 127MB HIGHMEM available.
> 896MB LOWMEM available.
> found SMP MP-table at 000ff780
> NX (Execute Disable) protection: active
> Entering add_active_range(0, 0, 262112) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   229376
>   HighMem    229376 ->   262112
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   262112
> On node 0 totalpages: 262112
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 1760 pages used for memmap
>   Normal zone: 223520 pages, LIFO batch:31
>   HighMem zone: 255 pages used for memmap
>   HighMem zone: 32481 pages, LIFO batch:7
>   Movable zone: 0 pages used for memmap
> DMI 2.3 present.
> Using APIC driver default
> ACPI: RSDP 000FA930, 0014 (r0 ACPIAM)
> ACPI: RSDT 3FFE0000, 0034 (r1 A M I  OEMRSDT   4000605 MSFT       97)
> ACPI: FACP 3FFE0200, 0084 (r2 A M I  OEMFACP   4000605 MSFT       97)
> ACPI: DSDT 3FFE0460, 39E0 (r1  DLP4G DLP4G007        7 INTL  2002026)
> ACPI: FACS 3FFEF000, 0040
> ACPI: APIC 3FFE0390, 0078 (r1 A M I  OEMAPIC   4000605 MSFT       97)
> ACPI: OEMB 3FFEF040, 0040 (r1 A M I  AMI_OEM   4000605 MSFT       97)
> ACPI: MCFG 3FFE3E40, 003C (r1 A M I  OEMMCFG   4000605 MSFT       97)
> ACPI: PM-Timer IO Port: 0x408
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Processor #0 6:14 APIC version 20
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> Processor #1 6:14 APIC version 20
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 3, version 32, address 0xfec10000, GSI 24-47
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Enabling APIC mode:  Flat.  Using 2 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> Built 1 zonelists in Zone order.  Total pages: 260065
> Kernel command line: ro root=/dev/md0 1
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> mapped IOAPIC to ffff9000 (fec10000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> CPU 0 irqstacks, hard=c0449000 soft=c0447000
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Detected 1666.871 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 1031884k/1048448k available (2269k kernel code, 15784k reserved,
> 840k data, 212k init, 130944k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff7e000 - 0xfffff000   ( 516 kB)
>     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc040f000 - 0xc0444000   ( 212 kB)
>       .data : 0xc0337424 - 0xc040955c   ( 840 kB)
>       .text : 0xc0100000 - 0xc0337424   (2269 kB)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> Calibrating delay using timer specific routine.. 3335.39 BogoMIPS
> (lpj=16676950)
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
> 0000c1a9 00000000 00000000 00000000
> monitor/mwait feature present.
> using mwait in idle threads.
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> CPU: After all inits, caps: bfebfbff 00100000 00000000 00002940 0000c1a9
> 00000000 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Compat vDSO mapped to ffffe000.
> Checking 'hlt' instruction... OK.
> SMP alternatives: switching to UP code
> ACPI: Core revision 20070126
> CPU0: Intel(R) Xeon(TM) CPU                 @ 1.66GHz stepping 08
> SMP alternatives: switching to SMP code
> Booting processor 1/1 eip 2000
> CPU 1 irqstacks, hard=c044a000 soft=c0448000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3333.67 BogoMIPS
> (lpj=16668380)
> CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
> 0000c1a9 00000000 00000000 00000000
> monitor/mwait feature present.
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU: After all inits, caps: bfebfbff 00100000 00000000 00002940 0000c1a9
> 00000000 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: Intel(R) Xeon(TM) CPU                 @ 1.66GHz stepping 08
> Total of 2 processors activated (6669.06 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG
> support.
> PCI: Using MMCONFIG
> Setting up standard PCI resources
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
> PCI quirk: region 0500-053f claimed by ICH4 GPIO
> PCI: Transparent bridge - 0000:00:1e.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPC0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPC1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
> disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
> disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
> disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 14 devices
> ACPI: ACPI bus type pnp unregistered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
> report
> Time: tsc clocksource has been installed.
> pnp: 00:07: iomem range 0xfed20000-0xfed8ffff has been reserved
> pnp: 00:08: ioport range 0x295-0x296 has been reserved
> pnp: 00:08: ioport range 0xb78-0xb7f has been reserved
> pnp: 00:08: iomem range 0xfec00000-0xfec00fff could not be reserved
> pnp: 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
> pnp: 00:08: iomem range 0xfec10000-0xfec1ffff could not be reserved
> pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
> pnp: 00:0b: ioport range 0x680-0x6ff has been reserved
> pnp: 00:0c: iomem range 0xe0000000-0xefffffff could not be reserved
> pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
> pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
> pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
> pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
> PCI: Bridge: 0000:00:02.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:04.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:06.0
>   IO window: c000-cfff
>   MEM window: fea00000-feafffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:07.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1e.0
>   IO window: b000-bfff
>   MEM window: fc900000-fe9fffff
>   PREFETCH window: 50000000-500fffff
> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:04.0 to 64
> ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:07.0 to 64
> PCI: Setting latency timer of device 0000:00:1e.0 to 64
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> checking if image is initramfs... it is
> Freeing initrd memory: 2781k freed
> audit: initializing netlink socket (disabled)
> audit(1193965848.069:1): initialized
> highmem bounce pool size: 64 pages
> Total HugeTLB memory allocated, 0
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> Boot video device is 0000:01:02.0
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> Allocate Port Service[0000:00:02.0:pcie00]
> Allocate Port Service[0000:00:02.0:pcie01]
> PCI: Setting latency timer of device 0000:00:04.0 to 64
> Allocate Port Service[0000:00:04.0:pcie00]
> Allocate Port Service[0000:00:04.0:pcie01]
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> Allocate Port Service[0000:00:06.0:pcie00]
> Allocate Port Service[0000:00:06.0:pcie01]
> PCI: Setting latency timer of device 0000:00:07.0 to 64
> Allocate Port Service[0000:00:07.0:pcie00]
> Allocate Port Service[0000:00:07.0:pcie01]
> AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
> AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
> AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
> AER service couldn't init device 0000:00:07.0:pcie01 - no _OSC support
> ACPI Warning (tbutils-0217): Incorrect checksum in table [SSDT] -  9B,
> should be D3 [20070126]
> ACPI: SSDT 3FFE3E80, 0440 (r1    AMI   CPU1PM        1 INTL  2002026)
> ACPI: Processor [CPU1] (supports 8 throttling states)
> ACPI: SSDT 3FFE42C0, 022D (r1    AMI   CPU2PM        1 INTL  2002026)
> ACPI Error (psargs-0355): [TYPE] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_PR_.CPU2._PDC] (Node f7d32240), AE_NOT_FOUND
> ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is
> not present [20070126]
> ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is
> not present [20070126]
> isapnp: Scanning for PnP cards...
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> isapnp: No Plug & Play device found
> Real Time Clock Driver v1.12ac
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> FDC 0 is a post-1991 82077
> RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
> loop: module loaded
> usbcore: registered new interface driver libusual
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard as /class/input/input0
> md: raid1 personality registered for level 1
> EDAC MC: Ver: 2.1.0 Oct 30 2007
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> Using IPI No-Shortcut mode
> Freeing unused kernel memory: 212k freed
> Write protecting the kernel read-only data: 626k
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000d400
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000d800
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
> ehci_hcd 0000:00:1d.7: debug port 1
> PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> ehci_hcd 0000:00:1d.7: irq 18, io mem 0xfebffc00
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 4 ports detected
> SCSI subsystem initialized
> libata version 2.21 loaded.
> ata_piix 0000:00:1f.1: version 2.12
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:1f.1 to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00
> irq 14
> ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08
> irq 15
> ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
> ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi2 : ata_piix
> scsi3 : ata_piix
> ata3: SATA max UDMA/133 cmd 0x0001ec00 ctl 0x0001e802 bmdma 0x0001dc00
> irq 19
> ata4: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e002 bmdma 0x0001dc08
> irq 19
> ata3.00: ATA-7: WDC WD3200YS-01PGB0, 21.00M21, max UDMA/133
> ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/1)
> ata3.00: configured for UDMA/133
> input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
> ata4.00: ATA-7: WDC WD3200YS-01PGB0, 21.00M21, max UDMA/133
> ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/1)
> ata4.00: configured for UDMA/133
> scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200YS-01P 21.0 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2 sda3 < sda5 sda6 >
> sd 2:0:0:0: [sda] Attached SCSI disk
> scsi 3:0:0:0: Direct-Access     ATA      WDC WD3200YS-01P 21.0 PQ: 0 ANSI: 5
> sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
> sd 3:0:0:0: [sdb] Attached SCSI disk
> md: md0 stopped.
> md: bind<sdb2>
> md: bind<sda2>
> raid1: raid set md0 active with 2 out of 2 mirrors
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> Contact your BIOS vendor to see if the E752x error registers can be
> safely un-hidden
> input: Power Button (FF) as /class/input/input2
> ACPI: Power Button (FF) [PWRF]
> input: Power Button (CM) as /class/input/input3
> ACPI: Power Button (CM) [PWRB]
> input: Sleep Button (CM) as /class/input/input4
> ACPI: Sleep Button (CM) [SLPB]
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> e1000: 0000:03:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1)
> 00:30:48:59:48:b4
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 20
> md: md1 stopped.
> md: bind<sdb6>
> md: bind<sda6>
> raid1: raid set md1 active with 2 out of 2 mirrors
> md: md9 stopped.
> md: bind<sdb1>
> md: bind<sda1>
> raid1: raid set md9 active with 2 out of 2 mirrors
> md: md20 stopped.
> md: bind<sdb5>
> md: bind<sda5>
> raid1: raid set md20 active with 2 out of 2 mirrors
> EXT3 FS on md0, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on md1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> 
> --------------------------------------------------------------------
> 
> .config:
> 
> CONFIG_X86_32=y
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_X86=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_DMI=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION="x"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_CPUSETS=y
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_LSF=y
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_CFQ=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_SMP=y
> CONFIG_X86_GENERICARCH=y
> CONFIG_X86_CYCLONE_TIMER=y
> CONFIG_M686=y
> CONFIG_X86_GENERIC=y
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_XADD=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_NR_CPUS=2
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> CONFIG_PREEMPT_NONE=y
> CONFIG_PREEMPT_BKL=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_P4THERMAL=y
> CONFIG_VM86=y
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_DMIID=y
> CONFIG_HIGHMEM64G=y
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NR_QUICK=1
> CONFIG_VIRT_TO_BUS=y
> CONFIG_HIGHPTE=y
> CONFIG_MTRR=y
> CONFIG_SECCOMP=y
> CONFIG_HZ_100=y
> CONFIG_HZ=100
> CONFIG_PHYSICAL_START=0x100000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x100000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_PM=y
> CONFIG_PM_LEGACY=y
> CONFIG_SUSPEND_SMP_POSSIBLE=y
> CONFIG_HIBERNATION_SMP_POSSIBLE=y
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_BLACKLIST_YEAR=1999
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=m
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=m
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=m
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_PCI=y
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> CONFIG_HT_IRQ=y
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_MISC=y
> CONFIG_NET=y
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETFILTER=y
> CONFIG_NF_CONNTRACK_ENABLED=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> CONFIG_NF_CONNTRACK_IPV4=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_IPRANGE=m
> CONFIG_IP_NF_MATCH_TOS=m
> CONFIG_IP_NF_MATCH_RECENT=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_OWNER=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_SAME=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_TOS=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_RAW=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_FIB_RULES=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_DEBUG_DEVRES=y
> CONFIG_PNP=y
> CONFIG_ISAPNP=y
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> CONFIG_BLK_DEV_RAM_BLOCKSIZE=4096
> CONFIG_MISC_DEVICES=y
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_PROC_FS=y
> CONFIG_BLK_DEV_SD=m
> CONFIG_SCSI_WAIT_SCAN=m
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ATA=m
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=m
> CONFIG_ATA_PIIX=m
> CONFIG_ATA_GENERIC=m
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_RAID1=y
> CONFIG_NETDEVICES=y
> CONFIG_DUMMY=m
> CONFIG_TUN=m
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> CONFIG_NET_VENDOR_3COM=y
> CONFIG_VORTEX=m
> CONFIG_NET_PCI=y
> CONFIG_PCNET32=m
> CONFIG_PCNET32_NAPI=y
> CONFIG_E100=m
> CONFIG_NETDEV_1000=y
> CONFIG_E1000=m
> CONFIG_E1000_NAPI=y
> CONFIG_PPP=m
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_MPPE=m
> CONFIG_SLHC=m
> CONFIG_INPUT=y
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_LIBPS2=y
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_RTC=y
> CONFIG_HPET=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_I801=m
> CONFIG_I2C_I810=m
> CONFIG_SENSORS_EEPROM=m
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_SPLIT_ISO=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_OHCI_HCD=m
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> CONFIG_USB_STORAGE=m
> CONFIG_USB_LIBUSUAL=y
> CONFIG_EDAC=y
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_AMD76X=m
> CONFIG_EDAC_E7XXX=m
> CONFIG_EDAC_E752X=m
> CONFIG_EDAC_I82875P=m
> CONFIG_EDAC_I82975X=m
> CONFIG_EDAC_I3000=m
> CONFIG_EDAC_I82860=m
> CONFIG_DMA_ENGINE=y
> CONFIG_NET_DMA=y
> CONFIG_INTEL_IOATDMA=m
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_JBD=y
> CONFIG_FS_MBCACHE=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_DNOTIFY=y
> CONFIG_GENERIC_ACL=y
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_RAMFS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=y
> CONFIG_NFS_ACL_SUPPORT=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> CONFIG_RPCSEC_GSS_KRB5=y
> CONFIG_CIFS=m
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_UTF8=m
> CONFIG_INSTRUMENTATION=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_DETECT_SOFTLOCKUP=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_LIST=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_4KSTACKS=y
> CONFIG_X86_FIND_SMP_CONFIG=y
> CONFIG_X86_MPPARSE=y
> CONFIG_DOUBLEFAULT=y
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_HW=y
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC32=y
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_KTIME_SCALAR=y

(cc's added)
