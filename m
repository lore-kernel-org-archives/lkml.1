Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXKHIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXKHIpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXKHIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:45:22 -0500
Received: from www.tglx.de ([62.245.132.106]:37269 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbXKHIpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:45:21 -0500
Date: Thu, 8 Nov 2007 09:44:59 +0100
From: =?ISO-8859-15?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
To: =?ISO-8859-15?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Mark Lord <lkml@rtr.ca>, romieu@fr.zoreil.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: r8169:  NFG in 2.6.24-rc2
Message-ID: <20071108094459.37088d25@dilbert.local>
In-Reply-To: <20071108085256.78a3a14e@dilbert.local>
References: <4731E2AB.5080703@rtr.ca>
	<20071108085256.78a3a14e@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 8 Nov 2007 08:52:56 +0100
schrieb Hans-Jürgen Koch <hjk@linutronix.de>:

> Am Wed, 07 Nov 2007 11:07:07 -0500
> schrieb Mark Lord <lkml@rtr.ca>:
> 
> > My ASUS board has one of these:
> > 
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
> > Subsystem: ASUSTeK Computer Inc. Unknown device 81aa Control: I/O+
> > Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> > SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> > >TAbort- <TAbort- <MAbort- >SERR- <PERR- Interrupt: pin A routed to
> > >IRQ 16 Region 0: I/O ports at 9800 [size=256]
> >         Region 2: Memory at ff3ff000 (64-bit, non-prefetchable)
> > [size=4K] Expansion ROM at ff3c0000 [disabled] [size=128K]
> >         Capabilities: [40] Power Management version 2
> >                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> > PME(D0-,D1+,D2+,D3hot+,D3cold+) Status: D0 PME-Enable- DSel=0
> > DScale=0 PME- Capabilities: [48] Vital Product Data
> >         Capabilities: [50] Message Signalled Interrupts: Mask-
> > 64bit+ Queue=0/1 Enable- Address: 0000000000000000  Data: 0000
> >         Capabilities: [60] Express Endpoint IRQ 0
> >                 Device: Supported: MaxPayload 1024 bytes, PhantFunc
> > 0, ExtTag+ Device: Latency L0s <1us, L1 unlimited
> >                 Device: AtnBtn+ AtnInd+ PwrInd+
> >                 Device: Errors: Correctable- Non-Fatal- Fatal-
> > Unsupported- Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >                 Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
> >                 Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s,
> > Port 0 Link: Latency L0s unlimited, L1 unlimited
> >                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
> >                 Link: Speed 2.5Gb/s, Width x1
> >         Capabilities: [84] Vendor Specific Information
> > 
> > It works perfectly in 2.6.23.
> > It does not work in 2.6.24-rc2.  Dunno about -rc1 or earlier -git*.
> > 
> > Without CONFIG_PCI_MSI, it works slightly, enough to ping it a
> > couple of times, but it then dies when used for anything real:
> > 
> > 	r8169 Gigabit Ethernet driver 2.2LK loaded
> > 	r8169 0000:01:00.0: no MSI. Back to INTx.
> > 	...
> > 	eth0: RTL8168b/8111b at 0xf884a000, 00:17:31:64:e0:bc, XID
> > 30000000 IRQ 16 ...
> > 	r8169: eth0: link up
> > 	...
> > 	kernel: NETDEV WATCHDOG: eth0: transmit timed out
> > 	r8169: eth0: link up
> > 	...
> > Not usable from this point on.
> 
> Same problem here with a MSI K9AGM2 board. The problem appeared in
> 2.6.24-rc1 (http://bugzilla.kernel.org/show_bug.cgi?id=9257).
> 
> It seems to be better in -rc2, at least the chip is detected again. I
> can assign an IP to that interface and bring it up, but no data
> traffic is possible. After some tests in both directions, ifconfig
> reports 157.6 KiB RX bytes, but TX bytes is 0, so sent packets seem
> to disappear quite early.

The patch just submitted by Francois Romieu fixes the problem.

Thanks,
Hans

