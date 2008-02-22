Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYBVOcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYBVOcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYBVOcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:32:16 -0500
Received: from borg.uu3.net ([87.99.63.19]:1168 "EHLO borg.uu3.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYBVOcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:32:14 -0500
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 09:32:13 EST
Date: Fri, 22 Feb 2008 15:08:30 +0100 (CET)
From: Unknown <borg@uu3.net>
X-X-Sender: borg@cube
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: 2.4.36.1 hangs.
Message-ID: <Pine.LNX.4.64.0802221452350.5082@cube>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) 2.4.36.1 hangs (probably during ext2_readdir())

2) 2.4.36.1 hangs during compilation of lighttpd-1.4.18.
    It is probably during ext2_readdir() but I cannot confirm that..
    Currently it only happens during compilation of lighttpd-1.4.18, always
    in the same place.
    Kernel 2.4.36 w/ same options (make oldconfig) works fine.

Last few lines of 'strace -f make' just before hang:
[pid 12817] open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
[pid 12817] fstat64(3, {st_mode=S_IFDIR|0777, st_size=8192, ...}) = 0
[pid 12817] fcntl64(3, F_SETFD, FD_CLOEXEC) = 0
[pid 12817] getdents64(3, /* 114 entries */, 4096) = 4088
[pid 12817] getdents64(3, /* 63 entries */, 4096) = 2424
[pid 12817] getdents64(3,

3) ext2fs

4) None.

5) None. Kernel just hangs.

6)
cd /home/root/src/lighttpd-1.4.18
N=lighttpd
AP="/usr/local/$N"
EP="/usr/local"
ETC="/etc/$N"
./configure --prefix=$AP --bindir=$EP/bin --sbindir=$EP/sbin \
--libexecdir=$EP/libexec --mandir=$EP/man --sysconfdir=$ETC --disable-ipv6
make

7.1) Slackware-11.0
Linux darkstar 2.4.36.1 #2 Fri Feb 22 14:13:50 CET 2008 i686 pentium3 i386 
GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
modutils               2.4.27
e2fsprogs              1.38
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    74:
Sh-utils               5.97
Modules Loaded

7.2)
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10
cpu MHz         : 930.329
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov 
pat pse36 mmx fxsr sse
bogomips        : 1854.66

7.3) None
7.4)
# cat /proc/ioports:
0000-001f : dma1
0020-003f : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial(auto)
0cf8-0cff : PCI conf1
1000-100f : Intel Corp. 82801AA IDE
   1000-1007 : ide0
   1008-100f : ide1
1400-141f : Intel Corp. 82801AA USB
1800-180f : Intel Corp. 82801AA SMBus
2400-243f : Intel Corp. 82557/8/9 [Ethernet Pro 100]
   2400-243f : eepro100
f000-f07f : motherboard
   f000-f003 : PM1a_EVT_BLK
   f004-f005 : PM1a_CNT_BLK
   f008-f00b : PM_TMR
   f028-f02b : GPE0_BLK
   f02c-f02f : GPE1_BLK
f100-f10f : motherboard
f180-f1bf : motherboard
f800-f81f : motherboard
f820-f82f : motherboard
fe00-fe00 : motherboard

# cat /proc/iomem
00000000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000c97ff : Extension ROM
000f0000-000fffff : System ROM
00100000-1feeffff : System RAM
   00100000-0027773b : Kernel code
   0027773c-002c52e3 : Kernel data
1fef0000-1fefefff : ACPI Tables
1feff000-1fefffff : ACPI Non-volatile Storage
1ff00000-1fffffff : reserved
f4000000-f407ffff : Intel Corp. 82810E DC-133 CGC [Chipset Graphics 
Controller]
f4100000-f411ffff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
f4120000-f4120fff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
   f4120000-f4120fff : eepro100
f8000000-fbffffff : Intel Corp. 82810E DC-133 CGC [Chipset Graphics 
Controller]
ffb80000-ffbfffff : reserved
fff00000-ffffffff : reserved

7.5)
# lspci
00:00.0 Host bridge: Intel Corporation 82810E DC-133 GMCH [Graphics Memory 
Controller Hub] (rev 03)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0

00:01.0 VGA compatible controller: Intel Corporation 82810E DC-133 CGC 
[Chipset Graphics Controller] (rev 03) (prog-if 00 [VGA])
         Subsystem: Siemens Nixdorf AG Unknown device 004a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
         Region 1: Memory at f4000000 (32-bit, non-prefetchable) 
[size=512K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: Intel Corporation 82801AA PCI Bridge (rev 02) (prog-if 
00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: f4100000-f41fffff
         Prefetchable memory behind bridge: fff00000-000fffff
         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801AA ISA Bridge (LPC) (rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801AA IDE (rev 02) (prog-if 80 
[Master])
         Subsystem: Intel Corporation 82801AA IDE
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 4: I/O ports at 1000 [size=16]

00:1f.2 USB Controller: Intel Corporation 82801AA USB (rev 02) (prog-if 00 
[UHCI])
         Subsystem: Intel Corporation 82801AA USB
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin D routed to IRQ 9
         Region 4: I/O ports at 1400 [size=32]

00:1f.3 SMBus: Intel Corporation 82801AA SMBus (rev 02)
         Subsystem: Intel Corporation 82801AA SMBus
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 5
         Region 4: I/O ports at 1800 [size=16]

01:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 
100] (rev 09)
         Subsystem: Siemens Nixdorf AG Unknown device 004b
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 9
         Region 0: Memory at f4120000 (32-bit, non-prefetchable) [size=4K]
         Region 1: I/O ports at 2400 [size=64]
         Region 2: Memory at f4100000 (32-bit, non-prefetchable) 
[size=128K]
         Expansion ROM at <unassigned> [disabled] [size=1M]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

7.6) None

7.7) Box has been tested via memtest86+
      15 hrs of test running, no errors
