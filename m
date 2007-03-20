Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbXCTXYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbXCTXYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933924AbXCTXYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:24:36 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20807 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921AbXCTXYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:24:35 -0400
Date: Tue, 20 Mar 2007 17:24:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv ADMA controller lockup investigation
In-reply-to: <20070320220132.GA10984@python.ca>
To: Neil Schemenauer <nas@arctrix.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Allen Martin <AMartin@nvidia.com>,
       B.Steinbrink@gmx.de
Message-id: <46006D10.2010205@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45D3E1FF.3080606@shaw.ca> <45D439F7.3030604@garzik.org>
 <45D5389E.70300@shaw.ca> <20070320220132.GA10984@python.ca>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Schemenauer wrote:
> Not sure if this helps.  I'm getting this reset with 2.6.21-rc4.
> After the reset the controller seems to work again.
> 
...
> ata2.00: ATA-7: Maxtor 6V300F0, VA111630, max UDMA/133
> ata2.00: 586114704 sectors, multi 16: LBA48 NCQ (depth 31/32)

...

> ata2: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
> ata2: CPB 1: ctl_flags 0x1f, resp_flags 0x2
> ata2: timeout waiting for ADMA IDLE, stat=0x400
> ata2: timeout waiting for ADMA LEGACY, stat=0x400
> ata2.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 61/00:08:72:44:22/02:00:21:00:00/40 tag 1 cdb 0x0 data 262144 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: configured for UDMA/133
> ata2: EH complete
> SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

That one looks like a drive-side issue. CPB resp_flags 2 indicates the 
drive accepted the command and the controller is still waiting for a 
response.

Could be that this is another drive that needs to be added to the NCQ 
blacklist, some similar Maxtor models seem to have issues..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

