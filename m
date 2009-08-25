Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZHYOD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZHYOD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZHYOD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:03:27 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:2220 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZHYODZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:03:25 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 10:03:24 EDT
Date: Tue, 25 Aug 2009 15:55:21 +0200 (CEST)
From: =?ISO-8859-2?Q?Pawe=B3_Go=B3aszewski?= <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: oops 
Message-ID: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-1123602371-1251208521=:16876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-1123602371-1251208521=:16876
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


No matter which kernel I'm using (2.6.27 - 2.6.30) it crashes. Works for 
few minutes and crashes. Even SysRq doesn't work.

Dunno how to trigger it on other machine than mine (I have two, both 
affected). If more info is required - just ask.
[...]
[24483.211036] BUG: unable to handle kernel NULL pointer dereference at 00000058
[24483.211144] IP: [<c081cf9a>] pick_next_task_fair+0x6a/0x100
[24483.211247] Oops: 0000 [#1] SMP 
[24483.211300] Modules linked in: netconsole configfs dm_mod softdog sch_sfq xfs raid10 uhci_hcd eepro100 ppdev parport_pc floppy parport ehci_hcd e100 piix i2c_piix4 thermal psmouse e1000 container ide_core usbcore mii button pcspkr serio_raw processor i2c_core sg evdev ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[24483.211878] 
[24483.211910] Pid: 1677, comm: md2_raid10 Not tainted (2.6.27.31-1 #1)
[24483.211952] EIP: 0060:[<c081cf9a>] EFLAGS: 00010046 CPU: 2
[24483.211996] EIP is at pick_next_task_fair+0x6a/0x100
[24483.212032] EAX: c1d941e0 EBX: c1d9421c ECX: 00000000 EDX: 00000000
[24483.212073] ESI: 00000000 EDI: 00000000 EBP: c1d941e0 ESP: f71b7ebc
[24483.212115]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[24483.212153] Process md2_raid10 (pid: 1677, ti=f71b6000 task=f709c600 task.ti=f71b6000)
[24483.212196] Stack: 00000000 00000000 c1d941e0 c1d941e0 c0acbf00 c1d94690 00000000 c1d941e0 
[24483.212323]        c0a9cb29 f8a34b2c f72b1000 00000286 f8a35452 00000000 f709c600 c1d941e0 
[24483.212451]        c1d94690 00001644 00000002 c1d8f688 c1d8f684 00000000 000021e0 f709c794 
[24483.212577] Call Trace:
[24483.212626]  [<c0a9cb29>] schedule+0x5b9/0xc20
[24483.212697]  [<f8a34b2c>] cleanup_module+0x271c/0x47db [raid10]
[24483.212755]  [<f8a35452>] cleanup_module+0x3042/0x47db [raid10]
[24483.212805]  [<c0a9d50d>] schedule_timeout+0xbd/0xf0
[24483.212853]  [<c0804d53>] common_interrupt+0x23/0x30
[24483.212911]  [<f882d543>] md_register_thread+0x153/0x180 [md_mod]
[24483.212982]  [<c083bcd0>] autoremove_wake_function+0x0/0x40
[24483.213056]  [<f882d490>] md_register_thread+0xa0/0x180 [md_mod]
[24483.213111]  [<c083ba29>] kthread+0x39/0x70
[24483.213156]  [<c083b9f0>] kthread+0x0/0x70
[24483.213199]  [<c0805007>] kernel_thread_helper+0x7/0x10
[24483.213249]  =======================
[24483.213281] Code: 8b 4e 1c 85 c9 75 7f 8b 43 44 8b 90 18 04 00 00 8b 80 14 04 00 00 89 56 24 89 46 20 89 73 38 8b 46 28 8b 56 2c 89 46 38 89 56 3c <8b> 5e 58 85 db 74 67 8b 4b 28 31 f6 85 c9 74 f0 8b 73 44 8b 53 
[24483.213899] EIP: [<c081cf9a>] pick_next_task_fair+0x6a/0x100 SS:ESP 0068:f71b7ebc
[24483.214257] ---[ end trace c9dd311f4b324acb ]---
[...]

There is some bugs catched too:
[  493.923295] BUG: soft lockup - CPU#0 stuck for 61s! [md2_raid10:1672]
[  493.923295] Modules linked in: softdog sch_sfq xfs raid10 uhci_hcd eepro100 ppdev parport_pc parport ehci_hcd floppy i2c_piix4 psmouse piix e100 thermal serio_raw e1000 container i2c_core mii usbcore pcspkr evdev ide_core sg button processor ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[  493.923295] 
[  493.923295] Pid: 1672, comm: md2_raid10 Not tainted (2.6.27.31-1 #1)
[  493.923295] EIP: 0060:[<f8a38ff5>] EFLAGS: 00010282 CPU: 0
[  493.923295] EIP is at cleanup_module+0x2be5/0x47db [raid10]
[  493.923295] EAX: f411c000 EBX: f2305c60 ECX: 000005bf EDX: 0000000d
[  493.923295] ESI: f411ca41 EDI: f1dffa41 EBP: 0000009c ESP: f71f3ef0
[  493.923295]  DS: 0068 ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  493.923295] CR0: 8005003b CR2: 080bd054 CR3: 36461000 CR4: 000006d0
[  493.923295] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  493.923295] DR6: ffff0ff0 DR7: 00000400
[  493.923295]  [<c09e7c57>] ? net_rx_action+0x127/0x200
[  493.923295]  [<c0a9d50d>] ? schedule_timeout+0xbd/0xf0
[  493.923295]  [<c0804d53>] ? common_interrupt+0x23/0x30
[  493.923295]  [<c083be41>] ? finish_wait+0x31/0x80
[  493.923295]  [<f882d4b9>] ? md_register_thread+0xc9/0x180 [md_mod]
[  493.923295]  [<c083bcd0>] ? autoremove_wake_function+0x0/0x40
[  493.923295]  [<f882d490>] ? md_register_thread+0xa0/0x180 [md_mod]
[  493.923295]  [<c083ba29>] ? kthread+0x39/0x70
[  493.923295]  [<c083b9f0>] ? kthread+0x0/0x70
[  493.923295]  [<c0805007>] ? kernel_thread_helper+0x7/0x10
[  493.923295]  =======================



# cat /proc/mdstat
Personalities : [raid1] [raid10] 
md2 : active raid10 sda2[0] sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1]
      834929664 blocks 64K chunks 2 far-copies [6/6] [UUUUUU]
      [=>...................]  resync =  7.9% (66705088/834929664) finish=1816.4min speed=7046K/sec
      
md1 : active raid1 sde1[0] sdf1[2](S) sdd1[1]
      14651136 blocks [2/2] [UU]
      
md0 : active raid1 sda1[0] sdc1[2](S) sdb1[1]
      14651136 blocks [2/2] [UU]
      
unused devices: <none>

# mount
/dev/md0 on / type ext3 (rw)
none on /proc type proc (rw,gid=17)
usbfs on /proc/bus/usb type usbfs (rw,devgid=78,devmode=664)
sysfs on /sys type sysfs (rw)
securityfs on /sys/kernel/security type securityfs (rw)
none on /dev/cpuset type cgroup (rw,cpuset,noprefix)
/dev/md1 on /vservers type ext3 (rw)
/dev/md2 on /vservers/news/srv type xfs (rw,noatime)
/vservers/news/srv/spool on /vservers/news/var/spool/news type none (rw,bind)
/vservers/news/srv/lib on /vservers/news/var/lib/news type none (rw,bind)
none on /dev/pts type devpts (rw,gid=5,mode=620)
none on /dev/shm type tmpfs (rw,noexec,nosuid,nodev,mode=1777)

# cat /proc/version
Linux version 2.6.27.31-1 (blues@carme-pld-i686) (gcc version 4.4.1 20090724 (release) (PLD-Linux) ) #1 SMP Fri Aug 21 23:19:19 CEST 2009


4 processors (right now only one left for testing):
# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 10
model name	: Pentium III (Cascades)
stepping	: 1
cpu MHz		: 700.184
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1400.71
clflush size	: 32
power management:

# lspci 
00:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c810 (rev 23)
00:09.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
00:0a.0 VGA compatible controller: Cirrus Logic GD 5480 (rev 23)
00:0b.0 PIC: Intel Corporation 683053 Programmable Interrupt Device
00:0c.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:0c.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:0c.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:0c.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:10.0 Host bridge: Intel Corporation 450NX - 82451NX Memory & I/O Controller (rev 03)
00:12.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 04)
00:13.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 04)
01:01.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller
01:02.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
01:02.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53C896/897 (rev 07)
01:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53C896/897 (rev 07)


# dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27.31-1 (blues@carme-pld-i686) (gcc version 4.4.1 20090724 (release) (PLD-Linux) ) #1 SMP Fri Aug 21 23:19:19 CEST 2009
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fffa800 (usable)
[    0.000000]  BIOS-e820: 000000005fffa800 - 000000005ffffc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000005ffffc00 - 0000000060000000 (ACPI NVS)
[    0.000000] DMI 2.1 present.
[    0.000000] last_pfn = 0x5fffa max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] RAMDISK: 00e6c000 - 00eff13b
[    0.000000] 639MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00009000 - 00010000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 0000c8b120]    TEXT DATA BSS ==> [0000200000 - 0000c8b120]
[    0.000000]   #4 [0000e6c000 - 0000eff13b]          RAMDISK ==> [0000e6c000 - 0000eff13b]
[    0.000000]   #5 [0000c8c000 - 0000c91000]    INIT_PG_TABLE ==> [0000c8c000 - 0000c91000]
[    0.000000]   #6 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f6b30] 000f6b30
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0005fffa
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0005fffa
[    0.000000] On node 0 totalpages: 393112
[    0.000000]   DMA zone: 3962 pages, LIFO batch:0
[    0.000000]   Normal zone: 223300 pages, LIFO batch:31
[    0.000000]   HighMem zone: 162394 pages, LIFO batch:31
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: INTEL   
[    0.000000] MPTABLE: Product ID: S450NX      
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #3 (Bootup-CPU)
[    0.000000] Processor #0
[    0.000000] Processor #1
[    0.000000] Processor #2
[    0.000000] I/O APIC #4 Version 19 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:a0000000)
[    0.000000] PERCPU: Allocating 18108 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 389656
[    0.000000] Kernel command line: BOOT_IMAGE=testing ro root=900 noapic nolapic acpi=off
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: Using PIT calibration value
[    0.000000] Detected 700.184 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 1545280k/1572840k available (2700k kernel code, 26172k reserved, 452k data, 6116k init, 655336k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xffdf9000 - 0xfffff000   (2072 kB)
[    0.003333]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc0207000 - 0xc0800000   (6116 kB)
[    0.003333]       .data : 0xc0ba2000 - 0xc0c133cc   ( 452 kB)
[    0.003333]       .text : 0xc0800000 - 0xc0aa3060   (2700 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.003373] Calibrating delay loop (skipped), value calculated using timer frequency.. 1400.71 BogoMIPS (lpj=2333946)
[    0.003567] Security Framework initialized
[    0.003672] SELinux:  Disabled at boot.
[    0.003782] Mount-cache hash table entries: 512
[    0.004521] Initializing cgroup subsys ns
[    0.004593] Initializing cgroup subsys cpuacct
[    0.004655] Initializing cgroup subsys memory
[    0.004721] Initializing cgroup subsys devices
[    0.004836] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.004935] CPU: L2 cache: 1024K
[    0.004998] CPU serial number disabled.
[    0.005062] Intel machine check architecture supported.
[    0.005126] Intel machine check reporting enabled on CPU#0.
[    0.005227] Checking 'hlt' instruction... OK.
[    0.017889] BIOS bug, local APIC #3 not detected!...
[    0.017955] ... forcing use of dummy APIC emulation.(tell your hw vendor)
[    0.018018] SMP disabled
[    0.018309] Brought up 1 CPUs
[    0.018370] Total of 1 processors activated (1400.71 BogoMIPS).
[    0.019217] net_namespace: 840 bytes
[    0.019567] NET: Registered protocol family 16
[    0.020639] EISA bus registered
[    0.030160] bios32_service: base:000fd690 length:00000970 entry:000004b4
[    0.030240] PCI: PCI BIOS revision 2.10 entry at 0x4b4, last bus=1
[    0.030304] PCI: Using configuration type 1 for base access
[    0.033113] ACPI: Interpreter disabled.
[    0.033180] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.033368] pnp: PnP ACPI: disabled
[    0.033433] PnPBIOS: Scanning system for PnP BIOS support...
[    0.033525] PnPBIOS: Found PnP BIOS installation structure at 0xc00f6d90
[    0.033593] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xb2cb, dseg 0x400
[    0.039822] PnPBIOS: 20 nodes reported by PnP BIOS; 20 recorded by driver
[    0.040903] PCI: Probing PCI hardware
[    0.040968] PCI: Probing PCI hardware (bus 00)
[    0.041189] PCI: 0000:00:08.0 reg 10 io port: [2000, 20ff]
[    0.041204] PCI: 0000:00:08.0 reg 14 32bit mmio: [fa102000, fa1020ff]
[    0.041320] PCI: 0000:00:09.0 reg 10 32bit mmio: [fa100000, fa100fff]
[    0.041334] PCI: 0000:00:09.0 reg 14 io port: [2400, 243f]
[    0.041348] PCI: 0000:00:09.0 reg 18 32bit mmio: [fa000000, fa0fffff]
[    0.041379] PCI: 0000:00:09.0 reg 30 32bit mmio: [0, fffff]
[    0.041415] pci 0000:00:09.0: supports D1
[    0.041421] pci 0000:00:09.0: supports D2
[    0.041428] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot
[    0.041497] pci 0000:00:09.0: PME# disabled
[    0.041581] PCI: 0000:00:0a.0 reg 10 32bit mmio: [fc000000, fdffffff]
[    0.041596] PCI: 0000:00:0a.0 reg 14 32bit mmio: [fa101000, fa101fff]
[    0.041633] PCI: 0000:00:0a.0 reg 30 32bit mmio: [0, 7fff]
[    0.041850] PCI: 0000:00:0c.1 reg 20 io port: [2460, 246f]
[    0.041939] PCI: 0000:00:0c.2 reg 20 io port: [2440, 245f]
[    0.041989] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    0.041993] * this clock source is slow. Consider trying other clock sources
[    0.042193] pci 0000:00:0c.3: quirk: region 0c00-0c3f claimed by PIIX4 ACPI
[    0.042263] pci 0000:00:0c.3: quirk: region 0cc0-0ccf claimed by PIIX4 SMB
[    0.042334] pci 0000:00:0c.3: PIIX4 devres B PIO at 0ca2-0ca3
[    0.042400] pci 0000:00:0c.3: PIIX4 devres C PIO at 0ca0-0ca1
[    0.042544] pci 0000:00:10.0: Searching for i450NX host bridges
[    0.042811] PCI: 0000:01:01.0 reg 10 32bit mmio: [fe040000, fe05ffff]
[    0.042826] PCI: 0000:01:01.0 reg 14 32bit mmio: [fe020000, fe03ffff]
[    0.042840] PCI: 0000:01:01.0 reg 18 io port: [3c00, 3c3f]
[    0.042872] PCI: 0000:01:01.0 reg 30 32bit mmio: [0, 1ffff]
[    0.042925] pci 0000:01:01.0: PME# supported from D0 D3hot D3cold
[    0.042993] pci 0000:01:01.0: PME# disabled
[    0.043093] PCI: 0000:01:02.0 reg 10 io port: [3000, 30ff]
[    0.043113] PCI: 0000:01:02.0 reg 14 64bit mmio: [fe004000, fe004fff]
[    0.043145] PCI: 0000:01:02.0 reg 30 32bit mmio: [0, 1ffff]
[    0.043219] PCI: 0000:01:02.1 reg 10 io port: [3400, 34ff]
[    0.043239] PCI: 0000:01:02.1 reg 14 64bit mmio: [fe005000, fe005fff]
[    0.043270] PCI: 0000:01:02.1 reg 30 32bit mmio: [0, 1ffff]
[    0.043454] PCI: 0000:01:03.0 reg 10 io port: [3800, 38ff]
[    0.043474] PCI: 0000:01:03.0 reg 14 64bit mmio: [fe006000, fe0063ff]
[    0.043494] PCI: 0000:01:03.0 reg 1c 64bit mmio: [fe000000, fe001fff]
[    0.043542] pci 0000:01:03.0: supports D1
[    0.043548] pci 0000:01:03.0: supports D2
[    0.043592] PCI: 0000:01:03.1 reg 10 io port: [4000, 40ff]
[    0.043612] PCI: 0000:01:03.1 reg 14 64bit mmio: [fe006400, fe0067ff]
[    0.043631] PCI: 0000:01:03.1 reg 1c 64bit mmio: [fe002000, fe003fff]
[    0.043679] pci 0000:01:03.1: supports D1
[    0.043684] pci 0000:01:03.1: supports D2
[    0.047163] NetLabel: Initializing
[    0.047163] NetLabel:  domain hash size = 128
[    0.047163] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.047163] NetLabel:  unlabeled traffic allowed by default
[    0.047163] system 00:00: ioport range 0xca0-0xca3 has been reserved
[    0.047208] system 00:02: iomem range 0xffffffffffe00000-0xffffffffffffffff has been reserved
[    0.047314] system 00:04: iomem range 0xdc000-0xdffff has been reserved
[    0.047394] system 00:06: iomem range 0x0-0x9ffff could not be reserved
[    0.047462] system 00:06: iomem range 0xe4000-0xfffff could not be reserved
[    0.047531] system 00:06: iomem range 0x100000-0x5fffffff could not be reserved
[    0.047632] system 00:0f: ioport range 0x4d0-0x4d1 has been reserved
[    0.047701] system 00:0f: ioport range 0xc00-0xc3f has been reserved
[    0.047767] system 00:0f: ioport range 0xcc0-0xccf has been reserved
[    0.047844] system 00:10: iomem range 0xfffffffffec00000-0xfffffffffec0ffff has been reserved
[    0.047926] system 00:10: iomem range 0xfffffffffee00000-0xfffffffffee00fff has been reserved
[    0.048020] system 00:12: iomem range 0xcfe00-0xcffff has been reserved
[    0.050358] bus: 00 index 0 io port: [0, ffff]
[    0.050420] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.050481] bus: 01 index 0 io port: [0, ffff]
[    0.050541] bus: 01 index 1 mmio: [0, ffffffffffffffff]
[    0.050603] bus: 80 index 0 io port: [0, ffff]
[    0.050664] bus: 80 index 1 mmio: [0, ffffffffffffffff]
[    0.050747] NET: Registered protocol family 2
[    0.051061] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.051597] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.057027] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.060455] TCP: Hash tables configured (established 131072 bind 65536)
[    0.060541] TCP reno registered
[    0.060986] NET: Registered protocol family 1
[    0.061484] checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
[    0.138243] Freeing initrd memory: 588k freed
[    0.140179] audit: initializing netlink socket (disabled)
[    0.140301] type=2000 audit(1251202105.139:1): initialized
[    0.162728] highmem bounce pool size: 64 pages
[    0.162812] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.172067] VFS: Disk quotas dquot_6.5.1
[    0.173658] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.174220] msgmni has been set to 1741
[    0.174718] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.174799] io scheduler noop registered
[    0.174859] io scheduler anticipatory registered
[    0.174920] io scheduler deadline registered
[    0.175022] io scheduler cfq registered (default)
[    0.175179] pci 0000:00:09.0: Firmware left e100 interrupts enabled; disabling
[    0.175272] pci 0000:00:0a.0: Boot video device
[    0.176285] isapnp: Scanning for PnP cards...
[    0.533412] isapnp: No Plug & Play device found
[    0.653627] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    0.906736] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.160067] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.161903] 00:13: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.162739] 00:19: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.168033] brd: module loaded
[    1.168336] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    1.168736] PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
[    1.168803] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.169661] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.170681] mice: PS/2 mouse device common for all mice
[    1.171175] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[    1.171268] rtc0: alarms up to one day
[    1.171674] EISA: Probing bus 0 at eisa.0
[    1.171757] Cannot allocate resource for EISA slot 2
[    1.171820] Cannot allocate resource for EISA slot 3
[    1.171883] Cannot allocate resource for EISA slot 4
[    1.171970] EISA: Detected 0 cards.
[    1.172529] TCP cubic registered
[    1.173312] NET: Registered protocol family 10
[    1.173840] lo: Disabled Privacy Extensions
[    1.174004] Mobile IPv6
[    1.174067] NET: Registered protocol family 17
[    1.174156] Using IPI No-Shortcut mode
[    1.174791] TuxOnIce: Ignoring late initcall, as requested.
[    1.174881] registered taskstats version 1
[    1.175464] rtc_cmos 00:0a: setting system clock to 2009-08-25 12:08:27 UTC (1251202107)
[    1.194748] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.276725] RAMDISK: Compressed image found at block 0
[    1.363099] VFS: Mounted root (romfs filesystem) readonly.
[    1.407595] md: raid1 personality registered for level 1
[    1.467379] SCSI subsystem initialized
[    1.493361] sym0: <896> rev 0x7 at pci 0000:01:03.0 irq 11
[    1.495546] sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    1.496563] sym0: SCSI BUS has been reset.
[    1.502316] scsi0 : sym-2.2.3
[    1.504139] sym1: <896> rev 0x7 at pci 0000:01:03.1 irq 11
[    1.506293] sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    1.506561] sym1: SCSI BUS has been reset.
[    1.513030] scsi1 : sym-2.2.3
[    1.514852] sym2: <810a> rev 0x23 at pci 0000:00:08.0 irq 11
[    1.517008] sym2: No NVRAM, ID 7, Fast-10, SE, parity checking
[    1.519894] sym2: SCSI BUS has been reset.
[    1.523511] scsi2 : sym-2.2.3
[   16.752206] scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   16.752212]         <Adaptec 3960D Ultra160 SCSI adapter>
[   16.752216]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   16.752220] 
[   16.964142] scsi 3:0:0:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   16.964240] scsi3:A:0:0: Tagged Queuing enabled.  Depth 253
[   16.964363] scsi target3:0:0: Beginning Domain Validation
[   16.968740] scsi target3:0:0: wide asynchronous
[   16.972171] scsi target3:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   16.979661] scsi target3:0:0: Ending Domain Validation
[   16.981185] scsi 3:0:1:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   16.981272] scsi3:A:1:0: Tagged Queuing enabled.  Depth 253
[   16.981384] scsi target3:0:1: Beginning Domain Validation
[   16.985757] scsi target3:0:1: wide asynchronous
[   16.989191] scsi target3:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   16.996635] scsi target3:0:1: Ending Domain Validation
[   16.998161] scsi 3:0:2:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   16.998246] scsi3:A:2:0: Tagged Queuing enabled.  Depth 253
[   16.998356] scsi target3:0:2: Beginning Domain Validation
[   17.002725] scsi target3:0:2: wide asynchronous
[   17.006152] scsi target3:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   17.013644] scsi target3:0:2: Ending Domain Validation
[   17.015195] scsi 3:0:3:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   17.015282] scsi3:A:3:0: Tagged Queuing enabled.  Depth 253
[   17.015394] scsi target3:0:3: Beginning Domain Validation
[   17.019758] scsi target3:0:3: wide asynchronous
[   17.023185] scsi target3:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   17.030671] scsi target3:0:3: Ending Domain Validation
[   17.032221] scsi 3:0:4:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   17.032309] scsi3:A:4:0: Tagged Queuing enabled.  Depth 253
[   17.032422] scsi target3:0:4: Beginning Domain Validation
[   17.036780] scsi target3:0:4: wide asynchronous
[   17.040196] scsi target3:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   17.047697] scsi target3:0:4: Ending Domain Validation
[   17.049225] scsi 3:0:5:0: Direct-Access     FUJITSU  MBA3300NC        0102 PQ: 0 ANSI: 3
[   17.049314] scsi3:A:5:0: Tagged Queuing enabled.  Depth 253
[   17.049429] scsi target3:0:5: Beginning Domain Validation
[   17.053778] scsi target3:0:5: wide asynchronous
[   17.057189] scsi target3:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   17.064676] scsi target3:0:5: Ending Domain Validation
[   17.126291] scsi 3:0:6:0: Processor         ESG-SHV  SCA HSBP M6      0.65 PQ: 0 ANSI: 2
[   17.126386] scsi target3:0:6: Beginning Domain Validation
[   17.258886] scsi target3:0:6: Ending Domain Validation
[   31.964495] scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   31.964500]         <Adaptec 3960D Ultra160 SCSI adapter>
[   31.964504]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
[   31.964508] 
[   32.043887] libata version 3.00 loaded.
[   32.055564] ata_piix 0000:00:0c.1: version 2.12
[   32.055830] scsi5 : ata_piix
[   32.056297] scsi6 : ata_piix
[   32.056631] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x2460 irq 14
[   32.056700] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x2468 irq 15
[   32.261229] ata2: port disabled. ignoring.
[   32.261342] ata_piix 0000:00:10.0: no available native port
[   32.277970] Driver 'sd' needs updating - please use bus_type methods
[   32.279198] sd 3:0:0:0: [sda] 585937500 512-byte hardware sectors (300000 MB)
[   32.282022] sd 3:0:0:0: [sda] Write Protect is off
[   32.282086] sd 3:0:0:0: [sda] Mode Sense: b3 00 00 08
[   32.283374] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.284064] sd 3:0:0:0: [sda] 585937500 512-byte hardware sectors (300000 MB)
[   32.286875] sd 3:0:0:0: [sda] Write Protect is off
[   32.286939] sd 3:0:0:0: [sda] Mode Sense: b3 00 00 08
[   32.288223] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.288309]  sda: sda1 sda2
[   32.291443] sd 3:0:0:0: [sda] Attached SCSI disk
[   32.292539] sd 3:0:1:0: [sdb] 585937500 512-byte hardware sectors (300000 MB)
[   32.295345] sd 3:0:1:0: [sdb] Write Protect is off
[   32.295409] sd 3:0:1:0: [sdb] Mode Sense: b3 00 00 08
[   32.296692] sd 3:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.297342] sd 3:0:1:0: [sdb] 585937500 512-byte hardware sectors (300000 MB)
[   32.300151] sd 3:0:1:0: [sdb] Write Protect is off
[   32.300217] sd 3:0:1:0: [sdb] Mode Sense: b3 00 00 08
[   32.301490] sd 3:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.301575]  sdb: sdb1 sdb2
[   32.304018] sd 3:0:1:0: [sdb] Attached SCSI disk
[   32.305119] sd 3:0:2:0: [sdc] 585937500 512-byte hardware sectors (300000 MB)
[   32.307948] sd 3:0:2:0: [sdc] Write Protect is off
[   32.308013] sd 3:0:2:0: [sdc] Mode Sense: b3 00 00 08
[   32.309297] sd 3:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.309940] sd 3:0:2:0: [sdc] 585937500 512-byte hardware sectors (300000 MB)
[   32.312733] sd 3:0:2:0: [sdc] Write Protect is off
[   32.312799] sd 3:0:2:0: [sdc] Mode Sense: b3 00 00 08
[   32.314130] sd 3:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.314214]  sdc: sdc1 sdc2
[   32.318452] sd 3:0:2:0: [sdc] Attached SCSI disk
[   32.319538] sd 3:0:3:0: [sdd] 585937500 512-byte hardware sectors (300000 MB)
[   32.322352] sd 3:0:3:0: [sdd] Write Protect is off
[   32.322416] sd 3:0:3:0: [sdd] Mode Sense: b3 00 00 08
[   32.323699] sd 3:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.324341] sd 3:0:3:0: [sdd] 585937500 512-byte hardware sectors (300000 MB)
[   32.327152] sd 3:0:3:0: [sdd] Write Protect is off
[   32.327217] sd 3:0:3:0: [sdd] Mode Sense: b3 00 00 08
[   32.328498] sd 3:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.328585]  sdd: sdd1 sdd2
[   32.332610] sd 3:0:3:0: [sdd] Attached SCSI disk
[   32.333711] sd 3:0:4:0: [sde] 585937500 512-byte hardware sectors (300000 MB)
[   32.336513] sd 3:0:4:0: [sde] Write Protect is off
[   32.336578] sd 3:0:4:0: [sde] Mode Sense: b3 00 00 08
[   32.337864] sd 3:0:4:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.338504] sd 3:0:4:0: [sde] 585937500 512-byte hardware sectors (300000 MB)
[   32.341317] sd 3:0:4:0: [sde] Write Protect is off
[   32.341381] sd 3:0:4:0: [sde] Mode Sense: b3 00 00 08
[   32.342664] sd 3:0:4:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.342750]  sde: sde1 sde2
[   32.347933] sd 3:0:4:0: [sde] Attached SCSI disk
[   32.349027] sd 3:0:5:0: [sdf] 585937500 512-byte hardware sectors (300000 MB)
[   32.351825] sd 3:0:5:0: [sdf] Write Protect is off
[   32.351890] sd 3:0:5:0: [sdf] Mode Sense: b3 00 00 08
[   32.353169] sd 3:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.355024] sd 3:0:5:0: [sdf] 585937500 512-byte hardware sectors (300000 MB)
[   32.357821] sd 3:0:5:0: [sdf] Write Protect is off
[   32.357885] sd 3:0:5:0: [sdf] Mode Sense: b3 00 00 08
[   32.359168] sd 3:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.359252]  sdf: sdf1 sdf2
[   32.365039] sd 3:0:5:0: [sdf] Attached SCSI disk
[   32.366920] scsi: waiting for bus probes to complete ...
[   35.867985] md: md0 stopped.
[   35.892652] md: bind<sdb1>
[   35.893147] md: bind<sdc1>
[   35.893479] md: bind<sda1>
[   35.893615] md: md0: raid array is not clean -- starting background reconstruction
[   35.893988] raid1: raid set md0 active with 2 out of 2 mirrors
[   35.895418] md: resync of RAID array md0
[   35.895482] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   35.895546] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[   35.895631] md: using 128k window, over a total of 14651136 blocks.
[   35.935801] EXT3-fs: INFO: recovery required on readonly filesystem.
[   35.935873] EXT3-fs: write access will be enabled during recovery.
[   36.115774] kjournald starting.  Commit interval 5 seconds
[   36.115888] EXT3-fs: recovery complete.
[   36.116848] EXT3-fs: mounted filesystem with ordered data mode.
[   36.116967] VFS: Mounted root (ext3 filesystem) readonly.
[   36.117031] Trying to move old root to /initrd ... okay
[   36.157621] Freeing unused kernel memory: 6116k freed
[   37.608836] Uniform Multi-Platform E-IDE driver
[   37.621007] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[   37.621016] Copyright (c) 1999-2006 Intel Corporation.
[   37.935157] e1000: 0000:01:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:6f:8e:9e
[   38.175107] usbcore: registered new interface driver usbfs
[   38.175214] usbcore: registered new interface driver hub
[   38.193017] sd 3:0:0:0: Attached scsi generic sg0 type 0
[   38.193165] sd 3:0:1:0: Attached scsi generic sg1 type 0
[   38.193307] sd 3:0:2:0: Attached scsi generic sg2 type 0
[   38.193449] sd 3:0:3:0: Attached scsi generic sg3 type 0
[   38.193593] sd 3:0:4:0: Attached scsi generic sg4 type 0
[   38.193736] sd 3:0:5:0: Attached scsi generic sg5 type 0
[   38.193887] scsi 3:0:6:0: Attached scsi generic sg6 type 3
[   38.235471] usbcore: registered new device driver usb
[   38.269159] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   38.280060] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   38.280069] e100: Copyright(c) 1999-2006 Intel Corporation
[   38.296991] piix: 450NX errata present, disabling IDE DMA.
[   38.297003] piix: A BIOS update may resolve this.
[   38.459851] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   38.483980] e100 0000:00:09.0: PME# disabled
[   38.657629] e100: eth1: e100_probe: addr 0xfa100000, irq 10, MAC addr 00:02:b3:08:a0:68
[   38.657895] piix4_smbus 0000:00:0c.3: SMBus Host Controller at 0xcc0, revision 0
[   38.658035] piix 0000:00:10.0: IDE controller (0x8086:0x84ca rev 0x03)
[   38.658061] piix 0000:00:10.0: device not capable of full native PCI mode
[   38.658069] piix 0000:00:10.0: device disabled (BIOS)
[   38.734420] eepro100.c:v1.09j-t 9/29/99 Donald Becker
[   38.734425] eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
[   38.742347] USB Universal Host Controller Interface driver v3.0
[   38.742551] uhci_hcd 0000:00:0c.2: UHCI Host Controller
[   38.742691] uhci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 1
[   38.742743] uhci_hcd 0000:00:0c.2: irq 15, io base 0x00002440
[   38.743393] usb usb1: configuration #1 chosen from 1 choice
[   38.743503] hub 1-0:1.0: USB hub found
[   38.743526] hub 1-0:1.0: 2 ports detected
[   38.844675] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   38.844688] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   38.844696] usb usb1: Product: UHCI Host Controller
[   38.844703] usb usb1: Manufacturer: Linux 2.6.27.31-1 uhci_hcd
[   38.844709] usb usb1: SerialNumber: 0000:00:0c.2
[   39.806488] EXT3 FS on md0, internal journal
[   40.243241] md: md1 stopped.
[   40.303699] md: bind<sdd1>
[   40.304014] md: bind<sdf1>
[   40.304300] md: bind<sde1>
[   40.311908] raid1: raid set md1 active with 2 out of 2 mirrors
[   40.315430] md: md2 stopped.
[   40.371125] md: bind<sdb2>
[   40.372718] md: bind<sdc2>
[   40.373983] md: bind<sdd2>
[   40.374305] md: bind<sde2>
[   40.375607] md: bind<sdf2>
[   40.375974] md: bind<sda2>
[   40.376100] md: md2: raid array is not clean -- starting background reconstruction
[   40.394284] md: raid10 personality registered for level 10
[   40.395455] raid10: raid set md2 active with 6 out of 6 devices
[   40.409200] md: delaying resync of md2 until md0 has finished (they share one or more physical units)
[   40.710194] kjournald starting.  Commit interval 5 seconds
[   40.714142] EXT3 FS on md1, internal journal
[   40.714158] EXT3-fs: mounted filesystem with ordered data mode.
[   40.799280] SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
[   40.803497] SGI XFS Quota Management subsystem
[   40.804921] Filesystem "md2": Disabling barriers, trial barrier write failed
[   40.809749] XFS mounting filesystem md2
[   40.963163] Starting XFS recovery on filesystem: md2 (logdev: internal)
[   41.181795] Ending XFS recovery on filesystem: md2 (logdev: internal)
[   42.252799] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   42.275605] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   42.276359] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   52.217084] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
[   52.406426] eth0: no IPv6 routers present
[   95.706099] scdp uses obsolete (PF_INET,SOCK_PACKET)
[  372.255222] md: md0: resync done.
[  372.285695] md: resync of RAID array md2
[  372.285704] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  372.285712] md: using maximum available idle IO bandwidth (but not more than 15000 KB/sec) for resync.
[  372.285727] md: using 128k window, over a total of 834929664 blocks.
[  372.409504] RAID1 conf printout:
[  372.409522]  --- wd:2 rd:2
[  372.409532]  disk 0, wo:0, o:1, dev:sda1
[  372.409540]  disk 1, wo:0, o:1, dev:sdb1


-- 
pozdr.  Pawe³ Go³aszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-1123602371-1251208521=:16876--
