Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYKJJUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYKJJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYKJJUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:20:03 -0500
Received: from sceest01.correodeempresas.telefonica.es ([212.170.236.202]:53339
	"EHLO sceest01.correodeempresas.telefonica.es" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYKJJUA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:20:00 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 04:20:00 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Regression: Boot hang sizing transparent PCI-to-PCI bridge since after 2.6.25-r7.
Date: Mon, 10 Nov 2008 10:12:22 +0100
Message-ID: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression: Boot hang sizing transparent PCI-to-PCI bridge since after 2.6.25-r7.
Thread-Index: AclDFHCeuI4ZPT5jTkChrD6jjluHIw==
From: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Nov 2008 09:12:23.0195 (UTC) FILETIME=[710E76B0:01C94314]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Time ago I bisected a commit that was making my OKI Anima 3300 laptop
hang during boot.

The offending commit was:

------------
commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Mar 26 11:22:40 2008 -0700

    Revert "PCI: remove transparent bridge sizing"

    This reverts commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, which
    caused various interesting problems for people, including wrong
resource
    allocations.  See for example bugzilla entry "2.6.25-rc2: ohci1394
    problem (MMIO broken)" at

        http://bugzilla.kernel.org/show_bug.cgi?id=10080

[...]
------------

It happenend sometime fter 2.6.25-rc7; since then I've been living on
hand-patched kernels; I can't boot any official kernel from Ubuntu or
Gentoo without patching them. For Ubuntu this would mean rebuilding the
LiveCD and then manually patching every kernel update and restricted
modules distribution...


I filled this bug:

http://bugzilla.kernel.org/show_bug.cgi?id=11054

that seems to be getting no attention at all. It includes detailed lspci
output.


The specific bridge that fails (as far as I can tell from putting
kprintf()'s into the kernel) is:

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=08, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c3000000-c30fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Gammagraphx, Inc. Device 0000
	Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000


A specific weird detail of the machine (I don't know whether it's
related at all) is that the onboard ethernet controller is recognized as
some kind of bridge??? :

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
	Subsystem: CLEVO/KAPOK Computer Device 5403
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at c0007000 (32-bit, non-prefetchable)
[size=4K]
	Region 1: I/O ports at 30b8 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Kernel driver in use: forcedeth


Since this issue means that either I scrap my laptop or suffer a forced
live of kernel micromanagement no matter the distro I choose, I'm very
interested in helping with this. I'll try to find the problem myself if
someone directs me about what to look for.


Regards, and thanks in advance,

   Juan Jesus.


