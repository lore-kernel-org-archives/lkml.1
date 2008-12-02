Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYLBENy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYLBENy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLBENq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:13:46 -0500
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:32526 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYLBENp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:13:45 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 05:13:39 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org
References: <200812020320.31876.rjw@sisk.pl> <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
In-reply-To: <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812020513.42243.elendil@planet.nl>
X-OriginalArrivalTime: 02 Dec 2008 04:13:42.0862 (UTC) FILETIME=[5CCB26E0:01C95434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Your patch doesn't fix anything, it just hides the bug.

> It would be good to hear what resource this is, and where it got set. So 
> instead of that broken patch that just hides the problem, please try to 
> debug it with something like

Your debug patch gives me on boot (hp 2510p; x86_64; current git head):

  system 00:00: iomem range 0x0-0x9ffff could not be reserved
  system 00:00: iomem range 0xe0000-0xfffff could not be reserved
  system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
  system 00:0a: ioport range 0x500-0x55f has been reserved
  system 00:0a: ioport range 0x800-0x80f has been reserved
  system 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
  system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
  system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
  system 00:0c: ioport range 0x2f8-0x2ff has been reserved
  system 00:0c: ioport range 0x3f8-0x3ff has been reserved
  system 00:0c: ioport range 0x1000-0x107f has been reserved
  system 00:0c: ioport range 0x1100-0x113f has been reserved
  system 00:0c: ioport range 0x1200-0x121f has been reserved
  system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
  system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
  system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
  system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
  system 00:0c: iomem range 0xfed90000-0xfed99fff has been reserved
  system 00:0d: iomem range 0xcee00-0xcffff has been reserved
  system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
  system 00:0d: iomem range 0xfeda0000-0xfedbffff has been reserved
  system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
! pci 0000:02:06.0: BAR 9 0-3ffffff wrong alignment flags 21200 4000000 (0)
! pci 0000:02:06.0: BAR 9 bad alignment 0: [0x000000-0x3ffffff]
  pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
  pci 0000:00:1c.0:   IO window: disabled
  pci 0000:00:1c.0:   MEM window: disabled
  pci 0000:00:1c.0:   PREFETCH window: disabled
  pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
  pci 0000:00:1c.1:   IO window: disabled
  pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe00fffff
  pci 0000:00:1c.1:   PREFETCH window: disabled
  pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
  pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
  pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
  pci 0000:02:06.0:   MEM window: 0x80000000-0x83ffffff
  pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
  pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
  pci 0000:00:1e.0:   MEM window: 0xe0100000-0xe03fffff
  pci 0000:00:1e.0:   PREFETCH window: disabled
  pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:1c.0: setting latency timer to 64
  pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  pci 0000:00:1c.1: setting latency timer to 64
  pci 0000:00:1e.0: setting latency timer to 64
  pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18

>From lspci -vv:
02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
        Subsystem: Hewlett-Packard Company Device 30c9
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at e0100000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: 84400000-847ff000 (prefetchable)
        Memory window 1: 80000000-83fff000
        I/O window 0: 00003000-000030ff
        I/O window 1: 00003400-000034ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket

02:06.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Device 30c9
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: Memory at e0101000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME+
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394

02:06.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
        Subsystem: Hewlett-Packard Company Device 30c9
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 20
        Region 0: Memory at e0102000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

02:06.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: ricoh-mmc
        Kernel modules: ricoh_mmc
