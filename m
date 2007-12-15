Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbXLOQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbXLOQ6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 11:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXLOQ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 11:58:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22710 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbXLOQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PyKKZxXrMQXA170GVyAkrjWtSj0R+dSfN4vn0X1EL++En69b5TMVd0RsvuSFhOTyAVl20AdwgrPTqQZZ6VkLliS7kEdTjEbPY1LlJukejvPRnb0lV93ZsOyVQo+cKky8HlUF/WMx1QAtfcVZUVAeae0VU0Dicvjnzx6M8Yp2t/Y=
Message-ID: <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
Date: Sat, 15 Dec 2007 17:58:26 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 007 of 7] md: Get name for block device in sysfs
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <1071214062647.1928@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071214171950.1308.patches@notabene> <1071214062647.1928@suse.de>
X-Google-Sender-Auth: 426791aa6e4d1e5c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
>
> Given an fd on a block device, returns a string like
>
>         /block/sda/sda1
>
> which can be used to find related information in /sys.
>
> Ideally we should have an ioctl that works on char devices as well,
> but that seems far from trivial, so it seems reasonable to have
> this until the later can be implemented.
>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./block/ioctl.c      |   13 +++++++++++++
>  ./include/linux/fs.h |    2 ++
>  2 files changed, 15 insertions(+)
>
> diff .prev/block/ioctl.c ./block/ioctl.c
> --- .prev/block/ioctl.c 2007-12-14 17:18:50.000000000 +1100
> +++ ./block/ioctl.c     2007-12-14 16:15:41.000000000 +1100
> @@ -227,8 +227,21 @@ int blkdev_ioctl(struct inode *inode, st
>         struct block_device *bdev = inode->i_bdev;
>         struct gendisk *disk = bdev->bd_disk;
>         int ret, n;
> +       char b[BDEVNAME_SIZE*2  + 10];
>
>         switch(cmd) {
> +       case BLKGETNAME:
> +               strcpy(b, "/block/");

As pointed out to when you came up with the idea, we can't do this. A devpath
is a path to the device and will not necessarily start with "/block" for block
devices. It may start with "/devices" and can be much longer than
BDEVNAME_SIZE*2  + 10.

Please do not apply!

Kay
