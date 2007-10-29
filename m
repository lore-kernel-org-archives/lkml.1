Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXJ2Huw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXJ2Huw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXJ2Huo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:50:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:63034 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXJ2Hum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fSeMirW+gN/IqmQdmJlrr995r8OaDovp2LDcLyhdP9OX+UI0JVk9bqJXYiEYjdRpotFlBW+v7AFrG9zPxeBsSMqdyuQZhOa2TLSfsTaHcfqu3O4pQGTOkID26Oj897RqCHosZYeVD5uTAwVphf2mEjRk30QjWwTG+ThO/E+cn90=
Message-ID: <3b2bc9d0710290050g4e1cf8aoa7917ab7e091da5a@mail.gmail.com>
Date: Mon, 29 Oct 2007 08:50:40 +0100
From: "marco gaddoni" <marco.gaddoni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/slab.c:597!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i got this oops on my server.
the kernel is a  2.6.21-2-686
from the debian.

this is an ext3 filesystem on a
raid0 array of 2 ide disks.
got the oops while doing a
big rm.

any idea on the possible cause?

please cc me as i am not subscribed.

ciao, marco.

------------[ cut here ]------------
kernel BUG at mm/slab.c:597!
invalid opcode: 0000 [#1]
SMP
Modules linked in: nfs nf_conntrack_ftp nfsd exportfs lockd nfs_acl
sunrpc ipt_MASQUERADE ipt_LOG ip6table_filter ip6_tables xt_state
xt_tcpmss xt_tcpudp ipt_addrtype xt_pkttype iptable_raw xt_CLASSIFY
xt_CONNMARK xt_MARK xt_comment ipt_REJECT xt_length xt_connmark
ipt_owner ipt_recent ipt_iprange xt_physdev xt_policy xt_multiport
xt_conntrack iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nfnetlink iptable_filter ip_tables x_tables ipv6 deflate
zlib_deflate twofish twofish_common serpent blowfish des cbc ecb
blkcipher aes xcbc sha256 sha1 crypto_null af_key dm_snapshot
dm_mirror dm_mod psmouse ide_generic parport_pc parport rtc shpchp
pci_hotplug i810_audio ac97_codec pcspkr snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm snd_timer snd soundcore i2c_i801 intel_rng intel_agp
snd_page_alloc i2c_core iTCO_wdt agpgart evdev ext3 jbd mbcache linear
md_mod ide_cd cdrom ide_disk ata_generic libata scsi_mod floppy e100
mii piix generic ide_core
CPU:    0
EIP:    0060:[<c0163ecf>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-2-686 #1)
EIP is at kmem_cache_free+0x29/0x7c
eax: 00000000   ebx: c20177bc   ecx: c71532a0   edx: c2800000
esi: c1b213c8   edi: 80000000   ebp: c7317600   esp: c7dd3f1c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kjournald (pid: 2007, ti=c7dd2000 task=c723e090 task.ti=c7dd2000)
Stack: c20177bc c1b213c8 c15c2f40 c88dfc4e 00001be7 00000000 c2a83fb0 c029d175
       c7dd3f9c c2b26800 00000000 c1223000 00000000 00000000 c22da40c 00000bf4
       00000000 c1223000 00000000 00000280 001444af c723e19c 00000282 c0129e66
Call Trace:
 [<c88dfc4e>] journal_commit_transaction+0xce2/0xf80 [jbd]
 [<c029d175>] __sched_text_start+0x675/0x73b
 [<c0129e66>] lock_timer_base+0x15/0x2f
 [<c88e2eed>] kjournald+0xa3/0x1d4 [jbd]
 [<c01328e9>] autoremove_wake_function+0x0/0x35
 [<c88e2e4a>] kjournald+0x0/0x1d4 [jbd]
 [<c013281e>] kthread+0xb2/0xdc
 [<c013276c>] kthread+0x0/0xdc
 [<c01049a7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 5f c3 57 89 d7 8d 92 00 00 00 40 89 c1 c1 ea 0c c1 e2 05 03 15
60 03 3b c0 56 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 <0f>
0b eb fe 39 4a 18 74 04 0f 0b eb fe 9c 58 fa 90 8d b4 26 00
EIP: [<c0163ecf>] kmem_cache_free+0x29/0x7c SS:ESP 0068:c7dd3f1c

full dmesg follow

Linux version 2.6.21-2-686 (Debian 2.6.21-6) (waldi@debian.org) (gcc
version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Wed Jul
11 03:53:02 UTC 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end:
00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 0000000000e00000 end:
0000000000f00000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 0000000000f00000 size: 0000000000100000 end:
0000000001000000 type: 2
copy_e820_map() start: 0000000001000000 size: 0000000006f00000 end:
0000000007f00000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end:
0000000100000000 type: 2
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
early_node_map[1] active PFN ranges
    0:        0 ->    32512
On node 0 totalpages: 32512
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 222 pages used for memmap
  Normal zone: 28194 pages, LIFO batch:7
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
Allocating PCI resources starting at 10000000 (gap: 07f00000:f7c00000)
Built 1 zonelists.  Total pages: 32258
Kernel command line: root=/dev/hdc1 ro
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01109000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 797.383 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 118924k/130048k available (1661k kernel code, 9608k reserved,
636k data, 212k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc8800000 - 0xff7fe000   ( 879 MB)
    lowmem  : 0xc0000000 - 0xc7f00000   ( 127 MB)
      .init : 0xc0345000 - 0xc037a000   ( 212 kB)
      .data : 0xc029f5e5 - 0xc033e834   ( 636 kB)
      .text : 0xc0100000 - 0xc029f5e5   (1661 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1596.13 BogoMIPS (lpj=3192266)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 128K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040
00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI Exception (tbxface-0618): AE_NO_ACPI_TABLES, While loading
namespace from ACPI tables [20070126]
ACPI: Unable to load the System Description Tables
CPU0: Intel Celeron (Coppermine) stepping 06
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
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
Boot video device is 0000:00:01.0
PCI quirk: region 4000-407f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 4080-40bf claimed by ICH4 GPIO
PCI: Firmware left 0000:01:0a.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:01:0b.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2410] at 0000:00:1f.0
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:01:0b.0
NET: Registered protocol family 8
NET: Registered protocol family 20
Time: tsc clocksource has been installed.
pnp: 00:08: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:08: iomem range 0xffb00000-0xffb7ffff could not be reserved
pnp: 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:08: iomem range 0xfee00000-0xfee0ffff has been reserved
pnp: 00:09: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:09: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:09: iomem range 0xf8000-0xfffff could not be reserved
pnp: 00:09: iomem range 0xca000-0xcffff has been reserved
PCI: Ignore bogus resource 6 [0:0] of 0000:00:01.0
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: d4000000-d5ffffff
  PREFETCH window: 10000000-101fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 49152 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5562k freed
audit: initializing netlink socket (disabled)
audit(1193640889.648:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:10: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 212k freed
input: AT Translated Set 2 keyboard as /class/input/input0
thermal: Unknown symbol acpi_processor_set_thermal_limit
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH: IDE controller at PCI slot 0000:00:1f.1
ICH: chipset revision 2
ICH: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: Maxtor 6L200P0, ATA DISK drive
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hdb: SAMSUNG SP0802N, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: Maxtor 6Y080L0, ATA DISK drive
hdd: ATAPI-CD ROM-DRIVE-52MAX, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:01:0a.0
e100: eth0: e100_probe: addr 0xd5201000, irq 11, MAC addr 00:AE:A0:00:07:A4
PCI: Found IRQ 10 for device 0000:01:0b.0
PCI: Sharing IRQ 10 with 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
e100: eth1: e100_probe: addr 0xd5200000, irq 10, MAC addr 00:AE:A0:00:07:A5
SCSI subsystem initialized
libata version 2.20 loaded.
hda: max request size: 512KiB
hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63, UDMA(66)
hda: cache flushes supported
 hda: hda1
hdb: max request size: 512KiB
hdb: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(66)
hdb: cache flushes supported
 hdb: hdb1
hdc: max request size: 128KiB
hdc: 160086528 sectors (81964 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(66)
hdc: cache flushes supported
 hdc: hdc1 hdc2 < hdc5 >
hdd: ATAPI 52X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
md: linear personality registered for level -1
md: md2 stopped.
md: bind<hdb1>
md: bind<hda1>
Attempting manual resume
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.102 (c) Dave Jones
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
agpgart: Detected an Intel i810 E Chipset.
agpgart: AGP aperture is 64M @ 0xd0000000
Intel 82802 RNG detected
PCI: Found IRQ 10 for device 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:01:0b.0
PCI: Found IRQ 10 for device 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:01:0b.0
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 54996 usecs
intel8x0: clocking to 48000
input: PC Speaker as /class/input/input1
Intel 810 + AC97 Audio, version 1.01, 03:46:36 Jul 11 2007
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Real Time Clock Driver v1.12ac
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Adding 353388k swap on /dev/hdc5.  Priority:-1 extents:1 across:353388k
EXT3 FS on hdc1, internal journal
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on md2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 15
e100: eth1: e100_watchdog: link up, 10Mbps, half-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ip_tables: (C) 2000-2006 Netfilter Core Team
eth1: no IPv6 routers present
eth0: no IPv6 routers present
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (1016 buckets, 8128 max)
ip6_tables: (C) 2000-2006 Netfilter Core Team
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
------------[ cut here ]------------
kernel BUG at mm/slab.c:597!
invalid opcode: 0000 [#1]
SMP
Modules linked in: nfs nf_conntrack_ftp nfsd exportfs lockd nfs_acl
sunrpc ipt_MASQUERADE ipt_LOG ip6table_filter ip6_tables xt_state
xt_tcpmss xt_tcpudp ipt_addrtype xt_pkttype iptable_raw xt_CLASSIFY
xt_CONNMARK xt_MARK xt_comment ipt_REJECT xt_length xt_connmark
ipt_owner ipt_recent ipt_iprange xt_physdev xt_policy xt_multiport
xt_conntrack iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nfnetlink iptable_filter ip_tables x_tables ipv6 deflate
zlib_deflate twofish twofish_common serpent blowfish des cbc ecb
blkcipher aes xcbc sha256 sha1 crypto_null af_key dm_snapshot
dm_mirror dm_mod psmouse ide_generic parport_pc parport rtc shpchp
pci_hotplug i810_audio ac97_codec pcspkr snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm snd_timer snd soundcore i2c_i801 intel_rng intel_agp
snd_page_alloc i2c_core iTCO_wdt agpgart evdev ext3 jbd mbcache linear
md_mod ide_cd cdrom ide_disk ata_generic libata scsi_mod floppy e100
mii piix generic ide_core
CPU:    0
EIP:    0060:[<c0163ecf>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-2-686 #1)
EIP is at kmem_cache_free+0x29/0x7c
eax: 00000000   ebx: c20177bc   ecx: c71532a0   edx: c2800000
esi: c1b213c8   edi: 80000000   ebp: c7317600   esp: c7dd3f1c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kjournald (pid: 2007, ti=c7dd2000 task=c723e090 task.ti=c7dd2000)
Stack: c20177bc c1b213c8 c15c2f40 c88dfc4e 00001be7 00000000 c2a83fb0 c029d175
       c7dd3f9c c2b26800 00000000 c1223000 00000000 00000000 c22da40c 00000bf4
       00000000 c1223000 00000000 00000280 001444af c723e19c 00000282 c0129e66
Call Trace:
 [<c88dfc4e>] journal_commit_transaction+0xce2/0xf80 [jbd]
 [<c029d175>] __sched_text_start+0x675/0x73b
 [<c0129e66>] lock_timer_base+0x15/0x2f
 [<c88e2eed>] kjournald+0xa3/0x1d4 [jbd]
 [<c01328e9>] autoremove_wake_function+0x0/0x35
 [<c88e2e4a>] kjournald+0x0/0x1d4 [jbd]
 [<c013281e>] kthread+0xb2/0xdc
 [<c013276c>] kthread+0x0/0xdc
 [<c01049a7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 5f c3 57 89 d7 8d 92 00 00 00 40 89 c1 c1 ea 0c c1 e2 05 03 15
60 03 3b c0 56 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 <0f>
0b eb fe 39 4a 18 74 04 0f 0b eb fe 9c 58 fa 90 8d b4 26 00
EIP: [<c0163ecf>] kmem_cache_free+0x29/0x7c SS:ESP 0068:c7dd3f1c


-- 
"Reality continues to ruin my life." - Calvin.
