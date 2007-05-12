Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXELSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXELSt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbXELStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:49:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:40090 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXELStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:49:17 -0400
Date: Sat, 12 May 2007 12:48:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [2.6.21.1] SATA freeze
In-reply-to: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no>
To: Fred Moyer <fred@redhotpenguin.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Message-id: <46460C1B.6000609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fred Moyer wrote:
> I just joined the list today so apologies if this email breaks any email 
> client post threading.
> 
> I have been seeing similar errors on two different systems.  I applied 
> Robert's sata_nv patch posted to the list on May 5th, and approved today 
> by Jeff Garzik.  I've taken several steps to insure that this isn't a 
> faulty cable or drive issue.  This is running on a hp dl145g2.  Here is 
> my lspci, dmesg, and relevant kernel config sections:

(snip)

> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
> 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
> violation)
> ata1: soft resetting port
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/100
> ata1: EH complete

This appears to be a different problem. Something is issuing 
SMART-related commands (smartd or smartctl perhaps) which the drive 
seems to be reacting strangely to. It apparently completed the command 
but never raised DRQ to request any data being transferred even though 
we expected it to. Maybe SMART is disabled on the drive and that's 
causing it to just toss these commands? CCing linux-ide in case anyone 
knows what would cause this.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

