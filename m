Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYKKXcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYKKXcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYKKXck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:32:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:2607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYKKXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZT8v7E0jdGm/Og+wCX4WU7Mz/Dyj0zmUY5R69JjilG/EeRxllTRB/lcKJjxJvCY6re
         FH8hMHhuPvM9IUvOx+IaEMdLlbqdts3A2KdVuKLHrT/IUFpy114p7u9i21ffbc/JGFOJ
         tkASZN4EXnsBXnY3ZMnyOXYeU0wFFDjSa4Qos=
Date: Wed, 12 Nov 2008 02:32:30 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org, kernel-testers@vger.kernel.org, rjw@sisk.pl
Subject: 2.6.28-rc4: BUG: spinlock lockup on CPU#0
Message-ID: <20081111233230.GC12456@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It is on sparc64 (Ultra 10). 2.6.28-rc4-00011-g3ad4f59

BUG: spinlock lockup on CPU#0, metalog/1322, 00000000007f1430
Kernel panic - not syncing: Aiee, killing interrupt handler!

It seems Sysrq does not work.

David, how can I provide more info before I reboot it ?

Full dmesg:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.27.0 2000/08/23 15:45'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 2.6.28-rc4-00011-g3ad4f59 (fireball@cygnus) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #6 PREEMPT Tue Nov 11 03:16:19 MSK 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:f5:ba:1d
[    0.000000] Kernel: Using 3 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
[    0.000000] PROM: Built device tree with 43896 bytes of memory.
[    0.000000] Top of RAM: 0x3ff46000, Total RAM: 0x3ff34000
[    0.000000] Memory hole size: 0MB
[    0.000000] [0000000200000000-fffff80001000000] page_structs=131072 node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80001400000] page_structs=131072 node=0 entry=1/0
[    0.000000] Allocated 1056768 bytes for kernel page tables.
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0001ffa3
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0001ff7f
[    0.000000]     0: 0x0001ff80 -> 0x0001ff97
[    0.000000]     0: 0x0001ff9f -> 0x0001ffa3
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129946
[    0.000000] Kernel command line: root=/dev/sda2 netconsole=@192.168.1.5/eth1,6667@192.168.1.3/00:08:c7:da:88:fb
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] clocksource: mult[245d1] shift[16]
[    0.000000] clockevent: mult[70a3d70a] shift[32]
[   20.820092] Console: colour dummy device 80x25
[   20.920473] console handover: boot [earlyprom0] -> real [tty0]
[   21.029396] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   21.029516] ... MAX_LOCKDEP_SUBCLASSES:    8
[   21.029581] ... MAX_LOCK_DEPTH:          48
[   21.029644] ... MAX_LOCKDEP_KEYS:        8191
[   21.029710] ... CLASSHASH_SIZE:           4096
[   21.029776] ... MAX_LOCKDEP_ENTRIES:     8192
[   21.029842] ... MAX_LOCKDEP_CHAINS:      16384
[   21.029908] ... CHAINHASH_SIZE:          8192
[   21.029975]  memory used by lock dependency info: 3839 kB
[   21.030052]  per task-struct memory footprint: 1920 bytes
[   21.030129] ------------------------
[   21.030185] | Locking API testsuite:
[   21.030243] ----------------------------------------------------------------------------
[   21.030354]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[   21.030467]   --------------------------------------------------------------------------
[   21.030620]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.056564]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.081869]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.107377]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.132867]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.158603]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.184318]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.210082]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.235279]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.260474]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   21.285859]   --------------------------------------------------------------------------
[   21.286009]               recursive read-lock:             |  ok  |             |  ok  |
[   21.294539]            recursive read-lock #2:             |  ok  |             |  ok  |
[   21.303071]             mixed read-write-lock:             |  ok  |             |  ok  |
[   21.311616]             mixed write-read-lock:             |  ok  |             |  ok  |
[   21.320169]   --------------------------------------------------------------------------
[   21.320321]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   21.332968]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   21.345631]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   21.358286]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   21.370941]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[   21.383607]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[   21.396266]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   21.408931]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   21.421603]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   21.434274]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   21.446950]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   21.459698]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   21.472460]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   21.485217]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   21.497963]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   21.510714]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   21.523465]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   21.536200]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   21.548947]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   21.561637]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   21.574330]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   21.587066]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   21.599807]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   21.612546]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   21.625304]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   21.638044]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   21.650807]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   21.663550]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   21.676311]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   21.689054]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   21.701799]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   21.714547]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   21.727314]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   21.740048]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   21.752805]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   21.765560]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   21.778332]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   21.791099]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   21.803888]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   21.816643]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   21.829421]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   21.842171]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   21.854949]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   21.867715]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   21.880502]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   21.893255]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   21.906022]       hard-irq read-recursion/123:  ok  |
[   21.910349]       soft-irq read-recursion/123:  ok  |
[   21.914676]       hard-irq read-recursion/132:  ok  |
[   21.918993]       soft-irq read-recursion/132:  ok  |
[   21.923317]       hard-irq read-recursion/213:  ok  |
[   21.927632]       soft-irq read-recursion/213:  ok  |
[   21.931954]       hard-irq read-recursion/231:  ok  |
[   21.936271]       soft-irq read-recursion/231:  ok  |
[   21.940594]       hard-irq read-recursion/312:  ok  |
[   21.944916]       soft-irq read-recursion/312:  ok  |
[   21.949238]       hard-irq read-recursion/321:  ok  |
[   21.953551]       soft-irq read-recursion/321:  ok  |
[   21.957876] -------------------------------------------------------
[   21.957988] Good, all 218 testcases passed! |
[   21.958074] ---------------------------------
[   21.963659] Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
[   21.968279] Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
[   22.071515] Memory: 1024992k available (2920k kernel code, 1344k data, 136k init) [fffff80000000000,000000003ff46000]
[   22.072160] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[   22.156160] Calibrating delay using timer specific routine.. 888.86 BogoMIPS (lpj=1479779)
[   22.157595] Mount-cache hash table entries: 512
[   22.171305] net_namespace: 648 bytes
[   22.173816] NET: Registered protocol family 16
[   22.250788] /pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
[   22.251009] /pci@1f,0: SABRE PCI Bus Module ver[0:0]
[   22.252227] PCI: Scanning PBM /pci@1f,0
[   22.256690] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot
[   22.256815] pci 0000:02:01.0: PME# disabled
[   22.357451] SCSI subsystem initialized
[   22.400547] AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
[   22.404167] /pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Mostek regs at 0x1fff1000000
[   22.425298] NET: Registered protocol family 2
[   22.533868] IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
[   22.539031] TCP established hash table entries: 32768 (order: 6, 524288 bytes)
[   22.542581] TCP bind hash table entries: 32768 (order: 7, 1835008 bytes)
[   22.574770] TCP: Hash tables configured (established 32768 bind 32768)
[   22.575053] TCP reno registered
[   22.614450] NET: Registered protocol family 1
[   22.615982] power: Control reg at 1fff1724000
[   22.635240] Kprobe smoke test started
[   22.759844] Kprobe smoke test passed successfully
[   22.959192] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   22.971385] msgmni has been set to 2003
[   22.974919] io scheduler noop registered
[   22.978475] io scheduler cfq registered (default)
[   22.982618] atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
[   22.984071] atyfb: 4M SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 100 Mhz MCLK, 100 MHz XCLK
[   22.986493] fbcon: ATY Mach64 (fb0) is primary device
[   23.059089] Console: switching to colour frame buffer device 144x56
[   23.083274] atyfb: fb0: ATY Mach64 frame buffer device on PCI
[   23.179801] /pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
[   23.180774] /pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
[   23.186766] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
[   23.196517] eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:f5:ba:1d
[   23.198099] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   23.198415] e100: Copyright(c) 1999-2006 Intel Corporation
[   23.223898] e100 0000:02:01.0: PME# disabled
[   23.231072] e100: eth1: e100_probe: addr 0x1ff00002000, irq 15, MAC addr 00:d0:b7:e4:d6:f1
[   23.232687] netconsole: local port 6665
[   23.232950] netconsole: local IP 192.168.1.5
[   23.233173] netconsole: interface eth1
[   23.233367] netconsole: remote port 6667
[   23.233571] netconsole: remote IP 192.168.1.3
[   23.233801] netconsole: remote ethernet address 00:08:c7:da:88:fb
[   23.234141] netconsole: device eth1 not up yet, forcing it
[   23.279743] e100: eth1: e100_watchdog: link up, 100Mbps, full-duplex
[   23.280283] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[   27.323532] console [netcon0] enabled
[   28.521598] netconsole: network logging started
[   28.532863] Driver 'sd' needs updating - please use bus_type methods
[   28.543959] Driver 'sr' needs updating - please use bus_type methods
[   28.557924] scsi0 : pata_cmd64x
[   28.573880] scsi1 : pata_cmd64x
[   28.584894] ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
[   28.594900] ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
[   28.762973] ata1.00: ATA-5: ST320011A, 3.10, max UDMA/100
[   28.772425] ata1.00: 39102336 sectors, multi 0: LBA 
[   28.789484] ata1.00: configured for MWDMA2
[   28.966201] scsi 0:0:0:0: Direct-Access     ATA      ST320011A        3.10 PQ: 0 ANSI: 5
[   28.981385] sd 0:0:0:0: [sda] 39102336 512-byte hardware sectors: (20.0 GB/18.6 GiB)
[   28.991592] sd 0:0:0:0: [sda] Write Protect is off
[   29.002396] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.014373] sd 0:0:0:0: [sda] 39102336 512-byte hardware sectors: (20.0 GB/18.6 GiB)
[   29.024624] sd 0:0:0:0: [sda] Write Protect is off
[   29.035137] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.045375]  sda: sda1 sda2
[   29.077794] sd 0:0:0:0: [sda] Attached SCSI disk
[   29.091617] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   29.107658] mice: PS/2 mouse device common for all mice
[   29.124328] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[   29.147410] TCP cubic registered
[   29.157979] NET: Registered protocol family 17
[   29.176361] RPC: Registered udp transport module.
[   29.186071] RPC: Registered tcp transport module.
[   29.201571] rtc-m48t59 rtc-m48t59.0: setting system clock to 2008-11-11 03:24:40 UTC (1226373880)
[   29.771270] input: Sun Type 5 keyboard as /class/input/input0
[   29.962863] EXT3-fs: mounted filesystem with ordered data mode.
[   29.973192] VFS: Mounted root (ext3 filesystem) readonly.
[   29.984508] kjournald starting.  Commit interval 5 seconds
[66033.381833] BUG: spinlock lockup on CPU#0, metalog/1322, 00000000007f1430
