Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbXCUGhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbXCUGhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXCUGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:37:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXCUGhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:37:25 -0400
Date: Tue, 20 Mar 2007 22:36:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, reiserfs-dev@namesys.com
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
In-Reply-To: <1174433034.62033.16.camel@localhost>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:

> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
> First impressions:
> Several of the same bugs as rc3-mm*:
>       * Freezes immediately if I touch the wlan0 device after loading
>         the new Broadcom wireless driver.

cc linux-wireless

>       * Freezes immediately if I allow Bluetooth to configure.

cc bluez-devel

>       * All freezes simply stop, no BUG or panic happens, no watchdog,
>         soft or NMI ever triggers.  Thinking about it, I wonder if
>         disabling EDAC_K8 would help here?  Does it steal NMI?  I'll try
>         that later.

Mabe that will be fixed by the just-uploaded
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/hot-fixes/tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

>       * I am using Reiser4 and after one of the above freezes and hard
>         power cycle, files that were in use *read*only* are filled with
>         zeros.  For example, while testing and experiencing the above
>         freezes, I lost /etc/ld.so.preload
>         and /lib/security/pam_limits.so.  What the heck?

cc reiserfs-dev

<most of remainder retained, sorry>

> Good points:
>       * Runs longer than 5 minutes, since I am typing this while using
>         it.
>       * I like RDSL so far.
> 
> Advice on who to annoy with further bug reports is welcome.  Bluetooth
> people?  USB people?  Broadcom driver people, probably.
> 
> The system is a Athlon64 laptop, nForce3 motherboard.
> Current lspci, dmesg (cannot get the frozen dmesgs, sorry) and .config
> follow:
> 00:00.0 Host bridge: nVidia Corporation nForce3 Host Bridge (rev a4)
> 00:01.0 ISA bridge: nVidia Corporation nForce3 LPC Bridge (rev a6)
> 00:01.1 SMBus: nVidia Corporation nForce3 SMBus (rev a4)
> 00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
> 00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
> 00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2)
> 00:06.0 Multimedia audio controller: nVidia Corporation nForce3 Audio (rev a2)
> 00:06.1 Modem: nVidia Corporation nForce3 Audio (rev a2)
> 00:08.0 IDE interface: nVidia Corporation nForce3 IDE (rev a5)
> 00:0a.0 PCI bridge: nVidia Corporation nForce3 PCI Bridge (rev a2)
> 00:0b.0 PCI bridge: nVidia Corporation nForce3 AGP Bridge (rev a4)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 01:00.0 VGA compatible controller: nVidia Corporation NV17 [GeForce4 420 Go 32M] (rev a3)
> 02:00.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link)
> 02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
> 02:02.0 Network controller: Broadcom Corporation BCM4303 802.11b Wireless LAN Controller (rev 02)
> 02:04.0 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
> 02:04.1 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
> 02:04.2 System peripheral: Texas Instruments PCI1620 Firmware Loading Function (rev 01)
> 
> [    0.000000] Linux version 2.6.21-rc4-mm1 (root@zephyr) (gcc version 4.2.0-alpha20070307 (prerelease) (Gentoo 4.2.0_alpha20070307)) #1 SMP PREEMPT Tue Mar 20 14:25:42 MDT 2007
> [    0.000000] Command line: root=/dev/sda2 rootfstype=reiser4 ro i8042.nomux elevator=cfq resume=/dev/sda3 single
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
> [    0.000000]  BIOS-e820: 000000003ff70000 - 000000003ff7f000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003ff7f000 - 000000003ff80000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 262000) 1 entries of 256 used
> [    0.000000] end_pfn_map = 1048576
> [    0.000000] DMI present.
> [    0.000000] ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
> [    0.000000] ACPI: RSDT 3FF7A87E, 0034 (r1 PTLTD    RSDT    6040000  LTP        0)
> [    0.000000] ACPI: FACP 3FF7EE13, 0074 (r1 NVIDIA CK8       6040000 PTL_    F4240)
> [    0.000000] ACPI: DSDT 3FF7A8B2, 4561 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
> [    0.000000] ACPI: FACS 3FF7FFC0, 0040
> [    0.000000] ACPI: APIC 3FF7EE87, 005A (r1 NVIDIA NV_APIC_  6040000  LTP        0)
> [    0.000000] ACPI: BOOT 3FF7EEE1, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
> [    0.000000] ACPI: SSDT 3FF7EF09, 00F7 (r1 PTLTD  POWERNOW  6040000  LTP        1)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 262000) 1 entries of 256 used
> [    0.000000] No mptable found.
> [    0.000000] sizeof(struct page) = 88
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1048576
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0:        0 ->      159
> [    0.000000]     0:      256 ->   262000
> [    0.000000] On node 0 totalpages: 261903
> [    0.000000] Node 0 memmap at 0xffff810001000000 size 23068672 first pfn 0xffff810001000000
> [    0.000000]   DMA zone: 88 pages used for memmap
> [    0.000000]   DMA zone: 2335 pages reserved
> [    0.000000]   DMA zone: 1576 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 5540 pages used for memmap
> [    0.000000]   DMA32 zone: 252364 pages, LIFO batch:31
> [    0.000000]   Normal zone: 0 pages used for memmap
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
> [    0.000000] ACPI: PM-Timer IO Port: 0x8008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
> [    0.000000] Nosave address range: 00000000000a0000 - 00000000000d0000
> [    0.000000] Nosave address range: 00000000000d0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bff80000)
> [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 37312 bytes of per cpu data
> [    0.000000] Built 1 zonelists.  Total pages: 253940
> [    0.000000] Kernel command line: root=/dev/sda2 rootfstype=reiser4 ro i8042.nomux elevator=cfq resume=/dev/sda3 single
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [   17.397762] time.c: Detected 2194.378 MHz processor.
> [   17.399354] Console: colour VGA+ 80x25
> [   17.402298] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [   17.402371] ... MAX_LOCKDEP_SUBCLASSES:    8
> [   17.402423] ... MAX_LOCK_DEPTH:          30
> [   17.402476] ... MAX_LOCKDEP_KEYS:        2048
> [   17.402528] ... CLASSHASH_SIZE:           1024
> [   17.402581] ... MAX_LOCKDEP_ENTRIES:     8192
> [   17.402633] ... MAX_LOCKDEP_CHAINS:      16384
> [   17.402685] ... CHAINHASH_SIZE:          8192
> [   17.402744]  memory used by lock dependency info: 1648 kB
> [   17.402798]  per task-struct memory footprint: 1680 bytes
> [   17.402853] ------------------------
> [   17.402903] | Locking API testsuite:
> [   17.402954] ----------------------------------------------------------------------------
> [   17.403028]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [   17.403101]   --------------------------------------------------------------------------
> [   17.403179]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.404370]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.405486]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.406652]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.407826]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.409052]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.410280]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.411514]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.412580]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.413647]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   17.414777]   --------------------------------------------------------------------------
> [   17.414851]               recursive read-lock:             |  ok  |             |  ok  |
> [   17.415334]            recursive read-lock #2:             |  ok  |             |  ok  |
> [   17.415824]             mixed read-write-lock:             |  ok  |             |  ok  |
> [   17.416312]             mixed write-read-lock:             |  ok  |             |  ok  |
> [   17.416807]   --------------------------------------------------------------------------
> [   17.416880]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   17.417444]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   17.418018]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   17.418583]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   17.419156]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [   17.419730]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [   17.420294]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   17.420865]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   17.421432]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   17.422003]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   17.422568]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   17.423164]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   17.423759]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   17.424347]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   17.424943]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   17.425530]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   17.426126]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   17.426713]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   17.427296]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   17.427874]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   17.428446]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   17.429035]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   17.429618]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   17.430205]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   17.430798]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   17.431376]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   17.431969]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   17.432550]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   17.433143]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   17.433726]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   17.434307]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   17.434894]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   17.435479]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   17.436063]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   17.436647]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   17.437237]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   17.437831]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   17.438410]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   17.439004]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   17.439586]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   17.440180]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   17.440765]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   17.441347]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   17.441934]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   17.442520]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   17.443105]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   17.443694]       hard-irq read-recursion/123:  ok  |
> [   17.443943]       soft-irq read-recursion/123:  ok  |
> [   17.444193]       hard-irq read-recursion/132:  ok  |
> [   17.444441]       soft-irq read-recursion/132:  ok  |
> [   17.444700]       hard-irq read-recursion/213:  ok  |
> [   17.444949]       soft-irq read-recursion/213:  ok  |
> [   17.445199]       hard-irq read-recursion/231:  ok  |
> [   17.445448]       soft-irq read-recursion/231:  ok  |
> [   17.445707]       hard-irq read-recursion/312:  ok  |
> [   17.445956]       soft-irq read-recursion/312:  ok  |
> [   17.446206]       hard-irq read-recursion/321:  ok  |
> [   17.446454]       soft-irq read-recursion/321:  ok  |
> [   17.446711] -------------------------------------------------------
> [   17.446767] Good, all 218 testcases passed! |
> [   17.446820] ---------------------------------
> [   17.447871] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [   17.448711] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [   17.448901] Checking aperture...
> [   17.448953] CPU 0: aperture @ e8000000 size 128 MB
> [   17.470739] Memory: 1013752k/1048000k available (3200k kernel code, 33568k reserved, 1519k data, 212k init)
> [   17.530543] Calibrating delay using timer specific routine.. 4390.56 BogoMIPS (lpj=2195280)
> [   17.530799] Mount-cache hash table entries: 256
> [   17.531328] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [   17.531387] CPU: L2 Cache: 1024K (64 bytes/line)
> [   17.531462] SMP alternatives: switching to UP code
> [   17.531743] Freeing SMP alternatives: 28k freed
> [   17.531816] ACPI: Core revision 20070126
> [   17.536624] Parsing all Control Methods:
> [   17.536769] Table [DSDT](id 0001) - 650 Objects with 66 Devices 205 Methods 24 Regions
> [   17.538016] Parsing all Control Methods:
> [   17.538146] Table [SSDT](id 0002) - 3 Objects with 0 Devices 1 Methods 0 Regions
> [   17.538263]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
> [   17.558729] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
> [   17.569330] Using local APIC timer interrupts.
> [   17.614892] result 12468058
> [   17.614942] Detected 12.468 MHz APIC timer.
> [   17.615526] Brought up 1 CPUs
> [   17.615800] PM: Adding info for No Bus:platform
> [   17.616047] NET: Registered protocol family 16
> [   17.616280] No dock devices found.
> [   17.616370] PM: Adding info for No Bus:vtcon0
> [   17.616570] ACPI: bus type pci registered
> [   17.616634] PCI: Using configuration type 1
> [   17.618818] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
> [   17.618981] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8 regs on int 0x9
> [   17.619507] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 5 Wake, Enabled 1 Runtime GPEs in this block
> [   17.619786] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 1 Runtime GPEs in this block
> [   17.620361] Completing Region/Field/Buffer/Package initialization:.....................................................................
> [   17.624273] Initialized 24/24 Regions 2/2 Fields 29/29 Buffers 14/21 Packages (662 nodes)
> [   17.624393] Initializing Device/Processor/Thermal objects by executing _INI methods:.
> [   17.624561] Executed 1 _INI methods requiring 0 _STA executions (examined 70 objects)
> [   17.624693] ACPI: Interpreter enabled
> [   17.624745] ACPI: (supports S0 S3 S4 S5)
> [   17.624983] ACPI: Using IOAPIC for interrupt routing
> [   17.625149] PM: Adding info for acpi:acpi_system:00
> [   17.625225] PM: Adding info for acpi:button_power:00
> [   17.625289] PM: Adding info for acpi:ACPI0007:00
> [   17.625374] PM: Adding info for acpi:device:00
> [   17.625455] PM: Adding info for acpi:pnp0c14:00
> [   17.625608] PM: Adding info for acpi:PNP0C0C:00
> [   17.625690] PM: Adding info for acpi:PNP0C0D:00
> [   17.625774] PM: Adding info for acpi:PNP0A03:00
> [   17.625928] PM: Adding info for acpi:device:01
> [   17.626084] PM: Adding info for acpi:device:02
> [   17.626170] PM: Adding info for acpi:device:03
> [   17.626256] PM: Adding info for acpi:device:04
> [   17.626338] PM: Adding info for acpi:device:05
> [   17.626447] PM: Adding info for acpi:device:06
> [   17.626525] PM: Adding info for acpi:device:07
> [   17.626610] PM: Adding info for acpi:device:08
> [   17.626686] PM: Adding info for acpi:device:09
> [   17.626768] PM: Adding info for acpi:device:0a
> [   17.626847] PM: Adding info for acpi:device:0b
> [   17.626934] PM: Adding info for acpi:device:0c
> [   17.627011] PM: Adding info for acpi:device:0d
> [   17.627094] PM: Adding info for acpi:device:0e
> [   17.627176] PM: Adding info for acpi:device:0f
> [   17.627258] PM: Adding info for acpi:device:10
> [   17.627336] PM: Adding info for acpi:device:11
> [   17.627427] PM: Adding info for acpi:device:12
> [   17.627506] PM: Adding info for acpi:device:13
> [   17.627590] PM: Adding info for acpi:device:14
> [   17.627672] PM: Adding info for acpi:device:15
> [   17.627753] PM: Adding info for acpi:ACPI0003:00
> [   17.627832] PM: Adding info for acpi:PNP0C02:00
> [   17.627913] PM: Adding info for acpi:PNP0C01:00
> [   17.628002] PM: Adding info for acpi:PNP0C09:00
> [   17.667388] PM: Adding info for acpi:PNP0C0A:00
> [   17.667474] PM: Adding info for acpi:PNP0C02:01
> [   17.667555] PM: Adding info for acpi:PNP0000:00
> [   17.667629] PM: Adding info for acpi:PNP0100:00
> [   17.667708] PM: Adding info for acpi:PNP0200:00
> [   17.667782] PM: Adding info for acpi:PNP0800:00
> [   17.667862] PM: Adding info for acpi:PNP0B00:00
> [   17.667936] PM: Adding info for acpi:PNP0C04:00
> [   17.668093] PM: Adding info for acpi:PNP0303:00
> [   17.668243] PM: Adding info for acpi:PNP0F13:00
> [   17.668330] PM: Adding info for acpi:PNP0A05:00
> [   17.668800] PM: Adding info for acpi:PNP0700:00
> [   17.673598] PM: Adding info for acpi:PNP0401:00
> [   17.673814] PM: Adding info for acpi:device:16
> [   17.673974] PM: Adding info for acpi:device:17
> [   17.674122] PM: Adding info for acpi:device:18
> [   17.674287] PM: Adding info for acpi:video:00
> [   17.674407] PM: Adding info for acpi:device:19
> [   17.674526] PM: Adding info for acpi:device:1a
> [   17.674640] PM: Adding info for acpi:device:1b
> [   17.675014] PM: Adding info for acpi:PNP0C0F:00
> [   17.675187] PM: Adding info for acpi:PNP0C0F:01
> [   17.675371] PM: Adding info for acpi:PNP0C0F:02
> [   17.675544] PM: Adding info for acpi:PNP0C0F:03
> [   17.675724] PM: Adding info for acpi:PNP0C0F:04
> [   17.675894] PM: Adding info for acpi:PNP0C0F:05
> [   17.676072] PM: Adding info for acpi:PNP0C0F:06
> [   17.676245] PM: Adding info for acpi:PNP0C0F:07
> [   17.676430] PM: Adding info for acpi:PNP0C0F:08
> [   17.676616] PM: Adding info for acpi:PNP0C0F:09
> [   17.676795] PM: Adding info for acpi:PNP0C0F:0a
> [   17.676968] PM: Adding info for acpi:PNP0C0F:0b
> [   17.677150] PM: Adding info for acpi:PNP0C0F:0c
> [   17.677354] PM: Adding info for acpi:PNP0C0F:0d
> [   17.677428] PM: Adding info for acpi:thermal:00
> [   17.677487] PM: Adding info for acpi:thermal:01
> [   17.677838] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [   17.677936] PM: Adding info for No Bus:pci0000:00
> [   17.678314] 0000:00:08.0: cannot adjust BAR0 (not I/O)
> [   17.678371] 0000:00:08.0: cannot adjust BAR1 (not I/O)
> [   17.678427] 0000:00:08.0: cannot adjust BAR2 (not I/O)
> [   17.678481] 0000:00:08.0: cannot adjust BAR3 (not I/O)
> [   17.679034] PCI: Bus #03 (-#06) is hidden behind  bridge #02 (-#02) (try 'pci=assign-busses')
> [   17.679109] Please report the result to linux-kernel to fix this permanently
> [   17.679229] PCI: Bus #07 (-#0a) is hidden behind  bridge #02 (-#02) (try 'pci=assign-busses')
> [   17.679304] Please report the result to linux-kernel to fix this permanently
> [   17.679476] Boot video device is 0000:01:00.0
> [   17.679535] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [   17.679678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
> [   17.679749] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP0._PRT]
> [   17.680943] PM: Adding info for pci:0000:00:00.0
> [   17.682179] PM: Adding info for pci:0000:00:01.0
> [   17.683404] PM: Adding info for pci:0000:00:01.1
> [   17.684622] PM: Adding info for pci:0000:00:02.0
> [   17.685836] PM: Adding info for pci:0000:00:02.1
> [   17.687056] PM: Adding info for pci:0000:00:02.2
> [   17.688272] PM: Adding info for pci:0000:00:06.0
> [   17.689498] PM: Adding info for pci:0000:00:06.1
> [   17.690712] PM: Adding info for pci:0000:00:08.0
> [   17.691935] PM: Adding info for pci:0000:00:0a.0
> [   17.693149] PM: Adding info for pci:0000:00:0b.0
> [   17.694382] PM: Adding info for pci:0000:00:18.0
> [   17.695596] PM: Adding info for pci:0000:00:18.1
> [   17.696821] PM: Adding info for pci:0000:00:18.2
> [   17.698035] PM: Adding info for pci:0000:00:18.3
> [   17.698147] PM: Adding info for pci:0000:02:00.0
> [   17.698253] PM: Adding info for pci:0000:02:01.0
> [   17.698373] PM: Adding info for pci:0000:02:02.0
> [   17.698479] PM: Adding info for pci:0000:02:04.0
> [   17.698590] PM: Adding info for pci:0000:02:04.1
> [   17.698697] PM: Adding info for pci:0000:02:04.2
> [   17.698814] PM: Adding info for pci:0000:01:00.0
> [   17.699206] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 18 19) *0
> [   17.699725] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 18 19) *0
> [   17.700246] ACPI: PCI Interrupt Link [LNK3] (IRQs 17) *0
> [   17.700706] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 18 19) *0, disabled.
> [   17.701249] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 18 19) *0
> [   17.701754] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22) *0
> [   17.702253] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *0
> [   17.702761] ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0
> [   17.703260] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *0
> [   17.703775] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22) *0, disabled.
> [   17.704311] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22) *0
> [   17.704816] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22) *0
> [   17.705333] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22) *0, disabled.
> [   17.705879] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0, disabled.
> [   17.706254] Linux Plug and Play Support v0.97 (c) Adam Belay
> [   17.706334] pnp: PnP ACPI init
> [   17.706401] PM: Adding info for No Bus:pnp0
> [   17.706597] PM: Adding info for pnp:00:00
> [   17.707281] PM: Adding info for pnp:00:01
> [   17.707475] PM: Adding info for pnp:00:02
> [   17.728319] PM: Adding info for pnp:00:03
> [   17.728404] PM: Adding info for pnp:00:04
> [   17.728465] PM: Adding info for pnp:00:05
> [   17.728541] PM: Adding info for pnp:00:06
> [   17.728606] PM: Adding info for pnp:00:07
> [   17.728716] PM: Adding info for pnp:00:08
> [   17.728822] PM: Adding info for pnp:00:09
> [   17.729092] PM: Adding info for pnp:00:0a
> [   17.731090] PM: Adding info for pnp:00:0b
> [   17.732020] pnp: PnP ACPI: found 12 devices
> [   17.732153] Generic PHY: Registered new driver
> [   17.732403] SCSI subsystem initialized
> [   17.732504] libata version 2.20 loaded.
> [   17.732614] PCI: Using ACPI for IRQ routing
> [   17.732668] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> [   17.732752] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
> [   17.733015] agpgart: Detected AGP bridge 0
> [   17.733072] agpgart: Setting up Nforce3 AGP.
> [   17.737586] PM: Adding info for No Bus:agpgart
> [   17.737683] agpgart: AGP aperture is 128M @ 0xe8000000
> [   17.737871] pnp: 00:01: ioport range 0x8000-0x807f has been reserved
> [   17.737929] pnp: 00:01: ioport range 0x8080-0x80ff has been reserved
> [   17.737986] pnp: 00:01: ioport range 0x8400-0x847f has been reserved
> [   17.738044] pnp: 00:01: ioport range 0x8480-0x84ff has been reserved
> [   17.738101] pnp: 00:01: ioport range 0x8800-0x887f has been reserved
> [   17.738158] pnp: 00:01: ioport range 0x8880-0x88ff has been reserved
> [   17.738216] Time: tsc clocksource has been installed.
> [   17.738275] pnp: 00:01: ioport range 0x2040-0x207f has been reserved
> [   17.738332] pnp: 00:01: ioport range 0x2000-0x203f has been reserved
> [   17.738396] pnp: 00:02: iomem range 0xfff80000-0xffffffff has been reserved
> [   17.738455] pnp: 00:02: iomem range 0xfec00000-0xfec00fff has been reserved
> [   17.738514] pnp: 00:02: iomem range 0xfee00000-0xfeefffff has been reserved
> [   17.738572] pnp: 00:02: iomem range 0xfed00000-0xfed00fff has been reserved
> [   17.738673] PM: Adding info for No Bus:mem
> [   17.738725] PM: Adding info for No Bus:kmem
> [   17.738768] PM: Adding info for No Bus:null
> [   17.738816] PM: Adding info for No Bus:port
> [   17.738858] PM: Adding info for No Bus:zero
> [   17.738905] PM: Adding info for No Bus:full
> [   17.738947] PM: Adding info for No Bus:random
> [   17.738997] PM: Adding info for No Bus:urandom
> [   17.739039] PM: Adding info for No Bus:kmsg
> [   17.739158] PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.0
> [   17.739235] PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.1
> [   17.739313] PCI: Bus 3, cardbus bridge: 0000:02:04.0
> [   17.739367]   IO window: 00003000-000030ff
> [   17.739421]   IO window: 00003400-000034ff
> [   17.739476]   PREFETCH window: 50000000-53ffffff
> [   17.739531] PCI: Bus 7, cardbus bridge: 0000:02:04.1
> [   17.739585]   IO window: 00003800-000038ff
> [   17.739639]   IO window: 00003c00-00003cff
> [   17.739693]   PREFETCH window: 54000000-57ffffff
> [   17.739748] PCI: Bridge: 0000:00:0a.0
> [   17.739800]   IO window: 3000-7fff
> [   17.739853]   MEM window: e0100000-e17fffff
> [   17.739906]   PREFETCH window: 50000000-57ffffff
> [   17.739962] PCI: Bridge: 0000:00:0b.0
> [   17.740013]   IO window: disabled.
> [   17.740067]   MEM window: e2000000-e2ffffff
> [   17.740121]   PREFETCH window: f0000000-f80fffff
> [   17.740183] PCI: Setting latency timer of device 0000:00:0a.0 to 64
> [   17.740708] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 19
> [   17.740772] ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [LNK1] -> GSI 19 (level, low) -> IRQ 19
> [   17.741334] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 18
> [   17.741394] ACPI: PCI Interrupt 0000:02:04.1[B] -> Link [LNK2] -> GSI 18 (level, low) -> IRQ 18
> [   17.741573] NET: Registered protocol family 2
> [   17.751310] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
> [   17.751620] TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
> [   17.757500] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
> [   17.762325] TCP: Hash tables configured (established 65536 bind 65536)
> [   17.762418] TCP reno registered
> [   17.765663] Simple Boot Flag at 0x37 set to 0x1
> [   17.765831] PM: Adding info for No Bus:mcelog
> [   17.765911] PM: Adding info for No Bus:msr0
> [   17.765974] PM: Adding info for No Bus:cpu0
> [   17.766279] PM: Adding info for platform:pcspkr
> [   17.766553] PM: Adding info for No Bus:snapshot
> [   17.766602] audit: initializing netlink socket (disabled)
> [   17.766677] audit(1174429488.298:1): initialized
> [   17.766920] Total HugeTLB memory allocated, 0
> [   17.767309] Loading Reiser4. See www.namesys.com for a description of Reiser4.
> [   17.767640] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   17.768058] io scheduler noop registered
> [   17.768111] io scheduler anticipatory registered
> [   17.768164] io scheduler deadline registered
> [   17.768257] io scheduler cfq registered (default)
> [   17.769736] ACPI: AC Adapter [ACAD] (on-line)
> [   17.791230] ACPI: Battery Slot [BAT1] (battery present)
> [   17.791428] input: Power Button (FF) as /class/input/input0
> [   17.791490] ACPI: Power Button (FF) [PWRF]
> [   17.791611] input: Power Button (CM) as /class/input/input1
> [   17.791667] ACPI: Power Button (CM) [PWRB]
> [   17.791799] input: Lid Switch as /class/input/input2
> [   17.791854] ACPI: Lid Switch [LID]
> [   17.792327] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> [   17.793720] ACPI: CPU0 (power states: C1[C1] C2[C2])
> [   17.793997] cpuidle: using driver acpi_idle
> [   17.825473] ACPI Exception (thermal-0412): AE_NOT_FOUND, Invalid active threshold [0] [20070126]
> [   17.828471] ACPI: Thermal Zone [THRM] (62 C)
> [   17.828571] PM: Adding info for No Bus:tty
> [   17.828615] PM: Adding info for No Bus:console
> [   17.828663] PM: Adding info for No Bus:ptmx
> [   17.828702] PM: Adding info for No Bus:tty0
> [   17.828765] PM: Adding info for No Bus:vcs
> [   17.828811] PM: Adding info for No Bus:vcsa
> [   17.828858] PM: Adding info for No Bus:tty1
> [   17.828908] PM: Adding info for No Bus:tty2
> [   17.828949] PM: Adding info for No Bus:tty3
> [   17.828996] PM: Adding info for No Bus:tty4
> [   17.829035] PM: Adding info for No Bus:tty5
> [   17.829089] PM: Adding info for No Bus:tty6
> [   17.829132] PM: Adding info for No Bus:tty7
> [   17.829183] PM: Adding info for No Bus:tty8
> [   17.829228] PM: Adding info for No Bus:tty9
> [   17.829280] PM: Adding info for No Bus:tty10
> [   17.829323] PM: Adding info for No Bus:tty11
> [   17.829374] PM: Adding info for No Bus:tty12
> [   17.829418] PM: Adding info for No Bus:tty13
> [   17.829474] PM: Adding info for No Bus:tty14
> [   17.829518] PM: Adding info for No Bus:tty15
> [   17.829570] PM: Adding info for No Bus:tty16
> [   17.829614] PM: Adding info for No Bus:tty17
> [   17.829667] PM: Adding info for No Bus:tty18
> [   17.829713] PM: Adding info for No Bus:tty19
> [   17.829767] PM: Adding info for No Bus:tty20
> [   17.829820] PM: Adding info for No Bus:tty21
> [   17.829874] PM: Adding info for No Bus:tty22
> [   17.829922] PM: Adding info for No Bus:tty23
> [   17.829976] PM: Adding info for No Bus:tty24
> [   17.830024] PM: Adding info for No Bus:tty25
> [   17.830083] PM: Adding info for No Bus:tty26
> [   17.830130] PM: Adding info for No Bus:tty27
> [   17.830185] PM: Adding info for No Bus:tty28
> [   17.830230] PM: Adding info for No Bus:tty29
> [   17.830286] PM: Adding info for No Bus:tty30
> [   17.830332] PM: Adding info for No Bus:tty31
> [   17.830387] PM: Adding info for No Bus:tty32
> [   17.830433] PM: Adding info for No Bus:tty33
> [   17.830489] PM: Adding info for No Bus:tty34
> [   17.830540] PM: Adding info for No Bus:tty35
> [   17.830600] PM: Adding info for No Bus:tty36
> [   17.830647] PM: Adding info for No Bus:tty37
> [   17.830705] PM: Adding info for No Bus:tty38
> [   17.830751] PM: Adding info for No Bus:tty39
> [   17.830807] PM: Adding info for No Bus:tty40
> [   17.830855] PM: Adding info for No Bus:tty41
> [   17.830912] PM: Adding info for No Bus:tty42
> [   17.830960] PM: Adding info for No Bus:tty43
> [   17.831015] PM: Adding info for No Bus:tty44
> [   17.831063] PM: Adding info for No Bus:tty45
> [   17.831138] PM: Adding info for No Bus:tty46
> [   17.831181] PM: Adding info for No Bus:tty47
> [   17.831235] PM: Adding info for No Bus:tty48
> [   17.831280] PM: Adding info for No Bus:tty49
> [   17.831334] PM: Adding info for No Bus:tty50
> [   17.831378] PM: Adding info for No Bus:tty51
> [   17.831429] PM: Adding info for No Bus:tty52
> [   17.831474] PM: Adding info for No Bus:tty53
> [   17.831527] PM: Adding info for No Bus:tty54
> [   17.831574] PM: Adding info for No Bus:tty55
> [   17.831633] PM: Adding info for No Bus:tty56
> [   17.831683] PM: Adding info for No Bus:tty57
> [   17.831740] PM: Adding info for No Bus:tty58
> [   17.831787] PM: Adding info for No Bus:tty59
> [   17.831844] PM: Adding info for No Bus:tty60
> [   17.831893] PM: Adding info for No Bus:tty61
> [   17.831952] PM: Adding info for No Bus:tty62
> [   17.832002] PM: Adding info for No Bus:tty63
> [   17.832160] PM: Adding info for No Bus:rtc
> [   17.832208] Real Time Clock Driver v1.12ac
> [   17.832270] PM: Adding info for No Bus:hpet
> [   17.832420] PM: Adding info for No Bus:watchdog
> [   17.832457] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
> [   17.832534] Linux agpgart interface v0.102 (c) Dave Jones
> [   17.832589] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> [   17.832664] Hangcheck: Using get_cycles().
> [   17.833305] loop: loaded (max 8 devices)
> [   17.833391] Marvell 88E1101: Registered new driver
> [   17.833475] Marvell 88E1111: Registered new driver
> [   17.833560] Marvell 88E1145: Registered new driver
> [   17.833652] Davicom DM9161E: Registered new driver
> [   17.833736] Davicom DM9131: Registered new driver
> [   17.833821] Cicada Cis8204: Registered new driver
> [   17.833905] Cicada Cis8201: Registered new driver
> [   17.833997] LXT970: Registered new driver
> [   17.834087] LXT971: Registered new driver
> [   17.834171] QS6612: Registered new driver
> [   17.834254] SMSC LAN83C185: Registered new driver
> [   17.834402] PM: Adding info for No Bus:lo
> [   17.834607] 8139too Fast Ethernet driver 0.9.28
> [   17.834685] ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNK2] -> GSI 18 (level, low) -> IRQ 18
> [   17.835148] PM: Adding info for No Bus:eth0
> [   17.835216] eth0: RealTek RTL8139 at 0xffffc20000018800, 00:0f:b0:07:dc:49, IRQ 18
> [   17.835290] eth0:  Identified 8139 chip type 'RTL-8101'
> [   17.835500] pata_amd 0000:00:08.0: version 0.3.8
> [   17.835526] PCI: Setting latency timer of device 0000:00:08.0 to 64
> [   17.835636] ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000012080 irq 14
> [   17.835753] ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000012088 irq 15
> [   17.835848] scsi0 : pata_amd
> [   17.835912] PM: Adding info for No Bus:host0
> [   17.990015] ata1.00: ATA-6: HTS721010G9AT00, MCZOA51A, max UDMA/100
> [   17.990073] ata1.00: 195371568 sectors, multi 16: LBA48 
> [   17.993003] ata1.00: configured for UDMA/100
> [   17.993061] scsi1 : pata_amd
> [   17.993119] PM: Adding info for No Bus:host1
> [   18.297591] ata2.00: ATAPI, max MWDMA2
> [   18.451340] ata2.00: configured for MWDMA2
> [   18.451405] PM: Adding info for No Bus:target0:0:0
> [   18.451680] scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9AT00  MCZO PQ: 0 ANSI: 5
> [   18.452894] PM: Adding info for scsi:0:0:0:0
> [   18.453120] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> [   18.453193] sd 0:0:0:0: [sda] Write Protect is off
> [   18.453248] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   18.453271] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   18.453648] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> [   18.453717] sd 0:0:0:0: [sda] Write Protect is off
> [   18.453771] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   18.453793] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   18.453901]  sda: sda1 sda2 sda3
> [   18.471748] sd 0:0:0:0: [sda] Attached SCSI disk
> [   18.471874] PM: Adding info for No Bus:target1:0:0
> [   18.472353] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+RW GCA-4040N 1.19 PQ: 0 ANSI: 5
> [   18.472434] PM: Adding info for scsi:1:0:0:0
> [   18.474384] sr0: scsi3-mmc drive: 40x/24x writer cd/rw xa/form2 cdda tray
> [   18.474443] Uniform CD-ROM driver Revision: 3.20
> [   18.474628] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [   18.474809] Yenta: CardBus bridge found at 0000:02:04.0 [103c:006d]
> [   18.474880] PCI: Bus 3, cardbus bridge: 0000:02:04.0
> [   18.474934]   IO window: 00003000-000030ff
> [   18.474988]   IO window: 00003400-000034ff
> [   18.475043]   PREFETCH window: 50000000-53ffffff
> [   18.475103]   MEM window: e0400000-e07fffff
> [   18.475159] Yenta: Enabling burst memory read transactions
> [   18.475215] Yenta: Using CSCINT to route CSC interrupts to PCI
> [   18.475270] Yenta: Routing CardBus interrupts to PCI
> [   18.475327] Yenta TI: socket 0000:02:04.0, mfunc 0x01111d22, devctl 0x64
> [   18.698633] Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
> [   18.698687] Socket status: 30000086
> [   18.698742] Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
> [   18.698816] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
> [   18.698886] pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
> [   18.698945] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
> [   18.699145] PM: Adding info for No Bus:pcmcia_socket0
> [   18.949375] Yenta: CardBus bridge found at 0000:02:04.1 [103c:006d]
> [   18.949447] Yenta: Using CSCINT to route CSC interrupts to PCI
> [   18.949502] Yenta: Routing CardBus interrupts to PCI
> [   18.949560] Yenta TI: socket 0000:02:04.1, mfunc 0x01111d22, devctl 0x64
> [   19.172901] Yenta: ISA IRQ mask 0x0cf8, PCI irq 18
> [   19.172955] Socket status: 30000006
> [   19.173009] Yenta: Raising subordinate bus# of parent bus (#02) from #06 to #0a
> [   19.173083] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
> [   19.173140] pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
> [   19.173198] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
> [   19.173373] PM: Adding info for No Bus:pcmcia_socket1
> [   19.423712] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [   19.423836] PM: Adding info for platform:i8042
> [   19.433971] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   19.434082] PM: Adding info for serio:serio0
> [   19.434178] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   19.434240] PM: Adding info for serio:serio1
> [   19.434351] PM: Adding info for No Bus:psaux
> [   19.434390] mice: PS/2 mouse device common for all mice
> [   19.434590] async_tx: api initialized (sync-only)
> [   19.434645] xor: automatically using best checksumming function: generic_sse
> [   19.439565]    generic_sse:  6560.000 MB/sec
> [   19.439618] xor: using function: generic_sse (6560.000 MB/sec)
> [   19.439674] EDAC MC: Ver: 2.0.1 Mar 20 2007
> [   19.440144] EDAC MC0: Giving out device to k8_edac Athlon64/Opteron: DEV 0000:00:18.2
> [   19.440257] cpuidle: using governor ladder
> [   19.440389] TCP cubic registered
> [   19.440440] Initializing XFRM netlink socket
> [   19.440515] NET: Registered protocol family 1
> [   19.440575] NET: Registered protocol family 17
> [   19.440642] NET: Registered protocol family 15
> [   19.440746] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3400+ processors (version 2.00.00)
> [   19.440940] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
> [   19.440995] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
> [   19.441050] powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x12
> [   19.441737] swsusp: Resume From Partition /dev/sda3
> [   19.441739] PM: Checking swsusp image.
> [   19.444558] Marking TSC unstable due to possible TSC halt in C2
> [   19.444618] Time: acpi_pm clocksource has been installed.
> [   19.458341] PM: Resume from disk failed.
> [   19.499700] input: AT Translated Set 2 keyboard as /class/input/input3
> [   19.576971] reiser4: sda2: found disk format 4.0.0.
> [   25.172977] VFS: Mounted root (reiser4 filesystem) readonly.
> [   25.173099] Freeing unused kernel memory: 212k freed
> [   25.223972] PM: Adding info for No Bus:vcs1
> [   25.453962] PM: Adding info for No Bus:vcsa1
> [   26.020896] PM: Removing info for No Bus:vcs1
> [   26.021468] PM: Removing info for No Bus:vcsa1
> [   26.021876] PM: Adding info for No Bus:vcs1
> [   26.022218] PM: Adding info for No Bus:vcsa1
> [   26.022602] PM: Removing info for No Bus:vcs1
> [   26.022952] PM: Removing info for No Bus:vcsa1
> [   26.233012] PM: Adding info for No Bus:vcs1
> [   26.233388] PM: Adding info for No Bus:vcsa1
> [   26.233839] PM: Removing info for No Bus:vcs1
> [   26.234049] PM: Removing info for No Bus:vcsa1
> [   26.235514] PM: Adding info for No Bus:vcs1
> [   26.235956] PM: Adding info for No Bus:vcsa1
> [   26.236402] PM: Removing info for No Bus:vcs1
> [   26.236784] PM: Removing info for No Bus:vcsa1
> [   26.237017] PM: Adding info for No Bus:vcs1
> [   26.237587] PM: Adding info for No Bus:vcsa1
> [   26.238069] PM: Removing info for No Bus:vcs1
> [   26.238457] PM: Removing info for No Bus:vcsa1
> [   26.302723] PM: Adding info for No Bus:vcs1
> [   26.303340] PM: Adding info for No Bus:vcsa1
> [   29.773194] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   29.773218] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [   29.936763] usbcore: registered new interface driver usbfs
> [   29.936876] usbcore: registered new interface driver hub
> [   29.936938] usbcore: registered new device driver usb
> [   29.938045] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [   29.938092] PCI: Enabling device 0000:00:02.0 (0004 -> 0006)
> [   29.938715] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
> [   29.938727] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, low) -> IRQ 22
> [   29.938746] PCI: Setting latency timer of device 0000:00:02.0 to 64
> [   29.938750] ohci_hcd 0000:00:02.0: OHCI Host Controller
> [   29.943103] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
> [   30.154957] ohci_hcd 0000:00:02.0: irq 22, io mem 0xe0000000
> [   30.190412] PM: Adding info for No Bus:timer
> [   30.208166] usb usb1: new device found, idVendor=0000, idProduct=0000
> [   30.208171] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
> [   30.208173] usb usb1: Product: OHCI Host Controller
> [   30.208175] usb usb1: Manufacturer: Linux 2.6.21-rc4-mm1 ohci_hcd
> [   30.208177] usb usb1: SerialNumber: 0000:00:02.0
> [   30.208266] PM: Adding info for usb:usb1
> [   30.208743] PM: Adding info for No Bus:usbdev1.1_ep00
> [   30.208769] usb usb1: configuration #1 chosen from 1 choice
> [   30.209010] PM: Adding info for usb:1-0:1.0
> [   30.209168] hub 1-0:1.0: USB hub found
> [   30.209274] hub 1-0:1.0: 3 ports detected
> [   30.310069] PM: Adding info for No Bus:usbdev1.1_ep81
> [   30.310414] PM: Adding info for No Bus:usbdev1.1
> [   30.310803] PCI: Enabling device 0000:00:02.1 (0004 -> 0006)
> [   30.311309] ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 21
> [   30.311320] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 21 (level, low) -> IRQ 21
> [   30.311341] PCI: Setting latency timer of device 0000:00:02.1 to 64
> [   30.311344] ohci_hcd 0000:00:02.1: OHCI Host Controller
> [   30.311377] ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
> [   30.523351] ohci_hcd 0000:00:02.1: irq 21, io mem 0xe0001000
> [   30.576281] usb usb2: new device found, idVendor=0000, idProduct=0000
> [   30.576285] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
> [   30.576288] usb usb2: Product: OHCI Host Controller
> [   30.576290] usb usb2: Manufacturer: Linux 2.6.21-rc4-mm1 ohci_hcd
> [   30.576292] usb usb2: SerialNumber: 0000:00:02.1
> [   30.576318] PM: Adding info for usb:usb2
> [   30.576410] PM: Adding info for No Bus:usbdev2.1_ep00
> [   30.576433] usb usb2: configuration #1 chosen from 1 choice
> [   30.576451] PM: Adding info for usb:2-0:1.0
> [   30.576485] hub 2-0:1.0: USB hub found
> [   30.576499] hub 2-0:1.0: 3 ports detected
> [   30.677124] PM: Adding info for No Bus:usbdev2.1_ep81
> [   30.677190] PM: Adding info for No Bus:usbdev2.1
> [   30.677819] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
> [   30.677832] ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUS2] -> GSI 20 (level, low) -> IRQ 20
> [   30.677853] PCI: Setting latency timer of device 0000:00:02.2 to 64
> [   30.677856] ehci_hcd 0000:00:02.2: EHCI Host Controller
> [   30.677889] ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
> [   30.677932] PCI: cache line size of 64 is not supported by device 0000:00:02.2
> [   30.677957] ehci_hcd 0000:00:02.2: irq 20, io mem 0xe0004000
> [   30.677962] ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [   30.678054] usb usb3: new device found, idVendor=0000, idProduct=0000
> [   30.678057] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
> [   30.678059] usb usb3: Product: EHCI Host Controller
> [   30.678061] usb usb3: Manufacturer: Linux 2.6.21-rc4-mm1 ehci_hcd
> [   30.678063] usb usb3: SerialNumber: 0000:00:02.2
> [   30.678072] PM: Adding info for usb:usb3
> [   30.678141] PM: Adding info for No Bus:usbdev3.1_ep00
> [   30.678162] usb usb3: configuration #1 chosen from 1 choice
> [   30.678184] PM: Adding info for usb:3-0:1.0
> [   30.678207] hub 3-0:1.0: USB hub found
> [   30.678380] hub 3-0:1.0: 6 ports detected
> [   30.778960] PM: Adding info for No Bus:usbdev3.1_ep81
> [   30.779025] PM: Adding info for No Bus:usbdev3.1
> [   30.783028] ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
> [   30.783033] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 22 (level, low) -> IRQ 22
> [   30.783069] PCI: Setting latency timer of device 0000:00:06.0 to 64
> [   30.867183] input: PS/2 Mouse as /class/input/input4
> [   30.879995] input: AlpsPS/2 ALPS GlidePoint as /class/input/input5
> [   30.886726] AC'97 0 analog subsections not ready
> [   31.288300] usb 2-2: new full speed USB device using ohci_hcd and address 2
> [   31.446880] intel8x0_measure_ac97_clock: measured 50191 usecs
> [   31.446884] intel8x0: clocking to 47393
> [   31.446930] PM: Adding info for No Bus:card0
> [   31.447154] PM: Adding info for No Bus:pcmC0D2p
> [   31.447411] PM: Adding info for No Bus:pcmC0D1c
> [   31.447441] PM: Adding info for No Bus:pcmC0D0p
> [   31.447539] PM: Adding info for No Bus:pcmC0D0c
> [   31.447565] PM: Adding info for ac97:0-0:AD1981B
> [   31.447601] PM: Adding info for No Bus:controlC0
> [   31.508940] usb 2-2: new device found, idVendor=049f, idProduct=0086
> [   31.508945] usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
> [   31.508948] usb 2-2: Product: Bluetooth by hp
> [   31.508950] usb 2-2: Manufacturer: ACTIONTEC
> [   31.508975] PM: Adding info for usb:2-2
> [   31.509068] PM: Adding info for No Bus:usbdev2.2_ep00
> [   31.509092] usb 2-2: configuration #1 chosen from 1 choice
> [   31.512951] PM: Adding info for usb:2-2:1.0
> [   31.513032] PM: Adding info for No Bus:usbdev2.2_ep81
> [   31.513073] PM: Adding info for No Bus:usbdev2.2_ep02
> [   31.513107] PM: Adding info for No Bus:usbdev2.2_ep82
> [   31.513141] PM: Adding info for usb:2-2:1.1
> [   31.513182] PM: Adding info for No Bus:usbdev2.2_ep03
> [   31.513221] PM: Adding info for No Bus:usbdev2.2_ep83
> [   31.513249] PM: Adding info for usb:2-2:1.2
> [   31.513329] PM: Adding info for No Bus:usbdev2.2
> [   31.717722] hci_usb: Unknown symbol hci_suspend_dev
> [   31.717763] hci_usb: Unknown symbol hci_free_dev
> [   31.717983] hci_usb: Unknown symbol hci_resume_dev
> [   31.718035] hci_usb: Unknown symbol hci_alloc_dev
> [   31.718136] hci_usb: Unknown symbol hci_unregister_dev
> [   31.718243] hci_usb: Unknown symbol hci_register_dev
> [   31.781354] hci_usb: Unknown symbol hci_suspend_dev
> [   31.781394] hci_usb: Unknown symbol hci_free_dev
> [   31.781614] hci_usb: Unknown symbol hci_resume_dev
> [   31.781666] hci_usb: Unknown symbol hci_alloc_dev
> [   31.781767] hci_usb: Unknown symbol hci_unregister_dev
> [   31.781874] hci_usb: Unknown symbol hci_register_dev
> [   31.787382] hci_usb: Unknown symbol hci_suspend_dev
> [   31.787422] hci_usb: Unknown symbol hci_free_dev
> [   31.787642] hci_usb: Unknown symbol hci_resume_dev
> [   31.787694] hci_usb: Unknown symbol hci_alloc_dev
> [   31.787795] hci_usb: Unknown symbol hci_unregister_dev
> [   31.787901] hci_usb: Unknown symbol hci_register_dev
> [   33.005970] NET: Registered protocol family 10
> [   34.776248] ReiserFS: sda1: found reiserfs format "3.6" with standard journal
> [   34.776310] ReiserFS: sda1: using ordered data mode
> [   34.776796] ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   34.778707] ReiserFS: sda1: checking transaction log (sda1)
> [   34.810342] ReiserFS: sda1: Using r5 hash to sort names
> [   35.034524] Adding 2843496k swap on /dev/disk/by-uuid/fd35277a-8dc7-4afe-8257-fda61b757344.  Priority:100 extents:1 across:2843496k
> [   42.116195] PM: Removing info for No Bus:vcs1
> [   42.116521] PM: Removing info for No Bus:vcsa1
> [   42.146081] PM: Adding info for No Bus:vcs1
> [   42.146219] PM: Adding info for No Bus:vcsa1
> [ 1061.733883] su[2639]: segfault at 0000000000000008 rip 0000003103c098b2 rsp 00007fffb0fea590 error 4
> [ 1601.898867] PM: Removing info for No Bus:vcs1
> [ 1601.899098] PM: Removing info for No Bus:vcsa1
> [ 1601.905470] PM: Adding info for No Bus:vcs1
> [ 1601.905622] PM: Adding info for No Bus:vcsa1
> [ 1606.464599] PM: Adding info for No Bus:vcs2
> [ 1606.464845] PM: Adding info for No Bus:vcsa2
> [ 1606.466860] PM: Removing info for No Bus:vcs2
> [ 1606.466969] PM: Removing info for No Bus:vcsa2
> [ 1606.473400] PM: Adding info for No Bus:vcs3
> [ 1606.473561] PM: Adding info for No Bus:vcsa3
> [ 1606.475560] PM: Removing info for No Bus:vcs3
> [ 1606.475667] PM: Removing info for No Bus:vcsa3
> [ 1606.478811] PM: Adding info for No Bus:vcs4
> [ 1606.478973] PM: Adding info for No Bus:vcsa4
> [ 1606.479291] PM: Removing info for No Bus:vcs4
> [ 1606.479321] PM: Removing info for No Bus:vcsa4
> [ 1606.479397] PM: Adding info for No Bus:vcs5
> [ 1606.479420] PM: Adding info for No Bus:vcsa5
> [ 1606.479450] PM: Removing info for No Bus:vcs5
> [ 1606.479472] PM: Removing info for No Bus:vcsa5
> [ 1606.479549] PM: Adding info for No Bus:vcs6
> [ 1606.479572] PM: Adding info for No Bus:vcsa6
> [ 1606.479604] PM: Removing info for No Bus:vcs6
> [ 1606.479626] PM: Removing info for No Bus:vcsa6
> [ 1606.479694] PM: Adding info for No Bus:vcs7
> [ 1606.479716] PM: Adding info for No Bus:vcsa7
> [ 1606.479745] PM: Removing info for No Bus:vcs7
> [ 1606.479767] PM: Removing info for No Bus:vcsa7
> [ 1606.479835] PM: Adding info for No Bus:vcs8
> [ 1606.479859] PM: Adding info for No Bus:vcsa8
> [ 1606.479928] PM: Removing info for No Bus:vcs8
> [ 1606.479951] PM: Removing info for No Bus:vcsa8
> [ 1606.480018] PM: Adding info for No Bus:vcs9
> [ 1606.480041] PM: Adding info for No Bus:vcsa9
> [ 1606.480071] PM: Removing info for No Bus:vcs9
> [ 1606.480093] PM: Removing info for No Bus:vcsa9
> [ 1606.480160] PM: Adding info for No Bus:vcs10
> [ 1606.480183] PM: Adding info for No Bus:vcsa10
> [ 1606.480212] PM: Removing info for No Bus:vcs10
> [ 1606.480234] PM: Removing info for No Bus:vcsa10
> [ 1606.480302] PM: Adding info for No Bus:vcs11
> [ 1606.480325] PM: Adding info for No Bus:vcsa11
> [ 1606.480354] PM: Removing info for No Bus:vcs11
> [ 1606.480376] PM: Removing info for No Bus:vcsa11
> [ 1606.910477] PM: Adding info for No Bus:vcs2
> [ 1606.910514] PM: Adding info for No Bus:vcsa2
> [ 1606.917302] PM: Removing info for No Bus:vcs2
> [ 1606.917349] PM: Removing info for No Bus:vcsa2
> [ 1606.919043] PM: Adding info for No Bus:vcs3
> [ 1606.919071] PM: Adding info for No Bus:vcsa3
> [ 1606.927621] PM: Adding info for No Bus:vcs4
> [ 1606.927658] PM: Adding info for No Bus:vcsa4
> [ 1606.928858] PM: Removing info for No Bus:vcs3
> [ 1606.928892] PM: Removing info for No Bus:vcsa3
> [ 1606.935224] PM: Removing info for No Bus:vcs4
> [ 1606.935269] PM: Removing info for No Bus:vcsa4
> [ 1606.937061] PM: Adding info for No Bus:vcs5
> [ 1606.937089] PM: Adding info for No Bus:vcsa5
> [ 1606.947922] PM: Removing info for No Bus:vcs5
> [ 1606.947970] PM: Removing info for No Bus:vcsa5
> [ 1606.951331] PM: Adding info for No Bus:vcs6
> [ 1606.951366] PM: Adding info for No Bus:vcsa6
> [ 1606.958845] PM: Removing info for No Bus:vcs6
> [ 1606.958892] PM: Removing info for No Bus:vcsa6
> [ 1606.961602] PM: Adding info for No Bus:vcs7
> [ 1606.961636] PM: Adding info for No Bus:vcsa7
> [ 1606.972031] PM: Removing info for No Bus:vcs7
> [ 1606.972082] PM: Removing info for No Bus:vcsa7
> [ 1606.973903] PM: Adding info for No Bus:vcs8
> [ 1606.973933] PM: Adding info for No Bus:vcsa8
> [ 1606.982366] PM: Removing info for No Bus:vcs8
> [ 1606.982413] PM: Removing info for No Bus:vcsa8
> [ 1606.986078] PM: Adding info for No Bus:vcs9
> [ 1606.986113] PM: Adding info for No Bus:vcsa9
> [ 1607.000479] PM: Adding info for No Bus:vcs10
> [ 1607.000514] PM: Adding info for No Bus:vcsa10
> [ 1607.000750] PM: Removing info for No Bus:vcs9
> [ 1607.000782] PM: Removing info for No Bus:vcsa9
> [ 1607.025869] PM: Adding info for No Bus:vcs11
> [ 1607.025904] PM: Adding info for No Bus:vcsa11
> [ 1607.031896] PM: Removing info for No Bus:vcs11
> [ 1607.031941] PM: Removing info for No Bus:vcsa11
> [ 1607.043139] PM: Removing info for No Bus:vcs10
> [ 1607.043185] PM: Removing info for No Bus:vcsa10
> [ 1608.025861] eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1
> [ 1608.343434] PM: Removing info for No Bus:vcs1
> [ 1608.343599] PM: Removing info for No Bus:vcsa1
> [ 1608.348965] PM: Adding info for No Bus:vcs1
> [ 1608.349084] PM: Adding info for No Bus:vcsa1
> [ 1608.350359] PM: Removing info for No Bus:vcs1
> [ 1608.350447] PM: Removing info for No Bus:vcsa1
> [ 1608.350790] PM: Adding info for No Bus:vcs1
> [ 1608.350809] PM: Adding info for No Bus:vcsa1
> [ 1608.350872] PM: Removing info for No Bus:vcs1
> [ 1608.350891] PM: Removing info for No Bus:vcsa1
> [ 1608.350927] PM: Adding info for No Bus:vcs1
> [ 1608.350945] PM: Adding info for No Bus:vcsa1
> [ 1608.351049] PM: Removing info for No Bus:vcs1
> [ 1608.351068] PM: Removing info for No Bus:vcsa1
> [ 1608.353580] PM: Adding info for No Bus:vcs1
> [ 1608.353616] PM: Adding info for No Bus:vcsa1
> [ 1617.090942] eth0: no IPv6 routers present
> [ 1617.123609] ata1.00: configured for UDMA/100
> [ 1617.123618] ata1: EH complete
> [ 1617.140588] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> [ 1617.140902] sd 0:0:0:0: [sda] Write Protect is off
> [ 1617.140905] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 1617.149976] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 1620.665587] process `named' is using obsolete setsockopt SO_BSDCOMPAT
> [ 1620.742991] PM: Adding info for No Bus:vcs7
> [ 1620.744509] PM: Adding info for No Bus:vcsa7
> [ 1620.792323] PM: Removing info for No Bus:vcs7
> [ 1620.793678] PM: Removing info for No Bus:vcsa7
> [ 1621.266697] PM: Adding info for No Bus:vcs7
> [ 1621.268278] PM: Adding info for No Bus:vcsa7
> [ 1622.859425] PM: Adding info for No Bus:mixer
> [ 1622.939896] PM: Adding info for No Bus:adsp
> [ 1622.955211] PM: Adding info for No Bus:dsp
> [ 1622.958759] PM: Adding info for No Bus:audio
> [ 1624.113602] esound-esd[57956]: segfault at 000000000000ac44 rip 00000036a8c55b2b rsp 00007fff9723d8f0 error 4
> [ 1625.283022] PM: Adding info for No Bus:vcs2
> [ 1625.284318] PM: Adding info for No Bus:vcsa2
> [ 1625.285611] PM: Adding info for No Bus:vcs3
> [ 1625.286744] PM: Adding info for No Bus:vcsa3
> [ 1625.289092] PM: Adding info for No Bus:vcs4
> [ 1625.290316] PM: Adding info for No Bus:vcsa4
> [ 1625.292624] PM: Adding info for No Bus:vcs5
> [ 1625.293892] PM: Adding info for No Bus:vcsa5
> [ 1625.296159] PM: Adding info for No Bus:vcs6
> [ 1625.297535] PM: Adding info for No Bus:vcsa6
> [ 1651.450090] esd[58205]: segfault at 000000000000ac44 rip 00000036a8c55b2b rsp 00007fffebe7fcd0 error 4
> [ 1658.130375] ISO 9660 Extensions: Microsoft Joliet Level 3
> [ 1658.254107] ISO 9660 Extensions: RRIP_1991A
> [ 1660.022177] [ACPI Debug]  String: [0x12] "=====QUERY_25====="
> [ 1663.057766] 
> [ 1663.057769] =======================================================
> [ 1663.057775] [ INFO: possible circular locking dependency detected ]
> [ 1663.057778] 2.6.21-rc4-mm1 #1
> [ 1663.057780] -------------------------------------------------------
> [ 1663.057783] evolution-data-/58416 is trying to acquire lock:
> [ 1663.057785]  (&mm->mmap_sem){----}, at: [<ffffffff80269eda>] do_page_fault+0x35a/0x800
> [ 1663.057795] 
> [ 1663.057796] but task is already holding lock:
> [ 1663.057798]  (&data->latch){----}, at: [<ffffffff8036a835>] read_unix_file+0x95/0x450
> [ 1663.057806] 
> [ 1663.057807] which lock already depends on the new lock.
> [ 1663.057808] 
> [ 1663.057809] 
> [ 1663.057810] the existing dependency chain (in reverse order) is:
> [ 1663.057812] 
> [ 1663.057813] -> #1 (&data->latch){----}:
> [ 1663.057816]        [<ffffffff802ae4c1>] __lock_acquire+0xd61/0x1010
> [ 1663.057823]        [<ffffffff802ae7b9>] lock_acquire+0x49/0x70
> [ 1663.057829]        [<ffffffff8036c721>] get_exclusive_access+0x11/0x20
> [ 1663.057836]        [<ffffffff802a8c9f>] down_write+0x2f/0x40
> [ 1663.057843]        [<ffffffff8036c721>] get_exclusive_access+0x11/0x20
> [ 1663.057849]        [<ffffffff8036ac50>] mmap_unix_file+0x60/0x140
> [ 1663.057855]        [<ffffffff8020dbf7>] do_mmap_pgoff+0x4f7/0x800
> [ 1663.057862]        [<ffffffff802acfd6>] mark_held_locks+0x76/0xa0
> [ 1663.057868]        [<ffffffff80267754>] _spin_unlock_irq+0x24/0x50
> [ 1663.057873]        [<ffffffff8026775f>] _spin_unlock_irq+0x2f/0x50
> [ 1663.057879]        [<ffffffff80234db3>] elf_map+0xa3/0x100
> [ 1663.057886]        [<ffffffff80217de2>] load_elf_binary+0x902/0x1c30
> [ 1663.057893]        [<ffffffff8028de20>] load_aout_binary+0x0/0x960
> [ 1663.057899]        [<ffffffff802174e0>] load_elf_binary+0x0/0x1c30
> [ 1663.057905]        [<ffffffff802406b3>] search_binary_handler+0xf3/0x2b0
> [ 1663.057912]        [<ffffffff8024f322>] load_script+0x212/0x240
> [ 1663.057919]        [<ffffffff802174e0>] load_elf_binary+0x0/0x1c30
> [ 1663.057925]        [<ffffffff8024f110>] load_script+0x0/0x240
> [ 1663.057930]        [<ffffffff802406b3>] search_binary_handler+0xf3/0x2b0
> [ 1663.057936]        [<ffffffff8023f9f8>] do_execve+0x188/0x250
> [ 1663.057942]        [<ffffffff802a1a10>] __call_usermodehelper+0x0/0x80
> [ 1663.057950]        [<ffffffff80255034>] sys_execve+0x44/0x70
> [ 1663.057956]        [<ffffffff80260044>] kernel_execve+0x64/0xd0
> [ 1663.057963]        [<ffffffff802a1a10>] __call_usermodehelper+0x0/0x80
> [ 1663.057969]        [<ffffffff802a1e0b>] ____call_usermodehelper+0x15b/0x170
> [ 1663.057975]        [<ffffffff8025ffd8>] child_rip+0xa/0x12
> [ 1663.057981]        [<ffffffff80267754>] _spin_unlock_irq+0x24/0x50
> [ 1663.057987]        [<ffffffff8025f6c0>] restore_args+0x0/0x30
> [ 1663.057993]        [<ffffffff802a1cb0>] ____call_usermodehelper+0x0/0x170
> [ 1663.057999]        [<ffffffff8025ffce>] child_rip+0x0/0x12
> [ 1663.058004]        [<ffffffffffffffff>] 0xffffffffffffffff
> [ 1663.058042] 
> [ 1663.058043] -> #0 (&mm->mmap_sem){----}:
> [ 1663.058045]        [<ffffffff802ac62b>] print_circular_bug_header+0xdb/0x100
> [ 1663.058051]        [<ffffffff802ae390>] __lock_acquire+0xc30/0x1010
> [ 1663.058057]        [<ffffffff802ae7b9>] lock_acquire+0x49/0x70
> [ 1663.058062]        [<ffffffff80269eda>] do_page_fault+0x35a/0x800
> [ 1663.058068]        [<ffffffff802a8bc2>] down_read+0x32/0x40
> [ 1663.058074]        [<ffffffff80269eda>] do_page_fault+0x35a/0x800
> [ 1663.058080]        [<ffffffff80264207>] thread_return+0xef/0x148
> [ 1663.058088]        [<ffffffff802676fd>] _spin_unlock_irqrestore+0x3d/0x70
> [ 1663.058094]        [<ffffffff80267d2d>] error_exit+0x0/0x96
> [ 1663.058100]        [<ffffffff8020ccbf>] file_read_actor+0x6f/0x190
> [ 1663.058105]        [<ffffffff80240a6f>] __lock_page+0x5f/0x70
> [ 1663.058111]        [<ffffffff8020bcd7>] do_generic_mapping_read+0x1f7/0x500
> [ 1663.058117]        [<ffffffff8020cc50>] file_read_actor+0x0/0x190
> [ 1663.058123]        [<ffffffff802162ca>] generic_file_aio_read+0x19a/0x1f0
> [ 1663.058129]        [<ffffffff8020c91f>] do_sync_read+0xcf/0x120
> [ 1663.058135]        [<ffffffff802a61f0>] autoremove_wake_function+0x0/0x30
> [ 1663.058141]        [<ffffffff802675f9>] _spin_unlock+0x29/0x50
> [ 1663.058146]        [<ffffffff8034f6fe>] reiser4_grab+0xae/0xd0
> [ 1663.058155]        [<ffffffff8036a879>] read_unix_file+0xd9/0x450
> [ 1663.058161]        [<ffffffff8020acea>] vfs_read+0xba/0x180
> [ 1663.058166]        [<ffffffff80212b2e>] sys_pread64+0x5e/0x90
> [ 1663.058172]        [<ffffffff8025f11e>] system_call+0x7e/0x83
> [ 1663.058178]        [<ffffffffffffffff>] 0xffffffffffffffff
> [ 1663.058184] 
> [ 1663.058185] other info that might help us debug this:
> [ 1663.058186] 
> [ 1663.058188] 1 lock held by evolution-data-/58416:
> [ 1663.058190]  #0:  (&data->latch){----}, at: [<ffffffff8036a835>] read_unix_file+0x95/0x450
> [ 1663.058196] 
> [ 1663.058196] stack backtrace:
> [ 1663.058198] 
> [ 1663.058198] Call Trace:
> [ 1663.058204]  [<ffffffff802ac214>] print_circular_bug_tail+0x74/0x90
> [ 1663.058208]  [<ffffffff802ac62b>] print_circular_bug_header+0xdb/0x100
> [ 1663.058211]  [<ffffffff802ae390>] __lock_acquire+0xc30/0x1010
> [ 1663.058216]  [<ffffffff802ae7b9>] lock_acquire+0x49/0x70
> [ 1663.058219]  [<ffffffff80269eda>] do_page_fault+0x35a/0x800
> [ 1663.058223]  [<ffffffff802a8bc2>] down_read+0x32/0x40
> [ 1663.058226]  [<ffffffff80269eda>] do_page_fault+0x35a/0x800
> [ 1663.058232]  [<ffffffff80264207>] thread_return+0xef/0x148
> [ 1663.058236]  [<ffffffff802676fd>] _spin_unlock_irqrestore+0x3d/0x70
> [ 1663.058240]  [<ffffffff80267d2d>] error_exit+0x0/0x96
> [ 1663.058245]  [<ffffffff8020ccbf>] file_read_actor+0x6f/0x190
> [ 1663.058248]  [<ffffffff80240a6f>] __lock_page+0x5f/0x70
> [ 1663.058253]  [<ffffffff8020bcd7>] do_generic_mapping_read+0x1f7/0x500
> [ 1663.058256]  [<ffffffff8020cc50>] file_read_actor+0x0/0x190
> [ 1663.058263]  [<ffffffff802162ca>] generic_file_aio_read+0x19a/0x1f0
> [ 1663.058267]  [<ffffffff8020c91f>] do_sync_read+0xcf/0x120
> [ 1663.058272]  [<ffffffff802a61f0>] autoremove_wake_function+0x0/0x30
> [ 1663.058276]  [<ffffffff802675f9>] _spin_unlock+0x29/0x50
> [ 1663.058280]  [<ffffffff8034f6fe>] reiser4_grab+0xae/0xd0
> [ 1663.058284]  [<ffffffff8036a879>] read_unix_file+0xd9/0x450
> [ 1663.058290]  [<ffffffff8020acea>] vfs_read+0xba/0x180
> [ 1663.058294]  [<ffffffff80212b2e>] sys_pread64+0x5e/0x90
> [ 1663.058298]  [<ffffffff8025f11e>] system_call+0x7e/0x83
> [ 1663.058301] 
> [ 1714.279224] process `rndc' is using obsolete setsockopt SO_BSDCOMPAT
> [ 1717.959422] eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1
> [ 1721.544091] process `named' is using obsolete setsockopt SO_BSDCOMPAT
> [ 1725.344372] eth0: no IPv6 routers present
> 

