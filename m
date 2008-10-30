Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYJ3Xoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYJ3Xoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJ3Xoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:44:30 -0400
Received: from vena.lwn.net ([206.168.112.25]:51800 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYJ3Xo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:44:29 -0400
Date: Thu, 30 Oct 2008 17:44:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc2 hates my e1000e
Message-ID: <20081030174427.4df2de93@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried booting -rc2 on my desktop system today.  All seems well until
I try to access the net; eth0 doesn't exist anymore.  dmesg tells me:

Oct 30 17:29:38 bike kernel: e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
Oct 30 17:29:38 bike kernel: e1000e: Copyright (c) 1999-2008 Intel Corporation.
Oct 30 17:29:38 bike kernel: e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Oct 30 17:29:38 bike kernel: e1000e 0000:00:19.0: BAR 0: can't reserve mem region [0xfe9e0000-0xfe9fffff]
Oct 30 17:29:38 bike kernel: e1000e 0000:00:19.0: PCI INT A disabled
Oct 30 17:29:38 bike kernel: e1000e: probe of 0000:00:19.0 failed with error -16

Here's what lspci thinks of my device:

00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
	Subsystem: Dell OptiPlex 755
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at fe9e0000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fe9db000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at ecc0 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] PCIe advanced features <?>
	Kernel modules: e1000e

Interestingly, under 2.6.27 it reads thus:

00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
	Subsystem: Dell OptiPlex 755
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 4350
	Region 0: Memory at d4200000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d4225000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at ecc0 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable+
		Address: 00000000fee0200c  Data: 4181
	Capabilities: [e0] PCIe advanced features <?>
	Kernel driver in use: e1000e

The I/O memory has moved, I have no idea why.  I assume that's a feature?

So...what else can I do to help track this one down?

Thanks,

jon
