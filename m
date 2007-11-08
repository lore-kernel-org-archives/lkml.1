Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXKHHB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXKHHB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXKHHBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:01:50 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:39075 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXKHHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:01:49 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Thu, 8 Nov 2007 09:01:38 +0200
Message-Id: <20071108065119.M10146@visp.net.lb>
In-Reply-To: <4732693B.1070509@shaw.ca>
References: <fa.FFqM2AneKZLH2d3/UIeCMjE/RLE@ifi.uio.no> <4732693B.1070509@shaw.ca>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You are right, seems no dma lines in adapter. hda=nodma helped, no errors 
anymore. I will try now also libata_dma_mask and will mail result. Btw there 
is no notes in Documentation/kernel-parameters.txt about it.

In any case it is complete board, WRAP.2C made by PCEngines in 2003. Kind of 
popular and mass produced, before was widely used by StarOS, probably known 
GPL violator, who didn't bother himself to supply patches, but at same time 
used it in his projects.

If it is valid for all board with this revision, maybe it is better to put it 
in some kind of fixup/quirk/black list, or how it is called?

On Wed, 07 Nov 2007 19:41:15 -0600, Robert Hancock wrote
> Denys wrote:
> > Finally i got full DMESG with 1GB card till end. Seems not readable too.
> >
> 
> ...
> 
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 
in
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata1.00: status: { DRDY }
> > ata1: soft resetting link
> > ata1.00: configured for MWDMA1
> > sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> > sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> > Descriptor sense data with sense descriptors (in hex):
> >         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> >         00 00 00 00
> > sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> > end_request: I/O error, dev sda, sector 0
> > Buffer I/O error on device sda, logical block 0
> > ata1: EH complete
> 
> I'm guessing that your CF-to-IDE adapter doesn't have the correct 
> lines wired up for DMA to work properly, and the card indicates DMA 
> support, which libata tries to use but which doesn't work. It looks 
> like it never tried falling back to PIO after DMA failed. Seems like 
> a deficiency in the speed-down logic?
> 
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

