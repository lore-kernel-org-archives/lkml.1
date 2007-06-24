Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbXFXTTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbXFXTTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXFXTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:19:12 -0400
Received: from dd8000.kasserver.com ([85.13.132.92]:43988 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbXFXTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:19:11 -0400
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2007 15:19:11 EDT
Message-ID: <467EBCA1.5070702@gmx.net>
Date: Sun, 24 Jun 2007 20:49:05 +0200
From: otto Meier <gf435@gmx.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_promise disk error 2.6.22-rc5 with hrt1 patch
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got the following in my logs:

Jun 24 19:06:40 gate2 kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x0
Jun 24 19:06:40 gate2 kernel: ata4.00: (port_status 0x00001000)
Jun 24 19:06:40 gate2 kernel: ata4.00: cmd
35/00:00:c1:17:92/00:04:17:00:00/e0 tag 0 cdb 0x0 data 524288 out
Jun 24 19:06:40 gate2 kernel:          res
50/00:00:c0:1b:92/00:00:17:00:00/e0 Emask 0x20 (host bus error)
Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
488397168, hpa_sectors = 488397168
Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
488397168, hpa_sectors = 488397168
Jun 24 19:06:40 gate2 kernel: ata4.00: configured for UDMA/133
Jun 24 19:06:40 gate2 kernel: ata4: EH complete
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte
hardware sectors (250059 MB)
Jun 24 19:06:40 gate2 kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x0
Jun 24 19:06:40 gate2 kernel: ata4.00: (port_status 0x00001000)
Jun 24 19:06:40 gate2 kernel: ata4.00: cmd
25/00:00:c1:15:92/00:02:17:00:00/e0 tag 0 cdb 0x0 data 262144 in
Jun 24 19:06:40 gate2 kernel:          res
50/00:00:c0:17:92/00:00:17:00:00/e0 Emask 0x20 (host bus error)
Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
488397168, hpa_sectors = 488397168
Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
488397168, hpa_sectors = 488397168
Jun 24 19:06:40 gate2 kernel: ata4.00: configured for UDMA/133
Jun 24 19:06:40 gate2 kernel: ata4: EH complete
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte
hardware sectors (250059 MB)
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

The system continued without seeing other effects.

It is runnuning a 2.6.22-rc5 kernel with hrt1 patch.
The drive ist part of a raid5 with 4 identical drives

lspci -vvv gives:

02:06.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
300 TX4) (rev 02)
        Subsystem: Promise Technology, Inc. PDC40718 (SATA 300 TX4)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (1000ns min, 4500ns max), Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at bc00 [size=128]
        Region 2: I/O ports at b800 [size=256]
        Region 3: Memory at fdeff000 (32-bit, non-prefetchable) [size=4K]
        Region 4: Memory at fdec0000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at fdda0000 [disabled] [size=32K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


Has anyone an idea whats going on?

Best regards




