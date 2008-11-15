Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYKOVuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYKOVuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYKOVsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:22866 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbYKOVss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=lqFJ8b/AnQw9TK0yvsp1G0K66H4oWsC1d3bdFUmRwN6hX7j/CKcWOGhlJPy+wYkyqm
         SyqOUrjAcJfVxD176Z7IVgEL+1FT0U62mvmQLZ+hWB06KvDo+Muo2qvgnZzMuWFpnZ9J
         49lhGrXxMgWPiR4/fLjQ5cesaVmXpNu8YOkUo=
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling
 mode
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <200811152019.31744.rjw@sisk.pl>
References: <1226722577.3104.4.camel@LiNuX> <491EBB2D.70106@tuffmail.co.uk>
	 <dd18b0c30811151039i4a5e295euc4aaa52382d47bb1@mail.gmail.com>
	 <200811152019.31744.rjw@sisk.pl>
Content-Type: multipart/mixed; boundary="=-mZAyOLL1/zgXVJOIQd45"
Date: Sat, 15 Nov 2008 13:48:42 -0800
Message-Id: <1226785722.3137.17.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mZAyOLL1/zgXVJOIQd45
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2008-11-15 at 20:19 +0100, Rafael J. Wysocki wrote:
> On Saturday, 15 of November 2008, Justin Mattock wrote:
> > On Sat, Nov 15, 2008 at 4:06 AM, Alan Jenkins
> > <alan-jenkins@tuffmail.co.uk> wrote:
> > > Rafael J. Wysocki wrote:
> > >>
> > >> On Saturday, 15 of November 2008, Alan Jenkins wrote:
> > >>
> > >>>
> > >>> On Sat, Nov 15, 2008 at 9:23 AM, Alexey Starikovskiy <aystarik@gmail.com>
> > >>> wrote:
> > >>>
> > >>>>
> > >>>> Andrew Morton wrote:
> > >>>>
> > >>>>>
> > >>>>> (cc linux-acpi)
> > >>>>>
> > >>>>> On Fri, 14 Nov 2008 20:16:17 -0800 "Justin P. Mattock"
> > >>>>> <justinmattock@gmail.com> wrote:
> > >>>>>
> > >>>>>
> > >>>>>>
> > >>>>>> just pulled the latest git today and am now noticing
> > >>>>>> the lovely gpe storm being triggered.(dmesg below);
> > >>>>>>
> > >>>>>
> > >>>>> Are any other effects observeable?
> > >>>>>
> > >>>>> I assume that 2.6.27 didn't do this.
> > >>>>>
> > >>>>>
> > >>>>
> > >>>> It did. Justin even opened a bug -- #11724.
> > >>>>
> > >>>
> > >>> In case anyone else tries to follow that, it's actually #10724 :).
> > >>>
> > >>
> > >> Yes, the "transaction in interrupt context" patch fixed that IIRC and the
> > >> one
> > >> of the patches in the recet ACPI merge broke it again.
> > >>
> > >> Justin, can you see if reverting one or more of the following commits
> > >> helps:
> > >>
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8517934ef6aaa28d6e055b98df65b31cedbd1372
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=06cf7d3c7af902939cd1754abcafb2464060cba8
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0b7084ac67fb84f0cf2f8bc02d7e0dea8521dd2d
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a2f93aeadf97e870ff385030633a73e21146815d
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd15f8c42af09031e27da5b4d697ce925511f2e1
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8248434e6a11d7cd314281be3b39bbcf82fc243
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594
> > >>
> > >> (please revert in this order)?
> > >>
> > >
> > > Be aware there's a real possibility this was only a cosmetic fix (and
> > > regression).
> > >
> > > I think the original GPE storm avoidance printed that message by default.
> > >  Then the "transaction in interrupt context" made the message into a
> > > pr_debug(), - i.e. disabled it by default.  And then my "make messages more
> > > useful when GPE storm is detected" re-enabled it.
> > >
> > > IIRC, this flip-flopping is contained within 2.6.28-rc.  I.e. I don't think
> > > it will show up as a (cosmetic) regression when jumping straight from 2.6.27
> > > to 2.6.28.  Though I suspect it will shows up between certain versions of
> > > -stable.
> > >
> > > Regards
> > > Alan
> > >
> > 
> > O.K. I think I was wrong about stating
> > this was not caused by the discharging and charging of the battery.
> > to retrace my steps
> > yesterday I pulled, then  recompiled, then
> > let the system idle for a few, then once I moved the computer to the
> > other room,(unplugged/plugged the A/C adapter)
> > the light turned orange on the A/C adapter then once
> > the battery became fully charged(green light on A/C adapter)
> > the gpe storm was triggered. Once I saw the gpe storm, I rebooted
> > (under the impression the battery was in a good state),
> > instantly the gpe storm was triggered. leading me
> > to beleive this was something else.
> > So after seeing that and sending a post I used the
> > acpi_osi=Darwin option sat had a beer and worried about it tomorrow.
> > Now when I woke up, and saw the commits from rafael(thanks for the help)
> > I decided to make sure this was reproducible, So removing the acpi_osi option,
> > then let the system idled. To my amazement the
> > gpe storm was not triggered at all.
> > (even unplugging and plugging the A/C multiple times had no effect)
> > After a while thinking what the hell is going on here, I decided to discharge
> > the battery to around 97% or 5 min. and then charge to see if this
> > triggers the gpe storm. Well sure enough it did.(attached is dmesg);
> > 
> > So for now should I go and individually revert the commits; charge,
> > and discharge
> > to locate the culprit, or is this something completely different?
> 
> Well, you have only one
> "ACPI: EC: GPE storm detected, transactions will use polling mode" message in
> the log, so the EC code seems to work as expected and you _really_ have an
> interrupt storm that is worked around.
> 
> Not sure what's causing it to happen, though.
> 
> Thanks,
> Rafael

Hmm...
Well it looks like the gpe storm is triggered
without messing with the battery:
after 2 hrs I get 
ACPI: EC: GPE storm detected, transactions will use polling mode
looks like I'll try out those commits to see what happens.
attached is dmesg.

-- 
Justin P. Mattock <justinmattock@gmail.com>

--=-mZAyOLL1/zgXVJOIQd45
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc4-00322-g58e20d8 (root@LiNuX) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Sat Nov 15 09:13:21 PST 2008
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
[    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  modified: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  modified: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  modified: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  modified: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  modified: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-16000
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 120MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00012000 - 00018f00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000062bbe4]    TEXT DATA BSS ==> [0000100000 - 000062bbe4]
[    0.000000]   #4 [000062c000 - 000062f000]    INIT_PG_TABLE ==> [000062c000 - 000062f000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x00000007
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258159
[    0.000000] free_area_init_node: node 0, pgdat c051f980, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 242 pages used for memmap
[    0.000000]   HighMem zone: 30714 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000007000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256141
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28-rc4-00322-g58e20d8 root=/dev/sda1 ro vga=790 debug pnpacpi=off pci=routeirq audit=1 selinux=1 enforcing=1
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2161.242 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Scanning for low memory corruption every 60 seconds
[    0.010000] Memory: 1017932k/1033128k available (2803k kernel code, 14344k reserved, 1506k data, 404k init, 123824k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.010000]       .init : 0xc053c000 - 0xc05a1000   ( 404 kB)
[    0.010000]       .data : 0xc03bce25 - 0xc05357c4   (1506 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03bce25   (2803 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4322.48 BogoMIPS (lpj=21612420)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Initializing.
[    0.010000] SELinux:  Starting in enforcing mode
[    0.010000] Failure registering Root Plug module with the kernel
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#0.
[    0.010000] using mwait in idle threads.
[    0.010000] Checking 'hlt' instruction... OK.
[    0.041238] ACPI: Core revision 20080926
[    0.059736] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159757] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.160000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4322.51 BogoMIPS (lpj=21612585)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.311696] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.311729] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.320021] Brought up 2 CPUs
[    0.320027] Total of 2 processors activated (8645.00 BogoMIPS).
[    0.320093] CPU0 attaching sched-domain:
[    0.320098]  domain 0: span 0-1 level MC
[    0.320102]   groups: 0 1
[    0.320110] CPU1 attaching sched-domain:
[    0.320113]  domain 0: span 0-1 level MC
[    0.320117]   groups: 1 0
[    0.320200] net_namespace: 540 bytes
[    0.320200] Booting paravirtualized kernel on bare hardware
[    0.320316] NET: Registered protocol family 16
[    0.320316] EISA bus registered
[    0.320316] ACPI: bus type pci registered
[    0.320316] PCI: Using configuration type 1 for base access
[    0.331036] ACPI: EC: EC description table is found, configuring boot EC
[    0.331289] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.342809] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.343896] ACPI: Interpreter enabled
[    0.343901] ACPI: (supports S0 S3 S4 S5)
[    0.343975] ACPI: Using IOAPIC for interrupt routing
[    0.370295] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.370295] ACPI: EC: driver started in interrupt mode
[    0.370410] ACPI: No dock devices found.
[    0.370437] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.370496] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.370496] pci 0000:00:01.0: PME# disabled
[    0.370496] pci 0000:00:07.0: reg 10 32bit mmio: [0x50404000-0x50404fff]
[    0.370496] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
[    0.370496] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.370496] pci 0000:00:1b.0: PME# disabled
[    0.370496] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.370496] pci 0000:00:1c.0: PME# disabled
[    0.370496] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.370496] pci 0000:00:1c.1: PME# disabled
[    0.370507] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.370514] pci 0000:00:1c.2: PME# disabled
[    0.370584] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.370652] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.370720] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.370787] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.370858] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50405400-0x504057ff]
[    0.370907] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.370915] pci 0000:00:1d.7: PME# disabled
[    0.371081] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.371088] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.371147] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.371157] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.371167] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.371176] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.371186] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.371244] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.371254] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.371263] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.371273] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.371282] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.371291] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50405000-0x504053ff]
[    0.371312] pci 0000:00:1f.2: PME# supported from D3hot
[    0.371318] pci 0000:00:1f.2: PME# disabled
[    0.371386] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.371453] pci 0000:01:00.0: reg 10 32bit mmio: [0x40000000-0x47ffffff]
[    0.371464] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.371474] pci 0000:01:00.0: reg 18 32bit mmio: [0x50300000-0x5030ffff]
[    0.371495] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.371507] pci 0000:01:00.0: supports D1 D2
[    0.371567] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.371572] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
[    0.371579] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x47ffffff]
[    0.371663] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x50203fff]
[    0.371676] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.371713] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.371730] pci 0000:02:00.0: supports D1 D2
[    0.371733] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.371741] pci 0000:02:00.0: PME# disabled
[    0.371804] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.371811] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
[    0.371903] pci 0000:03:00.0: reg 10 64bit mmio: [0x50100000-0x5010ffff]
[    0.371963] pci 0000:03:00.0: supports D1
[    0.371966] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.371974] pci 0000:03:00.0: PME# disabled
[    0.372049] pci 0000:00:1c.1: bridge 32bit mmio: [0x50100000-0x501fffff]
[    0.372118] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.372125] pci 0000:00:1c.2: bridge 32bit mmio: [0x4c100000-0x500fffff]
[    0.372135] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x48000000-0x4bffffff]
[    0.372197] pci 0000:0c:03.0: reg 10 32bit mmio: [0x4c004000-0x4c0047ff]
[    0.372208] pci 0000:0c:03.0: reg 14 32bit mmio: [0x4c000000-0x4c003fff]
[    0.372260] pci 0000:0c:03.0: supports D1 D2
[    0.372263] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.372270] pci 0000:0c:03.0: PME# disabled
[    0.372333] pci 0000:00:1e.0: transparent bridge
[    0.372342] pci 0000:00:1e.0: bridge 32bit mmio: [0x4c000000-0x4c0fffff]
[    0.372380] bus 00 -> node 0
[    0.372393] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.381400] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.381999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.382586] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.383179] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.383790] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.401166] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401166] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401166] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401166] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401357] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.401645] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.401937] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.402218] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.410280] SCSI subsystem initialized
[    0.410280] libata version 3.00 loaded.
[    0.410280] usbcore: registered new interface driver usbfs
[    0.410280] usbcore: registered new interface driver hub
[    0.410280] usbcore: registered new device driver usb
[    0.410280] PCI: Using ACPI for IRQ routing
[    0.410280] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
[    0.410280] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.410280] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410280] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410280] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410280] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410280] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410280] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410280] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.410280] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410280] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410280] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410280] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410280] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.440078] cfg80211: Using static regulatory domain info
[    0.440078] cfg80211: Regulatory domain: US
[    0.440078] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.440078] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.440078] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440078] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440078] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440078] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440082] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.440086] cfg80211: Calling CRDA for country: US
[    0.440112] NetLabel: Initializing
[    0.440112] NetLabel:  domain hash size = 128
[    0.440112] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.440134] NetLabel:  unlabeled traffic allowed by default
[    0.440148] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.440154] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.470028] pnp: PnP ACPI: disabled
[    0.501755] Switched to high resolution mode on CPU 1
[    0.505971] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.505979] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.505985] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.505990] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x00000047ffffff
[    0.505999] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.506004] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.506012] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.506019] pci 0000:00:1c.0:   PREFETCH window: 0x00000050500000-0x000000505fffff
[    0.506030] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.506033] pci 0000:00:1c.1:   IO window: disabled
[    0.506041] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.506047] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.506056] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.506062] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.506070] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.506076] pci 0000:00:1c.2:   PREFETCH window: 0x00000048000000-0x0000004bffffff
[    0.506087] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.506091] pci 0000:00:1e.0:   IO window: disabled
[    0.506098] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.506105] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.506118] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.506125] pci 0000:00:01.0: setting latency timer to 64
[    0.506134] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.506141] pci 0000:00:1c.0: setting latency timer to 64
[    0.506152] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.506158] pci 0000:00:1c.1: setting latency timer to 64
[    0.506169] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.506175] pci 0000:00:1c.2: setting latency timer to 64
[    0.506337] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.506346] pci 0000:00:1e.0: setting latency timer to 64
[    0.506352] bus: 00 index 0 io port: [0x00-0xffff]
[    0.506356] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.506359] bus: 01 index 0 io port: [0x3000-0x3fff]
[    0.506363] bus: 01 index 1 mmio: [0x50300000-0x503fffff]
[    0.506367] bus: 01 index 2 mmio: [0x40000000-0x47ffffff]
[    0.506370] bus: 01 index 3 mmio: [0x0-0x0]
[    0.506374] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.506377] bus: 02 index 1 mmio: [0x50200000-0x502fffff]
[    0.506381] bus: 02 index 2 mmio: [0x50500000-0x505fffff]
[    0.506384] bus: 02 index 3 mmio: [0x0-0x0]
[    0.506388] bus: 03 index 0 mmio: [0x0-0x0]
[    0.506391] bus: 03 index 1 mmio: [0x50100000-0x501fffff]
[    0.506394] bus: 03 index 2 mmio: [0x0-0x0]
[    0.506398] bus: 03 index 3 mmio: [0x0-0x0]
[    0.506401] bus: 04 index 0 io port: [0x1000-0x1fff]
[    0.506405] bus: 04 index 1 mmio: [0x4c100000-0x500fffff]
[    0.506408] bus: 04 index 2 mmio: [0x48000000-0x4bffffff]
[    0.506412] bus: 04 index 3 mmio: [0x0-0x0]
[    0.506415] bus: 0c index 0 mmio: [0x0-0x0]
[    0.506418] bus: 0c index 1 mmio: [0x4c000000-0x4c0fffff]
[    0.506422] bus: 0c index 2 mmio: [0x0-0x0]
[    0.506425] bus: 0c index 3 io port: [0x00-0xffff]
[    0.506429] bus: 0c index 4 mmio: [0x000000-0xffffffff]
[    0.506442] NET: Registered protocol family 2
[    0.510002] Switched to high resolution mode on CPU 0
[    0.540077] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.540401] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.540841] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.541393] TCP: Hash tables configured (established 131072 bind 65536)
[    0.541397] TCP reno registered
[    0.550152] NET: Registered protocol family 1
[    0.551156] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.553237] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.554645] Initializing RT-Tester: OK
[    0.554758] audit: initializing netlink socket (enabled)
[    0.554823] type=2000 audit(1226777320.551:1): initialized
[    0.559741] highmem bounce pool size: 64 pages
[    0.559749] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.575809] fuse init (API version 7.10)
[    0.576404] msgmni has been set to 1747
[    0.576647] SELinux:  Registering netfilter hooks
[    0.577571] alg: No test for stdrng (krng)
[    0.577592] io scheduler noop registered
[    0.577939] io scheduler cfq registered (default)
[    0.578097] pci 0000:01:00.0: Boot video device
[    0.598529] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000, using 3072k, total 16384k
[    0.598536] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    0.598539] vesafb: protected mode interface info at c000:ad0c
[    0.598543] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    0.598547] vesafb: scrolling: redraw
[    0.598551] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    0.622853] Console: switching to colour frame buffer device 128x48
[    0.645029] fb0: VESA VGA frame buffer device
[    0.658523] loop: module loaded
[    0.658675] Linux video capture interface: v2.00
[    0.659130] input: Macintosh mouse button emulation as /class/input/input0
[    0.659735] Driver 'sd' needs updating - please use bus_type methods
[    0.660132] Driver 'sr' needs updating - please use bus_type methods
[    0.660782] ata_piix 0000:00:1f.1: version 2.12
[    0.661085] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.661383] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.661753] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.662113] scsi0 : ata_piix
[    0.662751] scsi1 : ata_piix
[    0.664892] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    0.665212] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    0.840579] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.880536] ata1.00: configured for UDMA/66
[    1.053363] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
[    1.058024] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.066729] Uniform CD-ROM driver Revision: 3.20
[    1.075578] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.084271] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.092553] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.100864] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.260015] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.268315] scsi2 : ata_piix
[    1.276575] scsi3 : ata_piix
[    1.288158] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    1.296314] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.490510] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    1.498553] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.540517] ata3.01: configured for UDMA/100
[    1.711230] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
[    1.719953] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    1.728522] sd 2:0:1:0: [sda] Write Protect is off
[    1.736985] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.745376] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.753961] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    1.762466] sd 2:0:1:0: [sda] Write Protect is off
[    1.770844] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.779154] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.787681]  sda: sda1 sda2
[    1.796814] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.805443] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.813888] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.822386] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.831011] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.839462] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.847929] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.860403] ehci_hcd 0000:00:1d.7: debug port 1
[    1.868766] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.877296] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    1.900009] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.908649] usb usb1: configuration #1 chosen from 1 choice
[    1.917183] hub 1-0:1.0: USB hub found
[    1.925685] hub 1-0:1.0: 8 ports detected
[    1.934770] usbcore: registered new interface driver usblcd
[    1.943430] usbcore: registered new interface driver usbled
[    1.952155] PNP: No PS/2 controller found. Probing ports directly.
[    1.961444] i8042.c: No controller found.
[    1.980234] mice: PS/2 mouse device common for all mice
[    1.989173] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.997629] EDAC MC: Ver: 2.1.0 Nov 15 2008
[    2.006480] cpuidle: using governor ladder
[    2.014950] cpuidle: using governor menu
[    2.025303] usbcore: registered new interface driver hiddev
[    2.033763] usbcore: registered new interface driver usbhid
[    2.042028] usbhid: v2.6:USB HID core driver
[    2.050349] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    2.058843] ALSA device list:
[    2.067181]   No soundcards found.
[    2.075776] oprofile: using NMI interrupt.
[    2.084447] IPVS: Registered protocols (TCP, AH, ESP)
[    2.092965] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    2.101488] IPVS: ipvs loaded.
[    2.110089] Initializing XFRM netlink socket
[    2.118294] NET: Registered protocol family 17
[    2.126469] NET: Registered protocol family 15
[    2.134554] Using IPI No-Shortcut mode
[    2.174549] kjournald starting.  Commit interval 5 seconds
[    2.174559] EXT3-fs: mounted filesystem with ordered data mode.
[    2.174590] VFS: Mounted root (ext3 filesystem) readonly.
[    2.174893] Freeing unused kernel memory: 404k freed
[    2.380013] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    2.530564] usb 1-4: configuration #1 chosen from 1 choice
[    2.817550] SELinux: 8192 avtab hash slots, 173318 rules.
[    2.930997] SELinux: 8192 avtab hash slots, 173318 rules.
[    3.134684] SELinux:  7 users, 9 roles, 3230 types, 100 bools, 1 sens, 256 cats
[    3.142574] SELinux:  73 classes, 173318 rules
[    3.157895] SELinux:  Completing initialization.
[    3.165680] SELinux:  Setting up existing superblocks.
[    3.202007] SELinux: initialized (dev sda1, type ext3), uses xattr
[    3.353061] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    3.360943] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    3.368910] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    3.376949] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[    3.384970] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    3.392988] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[    3.401134] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.409267] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    3.417680] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.426014] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    3.434357] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.442674] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.450836] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.458715] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    3.466686] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.515840] type=1403 audit(1226777323.510:2): policy loaded auid=4294967295 ses=4294967295
[    4.198670] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.370093] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.383169] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.981585] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.889320] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[   10.908338] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[   10.928114] power_supply ADP1: uevent
[   10.936994] power_supply ADP1: No power supply yet
[   10.945744] power_supply ADP1: power_supply_changed
[   10.954338] ACPI: AC Adapter [ADP1] (on-line)
[   10.963070] power_supply ADP1: power_supply_changed_work
[   10.971813] power_supply ADP1: power_supply_update_gen_leds 1
[   10.980546] power_supply ADP1: uevent
[   10.988916] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   10.997414] power_supply ADP1: Static prop TYPE=Mains
[   11.005915] power_supply ADP1: 1 dynamic props
[   11.014263] power_supply ADP1: prop ONLINE=1
[   11.024546] Monitor-Mwait will be used to enter C-1 state
[   11.032952] Monitor-Mwait will be used to enter C-2 state
[   11.041191] Monitor-Mwait will be used to enter C-3 state
[   11.049363] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   11.057418] processor ACPI_CPU:00: registered as cooling_device0
[   11.065492] ACPI: Processor [CPU0] (supports 8 throttling states)
[   11.081978] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[   11.091346] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[   11.100608] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   11.110446] processor ACPI_CPU:01: registered as cooling_device1
[   11.116459] Marking TSC unstable due to TSC halts in idle
[   11.128731] ACPI: Processor [CPU1] (supports 8 throttling states)
[   11.138443] input: Power Button (FF) as /class/input/input1
[   11.190183] ACPI: Power Button (FF) [PWRF]
[   11.264328] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
[   11.281040] power_supply BAT0: uevent
[   11.289074] power_supply BAT0: No power supply yet
[   11.297344] power_supply BAT0: power_supply_changed
[   11.305661] power_supply BAT0: power_supply_changed_work
[   11.315984] uhci_hcd: USB Universal Host Controller Interface driver
[   11.326195] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   11.336423] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   11.346808] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   11.353857] ACPI: Battery Slot [BAT0] (battery present)
[   11.354041] input: Lid Switch as /class/input/input2
[   11.376067] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   11.385849] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   11.395883] usb usb2: configuration #1 chosen from 1 choice
[   11.402946] power_supply BAT0: power_supply_update_bat_leds 4
[   11.402964] power_supply BAT0: uevent
[   11.402966] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   11.402970] power_supply BAT0: Static prop TYPE=Battery
[   11.402972] power_supply BAT0: 12 dynamic props
[   11.402975] power_supply BAT0: prop STATUS=Full
[   11.402979] power_supply BAT0: prop PRESENT=1
[   11.402982] power_supply BAT0: prop TECHNOLOGY=Unknown
[   11.402985] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[   11.402988] power_supply BAT0: prop VOLTAGE_NOW=12587000
[   11.402991] power_supply BAT0: prop CURRENT_NOW=0
[   11.402994] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[   11.402997] power_supply BAT0: prop ENERGY_FULL=51200000
[   11.403000] power_supply BAT0: prop ENERGY_NOW=51200000
[   11.403002] power_supply BAT0: prop MODEL_NAME=ASMB012
[   11.403005] power_supply BAT0: prop MANUFACTURER=SMPN012
[   11.403008] power_supply BAT0: prop SERIAL_NUMBER=
[   11.412755] usb 1-4: firmware: requesting isight.fw
[   11.474268] ath9k: 0.1
[   11.474313] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.474325] ath9k 0000:03:00.0: setting latency timer to 64
[   11.563807] hub 2-0:1.0: USB hub found
[   11.563821] hub 2-0:1.0: 2 ports detected
[   11.564319] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   11.564330] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.564334] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.564394] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   11.564431] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   11.564600] usb usb3: configuration #1 chosen from 1 choice
[   11.564672] hub 3-0:1.0: USB hub found
[   11.564684] hub 3-0:1.0: 2 ports detected
[   11.564974] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.564982] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.564985] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.565048] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   11.565098] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   11.565273] usb usb4: configuration #1 chosen from 1 choice
[   11.565345] hub 4-0:1.0: USB hub found
[   11.565356] hub 4-0:1.0: 2 ports detected
[   11.565599] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   11.565607] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   11.565610] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   11.565666] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   11.565712] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   11.565896] usb usb5: configuration #1 chosen from 1 choice
[   11.565961] hub 5-0:1.0: USB hub found
[   11.565972] hub 5-0:1.0: 2 ports detected
[   11.693196] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   11.700843] Registered led device: ath9k-phy0:radio
[   11.700892] Registered led device: ath9k-phy0:assoc
[   11.700949] Registered led device: ath9k-phy0:tx
[   11.700997] Registered led device: ath9k-phy0:rx
[   11.701830] phy0: Atheros 5416: mem=0xf8820000, irq=17
[   11.901817] ACPI: Lid Switch [LID0]
[   11.908541] input: Power Button (CM) as /class/input/input3
[   11.932671] ACPI: Power Button (CM) [PWRB]
[   11.939696] input: Sleep Button (CM) as /class/input/input4
[   11.955702] ACPI: Sleep Button (CM) [SLPB]
[   11.982573] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   12.025772] usbcore: registered new interface driver isight_firmware
[   12.093656] firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.184512] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.192639] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.200921] firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI version 1.10
[   12.220267] usb 2-2: configuration #1 chosen from 1 choice
[   12.235073] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input5
[   12.256008] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[   12.280877] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input6
[   12.291645] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   12.312386] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[   12.365757] appletouch: Geyser mode initialized.
[   12.375535] input: appletouch as /class/input/input7
[   12.420406] usbcore: registered new interface driver appletouch
[   12.450042] usb 4-2: new full speed USB device using uhci_hcd and address 2
[   12.600905] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   12.660317] usb 4-2: configuration #1 chosen from 1 choice
[   12.689279] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[   12.711397] firewire_core: created device fw0: GUID 0019e3fffe2ad87e, S800
[   12.726781] applesmc: Apple MacBook Pro detected:
[   12.737872] applesmc:  - Model with accelerometer
[   12.748714] applesmc:  - Model with light sensors and backlight
[   12.759478] applesmc:  - Model with 12 temperature sensors
[   12.830130] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   12.842702] applesmc: device successfully initialized (0xe0, 0x00).
[   12.854019] applesmc: device successfully initialized.
[   12.866013] applesmc: 2 fans found.
[   12.878430] input: applesmc as /class/input/input8
[   12.894777] Registered led device: smc::kbd_backlight
[   12.906133] applesmc: driver successfully loaded.
[   13.002513] Clocksource tsc unstable (delta = -70993048 ns)
[   13.052175] Linux agpgart interface v0.103
[   13.091058] usb 5-1: configuration #1 chosen from 1 choice
[   13.130412] input: HID 05ac:1000 as /class/input/input9
[   13.151028] generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[   13.170091] [drm] Initialized drm 1.1.0 20060810
[   13.188111] input: HID 05ac:1000 as /class/input/input10
[   13.202956] generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[   13.214817] usb 1-4: USB disconnect, address 3
[   13.244085] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.255426] pci 0000:01:00.0: setting latency timer to 64
[   13.266870] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   13.423460] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.546167] nf_conntrack version 0.5.0 (16142 buckets, 64568 max)
[   13.557064] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   13.567505] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   13.578077] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   13.636548] arp_tables: (C) 2002 David S. Miller
[   13.716178] ieee80211_crypt: registered algorithm 'NULL'
[   13.763902] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   13.774448] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   13.799751] ieee80211_crypt: registered algorithm 'TKIP'
[   13.892463] usbcore: registered new interface driver uvcvideo
[   13.903162] USB Video Class driver (v0.1.0)
[   13.913749] usb 1-4: new high speed USB device using ehci_hcd and address 6
[   13.958273] ipmi message handler version 39.2
[   13.988200] IPMI Watchdog: driver initialized
[   14.081337] usb 1-4: configuration #1 chosen from 1 choice
[   14.082151] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   14.084609] uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
[   14.086605] input: Built-in iSight as /class/input/input11
[   14.268638] Adding 2988360k swap on /dev/sda2.  Priority:-1 extents:1 across:2988360k
[   14.676368] EXT3 FS on sda1, internal journal
[   17.905048] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   18.595153] applesmc: light sensor data length set to 6
[   19.997819] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   20.014147] Bluetooth: Core ver 2.13
[   20.018929] NET: Registered protocol family 31
[   20.018934] Bluetooth: HCI device and connection manager initialized
[   20.018940] Bluetooth: HCI socket layer initialized
[   20.047833] Bluetooth: L2CAP ver 2.11
[   20.047838] Bluetooth: L2CAP socket layer initialized
[   20.099326] Bluetooth: RFCOMM socket layer initialized
[   20.099368] Bluetooth: RFCOMM TTY layer initialized
[   20.099372] Bluetooth: RFCOMM ver 1.10
[   20.120444] Bluetooth: SCO (Voice Link) ver 0.6
[   20.120447] Bluetooth: SCO socket layer initialized
[   20.288022] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   20.288028] Bluetooth: BNEP filters: protocol multicast
[   20.312716] usb 5-1: USB disconnect, address 2
[   20.630092] usb 5-1: new full speed USB device using uhci_hcd and address 3
[   20.839934] usb 5-1: configuration #1 chosen from 1 choice
[   20.919762] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   20.919960] usbcore: registered new interface driver btusb
[   26.805873] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   26.810159] input: justinmattock’s mouse #1 as /class/input/input12
[   26.853399] generic-bluetooth 0005:0000:0000.0006: input: BLUETOOTH HID v0.00 Mouse [justinmattock’s mouse #1] on 00:17:F2:B4:BC:F5
[   31.262857] [drm] Setting GART location based on new memory map
[   31.264435] [drm] Loading R500 Microcode
[   31.264488] [drm] Num pipes: 1
[   31.264502] [drm] writeback test succeeded in 1 usecs
[   82.680920] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   82.682465] wlan0: authenticated
[   82.682471] wlan0: associate with AP 00:1e:2a:00:67:f0
[   82.686097] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 status=0 aid=33)
[   82.686103] wlan0: associated
[  194.711735] type=1400 audit(1226777516.267:3): avc:  denied  { getattr } for  pid=3234 comm="gvfs-hal-volume" path="inotify" dev=inotifyfs ino=1 scontext=a-12:sysadm_r:sysadm_dbusd_t:s0-s0:c0.c255 tcontext=system_u:object_r:inotifyfs_t:s0 tclass=dir
[  194.711762] type=1300 audit(1226777516.267:3): arch=40000003 syscall=197 success=no exit=-13 a0=9 a1=bf9940bc a2=b7d7dff4 a3=9 items=0 ppid=3233 pid=3234 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="gvfs-hal-volume" exe="/usr/lib/gvfs/gvfs-hal-volume-monitor" subj=a-12:sysadm_r:sysadm_dbusd_t:s0-s0:c0.c255 key=(null)
[  195.082818] type=1400 audit(1226777516.637:4): avc:  denied  { add_name } for  pid=3137 comm="evolution" name="enchant" scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_home_t:s0 tclass=dir
[  195.082855] type=1300 audit(1226777516.637:4): arch=40000003 syscall=39 success=no exit=-13 a0=88f81c8 a1=1c0 a2=b6a72ff4 a3=0 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 6738.496584] ACPI: EC: GPE storm detected, transactions will use polling mode
[ 8180.194126] type=1400 audit(1226785501.747:5): avc:  denied  { add_name } for  pid=3137 comm="evolution" name="enchant" scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_home_t:s0 tclass=dir
[ 8180.194163] type=1300 audit(1226785501.747:5): arch=40000003 syscall=39 success=no exit=-13 a0=8992c48 a1=1c0 a2=b6a72ff4 a3=0 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8217.804363] type=1400 audit(1226785539.360:6): avc:  denied  { add_name } for  pid=3137 comm="evolution" name="enchant" scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_home_t:s0 tclass=dir
[ 8217.804400] type=1300 audit(1226785539.360:6): arch=40000003 syscall=39 success=no exit=-13 a0=8d35378 a1=1c0 a2=b6a72ff4 a3=0 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8345.390308] type=1404 audit(1226785666.947:7): enforcing=0 old_enforcing=1 auid=4294967295 ses=4294967295
[ 8345.390396] type=1300 audit(1226785666.947:7): arch=40000003 syscall=4 success=yes exit=1 a0=3 a1=bfa9aa9c a2=1 a3=8048820 items=0 ppid=3530 pid=4041 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="setenforce" exe="/usr/sbin/setenforce" subj=a-12:sysadm_r:sysadm_t:s0-s0:c0.c255 key=(null)
[ 8352.119667] type=1400 audit(1226785673.637:8): avc:  denied  { search } for  pid=3137 comm="evolution" name="gtk-2.0" dev=sda1 ino=335878 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=dir
[ 8352.145310] type=1400 audit(1226785673.637:8): avc:  denied  { read } for  pid=3137 comm="evolution" name="gtkfilechooser.ini" dev=sda1 ino=337134 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8352.145388] type=1300 audit(1226785673.637:8): arch=40000003 syscall=5 success=yes exit=26 a0=8e50c70 a1=8000 a2=0 a3=8000 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8352.145462] type=1400 audit(1226785673.702:9): avc:  denied  { getattr } for  pid=3137 comm="evolution" path="/home/a-12/.config/gtk-2.0/gtkfilechooser.ini" dev=sda1 ino=337134 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8352.145513] type=1300 audit(1226785673.702:9): arch=40000003 syscall=197 success=yes exit=0 a0=1a a1=bfd6a134 a2=b69b7ff4 a3=1a items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8352.296255] type=1400 audit(1226785673.850:10): avc:  denied  { getattr } for  pid=4044 comm="evolution" path="/home/a-12/.gconf" dev=sda1 ino=336133 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gconf_home_t:s0 tclass=dir
[ 8352.296312] type=1300 audit(1226785673.850:10): arch=40000003 syscall=196 success=yes exit=0 a0=b493afe8 a1=b5243178 a2=b69b7ff4 a3=b493afe8 items=0 ppid=2834 pid=4044 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8352.368839] type=1400 audit(1226785673.920:11): avc:  denied  { getattr } for  pid=4044 comm="evolution" path="/home/a-12/tools" dev=sda1 ino=336206 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_home_t:s0 tclass=lnk_file
[ 8352.368902] type=1300 audit(1226785673.920:11): arch=40000003 syscall=196 success=yes exit=0 a0=b4902b08 a1=b5243178 a2=b69b7ff4 a3=b4902b08 items=0 ppid=2834 pid=4044 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8352.369003] type=1400 audit(1226785673.920:12): avc:  denied  { read } for  pid=4044 comm="evolution" name="tools" dev=sda1 ino=336206 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_home_t:s0 tclass=lnk_file
[ 8360.650827] __ratelimit: 15 callbacks suppressed
[ 8360.650833] type=1400 audit(1226785682.207:15): avc:  denied  { read } for  pid=3137 comm="evolution" name="gtkfilechooser.ini" dev=sda1 ino=337134 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8360.650908] type=1300 audit(1226785682.207:15): arch=40000003 syscall=5 success=yes exit=26 a0=8e65fa0 a1=8000 a2=0 a3=8000 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8360.651008] type=1400 audit(1226785682.207:16): avc:  denied  { getattr } for  pid=3137 comm="evolution" path="/home/a-12/.config/gtk-2.0/gtkfilechooser.ini" dev=sda1 ino=337134 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8360.651060] type=1300 audit(1226785682.207:16): arch=40000003 syscall=197 success=yes exit=0 a0=1a a1=bfd6a224 a2=b69b7ff4 a3=1a items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8360.651358] type=1400 audit(1226785682.207:17): avc:  denied  { write } for  pid=3137 comm="evolution" name="gtk-2.0" dev=sda1 ino=335878 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=dir
[ 8360.651408] type=1400 audit(1226785682.207:17): avc:  denied  { add_name } for  pid=3137 comm="evolution" name="gtkfilechooser.ini.9ZLKKU" scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=dir
[ 8360.651522] type=1400 audit(1226785682.207:17): avc:  denied  { create } for  pid=3137 comm="evolution" name="gtkfilechooser.ini.9ZLKKU" scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8360.651733] type=1400 audit(1226785682.207:17): avc:  denied  { write } for  pid=3137 comm="evolution" name="gtkfilechooser.ini.9ZLKKU" dev=sda1 ino=337135 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=file
[ 8360.651800] type=1300 audit(1226785682.207:17): arch=40000003 syscall=5 success=yes exit=26 a0=8e6ad08 a1=80c2 a2=1b6 a3=80c2 items=0 ppid=2834 pid=3137 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295 comm="evolution" exe="/usr/bin/evolution" subj=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 key=(null)
[ 8360.652125] type=1400 audit(1226785682.207:18): avc:  denied  { remove_name } for  pid=3137 comm="evolution" name="gtkfilechooser.ini.9ZLKKU" dev=sda1 ino=337135 scontext=a-12:sysadm_r:sysadm_evolution_t:s0-s0:c0.c255 tcontext=a-12:object_r:sysadm_gnome_home_t:s0 tclass=dir

--=-mZAyOLL1/zgXVJOIQd45--

