Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbXKHBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbXKHBlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXKHBl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:41:26 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34281 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXKHBlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:41:25 -0500
Date: Wed, 07 Nov 2007 19:41:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
In-reply-to: <fa.FFqM2AneKZLH2d3/UIeCMjE/RLE@ifi.uio.no>
To: Denys <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Message-id: <4732693B.1070509@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=KOI8-R; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FFqM2AneKZLH2d3/UIeCMjE/RLE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys wrote:
> Finally i got full DMESG with 1GB card till end. Seems not readable too.
> 

..


> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>         00 00 00 00
> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> ata1: EH complete

I'm guessing that your CF-to-IDE adapter doesn't have the correct lines 
wired up for DMA to work properly, and the card indicates DMA support, 
which libata tries to use but which doesn't work. It looks like it never 
tried falling back to PIO after DMA failed. Seems like a deficiency in 
the speed-down logic?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

