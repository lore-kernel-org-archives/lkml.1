Return-Path: <linux-kernel-owner+w=401wt.eu-S964846AbXHHQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846AbXHHQbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936605AbXHHQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:29:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47846 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936596AbXHHQ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:29:00 -0400
Message-ID: <46B9EF4A.1030609@garzik.org>
Date: Wed, 08 Aug 2007 12:28:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata git tree, mbox queue status and contents
References: <46B35344.3090208@garzik.org> <46B9D64E.6070609@rtr.ca>
In-Reply-To: <46B9D64E.6070609@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff,
> 
> This patch (below) is needed by WD drives that powerup-in-standby.

> drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after 
> drivers/ata/libata-core.c
> --- a/drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after
> +++ a/drivers/ata/libata-core.c
> @@ -1723,7 +1723,7 @@ int ata_dev_read_id(struct ata_device *d
>         tf.protocol = ATA_PROT_NODATA;
>         tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
>         err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
> -        if (err_mask) {
> +        if (err_mask && id[2] != 0x738c) {
>             rc = -EIO;
>             reason = "SPINUP failed";
>             goto err_out;


Thanks for the poke, it wasn't in my queue.

	Jeff


