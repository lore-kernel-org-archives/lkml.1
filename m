Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYA1RAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYA1RAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbYA1RAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:00:36 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:49735 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYA1RAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:00:33 -0500
Date: Mon, 28 Jan 2008 11:56:28 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <200801281135.14555.gene.heskett@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281156.28844.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_8kgnH7YqN15XXyY"
References: <200801272122.21823.gene.heskett@gmail.com>
 <18333.57152.472830.608248@harpo.it.uu.se>
 <200801281135.14555.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8kgnH7YqN15XXyY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 28 January 2008, Gene Heskett wrote:
While reading this msg as it came back, I locked up again and rebooted to 
2.6.24, and got lucky (maybe) as the attached dmesg will show quite a few 
instances of this LOOOONNNGG before the nvidia driver is loaded to taint the 
kernel.  Have fun guys!
 
>On Monday 28 January 2008, Mikael Pettersson wrote:
>>Gene Heskett writes:
>> > On Monday 28 January 2008, Peter Zijlstra wrote:
>> > >On Mon, 2008-01-28 at 09:17 +0100, Mikael Pettersson wrote:
>> > >> 1. Wrong mailing list; use linux-ide (@vger) instead.
>> > >
>> > >What, and keep all us other interested people in the dark?
>> >
>> > As a test, I tried rebooting to the latest fedora kernel and found it
>> > kills X, so I'm back to the second to last fedora version ATM, and the
>> > third 'smartctl -t lng /dev/sda' in 24 hours is running now.  The first
>> > two completed with no errors.
>> >
>> > I've added the linux-ide list to refresh those people of the problem,
>> > the logs are being spammed by this message stanza:
>> >
>> >  Jan 28 04:46:25 coyote kernel: [26550.290016] ata1.00: exception Emask
>> > 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 28 04:46:25 coyote kernel:
>> > [26550.290028] ata1.00: cmd 35/00:58:c9:9c:0a/00:01:00:00:00/e0 tag 0
>> > dma 176128 out Jan 28 04:46:25 coyote kernel: [26550.290029]         
>> > res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 28
>> > 04:46:25 coyote kernel: [26550.290032] ata1.00: status: { DRDY } Jan 28
>> > 04:46:25 coyote kernel: [26550.290060] ata1: soft resetting link Jan 28
>> > 04:46:25 coyote kernel: [26550.452301] ata1.00: configured for UDMA/100
>> > Jan 28 04:46:25 coyote kernel: [26550.452318] ata1: EH complete
>> > Jan 28 04:46:25 coyote kernel: [26550.455898] sd 0:0:0:0: [sda]
>> > 390721968 512-byte hardware sectors (200050 MB) Jan 28 04:46:25 coyote
>> > kernel: [26550.456151] sd 0:0:0:0: [sda] Write Protect is off Jan 28
>> > 04:46:25 coyote kernel: [26550.456403] sd 0:0:0:0: [sda] Write cache:
>> > enabled, read cache: enabled, doesn't support DPO or FUA
>>
>>It's not obvious from this incomplete dmesg log what HW or driver
>>is behind ata1, but if the 2.6.24-rc7 kernel matches the 2.6.24 one,
>>
>>it should be pata_amd driving a WDC disk:
>> > [   30.702887] pata_amd 0000:00:09.0: version 0.3.10
>> > [   30.703052] PCI: Setting latency timer of device 0000:00:09.0 to 64
>> > [   30.703188] scsi0 : pata_amd
>> > [   30.709313] scsi1 : pata_amd
>> > [   30.710076] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000
>> > irq 14 [   30.710079] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
>> > 0xf008 irq 15 [   30.864753] ata1.00: ATA-6: WDC WD2000JB-00EVA0,
>> > 15.05R15, max UDMA/100 [   30.864756] ata1.00: 390721968 sectors, multi
>> > 16: LBA48
>> > [   30.871629] ata1.00: configured for UDMA/100
>>
>>Unfortunately we also see:
>> > [   48.285456] nvidia: module license 'NVIDIA' taints kernel.
>> > [   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI
>> > 19 (level, high) -> IRQ 20 [   48.550149] NVRM: loading NVIDIA UNIX x86
>> > Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
>>
>>We have no way of debugging that module, so please try 2.6.24 without it.
>
>Sorry, I can't do this and have a working machine.  The nv driver has
> suffered bit rot or something since the FC2 days when it COULD run a 19"
> crt at 1600x1200, and will not drive this 20" wide screen lcd 1680x1050
> monitor at more than 800x600, which is absolutely butt ugly fuzzy, looking
> like a jpg compressed to 10%.  The system is not usable on a day to basis
> without the nvidia driver.
>
>Fix the nv driver so it will run this screen at its native resolution and
> I'll be glad to run it even if it won't run google earth, which I do use
> from time to time.  Now, if in all the hits you can get from google on
> this, currently 14,800 just for 'exception Emask', apparently caused by a
> timeout, if 100% of the complainers are running nvidia drivers also, then I
> see a legit complaint.  Again, fix the nv driver so it will run my screen &
> I'll be glad to switch.  I can see the reason, sure, but the machine must
> be capable of doing its common day to day stuff, while using that driver,
> like running kde for kmail, and browsers that work.
>
>>If the problems persist, please try to capture a complete log from the
>>failing kernel -- the interesting bits are everything from initial boot
>>up to and including the first few errors. You may need to increase the
>>kernel's log buffer size if the log gets truncated (CONFIG_LOG_BUF_SHIFT).
>
>If by log you mean /var/log/messages, I have several megabytes of those.
>If you mean a live dmesg capture taken right now, its attached. It contains
>several of these at the bottom.  I long ago made the kernel log buffer
>bigger, cuz it couldn't even show the start immediately after the boot, and
>even the dump to syslog was truncated.
>
>>There are no pata_amd changes from 2.6.24-rc7 to 2.6.24 final.
>
>That is what I was afraid of.  I've done some limited grepping in that
> branch of the kernel tree, and cannot seem to locate where this EH handler
> is being invoked from.
>
>There is 2 lines of interest in the dmesg:
>
>[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
>[    0.000000] If you got timer trouble try acpi_use_timer_override
>
>But I have NDI what it means, kernel argument/xconfig option?
>
>I've also done some googling, and it appears this problem is fairly
> widespread since the switchover to libata was encouraged.  A stock fedora
> F8 kernel suffers the same freezes and eventually locks up, but does it
> without the error messages being logged, it just freezes, feeling identical
> to this in the minutes before the total freeze.  I've tried 2 of those too,
> but the newest one won't even run X.



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Deprive a mirror of its silver and even the Czar won't see his face.

--Boundary-00=_8kgnH7YqN15XXyY
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.24 (root@coyote.coyote.den) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Thu Jan 24 20:17:55 EST 2008
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
[    0.000000] CPU 0 irqstacks, hard=c0743000 soft=c0723000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2079.540 MHz processor.
[   24.833457] Console: colour VGA+ 80x25
[   24.833460] console [tty0] enabled
[   24.834029] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   24.834561] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   24.865989] Memory: 1031080k/1048512k available (1951k kernel code, 16692k reserved, 986k data, 240k init, 131008k highmem)
[   24.865998] virtual kernel memory layout:
[   24.865999]     fixmap  : 0xffc55000 - 0xfffff000   (3752 kB)
[   24.866001]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   24.866002]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   24.866003]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   24.866004]       .init : 0xc06e4000 - 0xc0720000   ( 240 kB)
[   24.866006]       .data : 0xc05e7cd4 - 0xc06de6e4   ( 986 kB)
[   24.866007]       .text : 0xc0400000 - 0xc05e7cd4   (1951 kB)
[   24.866010] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   24.866059] SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   24.926020] Calibrating delay using timer specific routine.. 4160.90 BogoMIPS (lpj=2080453)
[   24.926053] Security Framework initialized
[   24.926059] SELinux:  Initializing.
[   24.926072] SELinux:  Starting in permissive mode
[   24.926086] selinux_register_security:  Registering secondary module capability
[   24.926088] Capability LSM initialized as secondary
[   24.926098] Mount-cache hash table entries: 512
[   24.926267] CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000 00000000
[   24.926275] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   24.926278] CPU: L2 Cache: 512K (64 bytes/line)
[   24.926280] CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000 00000000
[   24.926286] Intel machine check architecture supported.
[   24.926289] Intel machine check reporting enabled on CPU#0.
[   24.926294] Compat vDSO mapped to ffffe000.
[   24.926308] Checking 'hlt' instruction... OK.
[   24.930188] SMP alternatives: switching to UP code
[   24.930705] Freeing SMP alternatives: 13k freed
[   24.930709] ACPI: Core revision 20070126
[   24.933945] CPU0: AMD Athlon(tm) XP 2800+ stepping 00
[   24.933969] Total of 1 processors activated (4160.90 BogoMIPS).
[   24.934176] ENABLING IO-APIC IRQs
[   24.934367] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[   25.045973] Brought up 1 CPUs
[   25.046000] CPU0 attaching sched-domain:
[   25.046003]  domain 0: span 00000001
[   25.046005]   groups: 00000001
[   25.046221] net_namespace: 64 bytes
[   25.046717] Time: 16:50:13  Date: 01/28/08
[   25.046749] NET: Registered protocol family 16
[   25.046994] ACPI: bus type pci registered
[   25.082395] PCI: PCI BIOS revision 2.10 entry at 0xfb4c0, last bus=2
[   25.082398] PCI: Using configuration type 1
[   25.082400] Setting up standard PCI resources
[   25.090219] ACPI: EC: Look up EC in DSDT
[   25.096032] ACPI: Interpreter enabled
[   25.096036] ACPI: (supports S0 S1 S4 S5)
[   25.096050] ACPI: Using IOAPIC for interrupt routing
[   25.106449] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   25.106527] PCI: nForce2 C1 Halt Disconnect fixup
[   25.107549] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   25.107727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   25.107996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
[   25.163644] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   25.163843] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   25.164039] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   25.164230] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   25.164420] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.164612] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   25.164811] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   25.165008] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   25.165200] ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.165392] ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   25.165586] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.165778] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.165977] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   25.166171] ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.166362] ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.166553] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   25.166714] ACPI: PCI Interrupt Link [APC1] (IRQs *16)
[   25.166865] ACPI: PCI Interrupt Link [APC2] (IRQs *17)
[   25.167015] ACPI: PCI Interrupt Link [APC3] (IRQs *18)
[   25.167162] ACPI: PCI Interrupt Link [APC4] (IRQs *19)
[   25.167316] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[   25.167526] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
[   25.167736] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
[   25.167953] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
[   25.168163] ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
[   25.168373] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
[   25.168581] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
[   25.168731] ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
[   25.168945] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
[   25.169154] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
[   25.169363] ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
[   25.169572] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
[   25.169732] ACPI: Power Resource [ISAV] (on)
[   25.169789] Linux Plug and Play Support v0.97 (c) Adam Belay
[   25.169831] pnp: PnP ACPI init
[   25.169840] ACPI: bus type pnp registered
[   25.175979] pnp: PnP ACPI: found 16 devices
[   25.175981] ACPI: ACPI bus type pnp unregistered
[   25.176170] usbcore: registered new interface driver usbfs
[   25.176242] usbcore: registered new interface driver hub
[   25.176292] usbcore: registered new device driver usb
[   25.176405] PCI: Using ACPI for IRQ routing
[   25.176409] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   25.226746] NetLabel: Initializing
[   25.226748] NetLabel:  domain hash size = 128
[   25.226750] NetLabel:  protocols = UNLABELED CIPSOv4
[   25.226762] NetLabel:  unlabeled traffic allowed by default
[   25.227736] Time: tsc clocksource has been installed.
[   25.229773] system 00:00: ioport range 0x4000-0x407f has been reserved
[   25.229777] system 00:00: ioport range 0x4080-0x40ff has been reserved
[   25.229780] system 00:00: ioport range 0x4400-0x447f has been reserved
[   25.229783] system 00:00: ioport range 0x4480-0x44ff has been reserved
[   25.229786] system 00:00: ioport range 0x4200-0x427f has been reserved
[   25.229788] system 00:00: ioport range 0x4280-0x42ff has been reserved
[   25.229795] system 00:01: ioport range 0x5000-0x503f has been reserved
[   25.229798] system 00:01: ioport range 0x5100-0x513f has been reserved
[   25.229804] system 00:02: iomem range 0xda800-0xdbfff has been reserved
[   25.229807] system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
[   25.229812] system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
[   25.229815] system 00:02: iomem range 0xfc000-0xfffff could not be reserved
[   25.229818] system 00:02: iomem range 0x3fff0000-0x3fffffff could not be reserved
[   25.229822] system 00:02: iomem range 0xffff0000-0xffffffff could not be reserved
[   25.229825] system 00:02: iomem range 0x0-0x9ffff could not be reserved
[   25.229828] system 00:02: iomem range 0x100000-0x3ffeffff could not be reserved
[   25.229831] system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
[   25.229834] system 00:02: iomem range 0xfee00000-0xfee00fff could not be reserved
[   25.229840] system 00:04: ioport range 0xb78-0xb7b has been reserved
[   25.229843] system 00:04: ioport range 0xf78-0xf7b has been reserved
[   25.229845] system 00:04: ioport range 0xa78-0xa7b has been reserved
[   25.229848] system 00:04: ioport range 0xe78-0xe7b has been reserved
[   25.229851] system 00:04: ioport range 0xbbc-0xbbf has been reserved
[   25.229854] system 00:04: ioport range 0xfbc-0xfbf has been reserved
[   25.229856] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[   25.229859] system 00:04: ioport range 0x294-0x297 has been reserved
[   25.260349] PCI: Bridge: 0000:00:08.0
[   25.260352]   IO window: 9000-afff
[   25.260357]   MEM window: e3000000-e6ffffff
[   25.260361]   PREFETCH window: 50000000-500fffff
[   25.260366] PCI: Bridge: 0000:00:1e.0
[   25.260368]   IO window: disabled.
[   25.260372]   MEM window: e0000000-e2ffffff
[   25.260375]   PREFETCH window: d0000000-dfffffff
[   25.260385] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   25.260402] NET: Registered protocol family 2
[   25.269888] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   25.270255] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   25.271729] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   25.272478] TCP: Hash tables configured (established 131072 bind 65536)
[   25.272481] TCP reno registered
[   25.274871] checking if image is initramfs... it is
[   25.557129] Freeing initrd memory: 3630k freed
[   25.557552] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   25.557555] apm: overridden by ACPI.
[   25.557974] audit: initializing netlink socket (disabled)
[   25.557991] audit(1201539012.570:1): initialized
[   25.558127] highmem bounce pool size: 64 pages
[   25.558131] Total HugeTLB memory allocated, 0
[   25.560861] SELinux:  Registering netfilter hooks
[   25.560998] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   25.561002] io scheduler noop registered
[   25.561004] io scheduler anticipatory registered
[   25.561007] io scheduler deadline registered
[   25.561018] io scheduler cfq registered (default)
[   25.582401] Boot video device is 0000:02:00.0
[   25.587554] ACPI: Thermal Zone [THRM] (52 C)
[   25.587569] isapnp: Scanning for PnP cards...
[   25.760206] Switched to high resolution mode on CPU 0
[   25.944487] isapnp: No Plug & Play device found
[   25.947347] Real Time Clock Driver v1.12ac
[   25.947500] Non-volatile memory driver v1.2
[   25.947503] Linux agpgart interface v0.102
[   25.947560] agpgart: Detected NVIDIA nForce2 chipset
[   25.963439] agpgart: AGP aperture is 256M @ 0xc0000000
[   25.963465] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   25.963614] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   25.963753] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   25.964066] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   25.964249] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   25.965135] RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
[   25.965395] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   25.965399] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   25.965772] serio: i8042 KBD port at 0x60,0x64 irq 1
[   25.965847] mice: PS/2 mouse device common for all mice
[   25.986718] input: AT Translated Set 2 keyboard as /class/input/input0
[   25.989187] EDAC MC: Ver: 2.1.0 Jan 24 2008
[   25.989315] cpuidle: using governor ladder
[   25.989317] cpuidle: using governor menu
[   25.989396] usbcore: registered new interface driver hiddev
[   25.989433] usbcore: registered new interface driver usbhid
[   25.989437] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   25.989511] TCP cubic registered
[   25.989513] Initializing XFRM netlink socket
[   25.989589] NET: Registered protocol family 1
[   25.989605] NET: Registered protocol family 17
[   25.989612] Using IPI No-Shortcut mode
[   25.989626] registered taskstats version 1
[   25.989754]   Magic number: 8:557:844
[   25.990071] Freeing unused kernel memory: 240k freed
[   25.990110] Write protecting the kernel text: 1952k
[   25.990123] Write protecting the kernel read-only data: 772k
[   26.282400] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   26.282409] ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 22 (level, high) -> IRQ 16
[   26.282422] PCI: Setting latency timer of device 0000:00:02.2 to 64
[   26.282425] ehci_hcd 0000:00:02.2: EHCI Host Controller
[   26.282518] ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
[   26.282557] ehci_hcd 0000:00:02.2: debug port 1
[   26.282563] PCI: cache line size of 64 is not supported by device 0000:00:02.2
[   26.282574] ehci_hcd 0000:00:02.2: irq 16, io mem 0xe7005000
[   26.287965] ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   26.288090] usb usb1: configuration #1 chosen from 1 choice
[   26.288118] hub 1-0:1.0: USB hub found
[   26.288129] hub 1-0:1.0: 6 ports detected
[   26.394914] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   26.395326] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   26.395334] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, high) -> IRQ 17
[   26.395348] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   26.395352] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   26.395426] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   26.395444] ohci_hcd 0000:00:02.0: irq 17, io mem 0xe7003000
[   26.447950] usb usb2: configuration #1 chosen from 1 choice
[   26.447977] hub 2-0:1.0: USB hub found
[   26.447989] hub 2-0:1.0: 3 ports detected
[   26.549147] ACPI: PCI Interrupt Link [APCG] enabled at IRQ 20
[   26.549151] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 20 (level, high) -> IRQ 18
[   26.549159] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   26.549163] ohci_hcd 0000:00:02.1: OHCI Host Controller
[   26.549217] ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
[   26.549230] ohci_hcd 0000:00:02.1: irq 18, io mem 0xe7004000
[   26.594755] usb 1-1: new high speed USB device using ehci_hcd and address 2
[   26.601832] usb usb3: configuration #1 chosen from 1 choice
[   26.601856] hub 3-0:1.0: USB hub found
[   26.601866] hub 3-0:1.0: 3 ports detected
[   26.708712] USB Universal Host Controller Interface driver v3.0
[   26.709142] usb 1-1: configuration #1 chosen from 1 choice
[   26.709206] hub 1-1:1.0: USB hub found
[   26.709309] hub 1-1:1.0: 4 ports detected
[   26.767866] SCSI subsystem initialized
[   26.786664] Driver 'sd' needs updating - please use bus_type methods
[   26.804629] libata version 3.00 loaded.
[   26.810772] pata_amd 0000:00:09.0: version 0.3.10
[   26.810934] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   26.811069] scsi0 : pata_amd
[   26.816599] scsi1 : pata_amd
[   26.817343] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   26.817347] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   26.972040] ata1.00: ATA-6: WDC WD2000JB-00EVA0, 15.05R15, max UDMA/100
[   26.972044] ata1.00: 390721968 sectors, multi 16: LBA48 
[   26.978917] ata1.00: configured for UDMA/100
[   27.302587] ata2.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS06, max UDMA/66
[   27.346091] ata2.01: ATA-7: MAXTOR STM3320620A, 3.AAE, max UDMA/100
[   27.346094] ata2.01: 625142448 sectors, multi 16: LBA48 
[   27.346103] ata2.00: limited to UDMA/33 due to 40-wire cable
[   27.519360] ata2.00: configured for UDMA/33
[   27.554043] ata2.01: configured for UDMA/100
[   27.554146] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00E 15.0 PQ: 0 ANSI: 5
[   27.554222] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   27.554236] sd 0:0:0:0: [sda] Write Protect is off
[   27.554239] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.554259] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.554310] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   27.554321] sd 0:0:0:0: [sda] Write Protect is off
[   27.554324] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.554343] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.554347]  sda: sda1 sda2
[   27.576777] sd 0:0:0:0: [sda] Attached SCSI disk
[   27.577661] scsi 1:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS06 PQ: 0 ANSI: 5
[   27.577772] scsi 1:0:1:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
[   27.577837] sd 1:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[   27.577849] sd 1:0:1:0: [sdb] Write Protect is off
[   27.577852] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   27.577871] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.577920] sd 1:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[   27.577932] sd 1:0:1:0: [sdb] Write Protect is off
[   27.577934] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   27.577953] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.577956]  sdb:<6>usb 2-2: new full speed USB device using ohci_hcd and address 2
[   27.601964]  sdb1 sdb2 sdb3
[   27.602376] sd 1:0:1:0: [sdb] Attached SCSI disk
[   27.744716] usb 2-2: configuration #1 chosen from 1 choice
[   27.963802] usb 2-3: new low speed USB device using ohci_hcd and address 3
[   28.127327] usb 2-3: configuration #1 chosen from 1 choice
[   28.142509] input: Chicony Saitek Eclipse II Keyboard as /class/input/input1
[   28.146698] input,hidraw0: USB HID v1.11 Keyboard [Chicony Saitek Eclipse II Keyboard] on usb-0000:00:02.0-3
[   28.175283] input: Chicony Saitek Eclipse II Keyboard as /class/input/input2
[   28.178705] input,hiddev96,hidraw1: USB HID v1.11 Device [Chicony Saitek Eclipse II Keyboard] on usb-0000:00:02.0-3
[   28.395503] usb 3-3: new full speed USB device using ohci_hcd and address 2
[   28.530990] usb 3-3: configuration #1 chosen from 1 choice
[   28.533944] hub 3-3:1.0: USB hub found
[   28.536917] hub 3-3:1.0: 4 ports detected
[   28.832282] usb 1-1.1: new low speed USB device using ehci_hcd and address 6
[   29.020294] usb 1-1.1: configuration #1 chosen from 1 choice
[   29.782033] hiddev97hidraw2: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:02.2-1.1
[   29.959457] usb 1-1.2: new full speed USB device using ehci_hcd and address 7
[   30.052190] usb 1-1.2: configuration #1 chosen from 1 choice
[   30.128397] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   30.152335] sata_sil 0000:01:0a.0: version 2.3
[   30.152614] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   30.152622] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC1] -> GSI 16 (level, high) -> IRQ 19
[   30.158281] scsi2 : sata_sil
[   30.158336] scsi3 : sata_sil
[   30.158370] ata3: SATA max UDMA/100 mmio m512@0xe6004000 tf 0xe6004080 irq 19
[   30.158375] ata4: SATA max UDMA/100 mmio m512@0xe6004000 tf 0xe60040c0 irq 19
[   30.233321] usb 1-1.4: new high speed USB device using ehci_hcd and address 8
[   30.318569] usb 1-1.4: configuration #1 chosen from 1 choice
[   30.318637] hub 1-1.4:1.0: USB hub found
[   30.318738] hub 1-1.4:1.0: 4 ports detected
[   30.461079] ata3: SATA link down (SStatus 0 SControl 310)
[   30.608087] usb 1-1.4.3: new low speed USB device using ehci_hcd and address 9
[   30.699939] usb 1-1.4.3: configuration #1 chosen from 1 choice
[   30.704245] input: Logitech USB Receiver as /class/input/input3
[   30.707939] input,hidraw3: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.2-1.4.3
[   30.884824] usb 1-1.4.4: new full speed USB device using ehci_hcd and address 10
[   30.914779] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   30.918331] ata4.00: ATA-7: Hitachi HDT725040VLA360, V5COA7EA, max UDMA/133
[   30.918335] ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   30.924331] ata4.00: configured for UDMA/100
[   30.924446] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5CO PQ: 0 ANSI: 5
[   30.924527] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
[   30.924542] sd 3:0:0:0: [sdc] Write Protect is off
[   30.924545] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   30.924564] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.924616] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
[   30.924628] sd 3:0:0:0: [sdc] Write Protect is off
[   30.924630] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   30.924649] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.924653]  sdc: sdc1
[   30.937391] sd 3:0:0:0: [sdc] Attached SCSI disk
[   30.971195] usb 1-1.4.4: configuration #1 chosen from 1 choice
[   33.938587] EXT3-fs: INFO: recovery required on readonly filesystem.
[   33.938592] EXT3-fs: write access will be enabled during recovery.
[   38.878587] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   38.878643] ata1.00: BMDMA stat 0x65
[   38.878694] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   38.878695]          res 51/40:f8:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   38.878746] ata1.00: status: { DRDY ERR }
[   38.878792] ata1.00: error: { UNC }
[   38.905598] ata1.00: configured for UDMA/100
[   38.905606] ata1: EH complete
[   40.923221] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   40.923271] ata1.00: BMDMA stat 0x65
[   40.923320] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   40.923322]          res 51/40:00:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   40.923372] ata1.00: status: { DRDY ERR }
[   40.923495] ata1.00: error: { UNC }
[   40.950180] ata1.00: configured for UDMA/100
[   40.950185] ata1: EH complete
[   42.967882] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   42.968008] ata1.00: BMDMA stat 0x65
[   42.968134] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   42.968135]          res 51/40:f8:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   42.968340] ata1.00: status: { DRDY ERR }
[   42.968464] ata1.00: error: { UNC }
[   42.979747] ata1.00: configured for UDMA/100
[   42.979752] ata1: EH complete
[   44.995973] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   44.996102] ata1.00: BMDMA stat 0x65
[   44.996227] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   44.996229]          res 51/40:f8:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   44.996432] ata1.00: status: { DRDY ERR }
[   44.996554] ata1.00: error: { UNC }
[   45.023334] ata1.00: configured for UDMA/100
[   45.023339] ata1: EH complete
[   47.098786] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   47.098913] ata1.00: BMDMA stat 0x65
[   47.099038] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   47.099040]          res 51/40:f8:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   47.099244] ata1.00: status: { DRDY ERR }
[   47.099366] ata1.00: error: { UNC }
[   47.110882] ata1.00: configured for UDMA/100
[   47.110887] ata1: EH complete
[   49.276447] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   49.276573] ata1.00: BMDMA stat 0x65
[   49.276698] ata1.00: cmd c8/00:f8:59:3d:07/00:00:00:00:00/e0 tag 0 dma 126976 in
[   49.276699]          res 51/40:f8:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   49.276903] ata1.00: status: { DRDY ERR }
[   49.277028] ata1.00: error: { UNC }
[   49.288365] ata1.00: configured for UDMA/100
[   49.288377] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   49.288381] sd 0:0:0:0: [sda] Sense Key : 0x3 [current] [descriptor]
[   49.288385] Descriptor sense data with sense descriptors (in hex):
[   49.288387]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[   49.288393]         00 07 3d 8b 
[   49.288396] sd 0:0:0:0: [sda] ASC=0x11 ASCQ=0x4
[   49.288399] end_request: I/O error, dev sda, sector 474507
[   49.288415] ata1: EH complete
[   49.297395] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   49.299276] sd 0:0:0:0: [sda] Write Protect is off
[   49.299280] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   49.303585] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   49.306616] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   49.317409] sd 0:0:0:0: [sda] Write Protect is off
[   49.317412] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   49.320830] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   53.606855] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   53.606989] ata1.00: BMDMA stat 0x65
[   53.607118] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   53.607120]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   53.607324] ata1.00: status: { DRDY ERR }
[   53.607446] ata1.00: error: { UNC }
[   53.634393] ata1.00: configured for UDMA/100
[   53.634401] ata1: EH complete
[   55.651542] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   55.651672] ata1.00: BMDMA stat 0x65
[   55.651797] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   55.651799]          res 51/40:00:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   55.652002] ata1.00: status: { DRDY ERR }
[   55.652125] ata1.00: error: { UNC }
[   55.678936] ata1.00: configured for UDMA/100
[   55.678941] ata1: EH complete
[   57.845829] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   57.845956] ata1.00: BMDMA stat 0x65
[   57.846084] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   57.846086]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   57.846289] ata1.00: status: { DRDY ERR }
[   57.846411] ata1.00: error: { UNC }
[   57.857425] ata1.00: configured for UDMA/100
[   57.857430] ata1: EH complete
[   59.915393] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   59.915521] ata1.00: BMDMA stat 0x65
[   59.915649] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   59.915650]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   59.915854] ata1.00: status: { DRDY ERR }
[   59.915976] ata1.00: error: { UNC }
[   59.926980] ata1.00: configured for UDMA/100
[   59.926985] ata1: EH complete
[   61.993309] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   61.993436] ata1.00: BMDMA stat 0x65
[   61.993561] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   61.993563]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   61.993766] ata1.00: status: { DRDY ERR }
[   61.993888] ata1.00: error: { UNC }
[   62.020550] ata1.00: configured for UDMA/100
[   62.020555] ata1: EH complete
[   64.037975] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   64.038102] ata1.00: BMDMA stat 0x65
[   64.038227] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma 45056 in
[   64.038229]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0 Emask 0x9 (media error)
[   64.038432] ata1.00: status: { DRDY ERR }
[   64.038555] ata1.00: error: { UNC }
[   64.050125] ata1.00: configured for UDMA/100
[   64.050134] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   64.050138] sd 0:0:0:0: [sda] Sense Key : 0x3 [current] [descriptor]
[   64.050142] Descriptor sense data with sense descriptors (in hex):
[   64.050143]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[   64.050149]         00 07 3d 8b 
[   64.050152] sd 0:0:0:0: [sda] ASC=0x11 ASCQ=0x4
[   64.050155] end_request: I/O error, dev sda, sector 474507
[   64.050169] ata1: EH complete
[   64.050382] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   64.050506] sd 0:0:0:0: [sda] Write Protect is off
[   64.050509] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   64.050756] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.051049] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   64.051173] sd 0:0:0:0: [sda] Write Protect is off
[   64.051176] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   64.051422] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.632360] kjournald starting.  Commit interval 5 seconds
[   64.632378] EXT3-fs: dm-0: orphan cleanup on readonly fs
[   64.632385] ext3_orphan_cleanup: deleting unreferenced inode 17303473
[   64.648547] ext3_orphan_cleanup: deleting unreferenced inode 38797436
[   64.707760] ext3_orphan_cleanup: deleting unreferenced inode 37519565
[   64.730253] EXT3-fs: dm-0: 3 orphan inodes deleted
[   64.730255] EXT3-fs: recovery complete.
[   64.816010] EXT3-fs: mounted filesystem with ordered data mode.
[   65.194899] audit(1201539052.235:2): enforcing=1 old_enforcing=0 auid=4294967295
[   65.408684] SELinux:8192 avtab hash slots allocated.Num of rules:213166
[   65.470766] SELinux:8192 avtab hash slots allocated.Num of rules:213166
[   65.534876] security:  8 users, 11 roles, 2363 types, 114 bools, 1 sens, 1024 cats
[   65.534881] security:  67 classes, 213166 rules
[   65.537006] SELinux:  Completing initialization.
[   65.537009] SELinux:  Setting up existing superblocks.
[   65.559377] SELinux: initialized (dev dm-0, type ext3), uses xattr
[   65.720901] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   65.720917] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   65.721020] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   65.721032] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   65.721064] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   65.721073] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   65.721079] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   65.721090] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   65.721094] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   65.721102] SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
[   65.721109] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   65.721113] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   65.721118] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   65.721128] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   65.721140] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   65.721145] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   65.721169] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   65.725436] SELinux: policy loaded with handle_unknown=allow
[   65.725446] audit(1201539052.766:3): policy loaded auid=4294967295
[   69.515151] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   69.515177] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   69.515202] sd 1:0:1:0: Attached scsi generic sg2 type 0
[   69.515231] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   70.057084] input: Power Button (FF) as /class/input/input4
[   70.060611] ACPI: Power Button (FF) [PWRF]
[   70.060653] ACPI Error (evxfevnt-0186): Could not enable SleepButton event [20070126]
[   70.060658] ACPI Warning (evxface-0145): Could not enable fixed event 3 [20070126]
[   70.060742] input: Power Button (CM) as /class/input/input5
[   70.064592] ACPI: Power Button (CM) [PWRB]
[   70.064652] input: Sleep Button (CM) as /class/input/input6
[   70.067603] ACPI: Sleep Button (CM) [SLPB]
[   70.385057] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
[   70.385082] usbcore: registered new interface driver usblp
[   70.412471] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
[   70.412498] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5100
[   70.450007] usbcore: registered new interface driver usbserial
[   70.450013] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   70.569319] drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
[   70.569461] ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
[   70.569497] drivers/usb/serial/ftdi_sio.c: Detected FT232RL
[   70.569536] usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0
[   70.569552] usbcore: registered new interface driver ftdi_sio
[   70.569555] drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
[   70.615332] input: PC Speaker as /class/input/input7
[   70.661362] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   70.661752] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[   70.661757] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 16
[   70.661764] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   70.719617] Floppy drive(s): fd0 is 1.44M
[   70.736319] FDC 0 is a post-1991 82077
[   71.173281] forcedeth 0000:00:04.0: ifname eth0, PHY OUI 0x20 @ 1, addr 00:04:4b:5d:eb:7d
[   71.173286] forcedeth 0000:00:04.0: timirq lnktim desc-v1
[   71.173697] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   71.173705] ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 20
[   71.206469] Linux video capture interface: v2.00
[   71.231784] firewire_ohci: Added fw-ohci device 0000:01:09.0, OHCI version 1.10
[   71.475562] nvidia: module license 'NVIDIA' taints kernel.
[   71.733592] firewire_core: created new fw device fw0 (0 config rom retries, S400)
[   71.738694] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 20
[   71.739120] NVRM: loading NVIDIA UNIX x86 Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
[   72.053875] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   72.053971] cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected]
[   72.053975] cx88[0]: TV tuner type 60, Radio tuner type -1
[   72.093539] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   72.198076] cx88[0]/2: cx2388x 8802 Driver Manager
[   72.200230] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   72.200241] ACPI: PCI Interrupt 0000:01:07.2[A] -> Link [APC2] -> GSI 17 (level, high) -> IRQ 21
[   72.200254] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 21, latency: 32, mmio: 0xe4000000
[   72.200328] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC2] -> GSI 17 (level, high) -> IRQ 21
[   72.200340] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 21, latency: 32, mmio: 0xe3000000
[   72.379427] tda8290_probe: not probed - driver disabled by Kconfig
[   72.379432] tuner 2-0043: chip found @ 0x86 (cx88[0])
[   72.379457] tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner)
[   72.379460] tuner 2-0043: type set to tda9887
[   72.381847] tuner 2-0061: chip found @ 0xc2 (cx88[0])
[   72.381866] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   72.381869] tuner 2-0061: type set to Thomson DTT 761X (A
[   72.381871] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   72.381874] tuner 2-0061: type set to Thomson DTT 761X (A
[   72.394034] cx88[0]/0: registered device video0 [v4l2]
[   72.394059] cx88[0]/0: registered device vbi0
[   72.394083] cx88[0]/0: registered device radio0
[   72.528367] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   72.528372] cx88/2: registering cx8802 driver, type: dvb access: shared
[   72.528376] cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
[   72.528380] cx88[0]/2: cx2388x based DVB/ATSC card
[   72.581302] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   72.581312] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 22
[   72.586129] Audigy2 value: Special config.
[   72.695526] DVB: registering new adapter (cx88[0])
[   72.695532] DVB: registering frontend 0 (Oren OR51132 VSB/QAM Frontend)...
[   72.769048] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 21
[   72.769054] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 21 (level, high) -> IRQ 17
[   72.769090] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   73.080499] intel8x0_measure_ac97_clock: measured 50742 usecs
[   73.080504] intel8x0: clocking to 47447
[   75.947132] EXT3 FS on dm-0, internal journal
[   76.213561] kjournald starting.  Commit interval 5 seconds
[   76.220513] EXT3 FS on sda1, internal journal
[   76.220518] EXT3-fs: mounted filesystem with ordered data mode.
[   76.226324] SELinux: initialized (dev sda1, type ext3), uses xattr
[   76.226733] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   76.231140] kjournald starting.  Commit interval 5 seconds
[   76.238465] EXT3 FS on sdc1, internal journal
[   76.238469] EXT3-fs: mounted filesystem with ordered data mode.
[   76.245352] SELinux: initialized (dev sdc1, type ext3), uses xattr
[   77.211706] Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
[   77.215361] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   77.624868] warning: process `kudzu' used the deprecated sysctl system call with 1.23.
[   78.115621] NET: Registered protocol family 10
[   78.115859] lo: Disabled Privacy Extensions
[   83.732476] RPC: Registered udp transport module.
[   83.732480] RPC: Registered tcp transport module.
[   83.735747] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   84.406333] w83627hf: Found W83627HF chip at 0x290
[   84.927130] audit(1201539072.923:4): audit_pid=1915 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
[   86.877546] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   87.346561] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   87.501848] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   89.296245] eth0: no IPv6 routers present
[  129.766842] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[  129.766858] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
[  129.766929] agpgart: Putting AGP V3 device at 0000:02:00.0 into 8x mode

--Boundary-00=_8kgnH7YqN15XXyY--
