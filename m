Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbXKGQHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbXKGQHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:07:10 -0500
Received: from rtr.ca ([76.10.145.34]:4728 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXKGQHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:07:08 -0500
Message-ID: <4731E2AB.5080703@rtr.ca>
Date: Wed, 07 Nov 2007 11:07:07 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: romieu@fr.zoreil.com, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: r8169:  NFG in 2.6.24-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My ASUS board has one of these:

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81aa
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 9800 [size=256]
        Region 2: Memory at ff3ff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at ff3c0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <1us, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information

It works perfectly in 2.6.23.
It does not work in 2.6.24-rc2.  Dunno about -rc1 or earlier -git*.

Without CONFIG_PCI_MSI, it works slightly, enough to ping it a couple of times,
but it then dies when used for anything real:

	r8169 Gigabit Ethernet driver 2.2LK loaded
	r8169 0000:01:00.0: no MSI. Back to INTx.
	...
	eth0: RTL8168b/8111b at 0xf884a000, 00:17:31:64:e0:bc, XID 30000000 IRQ 16
	...
	r8169: eth0: link up
	...
	kernel: NETDEV WATCHDOG: eth0: transmit timed out
	r8169: eth0: link up
	...
Not usable from this point on.

With CONFIG_PCI_MSI=y, it also fails, and then isn't even detected (not in lspci)
on subsequent reboots.  A power cycle is required to get it to show up again.

Help?
