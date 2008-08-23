Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYHWKzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYHWKzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHWKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:55:10 -0400
Received: from main.gmane.org ([80.91.229.2]:34755 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYHWKzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:55:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sat, 23 Aug 2008 13:49:49 +0300
Organization: Private
Message-ID: <87od3k2egi.fsf@jondo.cante.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:wME2s7/YVNASSFueMhG7mqBegTg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Message from /etc/syslog:

        [1] Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:00:0d.0

My AMD freezes with Kernel 2.6.25 has experienced regular freezing so
that only power button can take the system down. This is alarming,
because the system can stay up only a few days.

I've spent countless of hours reading related "Out of SW-IOMMU space"
(Google) documents. For some people they have worked, for some they
haven't and there has not been any clear explanation what options
whould/should be used in what chipsets/MBs and why.

I've gone through various combinations of kernel boot options, but
nothing seems to completely solve the problem:

iommu=soft swiotlb=65536

        Freezing continued, but the disk corruption did not happen any more.
        Increasing the swiotlb value has not had helped.

iommu=soft,memaper=3 swiotlb=65536

        Adding memaper did not help. "Out of SW-IOMMU space" messages [see
        1] creept in and I'm preparing to see another freeze eventally.

iommu=noaperture

        Same as above. Not progress.

iommu=noagp,noaperture swiotlb=512M

        Current options that I use. They were giving hope for 2 days,
        but then a single "Out of SW-IOMMU space" message appeared. I'm
        afraid the freeze is about to come.

Should I try following options next? or just "iommu=off"?

        iommu=noagp,noaperture,off swiotlb=512M
                               ===

I don't understand enough what are the effects related to the MCP55 SATA
Controller which seems to be the target [See 1; based on device id
"00:0d.0"] of these IOMMU messages. Only the plain SATA connectors, not
the onboard RAID SATA connectors, are in use for the harddisk.

To best of my knowledge going through this motherboard:

- Asus award bios does not have setting related to IOMMU. I'm using the
  latest bios 2001 from www.asus.com
- has no aperture setting in bios.
- has no AGP, only PCI and CPIe slots.

My arsenal of knowledge is exhausting, so please, if you have any
insight what could be examined further or what could be done to solve
the IOMMU problem, let me know.

Jari

Some of the links and threads I've read
---------------------------------------

        "Appendix L. Known Issues" > The X86-64 platform (AMD64/EM64T) and 2.6 kernels
        ftp://download.nvidia.com/XFree86/Linux-x86/1.0-8174/README/32bit_html/appendix-l.html

        "What is AGP Aperture size?"
        http://www.techpowerup.com/articles/overclocking/vidcard/43

        "PCI-DMA: high address but no IOMMU"
        http://article.gmane.org/gmane.linux.kernel/342411

        "Out of IOMMU space"
        http://www.x86-64.org/pipermail/discuss/2005-September/006490.html

        "Your BIOS doesn't leave a aperture memory hole"
        http://www.linuxquestions.org/questions/linux-hardware-18/your-bios-doesnt-leave-a-aperture-memory-hole-624088/

Hardware details
----------------
 OS
        $ cat /etc/debian_version
        lenny/sid               (pinning: that's 90% testing + 10% unstable packages)

 Kernel
        $ uname -a
        2.6.25-2-amd64 #1 SMP Mon Jul 14 11:05:23 UTC 2008 x86_64 GNU/Linux

 CPU
        $ cat /proc/cpuinfo
        model name      : AMD Athlon(tm) X2 Dual Core Processor BE-2400
        stepping        : 2
        cpu MHz         : 2310.518
        cache size      : 512 KB
        ...

        $ cat /proc/meminfo
        MemTotal:      8266632 kB
        MemFree:        110212 kB
        Buffers:        237132 kB
        Cached:        3803660 kB
        SwapCached:          0 kB
        ...

 HD
        $ hdparm -I /dev/sda

        ATA device, with non-removable media
                Model Number:       ST31000340AS
                Serial Number:      5QJ01MS4
                Firmware Revision:  SD01

        http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD

 MB

        Asus M2N32-SLI Deluxe/Wireless Edition
        - nvidia nForce 590 SLI chipset MCP
        - 2 x PCIe (SLI x16), 1 x PCI (x4), 1 x PCI (x1), 2 x PCI 2.2
        - Socket AM2

        http://www.asus.com/products.aspx?l1=3&l2=101&l3=300&model=1163&modelmenu=1

        $ lspci -nn
        00:0d.0 IDE interface [0101]: nVidia Corporation MCP55 SATA Controller [10de:037f] (rev a2)
        01:00.0 VGA compatible controller [0300]: nVidia Corporation G70 [GeForce 7600 GS] [10de:0392] (rev a1)
        02:0b.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) [104c:8023]
        03:00.0 Mass storage controller [0180]: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller [1095:3132] (rev 01)
        ...

lspci -vv
----------------------------

00:16.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fde00000-fdefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4151
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp


[1] Full message from syslog
-----------------------------

Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:00:0d.0
Aug 21 11:01:19 jondo kernel: [174628.279020] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Aug 21 11:01:19 jondo kernel: [174628.279020] ata3.00: cmd 35/00:00:9f:b9:fd/00:04:71:00:00/e0 tag 0 dma 524288 out
Aug 21 11:01:19 jondo kernel: [174628.279020]          res 50/00:00:96:b9:fd/00:00:71:00:00/e0 Emask 0x40 (internal error)
Aug 21 11:01:19 jondo kernel: [174628.279020] ata3.00: status: { DRDY }
Aug 21 11:01:19 jondo kernel: [174628.322932] ata3.00: configured for UDMA/133
Aug 21 11:01:19 jondo kernel: [174628.322932] ata3: EH complete
Aug 21 11:01:19 jondo kernel: [174628.330761] sd 2:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
Aug 21 11:01:19 jondo kernel: [174628.340876] sd 2:0:0:0: [sda] Write Protect is off
Aug 21 11:01:19 jondo kernel: [174628.340876] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 21 11:01:19 jondo kernel: [174628.351250] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

dmesg
-------------------------------

[    0.914265] Linux agpgart interface v0.103
...
[    3.687719] ata1: SATA link down (SStatus 0 SControl 0)
[    5.770299] ata2: SATA link down (SStatus 0 SControl 0)
[    5.582800] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[    5.582811] ACPI: PCI Interrupt 0000:02:08.1[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[    5.584163] NFORCE-MCP55: 0000:00:0c.0 (rev a1) UDMA133 controller
[    5.584167] NFORCE-MCP55: IDE controller (0x10de:0x036e rev 0xa1) at  PCI slot 0000:00:0c.0
[    5.584187] NFORCE-MCP55: not 100% native mode: will probe irqs later
[    5.584194] NFORCE-MCP55: IDE port disabled
[    5.584198]     ide0: BM-DMA at 0xf400-0xf407, BIOS settings: hda:DMA, hdb:DMA
[    5.584208] Probing IDE interface ide0...
[    5.661667] firewire_ohci: Added fw-ohci device 0000:02:08.1, OHCI version 1.10
[    5.661706] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[    5.661706] ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
[    5.732701] firewire_ohci: Added fw-ohci device 0000:02:0b.0, OHCI version 1.10
[    6.345280] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
[    6.345280] ACPI: PCI Interrupt 0000:00:0a.1[B] -> Link [APCL] -> GSI 20 (level, low) -> IRQ 20
[    6.345280] PCI: Setting latency timer of device 0000:00:0a.1 to 64
[    6.345280] ehci_hcd 0000:00:0a.1: EHCI Host Controller
[    6.345280] ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 2
[    6.345280] ehci_hcd 0000:00:0a.1: debug port 1
[    6.345280] PCI: cache line size of 64 is not supported by device 0000:00:0a.1
[    6.345280] ehci_hcd 0000:00:0a.1: irq 20, io mem 0xfe02e000

