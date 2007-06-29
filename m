Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXF2K6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXF2K6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 06:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbXF2K5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 06:57:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:65328 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbXF2K5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 06:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ayWNVGmhn2LHcFUEXeYseeP/6cQcHgQr07Kr+IxzPB34xrBgnbO6H7NVP2EYmhHGqP9RxnYMQajtRsjnmmmycMeESPbZnzEXs47CLeQGSZJ5T4Lxk7cOTAdsHm6vxoU6Hs7XQ4omn9/UvfXDEHm5qb6uGRU68pdrZGOegJ2sDgM=
Message-ID: <4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>
Date: Fri, 29 Jun 2007 16:27:52 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4684DEF3.5060103@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <200706282210.23770.hjk@linutronix.de>
	 <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
	 <200706291038.58358.hjk@linutronix.de>
	 <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
	 <4684CDCC.9030202@drzeus.cx>
	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	 <4684D358.9090402@drzeus.cx>
	 <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
	 <4684DEF3.5060103@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Both of them show no sign of MMC.
> >
>
> Then you cannot mount them. What output did you see in dmesg when you inserted
> the card?
>

  The dmesg contains only the following when I remove and insert the card.

<6>imx-mmc imx-mmc.0: card removed
<6>imx-mmc imx-mmc.0: card inserted


   Also I was looking through the code. I found this function for init
of mmc_blk (linux/drivers/mmc/mmc_block.c)


static int __init mmc_blk_init(void)
{
	int res = -ENOMEM;

	res = register_blkdev(major, "mmc");
	if (res < 0) {
		printk(KERN_WARNING "Unable to get major %d for MMC media: %d\n",
		       major, res);
		goto out;
	}
	if (major == 0)
		major = res;

	devfs_mk_dir("mmc");
	return mmc_register_driver(&mmc_driver);

 out:
	return res;
}

    This uses the function devfs_mk_dir() - defined in
linux/fs/devfs/base.c. I don't have devfs enabled in my kernel (kernel
version 2.6.16. In fact I don't even get an option to enable it in
menuconfig.). Can this be the cause of the problem?? I have found the
same code in the original kernel version too (the one from
kernel.org).

Thanks,
Midhun.
