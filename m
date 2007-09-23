Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXIWTWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXIWTWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXIWTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:22:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:11297 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXIWTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=lLkb8qHfxfDoOIX8/scIxLFW069H2xS9zcjDGV3fFZbduW/tgFLQ2Kw+WnGXN6fdsJ+PZRRF0AhR51gEV/5+YEwhCoBlBW912r83x6K48heyuC6R91CgQJuvSH0R8jpwjYyswRRgDIMzjVStT2gMJx2MmOxpADLdzneEgRt8fWI=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sun, 23 Sep 2007 22:22:28 +0300
User-Agent: KMail/1.9.7
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709220828.00078.mihai.dontu@gmail.com> <200709232131.02348.mihai.dontu@gmail.com> <200709232118.09884.rjw@sisk.pl>
In-Reply-To: <200709232118.09884.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1zr9G8iKcDj3ISi"
Message-Id: <200709232222.29066.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1zr9G8iKcDj3ISi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Sunday 23 September 2007, Rafael J. Wysocki wrote:
> On Sunday, 23 September 2007 20:31, Mihai Donțu wrote:
> > On Sunday 23 September 2007, Mihai Donțu wrote:
> > > I'll to do a full cleanup and start all over. I'm going to nail this thing down if
> > > it's the last thing I do! (so help me God) :)
> > 
> >   Found it!
> > 
> >   The problem was "Framebuffer Console support". It was enabled by default in older
> >   configs (like 2.6.22.7) but I think someone noticed this was bad and put it to
> >   default N in newer (2.6.23-rc7); and since I reused the .config from 2.6.21.3 ...
> > 
> >   So there, if one wants "ATI Radeon display support" on Radeon XPRESS 200M with
> >   X using radeon_drv.so, *should* put "Framebuffer Console support" to N (if it's
> >   not already).
> > 
> >   Now all I have to do is figure out what's the equivalent of "vga=791" on the new
> >   kernel (default text console looks really bad on my laptop).
> > 
> >   Sorry for all the noise (and spam),
> 
> No, this actually is valuable information, thanks for it. :-)
> 
> [I have missed your first post, sorry for that.]

  Don't worry.

  Now, one last update (I've just ran into it): I was preparing my laptop (to brag
  tomorrow with my new s2ram thinggie) when I noticed that after powering up from a
  suspend-to-ram, X doesn't like radeonfb working behind it's back, as a result
  it goes crazy (corrupted pixmaps and such). I should have tested these two together :|

  Bottom line: no radeonfb for me :( at least, not now; but I have to be honest with
  you: I don't see what commit dd1447134454b169d5ae353aceb93f2368db8547 brought new
  into the picture. The previous radeonfb worked just great, but then, again, maybe I'm
  not using the console at it's full power :)

  I have attached the dmesg after power up.

  Thanks,

  (last post today, I swear to God!)

-- 
Mihai Donțu

--Boundary-00=_1zr9G8iKcDj3ISi
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-radeonfb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-radeonfb.txt"

[    0.000000] Linux version 2.6.23-rc7 (root@mdontu-l) (gcc version 4.1.2 (Gentoo 4.1.2)) #16 PREEMPT Sun Sep 23 21:45:39 EEST 2007
[    0.000000] Command line: nohz=on root=/dev/sda7 libata.noacpi=0
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
[    0.000000] Kernel command line: nohz=on root=/dev/sda7 libata.noacpi=0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   12.674960] time.c: Detected 2194.591 MHz processor.
[   12.676723] Console: colour VGA+ 80x25
[   12.676726] console [tty0] enabled
[   12.680404] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   12.681426] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   12.696604] Memory: 894868k/917312k available (4178k kernel code, 21796k reserved, 1783k data, 232k init)
[   12.755828] Calibrating delay using timer specific routine.. 4391.82 BogoMIPS (lpj=2195914)
[   12.755966] Mount-cache hash table entries: 256
[   12.756164] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   12.756211] CPU: L2 Cache: 1024K (64 bytes/line)
[   12.756267] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   12.756399] ACPI: Core revision 20070126
[   12.802447] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   12.812490] Using local APIC timer interrupts.
[   12.858042] result 12469271
[   12.858085] Detected 12.469 MHz APIC timer.
[   12.858886] NET: Registered protocol family 16
[   12.859104] No dock devices found.
[   12.859210] ACPI: bus type pci registered
[   12.864287] PCI: Using MMCONFIG at e0000000 - efffffff
[   12.864378] PCI: No mmconfig possible on device 00:18
[   12.867424] ACPI: EC: Look up EC in DSDT
[   12.867510] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   12.884599] ACPI: Interpreter enabled
[   12.884649] ACPI: (supports S0 S3)
[   12.884806] ACPI: Using IOAPIC for interrupt routing
[   12.892180] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   12.892270] ACPI: PCI Root Bridge [C047] (0000:00)
[   12.893712] PCI: Transparent bridge - 0000:00:14.4
[   12.893834] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   12.894031] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   12.894117] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   12.906699] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   12.907084] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   12.907467] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   12.907858] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   12.908242] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   12.908629] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   12.908976] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   12.909367] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   12.909670] ACPI: Power Resource [C1CF] (off)
[   12.909865] ACPI: Power Resource [C1B7] (on)
[   12.909947] ACPI: Power Resource [C1C7] (on)
[   12.910072] ACPI: Power Resource [C26C] (off)
[   12.910189] ACPI: Power Resource [C26D] (off)
[   12.910305] ACPI: Power Resource [C26E] (off)
[   12.910423] ACPI: Power Resource [C26F] (off)
[   12.910496] Linux Plug and Play Support v0.97 (c) Adam Belay
[   12.910561] pnp: PnP ACPI init
[   12.910613] ACPI: bus type pnp registered
[   12.916735] pnp: PnP ACPI: found 12 devices
[   12.916780] ACPI: ACPI bus type pnp unregistered
[   12.917006] SCSI subsystem initialized
[   12.917067] libata version 2.21 loaded.
[   12.917162] usbcore: registered new interface driver usbfs
[   12.917249] usbcore: registered new interface driver hub
[   12.917324] usbcore: registered new device driver usb
[   12.917527] PCI: Using ACPI for IRQ routing
[   12.917571] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   12.917631] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   12.917677] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   12.917723] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   12.917769] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   12.917814] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   12.917860] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   12.920593] Bluetooth: Core ver 2.11
[   12.920683] NET: Registered protocol family 31
[   12.920728] Bluetooth: HCI device and connection manager initialized
[   12.920775] Bluetooth: HCI socket layer initialized
[   12.920820] NET: Registered protocol family 8
[   12.920863] NET: Registered protocol family 20
[   12.921579] Time: tsc clocksource has been installed.
[   12.923598] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   12.923644] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   12.923691] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   12.923742] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   12.923787] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   12.923833] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   12.923880] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   12.923932] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   12.923985] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   12.924031] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   12.924077] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   12.924128] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   12.924177] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   12.924223] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   12.924274] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   12.924566] PCI: Bridge: 0000:00:01.0
[   12.924614]   IO window: 2000-2fff
[   12.924658]   MEM window: d0400000-d07fffff
[   12.924702]   PREFETCH window: c0000000-cfffffff
[   12.924746] PCI: Bridge: 0000:00:04.0
[   12.924790]   IO window: disabled.
[   12.924833]   MEM window: disabled.
[   12.924876]   PREFETCH window: disabled.
[   12.924920] PCI: Bridge: 0000:00:05.0
[   12.924963]   IO window: disabled.
[   12.925006]   MEM window: disabled.
[   12.925049]   PREFETCH window: disabled.
[   12.925095] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   12.925139]   IO window: 00001000-000010ff
[   12.925183]   IO window: 00001400-000014ff
[   12.925220]   PREFETCH window: 50000000-53ffffff
[   12.925264]   MEM window: 54000000-57ffffff
[   12.925302] PCI: Bridge: 0000:00:14.4
[   12.925341]   IO window: 1000-1fff
[   12.925384]   MEM window: d0000000-d03fffff
[   12.925421]   PREFETCH window: 50000000-53ffffff
[   12.925476] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   12.925481] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   12.925507] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   12.925619] NET: Registered protocol family 2
[   12.935588] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   12.936074] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   12.938444] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   12.939059] TCP: Hash tables configured (established 131072 bind 65536)
[   12.939107] TCP reno registered
[   12.942504] VFS: Disk quotas dquot_6.5.1
[   12.942563] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.942722] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   12.943051] NTFS driver 2.1.28 [Flags: R/O].
[   12.943123] fuse init (API version 7.8)
[   12.943320] io scheduler noop registered
[   12.943364] io scheduler anticipatory registered
[   12.943409] io scheduler deadline registered
[   12.943462] io scheduler cfq registered (default)
[   12.943509] PCI: MSI quirk detected. MSI deactivated.
[   12.944854] Boot video device is 0000:01:05.0
[   12.945013] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   12.945029] assign_interrupt_mode Found MSI capability
[   12.945080] Allocate Port Service[0000:00:04.0:pcie00]
[   12.945109] Allocate Port Service[0000:00:04.0:pcie01]
[   12.945134] Allocate Port Service[0000:00:04.0:pcie02]
[   12.945179] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   12.945193] assign_interrupt_mode Found MSI capability
[   12.945239] Allocate Port Service[0000:00:05.0:pcie00]
[   12.945264] Allocate Port Service[0000:00:05.0:pcie01]
[   12.945288] Allocate Port Service[0000:00:05.0:pcie02]
[   12.945383] AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
[   12.945398] AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
[   12.945463] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 17 (level, low) -> IRQ 17
[   12.945618] radeonfb: Retrieved PLL infos from BIOS
[   12.945664] radeonfb: Reference=14.32 MHz (RefDiv=6) Memory=300.00 Mhz, System=205.00 MHz
[   12.947453] radeonfb: PLL min 20000 max 40000
[   13.360927] Non-DDC laptop panel detected
[   13.437524] i2c-adapter i2c-2: unable to read EDID block.
[   13.556347] i2c-adapter i2c-2: unable to read EDID block.
[   13.675171] i2c-adapter i2c-2: unable to read EDID block.
[   13.925093] radeonfb: Monitor 1 type LCD found
[   13.925137] radeonfb: Monitor 2 type no found
[   13.925182] radeonfb: panel ID string: CMO N150P5-L01
[   13.925183]          
[   13.925268] radeonfb: detected LVDS panel size from BIOS: 1400x1050
[   13.925313] radeondb: BIOS provided dividers will be used
[   13.925597] radeonfb (0000:01:05.0): ATI Radeon YU 
[   13.927235] ACPI: AC Adapter [C177] (on-line)
[   13.927482] ACPI: Battery Slot [C179] (battery present)
[   13.927692] ACPI: Battery Slot [C178] (battery absent)
[   13.927837] input: Power Button (FF) as /class/input/input0
[   13.927883] ACPI: Power Button (FF) [PWRF]
[   13.927994] input: Sleep Button (CM) as /class/input/input1
[   13.928039] ACPI: Sleep Button (CM) [C1F0]
[   13.928148] input: Lid Switch as /class/input/input2
[   13.928193] ACPI: Lid Switch [C1F1]
[   13.928410] ACPI: Transitioning device [C270] to D3
[   13.928455] ACPI: Transitioning device [C270] to D3
[   13.928501] ACPI: Fan [C270] (off)
[   13.928683] ACPI: Transitioning device [C271] to D3
[   13.928727] ACPI: Transitioning device [C271] to D3
[   13.928772] ACPI: Fan [C271] (off)
[   13.928954] ACPI: Transitioning device [C272] to D3
[   13.928999] ACPI: Transitioning device [C272] to D3
[   13.929044] ACPI: Fan [C272] (off)
[   13.929231] ACPI: Transitioning device [C273] to D3
[   13.929275] ACPI: Transitioning device [C273] to D3
[   13.929321] ACPI: Fan [C273] (off)
[   13.929606] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   13.929759] ACPI: Processor [C000] (supports 8 throttling states)
[   13.937037] ACPI: Thermal Zone [TZ1] (67 C)
[   13.940198] ACPI: Thermal Zone [TZ2] (55 C)
[   13.948471] ACPI: Thermal Zone [TZ3] (27 C)
[   13.965984] Non-volatile memory driver v1.2
[   13.966095] Linux agpgart interface v0.102
[   13.966196] ipmi message handler version 39.1
[   13.966242] ipmi device interface
[   13.966324] IPMI System Interface driver.
[   13.975049] ipmi_si: Unable to find any System Interface(s)
[   13.975096] IPMI Watchdog: driver initialized
[   13.975141] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   13.975193] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   13.975245] Hangcheck: Using get_cycles().
[   13.975290] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   13.975725] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   13.975817] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   13.976278] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   13.976537] loop: module loaded
[   13.976721] nbd: registered device at major 43
[   13.977350] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   13.977520] tg3.c:v3.81 (September 5, 2007)
[   13.977589] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   14.007844] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   14.008124] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   14.008175] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   14.008293] PPP generic driver version 2.4.2
[   14.008385] PPP Deflate Compression module registered
[   14.008430] PPP BSD Compression module registered
[   14.008529] PPP MPPE Compression module registered
[   14.008574] NET: Registered protocol family 24
[   14.008692] tun: Universal TUN/TAP device driver, 1.6
[   14.008737] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   14.009034] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   14.009225] scsi0 : pata_atiixp
[   14.009314] scsi1 : pata_atiixp
[   14.009431] ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000013010 irq 14
[   14.009485] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000013018 irq 15
[   14.042916] Marking TSC unstable due to TSC halts in C3
[   14.042967] Time: acpi_pm clocksource has been installed.
[   14.163262] ata1.00: ATA-6: FUJITSU MHV2080AH, 00830096, max UDMA/100
[   14.163308] ata1.00: 156301488 sectors, multi 16: LBA 
[   14.185204] ata1.00: configured for UDMA/100
[   14.489877] ata2.00: ATAPI: MATSHITAUJ-840D, 1.02, max MWDMA2
[   14.646642] ata2.00: configured for MWDMA2
[   14.646758] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080A 0083 PQ: 0 ANSI: 5
[   14.646882] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   14.646935] sd 0:0:0:0: [sda] Write Protect is off
[   14.646980] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.646990] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.647087] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   14.647137] sd 0:0:0:0: [sda] Write Protect is off
[   14.647182] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.647192] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.647245]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[   14.711132] sd 0:0:0:0: [sda] Attached SCSI disk
[   14.711225] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   14.713092] scsi 1:0:0:0: CD-ROM            MATSHITA UJ-840D          1.02 PQ: 0 ANSI: 5
[   14.719788] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   14.719834] Uniform CD-ROM driver Revision: 3.20
[   14.719923] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   14.719969] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   14.720217] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   14.770444] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   14.770586] ieee1394: raw1394: /dev/raw1394 device initialized
[   14.770653] usbmon: debugfs is not available
[   14.770738] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   14.771235] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   14.771400] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   14.771506] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   14.771562] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   14.771779] usb usb1: configuration #1 chosen from 1 choice
[   14.771890] hub 1-0:1.0: USB hub found
[   14.771940] hub 1-0:1.0: 8 ports detected
[   14.872803] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   14.872840] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   14.873083] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   14.873238] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   14.873305] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   14.927742] usb usb2: configuration #1 chosen from 1 choice
[   14.927823] hub 2-0:1.0: USB hub found
[   14.927878] hub 2-0:1.0: 4 ports detected
[   15.028549] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   15.028759] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   15.028915] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   15.028986] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   15.083540] usb usb3: configuration #1 chosen from 1 choice
[   15.083620] hub 3-0:1.0: USB hub found
[   15.083675] hub 3-0:1.0: 4 ports detected
[   15.438847] usb 1-8: new high speed USB device using ehci_hcd and address 4
[   15.555971] usb 1-8: configuration #1 chosen from 1 choice
[   15.978045] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   16.024095] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   16.113102] usb 3-1: configuration #1 chosen from 1 choice
[   16.331521] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   16.472626] usb 3-3: configuration #1 chosen from 1 choice
[   16.578194] usbcore: registered new interface driver usblp
[   16.578240] Initializing USB Mass Storage driver...
[   16.578342] scsi2 : SCSI emulation for USB Mass Storage devices
[   16.578432] usb-storage: device found at 4
[   16.578433] usb-storage: waiting for device to settle before scanning
[   16.578446] usbcore: registered new interface driver usb-storage
[   16.578492] USB Mass Storage support registered.
[   16.578596] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   16.580432] i8042.c: Detected active multiplexing controller, rev 1.1.
[   16.581240] serio: i8042 KBD port at 0x60,0x64 irq 1
[   16.581319] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   16.581393] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   16.581465] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   16.581538] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   16.581661] mice: PS/2 mouse device common for all mice
[   16.603540] input: AT Translated Set 2 keyboard as /class/input/input3
[   16.615654] input: PC Speaker as /class/input/input4
[   17.225113] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   17.264940] input: SynPS/2 Synaptics TouchPad as /class/input/input5
[   17.267836] I2O subsystem v1.325
[   17.267880] i2o: max drivers = 8
[   17.268002] i2c /dev entries driver
[   17.268362] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   17.268413] sc1200wdt: build 20020303
[   17.268479] sc1200wdt: io parameter must be specified
[   17.268544] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   17.268635] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   17.268703] Bluetooth: HCI USB driver ver 2.9
[   17.270513] usbcore: registered new interface driver hci_usb
[   17.270560] Bluetooth: Virtual HCI driver ver 1.2
[   17.270629] Bluetooth: HCI UART driver ver 2.2
[   17.270674] Bluetooth: HCI H4 protocol initialized
[   17.270719] Bluetooth: HCI BCSP protocol initialized
[   17.270763] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   17.270835] usbcore: registered new interface driver bcm203x
[   17.270881] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   17.270951] usbcore: registered new interface driver bpa10x
[   17.270997] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   17.271067] usbcore: registered new interface driver bfusb
[   17.271113] EDAC MC: Ver: 2.1.0 Sep 23 2007
[   17.271361] sdhci: Secure Digital Host Controller Interface driver
[   17.271406] sdhci: Copyright(c) Pierre Ossman
[   17.271478] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   17.271546] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   17.272215] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   17.272495] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   17.272776] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   17.272843] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   17.272888] wbsd: Copyright(c) Pierre Ossman
[   17.273007] usbcore: registered new interface driver hiddev
[   17.278693] input: Logitech USB Receiver as /class/input/input6
[   17.278793] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   17.278921] usbcore: registered new interface driver usbhid
[   17.278966] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   17.279048] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   17.280348] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   17.290264] ALSA device list:
[   17.290313]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   17.290397] oprofile: using NMI interrupt.
[   17.290470] Netfilter messages via NETLINK v0.30.
[   17.290543] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.290608] arp_tables: (C) 2002 David S. Miller
[   17.290660] TCP cubic registered
[   17.290710] NET: Registered protocol family 1
[   17.290787] NET: Registered protocol family 10
[   17.290885] lo: Disabled Privacy Extensions
[   17.290982] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.291040] IPv6 over IPv4 tunneling driver
[   17.291162] sit0: Disabled Privacy Extensions
[   17.291280] NET: Registered protocol family 17
[   17.291327] Bluetooth: L2CAP ver 2.8
[   17.291371] Bluetooth: L2CAP socket layer initialized
[   17.291416] Bluetooth: SCO (Voice Link) ver 0.5
[   17.291460] Bluetooth: SCO socket layer initialized
[   17.291524] Bluetooth: RFCOMM socket layer initialized
[   17.291578] Bluetooth: RFCOMM TTY layer initialized
[   17.291622] Bluetooth: RFCOMM ver 1.8
[   17.291665] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   17.291710] Bluetooth: BNEP filters: protocol multicast
[   17.291755] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   17.291850] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   17.291896] All bugs added by David S. Miller <davem@redhat.com>
[   17.291944] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   17.291990] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   17.292042] ieee80211_crypt: registered algorithm 'NULL'
[   17.292044] ieee80211_crypt: registered algorithm 'WEP'
[   17.292045] ieee80211_crypt: registered algorithm 'CCMP'
[   17.292047] ieee80211_crypt: registered algorithm 'TKIP'
[   17.292054] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (1 cpu cores) (version 2.00.00)
[   17.294547] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   17.294592] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   17.294637] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   17.294682] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   17.294727] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   17.294817] powernow-k8: ph2 null fid transition 0xe
[   17.295012] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   17.328364] kjournald starting.  Commit interval 5 seconds
[   17.328415] EXT3-fs: mounted filesystem with ordered data mode.
[   17.328465] VFS: Mounted root (ext3 filesystem) readonly.
[   17.328520] Freeing unused kernel memory: 232k freed
[   20.915596] input: Video Bus as /class/input/input7
[   20.915617] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   21.483607] Real Time Clock Driver v1.12ac
[   21.904657] EXT3 FS on sda7, internal journal
[   22.060420] scsi 2:0:0:0: Direct-Access     ST350064 1A               3.AA PQ: 0 ANSI: 0
[   22.061896] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   22.062902] sd 2:0:0:0: [sdb] Write Protect is off
[   22.062905] sd 2:0:0:0: [sdb] Mode Sense: 10 00 00 00
[   22.062907] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   22.063766] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   22.064773] sd 2:0:0:0: [sdb] Write Protect is off
[   22.064775] sd 2:0:0:0: [sdb] Mode Sense: 10 00 00 00
[   22.064776] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   22.064780]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
[   22.136568] sd 2:0:0:0: [sdb] Attached SCSI disk
[   22.136769] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   22.136963] usb-storage: device scan complete
[   22.328723] kjournald starting.  Commit interval 5 seconds
[   22.329049] EXT3 FS on sda8, internal journal
[   22.329054] EXT3-fs: mounted filesystem with ordered data mode.
[   22.372828] NTFS volume version 3.1.
[   22.458392] Adding 1791208k swap on /dev/sda6.  Priority:-1 extents:1 across:1791208k
[   36.274916] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.842386] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   37.842391] tg3: eth0: Flow control is on for TX and on for RX.
[   37.843931] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   48.263202] eth0: no IPv6 routers present
[   93.000667] Stopping tasks ... done.
[   93.033605] Suspending console(s)
[   93.469511] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   93.469606] sd 0:0:0:0: [sda] Stopping disk
[   94.203773] ACPI handle has no context!
[   94.203975] ACPI handle has no context!
[   94.203994] ACPI: PCI interrupt for device 0000:02:04.4 disabled
[   94.203999] ACPI handle has no context!
[   94.211811] ACPI handle has no context!
[   94.211822] ACPI: PCI interrupt for device 0000:02:04.3 disabled
[   94.211827] ACPI handle has no context!
[   94.219818] ACPI handle has no context!
[   94.379107] radeonfb (0000:01:05.0): suspending for event: 2...
[   94.379231] ACPI: PCI interrupt for device 0000:00:14.5 disabled
[   94.379849] ACPI: PCI interrupt for device 0000:00:14.1 disabled
[   94.379890] ACPI: PCI interrupt for device 0000:00:13.2 disabled
[   94.383782] ACPI: PCI interrupt for device 0000:00:13.1 disabled
[   94.383803] ACPI: PCI interrupt for device 0000:00:13.0 disabled
[   94.384175] ACPI: Transitioning device [C273] to D0
[   94.384177] ACPI: Transitioning device [C273] to D0
[   94.384517] ACPI: Transitioning device [C272] to D0
[   94.384519] ACPI: Transitioning device [C272] to D0
[   94.384859] ACPI: Transitioning device [C271] to D0
[   94.384860] ACPI: Transitioning device [C271] to D0
[   94.385197] ACPI: Transitioning device [C270] to D0
[   94.385199] ACPI: Transitioning device [C270] to D0
[    0.172380] Back to C!
[    0.188587] ACPI: Transitioning device [C270] to D3
[    0.188589] ACPI: Transitioning device [C270] to D3
[    0.188729] ACPI: Transitioning device [C271] to D3
[    0.188730] ACPI: Transitioning device [C271] to D3
[    0.188873] ACPI: Transitioning device [C272] to D3
[    0.188875] ACPI: Transitioning device [C272] to D3
[    0.189015] ACPI: Transitioning device [C273] to D3
[    0.189016] ACPI: Transitioning device [C273] to D3
[    0.191886] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 22202121, writing 2202121)
[    0.191895] PM: Writing back config space on device 0000:00:04.0 at offset 9 (was 0, writing fff0)
[    0.191897] PM: Writing back config space on device 0000:00:04.0 at offset 8 (was 0, writing fff0)
[    0.191899] PM: Writing back config space on device 0000:00:04.0 at offset 7 (was 101, writing 1f1)
[    0.191902] PM: Writing back config space on device 0000:00:04.0 at offset 3 (was 10000, writing 10010)
[    0.191905] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was 100000, writing 100004)
[    0.191909] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.191914] PM: Writing back config space on device 0000:00:05.0 at offset 9 (was 0, writing fff0)
[    0.191917] PM: Writing back config space on device 0000:00:05.0 at offset 8 (was 0, writing fff0)
[    0.191919] PM: Writing back config space on device 0000:00:05.0 at offset 7 (was 101, writing 1f1)
[    0.191922] PM: Writing back config space on device 0000:00:05.0 at offset 3 (was 10000, writing 10010)
[    0.191925] PM: Writing back config space on device 0000:00:05.0 at offset 1 (was 100000, writing 100004)
[    0.191929] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.191935] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.191956] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[    0.195660] PCI: Enabling device 0000:00:13.2 (0000 -> 0002)
[    0.195662] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[    0.195678] PM: Writing back config space on device 0000:00:13.2 at offset 1 (was 2b00006, writing 2b00017)
[    0.195706] PM: Writing back config space on device 0000:00:14.1 at offset f (was 100, writing 10a)
[    0.195713] PM: Writing back config space on device 0000:00:14.1 at offset 8 (was 1, writing 3011)
[    0.195718] PM: Writing back config space on device 0000:00:14.1 at offset 3 (was 0, writing 4010)
[    0.195722] PM: Writing back config space on device 0000:00:14.1 at offset 1 (was 2300000, writing 2300005)
[    0.195731] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[    0.684944] PM: Writing back config space on device 0000:00:14.4 at offset 3 (was 816000, writing 814000)
[    0.684958] PM: Writing back config space on device 0000:00:14.5 at offset f (was 20200, writing 20205)
[    0.684967] PM: Writing back config space on device 0000:00:14.5 at offset 4 (was 0, writing d0804000)
[    0.684970] PM: Writing back config space on device 0000:00:14.5 at offset 3 (was 800000, writing 804010)
[    0.684974] PM: Writing back config space on device 0000:00:14.5 at offset 1 (was 4300000, writing 4300002)
[    0.684983] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[    0.685358] atiixp: codec reset timeout
[    0.686002] PM: Writing back config space on device 0000:00:14.6 at offset f (was 20200, writing 20205)
[    0.686010] PM: Writing back config space on device 0000:00:14.6 at offset 4 (was 0, writing d0805000)
[    0.686013] PM: Writing back config space on device 0000:00:14.6 at offset 3 (was 800000, writing 804010)
[    0.686017] PM: Writing back config space on device 0000:00:14.6 at offset 1 (was 4300000, writing 4300003)
[    0.686040] radeonfb (0000:01:05.0): resuming from state: 2...
[    0.753560] ata1.00: limited to UDMA/33 due to 40-wire cable
[    0.761553] ata1.00: configured for UDMA/33
[    0.761573] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    0.761581] sd 0:0:0:0: [sda] Write Protect is off
[    0.761582] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.761593] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.909373] ata2.00: configured for MWDMA2
[    1.051493] PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
[    1.052205] tg3: eth0: Link is down.
[    1.160980] PM: Writing back config space on device 0000:02:02.0 at offset f (was 100, writing 105)
[    1.160991] PM: Writing back config space on device 0000:02:02.0 at offset 4 (was 0, writing d0010000)
[    1.160994] PM: Writing back config space on device 0000:02:02.0 at offset 3 (was 0, writing 4000)
[    1.160998] PM: Writing back config space on device 0000:02:02.0 at offset 1 (was 0, writing 6)
[    1.161007] PM: Writing back config space on device 0000:02:04.0 at offset f (was 34001ff, writing 344010b)
[    1.161010] PM: Writing back config space on device 0000:02:04.0 at offset e (was 0, writing 14fc)
[    1.161013] PM: Writing back config space on device 0000:02:04.0 at offset d (was 0, writing 1400)
[    1.161017] PM: Writing back config space on device 0000:02:04.0 at offset c (was 0, writing 10fc)
[    1.161020] PM: Writing back config space on device 0000:02:04.0 at offset b (was 0, writing 1000)
[    1.161024] PM: Writing back config space on device 0000:02:04.0 at offset a (was 0, writing 57fff000)
[    1.161027] PM: Writing back config space on device 0000:02:04.0 at offset 9 (was 0, writing 54000000)
[    1.161030] PM: Writing back config space on device 0000:02:04.0 at offset 8 (was 0, writing 53fff000)
[    1.161034] PM: Writing back config space on device 0000:02:04.0 at offset 7 (was 0, writing 50000000)
[    1.161037] PM: Writing back config space on device 0000:02:04.0 at offset 6 (was 0, writing b0060302)
[    1.161041] PM: Writing back config space on device 0000:02:04.0 at offset 4 (was 0, writing d0012000)
[    1.161045] PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 820000, writing 824010)
[    1.161049] PM: Writing back config space on device 0000:02:04.0 at offset 1 (was 2100000, writing 2100007)
[    1.161062] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[    1.164762] PM: Writing back config space on device 0000:02:04.2 at offset f (was 4020300, writing 4020309)
[    1.164772] PM: Writing back config space on device 0000:02:04.2 at offset 5 (was 0, writing d0014000)
[    1.164776] PM: Writing back config space on device 0000:02:04.2 at offset 4 (was 0, writing d0013000)
[    1.164779] PM: Writing back config space on device 0000:02:04.2 at offset 3 (was 800000, writing 804010)
[    1.164783] PM: Writing back config space on device 0000:02:04.2 at offset 1 (was 2100000, writing 2100006)
[    1.182973] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    1.186910] PM: Writing back config space on device 0000:02:04.3 at offset f (was 40702ff, writing 4070209)
[    1.186921] PM: Writing back config space on device 0000:02:04.3 at offset 4 (was 0, writing d0018000)
[    1.186924] PM: Writing back config space on device 0000:02:04.3 at offset 3 (was 800000, writing 804010)
[    1.186929] PM: Writing back config space on device 0000:02:04.3 at offset 1 (was 2100000, writing 2100006)
[    1.186938] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[    1.190904] PM: Writing back config space on device 0000:02:04.4 at offset f (was 40703ff, writing 4070309)
[    1.190913] PM: Writing back config space on device 0000:02:04.4 at offset 6 (was 0, writing d001c000)
[    1.190917] PM: Writing back config space on device 0000:02:04.4 at offset 5 (was 0, writing d001b000)
[    1.190920] PM: Writing back config space on device 0000:02:04.4 at offset 4 (was 0, writing d001a000)
[    1.190924] PM: Writing back config space on device 0000:02:04.4 at offset 3 (was 800000, writing 804010)
[    1.190928] PM: Writing back config space on device 0000:02:04.4 at offset 1 (was 2100000, writing 2100006)
[    1.190937] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[    1.191118] sd 0:0:0:0: [sda] Starting disk
[    1.478983] Restarting tasks ... done.
[    1.731348] tg3: eth0: Link is up at 100 Mbps, full duplex.
[    1.731352] tg3: eth0: Flow control is on for TX and on for RX.

--Boundary-00=_1zr9G8iKcDj3ISi--
