Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXJKHOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXJKHOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXJKHOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:14:46 -0400
Received: from pear.igowo.de ([81.95.0.210]:43260 "EHLO pear.igowo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbXJKHOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:14:45 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 03:14:45 EDT
Message-ID: <470DCB24.8090500@igowo.de>
Date: Thu, 11 Oct 2007 09:05:08 +0200
From: Philipp Wollermann <philipp@igowo.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: IDE DMA doesn't work with pata_via and compact flash card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a problem with the linux kernel, which doesn't boot from a 
compact flash card (SanDisk Ultra 2 2048 MB) when trying to use DMA. I 
want to boot my PC from the CF card using a CF-to-IDE adapter. It works 
perfectly when using a card-reader instead of the adapter and booting 
from USB. I'm using kernel 2.6.23 and the new Parallel ATA drivers 
(pata_via). The board is a Tyan Tomcat K7M with the VIA KN400A chipset 
and VT8237 Southbridge. I also tried using the old IDE drivers, which 
give me the same error messages and also hang in a loop like the new 
ones, when using DMA. Turning off DMA for the old IDE drivers or 
patching ata_generic to handle my IDE controller and then deactivating 
DMA in the BIOS works, but then disk I/O is unbelievable slow.. do you 
have any idea how to fix it, so that DMA works?

Best regards,
Philipp

Boot messages:

scsi0: pata_via
scsi1: pata_via
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001e500 
irq 14
ata2: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001e500 
irq 15
ata1.00: CFA: SanDisk SDCFH-2048, HDX 4.04, max MWDMA2
ata1.00: 4001760 sectors, multi 0: LBA
ata1.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access   ATA   SanDisk SDCFH-20 HDX  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 4001760 512-byte hardware sectors (2049 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 4001760 512-byte hardware sectors (2049 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sda:[here it hangs for some time ...]<3>ata1.00: exception Emask 0x0 
SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd c8/00:08:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1.00: configured for MWDMA
ata1: EH complete
ata1.00: cmd c8/00:08:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1.00: configured for MWDMA
ata1: EH complete
ata1.00: cmd c8/00:08:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1.00: configured for MWDMA
ata1: EH complete
[...]




lspci -vv:
[...]
00:00.0 Host bridge: VIA Technologies, Inc. VT8378 [KM400/A] Chipset 
Host Bridge
         Subsystem: VIA Technologies, Inc. VT8378 [KM400/A] Chipset Host 
Bridge
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 8
         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
         Capabilities: [80] AGP version 3.5
                 Status: RQ=32 Iso- ArqSz=0 Cal=2 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=<none>
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
[...]
00:0f.0 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) 
(prog-if 8a [Master SecP PriP])
         Subsystem: VIA Technologies, Inc. 
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32
         Interrupt: pin A routed to IRQ 18
         Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [size=8]
         Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [size=1]
         Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [size=8]
         Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [size=1]
         Region 4: I/O ports at e500 [size=16]
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
[...]
