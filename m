Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYAJRnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYAJRnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYAJRmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:42:53 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:33005 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYAJRmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:42:52 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata and starting/stopping ATAPI floppy devices
Date: Thu, 10 Jan 2008 18:42:15 +0100
User-Agent: KMail/1.9.7
Cc: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <fa.BDdayWpk9nIIgpj7VGhVqIbyE8o@ifi.uio.no> <fa.EGIY7yNytG7Ky56/SjBE7Jpn2PY@ifi.uio.no> <47856F53.4010805@shaw.ca>
In-Reply-To: <47856F53.4010805@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101842.19688.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 02:05:23 Robert Hancock wrote:
> Tejun Heo wrote:
> > From: Ondrej Zary <linux@rainbow-software.org>
> >
> > Prevent libata from starting/stopping non-ATA devices (like ATAPI floppy
> > drives) as they don't seem to like it:
> >
> > sd 1:0:1:0: [sdb] Starting disk
> > ata2.01: configured for PIO2
> > sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> > sd 1:0:1:0: [sdb] Sense Key : 0x2 [current]
> > sd 1:0:1:0: [sdb] ASC=0x3a ASCQ=0x0
>
> Well, all that error is saying is "No medium present". We could just
> make sd suppress that error on disk starting/stopping..

Yes, provided that the start/stop command is valid for ATAPI drives and is the 
correct thing to do. I don't know.

>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > Signed-off-by: Tejun Heo <htejun@gmail.com>
> > ---
> > Trimmed message body and reformatted such that it's script friendly.
> >
> >  drivers/ata/libata-scsi.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > --- linux-2.6.23-orig/drivers/ata/libata-scsi.c	2007-10-09
> > 22:31:38.000000000 +0200 +++
> > linux-2.6.23-pentium/drivers/ata/libata-scsi.c	2008-01-05
> > 15:50:16.000000000 +0100 @@ -802,7 +802,8 @@
> >
> >  	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
> >
> > -	sdev->manage_start_stop = 1;
> > +	if (dev->class == ATA_DEV_ATA)
> > +		sdev->manage_start_stop = 1;
> >
> >  	if (dev)
> >  		ata_scsi_dev_config(sdev, dev);



-- 
Ondrej Zary
