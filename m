Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXFXVbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXFXVbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXFXVat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:30:49 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56543 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXFXVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:30:48 -0400
Date: Sun, 24 Jun 2007 23:30:42 +0200 (MEST)
Message-Id: <200706242130.l5OLUgY8004346@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: gf435@gmx.net, linux-kernel@vger.kernel.org
Subject: Re: sata_promise disk error 2.6.22-rc5 with hrt1 patch
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc: linux-ide added)

On Sun, 24 Jun 2007 20:49:05 +0200, otto Meier wrote:
> I got the following in my logs:
> 
> Jun 24 19:06:40 gate2 kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x0
> Jun 24 19:06:40 gate2 kernel: ata4.00: (port_status 0x00001000)
> Jun 24 19:06:40 gate2 kernel: ata4.00: cmd
> 35/00:00:c1:17:92/00:04:17:00:00/e0 tag 0 cdb 0x0 data 524288 out
> Jun 24 19:06:40 gate2 kernel:          res
> 50/00:00:c0:1b:92/00:00:17:00:00/e0 Emask 0x20 (host bus error)
> Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
> 488397168, hpa_sectors = 488397168
> Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
> 488397168, hpa_sectors = 488397168
> Jun 24 19:06:40 gate2 kernel: ata4.00: configured for UDMA/133
> Jun 24 19:06:40 gate2 kernel: ata4: EH complete
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte
> hardware sectors (250059 MB)
> Jun 24 19:06:40 gate2 kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x0
> Jun 24 19:06:40 gate2 kernel: ata4.00: (port_status 0x00001000)
> Jun 24 19:06:40 gate2 kernel: ata4.00: cmd
> 25/00:00:c1:15:92/00:02:17:00:00/e0 tag 0 cdb 0x0 data 262144 in
> Jun 24 19:06:40 gate2 kernel:          res
> 50/00:00:c0:17:92/00:00:17:00:00/e0 Emask 0x20 (host bus error)
> Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
> 488397168, hpa_sectors = 488397168
> Jun 24 19:06:40 gate2 kernel: ata4.00: ata_hpa_resize 1: sectors =
> 488397168, hpa_sectors = 488397168
> Jun 24 19:06:40 gate2 kernel: ata4.00: configured for UDMA/133
> Jun 24 19:06:40 gate2 kernel: ata4: EH complete
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte
> hardware sectors (250059 MB)
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Jun 24 19:06:40 gate2 kernel: sd 3:0:0:0: [sdd] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> 
> The system continued without seeing other effects.
> 
> It is runnuning a 2.6.22-rc5 kernel with hrt1 patch.
> The drive ist part of a raid5 with 4 identical drives
> 
> lspci -vvv gives:
> 
> 02:06.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
> 300 TX4) (rev 02)

The 300 TX4 model is causing transient errors for several people,
and we don't yet know why. In your case, port_status 0x00001000
means that "host bus is busy more than 256 clock cycles for every
ATA I/O transfer" (quoting the docs). Basically it's a timeout.

As long as it's transient, don't worry.

You may want to try without hrt1 to see if hrt1 is causing the issue.

/Mikael
