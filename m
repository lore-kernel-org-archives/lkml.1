Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXLKOfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXLKOfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXLKOfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:35:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:51349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753206AbXLKOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:35:04 -0500
X-Authenticated: #2025681
X-Provags-ID: V01U2FsdGVkX18+fIo4AwY+xN6EHRQIPQoG0WRvac4OvlW++Du7jR
	90RyqfgyCnZ6Kv
Message-ID: <475EA019.30705@gmx.de>
Date: Tue, 11 Dec 2007 15:35:05 +0100
From: Stefan Sassenberg <stefan.sassenberg@gmx.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel hangs on boot with additional PCI VGA
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've discovered a kernel problem for my hardware configuration. That 
might be a bug.

System:
A machine with an Intel® 945GC chipset on an MSI board with Award BIOS. 
Pentium 4 CPU with hyperthreading 3.0GHz.
A riser card with a PCI VGA card in it.
Reproducable always with GeForce 6200 and ATI 9250.

The problem:
The machine hangs on boot of a system that is booted with "gui 
intentions". Some examples:
Latest knoppix -> hangs
Latest ubuntu live DVD -> hangs
Ubuntu 7.1 installer -> works
Installed 7.1 ubuntu -> hangs
My modified old knoppix with 2.6.17, 2.6.21 or 2.6.23 -> hangs
My modified old knoppix with 2.6.11 or 2.6.9 -> works

Note:
The system always hangs before the init scripts are processed.
The kernel is not patched in any way.

Some information acquired after removing the 2nd VGA card
ver_linux
Gnu C                  4.1.2
Gnu make               3.80
binutils               Binutils
util-linux             2.12
mount                  2.11x
module-init-tools      3.1
e2fsprogs              1.36
reiserfsprogs          3.6.19
pcmcia-cs              3.2.5
PPP                    2.4.2
isdn4k-utils           3.5
nfs-utils              1.0.6
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.4
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.2.1

proc/version
Linux version 2.6.23.9 (root@K2) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Tue Dec 11 13:06:53 CET 2007

proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 5
cpu MHz         : 2999.893
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc peb
s bts sync_rdtsc pni monitor ds_cpl est tm2 cid cx16 xtpr lahf_lm
bogomips        : 6005.26
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 5
cpu MHz         : 2999.893
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc peb
s bts sync_rdtsc pni monitor ds_cpl est tm2 cid cx16 xtpr lahf_lm
bogomips        : 5999.81
clflush size    : 64

lspci -vvv
0000:00:00.0 Host bridge: Intel Corp.: Unknown device 2770 (rev 02)
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Capabilities: [e0] #09 [5109]

0000:00:02.0 VGA compatible controller: Intel Corp.: Unknown device 2772 
(rev 02) (prog-if 00 [VGA])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 5
         Region 0: Memory at fdf00000 (32-bit, non-prefetchable) [size=512K]
         Region 1: I/O ports at ff00 [size=8]
         Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
         Region 3: Memory at fdf80000 (32-bit, non-prefetchable) [size=256K]
         Capabilities: [90] Message Signalled Interrupts: 64bit- 
Queue=0/0 Enable-
                 Address: 00000000  Data: 0000
         Capabilities: [d0] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:1d.0 USB Controller: Intel Corp.: Unknown device 27c8 (rev 01) 
(prog-if 00 [UHCI])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 17
         Region 4: I/O ports at fe00 [size=32]

0000:00:1d.1 USB Controller: Intel Corp.: Unknown device 27c9 (rev 01) 
(prog-if 00 [UHCI])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 18
         Region 4: I/O ports at fd00 [size=32]

0000:00:1d.2 USB Controller: Intel Corp.: Unknown device 27ca (rev 01) 
(prog-if 00 [UHCI])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 16
         Region 4: I/O ports at fc00 [size=32]

0000:00:1d.3 USB Controller: Intel Corp.: Unknown device 27cb (rev 01) 
(prog-if 00 [UHCI])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin D routed to IRQ 19
         Region 4: I/O ports at fb00 [size=32]

0000:00:1d.7 USB Controller: Intel Corp.: Unknown device 27cc (rev 01) 
(prog-if 20 [EHCI])
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:1e.0 PCI bridge: Intel Corp. 82801 PCI Bridge (rev e1) (prog-if 
01 [Subtractive decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: fde00000-fdefffff
         Prefetchable memory behind bridge: 
00000000fdd00000-00000000fdd00000
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] #0d [0000]
0000:00:1f.0 ISA bridge: Intel Corp.: Unknown device 27b8 (rev 01)
         Subsystem: Intel Corp.: Unknown device 27b8
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [e0] #09 [100c]

0000:00:1f.1 IDE interface: Intel Corp.: Unknown device 27df (rev 01) 
(prog-if 8a [Master SecP PriP])
         Subsystem: Intel Corp.: Unknown device 27df
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at 01f0 [size=8]
         Region 1: I/O ports at 03f4 [size=1]
         Region 2: I/O ports at 0170 [size=8]
         Region 3: I/O ports at 0374 [size=1]
         Region 4: I/O ports at f800 [size=16]

0000:00:1f.3 SMBus: Intel Corp.: Unknown device 27da (rev 01)
         Subsystem: Intel Corp.: Unknown device 27da
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 18
         Region 4: I/O ports at 0500 [size=32]

0000:01:00.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O 
Controller (rev 01) (prog-if 02 [16550])
         Subsystem: LSI Logic / Symbios Logic 2S (16C550 UART)
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin A routed to IRQ 20
         Region 0: I/O ports at df00 [size=8]
         Region 1: I/O ports at de00 [size=8]
         Region 2: I/O ports at dd00 [size=8]
         Region 3: I/O ports at dc00 [size=8]
         Region 4: I/O ports at db00 [size=8]
         Region 5: I/O ports at da00 [size=16]

0000:01:02.0 Ethernet controller: Intel Corp. 82541GI/PI Gigabit 
Ethernet Controller (rev 05)
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 2310
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 252 (63750ns min), Cache Line Size: 0x10 (64 bytes)
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at fdee0000 (32-bit, non-prefetchable) [size=128K]
         Region 1: Memory at fdec0000 (32-bit, non-prefetchable) [size=128K]
         Region 2: I/O ports at d900 [size=64]
         Expansion ROM at fdd00000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [e4] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=0
                 Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=2, DMOST=0, DMCRS=0, RSCEM-
         Capabilities: [f0] Message Signalled Interrupts: 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

Someone else seems to have a similar problem:
http://ubuntuforums.org/showthread.php?t=596725

This is my first kernel bug report. I'd appriciate if you could drop me 
a quick note on how to follow your bug report handling.

Thank you very much.

Stefan Sassenberg
