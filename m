Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbXH3PE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbXH3PE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbXH3PEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:04:47 -0400
Received: from maynard.isillc.com ([207.55.182.68]:59151 "EHLO
	maynard.isillc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708AbXH3PEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:04:46 -0400
X-Greylist: delayed 2097 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 11:04:46 EDT
Subject: ICH8 libata SATA periodic drive failure
From: Jerome Haltom <jhaltom@isillc.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Institution Solutions LLC
Date: Thu, 30 Aug 2007 09:29:42 -0500
Message-Id: <1188484182.9953.11.camel@station-1.ad.isillc.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have two systems exhibiting a similar problem, even after swapping out
hard drives. Both systems have Intel ICH8 controllers. One is a server
class board with a Xeon, the other is a desktop class board with a Core
Duo. Both are Intel brand boards.

The server box is unable to use a drive in it's 4th, 5th or 6th SATA
port. The drive appears fine, and works fine for a few minutes, but
eventually starts spitting out errors:

[6494068.025887] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[6494068.073915] ata6.00: ata_hpa_resize 1: sectors = 781422768,
hpa_sectors = 781422768
[6494068.132112] ata6.00: ata_hpa_resize 1: sectors = 781422768,
hpa_sectors = 781422768
[6494068.132118] ata6.00: configured for UDMA/33
[6494068.132123] ata6: EH complete
[6494068.132163] SCSI device sdd: 781422768 512-byte hdwr sectors
(400088 MB)
[6494068.132176] sdd: Write Protect is off
[6494068.132179] sdd: Mode Sense: 00 3a 00 00
[6494068.132196] SCSI device sdd: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[6500148.311961] ata6: exception Emask 0x10 SAct 0x0 SErr 0x40d0002
action 0x2 frozen
[6500148.312013] ata6: (irq_stat 0x04400040, connection status changed)
[6500148.855772] ata6: waiting for device to spin up (8 secs)
[6500157.017604] ata6: soft resetting port

I have tried three drives in these ports. Ports 1, 2 and 3 all work
perfectly. Also have switched cables and such, including exchanging a
known working cable from port #1 with port#4, etc.

The desktop board I have has similar but slightly different issues.

[54733.636292] ata4: exception Emask 0x10 SAct 0x0 SErr 0x10000 action
0x2 frozen
[54733.636301] ata4: (irq_stat 0x00400000, PHY RDY changed)
[54734.352050] ata4: soft resetting port
[54736.875575] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[54736.978632] ata4.00: configured for UDMA/33
[54736.978636] ata4: EH complete
[54736.979560] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[54736.983558] sd 3:0:0:0: [sdc] Write Protect is off
[54736.983562] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[54736.991557] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

The difference is that ports 1, 2, 3 and 4 work fine. It's just port 5
that has an issue. I have yet to try port 6. There is a DVD drive on it
which seems to work fine.

Now, my first thought was maybe my power-supply couldn't power all the
drives. Figured if I just reorganized the plugs, maybe I could cause a
different drive to starve... but nope. It's consistently the same SATA
ports. If it was a power problem, I would not expect it to stay
localized to the same SATA ports.

The server machine is running Ubuntu Feisty with kernel
2.6.20-15-generic. The desktop machine is running Gutsy with kernel
2.6.22-10-generic.

The driver errors aren't yet good enough for me to make a diagnosis.
