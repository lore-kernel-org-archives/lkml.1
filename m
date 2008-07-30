Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYG3IMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYG3IMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYG3IMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:12:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYG3IM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:12:29 -0400
Date: Wed, 30 Jul 2008 01:12:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Schneider <j.schneider@uib.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: nvidia MCP78B ahci failed to IDENTIFY error on 2.6.26
Message-Id: <20080730011223.8f04ba20.akpm@linux-foundation.org>
In-Reply-To: <200807281203.38822.j.schneider@uib.de>
References: <200807281203.38822.j.schneider@uib.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-ide)

On Mon, 28 Jul 2008 12:03:38 +0200 Jan Schneider <j.schneider@uib.de> wrote:

> Hi,
> 
> I get the follwing errors when booting 2.6.26 on a FSC Esprimo P5625 (nvidia 
> MCP78B).

Did any earlier kernels work OK?  If so, which version(s)?

Thanks.

> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:5697 ata_host_activate+0xf6/0x100 
> [libata]()
> Modules linked in: 8250_pnp 8250 serial_core tg3(+) serio_raw ahci(+) 
> ata_generic tpm_infineon tpm tpm_bios pata_acpi libata shpchp dock 
> pci_hotplug ehci_hcd ohci_hcd usbcore container thermal button processor 
> evdev
> Pid: 1937, comm: modprobe Not tainted 2.6.26 #1
>  [<c012706f>] warn_on_slowpath+0x5f/0x90
>  [<c01213d5>] finish_task_switch+0x95/0xa0
>  [<c0108c22>] dma_alloc_coherent+0x122/0x2b0
>  [<c025e2c1>] devres_add+0x31/0x50
>  [<c025f94c>] dmam_alloc_coherent+0x6c/0x90
>  [<f8bd529f>] ahci_port_resume+0x5f/0x70 [ahci]
>  [<c025e2c1>] devres_add+0x31/0x50
>  [<f8bf893d>] ata_host_start+0xed/0x170 [libata]
>  [<c02055ca>] pci_bus_write_config_byte+0x5a/0x70
>  [<f8bfcda6>] ata_host_activate+0xf6/0x100 [libata]
>  [<f8bd6899>] ahci_init_one+0x899/0xac0 [ahci]
>  [<c0209a96>] pci_device_probe+0x56/0x80
>  [<c025c682>] driver_probe_device+0x82/0x180
>  [<c025c7ec>] __driver_attach+0x6c/0x70
>  [<c025bdbb>] bus_for_each_dev+0x3b/0x60
>  [<c025c506>] driver_attach+0x16/0x20
>  [<c025c780>] __driver_attach+0x0/0x70
>  [<c025c1e9>] bus_add_driver+0xa9/0x210
>  [<c02099e0>] pci_device_remove+0x0/0x40
>  [<c025c95d>] driver_register+0x4d/0x120
>  [<c0209cbd>] __pci_register_driver+0x3d/0x80
>  [<c0149194>] sys_init_module+0x84/0x1b0
>  [<c0103da1>] sysenter_past_esp+0x6a/0x99
>  =======================
> ---[ end trace 21da9b6136ad63e5 ]---
> 
> The serial ata harddisk does not appear.
> 
> ---------[ lspci -n ]---------
> 00:00.0 0500: 10de:0754 (rev a2)
> 00:01.0 0601: 10de:075c (rev a2)
> 00:01.1 0c05: 10de:0752 (rev a1)
> 00:01.2 0500: 10de:0751 (rev a1)
> 00:01.4 0500: 10de:0568 (rev a1)
> 00:02.0 0c03: 10de:077b (rev a1)
> 00:02.1 0c03: 10de:077c (rev a1)
> 00:04.0 0c03: 10de:077d (rev a1)
> 00:04.1 0c03: 10de:077e (rev a1)
> 00:07.0 0403: 10de:0774 (rev a1)
> 00:08.0 0604: 10de:075a (rev a1)
> 00:09.0 0101: 10de:0ad0 (rev a2)
> 00:0b.0 0604: 10de:0569 (rev a1)
> 00:10.0 0604: 10de:0778 (rev a1)
> 00:12.0 0604: 10de:075b (rev a1)
> 00:13.0 0604: 10de:077a (rev a1)
> 00:18.0 0600: 1022:1100
> 00:18.1 0600: 1022:1101
> 00:18.2 0600: 1022:1102
> 00:18.3 0600: 1022:1103
> 02:00.0 0300: 10de:084b (rev a2)
> 05:00.0 0200: 14e4:169b (rev 02)
> ----------------------------------
> 
> Full dmesg output:
> 
> Linux version 2.6.26 (root@pcbon14) (gcc version 4.2.3 (Ubuntu 
> 4.2.3-2ubuntu7)) #1 SMP PREEMPT Mon Jul 21 16:44:03 UTC 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000037f40000 (usable)
>  BIOS-e820: 0000000037f40000 - 0000000037f4d000 (ACPI data)
>  BIOS-e820: 0000000037f4d000 - 0000000037f4e000 (ACPI NVS)
>  BIOS-e820: 0000000037f4e000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> 0MB HIGHMEM available.
> 895MB LOWMEM available.
> found SMP MP-table at [c00f75e0] 000f75e0
> Entering add_active_range(0, 0, 229184) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   229184
>   HighMem    229184 ->   229184
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   229184
> On node 0 totalpages: 229184
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 1759 pages used for memmap
>   Normal zone: 223329 pages, LIFO batch:31
>   HighMem zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> DMI present.
> ACPI: RSDP 000F75B0, 0024 (r2 PTLTD )
> ACPI: XSDT 37F45097, 007C (r1 FSC    PC          60000  LTP        0)
> ACPI: FACP 37F4C7FA, 00F4 (r3 FSC                60000 PTL_    F4240)
> ACPI: DSDT 37F45113, 7673 (r1 FSC    D2721/A1    60000 MSFT  3000001)
> ACPI: FACS 37F4DFC0, 0040
> ACPI: TCPA 37F4C8EE, 0032 (r1 Phoeni  x          60000  TL         0)
> ACPI: WDAT 37F4C920, 0104 (r1 PTLTD  WDATTBL     60000  LTP        1)
> ACPI: SSDT 37F4CA24, 0248 (r1 AMD    POWERNOW    60000 AMD         1)
> ACPI: SRAT 37F4CC6C, 00A0 (r1 AMD    HAMMER      60000 AMD         1)
> ACPI: ASF! 37F4CD0C, 0070 (r32 OEMID  OEMTBL      60000 PTL         1)
> ACPI: SLIC 37F4CD7C, 0176 (r1 FSC    PC          60000  LTP        0)
> ACPI: MCFG 37F4CEF2, 003C (r1 PTLTD    MCFG      60000  LTP        0)
> ACPI: HPET 37F4CF2E, 0038 (r1 PTLTD  HPETTBL     60000  LTP        1)
> ACPI: APIC 37F4CF66, 0072 (r1 PTLTD  	 APIC      60000  LTP        0)
> ACPI: BOOT 37F4CFD8, 0028 (r1 PTLTD  $SBFTBL$    60000  LTP        1)
> ACPI: DMI detected: Fujitsu Siemens
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:b8000000)
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 36392 bytes of per cpu data
> NR_CPUS: 32, nr_cpu_ids: 2
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227393
> Kernel command line: lang=de video=vesa:ywrap,mtrr 
> pckey=4e6842c5129e7882c318378dde52fe2e service=192.168.1.14 vga=791 
> initrd=miniroot.gz reboot=b product=winxppro init=/etc/init quiet hn=evb 
> ramdisk_size=185320 splash BOOT_IMAGE=install 
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Extended CMOS year: 2000
> Detected 2300.065 MHz processor.
> spurious 8259A interrupt: IRQ7.
> Console: colour dummy device 80x25
> console [tty0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 841640k/916736k available (2127k kernel code, 74572k reserved, 758k 
> data, 340k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>     lowmem  : 0xc0000000 - 0xf7f40000   ( 895 MB)
>       .init : 0xc03d7000 - 0xc042c000   ( 340 kB)
>       .data : 0xc0313e37 - 0xc03d1a20   ( 758 kB)
>       .text : 0xc0100000 - 0xc0313e37   (2127 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> CPA: page pool initialized 1 of 1 pages preallocated
> hpet clockevent registered
> Calibrating delay using timer specific routine.. 4605.32 BogoMIPS 
> (lpj=9210650)
> Mount-cache hash table entries: 512
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 0(2) -> Core 0
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20080321
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
> CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 02
> APIC calibration not consistent with PM Timer: 349ms instead of 100ms
> APIC delta adjusted to PM-Timer: 357954 (1249981)
> Booting processor 1/1 ip 6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 1317.37 BogoMIPS 
> (lpj=2634740)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 1(2) -> Core 1
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 02
> Brought up 2 CPUs
> Total of 2 processors activated (5922.69 BogoMIPS).
> CPU0 attaching sched-domain:
>  domain 0: span 0-1
>   groups: 0 1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1
>   groups: 1 0
> net_namespace: 200 bytes
> NET: Registered protocol family 16
> EISA bus registered
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 5
> PCI: MCFG area at f8000000 reserved in E820
> PCI: Using MMCONFIG for extended config space
> PCI: Using configuration type 1 for base access
> Setting up standard PCI resources
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: Device [ECP] status [00000008]: functional but not present; setting 
> present
> ACPI: Device [COM2] status [00000008]: functional but not present; setting 
> present
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Transparent bridge - 0000:00:08.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXA._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXB._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXL._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 11 12 13 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 13 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 12 13 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 11 12 13 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LK0A] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LK0B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK0C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK0D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK1A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK1B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK1C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK1D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK2A] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LK2B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK2C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK2D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK3A] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LK3B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK3C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK3D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK4A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK4B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK4C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK4D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK5A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK5B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK5C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK5D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK6A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK6B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK6C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK6D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK7A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK7B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK7C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LK7D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR0] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR2] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR3] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR4] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR5] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR6] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LKR7] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LNKI] (IRQs 16 17 18 19 20 21 22 23) *5
> ACPI: PCI Interrupt Link [LNKJ] (IRQs 16 17 18 19 20 21 22 23) *10
> ACPI: PCI Interrupt Link [LNKK] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKL] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKM] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKN] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LNKO] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LNKP] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LNKQ] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKR] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKS] (IRQs 16 17 18 19 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LNKT] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 15 devices
> ACPI: ACPI bus type pnp unregistered
> PnPBIOS: Disabled by ACPI PNP
> SCSI subsystem initialized
> PCI: Using ACPI for IRQ routing
> ACPI: RTC can wake from S4
> system 00:01: ioport range 0x4d0-0x4d1 has been reserved
> system 00:01: ioport range 0x500-0x57f has been reserved
> system 00:01: ioport range 0x1000-0x10e7 has been reserved
> system 00:01: ioport range 0x1200-0x12fe has been reserved
> system 00:01: ioport range 0x1400-0x14fe has been reserved
> system 00:01: ioport range 0x1500-0x15fe has been reserved
> system 00:01: ioport range 0x1600-0x16fe has been reserved
> system 00:01: ioport range 0x1700-0x17fe has been reserved
> system 00:01: ioport range 0x1800-0x18fe has been reserved
> system 00:01: ioport range 0x1900-0x19fe has been reserved
> system 00:01: ioport range 0x1a00-0x1afe has been reserved
> system 00:01: ioport range 0x1c00-0x1cfe has been reserved
> system 00:01: ioport range 0xfe00-0xfe00 has been reserved
> system 00:01: ioport range 0xff00-0xff00 has been reserved
> system 00:01: iomem range 0xf8000000-0xfbffffff could not be reserved
> system 00:01: iomem range 0xfc000000-0xfebfffff has been reserved
> system 00:01: iomem range 0xfec00000-0xfec7ffff could not be reserved
> system 00:01: iomem range 0xfec80000-0xfecfffff has been reserved
> system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
> system 00:01: iomem range 0xfef00000-0xfef7ffff has been reserved
> system 00:01: iomem range 0xfef80000-0xfeffffff has been reserved
> system 00:01: iomem range 0xfff00000-0xffffffff could not be reserved
> PM-Timer running at invalid rate: 349% of normal - aborting.
> PCI: Bridge: 0000:00:08.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Failed to allocate mem resource #6:20000@f0000000 for 0000:02:00.0
> PCI: Bridge: 0000:00:0b.0
>   IO window: 4000-4fff
>   MEM window: 0xdc000000-0xdcffffff
>   PREFETCH window: 0x00000000de000000-0x00000000efffffff
> PCI: Bridge: 0000:00:10.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:12.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:13.0
>   IO window: disabled.
>   MEM window: 0xdde00000-0xddefffff
>   PREFETCH window: disabled.
> PCI: Setting latency timer of device 0000:00:08.0 to 64
> PCI: Setting latency timer of device 0000:00:0b.0 to 64
> ACPI: PCI Interrupt Link [LKR0] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LKR0] -> GSI 23 (level, high) -> 
> IRQ 23
> PCI: Setting latency timer of device 0000:00:10.0 to 64
> ACPI: PCI Interrupt Link [LKR2] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LKR2] -> GSI 22 (level, high) -> 
> IRQ 22
> PCI: Setting latency timer of device 0000:00:12.0 to 64
> ACPI: PCI Interrupt Link [LKR3] enabled at IRQ 21
> ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LKR3] -> GSI 21 (level, high) -> 
> IRQ 21
> PCI: Setting latency timer of device 0000:00:13.0 to 64
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> checking if image is initramfs...it isn't (no cpio magic); looks like an 
> initrd
> Freeing initrd memory: 62994k freed
> Simple Boot Flag at 0x38 set to 0x1
> audit: initializing netlink socket (disabled)
> type=2000 audit(1217245531.579:1): initialized
> Total HugeTLB memory allocated, 0
> msgmni has been set to 1767
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered (default)
> io scheduler cfq registered
> pci 0000:02:00.0: Boot video device
> PCI: Setting latency timer of device 0000:00:10.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:10.0:pcie00]
> PCI: Setting latency timer of device 0000:00:12.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:12.0:pcie00]
> PCI: Setting latency timer of device 0000:00:13.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:13.0:pcie00]
> vesafb: framebuffer at 0xdf000000, mapped to 0xf8880000, using 3072k, total 
> 14336k
> vesafb: mode is 1024x768x16, linelength=2048, pages=1
> vesafb: protected mode interface info at c000:b640
> vesafb: pmi: set display start = c00cb6a3, set palette = c00cb6fe
> vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 
> 3d0 3d1 3d2 3d3 3d4 3d5 3da 
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> Console: switching to colour frame buffer device 128x48
> fb0: VESA VGA frame buffer device
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> FDC 0 is a post-1991 82077
> brd: module loaded
> Loading iSCSI transport class v2.0-869.
> PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> EISA: Probing bus 0 at eisa.0
> Cannot allocate resource for EISA slot 1
> Cannot allocate resource for EISA slot 3
> Cannot allocate resource for EISA slot 4
> EISA: Detected 0 cards.
> TCP cubic registered
> NET: Registered protocol family 15
> Starting balanced_irq
> Using IPI No-Shortcut mode
> input: AT Translated Set 2 keyboard as /class/input/input0
> RAMDISK: Compressed image found at block 0
> VFS: Mounted root (ext2 filesystem).
> Freeing unused kernel memory: 340k freed
> Failed to execute /etc/init.  Attempting defaults...
> ACPI: ACPI0007:00 is registered as cooling_device0
> ACPI: ACPI0007:01 is registered as cooling_device1
> input: Power Button (FF) as /class/input/input1
> ACPI: Power Button (FF) [PWRF]
> input: Power Button (CM) as /class/input/input2
> ACPI: Power Button (CM) [PWRB]
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt Link [LNKJ] enabled at IRQ 20
> ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKJ] -> GSI 20 (level, high) -> 
> IRQ 20
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
> ohci_hcd 0000:00:02.0: irq 20, io mem 0xddbf9000
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 6 ports detected
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> No dock devices found.
> ACPI: PCI Interrupt Link [LNKR] enabled at IRQ 19
> ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LNKR] -> GSI 19 (level, high) -> 
> IRQ 19
> PCI: Setting latency timer of device 0000:00:04.0 to 64
> ohci_hcd 0000:00:04.0: OHCI Host Controller
> ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:04.0: irq 19, io mem 0xddbf8000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 6 ports detected
> libata version 3.00 loaded.
> ACPI: PCI Interrupt Link [LNKI] enabled at IRQ 18
> ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKI] -> GSI 18 (level, high) -> 
> IRQ 18
> PCI: Setting latency timer of device 0000:00:02.1 to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
> ehci_hcd 0000:00:02.1: debug port 1
> PCI: cache line size of 64 is not supported by device 0000:00:02.1
> ehci_hcd 0000:00:02.1: irq 18, io mem 0xddbf6c00
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 6 ports detected
> ACPI: PCI Interrupt Link [LNKS] enabled at IRQ 17
> ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [LNKS] -> GSI 17 (level, high) -> 
> IRQ 17
> PCI: Setting latency timer of device 0000:00:04.1 to 64
> ehci_hcd 0000:00:04.1: EHCI Host Controller
> ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 4
> ehci_hcd 0000:00:04.1: debug port 1
> PCI: cache line size of 64 is not supported by device 0000:00:04.1
> ehci_hcd 0000:00:04.1: irq 17, io mem 0xddbf6800
> ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 6 ports detected
> tpm_inf_pnp 00:02: Found TPM with ID IFX0102
> PCI: Setting latency timer of device 0000:00:09.0 to 64
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> ahci 0000:00:09.0: version 3.0
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial 00:0e: activated
> 00:0e: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl IDE mode
> ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio 
> PCI: Setting latency timer of device 0000:00:09.0 to 64
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:5697 ata_host_activate+0xf6/0x100 
> [libata]()
> Modules linked in: 8250_pnp 8250 serial_core tg3(+) serio_raw ahci(+) 
> ata_generic tpm_infineon tpm tpm_bios pata_acpi libata shpchp dock 
> pci_hotplug ehci_hcd ohci_hcd usbcore container thermal button processor 
> evdev
> Pid: 1937, comm: modprobe Not tainted 2.6.26 #1
>  [<c012706f>] warn_on_slowpath+0x5f/0x90
>  [<c01213d5>] finish_task_switch+0x95/0xa0
>  [<c0108c22>] dma_alloc_coherent+0x122/0x2b0
>  [<c025e2c1>] devres_add+0x31/0x50
>  [<c025f94c>] dmam_alloc_coherent+0x6c/0x90
>  [<f8bd529f>] ahci_port_resume+0x5f/0x70 [ahci]
>  [<c025e2c1>] devres_add+0x31/0x50
>  [<f8bf893d>] ata_host_start+0xed/0x170 [libata]
>  [<c02055ca>] pci_bus_write_config_byte+0x5a/0x70
>  [<f8bfcda6>] ata_host_activate+0xf6/0x100 [libata]
>  [<f8bd6899>] ahci_init_one+0x899/0xac0 [ahci]
>  [<c0209a96>] pci_device_probe+0x56/0x80
>  [<c025c682>] driver_probe_device+0x82/0x180
>  [<c025c7ec>] __driver_attach+0x6c/0x70
>  [<c025bdbb>] bus_for_each_dev+0x3b/0x60
>  [<c025c506>] driver_attach+0x16/0x20
>  [<c025c780>] __driver_attach+0x0/0x70
>  [<c025c1e9>] bus_add_driver+0xa9/0x210
>  [<c02099e0>] pci_device_remove+0x0/0x40
>  [<c025c95d>] driver_register+0x4d/0x120
>  [<c0209cbd>] __pci_register_driver+0x3d/0x80
>  [<c0149194>] sys_init_module+0x84/0x1b0
>  [<c0103da1>] sysenter_past_esp+0x6a/0x99
>  =======================
> ---[ end trace 21da9b6136ad63e5 ]---
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> scsi4 : ahci
> scsi5 : ahci
> ata1: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa100
> ata2: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa180
> ata3: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa200
> ata4: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa280
> ata5: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa300
> ata6: SATA max UDMA/133 abar m8192@0xddbfa000 port 0xddbfa380
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> ata2: failed to recover some devices, retrying in 5 secs
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> ata2: failed to recover some devices, retrying in 5 secs
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> ata2: failed to recover some devices, retrying in 5 secs
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3: SATA link down (SStatus 0 SControl 300)
> ata4: SATA link down (SStatus 0 SControl 300)
> ata5: SATA link down (SStatus 0 SControl 300)
> ata6: SATA link down (SStatus 0 SControl 300)
> tg3.c:v3.92.1 (June 9, 2008)
> ACPI: PCI Interrupt Link [LK3A] enabled at IRQ 16
> ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [LK3A] -> GSI 16 (level, high) -> 
> IRQ 16
> PCI: Setting latency timer of device 0000:05:00.0 to 64
> eth0: Tigon3 [partno(BCM95787) rev b002 PHY(5787)] (PCI Express) 
> 10/100/1000Base-T Ethernet 00:19:99:23:e4:7d
> eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
> eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> fuse init (API version 7.9)
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: 
> dm-devel@redhat.com
> NET: Registered protocol family 17
> tg3: eth0: Link is up at 100 Mbps, full duplex.
> tg3: eth0: Flow control is on for TX and on for RX.
> tg3: eth0: Link is up at 100 Mbps, full duplex.
> tg3: eth0: Flow control is on for TX and on for RX.
> 
> 
> Any help?
> 
> -- 
> Jan Schneider
> 
> uib gmbh
> Bonifaziusplatz 1B
> 55118 Mainz
> 
> Tel. 06131 / 27561-20
> Fax  06131 / 27561-22
> 
> E-Mail: j.schneider@uib.de
> 
> Internet: www.uib.de
> 
> Gesch__ftsf__hrer: dr. detlef oertel
> Handelsregister: Amtsgericht Mainz HRB 6942
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
