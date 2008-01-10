Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYAJBGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYAJBGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYAJBGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:06:23 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:18234 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbYAJBGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:06:21 -0500
Date: Wed, 09 Jan 2008 19:05:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata and starting/stopping ATAPI floppy devices
In-reply-to: <fa.EGIY7yNytG7Ky56/SjBE7Jpn2PY@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <47856F53.4010805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.BDdayWpk9nIIgpj7VGhVqIbyE8o@ifi.uio.no>
 <fa.muhws6klIiRnTK7h6EBkcjLsWKc@ifi.uio.no>
 <fa.zyXilo1bU+hQgN72pXqBeBGBIMs@ifi.uio.no>
 <fa.EGIY7yNytG7Ky56/SjBE7Jpn2PY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
> 
> Prevent libata from starting/stopping non-ATA devices (like ATAPI floppy 
> drives) as they don't seem to like it:
> 
> sd 1:0:1:0: [sdb] Starting disk
> ata2.01: configured for PIO2
> sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 1:0:1:0: [sdb] Sense Key : 0x2 [current]
> sd 1:0:1:0: [sdb] ASC=0x3a ASCQ=0x0

Well, all that error is saying is "No medium present". We could just 
make sd suppress that error on disk starting/stopping..

> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Trimmed message body and reformatted such that it's script friendly.
> 
>  drivers/ata/libata-scsi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.23-orig/drivers/ata/libata-scsi.c	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23-pentium/drivers/ata/libata-scsi.c	2008-01-05 15:50:16.000000000 +0100
> @@ -802,7 +802,8 @@
>  
>  	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
>  
> -	sdev->manage_start_stop = 1;
> +	if (dev->class == ATA_DEV_ATA)
> +		sdev->manage_start_stop = 1;
>  
>  	if (dev)
>  		ata_scsi_dev_config(sdev, dev);


-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

