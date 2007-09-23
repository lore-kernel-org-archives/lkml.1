Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXIWFYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXIWFYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 01:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXIWFYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 01:24:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6298 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXIWFYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 01:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=S6kA4C5yYdjF2hUgU2PkGTiT9TuVOeL6DoS1zov9pmCh2dFYco1G1Egknqkn9XN2jLXiwvZkezTGynJJQrZNRmp/yMmX0L3URF0e/D2pEtuSfchJR0o7COzKs1CJvfYtSI62ctXKSJlL544rAKT0kiw39Kr5N2tr1Iw8L9+o+F0=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Date: Sun, 23 Sep 2007 08:24:12 +0300
User-Agent: KMail/1.9.7
Cc: Oleg Verych <olecom@flower.upol.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20070922220347.586903979@linutronix.de> <E1IZG8l-0002jB-2k@flower> <alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9hf9GEgThLYbag1"
Message-Id: <200709230824.13320.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9hf9GEgThLYbag1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Sunday 23 September 2007, Linus Torvalds wrote:
> From a "future behaviour" standpoint it would probably be interesting to 
> hear whether Mihai can make his machine with not with the old IDE layer 
> (which distributions are migrating away from) but with the ATA layer 
> (libata) instead. It too should hopefully know about using ACPI to restore 
> any ATA controller quirks.

  I switched to libata, but it behaves like the old IDE without ACPI. I
  did not manage to get a full dmesg (apparently all volumes are mounted
  r/o right after a power up from a s2ram) but I did make a picture, from
  which I quote (if I may say so):

  "
  ata1.00: configured for PIO0
  sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
  sd 0:0:0:0: [sda] Sense key : 0xb [current] [descriptor]
  Descriptor sense data with sense descriptors (in hex):
          72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
          07 65 35 25
  sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
  end_request: I/O error, dev sda, sector 124073509
  ata1: EH complete
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
  ata1.00: cmd c5/00:10:75:36:65/00:00:00:00:00/e7 tag 0 cdb 0x0 data 8192 out
           res 51/04:10:75:36:65/00:00:00:00:00/e7 Emask 0x1 (device error)
  ata1.00: configured for PIO0
  ata1: EH complete
  "

  The last six lines repeat six times after which the whole things goes
  from the beginning:
  "
  ata1.00: configured for PIO0
  ...
  "

  It all gets crazy the moment I (or a process) try to access the root
  (or any other drive), until then, everything is nice and quiet.

  Mmm... in the excerpt above it says: "Write Protect is off" but when I did
  $ mount -o remount,rw /
  I got something like: "the device is write protected".

  I tried to save the dmesg on a mmc, but after powering up it said:
  "out of disk space"

  These are about all symptoms that I noticed... oh, and 'scsi_eh_0/1'
  enters disk-sleep often.

  I attached the dmesg pre s2ram.

  Thanks,

-- 
Mihai Donțu

--Boundary-00=_9hf9GEgThLYbag1
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-pre-s2ram.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-pre-s2ram.txt"

[    0.000000] Linux version 2.6.23-rc7 (root@mdontu-l) (gcc version 4.1.2 (Gentoo 4.1.2)) #10 PREEMPT Sun Sep 23 06:54:24 EEST 2007
[    0.000000] Command line: nohz=on root=/dev/sda7
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000037fd0000 - 0000000037fefc00 (reserved)
[    0.000000]  BIOS-e820: 0000000037fefc00 - 0000000037ffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000037ffb000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FE270, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     22110520 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 7489 (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF71D9, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1911 pages reserved
[    0.000000]   DMA zone: 2032 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfec01000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 224185
[    0.000000] Kernel command line: nohz=on root=/dev/sda7
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   39.453640] time.c: Detected 2194.613 MHz processor.
[   39.455401] Console: colour VGA+ 80x25
[   39.455404] console [tty0] enabled
[   39.459072] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   39.460107] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   39.475161] Memory: 894868k/917312k available (4163k kernel code, 21796k reserved, 1802k data, 232k init)
[   39.534509] Calibrating delay using timer specific routine.. 4391.68 BogoMIPS (lpj=2195841)
[   39.534639] Mount-cache hash table entries: 256
[   39.534832] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   39.534878] CPU: L2 Cache: 1024K (64 bytes/line)
[   39.534934] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   39.535066] ACPI: Core revision 20070126
[   39.580970] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   39.591012] Using local APIC timer interrupts.
[   39.636564] result 12469396
[   39.636607] Detected 12.469 MHz APIC timer.
[   39.637555] NET: Registered protocol family 16
[   39.637769] No dock devices found.
[   39.637872] ACPI: bus type pci registered
[   39.643017] PCI: Using MMCONFIG at e0000000 - efffffff
[   39.643108] PCI: No mmconfig possible on device 00:18
[   39.646112] ACPI: EC: Look up EC in DSDT
[   39.646190] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   39.662709] ACPI: Interpreter enabled
[   39.662754] ACPI: (supports S0 S3)
[   39.662910] ACPI: Using IOAPIC for interrupt routing
[   39.670228] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   39.670321] ACPI: PCI Root Bridge [C047] (0000:00)
[   39.671725] PCI: Transparent bridge - 0000:00:14.4
[   39.671845] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   39.672031] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   39.672112] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   39.685997] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   39.686381] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   39.686773] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   39.687172] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   39.687575] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   39.687973] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   39.688339] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   39.688745] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   39.689043] ACPI: Power Resource [C1CF] (off)
[   39.689233] ACPI: Power Resource [C1B7] (on)
[   39.689317] ACPI: Power Resource [C1C7] (on)
[   39.689453] ACPI: Power Resource [C26C] (off)
[   39.689567] ACPI: Power Resource [C26D] (off)
[   39.689680] ACPI: Power Resource [C26E] (off)
[   39.689795] ACPI: Power Resource [C26F] (off)
[   39.689867] Linux Plug and Play Support v0.97 (c) Adam Belay
[   39.689929] pnp: PnP ACPI init
[   39.689977] ACPI: bus type pnp registered
[   39.696206] pnp: PnP ACPI: found 12 devices
[   39.696250] ACPI: ACPI bus type pnp unregistered
[   39.696468] SCSI subsystem initialized
[   39.696529] libata version 2.21 loaded.
[   39.696644] usbcore: registered new interface driver usbfs
[   39.696724] usbcore: registered new interface driver hub
[   39.696796] usbcore: registered new device driver usb
[   39.696983] PCI: Using ACPI for IRQ routing
[   39.697028] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   39.697084] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   39.697130] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   39.697175] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   39.697221] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   39.697270] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   39.697316] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   39.700272] Bluetooth: Core ver 2.11
[   39.700357] NET: Registered protocol family 31
[   39.700401] Bluetooth: HCI device and connection manager initialized
[   39.700447] Bluetooth: HCI socket layer initialized
[   39.700492] NET: Registered protocol family 8
[   39.700536] NET: Registered protocol family 20
[   39.701257] Time: tsc clocksource has been installed.
[   39.703276] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   39.703322] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   39.703368] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   39.703419] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   39.703464] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   39.703510] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   39.703556] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   39.703607] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   39.703660] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   39.703708] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   39.703753] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   39.703804] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   39.703852] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   39.703898] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   39.703949] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   39.704215] PCI: Bridge: 0000:00:01.0
[   39.704263]   IO window: 2000-2fff
[   39.704307]   MEM window: d0400000-d07fffff
[   39.704350]   PREFETCH window: c0000000-cfffffff
[   39.704394] PCI: Bridge: 0000:00:04.0
[   39.704437]   IO window: disabled.
[   39.704480]   MEM window: disabled.
[   39.704523]   PREFETCH window: disabled.
[   39.704567] PCI: Bridge: 0000:00:05.0
[   39.704610]   IO window: disabled.
[   39.704653]   MEM window: disabled.
[   39.704696]   PREFETCH window: disabled.
[   39.704741] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   39.704786]   IO window: 00001000-000010ff
[   39.704830]   IO window: 00001400-000014ff
[   39.704867]   PREFETCH window: 50000000-53ffffff
[   39.704905]   MEM window: 54000000-57ffffff
[   39.704943] PCI: Bridge: 0000:00:14.4
[   39.704982]   IO window: 1000-1fff
[   39.705025]   MEM window: d0000000-d03fffff
[   39.705063]   PREFETCH window: 50000000-53ffffff
[   39.705117] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   39.705122] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   39.705145] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   39.705254] NET: Registered protocol family 2
[   39.715267] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   39.715757] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   39.718128] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   39.718740] TCP: Hash tables configured (established 131072 bind 65536)
[   39.718786] TCP reno registered
[   39.722123] VFS: Disk quotas dquot_6.5.1
[   39.722178] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   39.722328] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   39.722606] NTFS driver 2.1.28 [Flags: R/O].
[   39.722675] fuse init (API version 7.8)
[   39.722864] io scheduler noop registered
[   39.722908] io scheduler anticipatory registered
[   39.722953] io scheduler deadline registered
[   39.723004] io scheduler cfq registered (default)
[   39.723051] PCI: MSI quirk detected. MSI deactivated.
[   39.724429] Boot video device is 0000:01:05.0
[   39.724585] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   39.724599] assign_interrupt_mode Found MSI capability
[   39.724652] Allocate Port Service[0000:00:04.0:pcie00]
[   39.724680] Allocate Port Service[0000:00:04.0:pcie01]
[   39.724703] Allocate Port Service[0000:00:04.0:pcie02]
[   39.724742] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   39.724755] assign_interrupt_mode Found MSI capability
[   39.724801] Allocate Port Service[0000:00:05.0:pcie00]
[   39.724823] Allocate Port Service[0000:00:05.0:pcie01]
[   39.724847] Allocate Port Service[0000:00:05.0:pcie02]
[   39.724939] AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
[   39.724952] AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
[   39.726300] ACPI: AC Adapter [C177] (on-line)
[   39.726537] ACPI: Battery Slot [C179] (battery present)
[   39.726739] ACPI: Battery Slot [C178] (battery absent)
[   39.726881] input: Power Button (FF) as /class/input/input0
[   39.726926] ACPI: Power Button (FF) [PWRF]
[   39.728785] input: Sleep Button (CM) as /class/input/input1
[   39.728830] ACPI: Sleep Button (CM) [C1F0]
[   39.728926] input: Lid Switch as /class/input/input2
[   39.728970] ACPI: Lid Switch [C1F1]
[   39.729179] ACPI: Transitioning device [C270] to D3
[   39.729227] ACPI: Transitioning device [C270] to D3
[   39.729273] ACPI: Fan [C270] (off)
[   39.729451] ACPI: Transitioning device [C271] to D3
[   39.729496] ACPI: Transitioning device [C271] to D3
[   39.729541] ACPI: Fan [C271] (off)
[   39.729718] ACPI: Transitioning device [C272] to D3
[   39.729763] ACPI: Transitioning device [C272] to D3
[   39.729808] ACPI: Fan [C272] (off)
[   39.729985] ACPI: Transitioning device [C273] to D3
[   39.730030] ACPI: Transitioning device [C273] to D3
[   39.730075] ACPI: Fan [C273] (off)
[   39.730419] input: Video Bus as /class/input/input3
[   39.730464] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   39.730741] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   39.730894] ACPI: Processor [C000] (supports 8 throttling states)
[   39.738416] ACPI: Thermal Zone [TZ1] (68 C)
[   39.741642] ACPI: Thermal Zone [TZ2] (54 C)
[   39.749583] ACPI: Thermal Zone [TZ3] (27 C)
[   39.765001] Real Time Clock Driver v1.12ac
[   39.765151] Non-volatile memory driver v1.2
[   39.765209] Linux agpgart interface v0.102
[   39.765304] ipmi message handler version 39.1
[   39.765351] ipmi device interface
[   39.765440] IPMI System Interface driver.
[   39.773182] ipmi_si: Unable to find any System Interface(s)
[   39.773229] IPMI Watchdog: driver initialized
[   39.773273] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   39.773325] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   39.773377] Hangcheck: Using get_cycles().
[   39.773421] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   39.773832] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   39.773923] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   39.774338] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   39.774577] loop: module loaded
[   39.774757] nbd: registered device at major 43
[   39.775336] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   39.775535] tg3.c:v3.81 (September 5, 2007)
[   39.775599] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   39.796130] tifm_core: MMC/SD card detected in socket 0:3
[   39.805943] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   39.806215] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   39.806266] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   39.806375] PPP generic driver version 2.4.2
[   39.806463] PPP Deflate Compression module registered
[   39.806508] PPP BSD Compression module registered
[   39.806601] PPP MPPE Compression module registered
[   39.806646] NET: Registered protocol family 24
[   39.806756] tun: Universal TUN/TAP device driver, 1.6
[   39.806800] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   39.807073] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   39.807264] scsi0 : pata_atiixp
[   39.807347] scsi1 : pata_atiixp
[   39.807421] ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000013010 irq 14
[   39.807474] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000013018 irq 15
[   39.841053] Marking TSC unstable due to TSC halts in C3
[   39.841103] Time: acpi_pm clocksource has been installed.
[   39.961398] ata1.00: ATA-6: FUJITSU MHV2080AH, 00830096, max UDMA/100
[   39.961444] ata1.00: 156301488 sectors, multi 16: LBA 
[   39.983340] ata1.00: configured for UDMA/100
[   40.288012] ata2.00: ATAPI: MATSHITAUJ-840D, 1.02, max MWDMA2
[   40.444789] ata2.00: configured for MWDMA2
[   40.444905] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080A 0083 PQ: 0 ANSI: 5
[   40.445021] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   40.445074] sd 0:0:0:0: [sda] Write Protect is off
[   40.445118] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   40.445128] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.445220] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   40.445270] sd 0:0:0:0: [sda] Write Protect is off
[   40.445315] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   40.445324] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.445377]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[   40.501311] sd 0:0:0:0: [sda] Attached SCSI disk
[   40.501399] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   40.503265] scsi 1:0:0:0: CD-ROM            MATSHITA UJ-840D          1.02 PQ: 0 ANSI: 5
[   40.509950] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   40.509998] Uniform CD-ROM driver Revision: 3.20
[   40.510085] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   40.510129] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   40.510363] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   40.560581] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   40.560721] ieee1394: raw1394: /dev/raw1394 device initialized
[   40.560840] usbmon: debugfs is not available
[   40.560921] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   40.561423] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   40.561587] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   40.561694] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   40.561749] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   40.561959] usb usb1: configuration #1 chosen from 1 choice
[   40.562068] hub 1-0:1.0: USB hub found
[   40.562117] hub 1-0:1.0: 8 ports detected
[   40.662947] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   40.662985] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   40.663224] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   40.663378] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   40.663446] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   40.717892] usb usb2: configuration #1 chosen from 1 choice
[   40.717970] hub 2-0:1.0: USB hub found
[   40.718023] hub 2-0:1.0: 4 ports detected
[   40.818689] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   40.818907] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   40.819063] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   40.819131] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   40.873683] usb usb3: configuration #1 chosen from 1 choice
[   40.873762] hub 3-0:1.0: USB hub found
[   40.873815] hub 3-0:1.0: 4 ports detected
[   41.445670] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   41.581674] usb 3-1: configuration #1 chosen from 1 choice
[   41.800143] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   41.814233] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   41.941192] usb 3-3: configuration #1 chosen from 1 choice
[   41.943249] usbcore: registered new interface driver usblp
[   41.943294] Initializing USB Mass Storage driver...
[   41.943364] usbcore: registered new interface driver usb-storage
[   41.943410] USB Mass Storage support registered.
[   41.943511] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   41.945365] i8042.c: Detected active multiplexing controller, rev 1.1.
[   41.946170] serio: i8042 KBD port at 0x60,0x64 irq 1
[   41.946250] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   41.946322] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   41.946395] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   41.946465] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   41.946581] mice: PS/2 mouse device common for all mice
[   41.968645] input: AT Translated Set 2 keyboard as /class/input/input4
[   41.980759] input: PC Speaker as /class/input/input5
[   42.589206] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   42.629015] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   42.631917] I2O subsystem v1.325
[   42.631961] i2o: max drivers = 8
[   42.632079] I2O Configuration OSM v1.323
[   42.632139] I2O Bus Adapter OSM v1.317
[   42.632199] I2O Block Device OSM v1.325
[   42.632293] I2O SCSI Peripheral OSM v1.316
[   42.632354] I2O ProcFS OSM v1.316
[   42.632414] i2c /dev entries driver
[   42.632562] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   42.709894] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   42.709946] sc1200wdt: build 20020303
[   42.710007] sc1200wdt: io parameter must be specified
[   42.710068] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   42.710147] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   42.710211] Bluetooth: HCI USB driver ver 2.9
[   42.710279] usbcore: registered new interface driver hci_usb
[   42.710325] Bluetooth: Virtual HCI driver ver 1.2
[   42.710390] Bluetooth: HCI UART driver ver 2.2
[   42.710435] Bluetooth: HCI H4 protocol initialized
[   42.710480] Bluetooth: HCI BCSP protocol initialized
[   42.710524] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   42.710590] usbcore: registered new interface driver bcm203x
[   42.710636] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   42.710701] usbcore: registered new interface driver bpa10x
[   42.710747] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   42.712550] usbcore: registered new interface driver bfusb
[   42.712596] EDAC MC: Ver: 2.1.0 Sep 23 2007
[   42.712824] sdhci: Secure Digital Host Controller Interface driver
[   42.712869] sdhci: Copyright(c) Pierre Ossman
[   42.712937] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   42.713004] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   42.713620] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   42.713934] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   42.714212] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   42.714280] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   42.714325] wbsd: Copyright(c) Pierre Ossman
[   42.763775] usbcore: registered new interface driver hiddev
[   42.770230] input: Logitech USB Receiver as /class/input/input7
[   42.770325] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   42.770454] usbcore: registered new interface driver usbhid
[   42.770499] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   42.770584] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   42.770843] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   42.779916] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   42.808996] mmc3: new MMC card at address 0001
[   42.809158] mmcblk0: mmc3:0001 000000 62720KiB 
[   42.809236]  mmcblk0: p1
[   42.882578] MC'97 0 converters and GPIO not ready (0x1)
[   42.883156] ALSA device list:
[   42.883200]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   42.883246]   #1: ATI IXP Modem rev 2 at 0xd0805000, irq 17
[   42.883326] oprofile: using NMI interrupt.
[   42.883396] Netfilter messages via NETLINK v0.30.
[   42.883469] ip_tables: (C) 2000-2006 Netfilter Core Team
[   42.883538] arp_tables: (C) 2002 David S. Miller
[   42.883590] TCP cubic registered
[   42.883639] NET: Registered protocol family 1
[   42.883708] NET: Registered protocol family 10
[   42.883802] lo: Disabled Privacy Extensions
[   42.883899] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   42.883957] IPv6 over IPv4 tunneling driver
[   42.884068] sit0: Disabled Privacy Extensions
[   42.884183] NET: Registered protocol family 17
[   42.884231] Bluetooth: L2CAP ver 2.8
[   42.884274] Bluetooth: L2CAP socket layer initialized
[   42.884320] Bluetooth: SCO (Voice Link) ver 0.5
[   42.884364] Bluetooth: SCO socket layer initialized
[   42.884426] Bluetooth: RFCOMM socket layer initialized
[   42.884483] Bluetooth: RFCOMM TTY layer initialized
[   42.884527] Bluetooth: RFCOMM ver 1.8
[   42.884577] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   42.884622] Bluetooth: BNEP filters: protocol multicast
[   42.884666] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   42.884752] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   42.884798] All bugs added by David S. Miller <davem@redhat.com>
[   42.884876] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   42.884921] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   42.884975] ieee80211_crypt: registered algorithm 'NULL'
[   42.884977] ieee80211_crypt: registered algorithm 'WEP'
[   42.884978] ieee80211_crypt: registered algorithm 'CCMP'
[   42.884980] ieee80211_crypt: registered algorithm 'TKIP'
[   42.885003] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (1 cpu cores) (version 2.00.00)
[   42.887340] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   42.887385] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   42.887430] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   42.887475] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   42.887520] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   42.887609] powernow-k8: ph2 null fid transition 0xe
[   42.887803] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   42.901199] EXT3-fs: INFO: recovery required on readonly filesystem.
[   42.901245] EXT3-fs: write access will be enabled during recovery.
[   43.235697] kjournald starting.  Commit interval 5 seconds
[   43.235761] EXT3-fs: recovery complete.
[   43.236451] EXT3-fs: mounted filesystem with ordered data mode.
[   43.236513] VFS: Mounted root (ext3 filesystem) readonly.
[   43.236571] Freeing unused kernel memory: 232k freed
[   47.801222] EXT3 FS on sda7, internal journal
[   57.795525] kjournald starting.  Commit interval 5 seconds
[   57.795970] EXT3 FS on sda8, internal journal
[   57.795974] EXT3-fs: mounted filesystem with ordered data mode.
[   57.846526] NTFS volume version 3.1.
[   57.941964] Adding 1791208k swap on /dev/sda6.  Priority:-1 extents:1 across:1791208k
[   70.223467] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   71.812629] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   71.812632] tg3: eth0: Flow control is on for TX and on for RX.
[   71.813280] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   82.609570] eth0: no IPv6 routers present
[   95.264814] usb 1-5: new high speed USB device using ehci_hcd and address 5
[   95.391652] usb 1-5: configuration #1 chosen from 1 choice
[  125.202698] tifm0 : demand removing card from socket 0:3
[  125.202787] mmc3: card 0001 removed
[  125.731299] tifm_core: MMC/SD card detected in socket 0:3
[  125.766459] mmc3: new MMC card at address 0001
[  125.766880] mmcblk0: mmc3:0001 000000 62720KiB 
[  125.766948]  mmcblk0: p1
[  179.088895] APIC error on CPU0: 00(40)
[  271.819874] APIC error on CPU0: 40(40)
[  282.081037] APIC error on CPU0: 40(40)
[  468.014140] APIC error on CPU0: 40(40)

--Boundary-00=_9hf9GEgThLYbag1--
