Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZEEO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZEEO1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZEEO1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:27:31 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:39088 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZEEO1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:27:30 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2009 10:27:29 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am8FAN/o/0l5LAyc/2dsb2JhbACBUM5/hAEF
X-IronPort-AV: E=Sophos;i="4.40,297,1238941800"; 
   d="scan'208";a="374766599"
Date: Wed, 6 May 2009 00:22:19 +1000 (EST)
From: Tim Connors <tconnors@rather.puzzling.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: sata_sil24 EH complete
Message-ID: <alpine.DEB.2.00.0905060004100.15177@dirac.rather.puzzling.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.29, when I hotplug a western digital mybook into a 'Silicon
Image, Inc. SiI 3132 Serial ATA Raid II Controller', the drive is not
found:


*** drive failed due to user induced sillyness
...
[18676.308750] sd 0:0:0:0: [sdb] Stopping disk
[18676.308770] sd 0:0:0:0: [sdb] START_STOP FAILED
[18676.308774] sd 0:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
*** drive plugged back in
[18767.821747] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[18767.821756] ata1: irq_stat 0x00b40090, PHY RDY changed
[18767.821775] ata1: hard resetting link
[18774.633185] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[18774.773591] ata1.00: applying link speed limit horkage to 1.5 Gbps
[18779.655674] ata1: hard resetting link
[18781.861074] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[18782.178565] ata1.00: configured for UDMA/100
[18782.178579] ata1: EH complete

And then nothing.  The device is still alive - if I plug it back in
through its usb interface, it comes up normally.  I know from experience
that if I was to reboot the machine, it would have come up quite nicely
from boot:

[    9.780090] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    9.916218] ata1.00: applying link speed limit horkage to 1.5 Gbps
[   16.981087] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[   17.291757] ata1.00: configured for UDMA/100
[   17.291874] scsi 0:0:0:0: Direct-Access     ATA      WD My Book       01.0 PQ: 0 ANSI: 5
[   17.291959] sd 0:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[   17.291972] sd 0:0:0:0: [sdb] Write Protect is off
[   17.291974] sd 0:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   17.291994] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.292051] sd 0:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[   17.292150] sd 0:0:0:0: [sdb] Write Protect is off
[   17.292153] sd 0:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   17.292176] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.292179]  sdb: sdb1
[   17.372927] sd 0:0:0:0: [sdb] Attached SCSI disk

This is another attempt plugging in another mybook disk:

[20662.149223] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[20662.149233] ata1: irq_stat 0x00a00080, device exchanged
[20662.149252] ata1: hard resetting link
[20672.164117] ata1: softreset failed (timeout)
[20672.164139] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[20672.164143] ata1: link online but device misclassified, retrying
[20672.164146] ata1: hard resetting link
[20674.372055] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[20674.510116] ata1.00: applying link speed limit horkage to 1.5 Gbps
[20679.372028] ata1: hard resetting link
[20681.572066] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[20681.880986] ata1.00: configured for UDMA/100
[20681.880999] ata1: EH complete

Still no /dev/sd*

I haven't tried booting into a kernel prior to these updates:
http://lkml.org/lkml/2009/2/2/447


-- 
TimC
Yay! I have found the last bug bug bug bug bug bug bug
bug bug bug bug bug bug bug bug bug bug bug bug bug bug
bug bug bu%$@#$@#%$@#    Error: Missing Carrier Signal
