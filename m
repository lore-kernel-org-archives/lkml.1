Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYBDR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYBDR3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbYBDR3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:29:07 -0500
Received: from rtr.ca ([76.10.145.34]:3922 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbYBDR3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:29:05 -0500
Message-ID: <47A74B5F.7020202@rtr.ca>
Date: Mon, 04 Feb 2008 12:29:03 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org> <20071201154646.5a288c9e@laptopd505.fenrus.org> <4751F484.6040204@rtr.ca> <200712020120.36439.rjw@sisk.pl>
In-Reply-To: <200712020120.36439.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re:  http://bugzilla.kernel.org/show_bug.cgi?id=9489

This just happened here again.  Or at least I finally noticed that
the fan on my notebook seemed to be running hard for much longer
than usual.  :)

Powertop showed 2.6.24-final running with 10000-36000 wakeups/sec,
with *nothing* significant running:  top showed 97+% idle on both cores.

/proc/interrupts didn't have anything interesting either.

I've put a snap of the powertop output into Bug 9489 (link above),
along with the kernel .config again.

This was after an uptime of many days, with lots of suspend/resume (RAM)
cycles and even a few hibernate/resume cycles.

lspci -vv  doesn't show much different from a fresh reboot
versus what was seem "during" the problem:

--- lspci.rebooted      2008-02-04 12:18:53.000000000 -0500
+++ lspci.during        2008-02-04 12:16:04.000000000 -0500
@@ -44,7 +44,7 @@
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
-       Interrupt: pin A routed to IRQ 21
+       Interrupt: pin A routed to IRQ 20
        Region 0: Memory at efffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
@@ -174,7 +174,7 @@
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
-       Interrupt: pin B routed to IRQ 21
+       Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at bf60 [size=32]

 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
@@ -182,7 +182,7 @@
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
-       Interrupt: pin C routed to IRQ 22
+       Interrupt: pin C routed to IRQ 21
        Region 4: I/O ports at bf40 [size=32]

 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
@@ -190,7 +190,7 @@
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
-       Interrupt: pin D routed to IRQ 23
+       Interrupt: pin D routed to IRQ 22
        Region 4: I/O ports at bf20 [size=32]

 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
@@ -296,7 +296,7 @@
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
-       Interrupt: pin B routed to IRQ 20
+       Interrupt: pin B routed to IRQ 23
        Region 0: Memory at ef9fd400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)


Interestingly, lspci *does* show larger differences from "fresh reboot"
to "fresh resume from hibernate" after said reboot.  I don't think this should happen:

--- lspci.rebooted      2008-02-04 12:18:53.000000000 -0500
+++ lspci.afterhib2     2008-02-04 12:22:29.000000000 -0500
@@ -13,7 +13,7 @@
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: efd00000-efefffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [88] Subsystem: Dell Unknown device 01cd
        Capabilities: [80] Power Management version 2
@@ -24,7 +24,7 @@
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
-               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
+               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 2
@@ -69,12 +69,12 @@
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
-               Device: Errors: Correctable- Non-Fatal- Fatal+ Unsupported-
+               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
@@ -101,12 +101,12 @@
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
        Memory behind bridge: efc00000-efcfffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
-               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
+               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
@@ -140,7 +140,7 @@
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
-               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
+               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4


Rafael ?
