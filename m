Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbZA2Pe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbZA2Pe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZA2Pep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:34:45 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:20942 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZA2Pel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:34:41 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.29-rc3
Date: Thu, 29 Jan 2009 10:34:27 -0500
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain>
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_DycgJipHTfWbegW"
Message-id: <200901291034.27150.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_DycgJipHTfWbegW
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 28 January 2009, Linus Torvalds wrote:
>It's out there, and while it's a bit larger than I'd wish for, that size

Unforch, its not ready for prime time here.

1. In my buildit script, I copy the .config(s) from the defined $oldsrc tree 
to a safe place.  This includes the 'makeit' script.
2. I move the $src tree out of the way
3. Unpack new $src tree.
4. rename $src tree to $newversion, rename the $src.old back to $src
5. cd to $newversion
6. Copy all the .configs saved previously to this tree
7. apply the patch(plural if required)
8. make oldconfig
9. make xconfig (in case I want to change something)
exit

Then I cd to the new tree, and edit 'makeit' to fix its $VER, then
#> time ./makeit
which does everything but edit grub.conf for me.

It included all the reiserfs stuff I don't use, and pitched a fit over the 
includes
It skipped all the network hardware drivers so I had no network.

I redid the .config copying by hand, reran a make oldconfig by hand, and this 
time it worked although the make bzimage stage was still very noisy.  And I 
had a network when I rebooted to that version.

dmesg however was full of squawks (its attached) so I rebooted back to 
2.6.28.2.  Unforch the reboot killed the ethernet PHY's, so I had to crawl 
under the desk, pull the power and net cables, and go get a cuppa and check 
the weather (its snowing, yet, still, 3 days now about 40% of the time)
before coming back in and plugging everything in and tapping the power switch.

I'm getting smarter though, the next time I want to get out of a boot that 
isn't stable, I'll just tap the hardware reset, its a heck of a lot easier on 
hard drives.

The first squawk is caused apparently by my bios, that is in fact fixed if I 
update to the most recent, but that one cannot be used in the same machine as 
a stable kernel, its not in its vocabulary.  Support from ASUS is 
non-existent, I have sent several messages up the pipeline to them, with no 
response in over 60 days now.

Since apparently (see the dmesg) that first mtrr related bios wrinkle is fixed 
by the workaround, I see no valid reason to mark the system as 'Tainted' 
because of it, but it is.  What linux calls a Bios flub-up may be true, but 
once its 'fixed' with the older bios, the machine is rock solid.  The newer 
bios version doesn't need the fixup, and its uptimes range from 1 hour down 
to about the time x gets init'ed, sometimes even before, I have see it hang 
in the bootup, tap the hardware reset and it works ok for maybe an hour next 
time.

The next one (Oops/Bug) looks to be something in the cx88 code, which it seems 
has been changed since 2.6.28.

I also note that 2.6.28 doesn't have to do a workaround for reversed MAC's, 
also noted in this dmesg.

All in all, not ready for prime time use here, particularly when I want to 
reboot and have to use the hardware reset to do it if I don't want the MCP55 
ethernet ports turned off in a manner that requires this full powerdown reset 
stuff to recover.

That tends to take the fun out of playing the canary in the coal mine here.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
What does education often do?  It makes a straight cut ditch of a
free meandering brook.
		-- Henry David Thoreau

--Boundary-00=_DycgJipHTfWbegW
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg-2.6.29-rc3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.29-rc3"

[    0.000000] Linux version 2.6.29-rc3 (root@coyote.coyote.den) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #3 SMP PREEMPT Thu Jan 29 08:52:29 EST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:400 generic_get_mtrr+0xfa/0x110()
[    0.000000] Hardware name: System Product Name
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.29-rc3 #3
[    0.000000] Call Trace:
[    0.000000]  [<c0428716>] warn_slowpath+0x86/0xa0
[    0.000000]  [<c043f80b>] ? up+0x2b/0x40
[    0.000000]  [<c0428e64>] ? release_console_sem+0x1a4/0x1c0
[    0.000000]  [<c043f80b>] ? up+0x2b/0x40
[    0.000000]  [<c043f80b>] ? up+0x2b/0x40
[    0.000000]  [<c042943b>] ? printk+0x1b/0x20
[    0.000000]  [<c041b90f>] ? pat_init+0x7f/0xa0
[    0.000000]  [<c040fa9a>] generic_get_mtrr+0xfa/0x110
[    0.000000]  [<c071807a>] mtrr_trim_uncached_memory+0x7a/0x340
[    0.000000]  [<c0718411>] ? mtrr_bp_init+0xd1/0x6f0
[    0.000000]  [<c0714b66>] ? e820_end_pfn+0xc6/0xf0
[    0.000000]  [<c071312c>] setup_arch+0x43c/0x9a0
[    0.000000]  [<c042943b>] ? printk+0x1b/0x20
[    0.000000]  [<c070ca7c>] start_kernel+0x6c/0x300
[    0.000000]  [<c070c3d6>] ? reserve_ebda_region+0x56/0x70
[    0.000000]  [<c070c34c>] i386_start_kernel+0x7c/0xb0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  modified: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  modified: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  modified: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] kernel direct mapping tables up to 379fe000 @ 10000-16000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 37cfb000 - 37fefa33
[    0.000000] Allocated new RAMDISK: 00100000 - 003f4a33
[    0.000000] Move RAMDISK from 0000000037cfb000 - 0000000037fefa32 to 00100000 - 003f4a32
[    0.000000] ACPI: RSDP 000F7D20, 0024 (r2 Nvidia)
[    0.000000] ACPI: XSDT DFEE3100, 0044 (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP DFEEADC0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aEventBlock: 32/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aControlBlock: 16/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in PmTimerBlock: 32/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 64/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe1Block: 128/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aEventBlock: 8, using default 32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 8, using default 16 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 8, using default 32 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT DFEE3280, 7ACE (r1 NVIDIA AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS DFEE0000, 0040
[    0.000000] ACPI: HPET DFEEB000, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG DFEEB080, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC DFEEAF00, 0098 (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3718MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 00000000 - 379fe000
[    0.000000]   bootmap 00012000 - 00018f40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000400000 - 00007ba374]    TEXT DATA BSS ==> [0000400000 - 00007ba374]
[    0.000000]   #4 [00007bb000 - 00007c3000]    INIT_PG_TABLE ==> [00007bb000 - 00007c3000]
[    0.000000]   #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000100000 - 00003f4a33]      NEW RAMDISK ==> [0000100000 - 00003f4a33]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000] free_area_init_node: node 0, pgdat c06eba00, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7437 pages used for memmap
[    0.000000]   HighMem zone: 813013 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at e0000000 (gap: dff00000:10100000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038958
[    0.000000] Kernel command line: ro root=LABEL=/ rhgb quiet nomodeset
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c076b000 soft=c0763000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2209.330 MHz processor.
[    0.000999] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 4147036k/4718592k available (2175k kernel code, 44884k reserved, 925k data, 336k init, 3281800k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
[    0.000999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000999]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000999]       .init : 0xc070c000 - 0xc0760000   ( 336 kB)
[    0.000999]       .data : 0xc061fc1e - 0xc0707020   ( 925 kB)
[    0.000999]       .text : 0xc0400000 - 0xc061fc1e   (2175 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] hpet clockevent registered
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4418.66 BogoMIPS (lpj=2209330)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] using C1E aware idle routine
[    0.000999] Checking 'hlt' instruction... OK.
[    0.004208] Freeing SMP alternatives: 10k freed
[    0.004210] ACPI: Core revision 20081204
[    0.016157] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026168] CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.026999] CPU 1 irqstacks, hard=c076c000 soft=c0764000
[    0.026999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4420.12 BogoMIPS (lpj=2210060)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.097728] CPU1: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.097735] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.098078] CPU 2 irqstacks, hard=c076d000 soft=c0765000
[    0.098080] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4419.99 BogoMIPS (lpj=2209998)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.169651] CPU2: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.169660] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.170069] CPU 3 irqstacks, hard=c076e000 soft=c0766000
[    0.170072] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4420.00 BogoMIPS (lpj=2210003)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.241676] CPU3: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.241685] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.242025] Brought up 4 CPUs
[    0.242028] Total of 4 processors activated (17678.78 BogoMIPS).
[    0.243150] net_namespace: 532 bytes
[    0.243367] NET: Registered protocol family 16
[    0.243662] ACPI: bus type pci registered
[    0.243797] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.243799] PCI: MCFG area at f0000000 reserved in E820
[    0.243801] PCI: Using MMCONFIG for extended config space
[    0.243803] PCI: Using configuration type 1 for base access
[    0.245550] bio: create slab <bio-0> at 0
[    0.246494] ACPI: EC: Look up EC in DSDT
[    0.257194] ACPI: Interpreter enabled
[    0.257198] ACPI: (supports S0 S5)
[    0.257209] ACPI: Using IOAPIC for interrupt routing
[    0.268949] ACPI: No dock devices found.
[    0.268962] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.269191] pci 0000:00:01.1: reg 10 io port: [0xfc00-0xfc3f]
[    0.269202] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
[    0.269206] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
[    0.269225] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.269230] pci 0000:00:01.1: PME# disabled
[    0.269251] pci 0000:00:02.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
[    0.269269] pci 0000:00:02.0: supports D1 D2
[    0.269271] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269273] pci 0000:00:02.0: PME# disabled
[    0.269289] pci 0000:00:02.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
[    0.269307] pci 0000:00:02.1: supports D1 D2
[    0.269309] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269311] pci 0000:00:02.1: PME# disabled
[    0.269334] pci 0000:00:04.0: reg 20 io port: [0xf000-0xf00f]
[    0.269358] pci 0000:00:05.0: reg 10 io port: [0x9f0-0x9f7]
[    0.269361] pci 0000:00:05.0: reg 14 io port: [0xbf0-0xbf3]
[    0.269364] pci 0000:00:05.0: reg 18 io port: [0x970-0x977]
[    0.269367] pci 0000:00:05.0: reg 1c io port: [0xb70-0xb73]
[    0.269370] pci 0000:00:05.0: reg 20 io port: [0xdc00-0xdc0f]
[    0.269373] pci 0000:00:05.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.269400] pci 0000:00:05.1: reg 10 io port: [0x9e0-0x9e7]
[    0.269403] pci 0000:00:05.1: reg 14 io port: [0xbe0-0xbe3]
[    0.269406] pci 0000:00:05.1: reg 18 io port: [0x960-0x967]
[    0.269409] pci 0000:00:05.1: reg 1c io port: [0xb60-0xb63]
[    0.269412] pci 0000:00:05.1: reg 20 io port: [0xc800-0xc80f]
[    0.269415] pci 0000:00:05.1: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
[    0.269442] pci 0000:00:05.2: reg 10 io port: [0xc400-0xc407]
[    0.269445] pci 0000:00:05.2: reg 14 io port: [0xc000-0xc003]
[    0.269448] pci 0000:00:05.2: reg 18 io port: [0xbc00-0xbc07]
[    0.269451] pci 0000:00:05.2: reg 1c io port: [0xb800-0xb803]
[    0.269454] pci 0000:00:05.2: reg 20 io port: [0xb400-0xb40f]
[    0.269457] pci 0000:00:05.2: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.269508] pci 0000:00:06.1: reg 10 32bit mmio: [0xfe020000-0xfe023fff]
[    0.269530] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.269532] pci 0000:00:06.1: PME# disabled
[    0.269560] pci 0000:00:08.0: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.269563] pci 0000:00:08.0: reg 14 io port: [0xb000-0xb007]
[    0.269567] pci 0000:00:08.0: reg 18 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.269570] pci 0000:00:08.0: reg 1c 32bit mmio: [0xfe028000-0xfe02800f]
[    0.269589] pci 0000:00:08.0: supports D1 D2
[    0.269590] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269594] pci 0000:00:08.0: PME# disabled
[    0.269619] pci 0000:00:09.0: reg 10 32bit mmio: [0xfe027000-0xfe027fff]
[    0.269622] pci 0000:00:09.0: reg 14 io port: [0xac00-0xac07]
[    0.269625] pci 0000:00:09.0: reg 18 32bit mmio: [0xfe026000-0xfe0260ff]
[    0.269628] pci 0000:00:09.0: reg 1c 32bit mmio: [0xfe025000-0xfe02500f]
[    0.269647] pci 0000:00:09.0: supports D1 D2
[    0.269649] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269652] pci 0000:00:09.0: PME# disabled
[    0.269688] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269690] pci 0000:00:0e.0: PME# disabled
[    0.269716] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269718] pci 0000:00:0f.0: PME# disabled
[    0.269812] pci 0000:01:07.0: reg 10 io port: [0x9c00-0x9c3f]
[    0.269837] pci 0000:01:07.0: supports D1 D2
[    0.269858] pci 0000:01:08.0: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
[    0.269901] pci 0000:01:08.2: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.269948] pci 0000:01:0b.0: reg 10 32bit mmio: [0xfcfff000-0xfcfff7ff]
[    0.269952] pci 0000:01:0b.0: reg 14 32bit mmio: [0xfcff8000-0xfcffbfff]
[    0.269977] pci 0000:01:0b.0: supports D1 D2
[    0.269978] pci 0000:01:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.269981] pci 0000:01:0b.0: PME# disabled
[    0.270001] pci 0000:00:06.0: transparent bridge
[    0.270004] pci 0000:00:06.0: bridge io port: [0x9000-0x9fff]
[    0.270006] pci 0000:00:06.0: bridge 32bit mmio: [0xfa000000-0xfcffffff]
[    0.270033] pci 0000:00:0e.0: bridge io port: [0x7000-0x8fff]
[    0.270035] pci 0000:00:0e.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.270058] pci 0000:03:00.0: reg 10 64bit mmio: [0xe0000000-0xefffffff]
[    0.270065] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdde0000-0xfddeffff]
[    0.270069] pci 0000:03:00.0: reg 20 io port: [0x6c00-0x6cff]
[    0.270076] pci 0000:03:00.0: reg 30 32bit mmio: [0xfddc0000-0xfdddffff]
[    0.270090] pci 0000:03:00.0: supports D1 D2
[    0.270114] pci 0000:03:00.1: reg 10 64bit mmio: [0xfddfc000-0xfddfffff]
[    0.270140] pci 0000:03:00.1: supports D1 D2
[    0.272056] pci 0000:00:0f.0: bridge io port: [0x6000-0x6fff]
[    0.272058] pci 0000:00:0f.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.272061] pci 0000:00:0f.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.272068] pci_bus 0000:00: on NUMA node 0
[    0.272074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.272358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.333090] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333296] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
[    0.333503] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333709] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333914] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334126] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 *11 14 15)
[    0.334333] ACPI: PCI Interrupt Link [LNK7] (IRQs *5 7 9 10 11 14 15)
[    0.334539] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334747] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334953] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.335168] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
[    0.335375] ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 *10 11 14 15)
[    0.335581] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[    0.335787] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.336001] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.336203] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.336410] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.336617] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[    0.336821] ACPI: PCI Interrupt Link [LFID] (IRQs *5 7 9 10 11 14 15)
[    0.337034] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 *10 11 14 15)
[    0.337277] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.337520] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.337759] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.338007] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.338245] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.338479] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
[    0.338718] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.338945] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.339192] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    0.339432] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.339671] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0
[    0.339911] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.340159] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.340398] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    0.340637] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    0.340876] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.341118] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.341357] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.341599] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.341840] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.342256] usbcore: registered new interface driver usbfs
[    0.342321] usbcore: registered new interface driver hub
[    0.342370] usbcore: registered new device driver usb
[    0.342499] PCI: Using ACPI for IRQ routing
[    0.346018] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.346021] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.352006] pnp: PnP ACPI init
[    0.352011] ACPI: bus type pnp registered
[    0.358206] pnp: PnP ACPI: found 13 devices
[    0.358208] ACPI: ACPI bus type pnp unregistered
[    0.358216] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.358218] system 00:01: ioport range 0x1080-0x10ff has been reserved
[    0.358221] system 00:01: ioport range 0x1400-0x147f has been reserved
[    0.358223] system 00:01: ioport range 0x1480-0x14ff has been reserved
[    0.358225] system 00:01: ioport range 0x1800-0x187f has been reserved
[    0.358228] system 00:01: ioport range 0x1880-0x18ff has been reserved
[    0.358233] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.358235] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.358237] system 00:02: ioport range 0x290-0x297 has been reserved
[    0.358244] system 00:0b: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.358249] system 00:0c: iomem range 0xcf000-0xcffff has been reserved
[    0.358251] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.358253] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.358256] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.358258] system 00:0c: iomem range 0xfefff000-0xfefff0ff has been reserved
[    0.358261] system 00:0c: iomem range 0xdfee0000-0xdfefffff could not be reserved
[    0.358263] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[    0.358265] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.358268] system 00:0c: iomem range 0x100000-0xdfedffff could not be reserved
[    0.358270] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.358273] system 00:0c: iomem range 0xfee00000-0xfeefffff has been reserved
[    0.358276] system 00:0c: iomem range 0xfefff000-0xfeffffff could not be reserved
[    0.358278] system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved
[    0.358281] system 00:0c: iomem range 0xfff90000-0xfffbffff has been reserved
[    0.358283] system 00:0c: iomem range 0xfffed000-0xfffeffff has been reserved
[    0.393245] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.393248] pci 0000:00:06.0:   IO window: 0x9000-0x9fff
[    0.393250] pci 0000:00:06.0:   MEM window: 0xfa000000-0xfcffffff
[    0.393253] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.393255] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
[    0.393257] pci 0000:00:0e.0:   IO window: 0x7000-0x8fff
[    0.393260] pci 0000:00:0e.0:   MEM window: 0xfde00000-0xfdefffff
[    0.393262] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.393265] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:03
[    0.393267] pci 0000:00:0f.0:   IO window: 0x6000-0x6fff
[    0.393269] pci 0000:00:0f.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.393272] pci 0000:00:0f.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
[    0.393278] pci 0000:00:06.0: setting latency timer to 64
[    0.393282] pci 0000:00:0e.0: setting latency timer to 64
[    0.393286] pci 0000:00:0f.0: setting latency timer to 64
[    0.393288] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.393290] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.393293] pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
[    0.393295] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfcffffff]
[    0.393296] pci_bus 0000:01: resource 2 mem: [0x0-0x0]
[    0.393298] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.393300] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.393302] pci_bus 0000:02: resource 0 io:  [0x7000-0x8fff]
[    0.393304] pci_bus 0000:02: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.393306] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.393307] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.393309] pci_bus 0000:03: resource 0 io:  [0x6000-0x6fff]
[    0.393311] pci_bus 0000:03: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.393313] pci_bus 0000:03: resource 2 mem: [0xe0000000-0xefffffff]
[    0.393314] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.393365] NET: Registered protocol family 2
[    0.409079] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.409358] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.409819] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.410073] TCP: Hash tables configured (established 131072 bind 65536)
[    0.410075] TCP reno registered
[    0.415099] NET: Registered protocol family 1
[    0.415221] checking if image is initramfs...<7>Switched to high resolution mode on CPU 2
[    0.500751] Switched to high resolution mode on CPU 3
[    0.500802] Switched to high resolution mode on CPU 1
[    0.501039] Switched to high resolution mode on CPU 0
[    0.518178]  it is
[    0.627417] Freeing initrd memory: 3026k freed
[    0.628768] Scanning for low memory corruption every 60 seconds
[    0.628924] audit: initializing netlink socket (disabled)
[    0.628939] type=2000 audit(1233237483.628:1): initialized
[    0.629340] highmem bounce pool size: 64 pages
[    0.629344] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.629531] msgmni has been set to 1697
[    0.629777] alg: No test for stdrng (krng)
[    0.629834] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.629837] io scheduler noop registered
[    0.629857] io scheduler cfq registered (default)
[    0.642787] pci 0000:03:00.0: Boot video device
[    0.642906] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    0.643020] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    0.643259] fan PNP0C0B:00: registered as cooling_device0
[    0.643262] ACPI: Fan [FAN] (on)
[    0.643749] processor ACPI_CPU:00: registered as cooling_device1
[    0.643802] processor ACPI_CPU:01: registered as cooling_device2
[    0.643852] processor ACPI_CPU:02: registered as cooling_device3
[    0.643904] processor ACPI_CPU:03: registered as cooling_device4
[    0.644400] ACPI Warning (nspredef-0940): \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference [20081204]
[    0.644406] ACPI: Expecting a [Reference] package element, found type 0
[    0.644436] ACPI: Invalid passive threshold
[    0.644665] thermal LNXTHERM:01: registered as thermal_zone0
[    0.645131] ACPI: Thermal Zone [THRM] (40 C)
[    0.647800] Real Time Clock Driver v1.12b
[    0.648015] Non-volatile memory driver v1.3
[    0.648018] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.648128] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.648480] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.649974] brd: module loaded
[    0.650197] PNP: No PS/2 controller found. Probing ports directly.
[    0.650603] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.650608] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.650691] mice: PS/2 mouse device common for all mice
[    0.650842] cpuidle: using governor ladder
[    0.651623] usbcore: registered new interface driver hiddev
[    0.651655] usbcore: registered new interface driver usbhid
[    0.651657] usbhid: v2.6:USB HID core driver
[    0.651900] TCP cubic registered
[    0.651901] Initializing XFRM netlink socket
[    0.651914] NET: Registered protocol family 17
[    0.651933] Using IPI Shortcut mode
[    0.652309] Freeing unused kernel memory: 336k freed
[    0.908633] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.909040] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
[    0.909051] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 23 (level, low) -> IRQ 23
[    0.909076] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    0.909078] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    0.909185] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.909211] ehci_hcd 0000:00:02.1: debug port 1
[    0.909214] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    0.909229] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe02e000
[    0.915016] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.915036] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.915038] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.915040] usb usb1: Product: EHCI Host Controller
[    0.915041] usb usb1: Manufacturer: Linux 2.6.29-rc3 ehci_hcd
[    0.915043] usb usb1: SerialNumber: 0000:00:02.1
[    0.915100] usb usb1: configuration #1 chosen from 1 choice
[    0.915135] hub 1-0:1.0: USB hub found
[    0.915141] hub 1-0:1.0: 10 ports detected
[    0.917391] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.917790] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[    0.917800] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 22 (level, low) -> IRQ 22
[    0.917822] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.917824] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.917901] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    0.917924] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[    0.970291] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.970293] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.970295] usb usb2: Product: OHCI Host Controller
[    0.970297] usb usb2: Manufacturer: Linux 2.6.29-rc3 ohci_hcd
[    0.970298] usb usb2: SerialNumber: 0000:00:02.0
[    0.970357] usb usb2: configuration #1 chosen from 1 choice
[    0.970399] hub 2-0:1.0: USB hub found
[    0.970407] hub 2-0:1.0: 10 ports detected
[    0.972570] uhci_hcd: USB Universal Host Controller Interface driver
[    0.993209] SCSI subsystem initialized
[    0.996215] Driver 'sd' needs updating - please use bus_type methods
[    1.009197] libata version 3.00 loaded.
[    1.011423] pata_amd 0000:00:04.0: version 0.3.11
[    1.011457] pata_amd 0000:00:04.0: setting latency timer to 64
[    1.011513] scsi0 : pata_amd
[    1.011604] scsi1 : pata_amd
[    1.012368] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    1.012371] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.385343] ata1.00: ATA-7: MAXTOR STM3320620A, 3.AAE, max UDMA/100
[    1.385345] ata1.00: 625142448 sectors, multi 1: LBA48 
[    1.385380] ata1.01: ATAPI: HP DVD Writer 1040d, EH24, max UDMA/66
[    1.385405] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c50000) ACPI=0x3f01f (20:30:0x1f)
[    1.385409] ata1: nv_mode_filter: 0x1f39f&0x1f01f->0x1f01f, BIOS=0x1f000 (0xc6c50000) ACPI=0x1f01f (20:30:0x1f)
[    1.460297] ata1.00: configured for UDMA/100
[    1.473144] usb 1-10: new high speed USB device using ehci_hcd and address 5
[    1.482579] ata1.01: configured for UDMA/66
[    1.483344] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
[    1.483460] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.483471] sd 0:0:0:0: [sda] Write Protect is off
[    1.483473] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.483486] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.483536] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.483546] sd 0:0:0:0: [sda] Write Protect is off
[    1.483548] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.483568] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.483570]  sda: sda1 sda2 sda3
[    1.508481] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.509557] scsi 0:0:1:0: CD-ROM            HP       DVD Writer 1040d EH24 PQ: 0 ANSI: 5
[    1.509684] ata2: port disabled. ignoring.
[    1.586884] usb 1-10: New USB device found, idVendor=0409, idProduct=0059
[    1.586886] usb 1-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.586944] usb 1-10: configuration #1 chosen from 1 choice
[    1.587043] hub 1-10:1.0: USB hub found
[    1.587131] hub 1-10:1.0: 4 ports detected
[    1.804393] usb 2-2: new full speed USB device using ohci_hcd and address 2
[    1.954664] usb 2-2: New USB device found, idVendor=04b8, idProduct=0005
[    1.954666] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.954668] usb 2-2: Product: USB Printer
[    1.954671] usb 2-2: Manufacturer: EPSON
[    1.954673] usb 2-2: SerialNumber: RL0200301161041200
[    1.954731] usb 2-2: configuration #1 chosen from 1 choice
[    2.174391] usb 2-4: new low speed USB device using ohci_hcd and address 3
[    2.319804] usb 2-4: New USB device found, idVendor=046d, idProduct=c517
[    2.319806] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.319808] usb 2-4: Product: USB Receiver
[    2.319812] usb 2-4: Manufacturer: Logitech
[    2.319861] usb 2-4: configuration #1 chosen from 1 choice
[    2.330012] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.0/input/input0
[    2.335432] logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-4/input0
[    2.343813] logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
[    2.344369] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.1/input/input1
[    2.355486] logitech 0003:046D:C517.0002: input,hiddev96,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-4/input1
[    2.572392] usb 2-5: new full speed USB device using ohci_hcd and address 4
[    2.707956] usb 2-5: New USB device found, idVendor=0451, idProduct=2046
[    2.707958] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.708016] usb 2-5: configuration #1 chosen from 1 choice
[    2.710989] hub 2-5:1.0: USB hub found
[    2.713957] hub 2-5:1.0: 4 ports detected
[    2.806111] usb 1-10.1: new low speed USB device using ehci_hcd and address 6
[    3.011934] usb 1-10.1: New USB device found, idVendor=050d, idProduct=0751
[    3.011937] usb 1-10.1: New USB device strings: Mfr=4, Product=20, SerialNumber=0
[    3.011939] usb 1-10.1: Product: Belkin UPS
[    3.011940] usb 1-10.1: Manufacturer: Belkin 
[    3.011990] usb 1-10.1: configuration #1 chosen from 1 choice
[    3.715643] generic-usb 0003:050D:0751.0003: hiddev97,hidraw2: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:02.1-10.1/input0
[    3.792500] usb 1-10.2: new full speed USB device using ehci_hcd and address 7
[    3.891527] usb 1-10.2: New USB device found, idVendor=0403, idProduct=6001
[    3.891529] usb 1-10.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.891531] usb 1-10.2: Product: USB FAST SERIAL ADAPTER
[    3.891532] usb 1-10.2: Manufacturer: FTDI
[    3.891534] usb 1-10.2: SerialNumber: FTOOS09N
[    3.891588] usb 1-10.2: configuration #1 chosen from 1 choice
[    3.968562] usb 1-10.3: new full speed USB device using ehci_hcd and address 8
[    4.013902] sata_nv 0000:00:05.0: version 3.5
[    4.014319] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
[    4.014329] sata_nv 0000:00:05.0: PCI INT A -> Link[APSI] -> GSI 21 (level, low) -> IRQ 21
[    4.014331] sata_nv 0000:00:05.0: Using SWNCQ mode
[    4.014631] sata_nv 0000:00:05.0: setting latency timer to 64
[    4.014814] scsi2 : sata_nv
[    4.014982] scsi3 : sata_nv
[    4.015185] ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xdc00 irq 21
[    4.015187] ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xdc08 irq 21
[    4.056463] usb 1-10.3: New USB device found, idVendor=03eb, idProduct=3301
[    4.056466] usb 1-10.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    4.056468] usb 1-10.3: Product: Standard USB Hub
[    4.056535] usb 1-10.3: configuration #1 chosen from 1 choice
[    4.057237] hub 1-10.3:1.0: USB hub found
[    4.057337] hub 1-10.3:1.0: 4 ports detected
[    4.131624] usb 1-10.4: new high speed USB device using ehci_hcd and address 9
[    4.218900] usb 1-10.4: New USB device found, idVendor=0409, idProduct=0059
[    4.218902] usb 1-10.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.218951] usb 1-10.4: configuration #1 chosen from 1 choice
[    4.219058] hub 1-10.4:1.0: USB hub found
[    4.219150] hub 1-10.4:1.0: 4 ports detected
[    4.492764] usb 1-10.4.4: new full speed USB device using ehci_hcd and address 10
[    4.580914] usb 1-10.4.4: New USB device found, idVendor=04b8, idProduct=010f
[    4.580916] usb 1-10.4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.580918] usb 1-10.4.4: Product: EPSON Scanner 010F
[    4.580922] usb 1-10.4.4: Manufacturer: EPSON
[    4.580972] usb 1-10.4.4: configuration #1 chosen from 1 choice
[    4.888293] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.891745] ata3.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    4.891748] ata3.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.897882] ata3.00: configured for UDMA/133
[    4.897958] scsi 2:0:0:0: Direct-Access     ATA      ST3500320AS      SD1A PQ: 0 ANSI: 5
[    4.898065] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    4.898075] sd 2:0:0:0: [sdb] Write Protect is off
[    4.898077] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.898090] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.898146] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    4.898154] sd 2:0:0:0: [sdb] Write Protect is off
[    4.898156] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.898169] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.898176]  sdb: sdb1 sdb2 sdb3
[    4.902253] sd 2:0:0:0: [sdb] Attached SCSI disk
[    5.776289] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.779557] ata4.00: ATA-7: Hitachi HDT725040VLA360, V5COA7EA, max UDMA/133
[    5.779559] ata4.00: 781422768 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    5.785699] ata4.00: configured for UDMA/133
[    5.785762] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5CO PQ: 0 ANSI: 5
[    5.785871] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors: (400 GB/372 GiB)
[    5.785881] sd 3:0:0:0: [sdc] Write Protect is off
[    5.785884] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.785897] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.785938] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors: (400 GB/372 GiB)
[    5.785951] sd 3:0:0:0: [sdc] Write Protect is off
[    5.785953] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.785970] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.785977]  sdc: sdc1
[    5.800177] sd 3:0:0:0: [sdc] Attached SCSI disk
[    5.800653] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
[    5.800663] sata_nv 0000:00:05.1: PCI INT B -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
[    5.800666] sata_nv 0000:00:05.1: Using SWNCQ mode
[    5.800949] sata_nv 0000:00:05.1: setting latency timer to 64
[    5.801049] scsi4 : sata_nv
[    5.801136] scsi5 : sata_nv
[    5.801352] ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc800 irq 20
[    5.801354] ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc808 irq 20
[    6.534602] ata5: SATA link down (SStatus 0 SControl 300)
[    7.267599] ata6: SATA link down (SStatus 0 SControl 300)
[    7.267976] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[    7.267979] sata_nv 0000:00:05.2: PCI INT C -> Link[ASA2] -> GSI 23 (level, low) -> IRQ 23
[    7.267981] sata_nv 0000:00:05.2: Using SWNCQ mode
[    7.268258] sata_nv 0000:00:05.2: setting latency timer to 64
[    7.268325] scsi6 : sata_nv
[    7.268412] scsi7 : sata_nv
[    7.268600] ata7: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb400 irq 23
[    7.268602] ata8: SATA max UDMA/133 cmd 0xbc00 ctl 0xb800 bmdma 0xb408 irq 23
[    8.001600] ata7: SATA link down (SStatus 0 SControl 300)
[    8.734600] ata8: SATA link down (SStatus 0 SControl 300)
[   16.553155] kjournald starting.  Commit interval 5 seconds
[   16.553163] EXT3-fs: mounted filesystem with ordered data mode.
[   16.848493] type=1404 audit(1233237499.848:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   16.988931] SELinux: 8192 avtab hash slots, 228199 rules.
[   17.027461] SELinux: 8192 avtab hash slots, 228199 rules.
[   17.055730] SELinux:  8 users, 12 roles, 2519 types, 116 bools, 1 sens, 1024 cats
[   17.055734] SELinux:  67 classes, 228199 rules
[   17.057544] SELinux:  class peer not defined in policy
[   17.057546] SELinux:  class capability2 not defined in policy
[   17.057548] SELinux:  class kernel_service not defined in policy
[   17.057556] SELinux:  permission open in class dir not defined in policy
[   17.057559] SELinux:  permission open in class file not defined in policy
[   17.057562] SELinux:  permission open in class chr_file not defined in policy
[   17.057564] SELinux:  permission open in class blk_file not defined in policy
[   17.057566] SELinux:  permission open in class fifo_file not defined in policy
[   17.057574] SELinux:  permission recvfrom in class node not defined in policy
[   17.057576] SELinux:  permission sendto in class node not defined in policy
[   17.057581] SELinux:  permission ingress in class netif not defined in policy
[   17.057583] SELinux:  permission egress in class netif not defined in policy
[   17.057618] SELinux:  permission setfcap in class capability not defined in policy
[   17.057631] SELinux:  permission forward_in in class packet not defined in policy
[   17.057633] SELinux:  permission forward_out in class packet not defined in policy
[   17.057736] SELinux: the above unknown classes and permissions will be allowed
[   17.057739] SELinux:  Completing initialization.
[   17.057740] SELinux:  Setting up existing superblocks.
[   17.079797] SELinux: initialized (dev sdb3, type ext3), uses xattr
[   17.179519] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   17.179530] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.179617] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   17.179638] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   17.179646] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   17.179651] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   17.179659] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   17.179662] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.179669] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   17.179673] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   17.179678] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   17.179699] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   17.179706] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   17.179716] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   17.179720] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   17.179736] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   17.198294] type=1403 audit(1233237500.198:3): policy loaded auid=4294967295 ses=4294967295
[   19.612241] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.612262] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[   19.612283] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   19.612304] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   19.615133] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   19.618493] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   19.637069] ACPI: Power Button (FF) [PWRF]
[   19.637127] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   19.647421] ACPI: Power Button (CM) [PWRB]
[   19.657024] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[   19.657030] ACPI: I/O resource nForce2_smbus [0x1c40-0x1c7f] conflicts with ACPI region SM01 [0x1c40-0x1c45]
[   19.657033] ACPI: Device needs an ACPI driver
[   19.657044] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
[   19.661559] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
[   19.661579] usbcore: registered new interface driver usblp
[   19.717285] usbcore: registered new interface driver usbserial
[   19.717290] usbserial: USB Serial Driver core
[   19.722841] Driver 'sr' needs updating - please use bus_type methods
[   19.724161] Floppy drive(s): fd0 is 1.44M
[   19.727130] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.62.
[   19.727651] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[   19.727656] forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low) -> IRQ 22
[   19.727660] forcedeth 0000:00:08.0: setting latency timer to 64
[   19.727809] nv_probe: set workaround bit for reversed mac addr
[   19.730916] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   19.730921] Uniform CD-ROM driver Revision: 3.20
[   19.731058] sr 0:0:1:0: Attached scsi CD-ROM sr0
[   19.731609] USB Serial support registered for FTDI USB Serial Device
[   19.731672] ftdi_sio 1-10.2:1.0: FTDI USB Serial Device converter detected
[   19.731701] usb 1-10.2: Detected FT232RL
[   19.731763] usb 1-10.2: FTDI USB Serial Device converter now attached to ttyUSB0
[   19.731791] usbcore: registered new interface driver ftdi_sio
[   19.731793] ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
[   19.739000] FDC 0 is a post-1991 82077
[   19.914729] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   19.914740] firewire_ohci 0000:01:0b.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
[   19.933388] Linux video capture interface: v2.00
[   19.972143] firewire_ohci: Added fw-ohci device 0000:01:0b.0, OHCI version 1.10
[   20.117893] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   20.118523] cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected], frontend(s): 1
[   20.118525] cx88[0]: TV tuner type 60, Radio tuner type -1
[   20.134243] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   20.239869] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1f:c6:62:fc:bb
[   20.239873] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   20.240309] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
[   20.240314] HDA Intel 0000:00:06.1: PCI INT B -> Link[AAZA] -> GSI 21 (level, low) -> IRQ 21
[   20.240367] HDA Intel 0000:00:06.1: setting latency timer to 64
[   20.255696] tuner' 2-0043: chip found @ 0x86 (cx88[0])
[   20.268128] tda9887 2-0043: creating new instance
[   20.268131] tda9887 2-0043: tda988[5/6/7] found
[   20.271280] tuner' 2-0061: chip found @ 0xc2 (cx88[0])
[   20.324983] tuner-simple 2-0061: creating new instance
[   20.324987] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   20.327300] cx88[0]/2: cx2388x 8802 Driver Manager
[   20.327715] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   20.327725] cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   20.327732] cx88[0]/2: found at 0000:01:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xfa000000
[   20.327736] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   20.327790] cx8800 0000:01:08.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   20.327799] cx88[0]/0: found at 0000:01:08.0, rev: 5, irq: 18, latency: 32, mmio: 0xfb000000
[   20.327808] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   20.327869] cx88[0]/0: registered device video0 [v4l2]
[   20.327885] cx88[0]/0: registered device vbi0
[   20.327903] cx88[0]/0: registered device radio0
[   20.330282] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   20.330295] EMU10K1_Audigy 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   20.332520] Audigy2 value: Special config.
[   20.346268] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   20.346272] cx88/2: registering cx8802 driver, type: dvb access: shared
[   20.346276] cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
[   20.346278] cx88[0]/2: cx2388x based DVB/ATSC card
[   20.346287] BUG: unable to handle kernel NULL pointer dereference at (null)
[   20.346358] IP: [<c061d77d>] __mutex_lock_slowpath+0x2d/0xa0
[   20.346413] *pdpt = 000000003582c001 *pde = 0000000000000000 
[   20.346417] Oops: 0002 [#1] PREEMPT SMP 
[   20.346502] last sysfs file: /sys/devices/pci0000:00/0000:00:06.0/0000:01:08.0/video4linux/vbi0/dev
[   20.346532] Modules linked in: cx88_dvb(+) videobuf_dvb dvb_core tuner_simple tuner_types tda9887 tda8290 tuner snd_emu10k1 snd_hda_intel(+) snd_seq_dummy snd_hda_codec cx8800 snd_seq_oss(+) cx8802 cx88xx snd_seq_midi_event snd_rawmidi snd_seq snd_ac97_codec ir_common snd_pcm_oss snd_mixer_oss ac97_bus v4l2_common snd_seq_device videodev i2c_algo_bit snd_pcm firewire_ohci snd_util_mem firewire_core tveeprom v4l1_compat snd_hwdep btcx_risc videobuf_dma_sg snd_timer videobuf_core crc_itu_t snd ftdi_sio forcedeth(+) floppy sr_mod usbserial snd_page_alloc i2c_nforce2 soundcore usblp cdrom button pcspkr sg i2c_core joydev evdev ahci pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[   20.347382] 
[   20.347382] Pid: 1797, comm: modprobe Tainted: G        W  (2.6.29-rc3 #3) System Product Name
[   20.347382] EIP: 0060:[<c061d77d>] EFLAGS: 00010246 CPU: 3
[   20.347382] EIP is at __mutex_lock_slowpath+0x2d/0xa0
[   20.347382] EAX: f5dc3e48 EBX: f5901904 ECX: f5901804 EDX: 00000000
[   20.347382] ESI: f5901908 EDI: f590190c EBP: f5dc3e60 ESP: f5dc3e44
[   20.347382]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   20.347382] Process modprobe (pid: 1797, ti=f5dc3000 task=f5c851f0 task.ti=f5dc3000)
[   20.347382] Stack:
[   20.347382]  f5c851f0 f590190c f5dc3e7a c0684f05 f59018fc f5d62800 00000001 f5dc3e68
[   20.347382]  c061d59d f5dc3e80 f8435148 f5901904 ffffffed f5d62800 00000001 f5dc3ecc
[   20.347382]  f8446457 f8449214 f5d62810 0005489c 00000000 14a3a42f 00000006 00000202
[   20.347382] Call Trace:
[   20.347382]  [<c061d59d>] ? mutex_lock+0xd/0x10
[   20.347382]  [<f8435148>] ? videobuf_dvb_get_frontend+0x18/0x60 [videobuf_dvb]
[   20.347382]  [<f8446457>] ? cx8802_dvb_probe+0xe7/0x1fc0 [cx88_dvb]
[   20.347382]  [<f84460f0>] ? cx8802_dvb_advise_release+0x0/0x70 [cx88_dvb]
[   20.347382]  [<f8561534>] ? cx8802_register_driver+0x1a4/0x1f0 [cx8802]
[   20.347382]  [<f84483c0>] ? dvb_init+0x0/0x40 [cx88_dvb]
[   20.347382]  [<f84483f4>] ? dvb_init+0x34/0x40 [cx88_dvb]
[   20.347382]  [<c040102a>] ? _stext+0x2a/0x150
[   20.347382]  [<c044df83>] ? sys_init_module+0x83/0x1b0
[   20.347382]  [<c04878fd>] ? sys_read+0x3d/0x70
[   20.347382]  [<c04032ed>] ? sysenter_do_call+0x12/0x21
[   20.347382] Code: e5 57 56 53 89 c3 8d 73 04 83 ec 10 8d 7b 08 64 a1 00 a0 75 c0 89 45 e4 89 f0 e8 1f 10 00 00 8b 57 04 8d 45 e8 89 47 04 89 7d e8 <89> 02 8b 45 e4 89 55 ec ba ff ff ff ff 89 45 f0 89 d0 87 03 83 
[   20.347382] EIP: [<c061d77d>] __mutex_lock_slowpath+0x2d/0xa0 SS:ESP 0068:f5dc3e44
[   20.352096] ---[ end trace 4eaa2a86a8e2da24 ]---
[   20.352149] note: modprobe[1797] exited with preempt_count 1
[   20.471504] firewire_core: created device fw0: GUID 001e8c00012f990c, S400
[   20.926787] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 20
[   20.926854] forcedeth 0000:00:09.0: PCI INT A -> Link[AMC1] -> GSI 20 (level, low) -> IRQ 20
[   20.926941] forcedeth 0000:00:09.0: setting latency timer to 64
[   20.927070] nv_probe: set workaround bit for reversed mac addr
[   20.927249] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   20.927325] HDA Intel 0000:03:00.1: PCI INT B -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
[   20.927461] HDA Intel 0000:03:00.1: setting latency timer to 64
[   21.439857] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:1f:c6:63:07:97
[   21.439960] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   23.557884] EXT3 FS on sdb3, internal journal
[   23.841251] kjournald starting.  Commit interval 5 seconds
[   23.841606] EXT3 FS on sdb1, internal journal
[   23.841691] EXT3-fs: mounted filesystem with ordered data mode.
[   23.849577] SELinux: initialized (dev sdb1, type ext3), uses xattr
[   23.859120] kjournald starting.  Commit interval 5 seconds
[   23.859389] EXT3 FS on sdc1, internal journal
[   23.859471] EXT3-fs: mounted filesystem with ordered data mode.
[   23.866039] SELinux: initialized (dev sdc1, type ext3), uses xattr
[   23.866308] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   24.790477] Adding 4192956k swap on /dev/sdb2.  Priority:-1 extents:1 across:4192956k 
[   24.793212] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--Boundary-00=_DycgJipHTfWbegW--
