Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYD2X52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYD2X52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYD2X5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:57:07 -0400
Received: from smtp.ono.com ([62.42.230.12]:11555 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756471AbYD2X5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:57:00 -0400
Date: Wed, 30 Apr 2008 01:56:55 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Problems with -git14
Message-ID: <20080430015655.5a42f63d@werewolf.home>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have a couple problems with latest git (-14):

- It only recognises 2 processors out of 4 (dual Xeon HT)
- It oopses on the swapper process just on boot...

Difference in dmesg is below. If full correct dmesg or config is
needed, please ask for them. The kernel was built copying old
2.6.25 config to .config && make oldconfig. I filled the missing
gaps like PAT and others...

--- dm.txt	2008-04-30 01:47:55.000000000 +0200
+++ dm-git14.txt	2008-04-30 01:47:29.000000000 +0200
@@ -1,4 +1,4 @@
-Linux version 2.6.25-jam01 (root@werewolf) (gcc version 4.2.3 (4.2.3-6mnb1)) #6 SMP PREEMPT Mon Apr 21 20:28:14 CEST 2008
+Linux version 2.6.25-jam02 (root@werewolf) (gcc version 4.2.3 (4.2.3-6mnb1)) #1 SMP PREEMPT Wed Apr 30 00:49:19 CEST 2008
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
@@ -8,11 +8,9 @@
  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
+x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
 1150MB HIGHMEM available.
 896MB LOWMEM available.
-Scan SMP from c0000000 for 1024 bytes.
-Scan SMP from c009fc00 for 1024 bytes.
-Scan SMP from c00f0000 for 65536 bytes.
 found SMP MP-table at [c00f57c0] 000f57c0
 Entering add_active_range(0, 0, 524000) 0 entries of 256 used
 Zone PFN ranges:
@@ -42,13 +40,13 @@
 ACPI: PM-Timer IO Port: 0x408
 ACPI: Local APIC address 0xfee00000
 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
-Processor #0 15:2 APIC version 20
+BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
-Processor #6 15:2 APIC version 20
-ACPI: LAPIC (acpi_id[0x02] lapic_id[0x07] enabled)
-Processor #7 15:2 APIC version 20
-ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
-Processor #1 15:2 APIC version 20
+BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
+ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
+BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
+ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
+BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
 ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
@@ -63,6 +61,8 @@
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 Using ACPI (MADT) for SMP configuration information
 Allocating PCI resources starting at 80000000 (gap: 7ff00000:7ed00000)
+PERCPU: Allocating 39024 bytes of per cpu data
+NR_CPUS: 4, nr_cpu_ids: 4
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519907
 Kernel command line: video=vesafb:mtrr,ywrap vga=773 ro root=/dev/sda1
 mapped APIC to ffffb000 (fee00000)
@@ -70,72 +70,57 @@
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
-CPU 0 irqstacks, hard=c0458000 soft=c0454000
+CPU 0 irqstacks, hard=c043b000 soft=c0437000
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 2405.510 MHz processor.
+Detected 2405.615 MHz processor.
 Console: colour dummy device 80x25
 console [tty0] enabled
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 2073904k/2096000k available (2298k kernel code, 21036k reserved, 812k data, 268k init, 1178496k highmem)
+Memory: 2074016k/2096000k available (2218k kernel code, 20936k reserved, 812k data, 232k init, 1178496k highmem)
 virtual kernel memory layout:
     fixmap  : 0xfff81000 - 0xfffff000   ( 504 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-      .init : 0xc040e000 - 0xc0451000   ( 268 kB)
-      .data : 0xc033e8de - 0xc0409a48   ( 812 kB)
-      .text : 0xc0100000 - 0xc033e8de   (2298 kB)
+      .init : 0xc03fa000 - 0xc0434000   ( 232 kB)
+      .data : 0xc032aa15 - 0xc03f5af0   ( 812 kB)
+      .text : 0xc0100000 - 0xc032aa15   (2218 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
 CPA: page pool initialized 1 of 1 pages preallocated
-SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
-Calibrating delay using timer specific routine.. 4813.42 BogoMIPS (lpj=2406712)
+SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
+Calibrating delay using timer specific routine.. 4813.29 BogoMIPS (lpj=2406649)
 Mount-cache hash table entries: 512
 CPU: Trace cache: 12K uops, L1 D cache: 8K
 CPU: L2 cache: 512K
 CPU: Physical Processor ID: 0
 Compat vDSO mapped to ffffe000.
 Checking 'hlt' instruction... OK.
-Freeing SMP alternatives: 11k freed
+Freeing SMP alternatives: 10k freed
 ACPI: Core revision 20070126
+ENABLING IO-APIC IRQs
+..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
+CPU 1 irqstacks, hard=c043c000 soft=c0438000
 Booting processor 1/1 ip 2000
-CPU 1 irqstacks, hard=c0459000 soft=c0455000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 4810.24 BogoMIPS (lpj=2405121)
+Calibrating delay using timer specific routine.. 4810.28 BogoMIPS (lpj=2405142)
 CPU: Trace cache: 12K uops, L1 D cache: 8K
 CPU: L2 cache: 512K
 CPU: Physical Processor ID: 0
+x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
 CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
-Booting processor 2/6 ip 2000
-CPU 2 irqstacks, hard=c045a000 soft=c0456000
-Initializing CPU#2
-Calibrating delay using timer specific routine.. 4810.31 BogoMIPS (lpj=2405158)
-CPU: Trace cache: 12K uops, L1 D cache: 8K
-CPU: L2 cache: 512K
-CPU: Physical Processor ID: 3
-CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
-Booting processor 3/7 ip 2000
-CPU 3 irqstacks, hard=c045b000 soft=c0457000
-Initializing CPU#3
-Calibrating delay using timer specific routine.. 4810.31 BogoMIPS (lpj=2405158)
-CPU: Trace cache: 12K uops, L1 D cache: 8K
-CPU: L2 cache: 512K
-CPU: Physical Processor ID: 3
-CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
-Total of 4 processors activated (19244.29 BogoMIPS).
-ENABLING IO-APIC IRQs
-..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
-checking TSC synchronization [CPU#0 -> CPU#2]: passed.
-checking TSC synchronization [CPU#0 -> CPU#3]: passed.
-Brought up 4 CPUs
-net_namespace: 160 bytes
+native_cpu_up: bad cpu 2
+native_cpu_up: bad cpu 3
+Brought up 2 CPUs
+Total of 2 processors activated (9623.58 BogoMIPS).
+net_namespace: 200 bytes
 NET: Registered protocol family 16
 No dock devices found.
 ACPI: bus type pci registered
 PCI: PCI BIOS revision 2.10 entry at 0xfb7f0, last bus=3
-PCI: Using configuration type 1
+PCI: Using configuration type 1 for base access
 Setting up standard PCI resources
 ACPI: EC: Look up EC in DSDT
 ACPI: Interpreter enabled
@@ -167,7 +152,6 @@
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
 PCI: Using ACPI for IRQ routing
-PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
 hpet clockevent registered
 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
 hpet0: 3 64-bit timers, 14318180 Hz
@@ -213,7 +197,9 @@
 TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
 TCP reno registered
+NET: Registered protocol family 1
 highmem bounce pool size: 64 pages
+msgmni has been set to 1750 for ipc namespace c03dadc0
 io scheduler noop registered
 io scheduler anticipatory registered
 io scheduler deadline registered
@@ -231,10 +217,8 @@
 Non-volatile memory driver v1.2
 intel_rng: FWH not detected
 ACPI: PCI Interrupt 0000:03:0a.0[A] -> GSI 22 (level, low) -> IRQ 22
-Switched to high resolution mode on CPU 2
-Switched to high resolution mode on CPU 3
-Switched to high resolution mode on CPU 0
 Switched to high resolution mode on CPU 1
+Switched to high resolution mode on CPU 0
 scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
         <Adaptec 29320 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
@@ -243,19 +227,81 @@
         <Adaptec 29320 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
 scsi 1:0:0:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
- target1:0:0: asynchronous
+------------[ cut here ]------------
+WARNING: at include/linux/blkdev.h:427 blk_queue_init_tags+0x110/0x11f()
+Modules linked in:
+Pid: 1, comm: swapper Not tainted 2.6.25-jam02 #1
+ [<c011e618>] warn_on_slowpath+0x4d/0x66
+ [<c0133078>] __atomic_notifier_call_chain+0x27/0x48
+ [<c01330b0>] atomic_notifier_call_chain+0x17/0x1b
+ [<c024367e>] notify_update+0x1f/0x23
+ [<c02438c7>] vt_console_print+0x1dd/0x2ab
+ [<c02436ea>] vt_console_print+0x0/0x2ab
+ [<c0132c3e>] up+0x9/0x2b
+ [<c01eca3c>] init_tag_map+0x4e/0x95
+ [<c01ecb61>] __blk_queue_init_tags+0x27/0x4e
+ [<c01ecc98>] blk_queue_init_tags+0x110/0x11f
+ [<c027e9fb>] ahd_platform_set_tags+0x177/0x1a7
+ [<c027f0a7>] ahd_linux_slave_configure+0xcd/0x131
+ [<c02576fe>] scsi_probe_and_add_lun+0x706/0x964
+ [<c0257b27>] __scsi_scan_target+0xd9/0x5d9
+ [<c019c3b3>] sysfs_ilookup_test+0x0/0xd
+ [<c019ce3a>] sysfs_addrm_finish+0x14/0x1c7
+ [<c019c6bd>] sysfs_find_dirent+0x1e/0x27
+ [<c019c701>] sysfs_add_one+0x3b/0x8b
+ [<c019c24c>] sysfs_add_file_mode+0x4d/0x76
+ [<c019da1c>] internal_create_group+0xd7/0x196
+ [<c0322dd2>] klist_next+0x53/0x90
+ [<c025809f>] scsi_scan_channel+0x78/0x8d
+ [<c025815c>] scsi_scan_host_selected+0xa8/0xd1
+ [<c02581ed>] do_scsi_scan_host+0x68/0x6a
+ [<c027e26c>] ahd_linux_register_host+0x267/0x2db
+ [<c02808cf>] ahd_pci_map_int+0x2c/0x50
+ [<c0279bba>] ahd_pci_config+0x533/0x824
+ [<c01f6736>] kobject_get+0xf/0x13
+ [<c024a495>] get_device+0xe/0x14
+ [<c0202579>] pci_dev_get+0xf/0x13
+ [<c0280a96>] ahd_linux_pci_dev_probe+0x139/0x17f
+ [<c019ce3a>] sysfs_addrm_finish+0x14/0x1c7
+ [<c019c6bd>] sysfs_find_dirent+0x1e/0x27
+ [<c019c701>] sysfs_add_one+0x3b/0x8b
+ [<c019d3a3>] sysfs_create_link+0x89/0x106
+ [<c0202819>] pci_match_device+0x9c/0xad
+ [<c0202880>] pci_device_probe+0x40/0x60
+ [<c024c9d3>] driver_probe_device+0x76/0x152
+ [<c024cb05>] __driver_attach+0x56/0x58
+ [<c024c40d>] bus_for_each_dev+0x39/0x57
+ [<c0202840>] pci_device_probe+0x0/0x60
+ [<c024c896>] driver_attach+0x16/0x1a
+ [<c024caaf>] __driver_attach+0x0/0x58
+ [<c024bf1a>] bus_add_driver+0x19c/0x214
+ [<c0202534>] pci_device_remove+0x0/0x36
+ [<c0202840>] pci_device_probe+0x0/0x60
+ [<c024cc24>] driver_register+0x3b/0xd3
+ [<c020274b>] __pci_register_driver+0x32/0x64
+ [<c040eb5f>] ahd_linux_init+0x53/0x6f
+ [<c03faa36>] kernel_init+0x11d/0x287
+ [<c01174c2>] finish_task_switch+0x1f/0x6d
+ [<c0117711>] schedule_tail+0x16/0x44
+ [<c0102c6a>] ret_from_fork+0x6/0x1c
+ [<c03fa919>] kernel_init+0x0/0x287
+ [<c03fa919>] kernel_init+0x0/0x287
+ [<c0103947>] kernel_thread_helper+0x7/0x10
+ =======================
+---[ end trace 73ab2f7863b8a5fa ]---
+scsi target1:0:0: asynchronous
 scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
- target1:0:0: Beginning Domain Validation
- target1:0:0: wide asynchronous
- target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
- target1:0:0: Ending Domain Validation
+scsi target1:0:0: Beginning Domain Validation
+scsi target1:0:0: wide asynchronous
+scsi target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
+scsi target1:0:0: Ending Domain Validation
 scsi 1:0:1:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
- target1:0:1: asynchronous
+scsi target1:0:1: asynchronous
 scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
- target1:0:1: Beginning Domain Validation
- target1:0:1: wide asynchronous
- target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
- target1:0:1: Ending Domain Validation
+scsi target1:0:1: Beginning Domain Validation
+scsi target1:0:1: wide asynchronous
+scsi target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
+scsi target1:0:1: Ending Domain Validation
 Driver 'sd' needs updating - please use bus_type methods
 sd 1:0:0:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
 sd 1:0:0:0: [sda] Write Protect is off
@@ -353,6 +399,7 @@
 usb usb3: configuration #1 chosen from 1 choice
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
+hub 1-0:1.0: unable to enumerate USB device on port 1
 ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
 PCI: Setting latency timer of device 0000:00:1d.2 to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
@@ -361,6 +408,7 @@
 usb usb4: configuration #1 chosen from 1 choice
 hub 4-0:1.0: USB hub found
 hub 4-0:1.0: 2 ports detected
+hub 1-0:1.0: unable to enumerate USB device on port 4
 ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16
 PCI: Setting latency timer of device 0000:00:1d.3 to 64
 uhci_hcd 0000:00:1d.3: UHCI Host Controller
@@ -389,61 +437,61 @@
 input: Mitsumi Electric Apple Extended USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input3
 input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0000:00:1d.0-1.3
 usbcore: registered new interface driver usbhid
-drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
+usbhid: v2.6:USB HID core driver
 TCP cubic registered
-NET: Registered protocol family 1
 NET: Registered protocol family 17
 p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
 Using IPI Shortcut mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 VFS: Mounted root (ext3 filesystem) readonly.
-Freeing unused kernel memory: 268k freed
-sd 1:0:0:0: Attached scsi generic sg0 type 0
-sd 1:0:1:0: Attached scsi generic sg1 type 0
-sd 2:0:0:0: Attached scsi generic sg2 type 0
-sr 2:0:1:0: Attached scsi generic sg3 type 5
-sd 4:0:0:0: Attached scsi generic sg4 type 0
+Freeing unused kernel memory: 232k freed
 Linux agpgart interface v0.103
-ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
-usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x3404
-usbcore: registered new interface driver usblp
-rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
-rtc0: alarms up to one month
 agpgart: Detected an Intel i875 Chipset.
 agpgart: AGP aperture is 32M @ 0xf0000000
 Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
 Copyright (c) 1999-2006 Intel Corporation.
 ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 18
 PCI: Setting latency timer of device 0000:02:01.0 to 64
+usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x3404
+usbcore: registered new interface driver usblp
 e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:a6:8b:e9:85
+sd 1:0:0:0: Attached scsi generic sg0 type 0
+sd 1:0:1:0: Attached scsi generic sg1 type 0
+sd 2:0:0:0: Attached scsi generic sg2 type 0
+sr 2:0:1:0: Attached scsi generic sg3 type 5
+sd 4:0:0:0: Attached scsi generic sg4 type 0
+e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
+ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 20 (level, low) -> IRQ 20
+ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[f6008000-f60087ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
+ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 21 (level, low) -> IRQ 21
+3c59x: Donald Becker and others.
+0000:03:0d.0: 3Com PCI 3c980C Python-T at f881e000.
+ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
+gameport: EMU10K1 is pci0000:03:0b.1/gameport0, io 0x9400, speed 994kHz
+rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
+rtc0: alarms up to one month
 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
 serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
-parport_pc 00:09: reported by Plug and Play ACPI
-parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
-e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
-ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 21 (level, low) -> IRQ 21
-3c59x: Donald Becker and others.
-0000:03:0d.0: 3Com PCI 3c980C Python-T at f882e000.
-udev: renamed network interface eth0 to eth1
-ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 20 (level, low) -> IRQ 20
-ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[f6008000-f60087ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
-ACPI: PCI Interrupt 0000:03:0b.0[A] -> GSI 23 (level, low) -> IRQ 23
-gameport: EMU10K1 is pci0000:03:0b.1/gameport0, io 0x9400, speed 1028kHz
 ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17
 PCI: Setting latency timer of device 0000:00:1f.5 to 64
+parport_pc 00:09: reported by Plug and Play ACPI
+parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
+udev: renamed network interface eth1 to eth0
+udev: renamed network interface eth0_rename to eth1
 AC'97 0 analog subsections not ready
-intel8x0_measure_ac97_clock: measured 50135 usecs
+intel8x0_measure_ac97_clock: measured 50110 usecs
 intel8x0: clocking to 48000
-rtc: I/O resource 70 is not free.
+ACPI: PCI Interrupt 0000:03:0b.0[A] -> GSI 23 (level, low) -> IRQ 23
+firmware: requesting intel-ucode/0f-02-09
+firmware: requesting intel-ucode/0f-02-09
 IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
-rtc: I/O resource 70 is not free.
+ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e018000063814f]
 Floppy drive(s): fd0 is 1.44M
 FDC 0 is a post-1991 82077
-ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e018000063814f]
 EXT3 (no)user_xattr options not supported
 EXT3 FS on sda1, internal journal
 EXT3 (no)user_xattr options not supported



-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
