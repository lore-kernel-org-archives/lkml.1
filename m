Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYI1WUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYI1WUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 18:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYI1WUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 18:20:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:56517 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYI1WUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 18:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iT9vW13ldtuBIOSRNeiMJsGGzstyYewvP4l92hbS1XGfJ3wimQSpZg904eG8o54zOk
         yRa64Pt5yNB1RmnwV6nQjSFIAD0FBR2xcsSGQn91rG7GKWkXBFt8kVYLqBJbpF2DBrPz
         vjFhGqxz4e+hgsdxLlA+cMlYZuBEtoyIOuqqM=
Message-ID: <83aa947f0809281520o4e5db041x69f8afa982afcb4d@mail.gmail.com>
Date: Mon, 29 Sep 2008 00:20:05 +0200
From: JPM <jpmlists@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: iTCO_wdt v1.03 (30-Apr-2008) will not reboot ICH7-M platform after acpi suspend/wake-up
In-Reply-To: <83aa947f0809281515s56c2672i6161a6fdaacba215@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83aa947f0809281515s56c2672i6161a6fdaacba215@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have an Asus N4L-VM DH. This is an Intel Core Solo platform with
ICH7-M, it includes the Intel TCO watchdog. When I start the board and
kill watchdog, the Intel watchdog reboots the computer.
If I have suspended (S3) the machine at least once before killing
watchdog, then the board just sits there, no reboot occurs.
I have tested this with softdog, and softdog does not fail to reboot
the computer post suspend/wake-up.
I have compiled the iTCO_wdt module into the kernel, same results as
with the external module.
I have woken the computer from button, rtc alarm or WOL, same results.
Here is a trace:
(boot. NOTE: I disconnected all hard drives but the system drive for
testing, disregard the various 'link down" traces for ATA/SATA drives
in the attached dmesg)
cata:~# lsmod | grep iTCO
iTCO_wdt                9380  1
cata:~# lsof -n | grep watchdog
watchdog  2460          root  cwd       DIR       33,1     4096          2 /
watchdog  2460          root  rtd       DIR       33,1     4096          2 /
watchdog  2460          root  txt       REG       33,1    72416
4342776 /usr/sbin/watchdog
watchdog  2460          root  mem       REG       33,1    42504
1163415 /lib/i686/cmov/libnss_files-2.7.so
watchdog  2460          root  mem       REG       33,1  1413540
1163362 /lib/i686/cmov/libc-2.7.so
watchdog  2460          root  mem       REG       33,1   113248
1130538 /lib/ld-2.7.so
watchdog  2460          root    0u     unix 0xf6ce83c0
5342 socket
watchdog  2460          root    1w      CHR     10,130
3566 /dev/watchdog
watchdog  2460          root    2r      REG        0,3        0
4026531840 /proc/loadavg
watchdog  2460          root    3u      raw
5341 00000000:0001->00000000:0000 st=07
watchdog  2460          root    4r      REG        0,3        0
4026531842 /proc/meminfo
cata:~# echo mem > /sys/power/state
(suspends)
(WOL packet)
cata:~# killall -s KILL watchdog
cata:~# date
Sun Sep 28 23:52:08 CEST 2008
cata:~# lsmod | grep iTCO
iTCO_wdt                9380  0
cata:~# lsof -n | grep watchdog
cata:~# date
Sun Sep 28 23:54:23 CEST 2008
cata:~# dmesg | tail
[  121.304130] ACPI: PCI Interrupt 0000:04:0a.0[A] -> GSI 22 (level,
low) -> IRQ 22
[  121.456039] ata5: SATA link down (SStatus 0 SControl 300)
[  121.456069] ata6: SATA link down (SStatus 0 SControl 300)
[  121.624037] ata8: SATA link down (SStatus 0 SControl 310)
[  121.624065] ata7: SATA link down (SStatus 0 SControl 310)
[  121.956006] hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  121.956006] hde: UDMA/100 mode selected
[  121.957712] Restarting tasks ... done.
[  124.292989] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  156.732648] iTCO_wdt: Unexpected close, not stopping watchdog!
cata:~# reboot

Broadcast message from root@cata (pts/0) (Sun Sep 28 23:58:43 2008):
The system is going down for reboot NOW!
cata:~#
(reboot succeeds)
Please let me know if I can be of further help.
Regards,
--JP
PS: Full dmesg and lspci -vvv
>>>
cata:~# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-cata-1 (2.6.26) (root@cata) (gcc
version 4.3.1 (Debian 4.3.1-9) ) #1 SMP Fri Sep 26 03:18:22 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003feb0000 (usable)
[    0.000000]  BIOS-e820: 000000003feb0000 - 000000003fec0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fec0000 - 000000003fef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 261808) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261808
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261808
[    0.000000] On node 0 totalpages: 261808
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 254 pages used for memmap
[    0.000000]   HighMem zone: 32178 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FA550, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FEB0100, 004C (r1 A M I  OEMXSDT  11000622
MSFT       97)
[    0.000000] ACPI: FACP 3FEB0290, 00F4 (r3 A M I  OEMFACP  11000622
MSFT       97)
[    0.000000] ACPI: DSDT 3FEB0430, 967F (r1  A0465 A0465000        0
INTL 20060113)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: APIC 3FEB0390, 005C (r1 A M I  OEMAPIC  11000622
MSFT       97)
[    0.000000] ACPI: MCFG 3FEB03F0, 003C (r1 A M I  OEMMCFG  11000622
MSFT       97)
[    0.000000] ACPI: OEMB 3FEC0040, 0060 (r1 A M I  AMI_OEM  11000622
MSFT       97)
[    0.000000] ACPI: SSDT 3FEB9AB0, 03B0 (r1    AMI   CPU1PM        1
INTL 20060113)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
3ff00000:bef00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PERCPU: Allocating 37512 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 259762
[    0.000000] Kernel command line:
root=UUID=9aae733c-d578-4ce2-883f-5b695ce25b67 ro quiet noresume
acpi_osi="Windows 2001" acpi_osi="!Linux" loglevel=7
[    0.000000] ACPI: Added _OSI(Windows 2001)
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1500.045 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 1027940k/1047232k available (2025k kernel code,
18592k reserved, 797k data, 248k init, 129728k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc03ca000 - 0xc0408000   ( 248 kB)
[    0.004000]       .data : 0xc02fa5bc - 0xc03c1bb0   ( 797 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02fa5bc   (2025 kB)
[    0.004000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084095] Calibrating delay using timer specific routine..
3003.44 BogoMIPS (lpj=6006888)
[    0.084224] Security Framework initialized
[    0.084273] Capability LSM initialized
[    0.084331] Mount-cache hash table entries: 512
[    0.084531] Initializing cgroup subsys ns
[    0.084576] Initializing cgroup subsys cpuacct
[    0.084622] Initializing cgroup subsys devices
[    0.084684] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084754] CPU: L2 cache: 2048K
[    0.084798] Intel machine check architecture supported.
[    0.084848] Intel machine check reporting enabled on CPU#0.
[    0.084893] using mwait in idle threads.
[    0.084944] Checking 'hlt' instruction... OK.
[    0.101740] ACPI: Core revision 20080321
[    0.116156] ENABLING IO-APIC IRQs
[    0.116392] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.156134] CPU0: Intel Genuine Intel(R) CPU           T1200  @
1.50GHz stepping 08
[    0.160010] Brought up 1 CPUs
[    0.160010] Total of 1 processors activated (3003.44 BogoMIPS).
[    0.160010] net_namespace: 660 bytes
[    0.160010] Booting paravirtualized kernel on bare hardware
[    0.160010] NET: Registered protocol family 16
[    0.160010] ACPI: bus type pci registered
[    0.160010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.160010] PCI: Not using MMCONFIG.
[    0.160010] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    0.160010] PCI: Using configuration type 1 for base access
[    0.160010] Setting up standard PCI resources
[    0.169123] ACPI: EC: Look up EC in DSDT
[    0.187018] ACPI: Interpreter enabled
[    0.187064] ACPI: (supports S0 S1 S3 S4 S5)
[    0.187251] ACPI: Using IOAPIC for interrupt routing
[    0.187370] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.193944] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.193994] PCI: Using MMCONFIG for extended config space
[    0.205706] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.206512] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.206519] pci 0000:00:1f.0: quirk: region 0800-087f claimed by
ICH6 ACPI/GPIO/TCO
[    0.206581] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.207684] PCI: Transparent bridge - 0000:00:1e.0
[    0.207767] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.208107] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.208262] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.208411] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.208564] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.221764] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.222290] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11
12 14 15) *0, disabled.
[    0.222875] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.223396] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.223919] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11
12 14 15) *0, disabled.
[    0.224520] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.225042] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.225561] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.226140] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.226221] pnp: PnP ACPI init
[    0.226269] ACPI: bus type pnp registered
[    0.231532] pnp: PnP ACPI: found 14 devices
[    0.231577] ACPI: ACPI bus type pnp unregistered
[    0.231623] PnPBIOS: Disabled by ACPI PNP
[    0.231971] PCI: Using ACPI for IRQ routing
[    0.232381] hpet clockevent registered
[    0.232387] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.232536] hpet0: 3 64-bit timers, 14318180 Hz
[    0.233623] ACPI: RTC can wake from S4
[    0.233695] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.233752] system 00:06: ioport range 0x290-0x297 has been reserved
[    0.233804] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.233852] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.233900] system 00:07: ioport range 0x480-0x4bf has been reserved
[    0.233949] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.233998] system 00:07: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.234052] system 00:09: iomem range 0xffc00000-0xffefffff could
not be reserved
[    0.234116] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.234166] system 00:0a: iomem range 0xfee00000-0xfee00fff could
not be reserved
[    0.234235] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.234289] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.234336] system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[    0.234385] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.234434] system 00:0d: iomem range 0x100000-0x3fefffff could not
be reserved
[    0.265002] PCI: Bridge: 0000:00:1c.0
[    0.265046]   IO window: disabled.
[    0.265092]   MEM window: disabled.
[    0.265137]   PREFETCH window: 0x00000000bfe00000-0x00000000bfefffff
[    0.265190] PCI: Bridge: 0000:00:1c.2
[    0.265233]   IO window: a000-afff
[    0.265280]   MEM window: 0xff500000-0xff5fffff
[    0.265326]   PREFETCH window: disabled.
[    0.265374] PCI: Bridge: 0000:00:1c.3
[    0.265418]   IO window: 9000-9fff
[    0.265464]   MEM window: 0xff400000-0xff4fffff
[    0.265510]   PREFETCH window: disabled.
[    0.265559] PCI: Bridge: 0000:00:1e.0
[    0.265603]   IO window: b000-cfff
[    0.265648]   MEM window: 0xff600000-0xff8fffff
[    0.265695]   PREFETCH window: 0x0000000040000000-0x00000000400fffff
[    0.265771] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    0.265861] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.265884] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level,
low) -> IRQ 18
[    0.265972] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.265995] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level,
low) -> IRQ 19
[    0.266084] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.266097] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.266121] NET: Registered protocol family 2
[    0.266267] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.266570] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.267471] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.267931] TCP: Hash tables configured (established 131072 bind 65536)
[    0.267979] TCP reno registered
[    0.268887] NET: Registered protocol family 1
[    0.269073] checking if image is initramfs... it is
[    0.736345] Switched to high resolution mode on CPU 0
[    0.863932] Freeing initrd memory: 5984k freed
[    0.864681] audit: initializing netlink socket (disabled)
[    0.864740] type=2000 audit(1222638528.864:1): initialized
[    0.864959] highmem bounce pool size: 64 pages
[    0.865007] Total HugeTLB memory allocated, 0
[    0.865132] VFS: Disk quotas dquot_6.5.1
[    0.865205] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.865317] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.865529] msgmni has been set to 1766
[    0.865693] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.865754] io scheduler noop registered
[    0.865797] io scheduler anticipatory registered
[    0.865841] io scheduler deadline registered
[    0.865895] io scheduler cfq registered (default)
[    0.865952] pci 0000:00:02.0: Boot video device
[    0.893698] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.893741] assign_interrupt_mode Found MSI capability
[    0.893833] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.893886] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.893930] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.894036] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.894081] assign_interrupt_mode Found MSI capability
[    0.894165] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.894210] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.894253] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.894359] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.894401] assign_interrupt_mode Found MSI capability
[    0.894487] Allocate Port Service[0000:00:1c.3:pcie00]
[    0.894533] Allocate Port Service[0000:00:1c.3:pcie02]
[    0.894578] Allocate Port Service[0000:00:1c.3:pcie03]
[    0.894963] isapnp: Scanning for PnP cards...
[    1.248001] isapnp: No Plug & Play device found
[    1.250496] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
[    1.252702] brd: module loaded
[    1.252848] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.252895] PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    1.253516] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.253705] mice: PS/2 mouse device common for all mice
[    1.253884] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.253949] rtc0: alarms up to one month
[    1.254057] cpuidle: using governor ladder
[    1.254102] cpuidle: using governor menu
[    1.254148] No iBFT detected.
[    1.254662] TCP cubic registered
[    1.254706] NET: Registered protocol family 17
[    1.254838] RPC: Registered udp transport module.
[    1.254883] RPC: Registered tcp transport module.
[    1.254941] Using IPI No-Shortcut mode
[    1.255131] registered taskstats version 1
[    1.255365] rtc_cmos 00:03: setting system clock to 2008-09-28
21:48:49 UTC (1222638529)
[    1.255567] Freeing unused kernel memory: 248k freed
[    1.276878] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.360310] ACPI Error (psparse-0530): Method parse/execution
failed [\_PR_.CPU1._PDC] (Node f743089c), AE_ALREADY_EXISTS
[    1.360464] ACPI: Marking method _PDC as Serialized because of
AE_ALREADY_EXISTS error
[    1.361074] ACPI: CPU0 (power states: C1[C1] C2[C3])
[    1.361249] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.813944] No dock devices found.
[    1.824079] SCSI subsystem initialized
[    1.840703] Uniform Multi-Platform E-IDE driver
[    1.840754] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[    1.841147] JMB: IDE controller (0x197b:0x2363 rev 0x02) at  PCI
slot 0000:02:00.1
[    1.841227] JMicron IDE 0000:02:00.1: enabling device (0000 -> 0001)
[    1.841281] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 19 (level,
low) -> IRQ 19
[    1.841374] JMB: 100% native mode on irq 19
[    1.841434] PCI: Setting latency timer of device 0000:02:00.1 to 64
[    1.841441]     ide0: BM-DMA at 0xa400-0xa407
[    1.841495]     ide1: BM-DMA at 0xa408-0xa40f
[    1.841544] Probing IDE interface ide0...
[    1.850527] libata version 3.00 loaded.
[    1.892115] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[    1.892166] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.932192] usbcore: registered new interface driver usbfs
[    1.932276] usbcore: registered new interface driver hub
[    1.932359] usbcore: registered new device driver usb
[    1.938250] USB Universal Host Controller Interface driver v3.0
[    2.188003] Marking TSC unstable due to: TSC halts in idle.
[    2.411427] Probing IDE interface ide1...
[    2.977787] ide0 at 0xac00-0xac07,0xa882 on irq 19
[    2.977867] ide1 at 0xa800-0xa807,0xa482 on irq 19
[    2.978428] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 23
[    2.978522] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.978527] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.978705] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[    2.978795] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
[    2.978934] usb usb1: configuration #1 chosen from 1 choice
[    2.979017] hub 1-0:1.0: USB hub found
[    2.979066] hub 1-0:1.0: 2 ports detected
[    3.080126] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.080176] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.080235] usb usb1: Product: UHCI Host Controller
[    3.080280] usb usb1: Manufacturer: Linux 2.6.26-cata-1 uhci_hcd
[    3.080327] usb usb1: SerialNumber: 0000:00:1d.0
[    3.080434] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[    3.080524] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.080529] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.080598] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[    3.080682] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    3.080808] usb usb2: configuration #1 chosen from 1 choice
[    3.080885] hub 2-0:1.0: USB hub found
[    3.080933] hub 2-0:1.0: 2 ports detected
[    3.184109] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.184158] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.184217] usb usb2: Product: UHCI Host Controller
[    3.184262] usb usb2: Manufacturer: Linux 2.6.26-cata-1 uhci_hcd
[    3.184308] usb usb2: SerialNumber: 0000:00:1d.1
[    3.184413] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[    3.184502] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.184506] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.184575] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[    3.184662] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
[    3.184791] usb usb3: configuration #1 chosen from 1 choice
[    3.184870] hub 3-0:1.0: USB hub found
[    3.184917] hub 3-0:1.0: 2 ports detected
[    3.288101] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.288150] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.288209] usb usb3: Product: UHCI Host Controller
[    3.288254] usb usb3: Manufacturer: Linux 2.6.26-cata-1 uhci_hcd
[    3.288301] usb usb3: SerialNumber: 0000:00:1d.2
[    3.288404] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[    3.288495] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    3.288499] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.288568] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[    3.288656] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e000
[    3.288787] usb usb4: configuration #1 chosen from 1 choice
[    3.288863] hub 4-0:1.0: USB hub found
[    3.288911] hub 4-0:1.0: 2 ports detected
[    3.392106] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.392155] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.392213] usb usb4: Product: UHCI Host Controller
[    3.392257] usb usb4: Manufacturer: Linux 2.6.26-cata-1 uhci_hcd
[    3.392303] usb usb4: SerialNumber: 0000:00:1d.3
[    3.392424] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 23
[    3.392519] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.392523] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.392601] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[    3.396575] ehci_hcd 0000:00:1d.7: debug port 1
[    3.396624] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[    3.396630] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffa3b800
[    3.412018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[    3.412143] usb usb5: configuration #1 chosen from 1 choice
[    3.412219] hub 5-0:1.0: USB hub found
[    3.412270] hub 5-0:1.0: 8 ports detected
[    3.516103] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    3.516152] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.516212] usb usb5: Product: EHCI Host Controller
[    3.516257] usb usb5: Manufacturer: Linux 2.6.26-cata-1 ehci_hcd
[    3.516303] usb usb5: SerialNumber: 0000:00:1d.7
[    3.516378] ahci 0000:00:1f.2: version 3.0
[    3.516398] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[    4.520033] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5
Gbps 0x5 impl SATA mode
[    4.520095] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part
[    4.520145] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    4.520283] scsi0 : ahci
[    4.520417] scsi1 : ahci
[    4.520519] scsi2 : ahci
[    4.520628] scsi3 : ahci
[    4.520769] ata1: SATA max UDMA/133 abar m1024@0xffa3bc00 port
0xffa3bd00 irq 220
[    4.520828] ata2: DUMMY
[    4.520870] ata3: SATA max UDMA/133 abar m1024@0xffa3bc00 port
0xffa3be00 irq 220
[    4.520928] ata4: DUMMY
[    4.840068] ata1: SATA link down (SStatus 0 SControl 300)
[    5.160067] ata3: SATA link down (SStatus 0 SControl 300)
[    5.160184] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level,
low) -> IRQ 18
[    6.164096] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    6.164158] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
[    6.164211] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    6.164346] scsi4 : ahci
[    6.164696] scsi5 : ahci
[    6.164778] ata5: SATA max UDMA/133 abar m8192@0xff5fe000 port
0xff5fe100 irq 18
[    6.164840] ata6: SATA max UDMA/133 abar m8192@0xff5fe000 port
0xff5fe180 irq 18
[    6.484079] ata5: SATA link down (SStatus 0 SControl 300)
[    6.804077] ata6: SATA link down (SStatus 0 SControl 300)
[    6.806744] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 19 (level,
low) -> IRQ 19
[    6.806838] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    6.919451] eth0: (PCI Express:2.5GB/s:Width x1) 00:17:31:38:46:c8
[    6.919501] eth0: Intel(R) PRO/1000 Network Connection
[    6.919632] eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[    6.921908] ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level,
low) -> IRQ 21
[    6.971757] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]
MMIO=[ff8ff800-ff8fffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.973602] sata_sil 0000:04:09.0: version 2.3
[    6.973636] ACPI: PCI Interrupt 0000:04:09.0[A] -> GSI 21 (level,
low) -> IRQ 21
[    6.973785] scsi6 : sata_sil
[    6.973899] scsi7 : sata_sil
[    6.973974] ata7: SATA max UDMA/100 mmio m512@0xff8ff400 tf 0xff8ff480 irq 21
[    6.974024] ata8: SATA max UDMA/100 mmio m512@0xff8ff400 tf 0xff8ff4c0 irq 21
[    7.292080] ata7: SATA link down (SStatus 0 SControl 310)
[    7.612073] ata8: SATA link down (SStatus 0 SControl 310)
[    7.612159] ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI
slot 0000:00:1f.1
[    7.612228] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[    7.612322] ICH7: not 100% native mode: will probe irqs later
[    7.612376] ICH7: IDE port disabled
[    7.612423]     ide2: BM-DMA at 0xffa0-0xffa7
[    7.612472] Probing IDE interface ide2...
[    7.621965] CMD649: IDE controller (0x1095:0x0649 rev 0x02) at  PCI
slot 0000:04:0a.0
[    7.622043] ACPI: PCI Interrupt 0000:04:0a.0[A] -> GSI 22 (level,
low) -> IRQ 22
[    7.622139] CMD649: 100% native mode on irq 22
[    7.622190]     ide3: BM-DMA at 0xb800-0xb807
[    7.622240]     ide4: BM-DMA at 0xb808-0xb80f
[    7.622286] Probing IDE interface ide3...
[    7.900319] hde: ST96812A, ATA DISK drive
[    8.188097] Probing IDE interface ide4...
[    8.244178] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000a72733]
[    8.572093] hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    8.574483] hde: UDMA/100 mode selected
[    8.576428] ide2 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.756101] ide3 at 0xc080-0xc087,0xc002 on irq 22
[    8.756179] ide4 at 0xbc00-0xbc07,0xb882 on irq 22
[    8.772336] hde: max request size: 512KiB
[    8.989697] hde: 117210240 sectors (60011 MB) w/8192KiB Cache,
CHS=16383/255/63
[    8.989800] hde: cache flushes supported
[    8.989800]  hde: hde1 hde2
[    9.189957] kjournald starting.  Commit interval 5 seconds
[    9.189957] EXT3-fs: mounted filesystem with ordered data mode.
[   11.300143] udevd version 125 started
[   11.954563] Linux agpgart interface v0.103
[   12.062148] agpgart: Detected an Intel 945GM Chipset.
[   12.062562] agpgart: Detected 764K stolen memory.
[   12.079694] agpgart: AGP aperture is 256M @ 0xd0000000
[   12.153174] input: Power Button (FF) as /class/input/input1
[   12.180058] ACPI: Power Button (FF) [PWRF]
[   12.180219] input: Power Button (CM) as /class/input/input2
[   12.212055] ACPI: Power Button (CM) [PWRB]
[   12.914584] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   12.914721] iTCO_wdt: Found a ICH7-M DH TCO device (Version=2,
TCOBASE=0x0860)
[   12.914812] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.014664] intel_rng: FWH not detected
[   13.119471] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level,
low) -> IRQ 19
[   13.135284] input: PC Speaker as /class/input/input3
[   13.150683] Error: Driver 'pcspkr' is already registered, aborting...
[   14.496042] Adding 2265156k swap on /dev/hde2.  Priority:-1
extents:1 across:2265156k
[   14.913143] EXT3 FS on hde1, internal journal
[   15.192841] w83627ehf: Found W83627EHG chip at 0x290
[   18.132405] NET: Registered protocol family 10
[   18.132945] lo: Disabled Privacy Extensions
[   18.133977] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.440953] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   20.441373] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.520385] ACPI: 'P0P2' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   20.520448] ACPI: 'P0P4' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   20.520509] ACPI: 'P0P5' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   20.520569] ACPI: 'P0P6' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   20.520631] ACPI: 'P0P8' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   20.520692] ACPI: 'P0P9' and 'P0P7' have the same GPE, can't
disable/enable one seperately
[   23.297921] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   23.317094] NFSD: starting 90-second grace period
[   25.457419] warning: `avahi-daemon' uses 32-bit capabilities
(legacy support in use)
[   31.232012] eth0: no IPv6 routers present
[  116.066049] PM: Syncing filesystems ... done.
[  116.072438] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  116.092454] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[  116.092685] Suspending console(s)
[  118.828199] ACPI handle has no context!
[  118.828354] ACPI: PCI interrupt for device 0000:04:09.0 disabled
[  118.844134] ACPI handle has no context!
[  118.935958] ACPI: PCI interrupt for device 0000:01:00.0 disabled
[  118.935968] ACPI handle has no context!
[  118.980180] ACPI: PCI interrupt for device 0000:02:00.0 disabled
[  119.044208] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  119.060109] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
[  119.060143] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  119.060177] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  119.060209] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  119.060727] ACPI: Preparing to enter system sleep state S3
[  119.061419] Disabling non-boot CPUs ...
[  119.061419] Intel machine check architecture supported.
[  119.061428] Intel machine check reporting enabled on CPU#0.
[  119.061468] Back to C!
[  119.061728] Force enabled HPET at resume
[  119.062889] PM: Writing back config space on device 0000:00:00.0 at
offset 1 (was 20900006, writing 30900006)
[  119.079907] PM: Writing back config space on device 0000:00:1c.0 at
offset 7 (was f0, writing 200000f0)
[  119.079921] PM: Writing back config space on device 0000:00:1c.0 at
offset 1 (was 100106, writing 100506)
[  119.079958] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[  119.079993] PM: Writing back config space on device 0000:00:1c.2 at
offset 1 (was 100107, writing 100507)
[  119.080004] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[  119.080004] PM: Writing back config space on device 0000:00:1c.3 at
offset 1 (was 100107, writing 100507)
[  119.080004] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[  119.080004] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 23
[  119.080004] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  119.080004] usb usb1: root hub lost power or was reset
[  119.080004] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[  119.080004] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  119.080069] usb usb2: root hub lost power or was reset
[  119.080089] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[  119.080095] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  119.080143] usb usb3: root hub lost power or was reset
[  119.080161] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[  119.080167] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[  119.080213] usb usb4: root hub lost power or was reset
[  119.096070] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 23
[  119.096076] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  119.096139] PM: Writing back config space on device 0000:00:1e.0 at
offset 9 (was 1fff1, writing 40014001)
[  119.096154] PM: Writing back config space on device 0000:00:1e.0 at
offset 1 (was 100107, writing 8100107)
[  119.096174] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  119.096247] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[  119.112091] PM: Writing back config space on device 0000:00:1f.2 at
offset 1 (was 2b00007, writing 2b00407)
[  119.112128] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[  119.732065] Clocksource tsc unstable (delta = -499999830 ns)
[  120.132132] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level,
low) -> IRQ 18
[  120.132140] PCI: Setting latency timer of device 0000:02:00.0 to 64
[  120.436070] ata3: SATA link down (SStatus 0 SControl 300)
[  120.436089] ata1: SATA link down (SStatus 0 SControl 300)
[  121.136150] PM: Writing back config space on device 0000:02:00.1 at
offset 1 (was 100000, writing 100005)
[  121.136181] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 19 (level,
low) -> IRQ 19
[  121.136188] PCI: Setting latency timer of device 0000:02:00.1 to 64
[  121.152120] PM: Writing back config space on device 0000:01:00.0 at
offset 3 (was 8, writing 10)
[  121.152186] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 19 (level,
low) -> IRQ 19
[  121.152195] PCI: Setting latency timer of device 0000:01:00.0 to 64
[  121.289745] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]
MMIO=[ff8ff800-ff8fffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  121.304059] ACPI: PCI Interrupt 0000:04:09.0[A] -> GSI 21 (level,
low) -> IRQ 21
[  121.304069] sata_sil 0000:04:09.0: Applying R_ERR on DMA activate
FIS errata fix
[  121.304130] ACPI: PCI Interrupt 0000:04:0a.0[A] -> GSI 22 (level,
low) -> IRQ 22
[  121.456039] ata5: SATA link down (SStatus 0 SControl 300)
[  121.456069] ata6: SATA link down (SStatus 0 SControl 300)
[  121.624037] ata8: SATA link down (SStatus 0 SControl 310)
[  121.624065] ata7: SATA link down (SStatus 0 SControl 310)
[  121.956006] hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  121.956006] hde: UDMA/100 mode selected
[  121.957712] Restarting tasks ... done.
[  124.292989] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  156.732648] iTCO_wdt: Unexpected close, not stopping watchdog!
>>>
cata:~# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
Subsystem: ASUSTeK Computer Inc. Device 8218
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort+ <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information <?>
Kernel driver in use: agpgart-intel
Kernel modules: intel-agp
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
Subsystem: ASUSTeK Computer Inc. Device 8218
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 5
Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
Region 1: I/O ports at ec00 [size=8]
Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
Region 3: Memory at ffa40000 (32-bit, non-prefetchable) [size=256K]
Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
Address: 00000000  Data: 0000
Capabilities: [d0] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Kernel modules: intelfb
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000bfe00000-00000000bfefffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- RBE- FLReset-
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
ClockPM- Suprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
Address: fee0100c  Data: 41c1
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8219
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100] Virtual Channel <?>
Capabilities: [180] Root Complex Link <?>
Kernel driver in use: pcieport-driver
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02)
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000a000-0000afff
Memory behind bridge: ff500000-ff5fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- RBE- FLReset-
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
ClockPM- Suprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
Address: fee0100c  Data: 41c9
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8219
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100] Virtual Channel <?>
Capabilities: [180] Root Complex Link <?>
Kernel driver in use: pcieport-driver
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 02)
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 00009000-00009fff
Memory behind bridge: ff400000-ff4fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- RBE- FLReset-
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
ClockPM- Suprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
Address: fee0100c  Data: 41d1
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8219
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100] Virtual Channel <?>
Capabilities: [180] Root Complex Link <?>
Kernel driver in use: pcieport-driver
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 4: I/O ports at d800 [size=32]
Kernel driver in use: uhci_hcd
Kernel modules: uhci-hcd
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 4: I/O ports at d880 [size=32]
Kernel driver in use: uhci_hcd
Kernel modules: uhci-hcd
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 18
Region 4: I/O ports at dc00 [size=32]
Kernel driver in use: uhci_hcd
Kernel modules: uhci-hcd
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin D routed to IRQ 16
Region 4: I/O ports at e000 [size=32]
Kernel driver in use: uhci_hcd
Kernel modules: uhci-hcd
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02) (prog-if 20)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 0: Memory at ffa3b800 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Kernel driver in use: ehci_hcd
Kernel modules: ehci-hcd
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
(prog-if 01)
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
I/O behind bridge: 0000b000-0000cfff
Memory behind bridge: ff600000-ff8fffff
Prefetchable memory behind bridge: 0000000040000000-00000000400fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 8219
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC
Interface Bridge (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information <?>
Kernel modules: intel-rng, iTCO_wdt
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 18
Region 0: I/O ports at 01f0 [size=8]
Region 1: I/O ports at 03f4 [size=1]
Region 2: I/O ports at 0170 [size=8]
Region 3: I/O ports at 0374 [size=1]
Region 4: I/O ports at ffa0 [size=16]
Kernel driver in use: PIIX_IDE
Kernel modules: piix
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA AHCI Controller (rev 02) (prog-if 01)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 220
Region 0: I/O ports at e880 [size=8]
Region 1: I/O ports at e800 [size=4]
Region 2: I/O ports at e480 [size=8]
Region 3: I/O ports at e400 [size=4]
Region 4: I/O ports at e080 [size=16]
Region 5: Memory at ffa3bc00 (32-bit, non-prefetchable) [size=1K]
Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
Address: fee0100c  Data: 41e1
Capabilities: [70] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ahci
Kernel modules: ahci
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
Subsystem: ASUSTeK Computer Inc. Device 8219
Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin B routed to IRQ 19
Region 4: I/O ports at 0400 [size=32]
Kernel driver in use: i801_smbus
Kernel modules: i2c-i801
01:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet
Controller
Subsystem: ASUSTeK Computer Inc. Device 81c2
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 219
Region 0: Memory at ff4e0000 (32-bit, non-prefetchable) [size=128K]
Region 2: I/O ports at 9c00 [size=32]
Capabilities: [c8] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
Address: 00000000fee0100c  Data: 413a
Capabilities: [e0] Express (v1) Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <64us
ClockPM+ Suprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100] Advanced Error Reporting <?>
Capabilities: [140] Device Serial Number c8-46-38-ff-ff-31-17-00
Kernel driver in use: e1000e
Kernel modules: e1000e
02:00.0 SATA controller: JMicron Technologies, Inc. JMicron
20360/20363 AHCI Controller (rev 02) (prog-if 01)
Subsystem: ASUSTeK Computer Inc. Device 81e4
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 18
Region 5: Memory at ff5fe000 (32-bit, non-prefetchable) [size=8K]
Expansion ROM at ff5e0000 [disabled] [size=64K]
Capabilities: [68] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1 <16us
ClockPM- Suprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Kernel driver in use: ahci
Kernel modules: ahci
02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])
Subsystem: ASUSTeK Computer Inc. Device 81e4
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 0: I/O ports at ac00 [size=8]
Region 1: I/O ports at a880 [size=4]
Region 2: I/O ports at a800 [size=8]
Region 3: I/O ports at a480 [size=4]
Region 4: I/O ports at a400 [size=16]
Capabilities: [68] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: JMicron IDE
Kernel modules: jmicron
04:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10)
Subsystem: ASUSTeK Computer Inc. Device 815b
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 21
Region 0: Memory at ff8ff800 (32-bit, non-prefetchable) [size=2K]
Region 1: Memory at ff8f8000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME+
Kernel driver in use: ohci1394
Kernel modules: ohci1394
04:09.0 Mass storage controller: Silicon Image, Inc. SiI 3512
[SATALink/SATARaid] Serial ATA Controller (rev 01)
Subsystem: Silicon Image, Inc. SiI 3512 [SATALink/SATARaid] Serial ATA
Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 21
Region 0: I/O ports at cc00 [size=8]
Region 1: I/O ports at c880 [size=4]
Region 2: I/O ports at c800 [size=8]
Region 3: I/O ports at c480 [size=4]
Region 4: I/O ports at c400 [size=16]
Region 5: Memory at ff8ff400 (32-bit, non-prefetchable) [size=512]
Expansion ROM at 40000000 [disabled] [size=512K]
Capabilities: [60] Power Management version 2
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=2 PME-
Kernel driver in use: sata_sil
Kernel modules: sata_sil
04:0a.0 IDE interface: Silicon Image, Inc. SiI 0649 Ultra ATA/100 PCI
to ATA Host Controller (rev 02) (prog-if 8f [Master SecP SecO PriP
PriO])
Subsystem: Silicon Image, Inc. SiI 0649 Ultra ATA/100 PCI to ATA Host Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (500ns min, 1000ns max)
Interrupt: pin A routed to IRQ 22
Region 0: I/O ports at c080 [size=8]
Region 1: I/O ports at c000 [size=4]
Region 2: I/O ports at bc00 [size=8]
Region 3: I/O ports at b880 [size=4]
Region 4: I/O ports at b800 [size=16]
Expansion ROM at 40080000 [disabled] [size=512K]
Capabilities: [60] Power Management version 2
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=3 PME-
Kernel driver in use: CMD64x_IDE
Kernel modules: cmd64x
>>>
