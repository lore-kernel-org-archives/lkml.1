Return-Path: <linux-kernel-owner+w=401wt.eu-S1765913AbXHYAsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765913AbXHYAsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbXHYArv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:47:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60921 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbXHYArr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:47:47 -0400
X-Sasl-enc: RAq4K+rpMTTsZynvSL5v1oCrgrpYVifDefNZgONPT29A 1188002864
Message-ID: <46CF7C3F.10707@imap.cc>
Date: Sat, 25 Aug 2007 02:47:59 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<46CF695D.1020008@imap.cc> <20070824170702.a2c51084.akpm@linux-foundation.org>
In-Reply-To: <20070824170702.a2c51084.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig409D29879952063DD3D04F5F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig409D29879952063DD3D04F5F
Content-Type: multipart/mixed;
 boundary="------------060401020703050807050402"

This is a multi-part message in MIME format.
--------------060401020703050807050402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.08.2007 02:07 schrieb Andrew Morton:
> On Sat, 25 Aug 2007 01:27:25 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> Am 22.08.2007 11:06 schrieb Andrew Morton:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-=
rc3/2.6.23-rc3-mm1/

>> After applying Matthew Wilcox' patch to include/linux/isa.h
>=20
> which patch is that?

The one allowing drivers/scsi/advansys.c to compile with CONFIG_ISA=3Dn:

Date: 	Wed, 22 Aug 2007 10:28:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
Message-ID: <20070822162802.GJ9163@parisc-linux.org>

When CONFIG_ISA is disabled, the isa_driver support will not be compiled
in.  Define stubs so that we don't get link-time errors.

>> this compiles
>> and boots on my Intel/openSUSE 10.2 test machine but throws out the
>> following messages I don't remember ever seeing with other kernels:
>>
>> - on console early during boot, also in SuSE's /var/log/boot.msg:
>>
>> your system time is not correct:
>> Wed Jul 13 13:15:31 UTC 1910
>> setting system time to:
>> Tue Jul 24 00:00:00 UTC 2007
>=20
> What architecture?

i386. The machine is a Pentium D 940 which would be x86_64 capable,
but I'm still running 32 bit kernels on it.

> if x86_64 then perhaps something went wrong with the old x86_64 dyntick=
s
> leftovers which were in rc3-mm1.  I've just merged a shiny fresh new se=
ries
> so perhaps things there got fixed.  Please retest next -mm.

Will do that anyway.

> Perhaps it would be helpful if you could do a=20
>=20
> 	diff -u dmesg-2.6.23-rc3 dmesg-2.6.26-rc3-mm1

I hope the attached helps. I created it by taking /var/log/boot.msg
of the two systems, removing everything after "Kernel logging stopped",
editing out the printk timestamps and then running diff -u on them,
so it should be more or less the dmesg diff. I did not edit out any
of the differences because I'm lazy. (And also because I wasn't so sure
what would or wouldn't be interesting for you.)

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)

--------------060401020703050807050402
Content-Type: text/plain;
 name="bootmsg.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="bootmsg.diff"

--- /tmp/bootmsg-2.6.23-rc3	2007-08-25 02:25:54.000000000 +0200
+++ /tmp/bootmsg-2.6.23-rc3-mm1	2007-08-25 02:26:08.000000000 +0200
@@ -1,10 +1,10 @@
-Inspecting /boot/System.map-2.6.23-rc3-testing
-Loaded 27522 symbols from /boot/System.map-2.6.23-rc3-testing.
+Inspecting /boot/System.map-2.6.23-rc3-mm1-testing
+Loaded 28663 symbols from /boot/System.map-2.6.23-rc3-mm1-testing.
 Symbols match kernel version 2.6.23.
 No module symbols loaded - kernel modules not enabled.
=20
 klogd 1.4.1, log source =3D ksyslog started.
-<5>Linux version 2.6.23-rc3-testing (ts@xenon) (gcc version 4.1.2 200611=
15 (prerelease) (SUSE Linux)) #1 SMP PREEMPT Tue Aug 14 15:27:26 CEST 200=
7
+<5>Linux version 2.6.23-rc3-mm1-testing (ts@xenon) (gcc version 4.1.2 20=
061115 (prerelease) (SUSE Linux)) #1 SMP PREEMPT Thu Aug 23 00:02:51 CEST=
 2007
 <6>BIOS-provided physical RAM map:
 <4> BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 <4> BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
@@ -25,6 +25,7 @@
 <5>896MB LOWMEM available.
 <6>found SMP MP-table at 000fe200
 <7>Entering add_active_range(0, 0, 255744) 0 entries of 256 used
+<7>sizeof(struct page) =3D 56
 <4>Zone PFN ranges:
 <4>  DMA             0 ->     4096
 <4>  Normal       4096 ->   229376
@@ -33,6 +34,7 @@
 <4>early_node_map[1] active PFN ranges
 <4>    0:        0 ->   255744
 <7>On node 0 totalpages: 255744
+<7>Node 0 memmap at 0xc1000000 size 14336000 first pfn 0xc1000000
 <7>  DMA zone: 56 pages used for memmap
 <7>  DMA zone: 0 pages reserved
 <7>  DMA zone: 4040 pages, LIFO batch:0
@@ -82,16 +84,16 @@
 <4>swsusp: Registered nosave memory region: 000000000008f000 - 000000000=
00a0000
 <4>swsusp: Registered nosave memory region: 00000000000a0000 - 000000000=
00e0000
 <4>swsusp: Registered nosave memory region: 00000000000e0000 - 000000000=
0100000
-<4>Built 1 zonelists in Zone order.  Total pages: 252248
+<4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: =
252248
 <5>Kernel command line: root=3D/dev/system/root video=3Dmatroxfb:vesa:0x=
31b resume=3D/dev/system/swap splash=3Dverbose
 <7>mapped APIC to ffffb000 (fee00000)
 <7>mapped IOAPIC to ffffa000 (fec00000)
 <6>Enabling fast FPU save and restore... done.
 <6>Enabling unmasked SIMD FPU exception support... done.
 <6>Initializing CPU#0
-<4>CPU 0 irqstacks, hard=3Dc0451000 soft=3Dc0449000
+<4>CPU 0 irqstacks, hard=3Dc04d0000 soft=3Dc04c8000
 <4>PID hash table entries: 4096 (order: 12, 16384 bytes)
-<4>Detected 3197.068 MHz processor.
+<4>Detected 3196.982 MHz processor.
 <4>Console: colour VGA+ 80x25
 <6>console [tty0] enabled
 <4>Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Mol=
nar
@@ -188,21 +190,21 @@
 <4>---------------------------------
 <6>Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 <6>Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-<6>Memory: 993044k/1022976k available (2040k kernel code, 28100k reserve=
d, 1042k data, 252k init, 104484k highmem)
+<6>Memory: 992396k/1022976k available (2110k kernel code, 28776k reserve=
d, 1467k data, 260k init, 104484k highmem)
 <4>virtual kernel memory layout:
 <4>    fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
 <4>    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
 <4>    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
 <4>    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-<4>      .init : 0xc0407000 - 0xc0446000   ( 252 kB)
-<4>      .data : 0xc02fe179 - 0xc0402ce4   (1042 kB)
-<4>      .text : 0xc0100000 - 0xc02fe179   (2040 kB)
+<4>      .init : 0xc0483000 - 0xc04c4000   ( 260 kB)
+<4>      .data : 0xc030f81f - 0xc047e4c4   (1467 kB)
+<4>      .text : 0xc0100000 - 0xc030f81f   (2110 kB)
 <4>Checking if this processor honours the WP bit even in supervisor mode=
=2E.. Ok.
-<6>SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-1, MinObjects=3D4, CPUs=3D=
2, Nodes=3D1
-<6>hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
-<6>hpet0: 3 64-bit timers, 14318180 Hz
-<4>Calibrating delay using timer specific routine.. 6399.65 BogoMIPS (lp=
j=3D3199825)
-<6>Security Framework v1.0.0 initialized
+<6>SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-3, MinObjects=3D16, CPUs=
=3D2, Nodes=3D1
+<4>Calibrating delay using timer specific routine.. 6399.03 BogoMIPS (lp=
j=3D3199517)
+<6>kswapd reclaim order set to 3
+<6>Security Framework initialized
+<6>Capability LSM initialized
 <4>Mount-cache hash table entries: 512
 <7>CPU: After generic identify, caps: bfebfbff 20100000 00000000 0000000=
0 0000e4bd 00000000 00000001 00000000
 <4>monitor/mwait feature present.
@@ -223,9 +225,9 @@
 <4>CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
 <4>lockdep: not fixing up alternatives.
 <4>Booting processor 1/1 eip 3000
-<4>CPU 1 irqstacks, hard=3Dc0452000 soft=3Dc044a000
+<4>CPU 1 irqstacks, hard=3Dc04d1000 soft=3Dc04c9000
 <6>Initializing CPU#1
-<4>Calibrating delay using timer specific routine.. 6393.68 BogoMIPS (lp=
j=3D3196844)
+<4>Calibrating delay using timer specific routine.. 6392.76 BogoMIPS (lp=
j=3D3196383)
 <7>CPU: After generic identify, caps: bfebfbff 20100000 00000000 0000000=
0 0000e4bd 00000000 00000001 00000000
 <4>monitor/mwait feature present.
 <6>CPU: Trace cache: 12K uops, L1 D cache: 16K
@@ -238,23 +240,27 @@
 <6>CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
 <6>CPU1: Thermal monitoring enabled
 <4>CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
-<6>Total of 2 processors activated (12793.33 BogoMIPS).
+<6>Total of 2 processors activated (12791.80 BogoMIPS).
 <4>ENABLING IO-APIC IRQs
 <6>..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
-<6>checking TSC synchronization [CPU#0 -> CPU#1]: passed.
+<6>checking TSC synchronization [CPU#0 -> CPU#1]:
+<4>Measured 32 cycles TSC warp between CPUs, turning off TSC clock.
+<4>Marking TSC unstable due to: check_tsc_sync_source failed.
 <6>Brought up 2 CPUs
 <6>Booting paravirtualized kernel on bare hardware
 <6>NET: Registered protocol family 16
 <6>ACPI: bus type pci registered
-<3>PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
-<3>PCI: Not using MMCONFIG.
 <6>PCI: Using configuration type 1
 <4>Setting up standard PCI resources
 <7>ACPI: EC: Look up EC in DSDT
 <6>ACPI: Interpreter enabled
 <6>ACPI: (supports S0 S3)
 <6>ACPI: Using IOAPIC for interrupt routing
+<5>PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
+<5>PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
+<6>PCI: Using MMCONFIG
 <6>ACPI: PCI Root Bridge [PCI0] (0000:00)
+<7>PCI: Probing PCI hardware (bus 00)
 <4>PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
 <4>PCI quirk: region 0500-053f claimed by ICH6 GPIO
 <6>PCI: Transparent bridge - 0000:00:1e.0
@@ -285,7 +291,9 @@
 <6>NetLabel:  protocols =3D UNLABELED CIPSOv4
 <6>NetLabel:  unlabeled traffic allowed by default
 <4>ACPI: RTC can wake from S4
-<6>Time: tsc clocksource has been installed.
+<6>Time: hpet clocksource has been installed.
+<6>Switched to high resolution mode on CPU 0
+<6>Switched to high resolution mode on CPU 1
 <6>pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
 <6>pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
 <6>pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
@@ -340,15 +348,11 @@
 <6>TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
 <6>TCP: Hash tables configured (established 65536 bind 65536)
 <6>TCP reno registered
-<6>checking if image is initramfs...<6>Switched to high resolution mode =
on CPU 1
-<6>Switched to high resolution mode on CPU 0
-<4> it is
-<6>Freeing initrd memory: 7369k freed
+<6>checking if image is initramfs... it is
+<6>Freeing initrd memory: 7423k freed
 <6>Machine check exception polling timer started.
-<6>apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
-<5>apm: disabled - APM is not SMP safe.
 <6>audit: initializing netlink socket (disabled)
-<5>audit(1187997798.852:1): initialized
+<5>audit(2418234223.871:1): initialized
 <4>highmem bounce pool size: 64 pages
 <4>Total HugeTLB memory allocated, 0
 <5>VFS: Disk quotas dquot_6.5.1
@@ -363,22 +367,27 @@
 <4>assign_interrupt_mode Found MSI capability
 <7>Allocate Port Service[0000:00:1c.0:pcie00]
 <7>Allocate Port Service[0000:00:1c.0:pcie02]
+<7>Allocate Port Service[0000:00:1c.0:pcie03]
 <7>PCI: Setting latency timer of device 0000:00:1c.1 to 64
 <4>assign_interrupt_mode Found MSI capability
 <7>Allocate Port Service[0000:00:1c.1:pcie00]
 <7>Allocate Port Service[0000:00:1c.1:pcie02]
+<7>Allocate Port Service[0000:00:1c.1:pcie03]
 <7>PCI: Setting latency timer of device 0000:00:1c.2 to 64
 <4>assign_interrupt_mode Found MSI capability
 <7>Allocate Port Service[0000:00:1c.2:pcie00]
 <7>Allocate Port Service[0000:00:1c.2:pcie02]
+<7>Allocate Port Service[0000:00:1c.2:pcie03]
 <7>PCI: Setting latency timer of device 0000:00:1c.3 to 64
 <4>assign_interrupt_mode Found MSI capability
 <7>Allocate Port Service[0000:00:1c.3:pcie00]
 <7>Allocate Port Service[0000:00:1c.3:pcie02]
+<7>Allocate Port Service[0000:00:1c.3:pcie03]
 <7>PCI: Setting latency timer of device 0000:00:1c.4 to 64
 <4>assign_interrupt_mode Found MSI capability
 <7>Allocate Port Service[0000:00:1c.4:pcie00]
 <7>Allocate Port Service[0000:00:1c.4:pcie02]
+<7>Allocate Port Service[0000:00:1c.4:pcie03]
 <6>ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
 <6>matroxfb: Matrox G550 detected
 <6>PInS memtype =3D 5
@@ -390,7 +399,7 @@
 <4>fb0: MATROX frame buffer device
 <6>matroxfb_crtc2: secondary head of fb0 was registered as fb1
 <6>Real Time Clock Driver v1.12ac
-<7>hpet_resources: 0xfed00000 is busy
+<4>hpet_acpi_add: no address or irqs in _CRS
 <6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enab=
led
 <6>serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
 <6>00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
@@ -407,18 +416,15 @@
 <4>PNP: PS/2 appears to have AUX port disabled, if this is incorrect ple=
ase boot with i8042.nopnp
 <6>serio: i8042 KBD port at 0x60,0x64 irq 1
 <6>mice: PS/2 mouse device common for all mice
-<6>input: AT Translated Set 2 keyboard as /class/input/input0
-<6>input: PC Speaker as /class/input/input1
+<6>input: PC Speaker as /class/input/input0
 <6>NET: Registered protocol family 1
 <6>Starting balanced_irq
 <4>Using IPI No-Shortcut mode
-<6>Freeing unused kernel memory: 252k freed
-<4>Write protecting the kernel read-only data: 814k
+<6>Freeing unused kernel memory: 260k freed
+<4>Write protecting the kernel read-only data: 1215k
+<6>input: AT Translated Set 2 keyboard as /class/input/input1
 <5>SCSI subsystem initialized
-<6>ACPI: Processor [CPU0] (supports 8 throttling states)
-<6>ACPI: Processor [CPU1] (supports 8 throttling states)
-<4>ACPI Exception (processor_core-0790): AE_NOT_FOUND, Processor Device =
is not present [20070126]
-<4>ACPI Exception (processor_core-0790): AE_NOT_FOUND, Processor Device =
is not present [20070126]
+<4>thermal: Unknown symbol acpi_processor_set_thermal_limit
 <7>libata version 2.21 loaded.
 <7>ahci 0000:00:1f.2: version 2.3
 <6>ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
@@ -431,12 +437,12 @@
 <6>scsi3 : ahci
 <6>scsi4 : ahci
 <6>scsi5 : ahci
-<6>ata1: SATA max UDMA/133 cmd 0xf887c100 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
-<6>ata2: SATA max UDMA/133 cmd 0xf887c180 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
-<6>ata3: SATA max UDMA/133 cmd 0xf887c200 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
-<6>ata4: SATA max UDMA/133 cmd 0xf887c280 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
-<6>ata5: SATA max UDMA/133 cmd 0xf887c300 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
-<6>ata6: SATA max UDMA/133 cmd 0xf887c380 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata1: SATA max UDMA/133 cmd 0xf883c100 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata2: SATA max UDMA/133 cmd 0xf883c180 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata3: SATA max UDMA/133 cmd 0xf883c200 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata4: SATA max UDMA/133 cmd 0xf883c280 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata5: SATA max UDMA/133 cmd 0xf883c300 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
+<6>ata6: SATA max UDMA/133 cmd 0xf883c380 ctl 0x00000000 bmdma 0x0000000=
0 irq 218
 <6>ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 <6>ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
 <6>ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
@@ -465,12 +471,12 @@
 <5>sd 1:0:0:0: [sdb] Write Protect is off
 <7>sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
 <5>sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA
+<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
 <5>sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
 <5>sd 1:0:0:0: [sdb] Write Protect is off
 <7>sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
 <5>sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA
-<6> sdb:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
-<4> sdb1
+<6> sdb: sdb1
 <5>sd 1:0:0:0: [sdb] Attached SCSI disk
 <5>sd 1:0:0:0: Attached scsi generic sg1 type 0
 <6>ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 16
@@ -517,94 +523,139 @@
 <5>st 8:0:12:0: Attached scsi tape st0
 <6>st 8:0:12:0: st0: try direct i/o: yes (alignment 512 B)
 <6>Linux agpgart interface v0.102
+<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
+<4>rtc_cmos: probe of 00:03 failed with error -16
+<6>agpgart: suspend/resume problematic: resume with 3D/DRI active may lo=
ckup X.Org
+<4>on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
 <6>agpgart: Detected an Intel 965Q Chipset.
 <6>agpgart: Unknown page table size, assuming 512KB
 <6>agpgart: Detected 7676K stolen memory.
 <6>agpgart: AGP aperture is 256M @ 0x40000000
-<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
-<4>rtc_cmos: probe of 00:03 failed with error -16
 <6>ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 21 (level, low) -> IRQ 22
 <6>usbcore: registered new interface driver usbfs
 <6>usbcore: registered new interface driver hub
 <6>usbcore: registered new device driver usb
 <6>ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 19 (level, low) -> IRQ 19
-<6>ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
-<7>PCI: Setting latency timer of device 0000:00:1a.7 to 64
-<6>ehci_hcd 0000:00:1a.7: EHCI Host Controller
-<6>ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
-<5>firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
-<6>ehci_hcd 0000:00:1a.7: debug port 1
-<7>PCI: cache line size of 128 is not supported by device 0000:00:1a.7
-<6>ehci_hcd 0000:00:1a.7: irq 18, io mem 0x52c25c00
-<6>ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=

-<6>usb usb1: configuration #1 chosen from 1 choice
-<6>hub 1-0:1.0: USB hub found
-<6>hub 1-0:1.0: 4 ports detected
 <6>USB Universal Host Controller Interface driver v3.0
-<6>ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
-<7>PCI: Setting latency timer of device 0000:00:1d.7 to 64
-<6>ehci_hcd 0000:00:1d.7: EHCI Host Controller
-<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
-<6>ehci_hcd 0000:00:1d.7: debug port 1
-<7>PCI: cache line size of 128 is not supported by device 0000:00:1d.7
-<6>ehci_hcd 0000:00:1d.7: irq 23, io mem 0x52c25800
-<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=

-<6>usb usb2: configuration #1 chosen from 1 choice
-<6>hub 2-0:1.0: USB hub found
-<6>hub 2-0:1.0: 6 ports detected
 <6>ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 17
 <7>PCI: Setting latency timer of device 0000:00:1a.0 to 64
 <6>uhci_hcd 0000:00:1a.0: UHCI Host Controller
-<6>uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
+<6>uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
 <6>uhci_hcd 0000:00:1a.0: irq 17, io base 0x000030c0
-<6>usb usb3: configuration #1 chosen from 1 choice
-<6>hub 3-0:1.0: USB hub found
-<6>hub 3-0:1.0: 2 ports detected
+<6>usb usb1: configuration #1 chosen from 1 choice
+<6>hub 1-0:1.0: USB hub found
+<6>hub 1-0:1.0: 2 ports detected
+<5>firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
+<6>usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb1: Product: UHCI Host Controller
+<6>usb usb1: Manufacturer: Linux 2.6.23-rc3-mm1-testing uhci_hcd
+<6>usb usb1: SerialNumber: 0000:00:1a.0
 <6>ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 22
 <7>PCI: Setting latency timer of device 0000:00:1a.1 to 64
 <6>uhci_hcd 0000:00:1a.1: UHCI Host Controller
-<6>uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
+<6>uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
 <6>uhci_hcd 0000:00:1a.1: irq 22, io base 0x000030a0
-<6>usb usb4: configuration #1 chosen from 1 choice
-<6>hub 4-0:1.0: USB hub found
-<6>hub 4-0:1.0: 2 ports detected
-<5>firewire_core: created new fw device fw0 (0 config rom retries, S400)=

+<6>usb usb2: configuration #1 chosen from 1 choice
+<6>hub 2-0:1.0: USB hub found
+<6>hub 2-0:1.0: 2 ports detected
+<6>usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb2: Product: UHCI Host Controller
+<6>usb usb2: Manufacturer: Linux 2.6.23-rc3-mm1-testing uhci_hcd
+<6>usb usb2: SerialNumber: 0000:00:1a.1
+<6>ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
+<7>PCI: Setting latency timer of device 0000:00:1a.7 to 64
+<6>ehci_hcd 0000:00:1a.7: EHCI Host Controller
+<6>ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
+<6>ehci_hcd 0000:00:1a.7: debug port 1
+<7>PCI: cache line size of 128 is not supported by device 0000:00:1a.7
+<6>ehci_hcd 0000:00:1a.7: irq 18, io mem 0x52c25c00
+<6>ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=

+<6>usb usb3: configuration #1 chosen from 1 choice
+<6>hub 3-0:1.0: USB hub found
+<6>hub 3-0:1.0: 4 ports detected
+<6>usb usb3: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb3: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb3: Product: EHCI Host Controller
+<6>usb usb3: Manufacturer: Linux 2.6.23-rc3-mm1-testing ehci_hcd
+<6>usb usb3: SerialNumber: 0000:00:1a.7
 <6>ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
 <7>PCI: Setting latency timer of device 0000:00:1d.0 to 64
 <6>uhci_hcd 0000:00:1d.0: UHCI Host Controller
-<6>uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
+<6>uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
 <6>uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
-<6>usb usb5: configuration #1 chosen from 1 choice
-<6>hub 5-0:1.0: USB hub found
-<6>hub 5-0:1.0: 2 ports detected
-<6>ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
-<7>PCI: Setting latency timer of device 0000:00:1b.0 to 64
-<7>ALSA sound/pci/hda/hda_codec.c:2331: autoconfig: line_outs=3D1 (0xd/0=
x0/0x0/0x0/0x0)
-<7>ALSA sound/pci/hda/hda_codec.c:2335:    speaker_outs=3D0 (0x0/0x0/0x0=
/0x0/0x0)
-<7>ALSA sound/pci/hda/hda_codec.c:2339:    hp_outs=3D1 (0xa/0x0/0x0/0x0/=
0x0)
-<7>ALSA sound/pci/hda/hda_codec.c:2347:    inputs: mic=3D0xe, fmic=3D0xb=
, line=3D0xf, fline=3D0x0, cd=3D0x0, aux=3D0x0
-<7>ALSA sound/pci/hda/patch_sigmatel.c:1297: dac_nids=3D3 (0x2/0x5/0x4/0=
x0/0x0)
+<6>usb usb4: configuration #1 chosen from 1 choice
+<6>hub 4-0:1.0: USB hub found
+<6>hub 4-0:1.0: 2 ports detected
+<5>firewire_core: created new fw device fw0 (0 config rom retries, S400)=

+<6>usb usb4: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb4: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb4: Product: UHCI Host Controller
+<6>usb usb4: Manufacturer: Linux 2.6.23-rc3-mm1-testing uhci_hcd
+<6>usb usb4: SerialNumber: 0000:00:1d.0
 <6>ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
 <7>PCI: Setting latency timer of device 0000:00:1d.1 to 64
 <6>uhci_hcd 0000:00:1d.1: UHCI Host Controller
-<6>uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
+<6>uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
 <6>uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
-<6>usb usb6: configuration #1 chosen from 1 choice
-<6>hub 6-0:1.0: USB hub found
-<6>hub 6-0:1.0: 2 ports detected
+<6>usb usb5: configuration #1 chosen from 1 choice
+<6>hub 5-0:1.0: USB hub found
+<6>hub 5-0:1.0: 2 ports detected
+<6>usb usb5: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb5: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb5: Product: UHCI Host Controller
+<6>usb usb5: Manufacturer: Linux 2.6.23-rc3-mm1-testing uhci_hcd
+<6>usb usb5: SerialNumber: 0000:00:1d.1
 <6>ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
 <7>PCI: Setting latency timer of device 0000:00:1d.2 to 64
 <6>uhci_hcd 0000:00:1d.2: UHCI Host Controller
-<6>uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
+<6>uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
 <6>uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
+<6>usb usb6: configuration #1 chosen from 1 choice
+<6>hub 6-0:1.0: USB hub found
+<6>hub 6-0:1.0: 2 ports detected
+<6>usb usb6: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb6: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb6: Product: UHCI Host Controller
+<6>usb usb6: Manufacturer: Linux 2.6.23-rc3-mm1-testing uhci_hcd
+<6>usb usb6: SerialNumber: 0000:00:1d.2
+<6>ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
+<7>PCI: Setting latency timer of device 0000:00:1d.7 to 64
+<6>ehci_hcd 0000:00:1d.7: EHCI Host Controller
+<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
+<6>ehci_hcd 0000:00:1d.7: debug port 1
+<7>PCI: cache line size of 128 is not supported by device 0000:00:1d.7
+<6>ehci_hcd 0000:00:1d.7: irq 23, io mem 0x52c25800
+<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=

+<6>usb 5-2: new low speed USB device using uhci_hcd and address 2
 <6>usb usb7: configuration #1 chosen from 1 choice
 <6>hub 7-0:1.0: USB hub found
-<6>hub 7-0:1.0: 2 ports detected
-<6>usb 6-2: new low speed USB device using uhci_hcd and address 2
-<6>usb 6-2: configuration #1 chosen from 1 choice
+<6>hub 7-0:1.0: 6 ports detected
+<6>usb usb7: new device found, idVendor=3D0000, idProduct=3D0000
+<6>usb usb7: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
+<6>usb usb7: Product: EHCI Host Controller
+<6>usb usb7: Manufacturer: Linux 2.6.23-rc3-mm1-testing ehci_hcd
+<6>usb usb7: SerialNumber: 0000:00:1d.7
+<6>ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
+<7>PCI: Setting latency timer of device 0000:00:1b.0 to 64
+<7>ALSA sound/pci/hda/hda_codec.c:2735: autoconfig: line_outs=3D1 (0xd/0=
x0/0x0/0x0/0x0)
+<7>ALSA sound/pci/hda/hda_codec.c:2739:    speaker_outs=3D0 (0x0/0x0/0x0=
/0x0/0x0)
+<7>ALSA sound/pci/hda/hda_codec.c:2743:    hp_outs=3D1 (0xa/0x0/0x0/0x0/=
0x0)
+<7>ALSA sound/pci/hda/hda_codec.c:2751:    inputs: mic=3D0xe, fmic=3D0xb=
, line=3D0xf, fline=3D0x0, cd=3D0x0, aux=3D0x0
+<7>ALSA sound/pci/hda/patch_sigmatel.c:1344: dac_nids=3D3 (0x2/0x5/0x4/0=
x0/0x0)
 <6>Adding 2097144k swap on /dev/system/swap.  Priority:-1 extents:1 acro=
ss:2097144k
-<6>usb 7-1: new full speed USB device using uhci_hcd and address 2
-<6>usb 7-1: configuration #1 chosen from 1 choice
+<6>usb 5-2: new low speed USB device using uhci_hcd and address 3
+<6>usb 5-2: configuration #1 chosen from 1 choice
+<6>usb 5-2: new device found, idVendor=3D413c, idProduct=3D3010
+<6>usb 5-2: new device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
+<6>usb 6-1: new full speed USB device using uhci_hcd and address 2
+<6>usb 6-1: configuration #1 chosen from 1 choice
+<6>usb 6-1: new device found, idVendor=3D0681, idProduct=3D0002
+<6>usb 6-1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
+<6>usb 6-1: Product: Sinus 45 AB isdn
+<6>usb 6-1: Manufacturer: Siemens AG
+<6>usb 6-1: SerialNumber: 002F970BE0
 <6>usbcore: registered new interface driver hiddev
 <6>input: HID 413c:3010 as /class/input/input2
 <6>input: USB HID v1.00 Mouse [HID 413c:3010] on usb-0000:00:1d.1-2
@@ -617,9 +668,10 @@
 <7>gigaset: Register driver capabilities to LL
 <7>bas_gigaset: gigaset_probe: Check if device matches .. (Vendor: 0x681=
, Product: 0x2)
 <7>bas_gigaset: gigaset_probe: wrong alternate setting 0 - trying to swi=
tch
-<6>usb 7-1: gigaset_probe: Device matched (Vendor: 0x681, Product: 0x2)
+<6>usb 6-1: gigaset_probe: Device matched (Vendor: 0x681, Product: 0x2)
 <7>bas_gigaset: -------> 0x34 (0)
 <7>gigaset: scheduling START
+<7>bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
 <7>gigaset: connection state 0, event -110
 <7>gigaset: unblocking all channels
 <7>gigaset: blocking all channels
@@ -630,7 +682,6 @@
 <7>gigaset: connection state 0, event -27
 <6>usbcore: registered new interface driver bas_gigaset
 <6>bas_gigaset: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@=
web.de>, Stefan Eilers
-<7>bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
 <6>bas_gigaset: USB Driver for Gigaset 307x
 <7>bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
 <7>gigaset: scheduling timeout

--------------060401020703050807050402--

--------------enig409D29879952063DD3D04F5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGz3xHMdB4Whm86/kRAs14AJ4iVE47mv0nTYg7Ly9GIKKCwdH3CgCfRSoX
NXrxmAG8jRxyhbFw3aJKhAc=
=+229
-----END PGP SIGNATURE-----

--------------enig409D29879952063DD3D04F5F--
