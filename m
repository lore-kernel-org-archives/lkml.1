Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbYD1Oyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbYD1Oyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934538AbYD1OyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:54:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:30542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934102AbYD1OyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=abwJUR7RIX/kayJaS4LhXjT+7TVOyGmP1Yl95Tjhm3pysGT4tssg1JBmYSV3eYigdccIbTHOC+ldzvnZ+rHVwzqBNcSeKSo8MEsXg1qtZp0bvZVhMyT9tHWrF+iq05FlH0MjyDh9DFy91a65hcYArJMSUNtvH4yag9CTkWzvDEg=
Message-ID: <6101e8c40804280754r68e84ee1r8ba4984007fdcfeb@mail.gmail.com>
Date: Mon, 28 Apr 2008 16:54:14 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Gabor Gombas" <gombasg@sztaki.hu>
Subject: Re: Solid freezes with 2.6.25
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add CC]

On 4/28/08, Gabor Gombas <gombasg@sztaki.hu> wrote:
> Hi,
>
> I'm seeing solid freezes with 2.6.25. 2.6.24.x works fine, 2.6.25 never
> had an uptime longer than 4-6 hours so far. netconsole captured the
> following:
>
> NMI Watchdog detected LOCKUP on CPU 1
> CPU 1
> Modules linked in: edd netconsole configfs i915 radeon drm rfcomm l2cap
> bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 aead ah4 nfsd lockd
> nfs_acl auth_rpcgss sunrpc exportfs ipt_ULOG microcode ipt_REJECT
> nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit
> iptable_filter ip_tables x_tables deflate zlib_deflate zlib_inflate ctr
> twofish twofish_common camellia serpent blowfish des_generic cbc aes_x86_64
> aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse
> dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_mod coretemp w83627ehf
> hwmon_vid snd_hda_intel snd_pcm 8250_pnp snd_timer 8250 sg snd 8139too
> serial_core video r8169 snd_page_alloc usbhid i2c_i801 sr_mod iTCO_wdt
> floppy cdrom [last unloaded: netconsole]
> Pid: 2535, comm: postgres Not tainted 2.6.25 #11
> RIP: 0010:[<ffffffff8021aa54>]  [<ffffffff8021aa54>]
> hpet_rtc_interrupt+0x11a/0x2fd
> RSP: 0000:ffff81012fc77ec8  EFLAGS: 00200097
> RAX: 0000000000000000 RBX: 0000000000200002 RCX: 0000000000000000
> RDX: 000000000000c6c6 RSI: 0000000000200002 RDI: ffffffff80655ef8
> RBP: 000000010011144c R08: ffffffffff5fc128 R09: 0000000000000000
> R10: 0000000000200046 R11: 0000000000000000 R12: 00000000000000a6
> R13: ffff81012fcf8800 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff81012fc0f480(0063) knlGS:00000000f7f228e0
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000f1559000 CR3: 0000000128cd8000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process postgres (pid: 2535, threadinfo ffff810128d18000, task
> ffff81012cbb6930)
> Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  ffffffff00000000 0000000000000001 ffffffff806432c0 ffff81012fe25bc0
>  0000000000000000 0000000000000000 0000000000000008 ffffffff8025d6d0
> Call Trace:
>  <IRQ>  [<ffffffff8025d6d0>] ? handle_IRQ_event+0x25/0x53
>  [<ffffffff8025ec3a>] ? handle_edge_irq+0xdd/0x11c
>  [<ffffffff8020c0cc>] ? call_softirq+0x1c/0x28
>  [<ffffffff8020e26a>] ? do_IRQ+0xf1/0x15f
>  [<ffffffff8020b451>] ? ret_from_intr+0x0/0xa
>  <EOI>
>
> Code: a0 28 00 bf 0a 00 00 00 48 89 c3 e8 73 6b ff ff 48 89 de 41 88 c4 48
> c7 c7 f8 5e 65 80 e8 14 a1 28 00 45 84 e4 78 04 eb 12 f3 90 <48> 8b 05 25 1e
> 3e 00 48 29 e8 48 83 f8 04 76 ee 48 c7 c7 f8 5e
> ---[ end trace 8625c90c6582673f ]---
> Kernel panic - not syncing: Aiee, killing interrupt handler!
>
> Also, I have these messages in syslog:
>
> Apr 28 13:13:31 boogie kernel: rtc: lost 157 interrupts
> Apr 28 13:13:32 boogie kernel: rtc: lost 37 interrupts
> Apr 28 13:25:37 boogie kernel: rtc: lost 60 interrupts
>
> More info about the machine is attached. I've also seen similar hangs with
> 2.6.25-rc6 on an nforce4/Athlon64 box but I'm reluctant to re-test there
> because RAID rebuild takes too long.
>
> Gabor
>
> dmesg:
> ======
>
> Initializing cgroup subsys cpuset
> Linux version 2.6.25 (gombasg@boogie) (gcc version 4.2.3 (Debian 4.2.3-3))
> #11 SMP Mon Apr 28 10:41:10 CEST 2008
> Command line: BOOT_IMAGE=l2625 ro root=900 video=intelfb:1280x1024-16@60
> resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2 single
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cf2ac000 (usable)
>  BIOS-e820: 00000000cf2ac000 - 00000000cf2ef000 (ACPI NVS)
>  BIOS-e820: 00000000cf2ef000 - 00000000cf3c7000 (reserved)
>  BIOS-e820: 00000000cf3c7000 - 00000000cf3d7000 (ACPI NVS)
>  BIOS-e820: 00000000cf3d7000 - 00000000cf453000 (reserved)
>  BIOS-e820: 00000000cf453000 - 00000000cf459000 (ACPI data)
>  BIOS-e820: 00000000cf459000 - 00000000cf45a000 (ACPI NVS)
>  BIOS-e820: 00000000cf45a000 - 00000000cf45c000 (ACPI data)
>  BIOS-e820: 00000000cf45c000 - 00000000cf45d000 (ACPI NVS)
>  BIOS-e820: 00000000cf45d000 - 00000000cf45e000 (reserved)
>  BIOS-e820: 00000000cf45e000 - 00000000cf463000 (ACPI NVS)
>  BIOS-e820: 00000000cf463000 - 00000000cf472000 (reserved)
>  BIOS-e820: 00000000cf472000 - 00000000cf600000 (usable)
>  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
>  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
> Entering add_active_range(0, 0, 159) 0 entries of 256 used
> Entering add_active_range(0, 256, 848556) 1 entries of 256 used
> Entering add_active_range(0, 849010, 849408) 2 entries of 256 used
> Entering add_active_range(0, 1048576, 1245184) 3 entries of 256 used
> end_pfn_map = 1245184
> DMI 2.4 present.
> ACPI: RSDP 000F03C0, 0024 (r2  INTEL)
> ACPI: XSDT CF45AF10, 0044 (r1  INTEL   DG31PR  6222004 MSFT    10013)
> ACPI: FACP CF458D90, 00F4 (r4  INTEL   DG31PR  6222004 MSFT    10013)
> ACPI: DSDT CF453010, 4D33 (r1  INTEL   DG31PR        0 INTL 20051117)
> ACPI: FACS CF459F40, 0040
> ACPI: APIC CF458F10, 006C (r2  INTEL   DG31PR  6222004 MSFT    10013)
> ACPI: HPET CF461D10, 0038 (r1  INTEL ICH7HPET  6222004 AMI.        1)
> ACPI: MCFG CF461C10, 003C (r1 INTEL  DG31PR    6222004 MSFT       97)
> Entering add_active_range(0, 0, 159) 0 entries of 256 used
> Entering add_active_range(0, 256, 848556) 1 entries of 256 used
> Entering add_active_range(0, 849010, 849408) 2 entries of 256 used
> Entering add_active_range(0, 1048576, 1245184) 3 entries of 256 used
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-6bc61b] TEXT DATA BSS
> early res: 3 [9fc00-a0bff] EBDA
> early res: 4 [8000-dfff] PGTABLE
>  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
>  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
>  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
>  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
>  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
>  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
>  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
>  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
>  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
>  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
>  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
>  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
>  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
>  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
>  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
>  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
>  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
>  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
>  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
>  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
>  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
>  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
>  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
>  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
>  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
>  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
>  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
>  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
>  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
>  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
>  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
>  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
>  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
>  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
>  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009a00000 on node 0
>  [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009e00000 on node 0
>  [ffffe20004800000-ffffe200049fffff] PMD ->ffff81000a200000 on node 0
>  [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff81000a600000 on node 0
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1245184
> Movable zone start PFN for each node
> early_node_map[4] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->   848556
>     0:   849010 ->   849408
>     0:  1048576 ->  1245184
> On node 0 totalpages: 1045465
>   DMA zone: 64 pages used for memmap
>   DMA zone: 1224 pages reserved
>   DMA zone: 2711 pages, LIFO batch:0
>   DMA32 zone: 16320 pages used for memmap
>   DMA32 zone: 828538 pages, LIFO batch:31
>   Normal zone: 3072 pages used for memmap
>   Normal zone: 193536 pages, LIFO batch:31
>   Movable zone: 0 pages used for memmap
> ACPI: PM-Timer IO Port: 0x408
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
> ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 0, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Setting APIC routing to flat
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at d0000000 (gap: cf600000:2f71c000)
> SMP: Allowing 4 CPUs, 2 hotplug CPUs
> PERCPU: Allocating 34112 bytes of per cpu data
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1024785
> Kernel command line: BOOT_IMAGE=l2625 ro root=900
> video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1
> nmi_watchdog=2 single
> audit: enabled (after initialization)
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Extended CMOS year: 2000
> TSC calibrated against PM_TIMER
> time.c: Detected 2199.955 MHz processor.
> Console: colour VGA+ 80x50
> console [tty0] enabled
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> Placing software IO TLB between 0xae21000 - 0xee21000
> Memory: 4025872k/4980736k available (2717k kernel code, 155356k reserved,
> 1280k data, 248k init)
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
> hpet clockevent registered
> Calibrating delay using timer specific routine.. 4403.20 BogoMIPS
> (lpj=8806400)
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> selinux_register_security:  Registering secondary module capability
> Capability LSM initialized as secondary
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys memory
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 1024K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> CPU0: Thermal monitoring enabled (TM2)
> using mwait in idle threads.
> ACPI: Core revision 20070126
> Using local APIC timer interrupts.
> APIC timer calibration result 12499744
> Detected 12.499 MHz APIC timer.
> Booting processor 1/2 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4399.88 BogoMIPS
> (lpj=8799778)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 1024K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU1: Thermal monitoring enabled (TM2)
> Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> Testing NMI watchdog ... OK.
> CPU0 attaching sched-domain:
>  domain 0: span 3
>   groups: 1 2
> CPU1 attaching sched-domain:
>  domain 0: span 3
>   groups: 2 1
> net_namespace: 1016 bytes
> xor: automatically using best checksumming function: generic_sse
>    generic_sse:  8072.000 MB/sec
> xor: using function: generic_sse (8072.000 MB/sec)
> NET: Registered protocol family 16
> No dock devices found.
> ACPI: bus type pci registered
> PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> PCI: Not using MMCONFIG.
> PCI: Using configuration type 1
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: BIOS _OSI(Linux) query ignored
> ACPI: DMI System Vendor:
> ACPI: DMI Product Name:
> ACPI: DMI Product Version:
> ACPI: DMI Board Name: DG31PR
> ACPI: DMI BIOS Vendor: Intel Corp.
> ACPI: DMI BIOS Date: 02/27/2008
> ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
> ACPI: If "acpi_osi=Linux" works better, please notify
> linux-acpi@vger.kernel.org
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> PCI: Transparent bridge - 0000:00:1e.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
> report
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4
> NetLabel:  unlabeled traffic allowed by default
> PCI-GART: No AMD northbridge found.
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 64-bit timers, 14318180 Hz
> ACPI: RTC can wake from S4
> system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> system 00:01: iomem range 0xe0000000-0xe3ffffff has been reserved
> system 00:02: ioport range 0x400-0x47f has been reserved
> system 00:02: ioport range 0x1180-0x119f has been reserved
> system 00:02: ioport range 0x500-0x53f has been reserved
> system 00:02: iomem range 0xfec00000-0xfecfffff has been reserved
> system 00:02: iomem range 0xfee00000-0xfee0ffff could not be reserved
> system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
> system 00:02: iomem range 0xffb00000-0xffcfffff could not be reserved
> system 00:02: iomem range 0xfc800000-0xfc800fff has been reserved
> system 00:02: iomem range 0xfed20000-0xfed7ffff has been reserved
> system 00:02: iomem range 0xffe00000-0xffffffff could not be reserved
> system 00:03: ioport range 0x290-0x29f has been reserved
> system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
> PCI: Bridge: 0000:00:01.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.1
>   IO window: e000-efff
>   MEM window: 0xff800000-0xff8fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1e.0
>   IO window: d000-dfff
>   MEM window: 0xff700000-0xff7fffff
>   PREFETCH window: disabled.
> ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:00:1c.1 to 64
> PCI: Setting latency timer of device 0000:00:1e.0 to 64
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> audit: initializing netlink socket (enabled)
> type=2000 audit(1209386619.444:1): initialized
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> async_tx: api initialized (sync-only)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci 0000:00:02.0: Boot video device
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:01.0:pcie00]
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.0:pcie00]
> Allocate Port Service[0000:00:1c.0:pcie02]
> PCI: Setting latency timer of device 0000:00:1c.1 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.1:pcie00]
> Allocate Port Service[0000:00:1c.1:pcie02]
> input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button (FF) [PWRF]
> input: Sleep Button (CM) as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
> ACPI: Sleep Button (CM) [SLPB]
> input: Power Button (CM) as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> ACPI: Power Button (CM) [PWRB]
> ACPI: SSDT CF45EC10, 02CC (r1    AMI      IST        1 MSFT  3000001)
> ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> ACPI: ACPI0007:00 is registered as cooling_device0
> ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> ACPI: ACPI0007:01 is registered as cooling_device1
> hpet_resources: 0xfed00000 is busy
> Linux agpgart interface v0.103
> agpgart: Detected an Intel G33 Chipset.
> agpgart: Detected 7164K stolen memory.
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> agpgart: AGP aperture is 256M @ 0xd0000000
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60
> seconds).
> Hangcheck: Using get_cycles().
> intelfb: Framebuffer driver for Intel(R)
> 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
> intelfb: Version 0.9.4
> Driver 'sd' needs updating - please use bus_type methods
> ata_piix 0000:00:1f.1: version 2.12
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1f.1 to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14
> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15
> ata1.00: ATAPI: ASUS    DRW-1814BL, 1.13, max UDMA/66
> ata1.00: configured for UDMA/66
> ata2: port disabled. ignoring.
> scsi 0:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.13 PQ: 0 ANSI: 5
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
> ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi2 : ata_piix
> scsi3 : ata_piix
> ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 17
> ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 17
> ata3.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
> ata3.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.00: configured for UDMA/133
> ata4.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
> ata4.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata4.00: configured for UDMA/133
> scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
> sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
>  sda: sda1 sda2 sda3 < sda5 >
> sd 2:0:0:0: [sda] Attached SCSI disk
> scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
> sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
> sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
>  sdb: sdb1 sdb2 sdb3 < sdb5 >
> sd 3:0:0:0: [sdb] Attached SCSI disk
> ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:1d.7: debug port 1
> PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff984000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1d.3 to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
> boot with i8042.nopnp
> serio: i8042 KBD port at 0x60,0x64 irq 1
> mice: PS/2 mouse device common for all mice
> usb 1-2: new high speed USB device using ehci_hcd and address 3
> rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one year, y3k
> i2c /dev entries driver
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input3
> raid6: int64x1   2069 MB/s
> usb 1-2: configuration #1 chosen from 1 choice
> hub 1-2:1.0: USB hub found
> hub 1-2:1.0: 4 ports detected
> raid6: int64x2   2606 MB/s
> raid6: int64x4   2493 MB/s
> raid6: int64x8   2015 MB/s
> raid6: sse2x1    3509 MB/s
> raid6: sse2x2    3917 MB/s
> usb 2-1: new low speed USB device using uhci_hcd and address 2
> raid6: sse2x4    6646 MB/s
> raid6: using algorithm sse2x4 (6646 MB/s)
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> EDAC MC: Ver: 2.1.0 Apr 25 2008
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP cubic registered
> NET: Registered protocol family 1
> Marking TSC unstable due to TSC halts in idle
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> NET: Registered protocol family 17
> registered taskstats version 1
> rtc_cmos 00:08: setting system clock to 2008-04-28 12:43:41 UTC (1209386621)
> md: Autodetecting RAID arrays.
> md: invalid raid superblock magic on sda5
> md: sda5 does not have a valid v0.90 superblock, not importing!
> usb 2-1: configuration #1 chosen from 1 choice
> md: invalid raid superblock magic on sdb5
> md: sdb5 does not have a valid v0.90 superblock, not importing!
> md: Scanned 4 and added 2 devices.
> md: autorun ...
> md: considering sdb1 ...
> md:  adding sdb1 ...
> md:  adding sda1 ...
> md: created md0
> md: bind<sda1>
> md: bind<sdb1>
> md: running: <sdb1><sda1>
> raid1: raid set md0 active with 2 out of 2 mirrors
> md: ... autorun DONE.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 248k freed
> SELinux:8192 avtab hash slots allocated. Num of rules:71699
> SELinux:8192 avtab hash slots allocated. Num of rules:71699
> security:  7 users, 7 roles, 1457 types, 61 bools
> security:  69 classes, 71699 rules
> SELinux:  Completing initialization.
> SELinux:  Setting up existing superblocks.
> SELinux: initialized (dev md0, type ext3), uses xattr
> SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
> SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
> SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses
> genfs_contexts
> SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> SELinux: initialized (dev proc, type proc), uses genfs_contexts
> SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> SELinux: policy loaded with handle_unknown=deny
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
> r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> eth0: RTL8168b/8111b at 0xffffc20000020000, 00:1c:c0:34:06:c9, XID 38500000
> IRQ 380
> udev: renamed network interface eth0 to mobo
> ACPI Exception (video-1613): AE_NOT_FOUND, Evaluating _DOD [20070126]
> input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/input/input4
> FDC 0 is a post-1991 82077
> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
> iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> Driver 'sr' needs updating - please use bus_type methods
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 0:0:0:0: Attached scsi CD-ROM sr0
> 8139too Fast Ethernet driver 0.9.28
> ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21
> eth0: RealTek RTL8139 at 0xffffc20000022000, 00:c1:28:01:d5:f6, IRQ 21
> eth0:  Identified 8139 chip type 'RTL-8139C'
> sr 0:0:0:0: Attached scsi generic sg0 type 5
> sd 2:0:0:0: Attached scsi generic sg1 type 0
> sd 3:0:0:0: Attached scsi generic sg2 type 0
> ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
> udev: renamed network interface eth0 to rtl
> input: Logitech USB RECEIVER as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input5
> input: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-1
> usbcore: registered new interface driver usbhid
> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> printk: 21 messages suppressed.
> Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
> Adding 2008116k swap on /dev/sdb2.  Priority:-2 extents:1 across:2008116k
> EXT3 FS on md0, internal journal
> w83627ehf: Found W83627DHG chip at 0x290
> coretemp coretemp.0: Using relative temperature scale!
> coretemp coretemp.1: Using relative temperature scale!
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
> dm-devel@redhat.com
> md: md3 stopped.
> md: bind<sda5>
> md: bind<sdb5>
> md: md3: raid array is not clean -- starting background reconstruction
> raid1: raid set md3 active with 2 out of 2 mirrors
> md: resync of RAID array md3
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for resync.
> md: using 128k window, over a total of 240235840 blocks.
> md: resuming resync of md3 from checkpoint.
> fuse init (API version 7.9)
> SELinux: initialized (dev fusectl, type fusectl), not configured for
> labeling
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-0, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux: initialized (dev dm-0, type ext3), uses xattr
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux: initialized (dev dm-1, type ext3), uses xattr
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux: initialized (dev dm-2, type ext3), uses xattr
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-3, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux: initialized (dev dm-3, type ext3), uses xattr
> printk: 129 messages suppressed.
> NET: Registered protocol family 15
> printk: 15 messages suppressed.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> r8169: mobo: link up
> r8169: mobo: link up
> rtl: link down
> ADDRCONF(NETDEV_UP): rtl: link is not ready
> printk: 111 messages suppressed.
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
>
> lspci -vvvnn:
> =============
>
> 00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31 Express DRAM
> Controller [8086:29c0] (rev 02)
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: [e0] Vendor Specific Information <?>
> 	Kernel driver in use: agpgart-intel
>
> 00:01.0 PCI bridge [0604]: Intel Corporation 82G33/G31/P35/P31 Express PCI
> Express Root Port [8086:29c1] (rev 02)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: fff00000-000fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [88] Subsystem: Intel Corporation Device [8086:0000]
> 	Capabilities: [80] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable+
> 		Address: fee0300c  Data: 4159
> 	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> 			ExtTag- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us,
> L1 <8us
> 			ClockPM- Suprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
> 			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Off, PwrInd On, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
> 			Changed: MRL- PresDet- LinkState-
> 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> 		RootCap: CRSVisible-
> 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> 	Kernel driver in use: pcieport-driver
>
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
> Express Integrated Graphics Controller [8086:29c2] (rev 02)
> 	Subsystem: Intel Corporation 82G33/G31 Express Integrated Graphics
> Controller [8086:29c2]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at ff900000 (32-bit, non-prefetchable) [size=512K]
> 	Region 1: I/O ports at f140 [size=8]
> 	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
> 	Region 3: Memory at ff600000 (32-bit, non-prefetchable) [size=1M]
> 	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable-
> 		Address: 00000000  Data: 0000
> 	Capabilities: [d0] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller [8086:27d8] (rev 01)
> 	Subsystem: Intel Corporation Device [8086:d608]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at ff980000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable-
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> 			ExtTag- RBE- FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns,
> L1 <1us
> 			ClockPM- Suprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt-
> ABWMgmt-
> 	Kernel driver in use: HDA Intel
> 	Kernel modules: snd-hda-intel
>
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 1 [8086:27d0] (rev 01)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: fff00000-000fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1
> unlimited
> 			ExtTag- RBE- FLReset-
> 		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1
> <4us
> 			ClockPM- Suprise- LLActRep+ BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
> 			Slot #  1, PowerLimit 10.000000; Interlock- NoCompl-
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
> 			Changed: MRL- PresDet- LinkState-
> 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> 		RootCap: CRSVisible-
> 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> 	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable+
> 		Address: fee0300c  Data: 4161
> 	Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 1 [8086:27d0]
> 	Capabilities: [a0] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: pcieport-driver
>
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 2 [8086:27d2] (rev 01)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> 	I/O behind bridge: 0000e000-0000efff
> 	Memory behind bridge: ff800000-ff8fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1
> unlimited
> 			ExtTag- RBE- FLReset-
> 		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns,
> L1 <4us
> 			ClockPM- Suprise- LLActRep+ BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-
> ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
> 			Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet+ LinkState+
> 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> 		RootCap: CRSVisible-
> 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> 	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable+
> 		Address: fee0300c  Data: 4169
> 	Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 2 [8086:27d2]
> 	Capabilities: [a0] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: pcieport-driver
>
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #1 [8086:27c8] (rev 01)
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
> [8086:27c8]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 4: I/O ports at f080 [size=32]
> 	Kernel driver in use: uhci_hcd
>
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #2 [8086:27c9] (rev 01)
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
> [8086:27c9]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 19
> 	Region 4: I/O ports at f060 [size=32]
> 	Kernel driver in use: uhci_hcd
>
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #3 [8086:27ca] (rev 01)
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
> [8086:27ca]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at f040 [size=32]
> 	Kernel driver in use: uhci_hcd
>
> 00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #4 [8086:27cb] (rev 01)
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
> [8086:27cb]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 16
> 	Region 4: I/O ports at f020 [size=32]
> 	Kernel driver in use: uhci_hcd
>
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2
> EHCI Controller [8086:27cc] (rev 01) (prog-if 20)
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
> [8086:27cc]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: Memory at ff984000 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [58] Debug port: BAR=1 offset=00a0
> 	Kernel driver in use: ehci_hcd
>
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e]
> (rev e1) (prog-if 01)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: ff700000-ff7fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [50] Subsystem: Gammagraphx, Inc. Device [0000:0000]
>
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC
> Interface Bridge [8086:27b8] (rev 01)
> 	Subsystem: Intel Corporation Device [8086:544e]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: [e0] Vendor Specific Information <?>
> 	Kernel modules: iTCO_wdt
>
> 00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE
> Controller [8086:27df] (rev 01) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
> [8086:27df]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: I/O ports at 01f0 [size=8]
> 	Region 1: I/O ports at 03f4 [size=1]
> 	Region 2: I/O ports at 0170 [size=8]
> 	Region 3: I/O ports at 0374 [size=1]
> 	Region 4: I/O ports at f0f0 [size=16]
> 	Kernel driver in use: ata_piix
>
> 00:1f.2 IDE interface [0101]: Intel Corporation 82801GB/GR/GH (ICH7 Family)
> SATA IDE Controller [8086:27c0] (rev 01) (prog-if 8f [Master SecP SecO PriP
> PriO])
> 	Subsystem: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE
> Controller [8086:27c0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 17
> 	Region 0: I/O ports at f0e0 [size=8]
> 	Region 1: I/O ports at f0d0 [size=4]
> 	Region 2: I/O ports at f0c0 [size=8]
> 	Region 3: I/O ports at f0b0 [size=4]
> 	Region 4: I/O ports at f0a0 [size=16]
> 	Capabilities: [70] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: ata_piix
>
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus
> Controller [8086:27da] (rev 01)
> 	Subsystem: Intel Corporation Device [8086:d608]
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin B routed to IRQ 17
> 	Region 4: I/O ports at f000 [size=32]
> 	Kernel driver in use: i801_smbus
> 	Kernel modules: i2c-i801
>
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 01)
> 	Subsystem: Intel Corporation Device [8086:d608]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 380
> 	Region 0: I/O ports at e000 [size=256]
> 	Region 2: Memory at ff820000 (64-bit, non-prefetchable) [size=4K]
> 	Expansion ROM at ff800000 [disabled] [size=128K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0-,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [48] Vital Product Data <?>
> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
> Enable+
> 		Address: 00000000fee0300c  Data: 4189
> 	Capabilities: [60] Express (v1) Endpoint, MSI 00
> 		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <128ns, L1
> unlimited
> 			ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
> 		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited,
> L1 unlimited
> 			ClockPM- Suprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> 	Capabilities: [84] Vendor Specific Information <?>
> 	Kernel driver in use: r8169
> 	Kernel modules: r8169
>
> 04:06.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
> 	Subsystem: Compex Device [11f6:8139]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 32 (8000ns min, 16000ns max)
> 	Interrupt: pin A routed to IRQ 21
> 	Region 0: I/O ports at d000 [size=256]
> 	Region 1: Memory at ff700000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0-,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: 8139too
> 	Kernel modules: 8139too
>
>
> --
>      ---------------------------------------------------------
>      MTA SZTAKI Computer and Automation Research Institute
>                 Hungarian Academy of Sciences
>      ---------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
