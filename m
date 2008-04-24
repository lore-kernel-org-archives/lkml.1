Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYDXHPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYDXHPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYDXHP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:15:28 -0400
Received: from mail.southa.com ([125.215.237.177]:44855 "HELO southa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751015AbYDXHP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:15:26 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 03:15:24 EDT
Message-ID: <001201c8a5da$01ccc630$9d02a8c0@kyle>
From: "kyle" <kylewong@southa.com>
To: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: ahci slow transfer rate with kernel 2.6.23-2.6.25
Date: Thu, 24 Apr 2008 15:08:32 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000F_01C8A61D.0FB212D0"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_000F_01C8A61D.0FB212D0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Please cc me if possible, thanks.

I've built a new machine with Intel Desktop Board DQ35JO, Intel E2160 CPU,
and 8 x Seagate ST3500320AS 500MB SATA harddisks. 6 of the 8 harddisks are
connected to the motherboard's SATA ports, while the remaining 2 are
connected to a 2 ports PCI-E card with sil24.

kernel is 2.6.24.5, have tried fedora kernel 2.6.23.1-42 and 2.6.24.4-64,
all give the same result. 2.6.25 doesn't help.

I have another production server running 2.6.22.5, same harddisk connected
to ICH8R, does not have the transfer rate problem.

sda,b,c .... to sdf are running ahci driver, sdg and sdh are running sil24
driver

hdparm -t /dev/sd{a-f} give around 45-46MB/sec
[root@localhost log]# hdparm -t /dev/sda
/dev/sda:
 Timing buffered disk reads:  140 MB in  3.02 seconds =  46.42 MB/sec

hdparm -t /dev/sdg and sdh give over 105MB/sec
[root@localhost log]# hdparm -t /dev/sdg
/dev/sdg:
 Timing buffered disk reads:  316 MB in  3.01 seconds = 105.13 MB/sec

had updated the motherboard to latest BIOS, no change in hdparm test
b4/after update.
dd to /dev/null from sda,sdb ... also show the same result, around 4xMB/s,
dd from sdg, sdh give over 100MB/s
hdparm -i:

[root@localhost boot]# hdparm -i /dev/sda
/dev/sda:
 Model=ST3500320AS                             , FwRev=SD15    , SerialNo=
      9QM2Q7F4
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7
 * signifies the current active mode

[root@localhost boot]# hdparm -i /dev/sdb

/dev/sdb:

 Model=ST3500320AS                             , FwRev=SD15    , SerialNo=
      9QM2H18H
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode

...........................

[root@localhost boot]# hdparm -i /dev/sdg

/dev/sdg:

 Model=ST3500320AS                             , FwRev=SD15    , SerialNo=
      9QM2LE0C
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode
attached dmesg

Since I'll run a 8x500GB raid5 on this machine, slow transfer rate of AHCI
driven harddisks will
slow down the create / check / resync ... etc of the whole array.

Please help, thank you very much

Regards,
Kyle

------=_NextPart_000_000F_01C8A61D.0FB212D0
Content-Type: application/octet-stream;
	name="dmesg.dat"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.dat"

Initializing cgroup subsys cpuset=0A=
Linux version 2.6.24.5 (root@localhost.localdomain) (gcc version 4.1.2 =
20070925 (Red Hat 4.1.2-33)) #1 SMP Sun Apr 20 01:53:46 EDT 2008=0A=
Command line: ro root=3D/dev/md1 rhgb quiet=0A=
BIOS-provided physical RAM map:=0A=
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)=0A=
 BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)=0A=
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)=0A=
 BIOS-e820: 0000000000100000 - 00000000cdc4d000 (usable)=0A=
 BIOS-e820: 00000000cdc4d000 - 00000000cdce5000 (ACPI NVS)=0A=
 BIOS-e820: 00000000cdce5000 - 00000000ceeca000 (usable)=0A=
 BIOS-e820: 00000000ceeca000 - 00000000ceecc000 (reserved)=0A=
 BIOS-e820: 00000000ceecc000 - 00000000cef7a000 (usable)=0A=
 BIOS-e820: 00000000cef7a000 - 00000000cefe5000 (ACPI NVS)=0A=
 BIOS-e820: 00000000cefe5000 - 00000000cefe8000 (usable)=0A=
 BIOS-e820: 00000000cefe8000 - 00000000ceff3000 (ACPI data)=0A=
 BIOS-e820: 00000000ceff3000 - 00000000ceff4000 (usable)=0A=
 BIOS-e820: 00000000ceff4000 - 00000000cefff000 (ACPI data)=0A=
 BIOS-e820: 00000000cefff000 - 00000000cf000000 (usable)=0A=
 BIOS-e820: 00000000cf000000 - 00000000d0000000 (reserved)=0A=
 BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)=0A=
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)=0A=
 BIOS-e820: 0000000100000000 - 000000012c000000 (usable)=0A=
Entering add_active_range(0, 0, 156) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 842829) 1 entries of 256 used=0A=
Entering add_active_range(0, 842981, 847562) 2 entries of 256 used=0A=
Entering add_active_range(0, 847564, 847738) 3 entries of 256 used=0A=
Entering add_active_range(0, 847845, 847848) 4 entries of 256 used=0A=
Entering add_active_range(0, 847859, 847860) 5 entries of 256 used=0A=
Entering add_active_range(0, 847871, 847872) 6 entries of 256 used=0A=
Entering add_active_range(0, 1048576, 1228800) 7 entries of 256 used=0A=
end_pfn_map =3D 1228800=0A=
DMI 2.4 present.=0A=
ACPI: RSDP 000FE020, 0014 (r0 INTEL )=0A=
ACPI: RSDT CEFFD038, 0068 (r1 INTEL  DQ3510J       361       1000013)=0A=
ACPI: FACP CEFFC000, 0074 (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: DSDT CEFF8000, 3D3A (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: FACS CEF87000, 0040=0A=
ACPI: APIC CEFF7000, 0078 (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: WDDT CEFF6000, 0040 (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: MCFG CEFF5000, 003C (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: ASF! CEFF4000, 00A6 (r32 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: ASPT CEFF2000, 002C (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: WDTT CEFF1000, 02CC (r1 INTEL  DQ3510J       361 MSFT  1000013)=0A=
ACPI: SSDT CEFF0000, 0204 (r1 INTEL     CpuPm      361 MSFT  1000013)=0A=
ACPI: SSDT CEFEF000, 01F9 (r1 INTEL   Cpu0Ist      361 MSFT  1000013)=0A=
ACPI: SSDT CEFEE000, 01F9 (r1 INTEL   Cpu1Ist      361 MSFT  1000013)=0A=
ACPI: SSDT CEFED000, 01F9 (r1 INTEL   Cpu2Ist      361 MSFT  1000013)=0A=
ACPI: SSDT CEFEC000, 01F9 (r1 INTEL   Cpu3Ist      361 MSFT  1000013)=0A=
ACPI: SSDT CEFEB000, 00DD (r1 INTEL   Cpu0Cst      361 MSFT  1000013)=0A=
ACPI: SSDT CEFEA000, 00DD (r1 INTEL   Cpu1Cst      361 MSFT  1000013)=0A=
ACPI: SSDT CEFE9000, 00DD (r1 INTEL   Cpu2Cst      361 MSFT  1000013)=0A=
ACPI: SSDT CEFE8000, 00DD (r1 INTEL   Cpu3Cst      361 MSFT  1000013)=0A=
ACPI: TCPA CEF7B000, 0032 (r2 INTEL  TIANO           2 MSFT  1000013)=0A=
Entering add_active_range(0, 0, 156) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 842829) 1 entries of 256 used=0A=
Entering add_active_range(0, 842981, 847562) 2 entries of 256 used=0A=
Entering add_active_range(0, 847564, 847738) 3 entries of 256 used=0A=
Entering add_active_range(0, 847845, 847848) 4 entries of 256 used=0A=
Entering add_active_range(0, 847859, 847860) 5 entries of 256 used=0A=
Entering add_active_range(0, 847871, 847872) 6 entries of 256 used=0A=
Entering add_active_range(0, 1048576, 1228800) 7 entries of 256 used=0A=
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0=0A=
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0=0A=
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0=0A=
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0=0A=
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0=0A=
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0=0A=
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0=0A=
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0=0A=
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0=0A=
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0=0A=
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0=0A=
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0=0A=
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0=0A=
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0=0A=
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0=0A=
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0=0A=
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0=0A=
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0=0A=
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0=0A=
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0=0A=
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0=0A=
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0=0A=
 [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0=0A=
 [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0=0A=
 [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0=0A=
 [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0=0A=
 [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0=0A=
 [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0=0A=
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0=0A=
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0=0A=
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0=0A=
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0=0A=
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0=0A=
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0=0A=
Zone PFN ranges:=0A=
  DMA             0 ->     4096=0A=
  DMA32        4096 ->  1048576=0A=
  Normal    1048576 ->  1228800=0A=
Movable zone start PFN for each node=0A=
early_node_map[8] active PFN ranges=0A=
    0:        0 ->      156=0A=
    0:      256 ->   842829=0A=
    0:   842981 ->   847562=0A=
    0:   847564 ->   847738=0A=
    0:   847845 ->   847848=0A=
    0:   847859 ->   847860=0A=
    0:   847871 ->   847872=0A=
    0:  1048576 ->  1228800=0A=
On node 0 totalpages: 1027713=0A=
  DMA zone: 56 pages used for memmap=0A=
  DMA zone: 1042 pages reserved=0A=
  DMA zone: 2898 pages, LIFO batch:0=0A=
  DMA32 zone: 14280 pages used for memmap=0A=
  DMA32 zone: 829213 pages, LIFO batch:31=0A=
  Normal zone: 2464 pages used for memmap=0A=
  Normal zone: 177760 pages, LIFO batch:31=0A=
  Movable zone: 0 pages used for memmap=0A=
ACPI: PM-Timer IO Port: 0x408=0A=
ACPI: Local APIC address 0xfee00000=0A=
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)=0A=
Processor #0 (Bootup-CPU)=0A=
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)=0A=
Processor #1=0A=
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)=0A=
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)=0A=
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])=0A=
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])=0A=
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=0A=
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: IRQ0 used by override.=0A=
ACPI: IRQ2 used by override.=0A=
ACPI: IRQ9 used by override.=0A=
Setting APIC routing to flat=0A=
Using ACPI (MADT) for SMP configuration information=0A=
Allocating PCI resources starting at d2000000 (gap: d0000000:20000000)=0A=
SMP: Allowing 4 CPUs, 2 hotplug CPUs=0A=
PERCPU: Allocating 40304 bytes of per cpu data=0A=
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: =
1009871=0A=
Kernel command line: ro root=3D/dev/md1 rhgb quiet=0A=
Initializing CPU#0=0A=
PID hash table entries: 4096 (order: 12, 32768 bytes)=0A=
TSC calibrated against PM_TIMER=0A=
time.c: Detected 1795.482 MHz processor.=0A=
Console: colour VGA+ 80x25=0A=
console [tty0] enabled=0A=
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)=0A=
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)=0A=
Checking aperture...=0A=
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)=0A=
Placing software IO TLB between 0x9e1f000 - 0xde1f000=0A=
Memory: 3960320k/4915200k available (2053k kernel code, 149848k =
reserved, 1005k data, 232k init)=0A=
SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-1, MinObjects=3D4, =
CPUs=3D4, Nodes=3D1=0A=
Calibrating delay using timer specific routine.. 3593.93 BogoMIPS =
(lpj=3D7187868)=0A=
Security Framework initialized=0A=
Capability LSM initialized=0A=
Mount-cache hash table entries: 256=0A=
Initializing cgroup subsys ns=0A=
Initializing cgroup subsys cpuacct=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 1024K=0A=
using mwait in idle threads.=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 0=0A=
SMP alternatives: switching to UP code=0A=
ACPI: Core revision 20070126=0A=
Using local APIC timer interrupts.=0A=
APIC timer calibration result 12468625=0A=
Detected 12.468 MHz APIC timer.=0A=
SMP alternatives: switching to SMP code=0A=
Booting processor 1/2 APIC 0x1=0A=
Initializing CPU#1=0A=
Calibrating delay using timer specific routine.. 3590.98 BogoMIPS =
(lpj=3D7181976)=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 1024K=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 1=0A=
Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d=0A=
checking TSC synchronization [CPU#0 -> CPU#1]: passed.=0A=
Brought up 2 CPUs=0A=
net_namespace: 120 bytes=0A=
NET: Registered protocol family 16=0A=
ACPI: bus type pci registered=0A=
PCI: Using MMCONFIG at f0000000 - f7ffffff=0A=
ACPI: EC: Look up EC in DSDT=0A=
ACPI: Interpreter enabled=0A=
ACPI: (supports S0 S5)=0A=
ACPI: Using IOAPIC for interrupt routing=0A=
ACPI: PCI Root Bridge [PCI0] (0000:00)=0A=
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO=0A=
PCI quirk: region 0500-053f claimed by ICH6 GPIO=0A=
PCI: Transparent bridge - 0000:00:1e.0=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]=0A=
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)=0A=
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)=0A=
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)=0A=
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)=0A=
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)=0A=
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *9 10 11 12)=0A=
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)=0A=
Linux Plug and Play Support v0.97 (c) Adam Belay=0A=
pnp: PnP ACPI init=0A=
ACPI: bus type pnp registered=0A=
pnp: PnP ACPI: found 10 devices=0A=
ACPI: ACPI bus type pnp unregistered=0A=
usbcore: registered new interface driver usbfs=0A=
usbcore: registered new interface driver hub=0A=
usbcore: registered new device driver usb=0A=
PCI: Using ACPI for IRQ routing=0A=
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post =
a report=0A=
PCI-GART: No AMD northbridge found.=0A=
Time: tsc clocksource has been installed.=0A=
system 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved=0A=
system 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved=0A=
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved=0A=
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved=0A=
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved=0A=
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved=0A=
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved=0A=
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved=0A=
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved=0A=
system 00:01: iomem range 0xc0000-0xdffff has been reserved=0A=
system 00:01: iomem range 0xe0000-0xfffff could not be reserved=0A=
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved=0A=
system 00:06: ioport range 0x500-0x53f has been reserved=0A=
system 00:06: ioport range 0x400-0x47f has been reserved=0A=
system 00:06: ioport range 0x680-0x6ff has been reserved=0A=
PCI: Bridge: 0000:00:1c.0=0A=
  IO window: 3000-3fff=0A=
  MEM window: e0200000-e02fffff=0A=
  PREFETCH window: e0600000-e06fffff=0A=
PCI: Bridge: 0000:00:1c.1=0A=
  IO window: disabled.=0A=
  MEM window: disabled.=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.2=0A=
  IO window: 2000-2fff=0A=
  MEM window: e0100000-e01fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.3=0A=
  IO window: disabled.=0A=
  MEM window: disabled.=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.4=0A=
  IO window: disabled.=0A=
  MEM window: disabled.=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1e.0=0A=
  IO window: 1000-1fff=0A=
  MEM window: e0000000-e00fffff=0A=
  PREFETCH window: disabled.=0A=
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:1c.1 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:1c.2 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
PCI: Setting latency timer of device 0000:00:1e.0 to 64=0A=
NET: Registered protocol family 2=0A=
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)=0A=
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)=0A=
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)=0A=
TCP: Hash tables configured (established 262144 bind 65536)=0A=
TCP reno registered=0A=
checking if image is initramfs... it is=0A=
Freeing initrd memory: 3435k freed=0A=
audit: initializing netlink socket (disabled)=0A=
audit(1208956360.700:1): initialized=0A=
Total HugeTLB memory allocated, 0=0A=
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)=0A=
io scheduler noop registered=0A=
io scheduler anticipatory registered=0A=
io scheduler deadline registered=0A=
io scheduler cfq registered (default)=0A=
Boot video device is 0000:00:02.0=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.0:pcie00]=0A=
Allocate Port Service[0000:00:1c.0:pcie02]=0A=
Allocate Port Service[0000:00:1c.0:pcie03]=0A=
PCI: Setting latency timer of device 0000:00:1c.1 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.1:pcie00]=0A=
Allocate Port Service[0000:00:1c.1:pcie02]=0A=
Allocate Port Service[0000:00:1c.1:pcie03]=0A=
PCI: Setting latency timer of device 0000:00:1c.2 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.2:pcie00]=0A=
Allocate Port Service[0000:00:1c.2:pcie02]=0A=
Allocate Port Service[0000:00:1c.2:pcie03]=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.3:pcie00]=0A=
Allocate Port Service[0000:00:1c.3:pcie02]=0A=
Allocate Port Service[0000:00:1c.3:pcie03]=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.4:pcie00]=0A=
Allocate Port Service[0000:00:1c.4:pcie02]=0A=
Allocate Port Service[0000:00:1c.4:pcie03]=0A=
Monitor-Mwait will be used to enter C-1 state=0A=
ACPI: Processor [CPU0] (supports 8 throttling states)=0A=
ACPI: Processor [CPU1] (supports 8 throttling states)=0A=
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is =
not present [20070126]=0A=
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is =
not present [20070126]=0A=
Real Time Clock Driver v1.12ac=0A=
Non-volatile memory driver v1.2=0A=
Linux agpgart interface v0.102=0A=
agpgart: Detected an Intel Q35 Chipset.=0A=
agpgart: Detected 7164K stolen memory.=0A=
agpgart: AGP aperture is 256M @ 0xd0000000=0A=
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled=0A=
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17=0A=
0000:00:03.3: ttyS0 at I/O 0x4440 (irq =3D 17) is a 16550A=0A=
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize=0A=
input: Macintosh mouse button emulation as /class/input/input0=0A=
PNP: No PS/2 controller found. Probing ports directly.=0A=
serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
mice: PS/2 mouse device common for all mice=0A=
Switched to high resolution mode on CPU 1=0A=
Switched to high resolution mode on CPU 0=0A=
cpuidle: using governor ladder=0A=
cpuidle: using governor menu=0A=
usbcore: registered new interface driver hiddev=0A=
usbcore: registered new interface driver usbhid=0A=
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver=0A=
TCP cubic registered=0A=
NET: Registered protocol family 1=0A=
NET: Registered protocol family 17=0A=
registered taskstats version 1=0A=
Freeing unused kernel memory: 232k freed=0A=
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1a.7 to 64=0A=
ehci_hcd 0000:00:1a.7: EHCI Host Controller=0A=
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1=0A=
ehci_hcd 0000:00:1a.7: debug port 1=0A=
PCI: cache line size of 32 is not supported by device 0000:00:1a.7=0A=
ehci_hcd 0000:00:1a.7: irq 17, io mem 0xe0522c00=0A=
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=0A=
usb usb1: configuration #1 chosen from 1 choice=0A=
hub 1-0:1.0: USB hub found=0A=
hub 1-0:1.0: 6 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23=0A=
PCI: Setting latency timer of device 0000:00:1d.7 to 64=0A=
ehci_hcd 0000:00:1d.7: EHCI Host Controller=0A=
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2=0A=
ehci_hcd 0000:00:1d.7: debug port 1=0A=
PCI: cache line size of 32 is not supported by device 0000:00:1d.7=0A=
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0522800=0A=
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=0A=
usb usb2: configuration #1 chosen from 1 choice=0A=
hub 2-0:1.0: USB hub found=0A=
hub 2-0:1.0: 6 ports detected=0A=
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver=0A=
USB Universal Host Controller Interface driver v3.0=0A=
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:1a.0 to 64=0A=
uhci_hcd 0000:00:1a.0: UHCI Host Controller=0A=
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3=0A=
uhci_hcd 0000:00:1a.0: irq 18, io base 0x000040e0=0A=
usb usb3: configuration #1 chosen from 1 choice=0A=
hub 3-0:1.0: USB hub found=0A=
hub 3-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21=0A=
PCI: Setting latency timer of device 0000:00:1a.1 to 64=0A=
uhci_hcd 0000:00:1a.1: UHCI Host Controller=0A=
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4=0A=
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000040c0=0A=
usb usb4: configuration #1 chosen from 1 choice=0A=
hub 4-0:1.0: USB hub found=0A=
hub 4-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1a.2 to 64=0A=
uhci_hcd 0000:00:1a.2: UHCI Host Controller=0A=
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5=0A=
uhci_hcd 0000:00:1a.2: irq 17, io base 0x000040a0=0A=
usb usb5: configuration #1 chosen from 1 choice=0A=
hub 5-0:1.0: USB hub found=0A=
hub 5-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23=0A=
PCI: Setting latency timer of device 0000:00:1d.0 to 64=0A=
uhci_hcd 0000:00:1d.0: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6=0A=
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080=0A=
usb usb6: configuration #1 chosen from 1 choice=0A=
hub 6-0:1.0: USB hub found=0A=
hub 6-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1d.1 to 64=0A=
uhci_hcd 0000:00:1d.1: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7=0A=
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060=0A=
usb usb7: configuration #1 chosen from 1 choice=0A=
hub 7-0:1.0: USB hub found=0A=
hub 7-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:1d.2 to 64=0A=
uhci_hcd 0000:00:1d.2: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8=0A=
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040=0A=
usb usb8: configuration #1 chosen from 1 choice=0A=
hub 8-0:1.0: USB hub found=0A=
hub 8-0:1.0: 2 ports detected=0A=
md: raid1 personality registered for level 1=0A=
xor: automatically using best checksumming function: generic_sse=0A=
   generic_sse:  6573.000 MB/sec=0A=
xor: using function: generic_sse (6573.000 MB/sec)=0A=
async_tx: api initialized (async)=0A=
raid6: int64x1   1535 MB/s=0A=
usb 7-1: new low speed USB device using uhci_hcd and address 2=0A=
raid6: int64x2   1894 MB/s=0A=
raid6: int64x4   1727 MB/s=0A=
raid6: int64x8   1365 MB/s=0A=
raid6: sse2x1    3074 MB/s=0A=
usb 7-1: configuration #1 chosen from 1 choice=0A=
raid6: sse2x2    3317 MB/s=0A=
input:   USB Keyboard as /class/input/input1=0A=
raid6: sse2x4    5421 MB/s=0A=
raid6: using algorithm sse2x4 (5421 MB/s)=0A=
md: raid6 personality registered for level 6=0A=
md: raid5 personality registered for level 5=0A=
md: raid4 personality registered for level 4=0A=
SCSI subsystem initialized=0A=
Driver 'sd' needs updating - please use bus_type methods=0A=
libata version 3.00 loaded.=0A=
ahci 0000:00:1f.2: version 3.0=0A=
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 21 (level, low) -> IRQ 21=0A=
input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on =
usb-0000:00:1d.1-1=0A=
input:   USB Keyboard as /class/input/input2=0A=
input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on =
usb-0000:00:1d.1-1=0A=
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA =
mode=0A=
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part =0A=
PCI: Setting latency timer of device 0000:00:1f.2 to 64=0A=
scsi0 : ahci=0A=
scsi1 : ahci=0A=
scsi2 : ahci=0A=
scsi3 : ahci=0A=
scsi4 : ahci=0A=
scsi5 : ahci=0A=
ata1: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522100 irq 2298=0A=
ata2: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522180 irq 2298=0A=
ata3: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522200 irq 2298=0A=
ata4: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522280 irq 2298=0A=
ata5: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522300 irq 2298=0A=
ata6: SATA max UDMA/133 abar m2048@0xe0522000 port 0xe0522380 irq 2298=0A=
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata1.00: configured for UDMA/133=0A=
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata2.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata2.00: configured for UDMA/133=0A=
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata3.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata3.00: configured for UDMA/133=0A=
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata4.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata4.00: configured for UDMA/133=0A=
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata5.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata5.00: configured for UDMA/133=0A=
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata6.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata6.00: configured for UDMA/133=0A=
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 0:0:0:0: [sda] Write Protect is off=0A=
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0A=
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 0:0:0:0: [sda] Write Protect is off=0A=
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0A=
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sda: sda1 sda2 sda3=0A=
sd 0:0:0:0: [sda] Attached SCSI disk=0A=
scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 1:0:0:0: [sdb] Write Protect is off=0A=
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00=0A=
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 1:0:0:0: [sdb] Write Protect is off=0A=
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00=0A=
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdb: sdb1 sdb2 sdb3=0A=
sd 1:0:0:0: [sdb] Attached SCSI disk=0A=
scsi 2:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 2:0:0:0: [sdc] Write Protect is off=0A=
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00=0A=
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 2:0:0:0: [sdc] Write Protect is off=0A=
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00=0A=
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdc: unknown partition table=0A=
sd 2:0:0:0: [sdc] Attached SCSI disk=0A=
scsi 3:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 3:0:0:0: [sdd] Write Protect is off=0A=
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00=0A=
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 3:0:0:0: [sdd] Write Protect is off=0A=
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00=0A=
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdd: unknown partition table=0A=
sd 3:0:0:0: [sdd] Attached SCSI disk=0A=
scsi 4:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 4:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 4:0:0:0: [sde] Write Protect is off=0A=
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00=0A=
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 4:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 4:0:0:0: [sde] Write Protect is off=0A=
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00=0A=
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sde: unknown partition table=0A=
sd 4:0:0:0: [sde] Attached SCSI disk=0A=
scsi 5:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 5:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 5:0:0:0: [sdf] Write Protect is off=0A=
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00=0A=
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 5:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 5:0:0:0: [sdf] Write Protect is off=0A=
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00=0A=
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdf: unknown partition table=0A=
sd 5:0:0:0: [sdf] Attached SCSI disk=0A=
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:03:00.0 to 64=0A=
scsi6 : pata_marvell=0A=
scsi7 : pata_marvell=0A=
ata7: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 18=0A=
ata8: DUMMY=0A=
BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 =
0B:00 0C:01 0D:00 0E:00 0F:00 =0A=
md: md1 stopped.=0A=
md: bind<sda2>=0A=
md: bind<sdb2>=0A=
raid1: raid set md1 active with 2 out of 2 mirrors=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
sd 0:0:0:0: Attached scsi generic sg0 type 0=0A=
sd 1:0:0:0: Attached scsi generic sg1 type 0=0A=
sd 2:0:0:0: Attached scsi generic sg2 type 0=0A=
sd 3:0:0:0: Attached scsi generic sg3 type 0=0A=
sd 4:0:0:0: Attached scsi generic sg4 type 0=0A=
sd 5:0:0:0: Attached scsi generic sg5 type 0=0A=
input: Power Button (FF) as /class/input/input3=0A=
ACPI: Power Button (FF) [PWRF]=0A=
input: Sleep Button (CM) as /class/input/input4=0A=
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:03.2 to 64=0A=
ACPI: PCI interrupt for device 0000:00:03.2 disabled=0A=
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0=0A=
e1000e: Copyright (c) 1999-2007 Intel Corporation.=0A=
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:19.0 to 64=0A=
ACPI: Sleep Button (CM) [SLPB]=0A=
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:b3:01:d9=0A=
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection=0A=
0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff=0A=
sata_sil24 0000:01:00.0: version 1.1=0A=
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:01:00.0 to 64=0A=
8139too Fast Ethernet driver 0.9.28=0A=
scsi8 : sata_sil24=0A=
scsi9 : sata_sil24=0A=
ata9: SATA max UDMA/100 host m128@0xe0204000 port 0xe0200000 irq 16=0A=
ata10: SATA max UDMA/100 host m128@0xe0204000 port 0xe0202000 irq 16=0A=
input: PC Speaker as /class/input/input5=0A=
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 0)=0A=
ata9.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata9.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)=0A=
ata9.00: configured for UDMA/100=0A=
ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 0)=0A=
ata10.00: ATA-8: ST3500320AS, SD15, max UDMA/133=0A=
ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)=0A=
ata10.00: configured for UDMA/100=0A=
scsi 8:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 8:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 8:0:0:0: [sdg] Write Protect is off=0A=
sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00=0A=
sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 8:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 8:0:0:0: [sdg] Write Protect is off=0A=
sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00=0A=
sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdg: unknown partition table=0A=
sd 8:0:0:0: [sdg] Attached SCSI disk=0A=
sd 8:0:0:0: Attached scsi generic sg6 type 0=0A=
scsi 9:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 =
ANSI: 5=0A=
sd 9:0:0:0: [sdh] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 9:0:0:0: [sdh] Write Protect is off=0A=
sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00=0A=
sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
sd 9:0:0:0: [sdh] 976773168 512-byte hardware sectors (500108 MB)=0A=
sd 9:0:0:0: [sdh] Write Protect is off=0A=
sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00=0A=
sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdh: unknown partition table=0A=
sd 9:0:0:0: [sdh] Attached SCSI disk=0A=
sd 9:0:0:0: Attached scsi generic sg7 type 0=0A=
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21=0A=
eth1: RealTek RTL8139 at 0xffffc2000004a000, 00:c9:00:02:aa:1a, IRQ 21=0A=
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'=0A=
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 18 (level, low) -> IRQ 18=0A=
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)=0A=
md: md0 stopped.=0A=
md: bind<sda1>=0A=
md: bind<sdb1>=0A=
raid1: raid set md0 active with 2 out of 2 mirrors=0A=
device-mapper: uevent: version 1.0.3=0A=
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: =
dm-devel@redhat.com=0A=
device-mapper: multipath: version 1.0.5 loaded=0A=
EXT3 FS on md1, internal journal=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on md0, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
Adding 514072k swap on /dev/sda3.  Priority:-1 extents:1 across:514072k=0A=
Adding 514072k swap on /dev/sdb3.  Priority:-2 extents:1 across:514072k=0A=

------=_NextPart_000_000F_01C8A61D.0FB212D0--

