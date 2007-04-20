Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXDTHhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXDTHhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXDTHhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:37:51 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:34918 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbXDTHhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:37:50 -0400
X-Greylist: delayed 1616 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 03:37:50 EDT
Message-ID: <46286775.5000507@goth.net>
Date: Fri, 20 Apr 2007 03:10:45 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070208)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: AGPGart / AMD K7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Tyan Thunder K7x Pro (S2469) and the amd-k7-agp module does not
seem to be probing my AGP device.  I have even tried putting debugging
code into the amd-k7-agp module, and sure enough I can see it being
loaded, but the probe function is never called.  This is with kernel 2.6.19.

Here is my lspci -vvv for the relevent devices:

00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
System Co
ntroller (rev 20)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Step
ping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort
- <MAbort+ >SERR- <PERR-
        Latency: 32
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 1: Memory at c2200000 (32-bit, prefetchable) [size=4K]
        Region 2: I/O ports at 1050 [disabled] [size=4]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64
bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW-
Rate=<n
one>

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
AGP Bridge
 (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Step
ping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort
- <MAbort- >SERR- <PERR-
        Latency: 99
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: c0100000-c01fffff
        Prefetchable memory behind bridge: e0000000-efffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort
- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-


As you can see, the first device is indeed showing up as AGP capable and
such, its just never probed (at least the probe function in amd-k7-agp
is never called once the module is loaded).

To simplefy things, here is a pcitweak -l of the top two devices above:
PCI: 00:00:0: chip 1022,700c card 0000,0000 rev 20 class 06,00,00 hdr 00
PCI: 00:01:0: chip 1022,700d card 0000,0000 rev 00 class 06,04,00 hdr 01

In the amd-k7-agp code, this is in the device list:
    {
    .class      = (PCI_CLASS_BRIDGE_HOST << 8),
    .class_mask = ~0,
    .vendor     = PCI_VENDOR_ID_AMD,
    .device     = PCI_DEVICE_ID_AMD_FE_GATE_700C,
    .subvendor  = PCI_ANY_ID,
    .subdevice  = PCI_ANY_ID,
    },

Which matches the first device.  So I'm completely unsure as to why this
device is never probed or how to fix it.

Any help appreciated,

PreZ :)

PS - please CC me specifically on replies.  I will check the list myself
manually, but just in case I miss something .. :)
