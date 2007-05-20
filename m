Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXETRSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXETRSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbXETRSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:18:46 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:43664 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbXETRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:18:45 -0400
Date: Sun, 20 May 2007 11:18:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
In-reply-to: <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no>
To: l.genoni@oltrelinux.com, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, htejun@gmail.com
Message-id: <465082EA.1040603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no>
 <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no>
 <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

l.genoni@oltrelinux.com wrote:
> 
> Mybe I am wrong, but if you are detecting 40-wire cable to set them to 
> DMA/33, why the check includes also 80-wire cables configuring them to 
> DMA/33 too?
> 
> With this patch my nvidia4 IDE controllers detects correctly and 
> configure correctly DMA/100 for my HD and DMA/33 for my DVD (the first 
> uses a 80-wire cable, the second a 40-wire cable).
> 
> Am I wrong somewhere?
> 
> --- libata-core.c.orig  2007-05-20 14:31:25.000000000 +0200
> +++ libata-core.c       2007-05-20 14:34:01.000000000 +0200
> @@ -3901,8 +3901,7 @@
>                 /* UDMA/44 or higher would be available */
>                 if((ap->cbl == ATA_CBL_PATA40) ||
>                     (ata_drive_40wire(dev->id) &&
> -                    (ap->cbl == ATA_CBL_PATA_UNK ||
> -                     ap->cbl == ATA_CBL_PATA80))) {
> +                    (ap->cbl == ATA_CBL_PATA_UNK))) {
>                         ata_dev_printk(dev, KERN_WARNING,
>                                  "limited to UDMA/33 due to 40-wire 
> cable\n");
>                         xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);

It only does that for ATA_CBL_PATA80 if ata_drive_40wire returns true, 
which means that the drive is detecting a 40-wire cable on its side.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

