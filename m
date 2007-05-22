Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXEVBm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXEVBm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXEVBmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:42:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:63238 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbXEVBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=msgCqHM5Z+1aep8tfezzWjg/KxFrpPmPRflliJSMGiujIrXPXdOB2lIJipGPWlvVIi/9JYlcLLdu8VmT0TccBJMydMPS0E6M8+0Wy91SYdjoLvQOTxkEm7v3eZiDHku3EZjHPjxbXkLhQgFzDBd9k5ar04kUcB4lkMiRXNtJ7Mw=
Message-ID: <46524A6D.5050601@gmail.com>
Date: Mon, 21 May 2007 18:42:05 -0700
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI device problem - MMCONFIG, cannot allocate resource region, resource
 collisions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: System Design Works <wsherman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel has a problem allocating resources for my PCI NIC.  Here is 
what the kernel is reporting:

# uname -a
Linux wopr 2.6.20-gentoo-r8 #7 SMP Sun May 20 20:56:56 PDT 2007 i686 AMD 
Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux

# dmesg
...
PCI: BIOS Bug:  MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
...
PCI: Cannot allocate resource region 0 of device 0000:02:02.0
...
PCI: Device 0000:02:02.0 not available because of resource collisions
skge: 0000:02:02.0 cannot enable PCI device
skge: probe of 0000:02:02.0 failed with error -22
...

I have seen other posts reporting similar error messages.  I would like 
to help resolve this problem, and I can do some testing if needed.  More 
info:

Kernel boot params:   pci=nomsi

PCI Device:
    D-Link DGE-530T  (10/100/1000 Gigabit Desktop Adapter)
    http://www.dlink.com/products/?pid=284

Motherboard:
    MSI K9AGM-FID  (AMD Socket AM2)
    Chipset:  SB600 / RS485
    http://www.msicomputer.com/product/p_spec.asp?model=K9AGM-FID&class=mb

# lspci -vvv
...
02:02.0 Non-VGA unclassified device: D-Link System Inc Unknown device 
4901 (rev 11)
        Subsystem: D-Link System Inc Unknown device 4901
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 64 (5750ns min, 7250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at <ignored> (32-bit, non-prefetchable)
        Region 1: I/O ports at b800 [size=256]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
...

Thanks,

Wayne
