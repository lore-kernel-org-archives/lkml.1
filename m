Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYDWKaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYDWKaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYDWKa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:30:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:60007 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755476AbYDWKaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:30:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fZht1T38fUuFnlhkMdpJxgA3a/WuNxqYQR/uRyh
	Ac58FSa5GSEIDU
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1208938303.4905.23.camel@marge.simson.net>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <1208854300.4695.7.camel@marge.simson.net>  <20080422085905.GA9939@elte.hu>
	 <1208867154.4873.4.camel@marge.simson.net>
	 <1208938303.4905.23.camel@marge.simson.net>
Content-Type: text/plain; charset=US-ASCII
Date: Wed, 23 Apr 2008 12:30:04 +0200
Message-Id: <1208946604.4803.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 10:11 +0200, Mike Galbraith wrote:

> I dug my old p3/500 out and hooked it up since I still can't get minicom
> functional plugging P4->Q6600, but no joy.  Whatever the heck is going
> wrong in sched-devel is so catastrophic that not one character hits the
> console when it locks, and nmi_watchdog=1 does nada.

I built x86/latest to see if it locked, and while testing to see if
minicom was really really working properly on p3/500, I created an
explosion.  I see in the log that clockevents griped during boot, and
when I later poked SysRq-W, box blew to pieces.

[    0.000000] Linux version 2.6.26-devel-smp (root@marge) (gcc version 4.2.1 (SUSE Linux)) #1 SMP Wed Apr 23 11:16:47 CEST 2008
[    0.000000] Command line: root=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part3 vga=0x314 resume=/dev/sdb2 splash=silent console=ttyS0,115200n8 console=tty nmi_watchdog=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe90000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe90000 - 00000000bfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86: PAT support disabled.
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F7F20, 0014 (r0 MEDION)
[    0.000000] ACPI: RSDT BFEE3000, 003C (r1 MEDION MEDIONAG 42302E31 AWRD        0)
[    0.000000] ACPI: FACP BFEE3080, 0074 (r1 MEDION MEDIONAG 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT BFEE3100, 4243 (r1 MEDION AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS BFE90000, 0040
[    0.000000] ACPI: HPET BFEE75C0, 0038 (r1 MEDION MEDIONAG 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG BFEE7600, 003C (r1 MEDION MEDIONAG 42302E31 AWRD        0)
[    0.000000] ACPI: SLIC BFEE7380, 0176 (r1 MEDION MEDIONAG 42302E31 AWRD        0)
[    0.000000] ACPI: APIC BFEE7500, 0084 (r1 MEDION MEDIONAG 42302E31 AWRD        0)
[    0.000000] ACPI: SSDT BFEE7F60, 0380 (r1  PmRef    CpuPm     3000 INTL 20041203)
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-635ad7] TEXT DATA BSS
[    0.000000]   early res: 3 [377b6000-37fefb91] RAMDISK
[    0.000000]   early res: 4 [9e400-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-cfff] PGTABLE
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   786064
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: bff00000:20100000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34416 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774036
[    0.000000] Kernel command line: root=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part3 vga=0x314 resume=/dev/sdb2 splash=silent console=ttyS0,115200n8 console=tty nmi_watchdog=1
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000024] time.c: Detected 2392.499 MHz processor.
[    0.000044] Console: colour dummy device 80x25
[    0.000046] console [tty0] enabled
[    0.000211] console [ttyS0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Memory: 3080928k/3144256k available (2127k kernel code, 62260k reserved, 1290k data, 252k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[    0.080008] Calibrating delay using timer specific routine.. 4789.42 BogoMIPS (lpj=9578842)
[    0.088027] Security Framework initialized
[    0.092012] Capability LSM initialized
[    0.096014] Mount-cache hash table entries: 256
[    0.100136] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.104009] CPU: L2 cache: 4096K
[    0.108010] CPU: Physical Processor ID: 0
[    0.112009] CPU: Processor Core ID: 0
[    0.116014] CPU0: Thermal monitoring enabled (TM2)
[    0.120009] using mwait in idle threads.
[    0.124024] ACPI: Core revision 20070126
[    0.178436] activating NMI Watchdog ... done.
[    0.180012] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.189243] Using local APIC timer interrupts.
[    0.196014] Detected 16.614 MHz APIC timer.
[    0.200013] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.208105] Booting processor 1/3 ip 6000
[    0.208105] Initializing CPU#1
[    0.208105] Calibrating delay using timer specific routine.. 4784.99 BogoMIPS (lpj=9569994)
[    0.208105] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.208105] CPU: L2 cache: 4096K
[    0.208105] CPU: Physical Processor ID: 0
[    0.208105] CPU: Processor Core ID: 3
[    0.208105] CPU1: Thermal monitoring enabled (TM2)
[    0.208105] x86: PAT support disabled.
[    0.300971] CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.309273] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.312089] Booting processor 2/2 ip 6000
[    0.312089] Initializing CPU#2
[    0.312089] Calibrating delay using timer specific routine.. 4785.09 BogoMIPS (lpj=9570192)
[    0.312089] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.312089] CPU: L2 cache: 4096K
[    0.312089] CPU: Physical Processor ID: 0
[    0.312089] CPU: Processor Core ID: 2
[    0.312089] CPU2: Thermal monitoring enabled (TM2)
[    0.312089] x86: PAT support disabled.
[    0.409007] CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.417280] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.420101] Booting processor 3/1 ip 6000
[    0.420101] Initializing CPU#3
[    0.420101] Calibrating delay using timer specific routine.. 4785.04 BogoMIPS (lpj=9570084)
[    0.420101] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.420101] CPU: L2 cache: 4096K
[    0.420101] CPU: Physical Processor ID: 0
[    0.420101] CPU: Processor Core ID: 1
[    0.420101] CPU3: Thermal monitoring enabled (TM2)
[    0.420101] x86: PAT support disabled.
[    0.517027] CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.525296] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.528062] Brought up 4 CPUs
[    0.532041] Total of 4 processors activated (19144.55 BogoMIPS).
[    0.536083] Testing NMI watchdog ... OK.
[    0.623441] net_namespace: 1224 bytes
[    0.624162] NET: Registered protocol family 16
[    0.628278] ACPI: bus type pci registered
[    0.636057] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.640041] PCI: MCFG area at e0000000 reserved in E820
[    0.656641] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.660042] PCI: Using configuration type 1 for base access
[    0.674759] ACPI: Interpreter enabled
[    0.676043] ACPI: (supports S0 S3 S4 S5)
[    0.681162] ACPI: Using IOAPIC for interrupt routing
[    0.693485] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.696951] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.700046] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.708493] PCI: Transparent bridge - 0000:00:1e.0
[    0.729092] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.736333] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.744333] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.752143] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.758842] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.766642] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.774094] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 *7 9 10 11 12 14 15)
[    0.781262] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.788847] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.792100] pnp: PnP ACPI init
[    0.796055] ACPI: bus type pnp registered
[    0.804714] pnp: PnP ACPI: found 13 devices
[    0.808052] ACPI: ACPI bus type pnp unregistered
[    0.812479] PCI: Using ACPI for IRQ routing
[    0.832060] DMAR:parse DMAR table failure.
[    0.836069] PCI-GART: No AMD northbridge found.
[    0.840057] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.845258] hpet0: 4 64-bit timers, 14318180 Hz
[    0.849187] ACPI: RTC can wake from S4
[    0.852054] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
[    0.852054]  lapic is not functional.
[    0.852054]  lapic is not functional.
[    0.852054] Could not switch to high resolution mode on CPU 3
[    0.852060] Could not switch to high resolution mode on CPU 1
[    0.852060] Could not switch to high resolution mode on CPU 2
[    0.856053]  lapic is not functional.
[    0.860054] Could not switch to high resolution mode on CPU 0
[    0.880070] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.884057] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.892057] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.896062] system 00:09: ioport range 0x400-0x4bf could not be reserved
[    0.904063] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.908061] system 00:0c: iomem range 0xf0000-0xfffff could not be reserved
[    0.916059] system 00:0c: iomem range 0xbff00000-0xbfffffff has been reserved
[    0.920059] system 00:0c: iomem range 0xfed00000-0xfed000ff could not be reserved
[    0.924059] system 00:0c: iomem range 0xbfe90000-0xbfefffff could not be reserved
[    0.932060] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.936060] system 00:0c: iomem range 0x100000-0xbfe8ffff could not be reserved
[    0.944061] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.948061] system 00:0c: iomem range 0xfed14000-0xfed1dfff could not be reserved
[    0.956062] system 00:0c: iomem range 0xfed20000-0xfed9ffff could not be reserved
[    0.960061] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.968062] system 00:0c: iomem range 0xffb00000-0xffb7ffff could not be reserved
[    0.972062] system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.980068] system 00:0c: iomem range 0xe0000-0xeffff has been reserved
[    0.988528] PCI: Bridge: 0000:00:01.0
[    0.992064]   IO window: d000-dfff
[    0.995464]   MEM window: 0xf8000000-0xfbffffff
[    1.000070]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    1.004066] PCI: Bridge: 0000:00:1e.0
[    1.008065]   IO window: c000-cfff
[    1.012073]   MEM window: 0xfdd00000-0xfddfffff
[    1.016066]   PREFETCH window: 0x00000000fde00000-0x00000000fdefffff
[    1.020076] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.026795] NET: Registered protocol family 2
[    1.076123] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.080416] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.093051] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.100350] TCP: Hash tables configured (established 262144 bind 65536)
[    1.104070] TCP reno registered
[    1.124296] Unpacking initramfs... done
[    1.424091] Freeing initrd memory: 8422k freed
[    1.497541] audit: initializing netlink socket (disabled)
[    1.500094] type=2000 audit(1208951666.504:1): initialized
[    1.508436] Total HugeTLB memory allocated, 0
[    1.512232] VFS: Disk quotas dquot_6.5.1
[    1.516097] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.520213] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.524080] io scheduler noop registered
[    1.528079] io scheduler anticipatory registered
[    1.532079] io scheduler deadline registered
[    1.536082] io scheduler cfq registered (default)
[    1.540365] assign_interrupt_mode Found MSI capability
[    1.544536] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc20010100000, using 1875k, total 14336k
[    1.548081] vesafb: mode is 800x600x16, linelength=1600, pages=2
[    1.556086] vesafb: scrolling: redraw
[    1.560082] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.575054] Console: switching to colour frame buffer device 100x37
[    1.588090] fb0: VESA VGA frame buffer device
[    1.601534] Real Time Clock Driver v1.12ac
[    1.604382] Non-volatile memory driver v1.2
[    1.608085] Linux agpgart interface v0.103
[    1.612086] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.616235] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.620230] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.628719] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.632311] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.640436] PNP: No PS/2 controller found. Probing ports directly.
[    1.672619] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.676100] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.684289] mice: PS/2 mouse device common for all mice
[    2.018307] cpuidle: using governor ladder
[    2.024236] NET: Registered protocol family 1
[    2.028346] registered taskstats version 1
[    2.036223] Freeing unused kernel memory: 252k freed
[    2.040194] Write protecting the kernel read-only data: 3196k
[    2.048243] Testing CPA: undo ffffffff80418000-ffffffff80528000
[    2.052145] Testing CPA: again
[    2.072799] ACPI: SSDT BFEE7680, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
[    2.078935] ACPI: ACPI0007:00 is registered as cooling_device0
[    2.084314] ACPI: SSDT BFEE7B40, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
[    2.096289] ACPI: ACPI0007:01 is registered as cooling_device1
[    2.100310] ACPI: SSDT BFEE7CA0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20041203)
[    2.112280] ACPI: ACPI0007:02 is registered as cooling_device2
[    2.116304] ACPI: SSDT BFEE7E00, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20041203)
[    2.128280] ACPI: ACPI0007:03 is registered as cooling_device3
[    2.128280] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    2.133543] ACPI: Thermal Zone [THRM] (22 C)
[    2.143590] No dock devices found.
[    2.158424] SCSI subsystem initialized
[    2.173825] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[    3.185594] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    3.189557] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part 
[    3.197842] scsi0 : ahci
[    3.205635] scsi1 : ahci
[    3.209618] scsi2 : ahci
[    3.217624] scsi3 : ahci
[    3.221617] scsi4 : ahci
[    3.225617] scsi5 : ahci
[    3.229657] ata1: SATA max UDMA/133 irq 382
[    3.233561] ata2: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
[    3.241566] ata3: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc200 irq 382
[    3.249567] ata4: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc280 irq 382
[    3.253561] ata5: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
[    3.261567] ata6: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc380 irq 382
[    4.216257] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.235409] ata1.00: ATA-8: WDC WD5000AACS-00ZUB0, 01.01B01, max UDMA/133
[    4.236249] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.244953] ata1.00: configured for UDMA/133
[    5.184327] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.204381] ata2.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00, max UDMA/100
[    5.204381] ata2.00: configured for UDMA/100
[    5.536351] ata3: SATA link down (SStatus 0 SControl 300)
[    5.868371] ata4: SATA link down (SStatus 0 SControl 300)
[    6.764424] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.834051] ata5.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
[    6.836422] ata5.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.879377] ata5.00: configured for UDMA/133
[    7.204455] ata6: SATA link down (SStatus 0 SControl 300)
[    7.211874] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AACS-0 01.0 PQ: 0 ANSI: 5
[    7.223089] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH20NS10  EL00 PQ: 0 ANSI: 5
[    7.228593] scsi 4:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
[    7.228593] ACPI: PNP0C0B:00 is registered as cooling_device4
[    7.228671] ACPI: Fan [FAN] (on)
[    7.252148] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    7.390803] Driver 'sd' needs updating - please use bus_type methods
[    7.409606] usbcore: registered new interface driver usbfs
[    7.409631] usbcore: registered new interface driver hub
[    7.428664] usbcore: registered new device driver usb
[    7.428664] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    7.428676] sd 0:0:0:0: [sda] Write Protect is off
[    7.428695] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.428763] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    7.428782] sd 0:0:0:0: [sda] Write Protect is off
[    7.428807] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.428809]  sda: sda1 sda2 <<6>USB Universal Host Controller Interface driver v3.0
[    7.448525] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    7.460495] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.531220]  sda5<6>uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.531220] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fe00
[    7.531324] usb usb1: configuration #1 chosen from 1 choice
[    7.531344] hub 1-0:1.0: USB hub found
[    7.531348] hub 1-0:1.0: 2 ports detected
[    7.536455]  >
[    7.540560] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.548531] sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
[    7.556477] sd 4:0:0:0: [sdb] Write Protect is off
[    7.560475] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.568511] sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
[    7.631069] sd 4:0:0:0: [sdb] Write Protect is off
[    7.639092] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.647052]  sdb: sdb1 sdb2 sdb3
[    7.652564] sd 4:0:0:0: [sdb] Attached SCSI disk
[    7.679105] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    7.679107] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.679109] usb usb1: Product: UHCI Host Controller
[    7.679110] usb usb1: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    7.679112] usb usb1: SerialNumber: 0000:00:1a.0
[    7.699072] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[    7.699084] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.699106] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    7.699143] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fd00
[    7.699224] usb usb2: configuration #1 chosen from 1 choice
[    7.699241] hub 2-0:1.0: USB hub found
[    7.699245] hub 2-0:1.0: 2 ports detected
[    7.803154] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.807070] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.811109] usb usb2: Product: UHCI Host Controller
[    7.815078] usb usb2: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    7.823072] usb usb2: SerialNumber: 0000:00:1a.1
[    7.827109] ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19 (level, low) -> IRQ 19
[    7.839066] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    7.847100] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    7.851099] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fc00
[    7.859103] usb usb3: configuration #1 chosen from 1 choice
[    7.863078] hub 3-0:1.0: USB hub found
[    7.871077] hub 3-0:1.0: 2 ports detected
[    7.888486] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    7.983138] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.991067] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.999072] usb usb3: Product: UHCI Host Controller
[    8.003067] usb usb3: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    8.011068] usb usb3: SerialNumber: 0000:00:1a.2
[    8.015102] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    8.027082] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.031087] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    8.039098] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fb00
[    8.047154] usb usb4: configuration #1 chosen from 1 choice
[    8.055090] hub 4-0:1.0: USB hub found
[    8.059079] hub 4-0:1.0: 2 ports detected
[    8.147551] usb 1-1: configuration #1 chosen from 1 choice
[    8.158560] usb 1-1: New USB device found, idVendor=0424, idProduct=2228
[    8.164501] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.172499] usb 1-1: Product: Flash Card Reader
[    8.176494] usb 1-1: Manufacturer: Generic
[    8.184495] usb 1-1: SerialNumber: 000022272228
[    8.184495] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.184498] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.184499] usb usb4: Product: UHCI Host Controller
[    8.184501] usb usb4: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    8.184502] usb usb4: SerialNumber: 0000:00:1d.0
[    8.184526] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    8.184534] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.184552] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    8.184573] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fa00
[    8.184653] usb usb5: configuration #1 chosen from 1 choice
[    8.184670] hub 5-0:1.0: USB hub found
[    8.184675] hub 5-0:1.0: 2 ports detected
[    8.372521] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    8.380457] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.388457] usb usb5: Product: UHCI Host Controller
[    8.392457] usb usb5: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    8.400457] usb usb5: SerialNumber: 0000:00:1d.1
[    8.404488] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    8.416476] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    8.420480] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    8.432861] ehci_hcd 0000:00:1a.7: debug port 1
[    8.440477] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdffe000
[    8.440477] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    8.504468] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.508544] usb usb6: configuration #1 chosen from 1 choice
[    8.516487] hub 6-0:1.0: USB hub found
[    8.520500] hub 6-0:1.0: 6 ports detected
[    8.632544] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    8.640473] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.644473] usb usb6: Product: EHCI Host Controller
[    8.652473] usb usb6: Manufacturer: Linux 2.6.26-devel-smp ehci_hcd
[    8.656473] usb usb6: SerialNumber: 0000:00:1a.7
[    8.664493] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    8.676486] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.680493] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    8.688498] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f900
[    8.692553] usb usb7: configuration #1 chosen from 1 choice
[    8.704515] hub 7-0:1.0: USB hub found
[    8.708481] hub 7-0:1.0: 2 ports detected
[    8.800586] usb 1-1: USB disconnect, address 2
[    8.820546] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    8.828485] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.836485] usb usb7: Product: UHCI Host Controller
[    8.840485] usb usb7: Manufacturer: Linux 2.6.26-devel-smp uhci_hcd
[    8.848485] usb usb7: SerialNumber: 0000:00:1d.2
[    8.852524] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    8.864501] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    8.868507] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    8.881847] ehci_hcd 0000:00:1d.7: debug port 1
[    8.888502] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffd000
[    8.908494] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.916559] usb usb8: configuration #1 chosen from 1 choice
[    8.920507] hub 8-0:1.0: USB hub found
[    8.928500] hub 8-0:1.0: 6 ports detected
[    9.036564] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    9.040498] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.048498] usb usb8: Product: EHCI Host Controller
[    9.056498] usb usb8: Manufacturer: Linux 2.6.26-devel-smp ehci_hcd
[    9.060498] usb usb8: SerialNumber: 0000:00:1d.7
[    9.176584] usb 6-1: new high speed USB device using ehci_hcd and address 2
[    9.176584] PM: Starting manual resume from disk
[    9.383090] usb 6-1: configuration #1 chosen from 1 choice
[    9.388816] usb 6-1: New USB device found, idVendor=0424, idProduct=2228
[    9.396535] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    9.400556] usb 6-1: Product: Flash Card Reader
[    9.408530] usb 6-1: Manufacturer: Generic
[    9.412542] usb 6-1: SerialNumber: 000022272228
[    9.840565] usb 6-5: new high speed USB device using ehci_hcd and address 4
[   10.042076] usb 6-5: configuration #1 chosen from 1 choice
[   10.052739] usb 6-5: New USB device found, idVendor=13d3, idProduct=3247
[   10.056682] usb 6-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   10.060648] usb 6-5: Product: 802.11 n WLAN
[   10.064650] usb 6-5: Manufacturer: Ralink
[   10.072627] usb 6-5: SerialNumber: 1.0
[   10.504661] usb 2-1: new low speed USB device using uhci_hcd and address 3
[   10.700922] usb 2-1: configuration #1 chosen from 1 choice
[   10.700922] usb 2-1: New USB device found, idVendor=04ca, idProduct=002b
[   10.704612] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.712613] usb 2-1: Product: Wireless keyboard and mouse
[   10.720608] usb 2-1: Manufacturer: Liteon
[   10.964632] usb 3-2: new low speed USB device using uhci_hcd and address 2
[   11.152188] usb 3-2: configuration #1 chosen from 1 choice
[   11.157828] usb 3-2: New USB device found, idVendor=0bc7, idProduct=0006
[   11.160687] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.168642] usb 3-2: Product: RF receiver
[   11.176636] usb 3-2: Manufacturer: X10 WTI
[   11.195071] usbcore: registered new interface driver hiddev
[   11.216528] input: Liteon Wireless keyboard and mouse as /class/input/input0
[   11.251059] input: USB HID v1.11 Keyboard [Liteon Wireless keyboard and mouse] on usb-0000:00:1a.1-1
[   11.266265] input: Liteon Wireless keyboard and mouse as /class/input/input1
[   11.320673] input: USB HID v1.11 Mouse [Liteon Wireless keyboard and mouse] on usb-0000:00:1a.1-1
[   11.328672] usbcore: registered new interface driver usbhid
[   11.332647] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   31.633980] CPA self-test:
[   31.642105]  4k 69120 large 1913 gb 0 x 0[0-0] miss 0
[   31.654984]  4k 262656 large 1535 gb 0 x 0[0-0] miss 0
[   31.670379]  4k 262656 large 1535 gb 0 x 0[0-0] miss 0
[   31.677982] ok.
[   73.025120] kjournald starting.  Commit interval 5 seconds
[   73.029070] EXT3 FS on sdb3, internal journal
[   73.036786] EXT3-fs: mounted filesystem with writeback data mode.
[   75.147293] iTCO_vendor_support: vendor-support=0
[   75.202142] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   75.208740] iTCO_wdt: Found a ICH9DH TCO device (Version=2, TCOBASE=0x0460)
[   75.212683] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   75.373078] input: Power Button (FF) as /class/input/input2
[   75.373078] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   75.375250] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   75.383225] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   75.449466] Driver 'sr' needs updating - please use bus_type methods
[   75.449466] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 18 (level, low) -> IRQ 18
[   75.464971] ACPI: Power Button (FF) [PWRF]
[   75.465024] input: Power Button (CM) as /class/input/input3
[   75.466570] sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[   75.466573] Uniform CD-ROM driver Revision: 3.20
[   75.565025] ACPI: Power Button (CM) [PWRB]
[   75.696133] rtc_cmos: probe of 00:04 failed with error -16
[   75.696133] Initializing USB Mass Storage driver...
[   75.700338] scsi6 : SCSI emulation for USB Mass Storage devices
[   75.704486] usbcore: registered new interface driver usb-storage
[   75.711940] USB Mass Storage support registered.
[   75.718080] ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 18
[   75.782231] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fddfe000-fddfe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   75.782231] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   75.788980] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   75.797039] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[   75.895047] eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:92:6c:2e:10
[   75.900988] eth0: Intel(R) PRO/10/100 Network Connection
[   75.905026] eth0: MAC: 5, PHY: 7, PBA No: ffffff-0ff
[   76.208104] Linux video capture interface: v2.00
[   76.547009] saa7130/34: v4l2 driver version 0.2.14 loaded
[   76.552054] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   76.560006] saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 84, mmio: 0xfddff000
[   76.564054] saa7133[0]: subsystem: 16be:000d, board: Medion Md8800 Quadro [card=96,autodetected]
[   76.572017] saa7133[0]: board init: gpio is 0
[   76.688729] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   76.735137] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   76.744015] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   76.756009] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
[   76.768010] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
[   76.780011] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
[   76.784014] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
[   76.784018] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784022] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784026] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784030] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784034] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784037] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784041] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784045] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784049] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784053] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.784057] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.020029] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[   77.108034] tda8290 1-004b: setting tuner address to 60
[   77.180041] tda8290 1-004b: type set to tda8290+75a
[   80.643607] isa bounce pool size: 16 pages
[   80.649422] scsi 6:0:0:0: Direct-Access     Generic  Flash HS-CF      5.14 PQ: 0 ANSI: 0
[   80.659295] scsi 6:0:0:1: Direct-Access     Generic  Flash HS-MS/SD   5.14 PQ: 0 ANSI: 0
[   80.665294] scsi 6:0:0:2: Direct-Access     Generic  Flash HS-SM      5.14 PQ: 0 ANSI: 0
[   80.676193] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   80.677326] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   80.694143] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[   80.697346] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   80.711217] sd 6:0:0:2: [sde] Attached SCSI removable disk
[   80.713348] sd 6:0:0:2: Attached scsi generic sg5 type 0
[   81.028556] saa7133[0]: registered device video0 [v4l2]
[   81.032293] saa7133[0]: registered device vbi0
[   81.245354] DVB: registering new adapter (saa7133[0])
[   81.249347] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   81.349333] tda1004x: setting up plls for 48MHz sampling clock
[   83.345458] tda1004x: found firmware revision 26 -- ok
[   83.863379] Adding 2104504k swap on /dev/sdb2.  Priority:-1 extents:1 across:2104504k
[   83.981575] device-mapper: uevent: version 1.0.3
[   83.981873] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   84.487893] loop: module loaded
[   84.487893] kjournald starting.  Commit interval 5 seconds
[   84.531876] EXT3 FS on sdb1, internal journal
[   84.537770] EXT3-fs: mounted filesystem with writeback data mode.
[   84.797612] fuse init (API version 7.9)
[   89.631966] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   90.203890] NET: Registered protocol family 10
[   90.210199] lo: Disabled Privacy Extensions
[   90.768140] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   91.389759] ip_tables: (C) 2000-2006 Netfilter Core Team
[   91.762982] sysdev: class cpu: driver (ffffffff8054cab0) has already been registered to a class, something is wrong, but will forge on!
[   91.763475] ------------[ cut here ]------------
[   91.767449] WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12c()
[   91.771452] Modules linked in: acpi_cpufreq(+) ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 snd_pcm compat_ioctl32 firewire_ohci videodev v4l1_compat firewire_core snd_timer snd_page_alloc crc_itu_t v4l2_common snd_hwdep videobuf_dma_sg snd videobuf_core e1000e ir_kbd_i2c ohci1394 usb_storage rtc_cmos ir_common tveeprom ieee1394 rtc_core i2c_i801 sr_mod sg button i2c_core iTCO_wdt cdrom serio_raw iTCO_vendor_support rtc_lib intel_agp soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[   91.834870] Pid: 3033, comm: modprobe Not tainted 2.6.26-devel-smp #1
[   91.834871] 
[   91.834872] Call Trace:
[   91.834896]  [<ffffffff802352f3>] warn_on_slowpath+0x58/0x6b
[   91.834914]  [<ffffffff8023610a>] ? printk+0x67/0x69
[   91.834930]  [<ffffffff80229b2f>] ? need_resched+0x1e/0x28
[   91.834951]  [<ffffffffa0003974>] ? :processor:acpi_processor_preregister_performance+0x424/0x438
[   91.834968]  [<ffffffff803713ef>] sysdev_driver_register+0x75/0x12c
[   91.834982]  [<ffffffff803936d3>] cpufreq_register_driver+0x95/0x12c
[   91.834991]  [<ffffffffa014603f>] :acpi_cpufreq:acpi_cpufreq_init+0x3f/0x41
[   91.834999]  [<ffffffff80256cbb>] sys_init_module+0x1914/0x1a4a
[   91.835053]  [<ffffffff80290d9e>] ? vfs_read+0xa8/0x102
[   91.835077]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
[   91.835097] 
[   91.835098] ---[ end trace 728898a466de31f0 ]---
[   92.038552] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   93.864294] mm/memory.c:127: bad pmd ffff810000207810(9090909090909090).
[  100.255797] SysRq : Changing Loglevel
[  100.257477] Loglevel set to 9
[  100.496439] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[  100.500106] eth0: 10/100 speed: disabling TSO
[  100.509077] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  110.856754] eth0: no IPv6 routers present
[  114.395564] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[  120.454136] ISO 9660 Extensions: Microsoft Joliet Level 3
[  120.567245] ISOFS: changing to secondary root


Welcome to openSUSE 10.3 (X86-64) - Kernel 2.6.26-devel-smp (ttyS0).


marge login: [  122.185533] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.178.27 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  127.958172] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:1a:4f:7b:e8:48:08:00 SRC=192.168.178.1 DST=224.0.0.1 LEN=36 TOS=0x00 PREC=0xC0 TTL=1 ID=6286 DF OPT (94040000) PROTO=2 
[  129.743631] CPU0 attaching NULL sched-domain.
[  129.747325] CPU1 attaching NULL sched-domain.
[  129.751322] CPU2 attaching NULL sched-domain.
[  129.755342] CPU3 attaching NULL sched-domain.
[  129.783336] CPU0 attaching sched-domain:
[  129.787259]  domain 0: span 0,3
[  129.788210]   groups: 0 3
[  129.791897]   domain 1: span 0-3
[  129.796221]    groups: 0,3 1-2
[  129.799325] CPU1 attaching sched-domain:
[  129.803326]  domain 0: span 1-2
[  129.806485]   groups: 1 2
[  129.807904]   domain 1: span 0-3
[  129.812211]    groups: 1-2 0,3
[  129.815519] CPU2 attaching sched-domain:
[  129.819326]  domain 0: span 1-2
[  129.822483]   groups: 2 1
[  129.823898]   domain 1: span 0-3
[  129.828212]    groups: 1-2 0,3
[  129.831514] CPU3 attaching sched-domain:
[  129.835327]  domain 0: span 0,3
[  129.838483]   groups: 3 0
[  129.839900]   domain 1: span 0-3
[  129.844237]    groups: 0,3 1-2
[  138.265205] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.178.27 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  170.204540] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.178.27 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  234.085913] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.178.27 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  252.921917] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:1a:4f:7b:e8:48:08:00 SRC=192.168.178.1 DST=224.0.0.1 LEN=36 TOS=0x00 PREC=0xC0 TTL=1 ID=6287 DF OPT (94040000) PROTO=2 
[  362.180544] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.178.27 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  377.941696] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:1a:4f:7b:e8:48:08:00 SRC=192.168.178.1 DST=224.0.0.1 LEN=36 TOS=0x00 PREC=0xC0 TTL=1 ID=6288 DF OPT (94040000) PROTO=2 
[  386.102698] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:64:94:34:08:00 SRC=192.168.178.24 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  502.937602] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:1a:4f:7b:e8:48:08:00 SRC=192.168.178.1 DST=224.0.0.1 LEN=36 TOS=0x00 PREC=0xC0 TTL=1 ID=6289 DF OPT (94040000) PROTO=2 
[  593.676912] SysRq : Changing Loglevel
[  593.680314] Loglevel set to 9
[  604.920361] SysRq : Show Blocked State
[  604.923629]   task                        PC stack   pid father
[  604.923629] Sched Debug Version: v0.07, 2.6.26-devel-smp #1
[  604.923629] now at 605377.269777 msecs
[  604.923629]   .sysctl_sched_latency                    : 60.000000
[  604.923629]   .sysctl_sched_min_granularity            : 12.000000
[  604.923629]   .sysctl_sched_wakeup_granularity         : 30.000000
[  604.923629]   .sysctl_sched_child_runs_first           : 0.000001
[  604.923629]   .sysctl_sched_features                   : 895
[  604.923629] 
[  604.923629] cpu#0, 2392.499 MHz
[  604.923629]   .nr_running                    : 4
[  604.923629]   .load                          : 4096
[  604.923629]   .nr_switches                   : 245586
[  604.923629]   .nr_load_updates               : 151127
[  604.923629]   .nr_uninterruptible            : -173
[  604.923629]   .jiffies                       : 4295043423
[  604.923629]   .next_balance                  : 4295.043442
[  604.923629]   .curr->pid                     : 18518
[  604.923629]   .clock                         : 604548.285525
[  604.923629]   .idle_clock                    : 0.000000
[  604.923629]   .prev_clock_raw                : 634856.937739
[  604.923629]   .clock_warps                   : 0
[  604.923629]   .clock_overflows               : 99857
[  604.923629]   .clock_underflows              : 85710
[  604.923629]   .clock_deep_idle_events        : 4
[  604.923629]   .clock_max_delta               : 4.000250
[  604.923629]   .cpu_load[0]                   : 3072
[  604.923629]   .cpu_load[1]                   : 2225
[  604.923629]   .cpu_load[2]                   : 1638
[  604.923629]   .cpu_load[3]                   : 1465
[  604.923629]   .cpu_load[4]                   : 1352
[  604.923629] 
[  604.923629] cfs_rq[0]:
[  604.923629]   .exec_clock                    : 220180.249248
[  604.923629]   .MIN_vruntime                  : 803205.099951
[  604.923629]   .min_vruntime                  : 803298.594055
[  604.923629]   .max_vruntime                  : 803238.652606
[  604.923629]   .spread                        : 33.552655
[  604.923629]   .spread0                       : 0.000000
[  604.923629]   .nr_running                    : 4
[  604.923629]   .load                          : 4096
[  604.923629]   .bkl_count                     : 1635
[  604.923629]   .nr_spread_over                : 37912
[  604.923629] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[  604.923629] IP: [<ffffffff802a93ac>] seq_printf+0x2e/0xa7
[  604.923629] PGD 7c1ae067 PUD 7c111067 PMD 0 
[  604.923629] Oops: 0000 [1] SMP 
[  604.923629] CPU 3 
[  604.923629] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat cpufreq_conservative cpufreq_userspace iptable_filter ip6table_mangle cpufreq_powersave nf_conntrack_ipv4 nf_conntrack acpi_cpufreq ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 snd_pcm compat_ioctl32 firewire_ohci videodev v4l1_compat firewire_core snd_timer snd_page_alloc crc_itu_t v4l2_common snd_hwdep videobuf_dma_sg snd videobuf_core e1000e ir_kbd_i2c ohci1394 usb_storage rtc_cmos ir_common tveeprom ieee1394 rtc_core i2c_i801 sr_mod sg button i2c_core iTCO_wdt cdrom serio_raw iTCO_vendor_support rtc_lib intel_agp soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[  604.923629] Pid: 18521, comm: cc1 Not tainted 2.6.26-devel-smp #1
[  604.923629] RIP: 0010:[<ffffffff802a93ac>]  [<ffffffff802a93ac>] seq_printf+0x2e/0xa7
[  604.923629] RSP: 0000:ffff8100bf8eb8f8  EFLAGS: 00010092
[  604.923629] RAX: ffffffff804daf07 RBX: 0000000000000000 RCX: ffff8100bf8eb7f8
[  604.923629] RDX: 0000000000001313 RSI: ffffffff804daf07 RDI: 0000000000000000
[  604.923629] RBP: ffff8100bf8eb9d8 R08: 0000000000000005 R09: 0000000000000000
[  604.923629] R10: 000000000000000a R11: 0000000000000000 R12: 00000000000000fa
[  604.923629] R13: 0000000000000000 R14: ffff810001022dc0 R15: 0000000000000009
[  604.923629] FS:  00002b3fc99fe6f0(0000) GS:ffff8100bf80e680(0000) knlGS:0000000000000000
[  604.923629] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  604.923629] CR2: 0000000000000018 CR3: 0000000076025000 CR4: 00000000000006e0
[  604.923629] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  604.923629] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  604.923629] Process cc1 (pid: 18521, threadinfo ffff81007446a000, task ffff81007443c000)
[  604.923629] Stack:  0000000000000005 0000000000000000 0000003000000018 ffff8100bf8eb9e8
[  604.923629]  ffff8100bf8eb928 0000000000000046 0000000000001313 ffff8100bf8eb7f8
[  604.923629]  0000000000000005 0000000000000000 0000000000000005 0000000000000000
[  604.923629] Call Trace:
[  604.923629]  <IRQ>  [<ffffffff8024c527>] ? clocksource_read+0x7/0x9
[  604.923629]  [<ffffffff8024c575>] ? __get_nsec_offset+0x10/0x39
[  604.923629]  [<ffffffff8022caa9>] ? print_cfs_rq+0x41b/0x42a
[  604.923629]  [<ffffffff8022d419>] sched_debug_show+0x961/0xd22
[  604.923629]  [<ffffffff802318db>] show_state_filter+0x86/0x96
[  604.923629]  [<ffffffff80361e88>] sysrq_handle_showstate_blocked+0xe/0x10
[  604.923629]  [<ffffffff80361de3>] __handle_sysrq+0x9e/0x135
[  604.923629]  [<ffffffff80362006>] handle_sysrq+0x20/0x22
[  604.923629]  [<ffffffff8035b8c9>] kbd_event+0x37f/0x610
[  604.923629]  [<ffffffff8037aaea>] input_pass_event+0x5f/0x84
[  604.923629]  [<ffffffff8037ba4f>] input_handle_event+0x39c/0x3c0
[  604.923629]  [<ffffffff8037c1f8>] input_event+0x64/0x7c
[  604.923629]  [<ffffffffa0104c8f>] :hid:hidinput_hid_event+0x295/0x2c8
[  604.923629]  [<ffffffff80229b0f>] ? test_ti_thread_flag+0x11/0x13
[  604.923629]  [<ffffffffa01014b4>] :hid:hid_process_event+0x2e/0x62
[  604.923629]  [<ffffffffa01020e7>] :hid:hid_input_report+0x283/0x2f4
[  604.923629]  [<ffffffffa010ad8e>] :usbhid:hid_irq_in+0x8c/0x175
[  604.923629]  [<ffffffff8022924d>] ? __wake_up_common+0x46/0x75
[  604.923629]  [<ffffffffa00bb807>] :usbcore:usb_hcd_giveback_urb+0x84/0xb7
[  604.923629]  [<ffffffffa00eca13>] :uhci_hcd:uhci_giveback_urb+0x109/0x19d
[  604.923630]  [<ffffffffa00ed146>] :uhci_hcd:uhci_scan_schedule+0x58a/0x83f
[  604.923630]  [<ffffffff8023dc49>] ? run_timer_softirq+0x107/0x1af
[  604.923630]  [<ffffffffa00eef6d>] :uhci_hcd:uhci_irq+0x11c/0x133
[  604.923630]  [<ffffffffa00bb3bd>] :usbcore:usb_hcd_irq+0x37/0x68
[  604.923630]  [<ffffffff80267fc5>] handle_IRQ_event+0x27/0x57
[  604.923630]  [<ffffffff802693df>] handle_fasteoi_irq+0x95/0xd0
[  604.923630]  [<ffffffff8020f0c8>] do_IRQ+0x60/0xb6
[  604.923630]  [<ffffffff8020c7f1>] ret_from_intr+0x0/0xa
[  604.923630]  <EOI> 
[  604.923630] 
[  604.923630] Code: f0 48 89 e5 53 48 89 fb 48 81 ec d8 00 00 00 48 89 95 50 ff ff ff 48 89 8d 58 ff ff ff 4c 89 85 60 ff ff ff 4c 89 8d 68 ff ff ff <48> 8b 7f 18 48 3b 7b 08 73 5a 48 8b 73 08 48 8d 55 10 48 8d 8d 
[  604.923630] RIP  [<ffffffff802a93ac>] seq_printf+0x2e/0xa7
[  604.923630]  RSP <ffff8100bf8eb8f8>
[  604.923630] CR2: 0000000000000018
[  604.923630] ---[ end trace 728898a466de31f0 ]---
[  604.923630] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  604.923630] NMI Watchdog detected LOCKUP on CPU 3
[  604.923630] CPU 3 
[  604.923630] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat cpufreq_conservative cpufreq_userspace iptable_filter ip6table_mangle cpufreq_powersave nf_conntrack_ipv4 nf_conntrack acpi_cpufreq ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 snd_pcm compat_ioctl32 firewire_ohci videodev v4l1_compat firewire_core snd_timer snd_page_alloc crc_itu_t v4l2_common snd_hwdep videobuf_dma_sg snd videobuf_core e1000e ir_kbd_i2c ohci1394 usb_storage rtc_cmos ir_common tveeprom ieee1394 rtc_core i2c_i801 sr_mod sg button i2c_core iTCO_wdt cdrom serio_raw iTCO_vendor_support rtc_lib intel_agp soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[  604.923630] Pid: 18521, comm: cc1 Tainted: G      D  2.6.26-devel-smp #1
[  604.923630] RIP: 0010:[<ffffffff8021ad56>]  [<ffffffff8021ad56>] native_smp_send_stop+0x84/0xa7
[  604.923630] RSP: 0000:ffff8100bf8eb618  EFLAGS: 00000093
[  604.923630] RAX: ffff8100bf8eb5a8 RBX: 0000000000000002 RCX: 0000000000000004
[  604.923630] RDX: 0000000000000000 RSI: 00000000000008fc RDI: 0000000000000300
[  604.923630] RBP: ffff8100bf8eb658 R08: 000000000000000f R09: 0000000000000000
[  604.923630] R10: 000000000000000a R11: 0000000000007600 R12: 0000000000000003
[  604.923630] R13: 0000000000000001 R14: ffff81007443c000 R15: ffff8100bf8eb848
[  604.923630] FS:  00002b3fc99fe6f0(0000) GS:ffff8100bf80e680(0000) knlGS:0000000000000000
[  604.923630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  604.923630] CR2: 0000000000000018 CR3: 0000000076025000 CR4: 00000000000006e0
[  604.923630] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  604.923630] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  604.923630] Process cc1 (pid: 18521, threadinfo ffff81007446a000, task ffff81007443c000)
[  604.923630] Stack:  ffffffff8021ac26 0000000000000000 ffffffff00000001 ffff810000000000
[  604.923630]  ffff8100bf8eb648 ffffffff804dbbaf ffff81007443c000 0000000000000009
[  604.923630]  ffff8100bf8eb748 ffffffff802355ce 0000003000000008 ffff8100bf8eb758
[  604.923630] Call Trace:
[  604.923630]  <IRQ>  [<ffffffff8021ac26>] ? stop_this_cpu+0x0/0x21
[  604.923630]  [<ffffffff802355ce>] panic+0xaf/0x159
[  604.923630]  [<ffffffff8024b621>] ? blocking_notifier_call_chain+0xf/0x11
[  604.923630]  [<ffffffff80238752>] do_exit+0x78/0x699
[  604.923630]  [<ffffffff8035e798>] ? do_unblank_screen+0x1d/0x119
[  604.923630]  [<ffffffff8020d6cf>] oops_begin+0x0/0x96
[  604.923630]  [<ffffffff80222473>] do_page_fault+0x69f/0x758
[  604.923630]  [<ffffffff80411659>] error_exit+0x0/0x51
[  604.923630]  [<ffffffff802a93ac>] ? seq_printf+0x2e/0xa7
[  604.923630]  [<ffffffff8024c527>] ? clocksource_read+0x7/0x9
[  604.923630]  [<ffffffff8024c575>] ? __get_nsec_offset+0x10/0x39
[  604.923630]  [<ffffffff8022caa9>] ? print_cfs_rq+0x41b/0x42a
[  604.923630]  [<ffffffff8022d419>] ? sched_debug_show+0x961/0xd22
[  604.923630]  [<ffffffff802318db>] ? show_state_filter+0x86/0x96
[  604.923630]  [<ffffffff80361e88>] ? sysrq_handle_showstate_blocked+0xe/0x10
[  604.923630]  [<ffffffff80361de3>] ? __handle_sysrq+0x9e/0x135
[  604.923630]  [<ffffffff80362006>] ? handle_sysrq+0x20/0x22
[  604.923630]  [<ffffffff8035b8c9>] ? kbd_event+0x37f/0x610
[  604.923630]  [<ffffffff8037aaea>] ? input_pass_event+0x5f/0x84
[  604.923630]  [<ffffffff8037ba4f>] ? input_handle_event+0x39c/0x3c0
[  604.923630]  [<ffffffff8037c1f8>] ? input_event+0x64/0x7c
[  604.923630]  [<ffffffffa0104c8f>] ? :hid:hidinput_hid_event+0x295/0x2c8
[  604.923630]  [<ffffffff80229b0f>] ? test_ti_thread_flag+0x11/0x13
[  604.923630]  [<ffffffffa01014b4>] ? :hid:hid_process_event+0x2e/0x62
[  604.923630]  [<ffffffffa01020e7>] ? :hid:hid_input_report+0x283/0x2f4
[  604.923630]  [<ffffffffa010ad8e>] ? :usbhid:hid_irq_in+0x8c/0x175
[  604.923630]  [<ffffffff8022924d>] ? __wake_up_common+0x46/0x75
[  604.923630]  [<ffffffffa00bb807>] ? :usbcore:usb_hcd_giveback_urb+0x84/0xb7
[  604.923630]  [<ffffffffa00eca13>] ? :uhci_hcd:uhci_giveback_urb+0x109/0x19d
[  604.923630]  [<ffffffffa00ed146>] ? :uhci_hcd:uhci_scan_schedule+0x58a/0x83f
[  604.923630]  [<ffffffff8023dc49>] ? run_timer_softirq+0x107/0x1af
[  604.923630]  [<ffffffffa00eef6d>] ? :uhci_hcd:uhci_irq+0x11c/0x133
[  604.923630]  [<ffffffffa00bb3bd>] ? :usbcore:usb_hcd_irq+0x37/0x68
[  604.923630]  [<ffffffff80267fc5>] ? handle_IRQ_event+0x27/0x57
[  604.923630]  [<ffffffff802693df>] ? handle_fasteoi_irq+0x95/0xd0
[  604.923630]  [<ffffffff8020f0c8>] ? do_IRQ+0x60/0xb6
[  604.923630]  [<ffffffff8020c7f1>] ? ret_from_intr+0x0/0xa
[  604.923630]  <EOI> 
[  604.923630] 
[  604.923630] Code: c7 45 d0 00 00 00 00 c7 45 d8 00 00 00 00 48 89 05 68 e0 3a 00 0f ae f0 48 8b 05 e6 b9 34 00 bf fc 00 00 00 ff 50 38 eb 02 f3 90 <44> 39 65 d0 75 f8 45 85 ed 74 06 fe 05 39 e0 3a 00 e8 86 0d 00 
[  604.923630] ---[ end trace 728898a466de31f0 ]---
[  605.278311] NMI Watchdog detected LOCKUP on CPU 2
[  605.278311] CPU 2 
[  605.278311] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat cpufreq_conservative cpufreq_userspace iptable_filter ip6table_mangle cpufreq_powersave nf_conntrack_ipv4 nf_conntrack acpi_cpufreq ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 snd_pcm compat_ioctl32 firewire_ohci videodev v4l1_compat firewire_core snd_timer snd_page_alloc crc_itu_t v4l2_common snd_hwdep videobuf_dma_sg snd videobuf_core e1000e ir_kbd_i2c ohci1394 usb_storage rtc_cmos ir_common tveeprom ieee1394 rtc_core i2c_i801 sr_mod sg button i2c_core iTCO_wdt cdrom serio_raw iTCO_vendor_support rtc_lib intel_agp soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[  605.278311] Pid: 18522, comm: as Tainted: G      D  2.6.26-devel-smp #1
[  605.278311] RIP: 0010:[<ffffffff80303ea9>]  [<ffffffff80303ea9>] __write_lock_failed+0x9/0x20
[  605.278311] RSP: 0018:ffff81007617fed0  EFLAGS: 00000087
[  605.278311] RAX: ffff81007617fef8 RBX: ffff810076174000 RCX: ffffffff80237524
[  605.278311] RDX: 000000000000003c RSI: ffffe200028b4328 RDI: ffffffff80557200
[  605.278311] RBP: ffff81007617fed8 R08: 0000000000000000 R09: ffff81007617feb8
[  605.278311] R10: ffff81007617fe98 R11: ffff81007617fea8 R12: ffff810076174000
[  605.278311] R13: ffff810076174000 R14: 0000000000000000 R15: 0000000000000001
[  605.278311] FS:  0000000000000000(0000) GS:ffff8100bf80e500(0000) knlGS:0000000000000000
[  605.278311] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  605.278311] CR2: 00002b29b7b7a640 CR3: 0000000000201000 CR4: 00000000000006e0
[  605.278311] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  605.278311] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  605.278311] Process as (pid: 18522, threadinfo ffff81007617e000, task ffff810076174000)
[  605.278311] Stack:  ffffffff80411318 ffff81007617ff38 ffffffff802389dc ffff81007617ff48
[  605.278311]  ffffffff8022218c ffff81007617fef8 ffff81007617fef8 ffff8100ba0e2360
[  605.278311]  ffff8100b85516c0 00002b29b7e22888 0000000000000000 0000000000000000
[  605.278311] Call Trace:
[  605.278311]  [<ffffffff80411318>] ? _write_lock_irq+0x13/0x15
[  605.278311]  [<ffffffff802389dc>] do_exit+0x302/0x699
[  605.278311]  [<ffffffff8022218c>] ? do_page_fault+0x3b8/0x758
[  605.278311]  [<ffffffff80238dee>] do_group_exit+0x7b/0x96
[  605.278311]  [<ffffffff80238e1b>] sys_exit_group+0x12/0x14
[  605.278311]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
[  605.278311] 
[  605.278311] 
[  605.278311] Code: e9 07 48 89 11 31 c0 c3 48 83 e9 07 eb 00 48 c7 c0 f2 ff ff ff c3 90 90 90 90 90 90 90 90 90 90 90 90 f0 81 07 00 00 00 01 f3 90 <81> 3f 00 00 00 01 75 f6 f0 81 2f 00 00 00 01 0f 85 e2 ff ff ff 
[  605.278311] ---[ end trace 728898a466de31f0 ]---
[  605.278311] NMI Watchdog detected LOCKUP on CPU 0
[  605.278311] CPU 0 
[  605.278311] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat cpufreq_conservative cpufreq_userspace iptable_filter ip6table_mangle cpufreq_powersave nf_conntrack_ipv4 nf_conntrack acpi_cpufreq ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 snd_pcm compat_ioctl32 firewire_ohci videodev v4l1_compat firewire_core snd_timer snd_page_alloc crc_itu_t v4l2_common snd_hwdep videobuf_dma_sg snd videobuf_core e1000e ir_kbd_i2c ohci1394 usb_storage rtc_cmos ir_common tveeprom ieee1394 rtc_core i2c_i801 sr_mod sg button i2c_core iTCO_wdt cdrom serio_raw iTCO_vendor_support rtc_lib intel_agp soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[  605.278311] Pid: 18518, comm: gcc Tainted: G      D  2.6.26-devel-smp #1
[  605.278311] RIP: 0010:[<ffffffff80303ea9>]  [<ffffffff80303ea9>] __write_lock_failed+0x9/0x20
[  605.278311] RSP: 0018:ffff810074471ed0  EFLAGS: 00000087
[  605.278311] RAX: ffff810074471ef8 RBX: ffff8100b9dc2000 RCX: ffffffff80237524
[  605.278311] RDX: 000000000000002f RSI: ffffe20001b21c38 RDI: ffffffff80557200
[  605.278311] RBP: ffff810074471ed8 R08: 0000000000000000 R09: ffff810074471eb8
[  605.278311] R10: ffff810074471e98 R11: ffff810074471ea8 R12: ffff8100b9dc2000
[  605.278311] R13: ffff8100b9dc2000 R14: 0000000000000000 R15: 0000000000000001
[  605.278311] FS:  0000000000000000(0000) GS:ffffffff80557000(0000) knlGS:0000000000000000
[  605.278311] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  605.278311] CR2: 0000000000640498 CR3: 0000000000201000 CR4: 00000000000006e0
[  605.278311] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  605.278311] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  605.278311] Process gcc (pid: 18518, threadinfo ffff810074470000, task ffff8100b9dc2000)
[  605.278311] Stack:  ffffffff80411318 ffff810074471f38 ffffffff802389dc ffff810074471f78
[  605.278311]  ffffffff80293abb ffff810074471ef8 ffff810074471ef8 0000000000000001
[  605.278311]  ffff8100b8434000 00002b95f3e3d888 0000000000000000 0000000000000000
[  605.278311] Call Trace:
[  605.278311]  [<ffffffff80411318>] ? _write_lock_irq+0x13/0x15
[  605.278311]  [<ffffffff802389dc>] do_exit+0x302/0x699
[  605.278311]  [<ffffffff80293abb>] ? sys_newstat+0x31/0x3c
[  605.278311]  [<ffffffff80238dee>] do_group_exit+0x7b/0x96
[  605.278311]  [<ffffffff80238e1b>] sys_exit_group+0x12/0x14
[  605.278311]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
[  605.278311] 
[  605.278311] 
[  605.278311] Code: e9 07 48 89 11 31 c0 c3 48 83 e9 07 eb 00 48 c7 c0 f2 ff ff ff c3 90 90 90 90 90 90 90 90 90 90 90 90 f0 81 07 00 00 00 01 f3 90 <81> 3f 00 00 00 01 75 f6 f0 81 2f 00 00 00 01 0f 85 e2 ff ff ff 
[  605.278311] ---[ end trace 728898a466de31f0 ]---
[  605.278311] Kernel panic - not syncing: Aiee, killing interrupt handler!


