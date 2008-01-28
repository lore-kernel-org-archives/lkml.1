Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYA1Qft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYA1Qft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYA1Qfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:35:38 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:47874 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYA1Qff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:35:35 -0500
Date: Mon, 28 Jan 2008 11:35:14 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <18333.57152.472830.608248@harpo.it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281135.14555.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_CRgnHlCwc4ypVHQ"
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801280754.53768.gene.heskett@gmail.com>
 <18333.57152.472830.608248@harpo.it.uu.se>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CRgnHlCwc4ypVHQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 28 January 2008, Mikael Pettersson wrote:
>Gene Heskett writes:
> > On Monday 28 January 2008, Peter Zijlstra wrote:
> > >On Mon, 2008-01-28 at 09:17 +0100, Mikael Pettersson wrote:
> > >> 1. Wrong mailing list; use linux-ide (@vger) instead.
> > >
> > >What, and keep all us other interested people in the dark?
> >
> > As a test, I tried rebooting to the latest fedora kernel and found it
> > kills X, so I'm back to the second to last fedora version ATM, and the
> > third 'smartctl -t lng /dev/sda' in 24 hours is running now.  The first
> > two completed with no errors.
> >
> > I've added the linux-ide list to refresh those people of the problem,
> > the logs are being spammed by this message stanza:
> >
> >  Jan 28 04:46:25 coyote kernel: [26550.290016] ata1.00: exception Emask
> > 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 28 04:46:25 coyote kernel:
> > [26550.290028] ata1.00: cmd 35/00:58:c9:9c:0a/00:01:00:00:00/e0 tag 0 dma
> > 176128 out Jan 28 04:46:25 coyote kernel: [26550.290029]          res
> > 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 28 04:46:25
> > coyote kernel: [26550.290032] ata1.00: status: { DRDY } Jan 28 04:46:25
> > coyote kernel: [26550.290060] ata1: soft resetting link Jan 28 04:46:25
> > coyote kernel: [26550.452301] ata1.00: configured for UDMA/100 Jan 28
> > 04:46:25 coyote kernel: [26550.452318] ata1: EH complete
> > Jan 28 04:46:25 coyote kernel: [26550.455898] sd 0:0:0:0: [sda] 390721968
> > 512-byte hardware sectors (200050 MB) Jan 28 04:46:25 coyote kernel:
> > [26550.456151] sd 0:0:0:0: [sda] Write Protect is off Jan 28 04:46:25
> > coyote kernel: [26550.456403] sd 0:0:0:0: [sda] Write cache: enabled,
> > read cache: enabled, doesn't support DPO or FUA
>
>It's not obvious from this incomplete dmesg log what HW or driver
>is behind ata1, but if the 2.6.24-rc7 kernel matches the 2.6.24 one,
>
>it should be pata_amd driving a WDC disk:
> > [   30.702887] pata_amd 0000:00:09.0: version 0.3.10
> > [   30.703052] PCI: Setting latency timer of device 0000:00:09.0 to 64
> > [   30.703188] scsi0 : pata_amd
> > [   30.709313] scsi1 : pata_amd
> > [   30.710076] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000
> > irq 14 [   30.710079] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
> > 0xf008 irq 15 [   30.864753] ata1.00: ATA-6: WDC WD2000JB-00EVA0,
> > 15.05R15, max UDMA/100 [   30.864756] ata1.00: 390721968 sectors, multi
> > 16: LBA48
> > [   30.871629] ata1.00: configured for UDMA/100
>
>Unfortunately we also see:
> > [   48.285456] nvidia: module license 'NVIDIA' taints kernel.
> > [   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI
> > 19 (level, high) -> IRQ 20 [   48.550149] NVRM: loading NVIDIA UNIX x86
> > Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
>
>We have no way of debugging that module, so please try 2.6.24 without it.

Sorry, I can't do this and have a working machine.  The nv driver has suffered 
bit rot or something since the FC2 days when it COULD run a 19" crt at 
1600x1200, and will not drive this 20" wide screen lcd 1680x1050 monitor at 
more than 800x600, which is absolutely butt ugly fuzzy, looking like a jpg 
compressed to 10%.  The system is not usable on a day to basis without the 
nvidia driver.

Fix the nv driver so it will run this screen at its native resolution and I'll 
be glad to run it even if it won't run google earth, which I do use from time 
to time.  Now, if in all the hits you can get from google on this, currently 
14,800 just for 'exception Emask', apparently caused by a timeout, if 100% of 
the complainers are running nvidia drivers also, then I see a legit 
complaint.  Again, fix the nv driver so it will run my screen & I'll be glad 
to switch.  I can see the reason, sure, but the machine must be capable of 
doing its common day to day stuff, while using that driver, like running kde 
for kmail, and browsers that work.

>If the problems persist, please try to capture a complete log from the
>failing kernel -- the interesting bits are everything from initial boot
>up to and including the first few errors. You may need to increase the
>kernel's log buffer size if the log gets truncated (CONFIG_LOG_BUF_SHIFT).

If by log you mean /var/log/messages, I have several megabytes of those.
If you mean a live dmesg capture taken right now, its attached. It contains 
several of these at the bottom.  I long ago made the kernel log buffer 
bigger, cuz it couldn't even show the start immediately after the boot, and 
even the dump to syslog was truncated.

>There are no pata_amd changes from 2.6.24-rc7 to 2.6.24 final.

That is what I was afraid of.  I've done some limited grepping in that branch 
of the kernel tree, and cannot seem to locate where this EH handler is being 
invoked from.

There is 2 lines of interest in the dmesg:

[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override

But I have NDI what it means, kernel argument/xconfig option?

I've also done some googling, and it appears this problem is fairly widespread 
since the switchover to libata was encouraged.  A stock fedora F8 kernel 
suffers the same freezes and eventually locks up, but does it without the 
error messages being logged, it just freezes, feeling identical to this in 
the minutes before the total freeze.  I've tried 2 of those too, but the 
newest one won't even run X.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Ada is PL/I trying to be Smalltalk.
-- Codoso diBlini

--Boundary-00=_CRgnHlCwc4ypVHQ
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.24-rc7 (root@coyote.coyote.den) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Mon Jan 14 10:00:40 EST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32497 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP 000F7220, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 3FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF30C0, 4CC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: APIC 3FFF7DC0, 006E (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:10 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c073a000 soft=c071a000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2079.551 MHz processor.
[   28.725256] Console: colour VGA+ 80x25
[   28.725259] console [tty0] enabled
[   28.725828] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   28.726361] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   28.756701] Memory: 1031116k/1048512k available (1938k kernel code, 16656k reserved, 967k data, 236k init, 131008k highmem)
[   28.756710] virtual kernel memory layout:
[   28.756711]     fixmap  : 0xffc55000 - 0xfffff000   (3752 kB)
[   28.756713]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   28.756714]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   28.756715]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   28.756716]       .init : 0xc06dc000 - 0xc0717000   ( 236 kB)
[   28.756718]       .data : 0xc05e4944 - 0xc06d66e4   ( 967 kB)
[   28.756719]       .text : 0xc0400000 - 0xc05e4944   (1938 kB)
[   28.756722] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   28.756770] SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   28.816731] Calibrating delay using timer specific routine.. 4160.90 BogoMIPS (lpj=2080452)
[   28.816763] Security Framework initialized
[   28.816770] SELinux:  Initializing.
[   28.816784] SELinux:  Starting in permissive mode
[   28.816797] selinux_register_security:  Registering secondary module capability
[   28.816800] Capability LSM initialized as secondary
[   28.816809] Mount-cache hash table entries: 512
[   28.816976] CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000 00000000
[   28.816985] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   28.816987] CPU: L2 Cache: 512K (64 bytes/line)
[   28.816990] CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000 00000000
[   28.816996] Intel machine check architecture supported.
[   28.816998] Intel machine check reporting enabled on CPU#0.
[   28.817003] Compat vDSO mapped to ffffe000.
[   28.817017] Checking 'hlt' instruction... OK.
[   28.820895] SMP alternatives: switching to UP code
[   28.821401] Freeing SMP alternatives: 12k freed
[   28.821404] ACPI: Core revision 20070126
[   28.824590] CPU0: AMD Athlon(tm) XP 2800+ stepping 00
[   28.824614] Total of 1 processors activated (4160.90 BogoMIPS).
[   28.824820] ENABLING IO-APIC IRQs
[   28.825012] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[   28.936680] Brought up 1 CPUs
[   28.936708] CPU0 attaching sched-domain:
[   28.936711]  domain 0: span 00000001
[   28.936713]   groups: 00000001
[   28.936925] net_namespace: 64 bytes
[   28.937409] Time: 12:43:09  Date: 01/28/08
[   28.937442] NET: Registered protocol family 16
[   28.937683] ACPI: bus type pci registered
[   28.972986] PCI: PCI BIOS revision 2.10 entry at 0xfb4c0, last bus=2
[   28.972989] PCI: Using configuration type 1
[   28.972991] Setting up standard PCI resources
[   28.980763] ACPI: EC: Look up EC in DSDT
[   28.986590] ACPI: Interpreter enabled
[   28.986593] ACPI: (supports S0 S1 S4 S5)
[   28.986608] ACPI: Using IOAPIC for interrupt routing
[   28.997079] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   28.997157] PCI: nForce2 C1 Halt Disconnect fixup
[   28.998175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   28.998355] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   28.998631] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
[   29.054757] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   29.054952] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   29.055144] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   29.055334] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   29.055529] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.055724] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   29.055918] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   29.056109] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   29.056298] ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.056489] ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   29.056685] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.056876] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.057066] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   29.057258] ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.057448] ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.057642] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   29.057803] ACPI: PCI Interrupt Link [APC1] (IRQs *16)
[   29.057951] ACPI: PCI Interrupt Link [APC2] (IRQs *17)
[   29.058099] ACPI: PCI Interrupt Link [APC3] (IRQs *18)
[   29.058246] ACPI: PCI Interrupt Link [APC4] (IRQs *19)
[   29.058402] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[   29.058617] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
[   29.058827] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
[   29.059036] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
[   29.059245] ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
[   29.059454] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
[   29.059669] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
[   29.059819] ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
[   29.060028] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
[   29.060236] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
[   29.060446] ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
[   29.060661] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
[   29.060822] ACPI: Power Resource [ISAV] (on)
[   29.060880] Linux Plug and Play Support v0.97 (c) Adam Belay
[   29.060917] pnp: PnP ACPI init
[   29.060926] ACPI: bus type pnp registered
[   29.066989] pnp: PnP ACPI: found 16 devices
[   29.066992] ACPI: ACPI bus type pnp unregistered
[   29.067179] usbcore: registered new interface driver usbfs
[   29.067257] usbcore: registered new interface driver hub
[   29.067309] usbcore: registered new device driver usb
[   29.067395] PCI: Using ACPI for IRQ routing
[   29.067399] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   29.117453] NetLabel: Initializing
[   29.117455] NetLabel:  domain hash size = 128
[   29.117457] NetLabel:  protocols = UNLABELED CIPSOv4
[   29.117471] NetLabel:  unlabeled traffic allowed by default
[   29.118443] Time: tsc clocksource has been installed.
[   29.120481] system 00:00: ioport range 0x4000-0x407f has been reserved
[   29.120484] system 00:00: ioport range 0x4080-0x40ff has been reserved
[   29.120487] system 00:00: ioport range 0x4400-0x447f has been reserved
[   29.120490] system 00:00: ioport range 0x4480-0x44ff has been reserved
[   29.120492] system 00:00: ioport range 0x4200-0x427f has been reserved
[   29.120495] system 00:00: ioport range 0x4280-0x42ff has been reserved
[   29.120502] system 00:01: ioport range 0x5000-0x503f has been reserved
[   29.120505] system 00:01: ioport range 0x5100-0x513f has been reserved
[   29.120511] system 00:02: iomem range 0xda800-0xdbfff has been reserved
[   29.120514] system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
[   29.120516] system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
[   29.120519] system 00:02: iomem range 0xfc000-0xfffff could not be reserved
[   29.120522] system 00:02: iomem range 0x3fff0000-0x3fffffff could not be reserved
[   29.120525] system 00:02: iomem range 0xffff0000-0xffffffff could not be reserved
[   29.120528] system 00:02: iomem range 0x0-0x9ffff could not be reserved
[   29.120531] system 00:02: iomem range 0x100000-0x3ffeffff could not be reserved
[   29.120534] system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
[   29.120537] system 00:02: iomem range 0xfee00000-0xfee00fff could not be reserved
[   29.120543] system 00:04: ioport range 0xb78-0xb7b has been reserved
[   29.120546] system 00:04: ioport range 0xf78-0xf7b has been reserved
[   29.120548] system 00:04: ioport range 0xa78-0xa7b has been reserved
[   29.120551] system 00:04: ioport range 0xe78-0xe7b has been reserved
[   29.120554] system 00:04: ioport range 0xbbc-0xbbf has been reserved
[   29.120556] system 00:04: ioport range 0xfbc-0xfbf has been reserved
[   29.120559] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[   29.120562] system 00:04: ioport range 0x294-0x297 has been reserved
[   29.151040] PCI: Bridge: 0000:00:08.0
[   29.151044]   IO window: 9000-afff
[   29.151049]   MEM window: e3000000-e6ffffff
[   29.151053]   PREFETCH window: 50000000-500fffff
[   29.151058] PCI: Bridge: 0000:00:1e.0
[   29.151059]   IO window: disabled.
[   29.151063]   MEM window: e0000000-e2ffffff
[   29.151066]   PREFETCH window: d0000000-dfffffff
[   29.151077] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   29.151093] NET: Registered protocol family 2
[   29.160585] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   29.160952] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   29.162429] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   29.163092] TCP: Hash tables configured (established 131072 bind 65536)
[   29.163095] TCP reno registered
[   29.165574] checking if image is initramfs... it is
[   29.446295] Freeing initrd memory: 3628k freed
[   29.446709] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   29.446712] apm: overridden by ACPI.
[   29.447133] audit: initializing netlink socket (disabled)
[   29.447149] audit(1201524188.569:1): initialized
[   29.447287] highmem bounce pool size: 64 pages
[   29.447291] Total HugeTLB memory allocated, 0
[   29.449941] SELinux:  Registering netfilter hooks
[   29.450082] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   29.450086] io scheduler noop registered
[   29.450088] io scheduler anticipatory registered
[   29.450090] io scheduler deadline registered
[   29.450101] io scheduler cfq registered (default)
[   29.472109] Boot video device is 0000:02:00.0
[   29.477398] ACPI: Thermal Zone [THRM] (51 C)
[   29.477413] isapnp: Scanning for PnP cards...
[   29.650914] Switched to high resolution mode on CPU 0
[   29.834322] isapnp: No Plug & Play device found
[   29.837157] Real Time Clock Driver v1.12ac
[   29.837309] Non-volatile memory driver v1.2
[   29.837312] Linux agpgart interface v0.102
[   29.837365] agpgart: Detected NVIDIA nForce2 chipset
[   29.853228] agpgart: AGP aperture is 256M @ 0xc0000000
[   29.853255] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   29.853403] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.853542] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   29.853854] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.854037] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   29.855000] RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
[   29.855188] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   29.855191] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   29.855565] serio: i8042 KBD port at 0x60,0x64 irq 1
[   29.855638] mice: PS/2 mouse device common for all mice
[   29.876081] input: AT Translated Set 2 keyboard as /class/input/input0
[   29.878901] cpuidle: using governor ladder
[   29.878904] cpuidle: using governor menu
[   29.878982] usbcore: registered new interface driver hiddev
[   29.879024] usbcore: registered new interface driver usbhid
[   29.879027] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   29.879098] TCP cubic registered
[   29.879100] Initializing XFRM netlink socket
[   29.879180] NET: Registered protocol family 1
[   29.879196] NET: Registered protocol family 17
[   29.879204] Using IPI No-Shortcut mode
[   29.879217] registered taskstats version 1
[   29.879349]   Magic number: 8:30:735
[   29.879657] Freeing unused kernel memory: 236k freed
[   29.879695] Write protecting the kernel text: 1940k
[   29.879708] Write protecting the kernel read-only data: 758k
[   30.175117] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   30.175126] ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 22 (level, high) -> IRQ 16
[   30.175139] PCI: Setting latency timer of device 0000:00:02.2 to 64
[   30.175143] ehci_hcd 0000:00:02.2: EHCI Host Controller
[   30.175235] ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
[   30.175275] ehci_hcd 0000:00:02.2: debug port 1
[   30.175280] PCI: cache line size of 64 is not supported by device 0000:00:02.2
[   30.175291] ehci_hcd 0000:00:02.2: irq 16, io mem 0xe7005000
[   30.180677] ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   30.180795] usb usb1: configuration #1 chosen from 1 choice
[   30.180823] hub 1-0:1.0: USB hub found
[   30.180834] hub 1-0:1.0: 6 ports detected
[   30.287626] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   30.288031] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   30.288038] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, high) -> IRQ 17
[   30.288052] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   30.288055] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   30.288129] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   30.288148] ohci_hcd 0000:00:02.0: irq 17, io mem 0xe7003000
[   30.340664] usb usb2: configuration #1 chosen from 1 choice
[   30.340691] hub 2-0:1.0: USB hub found
[   30.340704] hub 2-0:1.0: 3 ports detected
[   30.441860] ACPI: PCI Interrupt Link [APCG] enabled at IRQ 20
[   30.441865] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 20 (level, high) -> IRQ 18
[   30.441873] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   30.441876] ohci_hcd 0000:00:02.1: OHCI Host Controller
[   30.441932] ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
[   30.441945] ohci_hcd 0000:00:02.1: irq 18, io mem 0xe7004000
[   30.487468] usb 1-1: new high speed USB device using ehci_hcd and address 2
[   30.494540] usb usb3: configuration #1 chosen from 1 choice
[   30.494569] hub 3-0:1.0: USB hub found
[   30.494579] hub 3-0:1.0: 3 ports detected
[   30.601427] USB Universal Host Controller Interface driver v3.0
[   30.601865] usb 1-1: configuration #1 chosen from 1 choice
[   30.602052] hub 1-1:1.0: USB hub found
[   30.602151] hub 1-1:1.0: 4 ports detected
[   30.660576] SCSI subsystem initialized
[   30.673851] Driver 'sd' needs updating - please use bus_type methods
[   30.700319] libata version 3.00 loaded.
[   30.702887] pata_amd 0000:00:09.0: version 0.3.10
[   30.703052] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   30.703188] scsi0 : pata_amd
[   30.709313] scsi1 : pata_amd
[   30.710076] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   30.710079] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   30.864753] ata1.00: ATA-6: WDC WD2000JB-00EVA0, 15.05R15, max UDMA/100
[   30.864756] ata1.00: 390721968 sectors, multi 16: LBA48 
[   30.871629] ata1.00: configured for UDMA/100
[   31.195305] ata2.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS06, max UDMA/66
[   31.243813] ata2.01: ATA-7: MAXTOR STM3320620A, 3.AAE, max UDMA/100
[   31.243816] ata2.01: 625142448 sectors, multi 16: LBA48 
[   31.243825] ata2.00: limited to UDMA/33 due to 40-wire cable
[   31.417074] ata2.00: configured for UDMA/33
[   31.451769] ata2.01: configured for UDMA/100
[   31.451873] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00E 15.0 PQ: 0 ANSI: 5
[   31.451953] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   31.451967] sd 0:0:0:0: [sda] Write Protect is off
[   31.451970] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   31.451989] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   31.452040] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   31.452051] sd 0:0:0:0: [sda] Write Protect is off
[   31.452054] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   31.452071] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   31.452075]  sda: sda1 sda2
[   31.467219] sd 0:0:0:0: [sda] Attached SCSI disk
[   31.468093] scsi 1:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS06 PQ: 0 ANSI: 5
[   31.468208] scsi 1:0:1:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
[   31.468272] sd 1:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[   31.468283] sd 1:0:1:0: [sdb] Write Protect is off
[   31.468286] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   31.468303] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   31.468338] sd 1:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[   31.468349] sd 1:0:1:0: [sdb] Write Protect is off
[   31.468352] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   31.468370] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   31.468373]  sdb:<6>usb 2-2: new full speed USB device using ohci_hcd and address 2
[   31.499690]  sdb1 sdb2 sdb3
[   31.500119] sd 1:0:1:0: [sdb] Attached SCSI disk
[   31.637428] usb 2-2: configuration #1 chosen from 1 choice
[   31.856522] usb 2-3: new low speed USB device using ohci_hcd and address 3
[   32.020045] usb 2-3: configuration #1 chosen from 1 choice
[   32.035222] input: Chicony Saitek Eclipse II Keyboard as /class/input/input1
[   32.038424] input,hidraw0: USB HID v1.11 Keyboard [Chicony Saitek Eclipse II Keyboard] on usb-0000:00:02.0-3
[   32.067995] input: Chicony Saitek Eclipse II Keyboard as /class/input/input2
[   32.070422] input,hiddev96,hidraw1: USB HID v1.11 Device [Chicony Saitek Eclipse II Keyboard] on usb-0000:00:02.0-3
[   32.287225] usb 3-3: new full speed USB device using ohci_hcd and address 2
[   32.422699] usb 3-3: configuration #1 chosen from 1 choice
[   32.425658] hub 3-3:1.0: USB hub found
[   32.428631] hub 3-3:1.0: 4 ports detected
[   32.724000] usb 1-1.1: new low speed USB device using ehci_hcd and address 6
[   32.919001] usb 1-1.1: configuration #1 chosen from 1 choice
[   33.655893] hiddev97hidraw2: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:02.2-1.1
[   33.833315] usb 1-1.2: new full speed USB device using ehci_hcd and address 7
[   33.925926] usb 1-1.2: configuration #1 chosen from 1 choice
[   34.018028] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   34.043070] sata_sil 0000:01:0a.0: version 2.3
[   34.043348] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   34.043355] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC1] -> GSI 16 (level, high) -> IRQ 19
[   34.045029] scsi2 : sata_sil
[   34.050031] scsi3 : sata_sil
[   34.050064] ata3: SATA max UDMA/100 mmio m512@0xe6004000 tf 0xe6004080 irq 19
[   34.050068] ata4: SATA max UDMA/100 mmio m512@0xe6004000 tf 0xe60040c0 irq 19
[   34.107056] usb 1-1.4: new high speed USB device using ehci_hcd and address 8
[   34.192310] usb 1-1.4: configuration #1 chosen from 1 choice
[   34.192499] hub 1-1.4:1.0: USB hub found
[   34.192597] hub 1-1.4:1.0: 4 ports detected
[   34.352811] ata3: SATA link down (SStatus 0 SControl 310)
[   34.481823] usb 1-1.4.3: new low speed USB device using ehci_hcd and address 9
[   34.573676] usb 1-1.4.3: configuration #1 chosen from 1 choice
[   34.577917] input: Logitech USB Receiver as /class/input/input3
[   34.580691] input,hidraw3: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.2-1.4.3
[   34.757557] usb 1-1.4.4: new full speed USB device using ehci_hcd and address 10
[   34.806514] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   34.810071] ata4.00: ATA-7: Hitachi HDT725040VLA360, V5COA7EA, max UDMA/133
[   34.810074] ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   34.816059] ata4.00: configured for UDMA/100
[   34.816175] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5CO PQ: 0 ANSI: 5
[   34.816257] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
[   34.816271] sd 3:0:0:0: [sdc] Write Protect is off
[   34.816274] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   34.816293] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.816344] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
[   34.816355] sd 3:0:0:0: [sdc] Write Protect is off
[   34.816358] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   34.816375] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.816379]  sdc: sdc1
[   34.829837] sd 3:0:0:0: [sdc] Attached SCSI disk
[   34.843933] usb 1-1.4.4: configuration #1 chosen from 1 choice
[   37.852458] EXT3-fs: INFO: recovery required on readonly filesystem.
[   37.852464] EXT3-fs: write access will be enabled during recovery.
[   41.522866] kjournald starting.  Commit interval 5 seconds
[   41.522885] EXT3-fs: recovery complete.
[   41.524254] EXT3-fs: mounted filesystem with ordered data mode.
[   41.972449] audit(1201524201.103:2): enforcing=1 old_enforcing=0 auid=4294967295
[   42.187011] SELinux:8192 avtab hash slots allocated.Num of rules:213166
[   42.260611] SELinux:8192 avtab hash slots allocated.Num of rules:213166
[   42.314117] security:  8 users, 11 roles, 2363 types, 114 bools, 1 sens, 1024 cats
[   42.314122] security:  67 classes, 213166 rules
[   42.327287] SELinux:  Completing initialization.
[   42.327290] SELinux:  Setting up existing superblocks.
[   42.353550] SELinux: initialized (dev dm-0, type ext3), uses xattr
[   42.515071] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   42.515088] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   42.515193] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   42.515205] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   42.515235] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   42.515244] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   42.515250] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   42.515262] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   42.515266] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   42.515274] SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
[   42.515280] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   42.515285] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   42.515290] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   42.515299] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   42.515312] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   42.515318] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   42.515341] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   42.520002] SELinux: policy loaded with handle_unknown=allow
[   42.520011] audit(1201524201.651:3): policy loaded auid=4294967295
[   46.528101] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   46.528126] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   46.528149] sd 1:0:1:0: Attached scsi generic sg2 type 0
[   46.528174] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   46.931288] input: Power Button (FF) as /class/input/input4
[   46.938141] ACPI: Power Button (FF) [PWRF]
[   46.938186] ACPI Error (evxfevnt-0186): Could not enable SleepButton event [20070126]
[   46.938192] ACPI Warning (evxface-0145): Could not enable fixed event 3 [20070126]
[   46.938283] input: Power Button (CM) as /class/input/input5
[   46.941132] ACPI: Power Button (CM) [PWRB]
[   46.941190] input: Sleep Button (CM) as /class/input/input6
[   46.944347] ACPI: Sleep Button (CM) [SLPB]
[   47.285717] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
[   47.285742] usbcore: registered new interface driver usblp
[   47.308848] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
[   47.308876] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5100
[   47.352146] usbcore: registered new interface driver usbserial
[   47.352152] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   47.455275] drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
[   47.455308] ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
[   47.455342] drivers/usb/serial/ftdi_sio.c: Detected FT232RL
[   47.455381] usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0
[   47.455398] usbcore: registered new interface driver ftdi_sio
[   47.455401] drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
[   47.530751] input: PC Speaker as /class/input/input7
[   47.572764] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   47.573147] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[   47.573151] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 16
[   47.573158] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   47.615492] Floppy drive(s): fd0 is 1.44M
[   47.630509] FDC 0 is a post-1991 82077
[   48.084769] forcedeth 0000:00:04.0: ifname eth0, PHY OUI 0x20 @ 1, addr 00:04:4b:5d:eb:7d
[   48.084775] forcedeth 0000:00:04.0: timirq lnktim desc-v1
[   48.085214] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   48.085222] ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 20
[   48.141308] firewire_ohci: Added fw-ohci device 0000:01:09.0, OHCI version 1.10
[   48.285456] nvidia: module license 'NVIDIA' taints kernel.
[   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 20
[   48.550149] NVRM: loading NVIDIA UNIX x86 Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
[   48.641028] firewire_core: created new fw device fw0 (0 config rom retries, S400)
[   48.848094] Linux video capture interface: v2.00
[   49.104974] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   49.105072] cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected]
[   49.105076] cx88[0]: TV tuner type 60, Radio tuner type -1
[   49.151205] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   49.255507] cx88[0]/2: cx2388x 8802 Driver Manager
[   49.257461] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   49.257472] ACPI: PCI Interrupt 0000:01:07.2[A] -> Link [APC2] -> GSI 17 (level, high) -> IRQ 21
[   49.257484] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 21, latency: 32, mmio: 0xe4000000
[   49.257561] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC2] -> GSI 17 (level, high) -> IRQ 21
[   49.257573] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 21, latency: 32, mmio: 0xe3000000
[   49.440179] tda8290_probe: not probed - driver disabled by Kconfig
[   49.440185] tuner 2-0043: chip found @ 0x86 (cx88[0])
[   49.440208] tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner)
[   49.440211] tuner 2-0043: type set to tda9887
[   49.442442] tuner 2-0061: chip found @ 0xc2 (cx88[0])
[   49.442458] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   49.442461] tuner 2-0061: type set to Thomson DTT 761X (A
[   49.442464] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   49.442466] tuner 2-0061: type set to Thomson DTT 761X (A
[   49.451016] cx88[0]/0: registered device video0 [v4l2]
[   49.451038] cx88[0]/0: registered device vbi0
[   49.451064] cx88[0]/0: registered device radio0
[   49.454722] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   49.454731] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 22
[   49.459555] Audigy2 value: Special config.
[   49.532042] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   49.532047] cx88/2: registering cx8802 driver, type: dvb access: shared
[   49.532052] cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
[   49.532055] cx88[0]/2: cx2388x based DVB/ATSC card
[   49.548119] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 21
[   49.548125] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 21 (level, high) -> IRQ 17
[   49.548162] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   49.654575] DVB: registering new adapter (cx88[0])
[   49.654582] DVB: registering frontend 0 (Oren OR51132 VSB/QAM Frontend)...
[   49.859126] intel8x0_measure_ac97_clock: measured 50668 usecs
[   49.859131] intel8x0: clocking to 47378
[   52.910654] EXT3 FS on dm-0, internal journal
[   53.162621] kjournald starting.  Commit interval 5 seconds
[   53.170013] EXT3 FS on sda1, internal journal
[   53.170019] EXT3-fs: mounted filesystem with ordered data mode.
[   53.170144] SELinux: initialized (dev sda1, type ext3), uses xattr
[   53.170540] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   53.174936] kjournald starting.  Commit interval 5 seconds
[   53.182987] EXT3 FS on sdc1, internal journal
[   53.182992] EXT3-fs: mounted filesystem with ordered data mode.
[   53.188827] SELinux: initialized (dev sdc1, type ext3), uses xattr
[   54.005729] Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
[   54.009417] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   54.393108] warning: process `kudzu' used the deprecated sysctl system call with 1.23.
[   54.885156] NET: Registered protocol family 10
[   54.885386] lo: Disabled Privacy Extensions
[   60.537079] RPC: Registered udp transport module.
[   60.537083] RPC: Registered tcp transport module.
[   60.540347] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   61.293946] w83627hf: Found W83627HF chip at 0x290
[   61.812622] audit(1201524221.948:4): audit_pid=1910 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
[   63.746132] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   64.231812] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   64.362173] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   66.015990] eth0: no IPv6 routers present
[  147.668171] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[  147.668186] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
[  147.668257] agpgart: Putting AGP V3 device at 0000:02:00.0 into 8x mode
[ 1712.473539] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 1712.473551] ata1.00: cmd 35/00:18:59:22:a2/00:00:12:00:00/e0 tag 0 dma 12288 out
[ 1712.473553]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1712.473556] ata1.00: status: { DRDY }
[ 1712.473584] ata1: soft resetting link
[ 1712.635816] ata1.00: configured for UDMA/100
[ 1712.635832] ata1: EH complete
[ 1712.636296] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 1712.636447] sd 0:0:0:0: [sda] Write Protect is off
[ 1712.636452] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1712.636698] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1772.618397] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 1772.618409] ata1.00: cmd ca/00:08:b9:85:68/00:00:00:00:00/e8 tag 0 dma 4096 out
[ 1772.618410]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1772.618414] ata1.00: status: { DRDY }
[ 1772.618441] ata1: soft resetting link
[ 1772.780653] ata1.00: configured for UDMA/100
[ 1772.780669] ata1: EH complete
[ 1772.804931] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 1772.812120] sd 0:0:0:0: [sda] Write Protect is off
[ 1772.812125] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1772.848506] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 8943.320830] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 8943.320842] ata1.00: cmd 35/00:18:59:22:a2/00:00:12:00:00/e0 tag 0 dma 12288 out
[ 8943.320844]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 8943.320847] ata1.00: status: { DRDY }
[ 8943.320874] ata1: soft resetting link
[ 8943.483114] ata1.00: configured for UDMA/100
[ 8943.483129] ata1: EH complete
[ 8943.483585] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 8943.483738] sd 0:0:0:0: [sda] Write Protect is off
[ 8943.483743] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 8943.483993] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--Boundary-00=_CRgnHlCwc4ypVHQ--
