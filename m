Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXDQCgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXDQCgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXDQCgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:36:22 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42566 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXDQCgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:36:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17956.12963.163961.762444@smtp.charter.net>
Date: Mon, 16 Apr 2007 22:36:19 -0400
From: "John Stoffel" <john@stoffel.org>
To: linux-kernel@vger.kernel.org
CC: linux-ide@vger.kernel.org
Subject: 2.6.21-rc6-mm1 ATA HPT37x regression
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jeff and crew,

I was just testing out 2.6.21-rc6-mm1 to test some Cyclades patches
and I noticed that my HPT302 (rev1) controller with a pair of 120gb WD
disks are not longer detected and I get the following in the dmesg
logs:

    [  148.121490] hpt37x: DPLL did not stabilize.

Where before, under 2.6.21-rc6 I got the following:

    [  173.749349] pata_hpt37x: BIOS has not set timing clocks.
    [  173.752949] hpt37x: HPT302: Bus clock 33MHz.
    [  173.754409] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level,
    low) -> IRQ
     18
    [  173.758403] ata5: PATA max UDMA/133 cmd 0x0001ecf8 ctl 0x0001ecf2
    bmdma 0x000
    1e800 irq 18
    [  173.761396] ata6: PATA max UDMA/133 cmd 0x0001ece0 ctl 0x0001ecda
    bmdma 0x000
    1e808 irq 18
    [  173.764319] scsi6 : pata_hpt37x
    [  173.928997] ATA: abnormal status 0x78 on port 0x0001ecff
    [  173.930511] scsi7 : pata_hpt37x
    [  174.094906] ATA: abnormal status 0x8 on port 0x0001ece7


Here's my lspci infomation on the board, it's an addon.  My apologies
for the crappy word wrapping, xterms inside screen, etc. 

  03:06.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
  (rev 01)
	  Subsystem: Triones Technologies, Inc. Unknown device 0001
	  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
  ParErr- Step
  ping- SERR+ FastB2B-
	  Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
  >TAbort- <TAbort
  - <MAbort- >SERR- <PERR-
	  Latency: 120 (2000ns min, 2000ns max)
	  Interrupt: pin A routed to IRQ 11
	  Region 0: I/O ports at ecf8 [size=8]
	  Region 1: I/O ports at ecf0 [size=4]
	  Region 2: I/O ports at ece0 [size=8]
	  Region 3: I/O ports at ecd8 [size=4]
	  Region 4: I/O ports at e800 [size=256]
	  Expansion ROM at f9000000 [disabled] [size=128K]
	  Capabilities: [60] Power Management version 2
		  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
  PME(D0-,D1-,D2-,D3hot
  -,D3cold-)
		  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

  03:0a.0 SCSI storage controller: Adaptec AHA-2940U2/U2W / 7890/7891
	  Subsystem: Dell Unknown device 0087
	  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
	  ParErr- Step
  ping- SERR+ FastB2B-
	  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
	  >TAbort- <TAbort
  - <MAbort- >SERR- <PERR-
	  Latency: 64 (9750ns min, 6250ns max), Cache Line Size: 32
	  bytes
	  Interrupt: pin A routed to IRQ 18
	  BIST result: 00
	  Region 0: I/O ports at e400 [disabled] [size=256]
	  Region 1: Memory at f8fff000 (64-bit, non-prefetchable)
	  [size=4K]
	  Expansion ROM at f1000000 [disabled] [size=128K]
	  Capabilities: [dc] Power Management version 1
		  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
	  PME(D0-,D1-,D2-,D3hot
  -,D3cold-)
		  Status: D0 PME-Enable- DSel=0 DScale=0 PME-



I'm moving to 2.6.21-rc7 now, but I'm willing to test out patches as
needed.  I suspect it's the move from the 0.6.0 driver to the 0.6.5
version, and the changes in the hpt_clock hpt37x_timings_* arrays, but
god knows which ones are affecting me.

Thanks,
John
