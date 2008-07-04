Return-Path: <linux-kernel-owner+w=401wt.eu-S1751162AbYGDEgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbYGDEgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYGDEfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:35:50 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24959 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYGDEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:35:49 -0400
Date: Thu, 03 Jul 2008 22:35:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
In-reply-to: <fa.Rv78KGguIBjNqcR6d0heXxceZEM@ifi.uio.no>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <486DA89F.9010505@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Rv78KGguIBjNqcR6d0heXxceZEM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On the motherboard itself (all drives configured for AHCI)
> 
> [    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.684566] ata1.00: configured for UDMA/133
> 
> On the PCI-e cards:
> 
> [   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 
> 31/32)
> [   16.162949] ata11.00: configured for UDMA/100
> 
> How come the PCI-e card configured the drive for UDMA/100 and not UDMA/133?
> 
> Perhaps the PCI-e card/driver does not configure/have AHCI 
> functionality, or?
> 
> The mobo: Intel DG965WH
> The card: 03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 
> Serial ATA Raid II Controller (rev 01)
> 
> The hard drives are the same make/model.

Not sure exactly why that is (could be an artificial driver difference), 
but for SATA I don't think the UDMA mode selection matters at all as far 
as throughput. SATA uses its own flow control mechanism, and the UDMA 
rate has no real meaning.

And no, the card is not AHCI, it's Silicon Image's own interface, which 
has most of the same features. (I'm not aware of any AHCI add-in cards, 
though they may exist..)
