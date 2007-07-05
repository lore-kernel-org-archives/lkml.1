Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXGEL7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXGEL7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXGEL6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:58:53 -0400
Received: from echo.digadd.de ([195.47.195.234]:33847 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756842AbXGEL6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:58:53 -0400
X-Greylist: delayed 2348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 07:58:52 EDT
Message-ID: <468CD489.8010205@digadd.de>
Date: Thu, 05 Jul 2007 14:22:49 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serial_pci and AC'97 Softmodems
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.5 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apparently the serial_pci module detects a lot of (non-existent?) serial
ports on my laptop:

ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKG] -> GSI 3 (level, low)
-> IRQ 3
0000:00:08.0: ttyS1 at I/O 0x8828 (irq = 3) is a 8250
0000:00:08.0: ttyS2 at I/O 0x8840 (irq = 3) is a 8250
0000:00:08.0: ttyS3 at I/O 0x8850 (irq = 3) is a 8250
0000:00:08.0: ttyS4 at I/O 0x8860 (irq = 3) is a 8250
0000:00:08.0: ttyS5 at I/O 0x8870 (irq = 3) is a 8250

These are not serial ports, as

00:08.0 0703: 10b9:5457 (prog-if 00 [Generic])
        Subsystem: 103c:0024
00:08.0 Modem: ALi Corporation M5457 AC'97 Modem Controller (prog-if 00
[Generic])
        Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin Modem
Device
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at d0016000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 8800 [size=256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Would it make sense to include a blacklist for these kind of "modem"
devices? I currently can only avoid those bogus serial ports by loading
the hsfmodem driver to block the IO region (yeah, 2.6.22 will bring the
possibility to leave 8250_pci out, I know...)

Regards,
Chris
