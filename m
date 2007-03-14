Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXCNSgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXCNSgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbXCNSgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:36:24 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:42314 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXCNSgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:36:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Date: Wed, 14 Mar 2007 12:36:09 -0600
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703141052.19792.bjorn.helgaas@hp.com> <20070314172141.GA17891@skynet.ie>
In-Reply-To: <20070314172141.GA17891@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141236.09599.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 11:21, Mel Gorman wrote:
> Can you tell me if the faulting line was at the check for PageBuddy?

I don't know, sorry.

> Can you 
> also apply the following patch and boot with loglevel=8 please? The
> patch moves the check for pfn_valid() before PageBuddy() is called.

Boots fine with this patch:


Linux version 2.6.21-rc3-mm2 (helgaas@tiger) (gcc version 4.0.3 (Debian 4.0.3-1)) #8 SMP Wed Mar 14 11:34:23 MST 2007
EFI v1.10 by HP: SALsystab=0x3fb38000 ACPI 2.0=0x3fb2e000 SMBIOS=0x3fb3a000 HCDP=0x3fb2c000
booting generic kernel on platform hpzx1
PCDP: v0 at 0x3fb2c000
Explicit "console="; ignoring PCDP
Early serial console at MMIO 0xff5e0000 (options '115200')
ACPI: RSDP 3FB2E000, 0028 (r2     HP)
ACPI: XSDT 3FB2E02C, 0094 (r1     HP   zx6000        0   HP        0)
ACPI: FACP 3FB36800, 00F4 (r3     HP   zx6000        0   HP        0)
ACPI: DSDT 3FB2E0E0, 5781 (r1     HP   zx6000        7 INTL  2012044)
ACPI: FACS 3FB368F8, 0040
ACPI: SPCR 3FB36938, 0050 (r1     HP   zx6000        0   HP        0)
ACPI: DBGP 3FB36988, 0034 (r1     HP   zx6000        0   HP        0)
ACPI: APIC 3FB36A48, 00B0 (r1     HP   zx6000        0   HP        0)
ACPI: SPMI 3FB369C0, 0050 (r4     HP   zx6000        0   HP        0)
ACPI: CPEP 3FB36A10, 0034 (r1     HP   zx6000        0   HP        0)
ACPI: SSDT 3FB33870, 01D6 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB33A50, 0342 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB33DA0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB347C0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB351E0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB35C00, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB36620, 00EB (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB36710, 00EF (r1     HP   zx6000        6 INTL  2012044)
SAL 3.1: HP version 2.31
SAL Platform features: None
SAL: AP wakeup using external interrupt vector 0xff
No logical to physical processor mapping available
ACPI: Local APIC address c0000000fee00000
GSI 36 (level, low) -> CPU 0 (0x0000) vector 48
2 CPUs available, 2 CPUs total
MCA related initialization done
Virtual mem_map starts at 0xa0007fffc7200000
Zone PFN ranges:
  DMA          1024 ->   262144
  Normal     262144 -> 17039360
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0:     1024 ->    64889
    0:    65216 ->    65227
    0: 16842752 -> 17039194
    0: 17039209 -> 17039236
    0: 17039264 -> 17039343
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Built 1 zonelists.  Total pages: 202189
Kernel command line: BOOT_IMAGE=net0:/helgaas/ia64/vmlinux.gz root=/dev/sda2 console=uart,mmio,0xff5e0000 loglevel=8 debug ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
CPU 0: base freq=200.000MHz, ITC ratio=9/2, ITC freq=900.000MHz+/-450ppm
Console: colour VGA+ 80x25
Memory: 4070112k/4150976k available (7303k code, 96672k reserved, 5072k data, 1856k init)
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff900000 end_page 0xa0007fffffc80000
Leaving McKinley Errata 9 workaround enabled
Calibrating delay loop... 1347.58 BogoMIPS (lpj=2695168)
Dentry cache hash table entries: 524288 (order: 8, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 7, 2097152 bytes)
Mount-cache hash table entries: 1024
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff900000 end_page 0xa0007fffffc80000
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff580000 end_page 0xa0007fffff900000
ACPI: Core revision 20070126
Boot processor id 0x0/0x0
Fixed BSP b0 value from CPU 1
CPU 1: synchronized ITC with CPU 0 (last diff -4 cycles, maxerr 435 cycles)
CPU 1: base freq=200.000MHz, ITC ratio=9/2, ITC freq=900.000MHz+/-450ppm
Calibrating delay loop... 1347.58 BogoMIPS (lpj=2695168)
Brought up 2 CPUs
Total of 2 processors activated (2695.16 BogoMIPS).
migration_cost=1877
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: Interpreter enabled
ACPI: Using IOSAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Firmware left 0000:00:03.0 e100 interrupts enabled, disabling
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:20)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:40)
Boot video device is 0000:41:05.0
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI2._PRT]
ACPI: PCI Root Bridge [PCI3] (0000:60)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI3._PRT]
ACPI: PCI Root Bridge [PCI4] (0000:80)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI4._PRT]
ACPI: PCI Root Bridge [PCI6] (0000:c0)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI6._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
GSI 34 (edge, high) -> CPU 1 (0x0100) vector 49
GSI 35 (edge, high) -> CPU 0 (0x0000) vector 50
pnp: PnP ACPI: found 10 devices
SCSI subsystem initialized
IOC: zx1 2.2 HPA 0xfed01000 IOVA space 1024Mb at 0x40000000
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 6, 1048576 bytes)
TCP established hash table entries: 524288 (order: 9, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 6, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Total HugeTLB memory allocated, 0
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
EFI Time Services Driver v0.4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:04: ttyS0 at MMIO 0xff5e0000 (irq = 49) is a 16550A
00:05: ttyS1 at MMIO 0xff5e2000 (irq = 50) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
tg3.c:v3.74 (February 20, 2007)
GSI 29 (level, low) -> CPU 1 (0x0100) vector 51
ACPI: PCI Interrupt 0000:20:02.0[A] -> GSI 29 (level, low) -> IRQ 51
eth0: Tigon3 [partno(BCM95700A6) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:30:6e:38:d9:67
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0] 
eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
CMD649: IDE controller at PCI slot 0000:00:02.0
GSI 21 (level, low) -> CPU 0 (0x0000) vector 52
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 21 (level, low) -> IRQ 52
CMD649: chipset revision 2
CMD649: 100% native mode on irq 52
    ide0: BM-DMA at 0x0d40-0x0d47, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: DW-28E, ATAPI CD/DVD-ROM drive
hda: selected mode 0x42
ide0 at 0xd58-0xd5f,0xd66 on irq 52
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 1698kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
GSI 27 (level, low) -> CPU 1 (0x0100) vector 53
ACPI: PCI Interrupt 0000:20:01.0[A] -> GSI 27 (level, low) -> IRQ 53
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030, FwRev=01032300h, Ports=1, MaxQ=255, IRQ=53
scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP04 PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
move_freepages: zone DMA zone_start_pfn 0x400 start_page 0xa0007fffc72e0000 end_page 0xa0007fffc7580000
SCSI device sda: 71132960 512-byte hdwr sectors (36420 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sda: 71132960 512-byte hdwr sectors (36420 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP04 PQ: 0 ANSI: 2
 target0:0:1: Beginning Domain Validation
 target0:0:1: Ending Domain Validation
 target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
SCSI device sdb: 71132960 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: 9f 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sdb: 71132960 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: 9f 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3
sd 0:0:1:0: Attached scsi disk sdb
GSI 28 (level, low) -> CPU 0 (0x0000) vector 54
ACPI: PCI Interrupt 0000:20:01.1[B] -> GSI 28 (level, low) -> IRQ 54
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator,Target}
scsi1 : ioc1: LSI53C1030, FwRev=01032300h, Ports=1, MaxQ=255, IRQ=54
scsi 1:0:2:0: Direct-Access     HP 36.4G ST336732LC       HPE3 PQ: 0 ANSI: 2
 target1:0:2: Beginning Domain Validation
 target1:0:2: Ending Domain Validation
 target1:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
SCSI device sdc: 71132960 512-byte hdwr sectors (36420 MB)
sdc: Write Protect is off
sdc: Mode Sense: ab 00 10 08
SCSI device sdc: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sdc: 71132960 512-byte hdwr sectors (36420 MB)
sdc: Write Protect is off
sdc: Mode Sense: ab 00 10 08
SCSI device sdc: write cache: disabled, read cache: enabled, supports DPO and FUA
 sdc: sdc1
sd 1:0:2:0: Attached scsi disk sdc
mice: PS/2 mouse device common for all mice
async_tx: api initialized (sync-only)
xor: measuring software checksumming speed
   ia64      :  2552.000 MB/sec
xor: using function: ia64 (2552.000 MB/sec)
EFI Variables Facility v0.08 2004-May-17
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Adding console on ttyS0 at MMIO 0xff5e0000 (options '115200')
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 1856kB freed
Failed to mount /selinux/: No such file or directory
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...done.
Activating swap...
Adding 1473632k swap on /dev/sda3.  Priority:-1 extents:1 across:1473632k
.
Checking root file system.../: clean, 63130/4251520 files, 647612/8498779 blocks
.
EXT3 FS on sda2, internal journal
Cleaning up ifupdown...done.
[33m*[39;49m Not running depmod because /lib/modules/2.6.21-rc3-mm2/ is not writeable.
Loading modules...
    psmouse
FATAL: Could not load /lib/modules/2.6.21-rc3-mm2/modules.dep: No such file or directory
    sd_mod
FATAL: Could not load /lib/modules/2.6.21-rc3-mm2/modules.dep: No such file or directory
All modules loaded.
FATAL: Could not load /lib/modules/2.6.21-rc3-mm2/modules.dep: No such file or directory
Setting the System Clock using the Hardware Clock as reference
System Clock set. Local time: Wed Mar 14 18:59:39 UTC 2007
.
Checking all file systems....
Setting kernel variables ...
... done.
Mounting local filesystems... [31mfailed![39;49m
Cleaning /tmp....
Cleaning /var/run ....
Cleaning /var/lock ....
Detecting hardware...Discovered hardware for these modules: e100 tg3 cmd64x mptscsih usb_ohci ehci_hcd
[33m*[39;49m Skipping unavailable/built-in e100 module.
[33m*[39;49m Skipping unavailable/built-in tg3 module.
[33m*[39;49m Skipping unavailable/built-in cmd64x module.
[33m*[39;49m Skipping unavailable/built-in mptscsih module.
[33m*[39;49m Skipping unavailable/built-in ohci_hcd module.
[33m*[39;49m Skipping unavailable/built-in ehci_hcd module.
Setting up networking...done.
hostname: the specified hostname is invalid
[33m*[39;49m /etc/network/options is deprecated.
Setting up IP spoofing protection...done (rp_filter).
Configuring network interfaces...Internet Software Consortium DHCP Client 2.0pl5
Copyright 1995, 1996, 1997, 1998, 1999 The Internet Software Consortium.
All rights reserved.

Please contribute if you find this software useful.
For info, please visit http://www.isc.org/dhcp-contrib.html

PM: Writing back config space on device 0000:20:02.0 at offset b (was 164514e4, writing 12a4103c)
PM: Writing back config space on device 0000:20:02.0 at offset 3 (was 0, writing c020)
PM: Writing back config space on device 0000:20:02.0 at offset 2 (was 2000000, writing 2000015)
PM: Writing back config space on device 0000:20:02.0 at offset 1 (was 2b00000, writing 2b00146)
BUG: at drivers/pci/pci.c:679 pci_restore_state()

Call Trace:
 [<a000000100014980>] show_stack+0x40/0xa0
                                sp=e000004063a5fb90 bsp=e000004063a58f98
 [<a0000001000152b0>] dump_stack+0x30/0x60
                                sp=e000004063a5fd60 bsp=e000004063a58f80
 [<a0000001003f8800>] pci_restore_state+0x480/0x4a0
                                sp=e000004063a5fd60 bsp=e000004063a58f38
 [<a00000010051a0b0>] tg3_chip_reset+0x6d0/0x1020
                                sp=e000004063a5fd70 bsp=e000004063a58ef0
 [<a00000010051b190>] tg3_reset_hw+0xb0/0x3e20
                                sp=e000004063a5fd80 bsp=e000004063a58e90
 [<a00000010051efb0>] tg3_init_hw+0xb0/0xe0
                                sp=e000004063a5fdc0 bsp=e000004063a58e68
 [<a000000100523af0>] tg3_open+0x690/0xe00
                                sp=e000004063a5fdc0 bsp=e000004063a58e10
 [<a000000100647f90>] dev_open+0xf0/0x1e0
                                sp=e000004063a5fdd0 bsp=e000004063a58de0
 [<a000000100645c00>] dev_change_flags+0xc0/0x240
                                sp=e000004063a5fdd0 bsp=e000004063a58da0
 [<a0000001006df200>] devinet_ioctl+0x5a0/0xfe0
                                sp=e000004063a5fdd0 bsp=e000004063a58d40
 [<a0000001006dfdd0>] inet_ioctl+0x190/0x240
                                sp=e000004063a5fe10 bsp=e000004063a58d10
 [<a00000010062cf00>] sock_ioctl+0x5c0/0x620
                                sp=e000004063a5fe10 bsp=e000004063a58ce0
 [<a000000100172cb0>] do_ioctl+0x90/0x180
                                sp=e000004063a5fe10 bsp=e000004063a58ca0
 [<a000000100173650>] vfs_ioctl+0x8b0/0x920
                                sp=e000004063a5fe10 bsp=e000004063a58c58
 [<a000000100173720>] sys_ioctl+0x60/0xc0
                                sp=e000004063a5fe20 bsp=e000004063a58bd8
 [<a00000010000c180>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000004063a5fe30 bsp=e000004063a58bd8
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000004063a60000 bsp=e000004063a58bd8
Listening on LPF/eth0/00:30:6e:38:d9:67
Sending on   LPF/eth0/00:30:6e:38:d9:67
Sending on   Socket/fallback/fallback-net
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
DHCPOFFER from 10.0.0.1
DHCPREQUEST on eth0 to 255.255.255.255 port 67
DHCPACK from 10.0.0.1
bound to 10.100.100.194 -- renewal in 129600 seconds.
done.
Starting portmap daemon: portmap.
Setting the System Clock using the Hardware Clock as reference
System Clock set. Local time: Wed Mar 14 18:59:57 UTC 2007
.
Initializing random number generator....
Recovering nvi editor sessions... done.
Setting up X server socket directory /tmp/.X11-unix...done.
Setting up ICE socket directory /tmp/.ICE-unix...done.
INIT: Entering runlevel: 2
Starting system log daemon: syslogd.
Starting kernel log daemon: klogd.
Not starting portmap daemon.  Already running.
Loading ACPI modules:
Starting Advanced Configuration and Power Interface daemon: acpid.
Starting system message bus: dbus-1.
Starting Hardware abstraction layer: hald.
Starting MTA: exim4.
Starting internet superserver: inetd.
Starting printer spooler: lpd .
Starting OpenBSD Secure Shell server: sshd.
Starting file alteration monitor: FAM.
Starting NFS common utilities: statd.
Starting deferred execution scheduler: atd.
Starting periodic command scheduler: cron.
Starting GNOME Display Manager: gdm.

Debian GNU/Linux testing/unstable lp.helgaas ttyS0

lp.helgaas login: 

