Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYC0OHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYC0OHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYC0OHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:07:11 -0400
Received: from penti.org ([193.167.33.200]:35012 "EHLO penti.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbYC0OHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:07:10 -0400
X-Greylist: delayed 792 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 10:07:09 EDT
Date: Thu, 27 Mar 2008 15:53:56 +0200 (EET)
From: Harald Hannelius <harald@iki.fi>
X-X-Sender: harald@penti.org
To: linux-kernel@vger.kernel.org
Subject: tg3 bad performance, lots of hardware interrupts
Message-ID: <alpine.DEB.1.00.0803271532570.30549@penti.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,

I experience a lot of hardware interrupts with a BCM5751 PCI-express NIC 
(tg3). modprobe tg3, ifconfig ethX up and friends makes the system 
unresponsive. Just having the interface up makes the system sluggish.

Onboard forcedeth works fine (with the same cable).

iperf gives me just 2Mbps on a 1Gbps ethernet. Load average near 1.0. top 
reports 40-50%hi (hardware interrupts) when generating traffic over that 
interface.

The system is a Supermicro H8SMI-2 motherboard, HP EA833AA BROADCOM 
NETXTREME PCI-express NIC, 2GB RAM, Dual-Core opteron 2.8GHz.

All of our other servers with broadcom NIC's work fine with tg3, but they 
aren't PCI-express.

I have tried booting with pci=nomsi and pci=routeirq (BIOS with or without 
"pnp OS" defined). Ubuntu 7.10 live-cd same result. Haven't tried other 
OS'es.

irq_balancing enabled.

Kernel conf: http://www.iki.fi/~harald/kernconf.gz (9kB).

Any hints on what to check for? Hardware or tg3 driverproblem?


I would be glad to report more info, if needed. I have profiling support 
but I have never profiled a kernel before. I haven't got any other PCI-e 
NIC's to test with, yet.


# uname -r
2.6.24.4

# dmesg|grep tg
tg3.c:v3.86 (November 9, 2007)

# lspci -vvv
07:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet PCI Express (rev 21)
 	Subsystem: Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet PCI Express
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 216
 	Region 0: Memory at febf0000 (64-bit, non-prefetchable) [size=64K]
 	Expansion ROM at febe0000 [disabled] [size=64K]
 	Capabilities: [48] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
 	Capabilities: [50] Vital Product Data
 	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+
 		Address: 00000000fee0300c  Data: 4142
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


-- 
A: Top Posters!                                      |  s/y Charlotta |
Q: What is the most annoying thing on mailing lists? |    FIN-2674    |
   http://www.fe83.org/ Finn Express Purjehtijat ry   |  ============= |
Harald H Hannelius | harald (At) iki (dot) fi | GSM +358 50 594 1020
