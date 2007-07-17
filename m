Return-Path: <linux-kernel-owner+w=401wt.eu-S936228AbXGQXiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936228AbXGQXiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbXGQXiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:38:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50921 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbXGQXh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:37:59 -0400
Message-ID: <469D52D1.1000803@garzik.org>
Date: Tue, 17 Jul 2007 19:37:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	 <20070717063810.GY5195@kernel.dk>	 <20070717121821.3212cd60.akpm@linux-foundation.org>	 <20070717132233.ed11362c.akpm@linux-foundation.org> <1184710755.3378.30.camel@localhost.localdomain>
In-Reply-To: <1184710755.3378.30.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
>  	int err, (*setfunc)(ide_drive_t *, int);
>  	u8 *val;
>  
> -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> -	if (err != -ENOTTY)
> -		return err;
> +	switch (cmd) {
> +	case SG_IO:
> +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> +	}
>  
>  	switch (cmd) {
>  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;


At that point you might as well use an 'if'.

But overall -- agreed.  ACK.

	Jeff


