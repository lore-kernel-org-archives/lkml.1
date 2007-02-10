Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXBJUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXBJUXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXBJUXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:23:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38481 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845AbXBJUXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:23:18 -0500
Date: Sat, 10 Feb 2007 20:36:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: <rol@as2917.net>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: AHCI - remove probing of ata2
Message-ID: <20070210203652.203f648a@localhost.localdomain>
In-Reply-To: <00d101c74d4e$4ff62df0$2101a8c0@donald>
References: <20070210190643.2e865cc9@localhost.localdomain>
	<00d101c74d4e$4ff62df0$2101a8c0@donald>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, rebooting again, with a new root device as /dev/sde1...
> No problem for the old IDE devices, they are now /dev/sdX.
> 
> But the Jmicron stuff is still broken though no more conflict :(

Thanks. That helps a lot as it narrows it down

> 
> PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
> ata7: PATA max UDMA/100 cmd 0x9C00 ctl 0x9882 bmdma 0x9400 irq 16
> ata8: PATA max UDMA/100 cmd 0x9800 ctl 0x9482 bmdma 0x9408 irq 16
> scsi6 : pata_jmicron
> ata7.00: ATAPI, max UDMA/66
> ata7.00: qc timeout (cmd 0xef)
> ata7.00: failed to set xfermode (err_mask=0x4)
> ata7.00: limiting speed to UDMA/44
> ata7: failed to recover some devices, retrying in 5 secs
> ata7.00: qc timeout (cmd 0xef)
> ata7.00: failed to set xfermode (err_mask=0x4)
> ata7.00: limiting speed to PIO0
> ata7: failed to recover some devices, retrying in 5 secs
> ata7.00: qc timeout (cmd 0xef)
> ata7.00: failed to set xfermode (err_mask=0x4)
> ata7.00: disabled
> scsi7 : pata_jmicron
> ATA: abnormal status 0x7F on port 0x9807

This looks like the problems that hopefully the patches from Tejun and
from Mark Lord cured (the delay after reset and the task file clear)

> Also, I've seen a :
> 
> ata1: Spurious SDB FIS during NCQ issue=0x0 SAct=0x7ff8001f
> FIS=004040a1:00040000
> 
> What's this ? Is it really bad or just a warning ???

It's one Tejun stuck logging in for in order to investigate further.

Alan
