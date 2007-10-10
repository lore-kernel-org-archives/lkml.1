Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXJJTDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXJJTDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXJJTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:02:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:38432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbXJJTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=U8NTNDS6tUILUeid3wdFHNAHvTi//IP9AYi1SjZJeSHhqk5zhe98YZZJq6IslWRzmfS5B1YUDfcpPeBWwsxWOXlQlWHpUeOl4estfD+mHwBsCvUI3DybfY9ppgoAok2ZRb+pHKAcbxcNcciIfRXpG/jnG93NnFD3iMMwHFz/Iv0=
Date: Wed, 10 Oct 2007 21:03:43 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Hitachi disk: spurious completions during NCQ
Message-ID: <20071010190342.GA13843@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
sometimes kernel complains about spurious completions on my new
notebook:

ata3.00: exception Emask 0x2 SAct 0x407fd SErr 0x0 action 0x2 frozen
ata3.00: spurious completions during NCQ issue=0x0 SAct=0x407fd FIS=005040a1:00020000
ata3.00: cmd 61/08:00:c7:5a:82/00:00:1b:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:10:3f:5b:fa/00:00:18:00:00/40 tag 2 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:18:5f:5b:fa/00:00:18:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/18:20:6f:5b:fa/00:00:18:00:00/40 tag 4 cdb 0x0 data 12288 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:28:e7:19:fd/00:00:18:00:00/40 tag 5 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:30:df:59:ae/00:00:1a:00:00/40 tag 6 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:38:3f:5a:ae/00:00:1a:00:00/40 tag 7 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/08:40:6f:62:ae/00:00:1a:00:00/40 tag 8 cdb 0x0 data 4096 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/28:48:d7:59:7e/00:00:1b:00:00/40 tag 9 cdb 0x0 data 20480 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/10:50:07:5b:82/00:00:1b:00:00/40 tag 10 cdb 0x0 data 8192 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3.00: cmd 61/30:90:f7:5a:fa/00:00:18:00:00/40 tag 18 cdb 0x0 data 24576 out
         res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
ata3: soft resetting port
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

(this is a very recent 2.6.23-git, SMP, x86_64)

The disk is:

ATA device, with non-removable media
        Model Number:       Hitachi HTS542525K9SA00
        Firmware Revision:  BBFOC31P

The controller is: 

00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Unknown device 14e7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 1272
        Region 0: I/O ports at ec00 [size=8]
        Region 1: I/O ports at e880 [size=4]
        Region 2: I/O ports at e800 [size=8]
        Region 3: I/O ports at e480 [size=4]
        Region 4: I/O ports at e400 [size=32]
        Region 5: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
                Address: fee0300c  Data: 41b9
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]

and I'm using AHCI driver.

I see that similar disks are already blacklisted, probably this one is
bugged too - though the error is pretty rare :(

Luca
-- 
"Di tutte le perversioni sessuali, la castita` e` la piu` strana".
Anatole France
