Return-Path: <linux-kernel-owner+w=401wt.eu-S965498AbXBFVPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498AbXBFVPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965499AbXBFVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:15:46 -0500
Received: from postoffice10.mail.cornell.edu ([132.236.56.14]:46961 "EHLO
	postoffice10.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965498AbXBFVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:15:45 -0500
X-Greylist: delayed 68830 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 16:15:44 EST
Message-ID: <34171.74.71.32.29.1170727713.squirrel@webmail.cornell.edu>
Date: Mon, 5 Feb 2007 21:08:33 -0500 (EST)
Subject: PROBLEM: sata timeouts with intel 82801HB on amd64
From: "Trevor Offner Caira" <toc3@cornell.edu>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(1) One-line summary: I'm getting SATA timeouts with Intel 82801HB on amd64.

(2) Full description: Unless CONFIG_RCU_TORTURE_TEST is set, I get sata
timeouts of this form periodically:

ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata1.00: cmd 60/18:00:b3:22:0a/00:00:00:00:00/40 tag 0 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

This entails complete blocking of all disk i/o (I only have one disk) for
about 45 seconds. The kernel then negotiates the next lowest transfer
speed (UDMA/166 all the way down to PIO0, when it errors saying it cannot
go slower). I get this issue on amd64 kernels only. The issue is only
present in 2.6.18+, since earlier kernels do not support my chipset at all
(intel 82801HB).

Knoppix 5.1.1 does not show this issue (i.e., no disk i/o issues even
without rcutorture running). However, a native amd64 build of exactly the
same kernel config shows the issue.

(3) Keywords: SATA, AHCI, modules, kernel, Intel.

(4) /proc/version: Linux delta 2.6.20 #15 SMP PREEMPT Sun Feb 4 20:25:02
EST 2007 x86_64 GNU/Linux.

(5) Most recent kernel version which did not have the bug: N/A

(6) Output of Oops.. message: N/A

(7) A small shell script or example program which triggers the problem:
simply logging in or accessing the disk in any way.

(8) Environment:
Note: the following information was collected on a minimal kernel with
RCU_TORTURE_TEST enabled.

(8.1) Software
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
xfsprogs               2.8.18
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    85:
Sh-utils               5.97
udev                   103

(8.2) Processor information:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6
cpu MHz         : 2397.649
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc
 pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4797.17
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6
cpu MHz         : 2397.649
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc
 pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4794.47
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

(8.3) Module information: N/A

(8.4)
/proc/ioports:
00000000-0009ebff : System RAM
  00000000-00000000 : Crash kernel
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cd000-000cdfff : Adapter ROM
000ce000-000cefff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3ed98fff : System RAM
  00200000-005ccb4d : Kernel code
  005ccb4e-0075d32f : Kernel data
3ed99000-3eda5fff : reserved
3eda6000-3ee3bfff : System RAM
3ee3c000-3eea8fff : ACPI Non-volatile Storage
3eea9000-3eeabfff : ACPI Tables
3eeac000-3eef1fff : ACPI Non-volatile Storage
3eef2000-3eefefff : ACPI Tables
3eeff000-3eefffff : System RAM
3ef00000-3f7fffff : reserved
40000000-4fffffff : 0000:00:02.0
  40000000-4076ffff : vesafb
50000000-500fffff : PCI Bus #06
  50000000-50003fff : 0000:06:03.0
  50004000-500047ff : 0000:06:03.0
50100000-501fffff : PCI Bus #02
  50100000-501001ff : 0000:02:00.0
50200000-502fffff : 0000:00:02.0
50300000-5031ffff : 0000:00:19.0
  50300000-5031ffff : e1000
50320000-50323fff : 0000:00:1b.0
  50320000-50323fff : ICH HD audio
50324000-50324fff : 0000:00:19.0
  50324000-50324fff : e1000
50325000-503257ff : 0000:00:1f.2
  50325000-503257ff : ahci
50325800-50325bff : 0000:00:1d.7
  50325800-50325bff : ehci_hcd
50325c00-50325fff : 0000:00:1a.7
  50325c00-50325fff : ehci_hcd
50326000-503260ff : 0000:00:1f.3
50326100-5032610f : 0000:00:03.0
50400000-504fffff : PCI Bus #01
50500000-505fffff : PCI Bus #03
50600000-506fffff : PCI Bus #04
50700000-507fffff : PCI Bus #05
fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC
fff00000-ffffffff : reserved

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vesafb
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-0420 : ACPI PM2_CNT_BLK
  0428-042f : ACPI GPE0_BLK
0500-053f : 0000:00:1f.0
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #02
  1000-100f : 0000:02:00.0
    1000-1007 : ide0
    1008-100f : ide1
  1010-1017 : 0000:02:00.0
  1018-101f : 0000:02:00.0
    1018-101f : ide0
  1020-1023 : 0000:02:00.0
  1024-1027 : 0000:02:00.0
    1026-1026 : ide0
2000-201f : 0000:00:1f.3
  2000-201f : i801_smbus
2020-203f : 0000:00:1f.2
  2020-203f : ahci
2040-205f : 0000:00:1d.2
  2040-205f : uhci_hcd
2060-207f : 0000:00:1d.1
  2060-207f : uhci_hcd
2080-209f : 0000:00:1d.0
  2080-209f : uhci_hcd
20a0-20bf : 0000:00:1a.1
  20a0-20bf : uhci_hcd
20c0-20df : 0000:00:1a.0
  20c0-20df : uhci_hcd
20e0-20ff : 0000:00:19.0
  20e0-20ff : e1000
2100-2107 : 0000:00:1f.2
  2100-2107 : ahci
2108-210f : 0000:00:1f.2
  2108-210f : ahci
2110-2117 : 0000:00:02.0
2118-211b : 0000:00:1f.2
  2118-211b : ahci
211c-211f : 0000:00:1f.2
  211c-211f : ahci

/proc/iomem:
00000000-0009ebff : System RAM
  00000000-00000000 : Crash kernel
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cd000-000cdfff : Adapter ROM
000ce000-000cefff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3ed98fff : System RAM
  00200000-005ccb4d : Kernel code
  005ccb4e-0075d32f : Kernel data
3ed99000-3eda5fff : reserved
3eda6000-3ee3bfff : System RAM
3ee3c000-3eea8fff : ACPI Non-volatile Storage
3eea9000-3eeabfff : ACPI Tables
3eeac000-3eef1fff : ACPI Non-volatile Storage
3eef2000-3eefefff : ACPI Tables
3eeff000-3eefffff : System RAM
3ef00000-3f7fffff : reserved
40000000-4fffffff : 0000:00:02.0
  40000000-4076ffff : vesafb
50000000-500fffff : PCI Bus #06
  50000000-50003fff : 0000:06:03.0
  50004000-500047ff : 0000:06:03.0
50100000-501fffff : PCI Bus #02
  50100000-501001ff : 0000:02:00.0
50200000-502fffff : 0000:00:02.0
50300000-5031ffff : 0000:00:19.0
  50300000-5031ffff : e1000
50320000-50323fff : 0000:00:1b.0
  50320000-50323fff : ICH HD audio
50324000-50324fff : 0000:00:19.0
  50324000-50324fff : e1000
50325000-503257ff : 0000:00:1f.2
  50325000-503257ff : ahci
50325800-50325bff : 0000:00:1d.7
  50325800-50325bff : ehci_hcd
50325c00-50325fff : 0000:00:1a.7
  50325c00-50325fff : ehci_hcd
50326000-503260ff : 0000:00:1f.3
50326100-5032610f : 0000:00:03.0
50400000-504fffff : PCI Bus #01
50500000-505fffff : PCI Bus #03
50600000-506fffff : PCI Bus #04
50700000-507fffff : PCI Bus #05
fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC
fff00000-ffffffff : reserved

(8.5) lspci -vvv (as root):
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub
(rev 02)
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated
Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 50200000 (32-bit, non-prefetchable) [size=1M]
        Region 2: Memory at 40000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 2110 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation 82P965/G965 HECI
Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 50326100 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82566DC Gigabit Network
Connection (rev 02)
        Subsystem: Intel Corporation Unknown device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at 50300000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at 50324000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 20e0 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at 20c0 [size=32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at 20a0 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
#2 (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at 50325c00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 2504
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 50320000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50400000-504fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 1, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Intel Corporation 82801H (ICH8
Family) PCI Express Port 1
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 2 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: 50100000-501fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 2, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Intel Corporation 82801H (ICH8
Family) PCI Express Port 2
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 3 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50500000-505fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 3, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Intel Corporation 82801H (ICH8
Family) PCI Express Port 3
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 4 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50600000-506fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 4, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Intel Corporation 82801H (ICH8
Family) PCI Express Port 4
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50700000-507fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 5, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Intel Corporation 82801H (ICH8
Family) PCI Express Port 5
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at 2080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 2060 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 2040 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
#1 (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at 50325800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50000000-500fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Intel Corporation Unknown device 514d

00:1f.0 ISA bridge: Intel Corporation 82801HH (ICH8DH) LPC Interface
Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 SATA controller: Intel Corporation 82801HB (ICH8) SATA AHCI
Controller (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at 2108 [size=8]
        Region 1: I/O ports at 211c [size=4]
        Region 2: I/O ports at 2100 [size=8]
        Region 3: I/O ports at 2118 [size=4]
        Region 4: I/O ports at 2020 [size=32]
        Region 5: Memory at 50325000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/4 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller
(rev 02)
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at 50326000 (32-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 2000 [size=32]

02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6101
(rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Marvell Technology Group Ltd. Unknown device 6101
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 1018 [size=8]
        Region 1: I/O ports at 1024 [size=4]
        Region 2: I/O ports at 1010 [size=8]
        Region 3: I/O ports at 1020 [size=4]
        Region 4: I/O ports at 1000 [size=16]
        Region 5: Memory at 50100000 (32-bit, non-prefetchable) [size=512]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s <256ns, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: Intel Corporation Unknown device 514d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 50004000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at 50000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

(8.6) SCSI information: N/A

(8.7) Other information: There's nothing in the system except for the
DG965WH motherboard, E6600 processor, 1GB of kingston RAM, the ST3320620AS
hard drive and 430 W PSU.

Thanks for reading this far! :)

Trevor Caira

