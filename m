Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYEHDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYEHDOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 23:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYEHDOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 23:14:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56535 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYEHDN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 23:13:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <48226FF4.1070103@gmail.com>
Date: Wed, 07 May 2008 23:13:56 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
To: Takashi Iwai <tiwai@suse.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
Subject: Re: [git patches] libata updates - (improve post-reset device	ready
 test) regression
References: <20080506154847.GA15299@havoc.gtf.org>
 <20080507145616.GA2210@gentoox2.trippelsdorf.de> <s5hod7ixeaj.wl%tiwai@suse.de>
In-reply-to: <s5hod7ixeaj.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07/05/08 12:35 PM, Takashi Iwai:
> 
> The same problem appears on my machine, too:
> 
> libata version 3.00 loaded.
> ata_piix 0000:00:1f.2: version 2.12
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: SATA max UDMA/133 cmd 0xe400 ctl 0xe500 bmdma 0xe800 irq 19
> ata2: SATA max UDMA/133 cmd 0xe600 ctl 0xe700 bmdma 0xe808 irq 19
> ata1.00: ATA-7: HDS728080PLA380, PF2OA60A, max UDMA/133
> ata1.00: 160836480 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> ata2: link is slow to respond, please be patient (ready=0)
> ata2: device not ready (errno=-16), forcing hardreset
> ata2: link is slow to respond, please be patient (ready=0)
> ata2: SRST failed (errno=-16)
> ata2: link is slow to respond, please be patient (ready=0)
> ata2: SRST failed (errno=-16)
> ata2: link is slow to respond, please be patient (ready=0)
> ata2: SRST failed (errno=-16)
> ata2: SRST failed (errno=-16)
> ata2: reset failed, giving up
> 
> 
> Takashi

Same here as well, with sata_nv.

The patch comment states:

 > This patch implements ata_check_ready(), which takes TF status value
 > and determines whether the port is ready or not considering the above
 > and other conditions, and use it in @check_ready() functions.  This is
 > safe as both 0x77 and 0x7f aren't valid ready status value even though
 > they have BSY bit cleared.

.. but adding a print to the ata_check_ready function shows the status in my 
case is systematically 0x7f for all unconnected links.  This makes 
ata_*_check_ready return 0 where it previously returned 1, and triggers several 
hundred retries (over several minutes) before the boot proceeds.

Marc
