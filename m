Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0CNUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:09:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0CNUJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:09:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Giampaolo Bellini <iw2lsi@gmail.com>
Subject: Re: PCI conflicts with latest kernels
Date: Sun, 14 Mar 2010 21:12:02 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com>
In-Reply-To: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003142112.02555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing linux-pci]

On Sunday 14 March 2010, Giampaolo Bellini wrote:
> Hi all...
> 
>    I'm experimenting PCI  address space collisions on an ICOP PC104
> VDX-6357 motherboard (with no cards/expansion at all) and kernels
> 2.6.33/34
> 
> collisions where not there with kernel 2.6.29 (I start with this
> .config and I've done a make oldconfig for 2.6.33/34).
> 
> I have no ACPI support and I'm using the sisfb framebuffer on a XGI
> Technology Inc. (eXtreme Graphics Innovation) Volari Z7 chipset.
> 
> thanks for any ideas
> 
>                    Paolo
> 
> 
> here are some info:
> 
> 
> -------------------------------------------------------------------
> cat /proc/cmdline
> -------------------------------------------------------------------
> root=/dev/sda2 quiet video=sisfb:640x480-32 ar8.debug=1
> ar8.outputs=0x80 BOOT_IMAGE=vmlinuz-2.6.33-r3-vdx
> 
> 
> -------------------------------------------------------------------
> dmesg kernel 2.6.33:
> -------------------------------------------------------------------
> Linux version 2.6.33-ibty3-vdx (root@nibble) (gcc version 4.2.4
> (Ubuntu 4.2.4-1ubuntu3)) #22 Sun Mar 14 00:35:18 CET 2010
> CPU: vendor_id 'Vortex86 SoC' unknown, using generic init.
> CPU: Your system may be unstable.
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
>  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> DMI not present or invalid.
> last_pfn = 0x20000 max_arch_pfn = 0x100000
> initial memory mapped : 0 - 01800000
> init_memory_mapping: 0000000000000000-0000000020000000
>  0000000000 - 0020000000 page 4k
> kernel direct mapping tables up to 20000000 @ 7000-8a000
> 512MB LOWMEM available.
>   mapped low ram: 0 - 20000000
>   low ram: 0 - 20000000
>   node 0 low ram: 00000000 - 20000000
>   node 0 bootmap 00001000 - 00005000
> (6 early reservations) ==> bootmem [0000000000 - 0020000000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0001000000 - 00012f6154]    TEXT DATA BSS ==> [0001000000 - 00012f6154]
>   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
>   #3 [00012f7000 - 00012fd000]              BRK ==> [00012f7000 - 00012fd000]
>   #4 [0000007000 - 0000081000]          PGTABLE ==> [0000007000 - 0000081000]
>   #5 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00020000
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x00020000
> On node 0 totalpages: 130975
> free_area_init_node: node 0, pgdat c12a2004, node_mem_map c12fd000
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3967 pages, LIFO batch:0
>   Normal zone: 992 pages used for memmap
>   Normal zone: 125984 pages, LIFO batch:31
> Allocating PCI resources starting at 20000000 (gap: 20000000:df000000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129951
> Kernel command line: root=/dev/sda2 quiet video=sisfb:640x480-32
> ar8.debug=1 ar8.outputs=0x80 BOOT_IMAGE=vmlinuz-2.6.33-r3-vdx
> PID hash table entries: 2048 (order: 1, 8192 bytes)
> Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Initializing CPU#0
> Memory: 515600k/524288k available (1844k kernel code, 8044k reserved,
> 863k data, 212k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
>     vmalloc : 0xe0800000 - 0xfffe3000   ( 503 MB)
>     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
>       .init : 0xc12a5000 - 0xc12da000   ( 212 kB)
>       .data : 0xc11cd056 - 0xc12a4ed8   ( 863 kB)
>       .text : 0xc1000000 - 0xc11cd056   (1844 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> Hierarchical RCU implementation.
> NR_IRQS:16
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 800.001 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 1600.00 BogoMIPS (lpj=3200004)
> Mount-cache hash table entries: 512
> Performance Events:
> CPU: Vortex86 SoC 05/02 stepping 02
> Checking 'hlt' instruction... OK.
> NET: Registered protocol family 16
> PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=0
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> vgaarb: loaded
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> pci 0000:00:01.0: reg 10: [io  0xdc00-0xdcff]
> pci 0000:00:01.0: reg 14: [mem 0xfefbb000-0xfefbb0ff]
> pci 0000:00:01.0: supports D1 D2
> pci 0000:00:01.0: PME# supported from D1 D2 D3hot D3cold
> pci 0000:00:01.0: PME# disabled
> pci 0000:00:02.0: reg 10: [io  0xdd00-0xddff]
> pci 0000:00:02.0: reg 14: [mem 0xfefbb400-0xfefbb4ff]
> pci 0000:00:02.0: supports D1 D2
> pci 0000:00:02.0: PME# supported from D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:03.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
> pci 0000:00:03.0: reg 14: [mem 0xfefc0000-0xfeffffff]
> pci 0000:00:03.0: reg 18: [io  0xdf80-0xdfff]
> pci 0000:00:03.0: supports D1 D2
> pci 0000:00:08.0: reg 10: [io  0xde00-0xdeff]
> pci 0000:00:08.0: reg 14: [mem 0xfefbb800-0xfefbb8ff]
> pci 0000:00:08.0: reg 30: [mem 0xfefa0000-0xfefaffff pref]
> pci 0000:00:0b.0: reg 10: [mem 0x000e0000-0x000e0fff]
> pci 0000:00:0b.1: reg 10: [mem 0x000e1000-0x000e10ff]
> pci 0000:00:0c.0: reg 10: [io  0x01f0-0x01f7]
> pci 0000:00:0c.0: reg 14: [io  0x03f4-0x03f7]
> pci 0000:00:0c.0: reg 18: [io  0x0170-0x0177]
> pci 0000:00:0c.0: reg 1c: [io  0x0374-0x0377]
> pci 0000:00:0c.0: reg 20: [io  0xfff0-0xffff]
> pci 0000:00:0c.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> vgaarb: device added: PCI:0000:00:03.0,decodes=io+mem,owns=io+mem,locks=none
> pci 0000:00:07.0: default IRQ router [17f3:6031]
> PCI: pci_cache_line_size set to 32 bytes
> 
> 
> pci 0000:00:0b.0: address space collision: [mem 0x000e0000-0x000e0fff]
> already in use
> pci 0000:00:0b.0: can't reserve [mem 0x000e0000-0x000e0fff]
> pci 0000:00:0b.1: address space collision: [mem 0x000e1000-0x000e10ff]
> already in use
> pci 0000:00:0b.1: can't reserve [mem 0x000e1000-0x000e10ff]
> 
> 
> Switching to clocksource tsc
> pci 0000:00:0c.0: BAR 6: assigned [mem 0x20000000-0x2001ffff pref]
> pci 0000:00:0b.0: BAR 0: assigned [mem 0x20020000-0x20020fff]
> pci 0000:00:0b.0: BAR 0: set to [mem 0x20020000-0x20020fff] (PCI
> address [0x20020000-0x20020fff]
> pci 0000:00:0b.1: BAR 0: assigned [mem 0x20021000-0x200210ff]
> pci 0000:00:0b.1: BAR 0: set to [mem 0x20021000-0x200210ff] (PCI
> address [0x20021000-0x200210ff]
> pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
> ...
> -------------------------------------------------------------------
> 
> 
> -------------------------------------------------------------------
> lspci
> -------------------------------------------------------------------
> 00:00.0 Host bridge: RDC Semiconductor, Inc. Unknown device 6021 (rev 01)
>         Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 0
> 
> 00:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. RT8139
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 128 (8000ns min, 16000ns max)
>         Interrupt: pin A routed to IRQ 9
>         Region 0: I/O ports at dc00 [size=256]
>         Region 1: Memory at fefbb000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. RT8139
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 128 (8000ns min, 16000ns max)
>         Interrupt: pin A routed to IRQ 6
>         Region 0: I/O ports at dd00 [size=256]
>         Region 1: Memory at fefbb400 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:03.0 VGA compatible controller: XGI Technology Inc. (eXtreme
> Graphics Innovation) Volari Z7 (prog-if 00 [VGA controller])
>         Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) Volari Z7
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         BIST result: 00
>         Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
>         Region 1: Memory at fefc0000 (32-bit, non-prefetchable) [size=256K]
>         Region 2: I/O ports at df80 [size=128]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:07.0 ISA bridge: RDC Semiconductor, Inc. Unknown device 6031 (rev 01)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=?? >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 
> 00:08.0 Ethernet controller: RDC Semiconductor, Inc. R6040 MAC Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 128 (750ns min, 2000ns max)
>         Interrupt: pin A routed to IRQ 5
>         Region 0: I/O ports at de00 [size=256]
>         Region 1: Memory at fefbb800 (32-bit, non-prefetchable) [size=256]
>         Expansion ROM at fefa0000 [disabled] [size=64K]
> 
> 00:0b.0 USB Controller: RDC Semiconductor, Inc. R6060 USB 1.1
> Controller (rev 11) (prog-if 10 [OHCI])
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 128, Cache Line Size: 16 bytes
>         Interrupt: pin A routed to IRQ 15
>         Region 0: Memory at 20020000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:0b.1 USB Controller: RDC Semiconductor, Inc. R6061 USB 2.0
> Controller (rev 02) (prog-if 20 [EHCI])
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 128, Cache Line Size: 16 bytes
>         Interrupt: pin B routed to IRQ 9
>         Region 0: Memory at 20021000 (32-bit, non-prefetchable) [size=256]
> 
> 00:0c.0 Mass storage controller: RDC Semiconductor, Inc. Unknown
> device 1010 (rev 13)
>         Subsystem: RDC Semiconductor, Inc. Unknown device 1010
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (2000ns min, 2000ns max)
>         Interrupt: pin A routed to IRQ 14
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=4]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=4]
>         Region 4: I/O ports at fff0 [size=16]
>         [virtual] Expansion ROM at 20000000 [disabled] [size=128K]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> -------------------------------------------------------------------
> 
> -------------------------------------------------------------------
> /proc/cpuinfo
> -------------------------------------------------------------------
> processor       : 0
> vendor_id       : Vortex86 SoC
> cpu family      : 5
> model           : 2
> model name      : 05/02
> stepping        : 2
> cpu MHz         : 800.001
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu tsc cx8
> bogomips        : 1600.00
> clflush size    : 32
> cache_alignment : 32
> address sizes   : 32 bits physical, 32 bits virtual
> power management:
> 
> 
> -------------------------------------------------------------------
> dmesg kernel 2.6.29:
> -------------------------------------------------------------------
> ...
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> pci 0000:00:01.0: reg 10 io port: [0xdc00-0xdcff]
> pci 0000:00:01.0: reg 14 32bit mmio: [0xfefbb000-0xfefbb0ff]
> pci 0000:00:01.0: supports D1 D2
> pci 0000:00:01.0: PME# supported from D1 D2 D3hot D3cold
> pci 0000:00:01.0: PME# disabled
> pci 0000:00:02.0: reg 10 io port: [0xdd00-0xddff]
> pci 0000:00:02.0: reg 14 32bit mmio: [0xfefbb400-0xfefbb4ff]
> pci 0000:00:02.0: supports D1 D2
> pci 0000:00:02.0: PME# supported from D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:03.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
> pci 0000:00:03.0: reg 14 32bit mmio: [0xfefc0000-0xfeffffff]
> pci 0000:00:03.0: reg 18 io port: [0xdf80-0xdfff]
> pci 0000:00:03.0: supports D1 D2
> pci 0000:00:08.0: reg 10 io port: [0xde00-0xdeff]
> pci 0000:00:08.0: reg 14 32bit mmio: [0xfefbb800-0xfefbb8ff]
> pci 0000:00:08.0: reg 30 32bit mmio: [0xfefa0000-0xfefaffff]
> pci 0000:00:0b.0: reg 10 32bit mmio: [0x0e0000-0x0e0fff]
> pci 0000:00:0b.1: reg 10 32bit mmio: [0x0e1000-0x0e10ff]
> pci 0000:00:0c.0: reg 10 io port: [0x1f0-0x1f7]
> pci 0000:00:0c.0: reg 14 io port: [0x3f4-0x3f7]
> pci 0000:00:0c.0: reg 18 io port: [0x170-0x177]
> pci 0000:00:0c.0: reg 1c io port: [0x374-0x377]
> pci 0000:00:0c.0: reg 20 io port: [0xfff0-0xffff]
> pci 0000:00:0c.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> pci 0000:00:07.0: default IRQ router [17f3:6031]
> pci 0000:00:0b.0: BAR 0: can't allocate resource
> pci 0000:00:0b.1: BAR 0: can't allocate resource
> ...
> -------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

