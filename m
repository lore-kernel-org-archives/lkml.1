Return-Path: <linux-kernel-owner+w=401wt.eu-S937188AbXGRA0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937188AbXGRA0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbXGRA0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:26:04 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:9877 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbXGRA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KHzq+JGECEGbMrfVRmDnxW6+4iKq1jIjKhMMr7Eq4fRufCA+dztihkq/9Swb5L36wRvv9a/9N31JBTY+qBONZn9vlgnJRHIF+0aw/L6K2p79CwgTWl80OqKunyA+FJ5H3YH+VyxzWqTZPpTHFQjJWmYDNGf/H5VjlC1klPypgog=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 02:43:13 +0200
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20070716165706.348f6bbf.akpm@linux-foundation.org> <1184710755.3378.30.camel@localhost.localdomain> <469D52D1.1000803@garzik.org>
In-Reply-To: <469D52D1.1000803@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180243.13368.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ James, please remeber to cc: linux-ide on IDE patches, thanks. ]

On Wednesday 18 July 2007, Jeff Garzik wrote:
> James Bottomley wrote:
> > @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
> >  	int err, (*setfunc)(ide_drive_t *, int);
> >  	u8 *val;
> >  
> > -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > -	if (err != -ENOTTY)
> > -		return err;
> > +	switch (cmd) {
> > +	case SG_IO:
> > +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > +	}
> >  
> >  	switch (cmd) {
> >  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
> 
> 
> At that point you might as well use an 'if'.
> 
> But overall -- agreed.  ACK.

James/Jeff thanks for following the issue but NAK. ;)

Causes regression wrt ide-floppy CDROMEJECT/CDROMCLOSETRAY support when
compared to 2.6.22 and SG_IO is not supported by ide-{disk,scsi,tape}.

Luckily Linus has already fixed the issue properly.

BTW cmd == 1 IOCTL is not defined/used by IDE driver.

Thanks,
Bart
