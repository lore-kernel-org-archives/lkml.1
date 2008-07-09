Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYGINIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYGINIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYGINIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:08:39 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1189 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYGINIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:08:37 -0400
Date: Wed, 9 Jul 2008 16:08:23 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Message-ID: <20080709130823.GA21320@deprecation.cyrius.com>
References: <1214584985.22228.15.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1214584985.22228.15.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Soeren Sonnenburg <kernel@nn7.de> [2008-06-27 18:43]:
> Anyone else seeing this? Happened after resuming from s2both (from
> disk)...

FWIW, I got something similar a few days ago with s2disk and 2.6.25.
I had never seen this before but then I got the same bug two or three
times within a day.  It happens when resuming the laptop from disk.
The kernel continues to start fine but doesn't restore the previous
state.

[   10.024084] ------------[ cut here ]------------
[   10.025255] kernel BUG at kernel/power/snapshot.c:493!
[   10.025255] invalid opcode: 0000 [1] SMP 
[   10.025255] CPU 0 
[   10.025255] Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt crypto_blkcipher dm_mirror dm_snapshot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata scsi_mod dock piix ide_pci_generic ide_core ehci_hcd uhci_hcd thermal processor fan
[   10.025255] Pid: 1520, comm: resume Not tainted 2.6.25-2-amd64 #1
[   10.025255] RIP: 0010:[<ffffffff80257d19>]  [<ffffffff80257d19>] memory_bm_set_bit+0x15/0x28
[   10.025255] RSP: 0018:ffff81007c9fbe90  EFLAGS: 00010282
[   10.025255] RAX: 00000000fffffff2 RBX: 0000000000000001 RCX: ffff81007c9fbe9c
[   10.025255] RDX: ffff81007c9fbe90 RSI: 0100000000000000 RDI: ffffffff80618ac0
[   10.025255] RBP: ffff81007c016000 R08: ffff81007c9fbe90 R09: 0000000000000002
[   10.025255] R10: 0000000000000002 R11: ffffffff802efae3 R12: 00007f853856a010
[   10.025255] R13: ffffffff80618b20 R14: 0000000000000004 R15: 0000000000001000
[   10.025255] FS:  0000000002090850(0063) GS:ffffffff80520000(0000) knlGS:0000000000000000
[   10.025255] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   10.025255] CR2: 0000000000445230 CR3: 000000007c914000 CR4: 00000000000006e0
[   10.025255] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   10.025255] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   10.025255] Process resume (pid: 1520, threadinfo ffff81007c9fa000, task ffff81007cd4a400)
[   10.025255] Stack:  ffff81007e877180 0000000000000092 ffffffff80258e7a 0000000000000000
[   10.025255]  ffff81007d8d4380 ffffffff80618b20 00007f853856a010 ffff81007c9fbf50
[   10.025255]  0000000000000004 00007f8538568010 ffffffff80259fd8 000000000001d688
[   10.025255] Call Trace:
[   10.025255]  [<ffffffff80258e7a>] ? snapshot_write_next+0xec/0x646
[   10.025255]  [<ffffffff80259fd8>] ? snapshot_write+0x22/0x5c
[   10.025255]  [<ffffffff8029ab65>] ? vfs_write+0xad/0x156
[   10.025255]  [<ffffffff8029b107>] ? sys_write+0x45/0x6e
[   10.025255]  [<ffffffff8020bd9a>] ? system_call_after_swapgs+0x8a/0x8f
[   10.025255] 
[   10.025255] 
[   10.025255] Code: 6d 48 8d 34 37 48 89 d7 48 c1 fe 03 48 0f af f0 e9 72 ff ff ff c3 48 83 ec 10 48 8d 4c 24 0c 48 89 e2 e8 e4 fe ff ff 85 c0 74 04 <0f> 0b eb fe 8b 54 24 0c 48 8b 04 24 f0 0f ab 10 59 5e c3 48 8b 
[   10.025255] RIP  [<ffffffff80257d19>] memory_bm_set_bit+0x15/0x28
[   10.025255]  RSP <ffff81007c9fbe90>
[   10.025266] ---[ end trace a54fd545107adef9 ]---

Full dmesg is attached.
-- 
Martin Michlmayr
http://www.cyrius.com/

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-snapshot-bug

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.25-2-amd64 (Debian 2.6.25-5) (waldi@debian.org) (gcc version 4.1.3 20080420 (prerelease) (Debian 4.1.2-22)) #1 SMP Thu Jun 12 15:38:32 UTC 2008
[    0.000000] Command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F77A0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7F7C81C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP 7F7C8084, 00F4 (r4 HP     30C9            3 HP          1)
[    0.000000] ACPI: DSDT 7F7C84C0, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
[    0.000000] ACPI: FACS 7F7E7D80, 0040
[    0.000000] ACPI: SLIC 7F7C8238, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET 7F7C83B0, 0038 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: APIC 7F7C83E8, 0068 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: MCFG 7F7C8450, 003C (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: TCPA 7F7C848C, 0032 (r2 HP     30C9            1 HP          1)
[    0.000000] ACPI: SSDT 7F7DB944, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT 7F7DC586, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC7E5, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC88B, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f7b0000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007f7b0000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000022ef7] pages 10
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-63d2f7] TEXT DATA BSS
[    0.000000] early res: 3 [37923000-37fef85b] RAMDISK
[    0.000000] early res: 4 [9fc00-a0bff] EBDA
[    0.000000] early res: 5 [8000-bfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   522160
[    0.000000] On node 0 totalpages: 522063
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1093 pages reserved
[    0.000000]   DMA zone: 2850 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7082 pages used for memmap
[    0.000000]   DMA32 zone: 510982 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35096 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513832
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000003] time.c: Detected 1196.997 MHz processor.
[    0.000034] Console: colour dummy device 80x25
[    0.000038] console [tty0] enabled
[    0.000314] Checking aperture...
[    0.000333] Calgary: detecting Calgary via BIOS EBDA area
[    0.000336] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2047968k/2088640k available (2184k kernel code, 40284k reserved, 1013k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080009] Calibrating delay using timer specific routine.. 2397.32 BogoMIPS (lpj=4794657)
[    0.080085] Security Framework initialized
[    0.080095] SELinux:  Disabled at boot.
[    0.080103] Capability LSM initialized
[    0.080475] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.082292] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.083212] Mount-cache hash table entries: 256
[    0.083443] Initializing cgroup subsys ns
[    0.083453] Initializing cgroup subsys cpuacct
[    0.083487] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083493] CPU: L2 cache: 2048K
[    0.083500] CPU 0/0 -> Node 0
[    0.083504] CPU: Physical Processor ID: 0
[    0.083509] CPU: Processor Core ID: 0
[    0.083522] CPU0: Thermal monitoring handled by SMI
[    0.083525] using mwait in idle threads.
[    0.084015] ACPI: Core revision 20070126
[    0.160148] Using local APIC timer interrupts.
[    0.164012] APIC timer calibration result 8312471
[    0.164015] Detected 8.312 MHz APIC timer.
[    0.164254] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 2394.00 BogoMIPS (lpj=4788008)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
[    0.252603] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.256053] Brought up 2 CPUs
[    0.256180] CPU0 attaching sched-domain:
[    0.256184]  domain 0: span 00000003
[    0.256187]   groups: 00000001 00000002
[    0.256192]   domain 1: span 00000003
[    0.256195]    groups: 00000003
[    0.256199] CPU1 attaching sched-domain:
[    0.256202]  domain 0: span 00000003
[    0.256204]   groups: 00000002 00000001
[    0.256208]   domain 1: span 00000003
[    0.256211]    groups: 00000003
[    0.256614] net_namespace: 1016 bytes
[    0.256624] Booting paravirtualized kernel on bare hardware
[    0.256941] NET: Registered protocol family 16
[    0.257244] ACPI: bus type pci registered
[    0.257380] PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
[    0.257387] PCI: Not using MMCONFIG.
[    0.257391] PCI: Using configuration type 1
[    0.260953] ACPI: EC: Look up EC in DSDT
[    0.007139] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.100807] ACPI: Interpreter enabled
[    0.100814] ACPI: (supports S0 S3 S4 S5)
[    0.100840] ACPI: Using IOAPIC for interrupt routing
[    0.120709] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.120719] ACPI: EC: driver started in interrupt mode
[    0.120818] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.122140] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.122152] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.123039] PCI: Transparent bridge - 0000:00:1e.0
[    0.123119] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.124100] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
[    0.124431] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
[    0.124724] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
[    0.202781] ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
[    0.203212] ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
[    0.203637] ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
[    0.204068] ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
[    0.204495] ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
[    0.204904] ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
[    0.205331] ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
[    0.205530] ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
[    0.205882] ACPI: Power Resource [C29F] (on)
[    0.205987] ACPI: Power Resource [C1C7] (off)
[    0.206201] ACPI: Power Resource [C3AD] (off)
[    0.206402] ACPI: Power Resource [C3B0] (off)
[    0.206603] ACPI: Power Resource [C3C3] (off)
[    0.206804] ACPI: Power Resource [C3C4] (off)
[    0.207002] ACPI: Power Resource [C3C5] (off)
[    0.207200] ACPI: Power Resource [C3C6] (off)
[    0.207398] ACPI: Power Resource [C3C7] (off)
[    0.207665] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.207715] pnp: PnP ACPI init
[    0.207729] ACPI: bus type pnp registered
[    0.208036]  00:00: calling quirk 0xffffffff8035b9a2: quirk_system_pci_resources+0x0/0x173()
[    0.208118] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.215457] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.216749] pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.216839] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.216920] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.216999] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.217080] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.217461] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.217554] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.217642] pnp 00:09: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
[    0.218543]  00:0a: calling quirk 0xffffffff8035b9a2: quirk_system_pci_resources+0x0/0x173()
[    0.218628] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.222825] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.222948]  00:0c: calling quirk 0xffffffff8035b9a2: quirk_system_pci_resources+0x0/0x173()
[    0.223045] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.225682]  00:0d: calling quirk 0xffffffff8035b9a2: quirk_system_pci_resources+0x0/0x173()
[    0.225790] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.225821] pnp: PnP ACPI: found 14 devices
[    0.225827] ACPI: ACPI bus type pnp unregistered
[    0.226108] usbcore: registered new interface driver usbfs
[    0.226198] usbcore: registered new interface driver hub
[    0.226262] usbcore: registered new device driver usb
[    0.226467] PCI: Using ACPI for IRQ routing
[    0.226474] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.244040] PCI-GART: No AMD northbridge found.
[    0.244052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.244062] hpet0: 3 64-bit timers, 14318180 Hz
[    0.245133] ACPI: RTC can wake from S4
[    0.504046] Switched to high resolution mode on CPU 0
[    0.248027] Switched to high resolution mode on CPU 1
[    0.260032] pnp: the driver 'system' has been registered
[    0.260045] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.260054] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.260062] system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
[    0.260070] system 00:00: driver attached
[    0.260084] system 00:0a: ioport range 0x500-0x55f has been reserved
[    0.260092] system 00:0a: ioport range 0x800-0x80f has been reserved
[    0.260101] system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.260110] system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.260118] system 00:0a: driver attached
[    0.260126] system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
[    0.260133] system 00:0c: ioport range 0x2f8-0x2ff has been reserved
[    0.260140] system 00:0c: ioport range 0x3f8-0x3ff has been reserved
[    0.260148] system 00:0c: ioport range 0x1000-0x107f has been reserved
[    0.260155] system 00:0c: ioport range 0x1100-0x113f has been reserved
[    0.260162] system 00:0c: ioport range 0x1200-0x121f has been reserved
[    0.260170] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.260178] system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
[    0.260187] system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
[    0.260196] system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
[    0.260205] system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
[    0.260213] system 00:0c: driver attached
[    0.260220] system 00:0d: iomem range 0xcee00-0xcffff has been reserved
[    0.260228] system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
[    0.260236] system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
[    0.260245] system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.260252] system 00:0d: driver attached
[    0.260885] PCI: Bridge: 0000:00:1c.0
[    0.260890]   IO window: disabled.
[    0.260900]   MEM window: disabled.
[    0.260908]   PREFETCH window: disabled.
[    0.260920] PCI: Bridge: 0000:00:1c.1
[    0.260924]   IO window: disabled.
[    0.260934]   MEM window: 0xe0000000-0xe00fffff
[    0.260943]   PREFETCH window: disabled.
[    0.260959] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.260964]   IO window: 0x00003000-0x000030ff
[    0.260973]   IO window: 0x00003400-0x000034ff
[    0.260983]   PREFETCH window: 0x88000000-0x8bffffff
[    0.260993]   MEM window: 0x8c000000-0x8fffffff
[    0.261002] PCI: Bridge: 0000:00:1e.0
[    0.261009]   IO window: 3000-3fff
[    0.261019]   MEM window: 0xe0100000-0xe03fffff
[    0.261028]   PREFETCH window: 0x0000000088000000-0x000000008bffffff
[    0.261073] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.261087] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.261119] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.261131] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.261150] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.261173] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
[    0.261228] NET: Registered protocol family 2
[    0.304191] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.305400] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.308713] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.309621] TCP: Hash tables configured (established 262144 bind 65536)
[    0.309629] TCP reno registered
[    0.320316] checking if image is initramfs... it is
[    1.276137] Freeing initrd memory: 6962k freed
[    1.283377] audit: initializing netlink socket (disabled)
[    1.283407] type=2000 audit(1214985973.536:1): initialized
[    1.283707] Total HugeTLB memory allocated, 0
[    1.283859] VFS: Disk quotas dquot_6.5.1
[    1.283904] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.284047] io scheduler noop registered
[    1.284053] io scheduler anticipatory registered
[    1.284058] io scheduler deadline registered
[    1.284097] io scheduler cfq registered (default)
[    1.284116] pci 0000:00:02.0: Boot video device
[    1.284413] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.284467] assign_interrupt_mode Found MSI capability
[    1.284534] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.284686] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.284741] assign_interrupt_mode Found MSI capability
[    1.284803] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.285483] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000900000, using 3072k, total 7616k
[    1.285494] vesafb: mode is 1024x768x16, linelength=2048, pages=3
[    1.285500] vesafb: scrolling: redraw
[    1.285506] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.305221] Console: switching to colour frame buffer device 128x48
[    1.324381] fb0: VESA VGA frame buffer device
[    1.328032] Real Time Clock Driver v1.12ac
[    1.328468] hpet_resources: 0xfed00000 is busy
[    1.328586] Linux agpgart interface v0.103
[    1.328737] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.329416] pnp: the driver 'serial' has been registered
[    1.330741] brd: module loaded
[    1.330955] input: Macintosh mouse button emulation as /class/input/input0
[    1.331356] pnp: the driver 'i8042 kbd' has been registered
[    1.331376] i8042 kbd 00:08: driver attached
[    1.331426] pnp: the driver 'i8042 aux' has been registered
[    1.331454] i8042 aux 00:09: driver attached
[    1.331498] PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
[    1.586807] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.587925] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.588112] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.588301] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.588488] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.588675] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.612221] mice: PS/2 mouse device common for all mice
[    1.612474] cpuidle: using governor ladder
[    1.612626] cpuidle: using governor menu
[    1.613336] TCP cubic registered
[    1.613469] NET: Registered protocol family 1
[    1.613642] NET: Registered protocol family 17
[    1.613971] registered taskstats version 1
[    1.614271] Freeing unused kernel memory: 372k freed
[    1.636130] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.892325] ACPI: Transitioning device [C3B1] to D3
[    1.896190] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.900135] ACPI: Fan [C3B1] (off)
[    1.904523] ACPI: Transitioning device [C3B2] to D3
[    1.908180] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.912133] ACPI: Fan [C3B2] (off)
[    1.916506] ACPI: Transitioning device [C3C8] to D3
[    1.920178] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.924133] ACPI: Fan [C3C8] (off)
[    1.932388] ACPI: Transitioning device [C3C9] to D3
[    1.936180] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.940134] ACPI: Fan [C3C9] (off)
[    1.944502] ACPI: Transitioning device [C3CA] to D3
[    1.948179] ACPI: PNP0C0B:04 is registered as cooling_device4
[    1.952137] ACPI: Fan [C3CA] (off)
[    1.956503] ACPI: Transitioning device [C3CB] to D3
[    1.960180] ACPI: PNP0C0B:05 is registered as cooling_device5
[    1.964138] ACPI: Fan [C3CB] (off)
[    1.968504] ACPI: Transitioning device [C3CC] to D3
[    1.972180] ACPI: PNP0C0B:06 is registered as cooling_device6
[    1.976139] ACPI: Fan [C3CC] (off)
[    1.766389] ACPI: SSDT 7F7DBCCA, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    1.768766] ACPI: SSDT 7F7DBF8C, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    2.017649] Monitor-Mwait will be used to enter C-1 state
[    2.017655] Monitor-Mwait will be used to enter C-2 state
[    2.017658] Monitor-Mwait will be used to enter C-3 state
[    2.017894] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.020193] ACPI: ACPI0007:00 is registered as cooling_device7
[    2.024138] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.028640] ACPI: SSDT 7F7DBC02, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    2.032593] ACPI: SSDT 7F7DBF07, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    1.821548] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.040133] Marking TSC unstable due to TSC halts in idle
[    1.824183] ACPI: ACPI0007:01 is registered as cooling_device8
[    1.824189] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.850833] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.852460] ACPI: Thermal Zone [TZ6] (25 C)
[    1.873784] ACPI: LNXTHERM:02 is registered as thermal_zone1
[    1.876518] ACPI: Thermal Zone [TZ0] (35 C)
[    1.888322] ACPI: LNXTHERM:03 is registered as thermal_zone2
[    1.896344] ACPI: Thermal Zone [TZ1] (39 C)
[    1.907897] ACPI: LNXTHERM:04 is registered as thermal_zone3
[    1.912219] ACPI: Thermal Zone [TZ3] (28 C)
[    2.166604] ACPI: LNXTHERM:05 is registered as thermal_zone4
[    2.177795] ACPI: Thermal Zone [TZ4] (28 C)
[    1.958647] ACPI: LNXTHERM:06 is registered as thermal_zone5
[    1.964762] ACPI: Thermal Zone [TZ5] (67 C)
[    2.674531] USB Universal Host Controller Interface driver v3.0
[    2.678558] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    2.682522] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    2.682529] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.686741] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.690558] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
[    2.694718] usb usb1: configuration #1 chosen from 1 choice
[    2.698565] hub 1-0:1.0: USB hub found
[    2.702521] hub 1-0:1.0: 2 ports detected
[    2.754949] atkbd.c: Unknown key pressed (translated set 2, code 0xd9 on isa0060/serio0).
[    2.758510] atkbd.c: Use 'setkeycodes e059 <keycode>' to make it known.
[    2.580310] Uniform Multi-Platform E-IDE driver
[    2.582812] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.802656] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.806536] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.810521] usb usb1: Product: UHCI Host Controller
[    2.814518] usb usb1: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.818518] usb usb1: SerialNumber: 0000:00:1a.0
[    2.822563] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[    2.826528] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    2.826533] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.830593] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    2.834560] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
[    2.838671] usb usb2: configuration #1 chosen from 1 choice
[    2.842555] hub 2-0:1.0: USB hub found
[    2.846527] hub 2-0:1.0: 2 ports detected
[    2.954735] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.958622] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.962591] usb usb2: Product: UHCI Host Controller
[    2.966586] usb usb2: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    2.970586] usb usb2: SerialNumber: 0000:00:1a.1
[    2.974643] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.978599] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.978605] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.982702] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    2.986641] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
[    2.990746] usb usb3: configuration #1 chosen from 1 choice
[    2.994624] hub 3-0:1.0: USB hub found
[    2.998595] hub 3-0:1.0: 2 ports detected
[    3.106549] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.110440] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.114438] usb usb3: Product: UHCI Host Controller
[    3.118438] usb usb3: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    3.122438] usb usb3: SerialNumber: 0000:00:1d.0
[    3.126479] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
[    3.130445] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.130452] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.134501] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    3.138483] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
[    3.142589] usb usb4: configuration #1 chosen from 1 choice
[    3.146472] hub 4-0:1.0: USB hub found
[    3.150446] hub 4-0:1.0: 2 ports detected
[    3.258291] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.262180] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.266179] usb usb4: Product: UHCI Host Controller
[    3.270179] usb usb4: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    3.274180] Clocksource tsc unstable (delta = -204575520 ns)
[    3.278180] usb usb4: SerialNumber: 0000:00:1d.1
[    3.282218] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.286186] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.286194] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.290247] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    3.294232] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
[    3.298333] usb usb5: configuration #1 chosen from 1 choice
[    3.302216] hub 5-0:1.0: USB hub found
[    3.306189] hub 5-0:1.0: 2 ports detected
[    3.413859] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.417750] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.421748] usb usb5: Product: UHCI Host Controller
[    3.425748] usb usb5: Manufacturer: Linux 2.6.25-2-amd64 uhci_hcd
[    3.429749] usb usb5: SerialNumber: 0000:00:1d.2
[    3.529060] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    3.531820] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    3.531826] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.535893] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    3.545741] ehci_hcd 0000:00:1a.7: debug port 1
[    3.547799] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    3.547808] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
[    3.567811] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.571953] usb usb6: configuration #1 chosen from 1 choice
[    3.575854] hub 6-0:1.0: USB hub found
[    3.579804] hub 6-0:1.0: 4 ports detected
[    3.691948] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    3.695806] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.699803] usb usb6: Product: EHCI Host Controller
[    3.703803] usb usb6: Manufacturer: Linux 2.6.25-2-amd64 ehci_hcd
[    3.707800] usb usb6: SerialNumber: 0000:00:1a.7
[    3.711858] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    3.715825] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.715831] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.719888] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    3.729193] ehci_hcd 0000:00:1d.7: debug port 1
[    3.731811] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    3.731820] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
[    3.750795] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.754915] usb usb7: configuration #1 chosen from 1 choice
[    3.758814] hub 7-0:1.0: USB hub found
[    3.762786] hub 7-0:1.0: 6 ports detected
[    3.867917] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    3.871811] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.875813] usb usb7: Product: EHCI Host Controller
[    3.879817] usb usb7: Manufacturer: Linux 2.6.25-2-amd64 ehci_hcd
[    3.883814] usb usb7: SerialNumber: 0000:00:1d.7
[    3.947391] ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
[    3.947401] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    3.947412] ICH8M: not 100% native mode: will probe irqs later
[    3.947424] ICH8M: IDE port disabled
[    3.947432]     ide0: BM-DMA at 0x20e0-0x20e7, BIOS settings: hda:DMA, hdb:DMA
[    3.947445] Probing IDE interface ide0...
[    4.235229] hda: TOSHIBA MK8009GAH, ATA DISK drive
[    4.685698] hdb: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
[    4.745114] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.745181] hda: UDMA/100 mode selected
[    4.749158] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.749447] hdb: MWDMA2 mode selected
[    4.753397] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.786751] No dock devices found.
[    4.799450] SCSI subsystem initialized
[    4.760409] libata version 3.00 loaded.
[    4.779474] hda: max request size: 128KiB
[    4.780745] hda: 156301488 sectors (80026 MB), CHS=65535/16/63
[    4.788799] hda: cache flushes supported
[    4.792809]  hda: hda1 hda2 hda3
[    4.873936] hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    4.881678] Uniform CD-ROM driver Revision: 3.20
[    5.527324] device-mapper: uevent: version 1.0.3
[    5.528547] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    9.890983] PM: Starting manual resume from disk
[   10.024084] ------------[ cut here ]------------
[   10.025255] kernel BUG at kernel/power/snapshot.c:493!
[   10.025255] invalid opcode: 0000 [1] SMP 
[   10.025255] CPU 0 
[   10.025255] Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt crypto_blkcipher dm_mirror dm_snapshot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata scsi_mod dock piix ide_pci_generic ide_core ehci_hcd uhci_hcd thermal processor fan
[   10.025255] Pid: 1520, comm: resume Not tainted 2.6.25-2-amd64 #1
[   10.025255] RIP: 0010:[<ffffffff80257d19>]  [<ffffffff80257d19>] memory_bm_set_bit+0x15/0x28
[   10.025255] RSP: 0018:ffff81007c9fbe90  EFLAGS: 00010282
[   10.025255] RAX: 00000000fffffff2 RBX: 0000000000000001 RCX: ffff81007c9fbe9c
[   10.025255] RDX: ffff81007c9fbe90 RSI: 0100000000000000 RDI: ffffffff80618ac0
[   10.025255] RBP: ffff81007c016000 R08: ffff81007c9fbe90 R09: 0000000000000002
[   10.025255] R10: 0000000000000002 R11: ffffffff802efae3 R12: 00007f853856a010
[   10.025255] R13: ffffffff80618b20 R14: 0000000000000004 R15: 0000000000001000
[   10.025255] FS:  0000000002090850(0063) GS:ffffffff80520000(0000) knlGS:0000000000000000
[   10.025255] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   10.025255] CR2: 0000000000445230 CR3: 000000007c914000 CR4: 00000000000006e0
[   10.025255] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   10.025255] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   10.025255] Process resume (pid: 1520, threadinfo ffff81007c9fa000, task ffff81007cd4a400)
[   10.025255] Stack:  ffff81007e877180 0000000000000092 ffffffff80258e7a 0000000000000000
[   10.025255]  ffff81007d8d4380 ffffffff80618b20 00007f853856a010 ffff81007c9fbf50
[   10.025255]  0000000000000004 00007f8538568010 ffffffff80259fd8 000000000001d688
[   10.025255] Call Trace:
[   10.025255]  [<ffffffff80258e7a>] ? snapshot_write_next+0xec/0x646
[   10.025255]  [<ffffffff80259fd8>] ? snapshot_write+0x22/0x5c
[   10.025255]  [<ffffffff8029ab65>] ? vfs_write+0xad/0x156
[   10.025255]  [<ffffffff8029b107>] ? sys_write+0x45/0x6e
[   10.025255]  [<ffffffff8020bd9a>] ? system_call_after_swapgs+0x8a/0x8f
[   10.025255] 
[   10.025255] 
[   10.025255] Code: 6d 48 8d 34 37 48 89 d7 48 c1 fe 03 48 0f af f0 e9 72 ff ff ff c3 48 83 ec 10 48 8d 4c 24 0c 48 89 e2 e8 e4 fe ff ff 85 c0 74 04 <0f> 0b eb fe 8b 54 24 0c 48 8b 04 24 f0 0f ab 10 59 5e c3 48 8b 
[   10.025255] RIP  [<ffffffff80257d19>] memory_bm_set_bit+0x15/0x28
[   10.025255]  RSP <ffff81007c9fbe90>
[   10.025266] ---[ end trace a54fd545107adef9 ]---
[   10.330075] EXT3-fs: INFO: recovery required on readonly filesystem.
[   10.331216] EXT3-fs: write access will be enabled during recovery.
[   16.322882] kjournald starting.  Commit interval 5 seconds
[   16.322902] EXT3-fs: recovery complete.
[   16.335398] EXT3-fs: mounted filesystem with ordered data mode.
[   21.129246] agpgart: Detected an Intel 965GM Chipset.
[   21.133392] agpgart: Detected 7676K stolen memory.
[   21.153707] agpgart: AGP aperture is 256M @ 0xd0000000
[   21.186597] input: Power Button (FF) as /class/input/input2
[   21.244233] ACPI: Power Button (FF) [PWRF]
[   21.248356] input: Sleep Button (CM) as /class/input/input3
[   21.292291] ACPI: Sleep Button (CM) [C2BF]
[   21.296388] input: Lid Switch as /class/input/input4
[   21.324401] ACPI: Lid Switch [C155]
[   21.380463] ACPI: AC Adapter [C23B] (off-line)
[   21.380786] ACPI: WMI: Mapper loaded
[   21.446487] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   21.448564] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   21.452638] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
[   21.456575] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   21.445706] ACPI: Battery Slot [C23D] (battery present)
[   21.587085] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:06:12:ee
[   21.588574] eth0: Intel(R) PRO/1000 Network Connection
[   21.592695] eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[   21.608376] ACPI: device:02 is registered as cooling_device9
[   21.612988] input: Video Bus as /class/input/input5
[   21.680663] ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[   22.022701] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   22.024706] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   22.028643] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.175736] Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
[   22.229319] ricoh-mmc: Ricoh MMC Controller disabling driver
[   22.232611] ricoh-mmc: Copyright(c) Philip Langdale
[   22.301688] Yenta: ISA IRQ mask 0x0cb8, PCI irq 18
[   22.304618] Socket status: 30000006
[   22.308617] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   22.312715] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
[   22.316619] pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
[   22.320621] pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
[   22.365777] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
[   22.368343] ricoh-mmc: Controller is now disabled.
[   22.517322] input: PC Speaker as /class/input/input6
[   22.715917] sdhci: Secure Digital Host Controller Interface driver
[   22.718751] sdhci: Copyright(c) Pierre Ossman
[   22.722794] sdhci: SDHCI controller found at 0000:02:06.2 [1180:0822] (rev 21)
[   22.726784] ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 20 (level, low) -> IRQ 20
[   22.730833] sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
[   22.734811] mmc0: SDHCI at 0xe0102000 irq 20 DMA
[   22.888586] pnp: the driver 'tpm_inf_pnp' has been registered
[   22.888939] tpm_inf_pnp 00:02: Found C284 with ID IFX0102
[   22.892994] tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   22.897242] tpm_inf_pnp 00:02: driver attached
[   22.937703] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[   22.940928] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   22.945017] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   22.948936] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   22.952963] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   23.007011] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   23.020044] phy0: Selected rate control algorithm 'iwl-4965-rs'
[   23.489298] input: PS/2 Generic Mouse as /class/input/input7
[   23.600266] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
[   23.602970] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   23.611445] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   24.200125] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
[   24.241138] input: SynPS/2 Synaptics TouchPad as /class/input/input8
[   26.238162] EXT3 FS on dm-1, internal journal
[   27.072616] loop: module loaded
[   27.198072] tun: Universal TUN/TAP device driver, 1.6
[   27.200738] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   35.135903] kjournald starting.  Commit interval 5 seconds
[   35.260022] EXT3 FS on hda1, internal journal
[   35.263705] EXT3-fs: mounted filesystem with ordered data mode.
[   35.295065] kjournald starting.  Commit interval 5 seconds
[   35.296200] EXT3 FS on dm-3, internal journal
[   35.299709] EXT3-fs: mounted filesystem with ordered data mode.
[   35.226733] Adding 1048568k swap on /dev/mapper/lucky-swap.  Priority:-1 extents:1 across:1048568k
[   37.542660] Bridge firewalling registered
[   37.679252] br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   37.690468] device eth0 entered promiscuous mode
[   57.708960] NET: Registered protocol family 10
[   57.712806] lo: Disabled Privacy Extensions
[   57.716806] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   59.609346] pnp: the driver 'parport_pc' has been registered
[   59.419967] lp: driver loaded but no devices found
[   59.506393] ppdev: user-space parallel port driver
[   68.101735] br0: no IPv6 routers present
[   74.040690] Bluetooth: Core ver 2.11
[   74.048398] NET: Registered protocol family 31
[   74.051802] Bluetooth: HCI device and connection manager initialized
[   74.055801] Bluetooth: HCI socket layer initialized
[   74.112056] Bluetooth: L2CAP ver 2.9
[   74.115802] Bluetooth: L2CAP socket layer initialized
[   74.296352] Bluetooth: RFCOMM socket layer initialized
[   74.298818] Bluetooth: RFCOMM TTY layer initialized
[   74.302801] Bluetooth: RFCOMM ver 1.8
[   77.947619] vmmon: module license 'unspecified' taints kernel.
[   77.948824] [3825]: VMCI: Driver initialized.
[   77.948880] [3825]: Module vmmon: registered with major=10 minor=165
[   77.948908] [3825]: Module vmmon: initialized
[   79.290520] /dev/vmnet: open called by PID 3856 (vmnet-bridge)
[   79.290537] /dev/vmnet: hub 0 does not exist, allocating memory.
[   79.290551] /dev/vmnet: port on hub 0 successfully opened
[   79.290569] bridge-eth0: enabling the bridge
[   79.290575] bridge-eth0: up
[   79.290579] bridge-eth0: already up
[   79.290582] bridge-eth0: attached
[   79.652193] hdb: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
[   79.652193] hdb: task_no_data_intr: error=0x04 { AbortedCommand }
[   79.652193] ide: failed opcode was: 0xef
[   81.671571] [drm] Initialized drm 1.1.0 20060810
[   81.738575] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   81.738594] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   81.738865] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  103.494888] warning: `zsh' uses 32-bit capabilities (legacy support in use)

--lrZ03NoBR/3+SXJZ--
