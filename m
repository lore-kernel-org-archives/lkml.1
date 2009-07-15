Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGOLJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGOLJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZGOLJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:09:28 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:43947 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbZGOLJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:09:27 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 07:09:26 EDT
Message-ID: <4A5DB243.2000100@orcon.net.nz>
Date: Wed, 15 Jul 2009 22:41:07 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-alpha@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx5.orcon.net.nz on Wed, 15 Jul 2009 22:41:11 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Jul 15 22:41:12 2009
X-DSPAM-Confidence: 0.8510
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Oops on Alpha Architecture when starting the Xserver.

Whenever I start the Xserver, version 1.6.2 from Debain Unstable, I get a
kernel oops report and the computer crashes hard; no ping response, hitting
the reset button to return to SRM fails.  Has caused corruption on disc
partitions on some crashes.  This occurs with kernels 2.6.30, 2.6.30.1 and
also a patched version of 2.6.29.x (patched so that I get PCI resource files
under sysfs).

The kernel oops is:

Unable to handle kernel paging request at virtual address 000000000000000c
Xorg(1940): Oops 0
pc = [<fffffc000031e634>]  ra = [<fffffc000031570c>]  ps = 0007    Not 
tainted
pc is at cia_machine_check+0x84/0x570
ra is at do_entInt+0x16c/0x1d0
v0 = 0000000000000001  t0 = 0000000000000001  t1 = fffffc000071a250
t2 = 0000000000000001  t3 = 0000000000000031  t4 = 3a00000000000000
t5 = 0000000000000004  t6 = 000000000000000f  t7 = fffffc0021c0c000
s0 = fffffc00006ed2d8  s1 = 0000000000000000  s2 = fffffc0021c0fee8
s3 = 000000011ff016fc  s4 = 000000011ff016f4  s5 = fffffc0000006068
s6 = 0000000000000660
a0 = 0000000000000001  a1 = 0000000000000000  a2 = fffffc0000006068
a3 = 0000000000000000  a4 = 0000000100000010  a5 = 000000012029c0a0
t8 = 0000000000000010  t9 = 00000001200c0b98  t10= 0000000000000000
t11= 000000000000000a  pv = fffffc000031e5b0  at = 0000000000000006
gp = fffffc00007192f0  sp = fffffc0021c0fe88
Disabling lock debugging due to kernel taint
Trace:
[<fffffc000031570c>] do_entInt+0x16c/0x1d0
[<fffffc0000310c80>] ret_from_sys_call+0x0/0x10
[<fffffc0000310720>] entInt+0x0/0x80

Code: 207f0660  41e305a3  2a620000  426015a1  44230001  e420000f 
<a031000c> 47ff0413


On one crash there was a trace of the Xorg.log file left intact ending with
the following lines:

(II) RADEON(0): Attempting to read un-POSTed bios
(II) RADEON(0): ATOM BIOS detected
(II) RADEON(0): ATOM BIOS Rom:
        SubsystemVendorID: 0x2232 SubsystemID: 0x1787
        IOBaseAddress: 0x0000
        Filename: 72319EAA.QEA
        BIOS Bootup Message:   HD2400 GDDR2_32MX16 64BIT 256MB 
72319EAA.QEA          
                      
(II) RADEON(0): Framebuffer space used by Firmware (kb): 0
(WW) RADEON(0): rhdAtomGetFbBaseAndSize: AtomBIOS specified VRAM scratch 
space size invalid
(II) RADEON(0):  default to: 20480
(II) RADEON(0): Cannot get VRAM scratch space. Allocating in main memory 
instead
(II) RADEON(0): Default Engine Clock: 525000
(II) RADEON(0): Default Memory Clock: 400000
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Output: 1200000
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Output: 0
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Input: 13500
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Input: 1000
(II) RADEON(0): Maximum Pixel Clock: 400000
(II) RADEON(0): Reference Clock: 27000
(II) RADEON(0): Default Engine Clock: 525000
(II) RADEON(0): Default Memory Clock: 400000
(II) RADEON(0): Calling ASIC Init
[Xorg.log ends here]


Other machine info follows:

aleph:~# cat /proc/version
Linux version 2.6.30.1-miata (mjc@alpha) (gcc version 4.2.4 (Debian 
4.2.4-6)) #1 Fri Jul 3 22:54:36 NZST 2009

aleph:~# cat /proc/cpuinfo
cpu            : Alpha
cpu model        : EV56
cpu variation        : 7
cpu revision        : 0
cpu serial number    :
system type        : Miata
system variation    : 0
system revision        : 0
system serial number    :
cycle frequency [Hz]    : 600000000
timer frequency [Hz]    : 1024.00
page size [bytes]    : 8192
phys. address bits    : 40
max. addr. space #    : 127
BogoMIPS        : 1187.96
kernel unaligned acc    : 0 (pc=0,va=0)
user unaligned acc    : 0 (pc=0,va=0)
platform string        : Digital Personal WorkStation 600au
cpus detected        : 1
L1 Icache        : 8K, 1-way, 32b line
L1 Dcache        : 8K, 1-way, 32b line
L2 cache        : 96K, 3-way, 64b line
L3 cache        : 2048K, 1-way, 64b line

aleph:~# cat /proc/modules
ipv6 331224 22 - Live 0xfffffffc008c2000
loop 18872 0 - Live 0xfffffffc00812000
snd_es18xx 40484 0 - Live 0xfffffffc007f0000
ohci_hcd 26048 0 - Live 0xfffffffc00788000
ehci_hcd 40004 0 - Live 0xfffffffc00764000
ide_cd_mod 36336 0 - Live 0xfffffffc0073c000
cdrom 44000 1 ide_cd_mod, Live 0xfffffffc006fc000
snd_hda_codec_atihdmi 4616 1 - Live 0xfffffffc006d8000
snd_hda_intel 31184 0 - Live 0xfffffffc006be000
snd_cmipci 42152 0 - Live 0xfffffffc00696000
snd_opl3_lib 13288 2 snd_es18xx,snd_cmipci, Live 0xfffffffc00672000
snd_hwdep 9760 1 snd_opl3_lib, Live 0xfffffffc0065a000
snd_mpu401_uart 9488 2 snd_es18xx,snd_cmipci, Live 0xfffffffc00642000
snd_seq_midi 8768 0 - Live 0xfffffffc0062a000
snd_seq_midi_event 8032 1 snd_seq_midi, Live 0xfffffffc00614000
sata_sil 11328 0 - Live 0xfffffffc005fe000
snd_hda_codec 72498 2 snd_hda_codec_atihdmi,snd_hda_intel, Live 
0xfffffffc005de000
snd_rawmidi 26657 2 snd_mpu401_uart,snd_seq_midi, Live 0xfffffffc005a6000
snd_pcm 77689 4 snd_es18xx,snd_hda_intel,snd_cmipci,snd_hda_codec, Live 
0xfffffffc00576000
snd_seq 67568 2 snd_seq_midi,snd_seq_midi_event, Live 0xfffffffc00534000
snd_timer 25064 3 snd_opl3_lib,snd_pcm,snd_seq, Live 0xfffffffc004fe000
snd_seq_device 8808 4 snd_opl3_lib,snd_seq_midi,snd_rawmidi,snd_seq, 
Live 0xfffffffc004de000
snd 72216 12 
snd_es18xx,snd_hda_intel,snd_cmipci,snd_opl3_lib,snd_hwdep,snd_mpu401_uart,snd_hda_codec,snd_rawmidi,snd_pcm,snd_seq,snd_timer,snd_seq_device, 
Live 0xfffffffc004b8000
snd_page_alloc 11200 2 snd_hda_intel,snd_pcm, Live 0xfffffffc00484000
soundcore 7712 1 snd, Live 0xfffffffc0046e000
libata 191292 1 sata_sil, Live 0xfffffffc0042a000
evdev 12896 1 - Live 0xfffffffc003b6000
pcspkr 3088 0 - Live 0xfffffffc0039e000
usbcore 168612 3 ohci_hcd,ehci_hcd, Live 0xfffffffc00364000
cy82c693 4552 0 - Live 0xfffffffc002f0000
tulip 56856 0 - Live 0xfffffffc002d0000
ide_pci_generic 5132 0 - Live 0xfffffffc002a6000

aleph:~# cat /proc/ioports
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-0080 : rtc
00a0-00bf : pic2
00c0-00df : dma2
0170-0177 : 0000:00:07.2
  0170-0177 : cy82c693
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : cy82c693
0220-022f : ES18xx
02f8-02ff : serial
0330-0331 : MPU401 UART
0376-0376 : 0000:00:07.2
  0376-0376 : cy82c693
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:07.1
  03f6-03f6 : cy82c693
03f7-03f7 : floppy
03f8-03ff : serial
8000-8fff : PCI Bus 0000:01
  8000-80ff : 0000:01:00.0
9000-9fff : PCI Bus 0000:02
  9000-90ff : 0000:02:04.0
  9400-94ff : 0000:02:0a.0
    9400-94ff : CMI8738-MC6
  9800-980f : 0000:02:08.0
  9810-9817 : 0000:02:08.0
  9818-981f : 0000:02:08.0
  9820-9823 : 0000:02:08.0
  9824-9827 : 0000:02:08.0
a000-a07f : 0000:00:03.0
  a000-a07f : tulip
a080-a08f : 0000:00:07.1
  a080-a08f : cy82c693

aleph:~# car /proc/iomem
09000000-090fffff : PCI Bus 0000:01
  09000000-0900ffff : 0000:01:00.0
  09010000-09013fff : 0000:01:00.1
    09010000-09013fff : ICH HD audio
09100000-091fffff : PCI Bus 0000:02
  09100000-09100fff : 0000:02:04.0
  09101000-091011ff : 0000:02:08.0
    09101000-091011ff : sata_sil
09200000-092fffff : PCI Bus 0000:02
  09200000-0927ffff : 0000:02:08.0
  09280000-0928ffff : 0000:02:04.0
09300000-0933ffff : 0000:00:03.0
09340000-0934ffff : 0000:00:07.2
  09340000-0934ffff : cy82c693
09350000-09350fff : 0000:00:07.3
  09350000-09350fff : ohci_hcd
09351000-0935107f : 0000:00:03.0
  09351000-0935107f : tulip
10000000-27ffffff : PCI Bus 0000:01
  10000000-1fffffff : 0000:01:00.0
  20000000-2001ffff : 0000:01:00.0

aleph:~# lspci -vvv
00:03.0 Ethernet controller: Digital Equipment Corporation DECchip 
21142/43 (rev 30)
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 255 (5000ns min, 10000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 24
    Region 0: I/O ports at a000 [size=128]
    Region 1: Memory at 09351000 (32-bit, non-prefetchable) [size=128]
    Expansion ROM at 09300000 [disabled] [size=256K]
    Kernel driver in use: tulip
    Kernel modules: tulip

00:07.0 ISA bridge: Contaq Microsystems 82c693
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Kernel modules: cy82c693

00:07.1 IDE interface: Contaq Microsystems 82c693 (prog-if 80 [Master])
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 0
    Region 0: I/O ports at 01f0 [size=8]
    Region 1: I/O ports at 03f4 [size=1]
    Region 4: I/O ports at a080 [size=16]
    Kernel driver in use: Cypress_IDE
    Kernel modules: cy82c693, ide-pci-generic

00:07.2 IDE interface: Contaq Microsystems 82c693 (prog-if 00 [])
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 0
    Region 0: I/O ports at 0170 [size=8]
    Region 1: I/O ports at 0374 [size=1]
    Region 4: Memory at 09340000 (32-bit, non-prefetchable) [disabled] 
[size=64K]
    Kernel modules: cy82c693, ide-pci-generic

00:07.3 USB Controller: Contaq Microsystems 82c693 (prog-if 10 [OHCI])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 248
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at 09350000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: cy82c693, ohci-hcd

00:0c.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI 
Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 255, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=255
    I/O behind bridge: 00008000-00008fff
    Memory behind bridge: 09000000-090fffff
    Prefetchable memory behind bridge: 10000000-27ffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] Express (v1) PCI/PCI-X to PCI-Express Bridge, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-

00:14.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 02) 
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 255, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=255
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: 09100000-091fffff
    Prefetchable memory behind bridge: 0000000009200000-00000000092fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort+ >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

01:00.0 VGA compatible controller: ATI Technologies Inc RV 610LE PCI 
[Radeon HD 2400] (prog-if 00 [VGA controller])
    Subsystem: Device 2232:1787
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 32
    Region 0: Memory at 10000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at 09000000 (64-bit, non-prefetchable) [size=64K]
    Region 4: I/O ports at 8000 [size=256]
    Expansion ROM at 20000000 [disabled] [size=128K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] #1002
    Capabilities: [aa1] #ffff

01:00.1 Audio device: ATI Technologies Inc RV610 audio device [Radeon HD 
2400 PRO]
    Subsystem: Device 2232:aa10
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx+
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 33
    Region 0: Memory at 09010000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] #1002
    Capabilities: [aa1] #ffff
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

02:04.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI 
(rev 05)
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 248, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 27
    Region 0: I/O ports at 9000 [size=256]
    Region 1: Memory at 09100000 (32-bit, non-prefetchable) [size=4K]
    Expansion ROM at 09280000 [disabled] [size=64K]
    Kernel driver in use: qla1280

02:08.0 RAID bus controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
    Subsystem: Silicon Image, Inc. SiI 3112 SATARaid Controller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 240, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 36
    Region 0: I/O ports at 9810 [size=8]
    Region 1: I/O ports at 9820 [size=4]
    Region 2: I/O ports at 9818 [size=8]
    Region 3: I/O ports at 9824 [size=4]
    Region 4: I/O ports at 9800 [size=16]
    Region 5: Memory at 09101000 (32-bit, non-prefetchable) [size=512]
    Expansion ROM at 09200000 [disabled] [size=512K]
    Capabilities: [60] Power Management version 2
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
    Kernel driver in use: sata_sil
    Kernel modules: sata_sil

02:0a.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
    Subsystem: C-Media Electronics Inc CMI8738/C3DX PCI Audio Device
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 255 (500ns min, 6000ns max)
    Interrupt: pin A routed to IRQ 44
    Region 0: I/O ports at 9400 [size=256]
    Capabilities: [c0] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: C-Media PCI
    Kernel modules: snd-cmipci

Cheerz
Michael.

