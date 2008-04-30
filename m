Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbYD3Kwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbYD3Kwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYD3Kwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:52:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:26195 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbYD3Kwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RI/z6P/h5t4lyYuHtgU9nfNhsKGG+LmAdDaIkMYe+QS9TtEL9SPrCkweW4glzSQIJQ7p1Jyt9u+v/+ZXalTpfjLMB5tYAJZIN+TUsDNxj64z0//2gyN5BaYXP0RSCHm65KRvJlFsJ12WunE1lXKrT6Ht7il3odnrqD8Y9Plje+M=
Message-ID: <3b2bc9d0804300352k76bdc2f1id7da040761bca427@mail.gmail.com>
Date: Wed, 30 Apr 2008 12:52:38 +0200
From: "marco gaddoni" <marco.gaddoni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: oops in linear_mergeable_bvec
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i have this repeatable oops in linear_mergeable_bvec

the kernel is the Debian testing as of this morning,

i am trying to rsync some data from this box to my pc.
the data is on a software raid 0 made of 2 ide disks

the oops is triggered during the copy of a specific file,
allways the same.

what can be the problem?

arianna:~# cat /proc/mdstat
Personalities : [linear]
md2 : active linear hda1[0] hdb1[1]
      277321856 blocks 64k rounding

unused devices: <none>


BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000010
printing eip: c881609a *pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: nf_nat_ftp nf_conntrack_ftp nfsd auth_rpcgss
exportfs nfs lockd nfs_acl sunrpc ipt_MASQUERADE ipt_LOG
ip6table_filter xt_state xt_NFQUEUE xt_hashlimit ip6_tables xt_tcpmss
xt_tcpudp ipt_addrtype xt_pkttype iptable_raw xt_CLASSIFY xt_CONNMARK
xt_MARK xt_comment ipt_REJECT xt_length xt_connmark ipt_owner
ipt_recent ipt_iprange xt_physdev xt_policy xt_multiport xt_conntrack
iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
iptable_filter ip_tables x_tables ipv6 deflate zlib_deflate
zlib_inflate twofish twofish_common camellia serpent blowfish
des_generic cbc ecb aes_i586 aes_generic geode_aes blkcipher xcbc
sha256_generic sha1_generic crypto_null af_key psmouse ide_generic
snd_intel8x0 snd_ac97_codec parport_pc ac97_bus i2c_i801 parport
snd_pcm i2c_core intel_rng snd_timer snd soundcore snd_page_alloc
intel_agp agpgart pcspkr shpchp pci_hotplug iTCO_wdt rtc evdev ext3
jbd mbcache linear md_mod ide_cd cdrom ide_disk ata_generic libata
scsi_mod floppy e100 mii piix generic ide_core

Pid: 5203, comm: rsync Not tainted (2.6.24-1-686 #1)
EIP: 0060:[<c881609a>] EFLAGS: 00010246 CPU: 0
EIP is at linear_mergeable_bvec+0x9a/0x10b [linear]
EAX: c6595fc0 EBX: 00000000 ECX: 00000000 EDX: 0000002c
ESI: c78a63c0 EDI: 00000000 EBP: 00000000 ESP: c16d5c68
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rsync (pid: 5203, ti=c16d4000 task=c7b09250 task.ti=c16d4000)
Stack: 0b3ed648 00000002 0b3ed648 c6747360 167dac90 00000004 0b3ed648 00000002
       c16ce660 c0196e63 c6747360 c16ce660 c8816000 c642b8c8 c019718e c16ce660
       c1011720 00000004 c16d5da0 c0197a3e 00001000 00000000 000000ff 00001000
Call Trace:
 [<c0196e63>] bio_alloc_bioset+0x9b/0xf3
 [<c8816000>] linear_mergeable_bvec+0x0/0x10b [linear]
 [<c019718e>] __bio_add_page+0xf0/0x162
 [<c0197a3e>] bio_add_page+0x31/0x37
 [<c019ab9c>] do_mpage_readpage+0x516/0x5d2
 [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
 [<c01e1499>] radix_tree_insert+0x4f/0x15e
 [<c015acdd>] add_to_page_cache+0x67/0x80
 [<c019adf3>] mpage_readpages+0x96/0xc3
 [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
 [<c015f343>] __alloc_pages+0x59/0x2d5
 [<c8916c2f>] ext3_readpages+0x0/0x15 [ext3]
 [<c0161101>] __do_page_cache_readahead+0x127/0x1a6
 [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
 [<c016147c>] page_cache_sync_readahead+0x2a/0x2f
 [<c015afae>] do_generic_mapping_read+0xdd/0x3b2
 [<c015a7c7>] file_read_actor+0x0/0xcc
 [<c015c95c>] generic_file_aio_read+0x16b/0x1a6
 [<c015a7c7>] file_read_actor+0x0/0xcc
 [<c0178493>] do_sync_read+0xc7/0x10a
 [<c01353f9>] autoremove_wake_function+0x0/0x35
 [<c011bf41>] do_page_fault+0x1f7/0x592
 [<c01783cc>] do_sync_read+0x0/0x10a
 [<c0178d19>] vfs_read+0x9f/0x14b
 [<c0179182>] sys_read+0x41/0x67
 [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 24 04 89 d1 31 d2 85 c9 89 44 24 08 74 08 89 c8 31 d2 f7 f3 89
c1 8b 44 24 08 f7 f3 89 ca 89 c2 8b 46 04 8b 1c 90 eb 03 83 c3 14 <8b>
53 10 8b 43 0c 8b 73 04 8b 7b 08 89 d1 89 54 24 24 89 c2 01
EIP: [<c881609a>] linear_mergeable_bvec+0x9a/0x10b [linear] SS:ESP 0068:c16d5c68
---[ end trace 7442023bdb72ce2e ]---
arianna:~# uname -a
Linux arianna 2.6.24-1-686 #1 SMP Sat Apr 19 00:37:55 UTC 2008 i686 GNU/Linux
arianna:~#

Linux version 2.6.24-1-686 (Debian 2.6.24-6) (waldi@debian.org) (gcc
version 4.1.3 20080308 (prerelease) (Debian 4.1.2-21)) #1 SMP Sat Apr
19 00:37:55 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000000f00000 (usable)
 BIOS-e820: 0000000000f00000 - 0000000001000000 (reserved)
 BIOS-e820: 0000000001000000 - 0000000007f00000 (usable)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
127MB LOWMEM available.
Entering add_active_range(0, 0, 32512) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    32512
  HighMem     32512 ->    32512
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    32512
On node 0 totalpages: 32512
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 222 pages used for memmap
  Normal zone: 28194 pages, LIFO batch:7
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.2 present.
Allocating PCI resources starting at 10000000 (gap: 07f00000:f7c00000)
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
swsusp: Registered nosave memory region: 0000000000f00000 - 0000000001000000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32258
Kernel command line: root=/dev/hdc1 ro
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (0110a000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 797.314 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 118640k/130048k available (1786k kernel code, 9892k reserved,
714k data, 248k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc8800000 - 0xff7fe000   ( 879 MB)
    lowmem  : 0xc0000000 - 0xc7f00000   ( 127 MB)
      .init : 0xc0377000 - 0xc03b5000   ( 248 kB)
      .data : 0xc02bea2d - 0xc0371384   ( 714 kB)
      .text : 0xc0100000 - 0xc02bea2d   (1786 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1596.26 BogoMIPS (lpj=3192528)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000
00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 128K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040
00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading
namespace from ACPI tables [20070126]
ACPI: Unable to load the System Description Tables
CPU0: Intel Celeron (Coppermine) stepping 06
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
net_namespace: 64 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb2d0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbc60
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbc90, dseg 0xf0000
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 4000-407f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 4080-40bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2410] at 0000:00:1f.0
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:01:0b.0
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI Error (evxfevnt-0186): Could not enable RealTimeClock event [20070126]
ACPI Warning (evxface-0145): Could not enable fixed event 4 [20070126]
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0xffb00000-0xffb7ffff could not be reserved
system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:08: iomem range 0xfee00000-0xfee0ffff has been reserved
system 00:08: iomem range 0x100000-0x7efffff could not be reserved
system 00:09: iomem range 0xf0000-0xf3fff could not be reserved
system 00:09: iomem range 0xf4000-0xf7fff could not be reserved
system 00:09: iomem range 0xf8000-0xfffff could not be reserved
system 00:09: iomem range 0xca000-0xcffff has been reserved
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: d4000000-d5ffffff
  PREFETCH window: disabled.
Time: tsc clocksource has been installed.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5629k freed
audit: initializing netlink socket (disabled)
audit(1209551666.780:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:01.0
PCI: Firmware left 0000:01:0a.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:01:0b.0 e100 interrupts enabled, disabling
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:10: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 248k freed
input: AT Translated Set 2 keyboard as /class/input/input0
thermal: Unknown symbol acpi_processor_set_thermal_limit
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH: IDE controller (0x8086:0x2411 rev 0x02) at  PCI slot 0000:00:1f.1
ICH: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hdb: SAMSUNG SP0802N, ATA DISK drive
hda: Maxtor 6L200P0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdd: ATAPI-CD ROM-DRIVE-52MAX, ATAPI CD/DVD-ROM drive
hdc: Maxtor 6Y080L0, ATA DISK drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:01:0a.0
e100: eth0: e100_probe: addr 0xd5201000, irq 11, MAC addr 00:ae:a0:00:07:a4
PCI: Found IRQ 10 for device 0000:01:0b.0
PCI: Sharing IRQ 10 with 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
e100: eth1: e100_probe: addr 0xd5200000, irq 10, MAC addr 00:ae:a0:00:07:a5
SCSI subsystem initialized
libata version 3.00 loaded.
hda: max request size: 512KiB
hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
hda: cache flushes supported
 hda: hda1
hdb: max request size: 512KiB
hdb: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63
hdb: cache flushes supported
 hdb: hdb1
hdc: max request size: 128KiB
hdc: 160086528 sectors (81964 MB) w/2048KiB Cache, CHS=65535/16/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 < hdc5 >
hdd: ATAPI 52X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
md: linear personality registered for level -1
md: md2 stopped.
md: bind<hdb1>
md: bind<hda1>
Attempting manual resume
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: hdc1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 8604283
EXT3-fs: hdc1: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Real Time Clock Driver v1.12ac
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input1
Linux agpgart interface v0.102
agpgart: Detected an Intel i810 Chipset.
agpgart: AGP aperture is 64M @ 0xd0000000
Intel 82802 RNG detected
PCI: Found IRQ 10 for device 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:01:0b.0
parport_pc 00:0e: reported by Plug and Play BIOS
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
PCI: Found IRQ 10 for device 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:01:0b.0
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 54785 usecs
intel8x0: clocking to 48000
Adding 353388k swap on /dev/hdc5.  Priority:-1 extents:1 across:353388k
EXT3 FS on hdc1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 15
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock not detected.
e100: eth1: e100_watchdog: link up, 10Mbps, half-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
eth1: no IPv6 routers present
eth0: no IPv6 routers present
ip6_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
