Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbYFDMPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbYFDMPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYFDMKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:48 -0400
Received: from smtpout01s1.x-echo.com ([193.252.149.37]:35252 "EHLO
	smtpout01s1.x-echo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363AbYFDMKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:44 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 08:10:43 EDT
From: Lkm <lkm@lea-linux.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Hardware clock instable
Date: Wed, 4 Jun 2008 14:02:39 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fRoRIl3n7W0Dhk0"
Message-Id: <200806041402.39515.lkm@lea-linux.com>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fRoRIl3n7W0Dhk0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

i work in a web hosting compagny. We have a strange problem on many servers. 
The hardware clock of several server is totaly instable. This happen on many 
server, not all.
Symptoms:

root@computer:~# date && hwclock
Wed Jun  4 13:53:21 CEST 2008
Sat Jun  7 20:23:16 2008  -0.576925 seconds


root@computer:~# hwclock --systohc

root@computer:~# date && hwclock
Wed Jun  4 13:53:34 CEST 2008
Wed Jun  4 13:53:36 2008  -0.835749 seconds

(2 seconds !)

root@rd10:~# date && hwclock
Wed Jun  4 13:53:42 CEST 2008
Wed Jun  4 13:54:02 2008  -0.779573 seconds

(20 seconds !!)

I have try to pass clock or clocksource= hpet, pti to the kernel at boot: same 
troubles.


Kernel information:
cat /proc/version
Linux version 2.6.24.2 (root@XXXXXXX ) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 SMP Wed Feb 20 15:40:12 CET 2008

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 797.548
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse
bogomips        : 1596.12
clflush size    : 32

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 797.548
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse
bogomips        : 1595.08
clflush size    : 32

cat /proc/ioports
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
0170-0177 : 0000:00:0f.1
01f0-01f7 : 0000:00:0f.1
  01f0-01f7 : ide0
0220-0223 : ACPI PM1a_EVT_BLK
0230-0231 : ACPI PM1a_CNT_BLK
0240-0243 : ACPI PM_TMR
02f8-02ff : serial
0376-0376 : 0000:00:0f.1
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:0f.1
  03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0408-040f : pnp 00:01
0cf8-0cff : PCI conf1
0f50-0f58 : pnp 00:01
1800-18ff : 0000:00:04.0
2000-20ff : 0000:00:01.0
  2000-20ff : cpqarray
2400-243f : 0000:00:02.0
  2400-243f : e100
2800-28ff : 0000:00:03.0
2c00-2c0f : 0000:00:0f.1


cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e8000-000edfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-1fffbfff : System RAM
  00200000-005c7a77 : Kernel code
  005c7a78-00717f7b : Kernel data
  0075e000-007cfbc7 : Kernel bss
1fffc000-1fffffff : ACPI Tables
30000000-300fffff : 0000:00:02.0
30100000-3017ffff : 0000:00:01.0
30180000-3019ffff : 0000:00:03.0
c3000000-c3ffffff : 0000:00:03.0
c4dfef00-c4dfefff : 0000:00:04.0
c4dff000-c4dfffff : 0000:00:03.0
c4e00000-c4efffff : 0000:00:02.0
  c4e00000-c4efffff : e100
c4fff000-c4ffffff : 0000:00:02.0
  c4fff000-c4ffffff : e100
c5000000-c5ffffff : 0000:00:01.0
c6000000-c6ffffff : 0000:00:01.0
fec00000-fec0ffff : reserved
fee00000-fee0ffff : reserved
fff80000-ffffffff : reserved


lspci -vvvv
00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes

00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes

00:01.0 RAID bus controller: LSI Logic / Symbios Logic 53C1510 (rev 02)
        Subsystem: Compaq Computer Corporation Integrated Array Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 192 (7500ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 2000 [size=256]
        Region 1: Memory at c6000000 (32-bit, non-prefetchable) [size=16M]
        Region 2: Memory at c5000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at 30100000 [disabled] [size=512K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] 
(rev 08)
        Subsystem: Compaq Computer Corporation NC3163 Fast Ethernet NIC 
(embedded, WOL)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c4fff000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 2400 [size=64]
        Region 2: Memory at c4e00000 (32-bit, non-prefetchable) [size=1M]
        [virtual] Expansion ROM at 30000000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:03.0 VGA compatible controller: ATI Technologies Inc 3D Rage IIC 215IIC 
[Mach64 GT IIC] (rev 7a) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Rage IIC
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min), Cache Line Size: 32 bytes
        Region 0: Memory at c3000000 (32-bit, prefetchable) [size=16M]
        Region 1: I/O ports at 2800 [size=256]
        Region 2: Memory at c4dff000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 30180000 [disabled] [size=128K]
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 System peripheral: Compaq Computer Corporation Advanced System 
Management Controller
        Subsystem: Compaq Computer Corporation Unknown device b0f3
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 255
        Region 0: I/O ports at 1800 [size=256]
        Region 1: Memory at c4dfef00 (32-bit, non-prefetchable) [size=256]

00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 51)
        Subsystem: Broadcom OSB4 South Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:0f.1 IDE interface: Broadcom OSB4 IDE Controller (prog-if 8a [Master SecP 
PriP])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
        Region 4: I/O ports at 2c00 [size=16]





--Boundary-00=_fRoRIl3n7W0Dhk0
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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

--Boundary-00=_fRoRIl3n7W0Dhk0--
