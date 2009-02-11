Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZBKIwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZBKIwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZBKIv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:51:56 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:50147 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZBKIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Z4tZ+GizunWOJZ0Bz1fhvXaNYrLVF4V8Wviive3JwTh1yRUdbSU5YgyJBfkv/10zRg
         CpUV5CH+Wfq4lnOeHAmVqdX4wWTDxVyMeZ+RX9vTQmLTkdiRY0uVewJk8Ny68IklkK2A
         VQegE7S1RvNSaENz89w1MkgwIK05CY9bcF5Js=
Message-ID: <499291A3.9070501@gmail.com>
Date: Wed, 11 Feb 2009 09:51:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: ACPI: S4 disappeared [mmotm 2009-02-10-16-35]
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
In-Reply-To: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded

Hi,

I've found out, that S4 disappeared in this release, in comparison to mmotm
based on 2.6.29-rc2:
-ACPI: (supports S0 S1 S3 S4 S5)
+ACPI: (supports S0 S1 S3 S5)

Any ideas what could have caused this?

Full dmesgs diff follows:

--- good        2009-02-11 09:19:39.000000000 +0100
+++ wrong       2009-02-11 09:17:49.000000000 +0100
@@ -1,5 +1,5 @@
 Initializing cgroup subsys cpuset
-Linux version 2.6.29-rc2-mm1_64 (ku@bellona) (gcc version 4.3.2 [gcc-4_3-branch
revision 141291] (SUSE Linux) ) #534 SMP Mon Jan 19 10:44:28 CET 2009
+Linux version 2.6.29-rc4-mm1_64 (ku@bellona) (gcc version 4.3.2 [gcc-4_3-branch
revision 141291] (SUSE Linux) ) #569 SMP Wed Feb 11 09:11:57 CET 2009
 Command line: root=/dev/md1 vga=1 ro reboot=a,w slub_debug debug resume=/dev/sdb6 2
 KERNEL supported cpus:
   Intel GenuineIntel
@@ -27,7 +27,7 @@
 ACPI: RSDP 000F9990, 0024 (r2 ACPIAM)
 ACPI: XSDT 7D5B0100, 0064 (r1 A M I  OEMXSDT   5000708 MSFT       97)
 ACPI: FACP 7D5B0290, 00F4 (r3 A M I  OEMFACP   5000708 MSFT       97)
-ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 128/64 [20081204]
+ACPI Warning (tbfadt-0567): 32/64X length mismatch in Gpe0Block: 128/64 [20090123]
 FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
 ACPI: DSDT 7D5B0490, 6643 (r1 SDBLI9 SDBLI944       44 INTL 20051117)
 ACPI: FACS 7D5BE000, 0040
@@ -42,7 +42,7 @@
 (5 early reservations) ==> bootmem [0000000000 - 007d5b0000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
-  #2 [0000200000 - 00008a79e4]    TEXT DATA BSS ==> [0000200000 - 00008a79e4]
+  #2 [0000200000 - 000089769c]    TEXT DATA BSS ==> [0000200000 - 000089769c]
   #3 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
   #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff]
on node 0
@@ -57,8 +57,8 @@
     0: 0x00000100 -> 0x0007d5b0
 On node 0 totalpages: 513355
   DMA zone: 56 pages used for memmap
-  DMA zone: 1807 pages reserved
-  DMA zone: 2132 pages, LIFO batch:0
+  DMA zone: 1791 pages reserved
+  DMA zone: 2148 pages, LIFO batch:0
   DMA32 zone: 6964 pages used for memmap
   DMA32 zone: 502396 pages, LIFO batch:31
 ACPI: PM-Timer IO Port: 0x808
@@ -77,21 +77,17 @@
 ACPI: HPET id: 0x8086a301 base: 0xfed00000
 4 Processors exceeds NR_CPUS limit of 2
 SMP: Allowing 2 CPUs, 0 hotplug CPUs
-PM: Registered nosave memory: 000000000009c000 - 000000000009d000
-PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
-PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
-PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
 Allocating PCI resources starting at 80000000 (gap: 7d600000:81790000)
 NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
-PERCPU: Allocating 49152 bytes of per cpu data
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 504528
+PERCPU: Allocating 77824 bytes of per cpu data
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 504544
 Kernel command line: root=/dev/md1 vga=1 ro reboot=a,w slub_debug debug
resume=/dev/sdb6 2
 Initializing CPU#0
 NR_IRQS:4352 nr_irqs:288
 PID hash table entries: 4096 (order: 12, 32768 bytes)
 Extended CMOS year: 2000
 Fast TSC calibration using PIT
-Detected 2992.548 MHz processor.
+Detected 2992.452 MHz processor.
 Console: colour VGA+ 80x25
 console [tty0] enabled
 Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
@@ -100,11 +96,10 @@
 please try cgroup_disable=memory option if you don't want
 Checking aperture...
 No AGP bridge found
-Memory: 1993388k/2053824k available (3914k kernel code, 404k absent, 59348k
reserved, 1810k data, 336k init)
-SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
+Memory: 1993452k/2053824k available (3910k kernel code, 404k absent, 59340k
reserved, 1806k data, 360k init)
 hpet clockevent registered
 HPET: 4 timers in total, 0 timers will be used for per-cpu timer
-Calibrating delay loop (skipped), value calculated using timer frequency..
5985.09 BogoMIPS (lpj=11970192)
+Calibrating delay loop (skipped), value calculated using timer frequency..
5984.90 BogoMIPS (lpj=11969808)
 Mount-cache hash table entries: 256
 Initializing cgroup subsys debug
 Initializing cgroup subsys ns
@@ -114,11 +109,11 @@
 Initializing cgroup subsys freezer
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 4096K
+CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 0
 CPU0: Thermal LVT vector (0xfa) already installed
-using mwait in idle threads.
-ACPI: Core revision 20081204
+ACPI: Core revision 20090123
 Setting APIC routing to flat
   alloc irq_desc for 20 on cpu 0 node 0
   alloc kstat_irqs on cpu 0 node 0
@@ -126,9 +121,10 @@
 CPU0: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
 Booting processor 1 APIC 0x1 ip 0x6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 5984.98 BogoMIPS (lpj=11969960)
+Calibrating delay using timer specific routine.. 5984.90 BogoMIPS (lpj=11969813)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 4096K
+CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 CPU1: Thermal monitoring enabled (TM2)
@@ -136,7 +132,7 @@
 CPU1: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
-Total of 2 processors activated (11970.07 BogoMIPS).
+Total of 2 processors activated (11969.81 BogoMIPS).
 net_namespace: 968 bytes
 NET: Registered protocol family 16
 ACPI: bus type pci registered
@@ -147,7 +143,7 @@
 ACPI: EC: Look up EC in DSDT
 ACPI: BIOS _OSI(Linux) query ignored
 ACPI: Interpreter enabled
-ACPI: (supports S0 S1 S3 S4 S5)
+ACPI: (supports S0 S1 S3 S5)
 ACPI: Using IOAPIC for interrupt routing
 PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
 PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
@@ -231,7 +227,7 @@
 ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 12 14 15)
 ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 12 14 15)
 ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *12 14 15)
-ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] - C7, should be
BA [20081204]
+ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] - C7, should be
BA [20090123]
 SCSI subsystem initialized
 libata version 3.00 loaded.
 usbcore: registered new interface driver usbfs
@@ -349,18 +345,18 @@
 0000:00:03.3: ttyS1 at I/O 0xe000 (irq = 17) is a 16550A
 parport_pc 00:08: reported by Plug and Play ACPI
 parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
-Switched to high resolution mode on CPU 1
-Switched to high resolution mode on CPU 0
 Floppy drive(s): fd0 is 1.44M
 FDC 0 is a National Semiconductor PC87306
 loop: module loaded
-e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
+e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k2
 e1000e: Copyright (c) 1999-2008 Intel Corporation.
 e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 e1000e 0000:00:19.0: setting latency timer to 64
   alloc irq_desc for 26 on cpu 0 node 0
   alloc kstat_irqs on cpu 0 node 0
 e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
+Switched to high resolution mode on CPU 1
+Switched to high resolution mode on CPU 0
 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:13:20:f5:f2:1d
 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
@@ -527,28 +523,27 @@
 device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
 cpuidle: using governor ladder
 cpuidle: using governor menu
-Advanced Linux Sound Architecture Driver Version 1.0.18a.
+Advanced Linux Sound Architecture Driver Version 1.0.19.
   alloc irq_desc for 22 on cpu 0 node 0
   alloc kstat_irqs on cpu 0 node 0
 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 HDA Intel 0000:00:1b.0: setting latency timer to 64
 input: HDA Intel at 0xffa74000 irq 22 Line In at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input2
 input: HDA Intel at 0xffa74000 irq 22 Mic at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/input/input3
-firewire_core: created device fw0: GUID 0000000000000000, S400
 input: HDA Intel at 0xffa74000 irq 22 Mic at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input4
 input: HDA Intel at 0xffa74000 irq 22 Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input5
+firewire_core: created device fw0: GUID 0000000000000000, S400
 input: HDA Intel at 0xffa74000 irq 22 Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input6
 input: HDA Intel at 0xffa74000 irq 22 Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input7
 input: HDA Intel at 0xffa74000 irq 22 Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/input/input8
 input: HDA Intel at 0xffa74000 irq 22 HP Out at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/input/input9
-usb 6-1: new full speed USB device using uhci_hcd and address 2
 ALSA device list:
   #0: HDA Intel at 0xffa74000 irq 22
 TCP cubic registered
 NET: Registered protocol family 10
 NET: Registered protocol family 17
 registered taskstats version 1
-rtc_cmos 00:03: setting system clock to 2009-02-11 08:18:36 UTC (1234340316)
+rtc_cmos 00:03: setting system clock to 2009-02-11 08:14:37 UTC (1234340077)
 md: Waiting for all devices to be available before autodetect
 md: If you don't use raid, use raid=noautodetect
 md: Autodetecting RAID arrays.
@@ -627,8 +622,9 @@
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
-Freeing unused kernel memory: 336k freed
-Write protecting the kernel read-only data: 5352k
+Freeing unused kernel memory: 360k freed
+Write protecting the kernel read-only data: 5344k
+usb 6-1: new full speed USB device using uhci_hcd and address 2
 usb 6-1: configuration #1 chosen from 1 choice
 hub 6-1:1.0: USB hub found
 hub 6-1:1.0: 3 ports detected
@@ -642,9 +638,7 @@
 ath5k 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
 ath5k 0000:04:00.0: registered as 'phy0'
 input: ABBHOME USB Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.1/6-1.1:1.0/input/input10
-wmaster0 (ath5k): not using net_device_ops yet
 phy0: Selected rate control algorithm 'minstrel'
-wlan0 (ath5k): not using net_device_ops yet
 ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
 wlan0 renamed to wlan1
 udev: renamed network interface wlan0 to wlan1
