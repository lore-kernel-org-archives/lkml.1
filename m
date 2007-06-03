Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXFCUtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXFCUtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXFCUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:32 -0400
Received: from snowcat.de ([89.31.32.98]:2600 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbXFCUra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:30 -0400
X-Greylist: delayed 2360 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 16:47:30 EDT
From: "Ingo Korb" <ml@akana.de>
Organization: Disorganized
To: linux-kernel@vger.kernel.org
Date: Sun, 03 Jun 2007 22:08:08 +0200
MIME-Version: 1.0
Subject: stallion driver dmesg notice
Message-ID: <46633BC8.3838.43FB8257@ml.akana.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Hashcash: 1:21:070603:linux-kernel@vger.kernel.org::w6D1nD8HKFuueIjf:000000000
	0000000000000000000000004Hq/
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The stallion driver in 2.6.21.3 put this little notice in my dmesg:

=== Cut ===
Stallion Multiport Serial Driver: version 5.6.0
stallion 0000:00:0b.0: please, report this to LKML: 100b/d001/ffffff
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
stallion: probe of 0000:00:0b.0 failed with error -16
=== Cut ===

The card is a EC8/32-PCI with a single connected panel. It used to work 
well with 2.4, mostly well with a patched 2.6.8.1, really bad 
(unstable, lost characters) with 2.6.11(?) and doesn't work at all with 
2.6.21.3.

Should I test it with an EC8/64-PCI? The /32 (ab)uses an IDE controller 
chip as PCI interface, the /64 uses a PLX PCI9050.

lspci -vv for the EC8/32:
=== Cut ===
00:0b.0 Class ffff: National Semiconductor Corporation 87410 IDE (rev 
ff) (prog-if ff)
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at d100 [size=8]
	Region 1: I/O ports at d200 [size=4]
	Region 2: I/O ports at d300 [size=8]
	Region 3: I/O ports at d400 [size=4]
=== Cut ===


-ik


