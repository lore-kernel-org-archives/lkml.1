Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXHWRkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXHWRkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbXHWRjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:39:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:13726 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374AbXHWRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=d4MGvdq0v4U6S8bICJcvlXwZXZ3aNDwYz8m8XTfa2uW7Jjh352eyURAaQ1A1IIBHEvzgF0y42Vrgw/6a/ltOmBffTgf+8oHPpa20oDg34pAOoQA4G1TSN9ub7guhMo5wHZ0cGKq1zfUWlA4Sgfc/BMzQhH1xaWRq6bYgQGSulko=
Message-ID: <e4c519350708231039r62b779d5n138e102e120b163c@mail.gmail.com>
Date: Thu, 23 Aug 2007 19:39:49 +0200
From: "Maurizio Monge" <maurizio.monge@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Spurious completions during NCQ with ahci/WDC WD1600BEVS-2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This happens with all kernel from 2.6.21 up to today Linus's git.
>From time to time, i am getting the following error in dmesg (more
information follows):

ata1.00: exception Emask 0x2 SAct 0xffc SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0xffc
FIS=004040a1:00040000
ata1.00: cmd 61/10:10:c8:c4:c8/00:00:11:00:00/40 tag 2 cdb 0x0 data 8192 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:18:e0:c4:c8/00:00:11:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:20:b0:8c:c9/00:00:11:00:00/40 tag 4 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:28:d0:8c:c9/00:00:11:00:00/40 tag 5 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:30:f8:fa:c9/00:00:11:00:00/40 tag 6 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:38:90:c4:fc/00:00:11:00:00/40 tag 7 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:40:e8:c4:fc/00:00:11:00:00/40 tag 8 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:48:f8:c4:fc/00:00:11:00:00/40 tag 9 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/10:50:f0:c6:80/00:00:12:00:00/40 tag 10 cdb 0x0 data 8192 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:58:50:c7:80/00:00:12:00:00/40 tag 11 cdb 0x0 data 4096 out
         res 40/00:5c:50:c7:80/00:00:12:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA



$ sdparm -a -v /dev/sda:
    /dev/sda: ATA       WDC WD1600BEVS-2  04.0
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
>> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
>> Format (SBC) mode page [0x3] not supported
>> Rigid disk (SBC) mode page [0x4] not supported
>> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
>> Control extension mode subpage [0xa,0x1] not supported
>> SAT pATA control mode subpage [0xa,0xf1] not supported
>> Power condition - old version mode page [0xd] not supported
>> XOR control (SBC) mode page [0x10] not supported
>> Protocol specific logical unit mode page [0x18] not supported
>> Protocol specific port mode page [0x19] not supported
>> Power condition mode page [0x1a] not supported
>> Informational exceptions control mode page [0x1c] not supported
>> Background control (SBC) mode subpage [0x1c,0x1] not supported



$ lspci -vv -nn:
00:00.0 Host bridge [0600]: Intel Corporation Mobile Memory Controller
Hub [8086:2a00] (rev 03)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
Integrated Graphics Controller [8086:2a02] (rev 03) (prog-if 00 [VGA])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

00:02.1 Display controller [0380]: Intel Corporation Mobile Integrated
Graphics Controller [8086:2a03] (rev 03)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at fc100000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB UHCI Contoller #4 [8086:2834] (rev 03) (prog-if 00 [UHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 1820 [size=32]

00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB UHCI Controller #5 [8086:2835] (rev 03) (prog-if 00 [UHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at 1840 [size=32]

00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB2 EHCI Controller #2 [8086:283a] (rev 03) (prog-if 20 [EHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 20
        Region 0: Memory at fc504800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD
Audio Controller [8086:284b] (rev 03)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc300000 (64-bit, non-prefetchable) [size=16K]
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
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
Express Port 1 [8086:283f] (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: f6000000-f7ffffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 2, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0300c  Data: 4169
        Capabilities: [90] Subsystem: Acer Incorporated [ALI] Unknown
device [1025:011f]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
Express Port 2 [8086:2841] (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f8000000-f9ffffff
        Prefetchable memory behind bridge: 00000000f2000000-00000000f3ffffff
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
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 3, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0300c  Data: 4171
        Capabilities: [90] Subsystem: Acer Incorporated [ALI] Unknown
device [1025:011f]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
Express Port 3 [8086:2843] (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=06, subordinate=07, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: fa000000-fbffffff
        Prefetchable memory behind bridge: 00000000f4000000-00000000f5ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
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
                Slot: Number 4, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0300c  Data: 4179
        Capabilities: [90] Subsystem: Acer Incorporated [ALI] Unknown
device [1025:011f]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB UHCI Controller #1 [8086:2830] (rev 03) (prog-if 00 [UHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at 1860 [size=32]

00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB UHCI Controller #2 [8086:2831] (rev 03) (prog-if 00 [UHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 1880 [size=32]

00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB UHCI Controller #3 [8086:2832] (rev 03) (prog-if 00 [UHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 18a0 [size=32]

00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB2 EHCI Controller #1 [8086:2836] (rev 03) (prog-if 20 [EHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fc504c00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
[8086:2448] (rev f3) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=0f, subordinate=13, sec-latency=56
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: fc200000-fc2fffff
        Prefetchable memory behind bridge: 0000000050000000-0000000053ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Gammagraphx, Inc. Unknown device
[0000:0000]

00:1f.0 ISA bridge [0601]: Intel Corporation Mobile LPC Interface
Controller [8086:2815] (rev 03)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface [0101]: Intel Corporation Mobile IDE Controller
[8086:2850] (rev 03) (prog-if 8a [Master SecP PriP])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1810 [size=16]

00:1f.2 SATA controller [0106]: Intel Corporation Mobile SATA AHCI
Controller [8086:2829] (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 2300
        Region 0: I/O ports at 1c00 [size=8]
        Region 1: I/O ports at 18d4 [size=4]
        Region 2: I/O ports at 18d8 [size=8]
        Region 3: I/O ports at 18d0 [size=4]
        Region 4: I/O ports at 18e0 [size=32]
        Region 5: Memory at fc504000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/2 Enable+
                Address: fee0100c  Data: 00a1
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]

00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus
Controller [8086:283e] (rev 03)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 19
        Region 0: Memory at 54000000 (32-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 1c20 [size=32]

02:00.0 Ethernet controller [0200]: Broadcom Corporation NetLink
BCM5787M Gigabit Ethernet PCI Express [14e4:1693] (rev 02)
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011c]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f6000000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D3 PME-Enable+ DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Vendor Specific Information
        Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 00000000fee0200c  Data: 41a9
        Capabilities: [d0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <4us, L1 <64us
                Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number 94-0b-57-fe-ff-d3-16-00

04:00.0 Network controller [0280]: Intel Corporation PRO/Wireless
3945ABG Network Connection [8086:4222] (rev 02)
        Subsystem: Intel Corporation Unknown device [8086:1001]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 2299
        Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000fee0300c  Data: 41b1
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 7a-2e-33-ff-ff-d2-19-00

0f:06.0 CardBus bridge [0607]: Texas Instruments PCIxx12 Cardbus
Controller [104c:8039]
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc204000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=0f, secondary=10, subordinate=13, sec-latency=176
        Memory window 0: 50000000-53fff000 (prefetchable)
        Memory window 1: 58000000-5bfff000
        I/O window 0: 00005000-000050ff
        I/O window 1: 00005400-000054ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

0f:06.1 FireWire (IEEE 1394) [0c00]: Texas Instruments PCIxx12 OHCI
Compliant IEEE 1394 Host Controller [104c:803a] (prog-if 10 [OHCI])
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc206000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at fc200000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

0f:06.2 Mass storage controller [0180]: Texas Instruments 5-in-1
Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fc205000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0f:06.3 Generic system peripheral [0805]: Texas Instruments PCIxx12
SDA Standard Compliant SD Host Controller [104c:803c]
        Subsystem: Acer Incorporated [ALI] Unknown device [1025:011f]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc206800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


-- 
Ciao
Maurizio
http://stregatto.wordpress.com

"Well we all shine on
Like the moon and the stars and the sun" (John Lennon)
