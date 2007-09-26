Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXIZGSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXIZGSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXIZGR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:17:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11875 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXIZGR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:17:59 -0400
Date: Wed, 26 Sep 2007 08:19:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdrom_open() forgets to unlock on -EROFS failure exits
Message-ID: <20070926061926.GF2367@kernel.dk>
References: <E1IaLAU-00085M-9P@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaLAU-00085M-9P@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26 2007, Al Viro wrote:
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/cdrom/cdrom.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 67ee3d4..7924571 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1032,6 +1032,10 @@ int cdrom_open(struct cdrom_device_info *cdi, struct inode *ip, struct file *fp)
>  	check_disk_change(ip->i_bdev);
>  	return 0;
>  err_release:
> +	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
> +		cdi->ops->lock_door(cdi, 0);
> +		cdinfo(CD_OPEN, "door unlocked.\n");
> +	}
>  	cdi->ops->release(cdi);
>  err:
>  	cdi->use_count--;
> -- 
> 1.5.3.GIT

Looks good Al, applied.

-- 
Jens Axboe

