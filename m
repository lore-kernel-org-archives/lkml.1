Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbXAWHwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbXAWHwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 02:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbXAWHwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 02:52:11 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4916 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbXAWHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 02:52:08 -0500
Message-ID: <45B5BEA2.30309@xs4all.nl>
Date: Tue, 23 Jan 2007 08:52:02 +0100
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.19.1: BUG: warning: at kernel/lockdep.c:2363/check_flags()
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running a kernel (2.6.19.1) with almost all debugging options turned
on revealed a BUG warning:


klogd 1.4.1, log source = /proc/kmsg started.
Loaded 25823 symbols from /boot/System.map.
Symbols match kernel version 2.6.19.
No module symbols loaded - kernel modules not enabled.

<5>[    0.000000] Linux version 2.6.19.1 (root@skyscraper) (gcc version 4.1.1) #8 PREEMPT Mon Jan 22 20:18:33 CET 2007
<6>[    0.000000] BIOS-provided physical RAM map:
<4>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
<4>[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
<4>[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
<4>[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ffb0000 (usable)
<4>[    0.000000]  BIOS-e820: 000000005ffb0000 - 000000005ffc0000 (ACPI data)
<4>[    0.000000]  BIOS-e820: 000000005ffc0000 - 000000005fff0000 (ACPI NVS)
<4>[    0.000000]  BIOS-e820: 000000005fff0000 - 0000000060000000 (reserved)
<4>[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
<5>[    0.000000] 639MB HIGHMEM available.
<5>[    0.000000] 896MB LOWMEM available.
<7>[    0.000000] Entering add_active_range(0, 0, 393136) 0 entries of 256 used
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA             0 ->     4096
<4>[    0.000000]   Normal       4096 ->   229376
<4>[    0.000000]   HighMem    229376 ->   393136
<4>[    0.000000] early_node_map[1] active PFN ranges
<4>[    0.000000]     0:        0 ->   393136
<7>[    0.000000] On node 0 totalpages: 393136
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1760 pages used for memmap
<7>[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 1279 pages used for memmap
<7>[    0.000000]   HighMem zone: 162481 pages, LIFO batch:31
<6>[    0.000000] DMI 2.3 present.
<7>[    0.000000] ACPI: RSDP (v000 ACPIAM                                ) @ 0x000fa7c0
<7>[    0.000000] ACPI: RSDT (v001 A M I  OEMRSDT  0x11000514 MSFT 0x00000097) @ 0x5ffb0000
<7>[    0.000000] ACPI: FADT (v001 A M I  OEMFACP  0x11000514 MSFT 0x00000097) @ 0x5ffb0200
<7>[    0.000000] ACPI: MADT (v001 A M I  OEMAPIC  0x11000514 MSFT 0x00000097) @ 0x5ffb0390
<7>[    0.000000] ACPI: OEMB (v001 A M I  OEMBIOS  0x11000514 MSFT 0x00000097) @ 0x5ffc0040
<7>[    0.000000] ACPI: DSDT (v001  A0036 A0036001 0x00000001 MSFT 0x0100000d) @ 0x00000000
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x808
<4>[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:9f780000)
<4>[    0.000000] Detected 2403.238 MHz processor.
<4>[   30.773920] Built 1 zonelists.  Total pages: 390065
<5>[   30.773922] Kernel command line: root=/dev/hda2 ro selinux=0 vga=0x31B
<6>[   30.774072] Enabling fast FPU save and restore... done.
<6>[   30.774074] Enabling unmasked SIMD FPU exception support... done.
<6>[   30.774076] Initializing CPU#0
<4>[   30.774200] PID hash table entries: 4096 (order: 12, 16384 bytes)
<4>[   30.774374] Console: colour dummy device 80x25
<4>[   30.774413] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
<4>[   30.774417] ... MAX_LOCKDEP_SUBCLASSES:    8
<4>[   30.774420] ... MAX_LOCK_DEPTH:          30
<4>[   30.774422] ... MAX_LOCKDEP_KEYS:        2048
<4>[   30.774425] ... CLASSHASH_SIZE:           1024
<4>[   30.774427] ... MAX_LOCKDEP_ENTRIES:     8192
<4>[   30.774430] ... MAX_LOCKDEP_CHAINS:      8192
<4>[   30.774432] ... CHAINHASH_SIZE:          4096
<4>[   30.774435]  memory used by lock dependency info: 904 kB
<4>[   30.774437]  per task-struct memory footprint: 1200 bytes
<4>[   30.774440] ------------------------
<4>[   30.774443] | Locking API testsuite:
<4>[   30.774445] ----------------------------------------------------------------------------
<4>[   30.774449]                                  | spin |wlock |rlock |mutex | wsem | rsem |
<4>[   30.774453]   --------------------------------------------------------------------------
<4>[   30.774460]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.775103]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.776067]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.777216]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.778356]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.779745]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.781135]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.782537]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.783171]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.783815]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
<4>[   30.784707]   --------------------------------------------------------------------------
<4>[   30.784711]               recursive read-lock:             |  ok  |             |  ok  |
<4>[   30.784925]            recursive read-lock #2:             |  ok  |             |  ok  |
<4>[   30.785139]             mixed read-write-lock:             |  ok  |             |  ok  |
<4>[   30.785399]             mixed write-read-lock:             |  ok  |             |  ok  |
<4>[   30.785647]   --------------------------------------------------------------------------
<4>[   30.785651]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
<4>[   30.785977]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
<4>[   30.786331]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
<4>[   30.786673]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
<4>[   30.787015]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
<4>[   30.787366]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
<4>[   30.787705]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
<4>[   30.788029]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
<4>[   30.788384]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
<4>[   30.788723]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
<4>[   30.789066]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
<4>[   30.789533]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
<4>[   30.789989]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
<4>[   30.790456]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
<4>[   30.790912]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
<4>[   30.791378]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
<4>[   30.791834]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
<4>[   30.792250]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
<4>[   30.792671]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
<4>[   30.793024]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
<4>[   30.793404]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
<4>[   30.793809]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
<4>[   30.794241]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
<4>[   30.794648]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
<4>[   30.795080]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
<4>[   30.795480]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
<4>[   30.795912]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
<4>[   30.796329]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
<4>[   30.796760]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
<4>[   30.797132]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
<4>[   30.797541]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
<4>[   30.797930]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
<4>[   30.798374]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
<4>[   30.798746]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
<4>[   30.799143]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
<4>[   30.799562]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
<4>[   30.799994]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
<4>[   30.800395]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
<4>[   30.800827]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
<4>[   30.801245]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
<4>[   30.801676]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
<4>[   30.802048]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
<4>[   30.802458]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
<4>[   30.802848]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
<4>[   30.803291]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
<4>[   30.803664]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
<4>[   30.804062]       hard-irq read-recursion/123:  ok  |
<4>[   30.804208]       soft-irq read-recursion/123:  ok  |
<4>[   30.804351]       hard-irq read-recursion/132:  ok  |
<4>[   30.804485]       soft-irq read-recursion/132:  ok  |
<4>[   30.804628]       hard-irq read-recursion/213:  ok  |
<4>[   30.804762]       soft-irq read-recursion/213:  ok  |
<4>[   30.804905]       hard-irq read-recursion/231:  ok  |
<4>[   30.805039]       soft-irq read-recursion/231:  ok  |
<4>[   30.805182]       hard-irq read-recursion/312:  ok  |
<4>[   30.805327]       soft-irq read-recursion/312:  ok  |
<4>[   30.805470]       hard-irq read-recursion/321:  ok  |
<4>[   30.805604]       soft-irq read-recursion/321:  ok  |
<4>[   30.805747] -------------------------------------------------------
<4>[   30.805750] Good, all 218 testcases passed! |
<4>[   30.805753] ---------------------------------
<4>[   30.806223] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<4>[   30.806704] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[   30.870421] Memory: 1550572k/1572544k available (2704k kernel code, 20764k reserved, 947k data, 188k init, 655040k highmem)
<4>[   30.870440] virtual kernel memory layout:
<4>[   30.870441]     fixmap  : 0xfffdd000 - 0xfffff000   ( 136 kB)
<4>[   30.870442]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<4>[   30.870443]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
<4>[   30.870444]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
<4>[   30.870445]       .init : 0xc04e8000 - 0xc0517000   ( 188 kB)
<4>[   30.870446]       .data : 0xc03a42d8 - 0xc0490f54   ( 947 kB)
<4>[   30.870447]       .text : 0xc0100000 - 0xc03a42d8   (2704 kB)
<4>[   30.870458] Checking if this processor honours the WP bit even in supervisor mode... Ok.
<4>[   30.930142] Calibrating delay using timer specific routine.. 4810.45 BogoMIPS (lpj=2405226)
<6>[   30.930342] Security Framework v1.0.0 initialized
<6>[   30.930352] SELinux:  Disabled at boot.
<4>[   30.930437] Mount-cache hash table entries: 512
<7>[   30.931398] subsystem fs: registering
<7>[   30.931401] kobject fs: registering. parent: <NULL>, set: <NULL>
<7>[   30.932588] CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000001
<6>[   30.932596] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>[   30.932600] CPU: L2 Cache: 512K (64 bytes/line)
<7>[   30.932603] CPU: After all inits, caps: 078bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000001
<6>[   30.932609] Intel machine check architecture supported.
<6>[   30.932613] Intel machine check reporting enabled on CPU#0.
<4>[   30.932623] Compat vDSO mapped to ffffe000.
<4>[   30.932634] CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 02
<6>[   30.932641] Checking 'hlt' instruction... OK.
<6>[   30.936279] ACPI: Core revision 20060707
<4>[   30.940662] ACPI: setting ELCR to 0200 (from 0c20)
<6>[   30.942908] checking if image is initramfs... it is
<6>[   30.977180] Freeing initrd memory: 160k freed
<7>[   30.977554] subsystem devices: registering
<7>[   30.977557] kobject devices: registering. parent: <NULL>, set: <NULL>
<7>[   30.977581] subsystem bus: registering
<7>[   30.977582] kobject bus: registering. parent: <NULL>, set: <NULL>
<7>[   30.977598] subsystem class: registering
<7>[   30.977599] kobject class: registering. parent: <NULL>, set: <NULL>
<7>[   30.977615] subsystem firmware: registering
<7>[   30.977617] kobject firmware: registering. parent: <NULL>, set: <NULL>
<7>[   30.977634] kobject platform: registering. parent: <NULL>, set: devices
<7>[   30.977747] kobject_uevent
<7>[   30.977751] subsystem platform: registering
<7>[   30.977753] kobject platform: registering. parent: <NULL>, set: bus
<7>[   30.977769] kobject devices: registering. parent: platform, set: <NULL>
<7>[   30.977784] kobject drivers: registering. parent: platform, set: <NULL>
<7>[   30.977800] subsystem system: registering
<7>[   30.977801] kobject system: registering. parent: devices, set: <NULL>
<7>[   30.977817] kobject cpu: registering. parent: <NULL>, set: system
<7>[   30.978250] subsystem power: registering
<7>[   30.978252] kobject power: registering. parent: <NULL>, set: <NULL>
<7>[   30.978271] subsystem kernel: registering
<7>[   30.978272] kobject kernel: registering. parent: <NULL>, set: <NULL>
<7>[   30.978341] subsystem debug: registering
<7>[   30.978343] kobject debug: registering. parent: <NULL>, set: kernel
<7>[   30.978361] subsystem security: registering
<7>[   30.978363] kobject security: registering. parent: <NULL>, set: kernel
<6>[   30.978696] NET: Registered protocol family 16
<7>[   30.978838] subsystem pci_bus: registering
<7>[   30.978839] kobject pci_bus: registering. parent: <NULL>, set: class
<7>[   30.978858] subsystem pci: registering
<7>[   30.978859] kobject pci: registering. parent: <NULL>, set: bus
<7>[   30.978884] kobject devices: registering. parent: pci, set: <NULL>
<7>[   30.978900] kobject drivers: registering. parent: pci, set: <NULL>
<7>[   30.978919] subsystem tty: registering
<7>[   30.978921] kobject tty: registering. parent: <NULL>, set: class
<7>[   30.978944] subsystem vtconsole: registering
<7>[   30.978946] kobject vtconsole: registering. parent: <NULL>, set: class
<7>[   30.978970] kobject vtcon0: registering. parent: vtconsole, set: class_obj
<7>[   30.978990] kobject_uevent
<7>[   30.979001] fill_kobj_path: path = '/class/vtconsole/vtcon0'
<6>[   30.979676] ACPI: bus type pci registered
<6>[   30.980080] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=1
<6>[   30.980083] PCI: Using configuration type 1
<4>[   30.980086] Setting up standard PCI resources
<7>[   30.987815] kobject cpu0: registering. parent: <NULL>, set: cpu
<7>[   30.987876] kobject_uevent
<7>[   30.987881] fill_kobj_path: path = '/devices/system/cpu/cpu0'
<7>[   30.988102] subsystem module: registering
<7>[   30.988104] kobject module: registering. parent: <NULL>, set: <NULL>
<7>[   30.988183] kobject printk: registering. parent: <NULL>, set: module
<7>[   30.988199] kobject_uevent
<7>[   30.988204] fill_kobj_path: path = '/module/printk'
<7>[   30.988444] kobject rcupdate: registering. parent: <NULL>, set: module
<7>[   30.988460] kobject_uevent
<7>[   30.988465] fill_kobj_path: path = '/module/rcupdate'
<7>[   30.988685] kobject rcupdate: unregistering
<7>[   30.988687] kobject_uevent
<7>[   30.988691] fill_kobj_path: path = '/module/rcupdate'
<7>[   30.989017] kobject rcupdate: cleaning up
<7>[   30.989021] kobject keyboard: registering. parent: <NULL>, set: module
<7>[   30.989032] kobject_uevent
<7>[   30.989037] fill_kobj_path: path = '/module/keyboard'
<7>[   30.989479] kobject amd64_agp: registering. parent: <NULL>, set: module
<7>[   30.989495] kobject_uevent
<7>[   30.989507] fill_kobj_path: path = '/module/amd64_agp'
<7>[   30.989728] kobject amd64_agp: unregistering
<7>[   30.989729] kobject_uevent
<7>[   30.989734] fill_kobj_path: path = '/module/amd64_agp'
<7>[   30.989981] kobject amd64_agp: cleaning up
<7>[   30.989984] kobject cn: registering. parent: <NULL>, set: module
<7>[   30.989995] kobject_uevent
<7>[   30.990000] fill_kobj_path: path = '/module/cn'
<7>[   30.990234] kobject cn: unregistering
<7>[   30.990235] kobject_uevent
<7>[   30.990240] fill_kobj_path: path = '/module/cn'
<7>[   30.990487] kobject cn: cleaning up
<7>[   30.990490] kobject rd: registering. parent: <NULL>, set: module
<7>[   30.990501] kobject_uevent
<7>[   30.990506] fill_kobj_path: path = '/module/rd'
<7>[   30.990734] kobject rd: unregistering
<7>[   30.990736] kobject_uevent
<7>[   30.990740] fill_kobj_path: path = '/module/rd'
<7>[   30.990988] kobject rd: cleaning up
<7>[   30.990991] kobject loop: registering. parent: <NULL>, set: module
<7>[   30.991002] kobject_uevent
<7>[   30.991006] fill_kobj_path: path = '/module/loop'
<7>[   30.992147] kobject loop: unregistering
<7>[   30.992149] kobject_uevent
<7>[   30.992153] fill_kobj_path: path = '/module/loop'
<7>[   30.992376] kobject loop: cleaning up
<7>[   30.992379] kobject sx8: registering. parent: <NULL>, set: module
<7>[   30.992390] kobject_uevent
<7>[   30.992394] fill_kobj_path: path = '/module/sx8'
<7>[   30.992611] kobject generic: registering. parent: <NULL>, set: module
<7>[   30.992627] kobject_uevent
<7>[   30.992632] fill_kobj_path: path = '/module/generic'
<7>[   30.992845] kobject usbcore: registering. parent: <NULL>, set: module
<7>[   30.992861] kobject_uevent
<7>[   30.992866] fill_kobj_path: path = '/module/usbcore'
<7>[   30.993089] kobject libusual: registering. parent: <NULL>, set: module
<7>[   30.994597] kobject_uevent
<7>[   30.994602] fill_kobj_path: path = '/module/libusual'
<7>[   30.994818] kobject i8042: registering. parent: <NULL>, set: module
<7>[   30.994835] kobject_uevent
<7>[   30.994840] fill_kobj_path: path = '/module/i8042'
<7>[   30.995055] kobject atkbd: registering. parent: <NULL>, set: module
<7>[   30.995071] kobject_uevent
<7>[   30.995076] fill_kobj_path: path = '/module/atkbd'
<7>[   30.995284] kobject atkbd: unregistering
<7>[   30.995286] kobject_uevent
<7>[   30.995290] fill_kobj_path: path = '/module/atkbd'
<7>[   30.995513] kobject atkbd: cleaning up
<7>[   30.995517] kobject tcp_cubic: registering. parent: <NULL>, set: module
<7>[   30.995528] kobject_uevent
<7>[   30.995532] fill_kobj_path: path = '/module/tcp_cubic'
<7>[   30.996980] subsystem block: registering
<7>[   30.996982] kobject block: registering. parent: <NULL>, set: <NULL>
<7>[   30.997046] subsystem graphics: registering
<7>[   30.997047] kobject graphics: registering. parent: <NULL>, set: class
<7>[   30.997066] subsystem acpi: registering
<7>[   30.997068] kobject acpi: registering. parent: <NULL>, set: firmware
<6>[   31.016591] ACPI: Interpreter enabled
<6>[   31.016601] ACPI: Using PIC for interrupt routing
<7>[   31.016782] kobject namespace: registering. parent: acpi, set: <NULL>
<7>[   31.016804] subsystem acpi: registering
<7>[   31.016805] kobject acpi: registering. parent: <NULL>, set: bus
<7>[   31.016824] kobject devices: registering. parent: acpi, set: <NULL>
<7>[   31.016841] kobject drivers: registering. parent: acpi, set: <NULL>
<7>[   31.016873] kobject ACPI: registering. parent: <NULL>, set: namespace
<7>[   31.016890] kobject_uevent
<7>[   31.016902] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI'
<7>[   31.017160] kobject acpi: registering. parent: <NULL>, set: devices
<7>[   31.017238] kobject_uevent
<7>[   31.017243] fill_kobj_path: path = '/devices/acpi'
<7>[   31.017494] kobject PWRF: registering. parent: ACPI, set: namespace
<7>[   31.017513] kobject_uevent
<7>[   31.017524] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/PWRF'
<7>[   31.017742] kobject CPU1: registering. parent: ACPI, set: namespace
<7>[   31.017759] kobject_uevent
<7>[   31.017770] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/CPU1'
<7>[   31.017997] kobject CPU2: registering. parent: ACPI, set: namespace
<7>[   31.018015] kobject_uevent
<7>[   31.018025] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/CPU2'
<7>[   31.018277] kobject _SB: registering. parent: ACPI, set: namespace
<7>[   31.018295] kobject_uevent
<7>[   31.018306] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB'
<7>[   31.020620] kobject PCI0: registering. parent: _SB, set: namespace
<7>[   31.020638] kobject_uevent
<7>[   31.020650] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0'
<6>[   31.020872] ACPI: PCI Root Bridge [PCI0] (0000:00)
<7>[   31.020925] PCI: Probing PCI hardware (bus 00)
<7>[   31.020968] kobject pci0000:00: registering. parent: <NULL>, set: devices
<7>[   31.037130] kobject_uevent
<7>[   31.037135] kobject 0000:00: registering. parent: pci_bus, set: class_obj
<7>[   31.037159] kobject_uevent
<7>[   31.037164] fill_kobj_path: path = '/class/pci_bus/0000:00'
<6>[   31.038890] PCI: enabled onboard AC97/MC97 devices
<7>[   31.039418] kobject 0000:01: registering. parent: pci_bus, set: class_obj
<7>[   31.039439] kobject_uevent
<7>[   31.039449] fill_kobj_path: path = '/class/pci_bus/0000:01'
<7>[   31.039780] Boot video device is 0000:01:00.0
<7>[   31.039867] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[   31.040663] kobject 0000:00:00.0: registering. parent: pci0000:00, set: devices
<7>[   31.042449] kobject_uevent
<7>[   31.042455] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.0'
<7>[   31.042681] kobject 0000:00:00.1: registering. parent: pci0000:00, set: devices
<7>[   31.044477] kobject_uevent
<7>[   31.044482] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.1'
<7>[   31.044705] kobject 0000:00:00.2: registering. parent: pci0000:00, set: devices
<7>[   31.046492] kobject_uevent
<7>[   31.046497] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.2'
<7>[   31.046719] kobject 0000:00:00.3: registering. parent: pci0000:00, set: devices
<7>[   31.048505] kobject_uevent
<7>[   31.048510] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.3'
<7>[   31.048733] kobject 0000:00:00.4: registering. parent: pci0000:00, set: devices
<7>[   31.050522] kobject_uevent
<7>[   31.050527] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.4'
<7>[   31.050749] kobject 0000:00:00.7: registering. parent: pci0000:00, set: devices
<7>[   31.052559] kobject_uevent
<7>[   31.052564] fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.7'
<7>[   31.052787] kobject 0000:00:01.0: registering. parent: pci0000:00, set: devices
<7>[   31.054579] kobject_uevent
<7>[   31.054584] fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0'
<7>[   31.054806] kobject 0000:00:07.0: registering. parent: pci0000:00, set: devices
<7>[   31.056595] kobject_uevent
<7>[   31.056600] fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
<7>[   31.056823] kobject 0000:00:09.0: registering. parent: pci0000:00, set: devices
<7>[   31.058644] kobject_uevent
<7>[   31.058649] fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
<7>[   31.058872] kobject 0000:00:0a.0: registering. parent: pci0000:00, set: devices
<7>[   31.060655] kobject_uevent
<7>[   31.060660] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0a.0'
<7>[   31.060883] kobject 0000:00:0d.0: registering. parent: pci0000:00, set: devices
<7>[   31.062657] kobject_uevent
<7>[   31.062662] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
<7>[   31.062884] kobject 0000:00:0d.1: registering. parent: pci0000:00, set: devices
<7>[   31.064658] kobject_uevent
<7>[   31.064663] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.1'
<7>[   31.064886] kobject 0000:00:0e.0: registering. parent: pci0000:00, set: devices
<7>[   31.066673] kobject_uevent
<7>[   31.066678] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0e.0'
<7>[   31.066901] kobject 0000:00:0e.1: registering. parent: pci0000:00, set: devices
<7>[   31.068688] kobject_uevent
<7>[   31.068693] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0e.1'
<7>[   31.068916] kobject 0000:00:0f.0: registering. parent: pci0000:00, set: devices
<7>[   31.070660] kobject_uevent
<7>[   31.070665] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.0'
<7>[   31.070888] kobject 0000:00:0f.1: registering. parent: pci0000:00, set: devices
<7>[   31.072673] kobject_uevent
<7>[   31.072678] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1'
<7>[   31.072901] kobject 0000:00:10.0: registering. parent: pci0000:00, set: devices
<7>[   31.074686] kobject_uevent
<7>[   31.074691] fill_kobj_path: path = '/devices/pci0000:00/0000:00:10.0'
<7>[   31.074914] kobject 0000:00:10.1: registering. parent: pci0000:00, set: devices
<7>[   31.076694] kobject_uevent
<7>[   31.076699] fill_kobj_path: path = '/devices/pci0000:00/0000:00:10.1'
<7>[   31.076922] kobject 0000:00:10.2: registering. parent: pci0000:00, set: devices
<7>[   31.078700] kobject_uevent
<7>[   31.078705] fill_kobj_path: path = '/devices/pci0000:00/0000:00:10.2'
<7>[   31.078928] kobject 0000:00:10.3: registering. parent: pci0000:00, set: devices
<7>[   31.080725] kobject_uevent
<7>[   31.080730] fill_kobj_path: path = '/devices/pci0000:00/0000:00:10.3'
<7>[   31.080953] kobject 0000:00:10.4: registering. parent: pci0000:00, set: devices
<7>[   31.082731] kobject_uevent
<7>[   31.082736] fill_kobj_path: path = '/devices/pci0000:00/0000:00:10.4'
<7>[   31.082959] kobject 0000:00:11.0: registering. parent: pci0000:00, set: devices
<7>[   31.084739] kobject_uevent
<7>[   31.084744] fill_kobj_path: path = '/devices/pci0000:00/0000:00:11.0'
<7>[   31.084967] kobject 0000:00:11.5: registering. parent: pci0000:00, set: devices
<7>[   31.086750] kobject_uevent
<7>[   31.086755] fill_kobj_path: path = '/devices/pci0000:00/0000:00:11.5'
<7>[   31.086978] kobject 0000:00:11.6: registering. parent: pci0000:00, set: devices
<7>[   31.088773] kobject_uevent
<7>[   31.088778] fill_kobj_path: path = '/devices/pci0000:00/0000:00:11.6'
<7>[   31.089001] kobject 0000:00:18.0: registering. parent: pci0000:00, set: devices
<7>[   31.090789] kobject_uevent
<7>[   31.090794] fill_kobj_path: path = '/devices/pci0000:00/0000:00:18.0'
<7>[   31.091016] kobject 0000:00:18.1: registering. parent: pci0000:00, set: devices
<7>[   31.092807] kobject_uevent
<7>[   31.092813] fill_kobj_path: path = '/devices/pci0000:00/0000:00:18.1'
<7>[   31.093035] kobject 0000:00:18.2: registering. parent: pci0000:00, set: devices
<7>[   31.094838] kobject_uevent
<7>[   31.094843] fill_kobj_path: path = '/devices/pci0000:00/0000:00:18.2'
<7>[   31.095078] kobject 0000:00:18.3: registering. parent: pci0000:00, set: devices
<7>[   31.096864] kobject_uevent
<7>[   31.096869] fill_kobj_path: path = '/devices/pci0000:00/0000:00:18.3'
<7>[   31.097105] kobject 0000:01:00.0: registering. parent: 0000:00:01.0, set: devices
<7>[   31.097157] kobject_uevent
<7>[   31.097162] fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:00.0'
<7>[   31.097417] kobject VIAN: registering. parent: PCI0, set: namespace
<7>[   31.097434] kobject_uevent
<7>[   31.097446] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/VIAN'
<7>[   31.097711] kobject NBF1: registering. parent: PCI0, set: namespace
<7>[   31.097728] kobject_uevent
<7>[   31.097739] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/NBF1'
<7>[   31.098006] kobject NBF2: registering. parent: PCI0, set: namespace
<7>[   31.098023] kobject_uevent
<7>[   31.098034] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/NBF2'
<7>[   31.098478] kobject NBF3: registering. parent: PCI0, set: namespace
<7>[   31.098495] kobject_uevent
<7>[   31.098506] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/NBF3'
<7>[   31.098766] kobject NBF4: registering. parent: PCI0, set: namespace
<7>[   31.098783] kobject_uevent
<7>[   31.098794] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/NBF4'
<7>[   31.099056] kobject NBF7: registering. parent: PCI0, set: namespace
<7>[   31.099087] kobject_uevent
<7>[   31.099097] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/NBF7'
<7>[   31.099359] kobject P0P1: registering. parent: PCI0, set: namespace
<7>[   31.099376] kobject_uevent
<7>[   31.099388] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/P0P1'
<7>[   31.099654] kobject SBRG: registering. parent: PCI0, set: namespace
<7>[   31.099671] kobject_uevent
<7>[   31.099682] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG'
<7>[   31.099943] kobject PIC: registering. parent: SBRG, set: namespace
<7>[   31.099960] kobject_uevent
<7>[   31.099971] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/PIC'
<7>[   31.100968] kobject DMAD: registering. parent: SBRG, set: namespace
<7>[   31.100986] kobject_uevent
<7>[   31.101000] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/DMAD'
<7>[   31.101245] kobject TMR: registering. parent: SBRG, set: namespace
<7>[   31.101262] kobject_uevent
<7>[   31.101273] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/TMR'
<7>[   31.101512] kobject RTC0: registering. parent: SBRG, set: namespace
<7>[   31.101537] kobject_uevent
<7>[   31.101548] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/RTC0'
<7>[   31.103427] kobject PS2K: registering. parent: SBRG, set: namespace
<7>[   31.103445] kobject_uevent
<7>[   31.103457] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/PS2K'
<7>[   31.103848] kobject SPKR: registering. parent: SBRG, set: namespace
<7>[   31.103866] kobject_uevent
<7>[   31.103877] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/SPKR'
<7>[   31.104125] kobject COPR: registering. parent: SBRG, set: namespace
<7>[   31.104142] kobject_uevent
<7>[   31.104153] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/COPR'
<7>[   31.106702] kobject FDC: registering. parent: SBRG, set: namespace
<7>[   31.106720] kobject_uevent
<7>[   31.106731] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/FDC'
<7>[   31.109840] kobject LPTE: registering. parent: SBRG, set: namespace
<7>[   31.109859] kobject_uevent
<7>[   31.109870] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/LPTE'
<7>[   31.110221] kobject SIOR: registering. parent: SBRG, set: namespace
<7>[   31.110247] kobject_uevent
<7>[   31.110259] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/SIOR'
<7>[   31.110497] kobject RMSC: registering. parent: SBRG, set: namespace
<7>[   31.110515] kobject_uevent
<7>[   31.110526] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/RMSC'
<7>[   31.110757] kobject OMSC: registering. parent: SBRG, set: namespace
<7>[   31.110774] kobject_uevent
<7>[   31.110785] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/OMSC'
<7>[   31.113880] kobject UAR2: registering. parent: SBRG, set: namespace
<7>[   31.113899] kobject_uevent
<7>[   31.113910] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/UAR2'
<7>[   31.116964] kobject UAR1: registering. parent: SBRG, set: namespace
<7>[   31.116982] kobject_uevent
<7>[   31.116993] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/SBRG/UAR1'
<7>[   31.119516] kobject AC97: registering. parent: PCI0, set: namespace
<7>[   31.119535] kobject_uevent
<7>[   31.119550] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/AC97'
<7>[   31.119808] kobject MC97: registering. parent: PCI0, set: namespace
<7>[   31.119826] kobject_uevent
<7>[   31.119837] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/MC97'
<7>[   31.120108] kobject IDEC: registering. parent: PCI0, set: namespace
<7>[   31.120126] kobject_uevent
<7>[   31.120137] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC'
<7>[   31.120398] kobject CHN0: registering. parent: IDEC, set: namespace
<7>[   31.120415] kobject_uevent
<7>[   31.120426] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN0'
<7>[   31.120656] kobject DRV0: registering. parent: CHN0, set: namespace
<7>[   31.120673] kobject_uevent
<7>[   31.120684] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN0/DRV0'
<7>[   31.120916] kobject DRV1: registering. parent: CHN0, set: namespace
<7>[   31.120932] kobject_uevent
<7>[   31.120944] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN0/DRV1'
<7>[   31.121429] kobject CHN1: registering. parent: IDEC, set: namespace
<7>[   31.121446] kobject_uevent
<7>[   31.121457] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN1'
<7>[   31.121687] kobject DRV0: registering. parent: CHN1, set: namespace
<7>[   31.121704] kobject_uevent
<7>[   31.121715] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN1/DRV0'
<7>[   31.121946] kobject DRV1: registering. parent: CHN1, set: namespace
<7>[   31.121963] kobject_uevent
<7>[   31.121974] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/IDEC/CHN1/DRV1'
<7>[   31.122903] kobject USB1: registering. parent: PCI0, set: namespace
<7>[   31.122921] kobject_uevent
<7>[   31.122933] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/USB1'
<7>[   31.124425] kobject USB2: registering. parent: PCI0, set: namespace
<7>[   31.124444] kobject_uevent
<7>[   31.124455] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/USB2'
<7>[   31.126310] kobject USB3: registering. parent: PCI0, set: namespace
<7>[   31.126330] kobject_uevent
<7>[   31.126341] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/USB3'
<7>[   31.127291] kobject USB4: registering. parent: PCI0, set: namespace
<7>[   31.127310] kobject_uevent
<7>[   31.127321] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/USB4'
<7>[   31.127999] kobject EHCI: registering. parent: PCI0, set: namespace
<7>[   31.128018] kobject_uevent
<7>[   31.128029] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PCI0/EHCI'
<7>[   31.128619] kobject RMEM: registering. parent: _SB, set: namespace
<7>[   31.128637] kobject_uevent
<7>[   31.128648] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/RMEM'
<7>[   31.129317] kobject PWRB: registering. parent: _SB, set: namespace
<7>[   31.129335] kobject_uevent
<7>[   31.129351] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/PWRB'
<7>[   31.129840] kobject LNKA: registering. parent: _SB, set: namespace
<7>[   31.129859] kobject_uevent
<7>[   31.129870] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKA'
<4>[   31.130754] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
<7>[   31.131229] kobject LNKB: registering. parent: _SB, set: namespace
<7>[   31.131248] kobject_uevent
<7>[   31.131259] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKB'
<4>[   31.131785] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
<7>[   31.132830] kobject LNKC: registering. parent: _SB, set: namespace
<7>[   31.132848] kobject_uevent
<7>[   31.132859] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKC'
<4>[   31.133397] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
<7>[   31.133800] kobject LNKD: registering. parent: _SB, set: namespace
<7>[   31.133818] kobject_uevent
<7>[   31.133829] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKD'
<4>[   31.134689] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 14 15)
<7>[   31.135107] kobject LNKE: registering. parent: _SB, set: namespace
<7>[   31.135126] kobject_uevent
<7>[   31.135137] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKE'
<4>[   31.135662] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
<7>[   31.136084] kobject LNKF: registering. parent: _SB, set: namespace
<7>[   31.136102] kobject_uevent
<7>[   31.136113] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKF'
<4>[   31.136638] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
<7>[   31.137430] kobject LNKG: registering. parent: _SB, set: namespace
<7>[   31.137448] kobject_uevent
<7>[   31.137460] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKG'
<4>[   31.137985] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
<7>[   31.138406] kobject LNKH: registering. parent: _SB, set: namespace
<7>[   31.138424] kobject_uevent
<7>[   31.138435] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/LNKH'
<4>[   31.138960] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
<7>[   31.139542] kobject SLPB: registering. parent: _SB, set: namespace
<7>[   31.139560] kobject_uevent
<7>[   31.139572] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_SB/SLPB'
<7>[   31.139793] kobject _TZ: registering. parent: ACPI, set: namespace
<7>[   31.139812] kobject_uevent
<7>[   31.139824] fill_kobj_path: path = '/firmware/acpi/namespace/ACPI/_TZ'
<6>[   31.140054] Linux Plug and Play Support v0.97 (c) Adam Belay
<7>[   31.140059] subsystem pnp: registering
<7>[   31.140061] kobject pnp: registering. parent: <NULL>, set: bus
<7>[   31.140080] kobject devices: registering. parent: pnp, set: <NULL>
<7>[   31.140097] kobject drivers: registering. parent: pnp, set: <NULL>
<6>[   31.140114] pnp: PnP ACPI init
<7>[   31.140152] kobject pnp0: registering. parent: <NULL>, set: devices
<7>[   31.140188] kobject_uevent
<7>[   31.140473] kobject 00:00: registering. parent: pnp0, set: devices
<7>[   31.140513] kobject_uevent
<7>[   31.140524] fill_kobj_path: path = '/devices/pnp0/00:00'
<7>[   31.140800] kobject 00:01: registering. parent: pnp0, set: devices
<7>[   31.140843] kobject_uevent
<7>[   31.140855] fill_kobj_path: path = '/devices/pnp0/00:01'
<7>[   31.141318] kobject 00:02: registering. parent: pnp0, set: devices
<7>[   31.141357] kobject_uevent
<7>[   31.141367] fill_kobj_path: path = '/devices/pnp0/00:02'
<7>[   31.141759] kobject 00:03: registering. parent: pnp0, set: devices
<7>[   31.141806] kobject_uevent
<7>[   31.141817] fill_kobj_path: path = '/devices/pnp0/00:03'
<7>[   31.142209] kobject 00:04: registering. parent: pnp0, set: devices
<7>[   31.142249] kobject_uevent
<7>[   31.142260] fill_kobj_path: path = '/devices/pnp0/00:04'
<7>[   31.142510] kobject 00:05: registering. parent: pnp0, set: devices
<7>[   31.142558] kobject_uevent
<7>[   31.142569] fill_kobj_path: path = '/devices/pnp0/00:05'
<7>[   31.145487] kobject 00:06: registering. parent: pnp0, set: devices
<7>[   31.145527] kobject_uevent
<7>[   31.145538] fill_kobj_path: path = '/devices/pnp0/00:06'
<7>[   31.149438] kobject 00:07: registering. parent: pnp0, set: devices
<7>[   31.149477] kobject_uevent
<7>[   31.149489] fill_kobj_path: path = '/devices/pnp0/00:07'
<7>[   31.149994] kobject 00:08: registering. parent: pnp0, set: devices
<7>[   31.150033] kobject_uevent
<7>[   31.150057] fill_kobj_path: path = '/devices/pnp0/00:08'
<7>[   31.150627] kobject 00:09: registering. parent: pnp0, set: devices
<7>[   31.150677] kobject_uevent
<7>[   31.150687] fill_kobj_path: path = '/devices/pnp0/00:09'
<7>[   31.151401] kobject 00:0a: registering. parent: pnp0, set: devices
<7>[   31.151444] kobject_uevent
<7>[   31.151455] fill_kobj_path: path = '/devices/pnp0/00:0a'
<7>[   31.154169] kobject 00:0b: registering. parent: pnp0, set: devices
<7>[   31.154210] kobject_uevent
<7>[   31.154221] fill_kobj_path: path = '/devices/pnp0/00:0b'
<7>[   31.156466] kobject 00:0c: registering. parent: pnp0, set: devices
<7>[   31.156506] kobject_uevent
<7>[   31.156517] fill_kobj_path: path = '/devices/pnp0/00:0c'
<7>[   31.159060] kobject 00:0d: registering. parent: pnp0, set: devices
<7>[   31.159100] kobject_uevent
<7>[   31.159111] fill_kobj_path: path = '/devices/pnp0/00:0d'
<6>[   31.160327] pnp: PnP ACPI: found 14 devices
<7>[   31.160339] subsystem misc: registering
<7>[   31.160341] kobject misc: registering. parent: <NULL>, set: class
<7>[   31.160508] subsystem spi: registering
<7>[   31.160509] kobject spi: registering. parent: <NULL>, set: bus
<7>[   31.160528] kobject devices: registering. parent: spi, set: <NULL>
<7>[   31.160545] kobject drivers: registering. parent: spi, set: <NULL>
<7>[   31.160569] subsystem spi_master: registering
<7>[   31.160571] kobject spi_master: registering. parent: <NULL>, set: class
<7>[   31.160639] subsystem usb: registering
<7>[   31.160641] kobject usb: registering. parent: <NULL>, set: bus
<7>[   31.160658] kobject devices: registering. parent: usb, set: <NULL>
<7>[   31.160673] kobject drivers: registering. parent: usb, set: <NULL>
<7>[   31.160692] subsystem usb_host: registering
<7>[   31.160693] kobject usb_host: registering. parent: <NULL>, set: class
<7>[   31.160717] kobject usbfs: registering. parent: <NULL>, set: drivers
<7>[   31.160733] kobject_uevent
<7>[   31.160738] fill_kobj_path: path = '/bus/usb/drivers/usbfs'
<6>[   31.160952] usbcore: registered new interface driver usbfs
<7>[   31.160962] subsystem usb_device: registering
<7>[   31.160963] kobject usb_device: registering. parent: <NULL>, set: class
<7>[   31.160993] kobject hub: registering. parent: <NULL>, set: drivers
<7>[   31.161009] kobject_uevent
<7>[   31.161014] fill_kobj_path: path = '/bus/usb/drivers/hub'
<6>[   31.161401] usbcore: registered new interface driver hub
<7>[   31.161459] kobject usb: registering. parent: <NULL>, set: drivers
<7>[   31.161476] kobject_uevent
<7>[   31.161489] fill_kobj_path: path = '/bus/usb/drivers/usb'
<6>[   31.161698] usbcore: registered new device driver usb
<7>[   31.161702] subsystem serio: registering
<7>[   31.161704] kobject serio: registering. parent: <NULL>, set: bus
<7>[   31.161722] kobject devices: registering. parent: serio, set: <NULL>
<7>[   31.161738] kobject drivers: registering. parent: serio, set: <NULL>
<7>[   31.161863] subsystem input: registering
<7>[   31.161865] kobject input: registering. parent: <NULL>, set: class
<7>[   31.161891] subsystem i2c: registering
<7>[   31.161892] kobject i2c: registering. parent: <NULL>, set: bus
<7>[   31.161910] kobject devices: registering. parent: i2c, set: <NULL>
<7>[   31.161926] kobject drivers: registering. parent: i2c, set: <NULL>
<7>[   31.161943] kobject i2c_adapter: registering. parent: <NULL>, set: drivers
<7>[   31.161958] kobject_uevent
<7>[   31.161963] fill_kobj_path: path = '/bus/i2c/drivers/i2c_adapter'
<7>[   31.162175] subsystem i2c-adapter: registering
<7>[   31.162177] kobject i2c-adapter: registering. parent: <NULL>, set: class
<7>[   31.162196] subsystem dma: registering
<7>[   31.162197] kobject dma: registering. parent: <NULL>, set: class
<6>[   31.162222] PCI: Using ACPI for IRQ routing
<6>[   31.162227] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<7>[   31.167934] subsystem net: registering
<7>[   31.167936] kobject net: registering. parent: <NULL>, set: class
<6>[   31.168111] NetLabel: Initializing
<6>[   31.168115] NetLabel:  domain hash size = 128
<6>[   31.168117] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[   31.168348] NetLabel:  unlabeled traffic allowed by default
<7>[   31.169827] kobject system: registering. parent: <NULL>, set: drivers
<7>[   31.169848] kobject_uevent
<7>[   31.169853] fill_kobj_path: path = '/bus/pnp/drivers/system'
<6>[   31.170078] pnp: 00:08: ioport range 0x680-0x6ff has been reserved
<6>[   31.170083] pnp: 00:08: ioport range 0x290-0x297 has been reserved
<7>[   31.170143] subsystem mem: registering
<7>[   31.170145] kobject mem: registering. parent: <NULL>, set: class
<7>[   31.170175] kobject mem: registering. parent: mem, set: class_obj
<7>[   31.170196] kobject_uevent
<7>[   31.170200] fill_kobj_path: path = '/class/mem/mem'
<7>[   31.170413] kobject kmem: registering. parent: mem, set: class_obj
<7>[   31.170435] kobject_uevent
<7>[   31.170439] fill_kobj_path: path = '/class/mem/kmem'
<7>[   31.170665] kobject null: registering. parent: mem, set: class_obj
<7>[   31.170686] kobject_uevent
<7>[   31.170691] fill_kobj_path: path = '/class/mem/null'
<7>[   31.170916] kobject port: registering. parent: mem, set: class_obj
<7>[   31.170937] kobject_uevent
<7>[   31.170942] fill_kobj_path: path = '/class/mem/port'
<7>[   31.171719] kobject zero: registering. parent: mem, set: class_obj
<7>[   31.171741] kobject_uevent
<7>[   31.171745] fill_kobj_path: path = '/class/mem/zero'
<7>[   31.171956] kobject full: registering. parent: mem, set: class_obj
<7>[   31.171987] kobject_uevent
<7>[   31.171991] fill_kobj_path: path = '/class/mem/full'
<7>[   31.172217] kobject random: registering. parent: mem, set: class_obj
<7>[   31.172238] kobject_uevent
<7>[   31.172243] fill_kobj_path: path = '/class/mem/random'
<7>[   31.172467] kobject urandom: registering. parent: mem, set: class_obj
<7>[   31.172488] kobject_uevent
<7>[   31.172492] fill_kobj_path: path = '/class/mem/urandom'
<7>[   31.172723] kobject kmsg: registering. parent: mem, set: class_obj
<7>[   31.172744] kobject_uevent
<7>[   31.172749] fill_kobj_path: path = '/class/mem/kmsg'
<6>[   31.173006] PCI: Bridge: 0000:00:01.0
<6>[   31.173009]   IO window: disabled.
<6>[   31.173016]   MEM window: f9f00000-fbffffff
<6>[   31.173021]   PREFETCH window: e0000000-f8ffffff
<7>[   31.173522] PCI: Setting latency timer of device 0000:00:01.0 to 64
<6>[   31.173591] NET: Registered protocol family 2
<4>[   31.183356] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<4>[   31.183919] TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
<4>[   31.188520] TCP bind hash table entries: 32768 (order: 8, 1441792 bytes)
<6>[   31.190801] TCP: Hash tables configured (established 65536 bind 32768)
<6>[   31.190877] TCP reno registered
<7>[   31.190958] kobject timer: registering. parent: <NULL>, set: system
<7>[   31.190997] kobject timer0: registering. parent: <NULL>, set: timer
<7>[   31.191014] kobject_uevent
<7>[   31.191041] fill_kobj_path: path = '/devices/system/timer/timer0'
<7>[   31.191332] kobject pcspkr: registering. parent: platform, set: devices
<7>[   31.191392] kobject_uevent
<7>[   31.191396] fill_kobj_path: path = '/devices/platform/pcspkr'
<7>[   31.191601] kobject i8259: registering. parent: <NULL>, set: system
<7>[   31.191619] kobject i82590: registering. parent: <NULL>, set: i8259
<7>[   31.191637] kobject_uevent
<7>[   31.191642] fill_kobj_path: path = '/devices/system/i8259/i82590'
<7>[   31.191840] kobject i8237: registering. parent: <NULL>, set: system
<7>[   31.191859] kobject i82370: registering. parent: <NULL>, set: i8237
<7>[   31.191875] kobject_uevent
<7>[   31.191880] fill_kobj_path: path = '/devices/system/i8237/i82370'
<7>[   31.192101] kobject cache: registering. parent: cpu0, set: <NULL>
<7>[   31.192124] kobject_uevent
<7>[   31.192138] fill_kobj_path: path = '/devices/system/cpu/cpu0/cache'
<7>[   31.192354] kobject index0: registering. parent: cache, set: <NULL>
<7>[   31.192378] kobject_uevent
<7>[   31.192383] fill_kobj_path: path = '/devices/system/cpu/cpu0/cache/index0'
<7>[   31.192583] kobject index1: registering. parent: cache, set: <NULL>
<7>[   31.192607] kobject_uevent
<7>[   31.192612] fill_kobj_path: path = '/devices/system/cpu/cpu0/cache/index1'
<7>[   31.192814] kobject index2: registering. parent: cache, set: <NULL>
<7>[   31.192839] kobject_uevent
<7>[   31.192844] fill_kobj_path: path = '/devices/system/cpu/cpu0/cache/index2'
<7>[   31.193062] kobject timekeeping: registering. parent: <NULL>, set: system
<7>[   31.193081] kobject timekeeping0: registering. parent: <NULL>, set: timekeeping
<7>[   31.193097] kobject_uevent
<7>[   31.193102] fill_kobj_path: path = '/devices/system/timekeeping/timekeeping0'
<7>[   31.193391] kobject clocksource: registering. parent: <NULL>, set: system
<7>[   31.193409] kobject clocksource0: registering. parent: <NULL>, set: clocksource
<7>[   31.193425] kobject_uevent
<7>[   31.193431] fill_kobj_path: path = '/devices/system/clocksource/clocksource0'
<7>[   31.193870] kobject rttest: registering. parent: <NULL>, set: system
<7>[   31.193943] kobject rttest0: registering. parent: <NULL>, set: rttest
<7>[   31.193960] kobject_uevent
<7>[   31.193965] fill_kobj_path: path = '/devices/system/rttest/rttest0'
<7>[   31.194728] kobject rttest1: registering. parent: <NULL>, set: rttest
<7>[   31.194746] kobject_uevent
<7>[   31.194751] fill_kobj_path: path = '/devices/system/rttest/rttest1'
<7>[   31.195001] kobject rttest2: registering. parent: <NULL>, set: rttest
<7>[   31.195032] kobject_uevent
<7>[   31.195037] fill_kobj_path: path = '/devices/system/rttest/rttest2'
<7>[   31.195307] kobject rttest3: registering. parent: <NULL>, set: rttest
<7>[   31.195324] kobject_uevent
<7>[   31.195329] fill_kobj_path: path = '/devices/system/rttest/rttest3'
<7>[   31.195599] kobject rttest4: registering. parent: <NULL>, set: rttest
<7>[   31.195616] kobject_uevent
<7>[   31.195621] fill_kobj_path: path = '/devices/system/rttest/rttest4'
<7>[   31.195890] kobject rttest5: registering. parent: <NULL>, set: rttest
<7>[   31.195907] kobject_uevent
<7>[   31.195913] fill_kobj_path: path = '/devices/system/rttest/rttest5'
<7>[   31.197596] kobject rttest6: registering. parent: <NULL>, set: rttest
<7>[   31.197614] kobject_uevent
<7>[   31.197619] fill_kobj_path: path = '/devices/system/rttest/rttest6'
<7>[   31.197848] kobject rttest7: registering. parent: <NULL>, set: rttest
<7>[   31.197866] kobject_uevent
<7>[   31.197871] fill_kobj_path: path = '/devices/system/rttest/rttest7'
<4>[   31.198086] Initializing RT-Tester: OK
<6>[   31.198098] audit: initializing netlink socket (disabled)
<5>[   31.198168] audit(1169495033.719:1): initialized
<4>[   31.198426] highmem bounce pool size: 64 pages
<5>[   31.199967] VFS: Disk quotas dquot_6.5.1
<4>[   31.200007] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
<6>[   31.200511] SGI XFS with ACLs, security attributes, no debug enabled
<6>[   31.200864] SGI XFS Quota Management subsystem
<6>[   31.201371] io scheduler noop registered
<6>[   31.201376] io scheduler anticipatory registered (default)
<6>[   31.201380] io scheduler deadline registered
<6>[   31.201415] io scheduler cfq registered
<7>[   31.224285] kobject fbcon: registering. parent: graphics, set: class_obj
<7>[   31.224312] kobject_uevent
<7>[   31.224318] fill_kobj_path: path = '/class/graphics/fbcon'
<7>[   31.224562] kobject vesafb: registering. parent: <NULL>, set: drivers
<7>[   31.224590] kobject_uevent
<7>[   31.224596] fill_kobj_path: path = '/bus/platform/drivers/vesafb'
<7>[   31.224814] kobject vesafb.0: registering. parent: platform, set: devices
<7>[   31.224869] kobject_uevent
<7>[   31.224874] fill_kobj_path: path = '/devices/platform/vesafb.0'
<6>[   31.225122] vesafb: framebuffer at 0xe0000000, mapped to 0xf8880000, using 10240k, total 131072k
<6>[   31.225128] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
<6>[   31.225132] vesafb: protected mode interface info at c000:d510
<6>[   31.225135] vesafb: pmi: set display start = c00cd546, set palette = c00cd5b0
<6>[   31.225138] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
<6>[   31.225155] vesafb: scrolling: redraw
<6>[   31.225158] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
<7>[   31.225185] kobject fb0: registering. parent: graphics, set: class_obj
<7>[   31.225216] kobject_uevent
<7>[   31.225227] fill_kobj_path: path = '/class/graphics/fb0'
<7>[   31.225230] fill_kobj_path: path = '/devices/platform/vesafb.0'
<7>[   31.225937] kobject vtcon1: registering. parent: vtconsole, set: class_obj
<7>[   31.226081] kobject_uevent
<7>[   31.226085] fill_kobj_path: path = '/class/vtconsole/vtcon1'
<4>[   31.348871] Console: switching to colour frame buffer device 160x64
<6>[   31.460992] fb0: VESA VGA frame buffer device
<7>[   31.461581] kobject irqrouter: registering. parent: <NULL>, set: system
<7>[   31.461605] kobject irqrouter0: registering. parent: <NULL>, set: irqrouter
<7>[   31.461623] kobject_uevent
<7>[   31.461628] fill_kobj_path: path = '/devices/system/irqrouter/irqrouter0'
<7>[   31.461860] kobject tty: registering. parent: tty, set: class_obj
<7>[   31.461884] kobject_uevent
<7>[   31.461889] fill_kobj_path: path = '/class/tty/tty'
<7>[   31.462118] kobject console: registering. parent: tty, set: class_obj
<7>[   31.462140] kobject_uevent
<7>[   31.462152] fill_kobj_path: path = '/class/tty/console'
<7>[   31.462366] kobject ptmx: registering. parent: tty, set: class_obj
<7>[   31.462389] kobject_uevent
<7>[   31.462394] fill_kobj_path: path = '/class/tty/ptmx'
<7>[   31.462608] kobject tty0: registering. parent: tty, set: class_obj
<7>[   31.462631] kobject_uevent
<7>[   31.462636] fill_kobj_path: path = '/class/tty/tty0'
<7>[   31.462848] subsystem vc: registering
<7>[   31.462850] kobject vc: registering. parent: <NULL>, set: class
<7>[   31.462879] kobject vcs: registering. parent: vc, set: class_obj
<7>[   31.462913] kobject_uevent
<7>[   31.462918] fill_kobj_path: path = '/class/vc/vcs'
<7>[   31.463156] kobject vcsa: registering. parent: vc, set: class_obj
<7>[   31.463179] kobject_uevent
<7>[   31.463183] fill_kobj_path: path = '/class/vc/vcsa'
<7>[   31.463443] kobject tty1: registering. parent: tty, set: class_obj
<7>[   31.463466] kobject_uevent
<7>[   31.463471] fill_kobj_path: path = '/class/tty/tty1'
<7>[   31.463734] kobject tty2: registering. parent: tty, set: class_obj
<7>[   31.463765] kobject_uevent
<7>[   31.463770] fill_kobj_path: path = '/class/tty/tty2'
<7>[   31.464219] kobject tty3: registering. parent: tty, set: class_obj
<7>[   31.464242] kobject_uevent
<7>[   31.464246] fill_kobj_path: path = '/class/tty/tty3'
<7>[   31.464494] kobject tty4: registering. parent: tty, set: class_obj
<7>[   31.464516] kobject_uevent
<7>[   31.464521] fill_kobj_path: path = '/class/tty/tty4'
<7>[   31.464779] kobject tty5: registering. parent: tty, set: class_obj
<7>[   31.464801] kobject_uevent
<7>[   31.464806] fill_kobj_path: path = '/class/tty/tty5'
<7>[   31.465079] kobject tty6: registering. parent: tty, set: class_obj
<7>[   31.465103] kobject_uevent
<7>[   31.465107] fill_kobj_path: path = '/class/tty/tty6'
<7>[   31.465365] kobject tty7: registering. parent: tty, set: class_obj
<7>[   31.465388] kobject_uevent
<7>[   31.465392] fill_kobj_path: path = '/class/tty/tty7'
<7>[   31.465652] kobject tty8: registering. parent: tty, set: class_obj
<7>[   31.465674] kobject_uevent
<7>[   31.465679] fill_kobj_path: path = '/class/tty/tty8'
<7>[   31.466663] kobject tty9: registering. parent: tty, set: class_obj
<7>[   31.466685] kobject_uevent
<7>[   31.466690] fill_kobj_path: path = '/class/tty/tty9'
<7>[   31.466943] kobject tty10: registering. parent: tty, set: class_obj
<7>[   31.466970] kobject_uevent
<7>[   31.466975] fill_kobj_path: path = '/class/tty/tty10'
<7>[   31.467214] kobject tty11: registering. parent: tty, set: class_obj
<7>[   31.467237] kobject_uevent
<7>[   31.467242] fill_kobj_path: path = '/class/tty/tty11'
<7>[   31.467481] kobject tty12: registering. parent: tty, set: class_obj
<7>[   31.467504] kobject_uevent
<7>[   31.467508] fill_kobj_path: path = '/class/tty/tty12'
<7>[   31.467748] kobject tty13: registering. parent: tty, set: class_obj
<7>[   31.467771] kobject_uevent
<7>[   31.467776] fill_kobj_path: path = '/class/tty/tty13'
<7>[   31.469255] kobject tty14: registering. parent: tty, set: class_obj
<7>[   31.469289] kobject_uevent
<7>[   31.469293] fill_kobj_path: path = '/class/tty/tty14'
<7>[   31.469533] kobject tty15: registering. parent: tty, set: class_obj
<7>[   31.469556] kobject_uevent
<7>[   31.469561] fill_kobj_path: path = '/class/tty/tty15'
<7>[   31.469800] kobject tty16: registering. parent: tty, set: class_obj
<7>[   31.469823] kobject_uevent
<7>[   31.469827] fill_kobj_path: path = '/class/tty/tty16'
<7>[   31.470081] kobject tty17: registering. parent: tty, set: class_obj
<7>[   31.470104] kobject_uevent
<7>[   31.470109] fill_kobj_path: path = '/class/tty/tty17'
<7>[   31.470349] kobject tty18: registering. parent: tty, set: class_obj
<7>[   31.470381] kobject_uevent
<7>[   31.470386] fill_kobj_path: path = '/class/tty/tty18'
<7>[   31.470626] kobject tty19: registering. parent: tty, set: class_obj
<7>[   31.470649] kobject_uevent
<7>[   31.470654] fill_kobj_path: path = '/class/tty/tty19'
<7>[   31.470893] kobject tty20: registering. parent: tty, set: class_obj
<7>[   31.471780] kobject_uevent
<7>[   31.471786] fill_kobj_path: path = '/class/tty/tty20'
<7>[   31.472039] kobject tty21: registering. parent: tty, set: class_obj
<7>[   31.472062] kobject_uevent
<7>[   31.472067] fill_kobj_path: path = '/class/tty/tty21'
<7>[   31.472306] kobject tty22: registering. parent: tty, set: class_obj
<7>[   31.472330] kobject_uevent
<7>[   31.472335] fill_kobj_path: path = '/class/tty/tty22'
<7>[   31.472574] kobject tty23: registering. parent: tty, set: class_obj
<7>[   31.472597] kobject_uevent
<7>[   31.472602] fill_kobj_path: path = '/class/tty/tty23'
<7>[   31.472851] kobject tty24: registering. parent: tty, set: class_obj
<7>[   31.472879] kobject_uevent
<7>[   31.472884] fill_kobj_path: path = '/class/tty/tty24'
<7>[   31.474623] kobject tty25: registering. parent: tty, set: class_obj
<7>[   31.474646] kobject_uevent
<7>[   31.474651] fill_kobj_path: path = '/class/tty/tty25'
<7>[   31.474890] kobject tty26: registering. parent: tty, set: class_obj
<7>[   31.474927] kobject_uevent
<7>[   31.474932] fill_kobj_path: path = '/class/tty/tty26'
<7>[   31.475171] kobject tty27: registering. parent: tty, set: class_obj
<7>[   31.475195] kobject_uevent
<7>[   31.475200] fill_kobj_path: path = '/class/tty/tty27'
<7>[   31.475440] kobject tty28: registering. parent: tty, set: class_obj
<7>[   31.475463] kobject_uevent
<7>[   31.475468] fill_kobj_path: path = '/class/tty/tty28'
<7>[   31.475708] kobject tty29: registering. parent: tty, set: class_obj
<7>[   31.475731] kobject_uevent
<7>[   31.475736] fill_kobj_path: path = '/class/tty/tty29'
<7>[   31.476393] kobject tty30: registering. parent: tty, set: class_obj
<7>[   31.476418] kobject_uevent
<7>[   31.476423] fill_kobj_path: path = '/class/tty/tty30'
<7>[   31.476663] kobject tty31: registering. parent: tty, set: class_obj
<7>[   31.476696] kobject_uevent
<7>[   31.476701] fill_kobj_path: path = '/class/tty/tty31'
<7>[   31.476954] kobject tty32: registering. parent: tty, set: class_obj
<7>[   31.476977] kobject_uevent
<7>[   31.476982] fill_kobj_path: path = '/class/tty/tty32'
<7>[   31.477222] kobject tty33: registering. parent: tty, set: class_obj
<7>[   31.477245] kobject_uevent
<7>[   31.477250] fill_kobj_path: path = '/class/tty/tty33'
<7>[   31.477489] kobject tty34: registering. parent: tty, set: class_obj
<7>[   31.477514] kobject_uevent
<7>[   31.477519] fill_kobj_path: path = '/class/tty/tty34'
<7>[   31.477760] kobject tty35: registering. parent: tty, set: class_obj
<7>[   31.477792] kobject_uevent
<7>[   31.477797] fill_kobj_path: path = '/class/tty/tty35'
<7>[   31.478925] kobject tty36: registering. parent: tty, set: class_obj
<7>[   31.478949] kobject_uevent
<7>[   31.478954] fill_kobj_path: path = '/class/tty/tty36'
<7>[   31.479194] kobject tty37: registering. parent: tty, set: class_obj
<7>[   31.479218] kobject_uevent
<7>[   31.479223] fill_kobj_path: path = '/class/tty/tty37'
<7>[   31.479462] kobject tty38: registering. parent: tty, set: class_obj
<7>[   31.479486] kobject_uevent
<7>[   31.479490] fill_kobj_path: path = '/class/tty/tty38'
<7>[   31.479733] kobject tty39: registering. parent: tty, set: class_obj
<7>[   31.479757] kobject_uevent
<7>[   31.479762] fill_kobj_path: path = '/class/tty/tty39'
<7>[   31.480565] kobject tty40: registering. parent: tty, set: class_obj
<7>[   31.480588] kobject_uevent
<7>[   31.480594] fill_kobj_path: path = '/class/tty/tty40'
<7>[   31.480833] kobject tty41: registering. parent: tty, set: class_obj
<7>[   31.480857] kobject_uevent
<7>[   31.480862] fill_kobj_path: path = '/class/tty/tty41'
<7>[   31.481114] kobject tty42: registering. parent: tty, set: class_obj
<7>[   31.481138] kobject_uevent
<7>[   31.481142] fill_kobj_path: path = '/class/tty/tty42'
<7>[   31.481383] kobject tty43: registering. parent: tty, set: class_obj
<7>[   31.481407] kobject_uevent
<7>[   31.481412] fill_kobj_path: path = '/class/tty/tty43'
<7>[   31.481652] kobject tty44: registering. parent: tty, set: class_obj
<7>[   31.481676] kobject_uevent
<7>[   31.481681] fill_kobj_path: path = '/class/tty/tty44'
<7>[   31.482785] kobject tty45: registering. parent: tty, set: class_obj
<7>[   31.482809] kobject_uevent
<7>[   31.482814] fill_kobj_path: path = '/class/tty/tty45'
<7>[   31.483066] kobject tty46: registering. parent: tty, set: class_obj
<7>[   31.483090] kobject_uevent
<7>[   31.483095] fill_kobj_path: path = '/class/tty/tty46'
<7>[   31.483334] kobject tty47: registering. parent: tty, set: class_obj
<7>[   31.483359] kobject_uevent
<7>[   31.483364] fill_kobj_path: path = '/class/tty/tty47'
<7>[   31.483604] kobject tty48: registering. parent: tty, set: class_obj
<7>[   31.483645] kobject_uevent
<7>[   31.483649] fill_kobj_path: path = '/class/tty/tty48'
<7>[   31.483902] kobject tty49: registering. parent: tty, set: class_obj
<7>[   31.483927] kobject_uevent
<7>[   31.483931] fill_kobj_path: path = '/class/tty/tty49'
<7>[   31.484172] kobject tty50: registering. parent: tty, set: class_obj
<7>[   31.484196] kobject_uevent
<7>[   31.484200] fill_kobj_path: path = '/class/tty/tty50'
<7>[   31.484442] kobject tty51: registering. parent: tty, set: class_obj
<7>[   31.484468] kobject_uevent
<7>[   31.484473] fill_kobj_path: path = '/class/tty/tty51'
<7>[   31.484714] kobject tty52: registering. parent: tty, set: class_obj
<7>[   31.484747] kobject_uevent
<7>[   31.484752] fill_kobj_path: path = '/class/tty/tty52'
<7>[   31.485618] kobject tty53: registering. parent: tty, set: class_obj
<7>[   31.485642] kobject_uevent
<7>[   31.485647] fill_kobj_path: path = '/class/tty/tty53'
<7>[   31.485887] kobject tty54: registering. parent: tty, set: class_obj
<7>[   31.485925] kobject_uevent
<7>[   31.485930] fill_kobj_path: path = '/class/tty/tty54'
<7>[   31.486170] kobject tty55: registering. parent: tty, set: class_obj
<7>[   31.486194] kobject_uevent
<7>[   31.486199] fill_kobj_path: path = '/class/tty/tty55'
<7>[   31.486439] kobject tty56: registering. parent: tty, set: class_obj
<7>[   31.486464] kobject_uevent
<7>[   31.486469] fill_kobj_path: path = '/class/tty/tty56'
<7>[   31.486709] kobject tty57: registering. parent: tty, set: class_obj
<7>[   31.486734] kobject_uevent
<7>[   31.486739] fill_kobj_path: path = '/class/tty/tty57'
<7>[   31.487712] kobject tty58: registering. parent: tty, set: class_obj
<7>[   31.487736] kobject_uevent
<7>[   31.487741] fill_kobj_path: path = '/class/tty/tty58'
<7>[   31.487993] kobject tty59: registering. parent: tty, set: class_obj
<7>[   31.488018] kobject_uevent
<7>[   31.488023] fill_kobj_path: path = '/class/tty/tty59'
<7>[   31.488263] kobject tty60: registering. parent: tty, set: class_obj
<7>[   31.488288] kobject_uevent
<7>[   31.488294] fill_kobj_path: path = '/class/tty/tty60'
<7>[   31.488533] kobject tty61: registering. parent: tty, set: class_obj
<7>[   31.488558] kobject_uevent
<7>[   31.488562] fill_kobj_path: path = '/class/tty/tty61'
<7>[   31.488802] kobject tty62: registering. parent: tty, set: class_obj
<7>[   31.488827] kobject_uevent
<7>[   31.488831] fill_kobj_path: path = '/class/tty/tty62'
<7>[   31.490183] kobject tty63: registering. parent: tty, set: class_obj
<7>[   31.490208] kobject_uevent
<7>[   31.490213] fill_kobj_path: path = '/class/tty/tty63'
<7>[   31.490499] kobject hpet: registering. parent: misc, set: class_obj
<7>[   31.490533] kobject_uevent
<7>[   31.490538] fill_kobj_path: path = '/class/misc/hpet'
<6>[   31.490782] Linux agpgart interface v0.101 (c) Dave Jones
<7>[   31.491523] kobject agpgart-amd64: registering. parent: <NULL>, set: drivers
<7>[   31.491544] kobject_uevent
<7>[   31.491549] fill_kobj_path: path = '/bus/pci/drivers/agpgart-amd64'
<6>[   31.491758] agpgart: Detected AGP bridge 0
<7>[   31.497776] kobject agpgart: registering. parent: misc, set: class_obj
<7>[   31.497821] kobject_uevent
<7>[   31.497828] fill_kobj_path: path = '/class/misc/agpgart'
<6>[   31.498171] agpgart: AGP aperture is 128M @ 0xd0000000
<7>[   31.499128] kobject ram0: registering. parent: <NULL>, set: block
<7>[   31.499168] kobject holders: registering. parent: ram0, set: <NULL>
<7>[   31.499186] kobject_uevent
<7>[   31.499188] kobject slaves: registering. parent: ram0, set: <NULL>
<7>[   31.499205] kobject_uevent
<7>[   31.499207] kobject_uevent
<7>[   31.499212] fill_kobj_path: path = '/block/ram0'
<7>[   31.499411] kobject ram1: registering. parent: <NULL>, set: block
<7>[   31.499437] kobject holders: registering. parent: ram1, set: <NULL>
<7>[   31.499453] kobject_uevent
<7>[   31.499456] kobject slaves: registering. parent: ram1, set: <NULL>
<7>[   31.499479] kobject_uevent
<7>[   31.499481] kobject_uevent
<7>[   31.499485] fill_kobj_path: path = '/block/ram1'
<7>[   31.499684] kobject ram2: registering. parent: <NULL>, set: block
<7>[   31.499710] kobject holders: registering. parent: ram2, set: <NULL>
<7>[   31.499726] kobject_uevent
<7>[   31.499729] kobject slaves: registering. parent: ram2, set: <NULL>
<7>[   31.499746] kobject_uevent
<7>[   31.499748] kobject_uevent
<7>[   31.499753] fill_kobj_path: path = '/block/ram2'
<7>[   31.500365] kobject ram3: registering. parent: <NULL>, set: block
<7>[   31.500390] kobject holders: registering. parent: ram3, set: <NULL>
<7>[   31.500408] kobject_uevent
<7>[   31.500410] kobject slaves: registering. parent: ram3, set: <NULL>
<7>[   31.500427] kobject_uevent
<7>[   31.500428] kobject_uevent
<7>[   31.500433] fill_kobj_path: path = '/block/ram3'
<7>[   31.500629] kobject ram4: registering. parent: <NULL>, set: block
<7>[   31.500654] kobject holders: registering. parent: ram4, set: <NULL>
<7>[   31.500674] kobject_uevent
<7>[   31.500676] kobject slaves: registering. parent: ram4, set: <NULL>
<7>[   31.500693] kobject_uevent
<7>[   31.500694] kobject_uevent
<7>[   31.500699] fill_kobj_path: path = '/block/ram4'
<7>[   31.500908] kobject ram5: registering. parent: <NULL>, set: block
<7>[   31.500935] kobject holders: registering. parent: ram5, set: <NULL>
<7>[   31.500951] kobject_uevent
<7>[   31.500954] kobject slaves: registering. parent: ram5, set: <NULL>
<7>[   31.500970] kobject_uevent
<7>[   31.500972] kobject_uevent
<7>[   31.500976] fill_kobj_path: path = '/block/ram5'
<7>[   31.501172] kobject ram6: registering. parent: <NULL>, set: block
<7>[   31.501207] kobject holders: registering. parent: ram6, set: <NULL>
<7>[   31.501224] kobject_uevent
<7>[   31.501226] kobject slaves: registering. parent: ram6, set: <NULL>
<7>[   31.501244] kobject_uevent
<7>[   31.501245] kobject_uevent
<7>[   31.501250] fill_kobj_path: path = '/block/ram6'
<7>[   31.501446] kobject ram7: registering. parent: <NULL>, set: block
<7>[   31.501480] kobject holders: registering. parent: ram7, set: <NULL>
<7>[   31.501497] kobject_uevent
<7>[   31.501500] kobject slaves: registering. parent: ram7, set: <NULL>
<7>[   31.501516] kobject_uevent
<7>[   31.501518] kobject_uevent
<7>[   31.501522] fill_kobj_path: path = '/block/ram7'
<4>[   31.501718] RAMDISK driver initialized: 8 RAM disks of 4096K size 1024 blocksize
<7>[   31.503215] kobject loop0: registering. parent: <NULL>, set: block
<7>[   31.503241] kobject holders: registering. parent: loop0, set: <NULL>
<7>[   31.503258] kobject_uevent
<7>[   31.503260] kobject slaves: registering. parent: loop0, set: <NULL>
<7>[   31.503280] kobject_uevent
<7>[   31.503282] kobject_uevent
<7>[   31.503293] fill_kobj_path: path = '/block/loop0'
<7>[   31.503494] kobject loop1: registering. parent: <NULL>, set: block
<7>[   31.503526] kobject holders: registering. parent: loop1, set: <NULL>
<7>[   31.503544] kobject_uevent
<7>[   31.503546] kobject slaves: registering. parent: loop1, set: <NULL>
<7>[   31.503563] kobject_uevent
<7>[   31.503565] kobject_uevent
<7>[   31.503569] fill_kobj_path: path = '/block/loop1'
<7>[   31.503763] kobject loop2: registering. parent: <NULL>, set: block
<7>[   31.503789] kobject holders: registering. parent: loop2, set: <NULL>
<7>[   31.503806] kobject_uevent
<7>[   31.503808] kobject slaves: registering. parent: loop2, set: <NULL>
<7>[   31.503825] kobject_uevent
<7>[   31.503826] kobject_uevent
<7>[   31.503831] fill_kobj_path: path = '/block/loop2'
<7>[   31.504038] kobject loop3: registering. parent: <NULL>, set: block
<7>[   31.504064] kobject holders: registering. parent: loop3, set: <NULL>
<7>[   31.504080] kobject_uevent
<7>[   31.504082] kobject slaves: registering. parent: loop3, set: <NULL>
<7>[   31.504099] kobject_uevent
<7>[   31.504100] kobject_uevent
<7>[   31.504105] fill_kobj_path: path = '/block/loop3'
<7>[   31.504303] kobject loop4: registering. parent: <NULL>, set: block
<7>[   31.504330] kobject holders: registering. parent: loop4, set: <NULL>
<7>[   31.504346] kobject_uevent
<7>[   31.504349] kobject slaves: registering. parent: loop4, set: <NULL>
<7>[   31.504365] kobject_uevent
<7>[   31.504367] kobject_uevent
<7>[   31.504371] fill_kobj_path: path = '/block/loop4'
<7>[   31.504569] kobject loop5: registering. parent: <NULL>, set: block
<7>[   31.504596] kobject holders: registering. parent: loop5, set: <NULL>
<7>[   31.504613] kobject_uevent
<7>[   31.504615] kobject slaves: registering. parent: loop5, set: <NULL>
<7>[   31.504632] kobject_uevent
<7>[   31.504633] kobject_uevent
<7>[   31.504638] fill_kobj_path: path = '/block/loop5'
<7>[   31.504834] kobject loop6: registering. parent: <NULL>, set: block
<7>[   31.504868] kobject holders: registering. parent: loop6, set: <NULL>
<7>[   31.506209] kobject_uevent
<7>[   31.506211] kobject slaves: registering. parent: loop6, set: <NULL>
<7>[   31.506228] kobject_uevent
<7>[   31.506230] kobject_uevent
<7>[   31.506235] fill_kobj_path: path = '/block/loop6'
<7>[   31.506429] kobject loop7: registering. parent: <NULL>, set: block
<7>[   31.506456] kobject holders: registering. parent: loop7, set: <NULL>
<7>[   31.506482] kobject_uevent
<7>[   31.506484] kobject slaves: registering. parent: loop7, set: <NULL>
<7>[   31.506501] kobject_uevent
<7>[   31.506502] kobject_uevent
<7>[   31.506507] fill_kobj_path: path = '/block/loop7'
<6>[   31.506707] loop: loaded (max 8 devices)
<7>[   31.507246] kobject sx8: registering. parent: <NULL>, set: drivers
<7>[   31.507265] kobject_uevent
<7>[   31.507270] fill_kobj_path: path = '/bus/pci/drivers/sx8'
<7>[   31.507488] kobject lo: registering. parent: net, set: class_obj
<7>[   31.507666] kobject_uevent
<7>[   31.507704] fill_kobj_path: path = '/class/net/lo'
<6>[   31.509922] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>[   31.510772] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<7>[   31.512176] subsystem ide: registering
<7>[   31.512177] kobject ide: registering. parent: <NULL>, set: bus
<7>[   31.512201] kobject devices: registering. parent: ide, set: <NULL>
<7>[   31.512229] kobject drivers: registering. parent: ide, set: <NULL>
<6>[   31.512265] PDC20267: IDE controller at PCI slot 0000:00:09.0
<4>[   31.513898] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
<7>[   31.514666] PCI: setting IRQ 11 as level-triggered
<6>[   31.514671] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
<6>[   31.515907] PDC20267: chipset revision 2
<6>[   31.516431] PDC20267: ROM enabled at 0xf9900000
<6>[   31.517045] PDC20267: 100%% native mode on irq 11
<6>[   31.517665] PDC20267: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
<6>[   31.518696]     ide2: BM-DMA at 0x9000-0x9007, BIOS settings: hde:pio, hdf:DMA
<6>[   31.519726]     ide3: BM-DMA at 0x9008-0x900f, BIOS settings: hdg:pio, hdh:DMA
<7>[   31.520755] Probing IDE interface ide2...
<4>[   31.885995] hde: OnStream DI-30, ATAPI TAPE drive
<7>[   31.886695] kobject ide2: registering. parent: 0000:00:09.0, set: devices
<7>[   31.886755] kobject_uevent
<4>[   32.192680] ide2 at 0xa400-0xa407,0xa002 on irq 11
<7>[   32.193361] kobject 2.0: registering. parent: ide2, set: devices
<7>[   32.193406] kobject_uevent
<7>[   32.193417] fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0/ide2/2.0'
<7>[   32.193675] Probing IDE interface ide3...
<6>[   32.712394] VP_IDE: IDE controller at PCI slot 0000:00:0f.1
<6>[   32.713152] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
<6>[   32.714381] PCI: VIA IRQ fixup for 0000:00:0f.1, from 255 to 11
<6>[   32.715191] VP_IDE: chipset revision 6
<6>[   32.715700] VP_IDE: not 100%% native mode: will probe irqs later
<6>[   32.716513] VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
<6>[   32.717525]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:DMA
<6>[   32.718560]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:DMA
<7>[   32.719591] Probing IDE interface ide0...
<4>[   33.105281] hda: WDC WD800BB-00FRA0, ATA DISK drive
<7>[   33.105999] kobject ide0: registering. parent: 0000:00:0f.1, set: devices
<7>[   33.106044] kobject_uevent
<4>[   33.360169] hdb: Maxtor 6L250R0, ATA DISK drive
<4>[   33.417104] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<7>[   33.417754] kobject 0.0: registering. parent: ide0, set: devices
<7>[   33.417799] kobject_uevent
<7>[   33.417804] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   33.418031] kobject 0.1: registering. parent: ide0, set: devices
<7>[   33.418092] kobject_uevent
<7>[   33.418097] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.1'
<7>[   33.418313] Probing IDE interface ide1...
<4>[   34.211796] hdc: PLEXTOR CD-R PX-W5224A, ATAPI CD/DVD-ROM drive
<7>[   34.212657] kobject ide1: registering. parent: 0000:00:0f.1, set: devices
<7>[   34.212711] kobject_uevent
<4>[   34.926483] hdd: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
<4>[   34.977596] ide1 at 0x170-0x177,0x376 on irq 15
<7>[   34.978238] kobject 1.0: registering. parent: ide1, set: devices
<7>[   34.978299] kobject_uevent
<7>[   34.978305] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide1/1.0'
<7>[   34.978541] kobject 1.1: registering. parent: ide1, set: devices
<7>[   34.978586] kobject_uevent
<7>[   34.978591] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide1/1.1'
<7>[   34.978863] kobject Promise_Old_IDE: registering. parent: <NULL>, set: drivers
<7>[   34.978885] kobject_uevent
<7>[   34.978890] fill_kobj_path: path = '/bus/pci/drivers/Promise_Old_IDE'
<7>[   34.979140] kobject VIA_IDE: registering. parent: <NULL>, set: drivers
<7>[   34.979159] kobject_uevent
<7>[   34.979164] fill_kobj_path: path = '/bus/pci/drivers/VIA_IDE'
<7>[   34.979405] kobject PCI_IDE: registering. parent: <NULL>, set: drivers
<7>[   34.979425] kobject_uevent
<7>[   34.979430] fill_kobj_path: path = '/bus/pci/drivers/PCI_IDE'
<7>[   34.979666] kobject ide-disk: registering. parent: <NULL>, set: drivers
<7>[   34.979685] kobject_uevent
<7>[   34.979690] fill_kobj_path: path = '/bus/ide/drivers/ide-disk'
<6>[   34.979925] hda: max request size: 512KiB
<6>[   35.026507] hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
<6>[   35.064331] hda: cache flushes supported
<7>[   35.100380] kobject hda: registering. parent: <NULL>, set: block
<7>[   35.100420] kobject holders: registering. parent: hda, set: <NULL>
<7>[   35.100438] kobject_uevent
<7>[   35.100441] kobject slaves: registering. parent: hda, set: <NULL>
<7>[   35.100459] kobject_uevent
<6>[   35.100781]  hda: hda1 hda2 hda3 hda4
<7>[   35.173450] kobject hda1: registering. parent: hda, set: <NULL>
<7>[   35.173533] kobject holders: registering. parent: hda1, set: <NULL>
<7>[   35.173553] kobject_uevent
<7>[   35.173562] kobject hda2: registering. parent: hda, set: <NULL>
<7>[   35.173590] kobject holders: registering. parent: hda2, set: <NULL>
<7>[   35.173610] kobject_uevent
<7>[   35.173619] kobject hda3: registering. parent: hda, set: <NULL>
<7>[   35.173648] kobject holders: registering. parent: hda3, set: <NULL>
<7>[   35.173668] kobject_uevent
<7>[   35.173677] kobject hda4: registering. parent: hda, set: <NULL>
<7>[   35.173706] kobject holders: registering. parent: hda4, set: <NULL>
<7>[   35.173726] kobject_uevent
<7>[   35.179592] kobject_uevent
<7>[   35.179607] fill_kobj_path: path = '/block/hda'
<7>[   35.179611] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   35.179867] kobject_uevent
<7>[   35.179872] fill_kobj_path: path = '/block/hda/hda1'
<7>[   35.179876] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   35.180085] kobject_uevent
<7>[   35.180090] fill_kobj_path: path = '/block/hda/hda2'
<7>[   35.180093] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   35.180376] kobject_uevent
<7>[   35.180381] fill_kobj_path: path = '/block/hda/hda3'
<7>[   35.180384] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   35.180591] kobject_uevent
<7>[   35.180595] fill_kobj_path: path = '/block/hda/hda4'
<7>[   35.180599] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   35.180859] kobject queue: registering. parent: hda, set: <NULL>
<7>[   35.180884] kobject_uevent
<7>[   35.180886] kobject iosched: registering. parent: queue, set: <NULL>
<7>[   35.180920] kobject_uevent
<6>[   35.180959] hdb: max request size: 512KiB
<6>[   35.238951] hdb: 490234752 sectors (251000 MB) w/16384KiB Cache, CHS=30515/255/63, UDMA(133)
<6>[   35.277569] hdb: cache flushes supported
<7>[   35.314331] kobject hdb: registering. parent: <NULL>, set: block
<7>[   35.314368] kobject holders: registering. parent: hdb, set: <NULL>
<7>[   35.314388] kobject_uevent
<7>[   35.314390] kobject slaves: registering. parent: hdb, set: <NULL>
<7>[   35.314409] kobject_uevent
<6>[   35.314427]  hdb: hdb1
<7>[   35.355733] kobject hdb1: registering. parent: hdb, set: <NULL>
<7>[   35.355766] kobject holders: registering. parent: hdb1, set: <NULL>
<7>[   35.355786] kobject_uevent
<7>[   35.356011] kobject_uevent
<7>[   35.356017] fill_kobj_path: path = '/block/hdb'
<7>[   35.356020] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.1'
<7>[   35.356250] kobject_uevent
<7>[   35.356254] fill_kobj_path: path = '/block/hdb/hdb1'
<7>[   35.356258] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.1'
<7>[   35.356523] kobject queue: registering. parent: hdb, set: <NULL>
<7>[   35.356547] kobject_uevent
<7>[   35.356549] kobject iosched: registering. parent: queue, set: <NULL>
<7>[   35.356573] kobject_uevent
<7>[   35.357038] kobject libusual: registering. parent: <NULL>, set: drivers
<7>[   35.357061] kobject_uevent
<7>[   35.357066] fill_kobj_path: path = '/bus/usb/drivers/libusual'
<6>[   35.357257] usbcore: registered new interface driver libusual
<7>[   35.394144] kobject i8042 kbd: registering. parent: <NULL>, set: drivers
<7>[   35.394166] kobject_uevent
<7>[   35.394171] fill_kobj_path: path = '/bus/pnp/drivers/i8042 kbd'
<7>[   35.394437] kobject i8042 aux: registering. parent: <NULL>, set: drivers
<7>[   35.394458] kobject_uevent
<7>[   35.394462] fill_kobj_path: path = '/bus/pnp/drivers/i8042 aux'
<6>[   35.394648] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>[   35.431551] PNP: PS/2 controller doesn't have AUX irq; using default 12
<7>[   35.468719] kobject i8042: registering. parent: <NULL>, set: drivers
<7>[   35.468745] kobject_uevent
<7>[   35.468750] fill_kobj_path: path = '/bus/platform/drivers/i8042'
<7>[   35.468992] kobject i8042: registering. parent: platform, set: devices
<7>[   35.469043] kobject_uevent
<7>[   35.469048] fill_kobj_path: path = '/devices/platform/i8042'
<6>[   35.469590] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[   35.506971] serio: i8042 AUX port at 0x60,0x64 irq 12
<7>[   35.543689] subsystem hwmon: registering
<7>[   35.543691] kobject hwmon: registering. parent: <NULL>, set: class
<7>[   35.543799] subsystem sound: registering
<7>[   35.543801] kobject sound: registering. parent: <NULL>, set: class
<4>[   35.543861] Netfilter messages via NETLINK v0.30.
<6>[   35.580752] TCP cubic registered
<6>[   35.617769] NET: Registered protocol family 1
<6>[   35.654331] NET: Registered protocol family 17
<4>[   35.690182] Using IPI Shortcut mode
<7>[   35.725672] kobject acpi: registering. parent: <NULL>, set: system
<7>[   35.725697] kobject acpi0: registering. parent: <NULL>, set: acpi
<7>[   35.725716] kobject_uevent
<7>[   35.725721] fill_kobj_path: path = '/devices/system/acpi/acpi0'
<7>[   35.725841] kobject serio0: registering. parent: i8042, set: devices
<7>[   35.725992] kobject_uevent
<6>[   35.726055] Time: tsc clocksource has been installed.
<7>[   35.761601] fill_kobj_path: path = '/devices/platform/i8042/serio0'
<6>[   35.761929] ACPI: (supports S0 S1 S3 S4 S5)
<6>[   35.797726] Freeing unused kernel memory: 188k freed
<4>[   35.833025] Write protecting the kernel read-only data: 391k
<7>[   35.868869] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   35.868911] kobject_uevent
<7>[   35.868923] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   35.869347] kobject serio1: registering. parent: i8042, set: devices
<7>[   35.869412] kobject_uevent
<7>[   35.869417] fill_kobj_path: path = '/devices/platform/i8042/serio1'
<7>[   35.869676] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   35.869703] kobject_uevent
<7>[   35.869708] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   35.870055] kobject atkbd: registering. parent: <NULL>, set: drivers
<7>[   35.870077] kobject_uevent
<7>[   35.870082] fill_kobj_path: path = '/bus/serio/drivers/atkbd'
<7>[   36.446941] kobject input0: registering. parent: input, set: class_obj
<7>[   36.447018] kobject_uevent
<7>[   36.447024] fill_kobj_path: path = '/class/input/input0'
<7>[   36.447027] fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>[   36.447696] fill_kobj_path: path = '/class/input/input0'
<6>[   36.447698] input: AT Translated Set 2 keyboard as /class/input/input0
<7>[   36.512480] kobject <NULL>: cleaning up
<5>[   37.977660] XFS mounting filesystem hda2
<7>[   38.120078] Ending clean XFS mount for filesystem: hda2
<7>[   38.120456] kobject_uevent
<7>[   38.120465] fill_kobj_path: path = '/block/hda/hda2'
<7>[   38.120471] fill_kobj_path: path = '/devices/pci0000:00/0000:00:0f.1/ide0/0.0'
<7>[   38.370050] kobject_uevent
<7>[   38.370060] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.371073] kobject vcs1: cleaning up
<7>[   38.371125] kobject_uevent
<7>[   38.371130] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.371491] kobject vcsa1: cleaning up
<7>[   38.371686] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   38.371713] kobject_uevent
<7>[   38.371718] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.372025] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   38.372046] kobject_uevent
<7>[   38.372050] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.372383] kobject_uevent
<7>[   38.372388] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.372746] kobject vcs1: cleaning up
<7>[   38.372798] kobject_uevent
<7>[   38.372803] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.373178] kobject vcsa1: cleaning up
<7>[   38.437159] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   38.437187] kobject_uevent
<7>[   38.437193] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.437484] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   38.437504] kobject_uevent
<7>[   38.437509] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.437947] kobject_uevent
<7>[   38.437952] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.438325] kobject vcs1: cleaning up
<7>[   38.438377] kobject_uevent
<7>[   38.438382] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.438748] kobject vcsa1: cleaning up
<7>[   38.438927] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   38.438947] kobject_uevent
<7>[   38.438952] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.439217] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   38.439237] kobject_uevent
<7>[   38.439242] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.439811] kobject_uevent
<7>[   38.439815] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.440197] kobject vcs1: cleaning up
<7>[   38.440249] kobject_uevent
<7>[   38.440254] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.440620] kobject vcsa1: cleaning up
<7>[   38.440749] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   38.440769] kobject_uevent
<7>[   38.440774] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.442009] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   38.442029] kobject_uevent
<7>[   38.442033] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.479914] kobject_uevent
<7>[   38.479919] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.480286] kobject vcs1: cleaning up
<7>[   38.480338] kobject_uevent
<7>[   38.480343] fill_kobj_path: path = '/class/vc/vcsa1'
<7>[   38.480706] kobject vcsa1: cleaning up
<7>[   38.497945] kobject vcs1: registering. parent: vc, set: class_obj
<7>[   38.497972] kobject_uevent
<7>[   38.497977] fill_kobj_path: path = '/class/vc/vcs1'
<7>[   38.498260] kobject vcsa1: registering. parent: vc, set: class_obj
<7>[   38.498281] kobject_uevent
<7>[   38.498285] fill_kobj_path: path = '/class/vc/vcsa1'
<4>[   39.002701] BUG: warning at kernel/lockdep.c:2363/check_flags()
<4>[   39.038409]  [dump_trace+497/544] dump_trace+0x1f1/0x220
<4>[   39.074179]  [show_trace_log_lvl+38/64] show_trace_log_lvl+0x26/0x40
<4>[   39.109566]  [show_trace+27/32] show_trace+0x1b/0x20
<4>[   39.144433]  [dump_stack+38/48] dump_stack+0x26/0x30
<4>[   39.178850]  [check_flags+694/704] check_flags+0x2b6/0x2c0
<4>[   39.212796]  [lock_acquire+36/144] lock_acquire+0x24/0x90
<4>[   39.246212]  [down_read_trylock+98/112] down_read_trylock+0x62/0x70
<4>[   39.279488]  [do_page_fault+189/1584] do_page_fault+0xbd/0x630
<4>[   39.312432]  [error_code+57/64] error_code+0x39/0x40
<4>[   39.344858]  [phys_startup_32+133475296/-1073741824] 0x804abe0
<4>[   39.377200]  =======================
<4>[   39.409542] irq event stamp: 1527
<4>[   39.441540] hardirqs last  enabled at (1527): [sysenter_past_esp+134/141] sysenter_past_esp+0x86/0x8d
<4>[   39.474266] hardirqs last disabled at (1526): [sysenter_past_esp+99/141] sysenter_past_esp+0x63/0x8d
<4>[   39.507050] softirqs last  enabled at (1454): [__do_softirq+172/192] __do_softirq+0xac/0xc0
<4>[   39.539510] softirqs last disabled at (1445): [do_softirq+85/96] do_softirq+0x55/0x60
<6>[   43.670711] Adding 1951888k swap on /dev/hda4.  Priority:-1 extents:1 across:1951888k
<7>[   44.733673] kobject nvram: registering. parent: <NULL>, set: module
<7>[   44.763241] kobject_uevent
<7>[   44.792169] fill_kobj_path: path = '/module/nvram'
<7>[   44.822684] kobject nvram: registering. parent: misc, set: class_obj
<7>[   44.852060] kobject_uevent
(...)


bjd

