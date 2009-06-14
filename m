Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZFNG1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZFNG1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZFNG1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:27:23 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34709 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFNG1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Cw3MuMiy68rpbonS9OX4jnPnik58B8S3ct+pGkV9lMu2jIxaHeQltkpi+fsMycN56f
         gpAsbGZmqDcCa4vP+sfS5Mn2IhZBq7Lo6wv6m5i0sm1/Xmj9bxyFD5nH3XnPabUgZAIs
         u7bGXAguhDPBfYI20U4+DGyVwmVkU36RwO7IA=
MIME-Version: 1.0
In-Reply-To: <20090613230842.GA18347@gallifrey>
References: <20090613230842.GA18347@gallifrey>
Date: Sun, 14 Jun 2009 09:27:18 +0300
X-Google-Sender-Auth: c790c7daa792467f
Message-ID: <84144f020906132327n51db29dfgc05dad98587d9f41@mail.gmail.com>
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding some cc's.)

On Sun, Jun 14, 2009 at 2:08 AM, Dr. David Alan
Gilbert<linux@treblig.org> wrote:
> Hi,
>  I've got an old Pentium 90 machine that's been running a 2.4.x
> kernel for a long time, seems to work OK on a 2.6.18 kernel
> but doesn't seem to like anything newer.
>
> 2.6.30 no keyboard - but otherwise OK
> 2.6.28 no keyboard - but otherwise OK
> 2.6.26 reboots just after parsing ELF (maybe one more line)
> 2.6.25 reboots almost immediately
> 2.6.18 works OK
>
> The 2.6.18 and 26 are Debian kernels (etch and lenny), the
> rest are vanilla from git.
>
> So it looks like something got fixed between 26 and 28 that
> stops the early reboot.
>
> Attached is the .config from the 2.6.30 and a dmesg from that boot.
> /proc/interrupts shows 8 interrupts on interrupt 1 from the i8042
> but it doesn't go up if I type.  I've tried a couple of different
> keyboards, so I don't think it's just a dislike for the keyboard.
>
> I can see a /sys entry for the i8042 - I just don't get any input.
>
> It has an ISA VGA card (Trident 1M) (I needed the PCI slots
> for another net card!).
>
> I compiled it on a 64bit Ubuntu machine.
>
> Suggestions welcome,
>
> Dave
>
> lspci
> -----
> 00:00.0 Host bridge: Intel Corporation 82434LX/NX [Mercury/Neptune] Processor to PCI bridge (rev 11)
> 00:01.0 IDE interface: Micron PC Tech RZ1000 (rev 01)
> 00:02.0 Non-VGA unclassified device: Intel Corporation 82378ZB/IB, 82379AB (SIO, SIO.A) PCI to ISA Bridge (rev 03)
> 00:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
> 00:0c.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
> 00:0e.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
>
> interrupts
> ----------
>           CPU0
>  0:     279289    XT-PIC-XT        timer
>  1:          8    XT-PIC-XT        i8042
>  2:          0    XT-PIC-XT        cascade
>  6:          3    XT-PIC-XT        floppy
>  7:          2    XT-PIC-XT
>  8:          2    XT-PIC-XT        rtc0
>  11:       1385    XT-PIC-XT        eth1, eth0, eth2
>  12:          0    XT-PIC-XT        i8042
>  14:       4256    XT-PIC-XT        ide0
>  15:          0    XT-PIC-XT        ide1
> NMI:          0   Non-maskable interrupts
> ERR:          0
>
> dmesg
> -----
> [    0.000000] Linux version 2.6.302.6.30gort1 (dg@davros) (gcc version 4.4.0 (Ubuntu 4.4.0-5ubuntu1) ) #2 Sat Jun 13 18:18:17 BST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-88: 0000000000100000 - 0000000004000000 (usable)
> [    0.000000] DMI not present or invalid.
> [    0.000000] last_pfn = 0x4000 max_arch_pfn = 0x100000
> [    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
> [    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
> [    0.000000]  modified: 0000000000100000 - 0000000004000000 (usable)
> [    0.000000] init_memory_mapping: 0000000000000000-0000000004000000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0004000000 page 2M
> [    0.000000] kernel direct mapping tables up to 4000000 @ 10000-14000
> [    0.000000] 64MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 04000000
> [    0.000000]   low ram: 0 - 04000000
> [    0.000000]   node 0 low ram: 00000000 - 04000000
> [    0.000000]   node 0 bootmap 00010000 - 00010800
> [    0.000000] (5 early reservations) ==> bootmem [0000000000 - 0004000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000200000 - 0000659c1c]    TEXT DATA BSS ==> [0000200000 - 0000659c1c]
> [    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #3 [000065a000 - 000065c000]              BRK ==> [000065a000 - 000065c000]
> [    0.000000]   #4 [0000010000 - 0000011000]          BOOTMAP ==> [0000010000 - 0000011000]
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x00004000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00000001
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x00004000
> [    0.000000] On node 0 totalpages: 16272
> [    0.000000] free_area_init_node: node 0, pgdat c059a814, node_mem_map c1000000
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3952 pages, LIFO batch:0
> [    0.000000]   Normal zone: 96 pages used for memmap
> [    0.000000]   Normal zone: 12192 pages, LIFO batch:1
> [    0.000000] Allocating PCI resources starting at 10000000 (gap: 4000000:fc000000)
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16144
> [    0.000000] Kernel command line: root=/dev/hda3 ro
> [    0.000000] Initializing CPU#0
> [    0.000000] NR_IRQS:16
> [    0.000000] PID hash table entries: 256 (order: 8, 1024 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 90.194 MHz processor.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.004000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.004000] Memory: 60032k/65536k available (2565k kernel code, 5032k reserved, 1185k data, 220k init, 0k highmem)
> [    0.004000] virtual kernel memory layout:
> [    0.004000]     fixmap  : 0xfffeb000 - 0xfffff000   (  80 kB)
> [    0.004000]     vmalloc : 0xc4800000 - 0xfffe9000   ( 951 MB)
> [    0.004000]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
> [    0.004000]       .init : 0xc05ac000 - 0xc05e3000   ( 220 kB)
> [    0.004000]       .data : 0xc0481560 - 0xc05a9ad4   (1185 kB)
> [    0.004000]       .text : 0xc0200000 - 0xc0481560   (2565 kB)
> [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.004000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.004105] Calibrating delay loop (skipped), value calculated using timer frequency.. 180.38 BogoMIPS (lpj=360776)
> [    0.005249] Security Framework initialized
> [    0.005658] SELinux:  Disabled at boot.
> [    0.006136] Mount-cache hash table entries: 512
> [    0.009959] Intel Pentium with F0 0F bug - workaround enabled.
> [    0.010356]
> [    0.010925] CPU: Intel Pentium 75 - 200 stepping 04
> [    0.011597] Checking 'hlt' instruction... OK.
> [    0.037920] net_namespace: 560 bytes
> [    0.045603] NET: Registered protocol family 16
> [    0.063141] PCI: PCI BIOS revision 2.00 entry at 0xf3940, last bus=0
> [    0.063555] PCI: Using configuration type 1 for base access
> [    0.203103] bio: create slab <bio-0> at 0
> [    0.224508] PCI: Probing PCI hardware
> [    0.224894] PCI: Probing PCI hardware (bus 00)
> [    0.227218] pci 0000:00:01.0: reg 10 io port: [0x1f0-0x1f7]
> [    0.227350] pci 0000:00:01.0: reg 14 io port: [0x3f4-0x3f7]
> [    0.227954] pci 0000:00:06.0: reg 10 io port: [0xfc80-0xfcff]
> [    0.228392] pci 0000:00:06.0: reg 14 32bit mmio: [0xffbfff80-0xffbfffff]
> [    0.228825] pci 0000:00:0c.0: reg 10 32bit mmio: [0xffbef000-0xffbeffff]
> [    0.228960] pci 0000:00:0c.0: reg 14 io port: [0xfc40-0xfc7f]
> [    0.229088] pci 0000:00:0c.0: reg 18 32bit mmio: [0xffa00000-0xffafffff]
> [    0.229251] pci 0000:00:0c.0: reg 30 32bit mmio: [0xfe000000-0xfe0fffff]
> [    0.229425] pci 0000:00:0c.0: supports D1 D2
> [    0.229514] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot
> [    0.229926] pci 0000:00:0c.0: PME# disabled
> [    0.230498] pci 0000:00:0e.0: reg 10 io port: [0xf880-0xf8ff]
> [    0.230634] pci 0000:00:0e.0: reg 14 32bit mmio: [0xffbdff80-0xffbdffff]
> [    0.230811] pci 0000:00:0e.0: reg 30 32bit mmio: [0xfe000000-0xfe01ffff]
> [    0.230976] pci 0000:00:0e.0: supports D1 D2
> [    0.231064] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot
> [    0.231462] pci 0000:00:0e.0: PME# disabled
> [    0.250198] NetLabel: Initializing
> [    0.250567] NetLabel:  domain hash size = 128
> [    0.250904] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.251685] NetLabel:  unlabeled traffic allowed by default
> [    0.254639] Slow work thread pool: Starting up
> [    0.256856] Slow work thread pool: Ready
> [    0.257403] FS-Cache: Loaded
> [    0.259569] CacheFiles: Loaded
> [    0.278072] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.278186] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> [    0.278982] NET: Registered protocol family 2
> [    0.282180] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.289678] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.290702] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.291383] TCP: Hash tables configured (established 2048 bind 2048)
> [    0.291775] TCP reno registered
> [    0.293865] NET: Registered protocol family 1
> [    0.302847] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.305094] Scanning for low memory corruption every 60 seconds
> [    0.314357] audit: initializing netlink socket (disabled)
> [    0.314956] type=2000 audit(1244914801.311:1): initialized
> [    0.453503] NTFS driver 2.1.29 [Flags: R/O].
> [    0.461983] msgmni has been set to 117
> [    0.468627] alg: No test for cipher_null (cipher_null-generic)
> [    0.469986] alg: No test for ecb(cipher_null) (ecb-cipher_null)
> [    0.471314] alg: No test for digest_null (digest_null-generic)
> [    0.472751] alg: No test for compress_null (compress_null-generic)
> [    0.545552] alg: No test for stdrng (krng)
> [    0.546900] alg: No test for stdrng (ansi_cprng)
> [    0.547678] io scheduler noop registered
> [    0.548283] io scheduler deadline registered (default)
> [    0.549881] isapnp: Scanning for PnP cards...
> [    0.906676] isapnp: No Plug & Play device found
> [    1.042776] lp: driver loaded but no devices found
> [    1.045360] Non-volatile memory driver v1.3
> [    1.047261] ppdev: user-space parallel port driver
> [    1.047673] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> [    1.048339] Hangcheck: Using get_cycles().
> [    1.048766] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.051655] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.054528] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.057112] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
> [    1.059625] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
> [    1.076882] parport0: PC-style at 0x378 [PCSPP,EPP]
> [    1.177517] lp0: using parport0 (polling).
> [    1.179798] parport1: PC-style at 0x278 (0x678) [PCSPP,TRISTATE]
> [    1.309938] parport1: irq 7 detected
> [    1.409631] lp1: using parport1 (polling).
> [    1.417488] Floppy drive(s): fd0 is 1.44M, fd1 is 1.2M
> [    1.436665] FDC 0 is a post-1991 82077
> [    1.481588] loop: module loaded
> [    1.481946] Uniform Multi-Platform E-IDE driver
> [    1.485696] 0000:00:01.0: disabled chipset read-ahead (buggy RZ1000/RZ1001)
> [    1.486169] rz1000 0000:00:01.0: IDE controller (0x1042:0x1000 rev 0x01)
> [    1.486991] rz1000 0000:00:01.0: not 100% native mode: will probe irqs later
> [    1.487458] Probing IDE interface ide0...
> [    1.776529] hda: IBM-DCAA-33610, ATA DISK drive
> [    2.280441] hdb: GCD-R542B, ATAPI CD/DVD-ROM drive
> [    2.282829] Probing IDE interface ide1...
> [    2.850533] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    2.851548] ide1 at 0x170-0x177,0x376 on irq 15
> [    2.858113] ide-gd driver 1.18
> [    2.859043] hda: max request size: 128KiB
> [    2.859427] hda: 7056000 sectors (3612 MB) w/96KiB Cache, CHS=7000/16/63
> [    2.860045] hda: cache flushes not supported
> [    2.861373]  hda: hda1 hda2 < hda5 > hda3
> [    2.919259] ide-cd driver 5.00
> [    2.924195] ide-cd: hdb: ATAPI 4X CD-ROM drive, 256kB Cache
> [    2.925339] Uniform CD-ROM driver Revision: 3.20
> [    2.944818] 3c59x: Donald Becker and others.
> [    2.945334] 0000:00:0e.0: 3Com PCI 3c905C Tornado at c48f0f80.
> [    2.979186] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    2.979598] e100: Copyright(c) 1999-2006 Intel Corporation
> [    3.008016] e100 0000:00:0c.0: PME# disabled
> [    3.017088] e100: eth1: e100_probe: addr 0xffbef000, irq 11, MAC addr 00:d0:b7:bf:81:57
> [    3.074566] Fixed MDIO Bus: probed
> [    3.110073] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> [    3.110542] 8139cp 0000:00:06.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
> [    3.113076] 8139too Fast Ethernet driver 0.9.28
> [    3.124933] eth2: RealTek RTL8139 at 0xfc80, 00:20:18:88:7a:c1, IRQ 11
> [    3.125361] eth2:  Identified 8139 chip type 'RTL-8139 rev K'
> [    3.127080] tun: Universal TUN/TAP device driver, 1.6
> [    3.127464] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    3.129775] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
> [    3.131792] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
> [    3.131866]   http://www.scyld.com/network/drivers.html
> [    3.139302] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.186312] mice: PS/2 mouse device common for all mice
> [    3.194043] input: PC Speaker as /devices/platform/pcspkr/input/input0
> [    3.196976] evbug.c: Connected device: input0 (PC Speaker at isa0061/input0)
> [    3.203133] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    3.203722] rtc0: alarms up to one day, 114 bytes nvram
> [    3.215553] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    3.219608] evbug.c: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [    3.249229] rtc-test rtc-test.0: rtc core: registered test as rtc1
> [    3.253953] rtc-test rtc-test.1: rtc core: registered test as rtc2
> [    3.257647] Driver for 1-wire Dallas network protocol.
> [    3.262943] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> [    3.263566] cpuidle: using governor ladder
> [    3.263920] cpuidle: using governor menu
> [    3.267648] NET: Registered protocol family 26
> [    3.272750] GACT probability on
> [    3.273085] Mirror/redirect action on
> [    3.273426] Simple TC action Loaded
> [    3.285515] netem: version 1.2
> [    3.285870] u32 classifier
> [    3.286174]     Actions configured
> [    3.286541] Netfilter messages via NETLINK v0.30.
> [    3.287376] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> [    3.294582] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [    3.295145] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
> [    3.295686] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [    3.303380] ctnetlink v0.93: registering with nfnetlink.
> [    3.304032] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
> [    3.304442] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
> [    3.305711] xt_time: kernel timezone is -0000
> [    3.309307] IPVS: Registered protocols (TCP, UDP, AH, ESP)
> [    3.310231] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
> [    3.312122] IPVS: ipvs loaded.
> [    3.312470] IPVS: [rr] scheduler registered.
> [    3.312936] IPVS: [wrr] scheduler registered.
> [    3.313300] IPVS: [lc] scheduler registered.
> [    3.313652] IPVS: [wlc] scheduler registered.
> [    3.314562] IPVS: [lblc] scheduler registered.
> [    3.315414] IPVS: [lblcr] scheduler registered.
> [    3.315784] IPVS: [dh] scheduler registered.
> [    3.316137] IPVS: [sh] scheduler registered.
> [    3.316491] IPVS: [sed] scheduler registered.
> [    3.316951] IPVS: [nq] scheduler registered.
> [    3.317365] IPVS: ftp: loaded support on port[0] = 21
> [    3.337415] IPv4 over IPv4 tunneling driver
> [    3.368805] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    3.369907] ClusterIP Version 0.8 loaded successfully
> [    3.370885] arp_tables: (C) 2002 David S. Miller
> [    3.372316] TCP bic registered
> [    3.372788] TCP cubic registered
> [    3.373130] TCP westwood registered
> [    3.373465] TCP highspeed registered
> [    3.373800] TCP hybla registered
> [    3.374127] TCP htcp registered
> [    3.374448] TCP vegas registered
> [    3.374768] TCP veno registered
> [    3.375091] TCP scalable registered
> [    3.375423] TCP lp registered
> [    3.375746] TCP yeah registered
> [    3.376071] TCP illinois registered
> [    3.376420] NET: Registered protocol family 17
> [    3.379007] Bridge firewalling registered
> [    3.379446] Ebtables v2.0 registered
> [    3.380415] ebt_ulog: out of memory trying to call netlink_kernel_create
> [    3.384957] NET: Registered protocol family 33
> [    3.387113] SCTP: Hash tables configured (established 2048 bind 4096)
> [    3.405089] rtc_cmos rtc_cmos: setting system clock to 2009-06-13 17:40:04 UTC (1244914804)
> [    3.672471] kjournald starting.  Commit interval 5 seconds
> [    3.673126] EXT3-fs: mounted filesystem with writeback data mode.
> [    3.673707] VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
> [    3.675074] Freeing unused kernel memory: 220k freed
> [    3.684853] Write protecting the kernel text: 2568k
> [    3.685603] Write protecting the kernel read-only data: 944k
> [   48.003003] Adding 176672k swap on /dev/hda5.  Priority:-1 extents:1 across:176672k
> [   49.531291] EXT3 FS on hda3, internal journal
> [   57.529885] kjournald starting.  Commit interval 5 seconds
> [   57.531941] EXT3 FS on hda1, internal journal
> [   57.532428] EXT3-fs: mounted filesystem with writeback data mode.
> [   66.173547] e100 0000:00:0c.0: firmware: using built-in firmware e100/d101m_ucode.bin
> [   66.579827] eth0: link down
> [   68.844244] e100: eth1 NIC Link is Up 100 Mbps Full Duplex
> [   75.741037] eth2:  setting full-duplex.
> [  130.761741] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
> [  650.173418] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
>
> config
> ------
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.30
> # Sat Jun 13 18:11:36 2009
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION="2.6.30gort1"
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_TREE=y
>
> #
> # RCU Subsystem
> #
> CONFIG_CLASSIC_RCU=y
> # CONFIG_TREE_RCU is not set
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_PREEMPT_RCU_TRACE is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_GROUP_SCHED is not set
> # CONFIG_CGROUPS is not set
> # CONFIG_SYSFS_DEPRECATED_V2 is not set
> CONFIG_RELAY=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_BLK_DEV_INITRD is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> CONFIG_MARKERS=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_SLOW_WORK=y
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> # CONFIG_LBD is not set
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_AS is not set
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> # CONFIG_DEFAULT_AS is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> # CONFIG_FREEZER is not set
>
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> # CONFIG_SMP is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> CONFIG_M586TSC=y
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_CPU=y
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_XADD=y
> # CONFIG_X86_PPRO_FENCE is not set
> CONFIG_X86_F00F_BUG=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_TSC=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_CPU_SUP_UMC_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> # CONFIG_IOMMU_API is not set
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> # CONFIG_X86_UP_APIC is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_X86_CPU_DEBUG is not set
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> # CONFIG_X86_PAE is not set
> # CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_UNEVICTABLE_LRU=y
> CONFIG_HAVE_MLOCK=y
> CONFIG_HAVE_MLOCKED_PAGE_BIT=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW_64K=y
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> # CONFIG_X86_PAT is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR_ALL=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x100000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
>
> #
> # Power management and ACPI options
> #
> # CONFIG_PM is not set
>
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> CONFIG_PCI_LEGACY=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
>
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=y
> # CONFIG_NET_IPGRE is not set
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=y
> CONFIG_TCP_CONG_HTCP=y
> CONFIG_TCP_CONG_HSTCP=y
> CONFIG_TCP_CONG_HYBLA=y
> CONFIG_TCP_CONG_VEGAS=y
> CONFIG_TCP_CONG_SCALABLE=y
> CONFIG_TCP_CONG_LP=y
> CONFIG_TCP_CONG_VENO=y
> CONFIG_TCP_CONG_YEAH=y
> CONFIG_TCP_CONG_ILLINOIS=y
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> # CONFIG_IPV6 is not set
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=y
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_QUEUE=y
> CONFIG_NETFILTER_NETLINK_LOG=y
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> # CONFIG_NF_CT_PROTO_DCCP is not set
> CONFIG_NF_CT_PROTO_GRE=y
> CONFIG_NF_CT_PROTO_SCTP=y
> CONFIG_NF_CT_PROTO_UDPLITE=y
> CONFIG_NF_CONNTRACK_AMANDA=y
> CONFIG_NF_CONNTRACK_FTP=y
> CONFIG_NF_CONNTRACK_H323=y
> CONFIG_NF_CONNTRACK_IRC=y
> CONFIG_NF_CONNTRACK_NETBIOS_NS=y
> CONFIG_NF_CONNTRACK_PPTP=y
> # CONFIG_NF_CONNTRACK_SANE is not set
> CONFIG_NF_CONNTRACK_SIP=y
> CONFIG_NF_CONNTRACK_TFTP=y
> CONFIG_NF_CT_NETLINK=y
> CONFIG_NETFILTER_TPROXY=y
> CONFIG_NETFILTER_XTABLES=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
> CONFIG_NETFILTER_XT_TARGET_DSCP=y
> CONFIG_NETFILTER_XT_TARGET_HL=y
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
> CONFIG_NETFILTER_XT_TARGET_RATEEST=y
> CONFIG_NETFILTER_XT_TARGET_TPROXY=y
> CONFIG_NETFILTER_XT_TARGET_TRACE=y
> CONFIG_NETFILTER_XT_TARGET_SECMARK=y
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> # CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
> CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
> CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> CONFIG_NETFILTER_XT_MATCH_DCCP=y
> CONFIG_NETFILTER_XT_MATCH_DSCP=y
> CONFIG_NETFILTER_XT_MATCH_ESP=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_HELPER=y
> CONFIG_NETFILTER_XT_MATCH_HL=y
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
> CONFIG_NETFILTER_XT_MATCH_LENGTH=y
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=y
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> CONFIG_NETFILTER_XT_MATCH_OWNER=y
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
> CONFIG_NETFILTER_XT_MATCH_QUOTA=y
> CONFIG_NETFILTER_XT_MATCH_RATEEST=y
> CONFIG_NETFILTER_XT_MATCH_REALM=y
> CONFIG_NETFILTER_XT_MATCH_RECENT=y
> # CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
> CONFIG_NETFILTER_XT_MATCH_SCTP=y
> CONFIG_NETFILTER_XT_MATCH_SOCKET=y
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> CONFIG_NETFILTER_XT_MATCH_STRING=y
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
> CONFIG_NETFILTER_XT_MATCH_TIME=y
> CONFIG_NETFILTER_XT_MATCH_U32=y
> CONFIG_IP_VS=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
>
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
>
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=y
> CONFIG_IP_VS_WRR=y
> CONFIG_IP_VS_LC=y
> CONFIG_IP_VS_WLC=y
> CONFIG_IP_VS_LBLC=y
> CONFIG_IP_VS_LBLCR=y
> CONFIG_IP_VS_DH=y
> CONFIG_IP_VS_SH=y
> CONFIG_IP_VS_SED=y
> CONFIG_IP_VS_NQ=y
>
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=y
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=y
> CONFIG_NF_CONNTRACK_IPV4=y
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> CONFIG_IP_NF_QUEUE=y
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_ADDRTYPE=y
> CONFIG_IP_NF_MATCH_AH=y
> CONFIG_IP_NF_MATCH_ECN=y
> CONFIG_IP_NF_MATCH_TTL=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> CONFIG_IP_NF_TARGET_LOG=y
> CONFIG_IP_NF_TARGET_ULOG=y
> CONFIG_NF_NAT=y
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=y
> CONFIG_IP_NF_TARGET_NETMAP=y
> CONFIG_IP_NF_TARGET_REDIRECT=y
> CONFIG_NF_NAT_SNMP_BASIC=y
> CONFIG_NF_NAT_PROTO_GRE=y
> CONFIG_NF_NAT_PROTO_UDPLITE=y
> CONFIG_NF_NAT_PROTO_SCTP=y
> CONFIG_NF_NAT_FTP=y
> CONFIG_NF_NAT_IRC=y
> CONFIG_NF_NAT_TFTP=y
> CONFIG_NF_NAT_AMANDA=y
> CONFIG_NF_NAT_PPTP=y
> CONFIG_NF_NAT_H323=y
> CONFIG_NF_NAT_SIP=y
> CONFIG_IP_NF_MANGLE=y
> CONFIG_IP_NF_TARGET_CLUSTERIP=y
> CONFIG_IP_NF_TARGET_ECN=y
> CONFIG_IP_NF_TARGET_TTL=y
> CONFIG_IP_NF_RAW=y
> CONFIG_IP_NF_SECURITY=y
> CONFIG_IP_NF_ARPTABLES=y
> CONFIG_IP_NF_ARPFILTER=y
> CONFIG_IP_NF_ARP_MANGLE=y
> CONFIG_BRIDGE_NF_EBTABLES=y
> CONFIG_BRIDGE_EBT_BROUTE=y
> CONFIG_BRIDGE_EBT_T_FILTER=y
> CONFIG_BRIDGE_EBT_T_NAT=y
> CONFIG_BRIDGE_EBT_802_3=y
> CONFIG_BRIDGE_EBT_AMONG=y
> CONFIG_BRIDGE_EBT_ARP=y
> CONFIG_BRIDGE_EBT_IP=y
> CONFIG_BRIDGE_EBT_LIMIT=y
> CONFIG_BRIDGE_EBT_MARK=y
> CONFIG_BRIDGE_EBT_PKTTYPE=y
> CONFIG_BRIDGE_EBT_STP=y
> CONFIG_BRIDGE_EBT_VLAN=y
> CONFIG_BRIDGE_EBT_ARPREPLY=y
> CONFIG_BRIDGE_EBT_DNAT=y
> CONFIG_BRIDGE_EBT_MARK_T=y
> CONFIG_BRIDGE_EBT_REDIRECT=y
> CONFIG_BRIDGE_EBT_SNAT=y
> CONFIG_BRIDGE_EBT_LOG=y
> CONFIG_BRIDGE_EBT_ULOG=y
> CONFIG_BRIDGE_EBT_NFLOG=y
> # CONFIG_IP_DCCP is not set
> CONFIG_IP_SCTP=y
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> CONFIG_NET_SCHED=y
>
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> CONFIG_NET_SCH_HTB=y
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> CONFIG_NET_SCH_RED=y
> CONFIG_NET_SCH_SFQ=y
> CONFIG_NET_SCH_TEQL=y
> CONFIG_NET_SCH_TBF=y
> CONFIG_NET_SCH_GRED=y
> CONFIG_NET_SCH_DSMARK=y
> CONFIG_NET_SCH_NETEM=y
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_INGRESS=y
>
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_ROUTE4=y
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=y
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=y
> CONFIG_NET_CLS_RSVP6=y
> # CONFIG_NET_CLS_FLOW is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=y
> CONFIG_NET_EMATCH_NBYTE=y
> CONFIG_NET_EMATCH_U32=y
> CONFIG_NET_EMATCH_META=y
> CONFIG_NET_EMATCH_TEXT=y
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> CONFIG_NET_ACT_GACT=y
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=y
> CONFIG_NET_ACT_IPT=y
> CONFIG_NET_ACT_NAT=y
> CONFIG_NET_ACT_PEDIT=y
> CONFIG_NET_ACT_SIMP=y
> CONFIG_NET_ACT_SKBEDIT=y
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_DROP_MONITOR is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_AF_RXRPC=y
> # CONFIG_AF_RXRPC_DEBUG is not set
> # CONFIG_RXKAD is not set
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_SERIAL=y
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
>
> #
> # Protocols
> #
> CONFIG_ISAPNP=y
> # CONFIG_PNPBIOS is not set
> # CONFIG_PNPACPI is not set
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_CRYPTOLOOP=y
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> CONFIG_TIFM_CORE=y
> # CONFIG_TIFM_7XX1 is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_C2PORT is not set
>
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
>
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> # CONFIG_IDE_GD_ATAPI is not set
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
>
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_PLATFORM is not set
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
>
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_RZ1000=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_CS5536 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
>
> #
> # Other IDE chipsets support
> #
>
> #
> # Note: most of these also require special kernel boot parameters
> #
> # CONFIG_BLK_DEV_4DRIVES is not set
> # CONFIG_BLK_DEV_ALI14XX is not set
> # CONFIG_BLK_DEV_DTC2278 is not set
> # CONFIG_BLK_DEV_HT6560B is not set
> # CONFIG_BLK_DEV_QD65XX is not set
> # CONFIG_BLK_DEV_UMC8672 is not set
> # CONFIG_BLK_DEV_IDEDMA is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
>
> #
> # Enable only one of the two stacks, unless you know what you are doing
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_COMPAT_NET_DEV_OPS=y
> CONFIG_IFB=y
> CONFIG_DUMMY=y
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=y
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> CONFIG_PHYLIB=y
>
> #
> # MII PHY device drivers
> #
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=y
> CONFIG_VITESSE_PHY=y
> CONFIG_SMSC_PHY=y
> CONFIG_BROADCOM_PHY=y
> CONFIG_ICPLUS_PHY=y
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_FIXED_PHY=y
> CONFIG_MDIO_BITBANG=y
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> CONFIG_NET_VENDOR_3COM=y
> # CONFIG_EL1 is not set
> # CONFIG_EL2 is not set
> # CONFIG_ELPLUS is not set
> # CONFIG_EL16 is not set
> # CONFIG_EL3 is not set
> # CONFIG_3C515 is not set
> CONFIG_VORTEX=y
> # CONFIG_TYPHOON is not set
> # CONFIG_LANCE is not set
> # CONFIG_NET_VENDOR_SMC is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> # CONFIG_DNET is not set
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=y
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> # CONFIG_TULIP_MMIO is not set
> # CONFIG_TULIP_NAPI is not set
> CONFIG_DE4X5=y
> CONFIG_WINBOND_840=y
> CONFIG_DM9102=y
> CONFIG_ULI526X=y
> # CONFIG_AT1700 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_HP100 is not set
> # CONFIG_NET_ISA is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_AC3200 is not set
> # CONFIG_APRICOT is not set
> # CONFIG_B44 is not set
> # CONFIG_FORCEDETH is not set
> # CONFIG_CS89x0 is not set
> CONFIG_E100=y
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> CONFIG_NE2K_PCI=y
> CONFIG_8139CP=y
> CONFIG_8139TOO=y
> CONFIG_8139TOO_PIO=y
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> CONFIG_8139TOO_8129=y
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_R6040 is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SMSC9420 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_NET_POCKET is not set
> # CONFIG_ATL2 is not set
> # CONFIG_NETDEV_1000 is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
>
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=y
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=y
> CONFIG_INPUT_EVBUG=y
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_XTKBD=y
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=y
> # CONFIG_INPUT_WISTRON_BTNS is not set
> # CONFIG_INPUT_UINPUT is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> # CONFIG_SERIO_PARKBD is not set
> CONFIG_SERIO_PCIPS2=y
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> # CONFIG_DEVKMEM is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=48
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_CONSOLE_POLL=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=0
> CONFIG_PRINTER=y
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=y
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> # CONFIG_HW_RANDOM_INTEL is not set
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_GEODE is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_NVRAM=y
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_CHARDEV is not set
> # CONFIG_I2C_HELPER_AUTO is not set
>
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_SIMTEC is not set
>
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
>
> #
> # Graphics adapter I2C/DDC channel drivers
> #
> # CONFIG_I2C_VOODOO3 is not set
>
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_ELEKTOR is not set
> # CONFIG_I2C_PCA_ISA is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_SCx200_ACB is not set
>
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_DS1682 is not set
> # CONFIG_SENSORS_PCF8574 is not set
> # CONFIG_PCF8575 is not set
> # CONFIG_SENSORS_PCA9539 is not set
> # CONFIG_SENSORS_MAX6875 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> # CONFIG_SPI is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> CONFIG_W1=y
> # CONFIG_W1_CON is not set
>
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> # CONFIG_W1_MASTER_DS2482 is not set
>
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> # CONFIG_W1_SLAVE_SMEM is not set
> # CONFIG_W1_SLAVE_DS2431 is not set
> # CONFIG_W1_SLAVE_DS2433 is not set
> CONFIG_W1_SLAVE_DS2760=y
> # CONFIG_W1_SLAVE_BQ27000 is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_HWMON is not set
> # CONFIG_THERMAL is not set
> CONFIG_THERMAL_HWMON=y
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
>
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_REGULATOR is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
>
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_PROGEAR is not set
> # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> CONFIG_HID_DEBUG=y
> # CONFIG_HIDRAW is not set
> CONFIG_HID_PID=y
>
> #
> # Special HID drivers
> #
> # CONFIG_USB_SUPPORT is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
>
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> CONFIG_RTC_DRV_TEST=y
>
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> CONFIG_RTC_DRV_M41T80_WDT=y
> # CONFIG_RTC_DRV_S35390A is not set
> CONFIG_RTC_DRV_FM3130=y
> CONFIG_RTC_DRV_RX8581=y
>
> #
> # SPI RTC drivers
> #
>
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=y
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_BQ4802=y
> CONFIG_RTC_DRV_V3020=y
>
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
>
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_FILE_LOCKING=y
> # CONFIG_XFS_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> CONFIG_GENERIC_ACL=y
>
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_CACHEFILES=y
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
>
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="cp437"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=y
> # CONFIG_DLM is not set
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_FTRACE_SYSCALLS=y
> CONFIG_RING_BUFFER=y
> CONFIG_TRACING=y
> CONFIG_TRACING_SUPPORT=y
>
> #
> # Tracers
> #
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SYSPROF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> CONFIG_CONTEXT_SWITCH_TRACER=y
> # CONFIG_EVENT_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> # CONFIG_BOOT_TRACER is not set
> # CONFIG_TRACE_BRANCH_PROFILING is not set
> # CONFIG_POWER_TRACER is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_KMEMTRACE is not set
> # CONFIG_WORKQUEUE_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> CONFIG_KGDB_SERIAL_CONSOLE=y
> # CONFIG_KGDB_TESTS is not set
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> # CONFIG_4KSTACKS is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=1
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
>
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_PATH=y
> CONFIG_SECURITY_FILE_CAPABILITIES=y
> CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> CONFIG_SECURITY_SMACK=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> # CONFIG_CRYPTO_AUTHENC is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> CONFIG_CRYPTO_SEQIV=y
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
>
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
>
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_586 is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_ARC4 is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_586 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
>
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
>
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_BINARY_PRINTF=y
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_GENERIC_FIND_LAST_BIT=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_NLATTR=y
> --
>  -----Open up your eyes, open up your mind, open up your code -------
> / Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \
> \ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
