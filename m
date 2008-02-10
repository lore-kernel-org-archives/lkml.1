Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYBJIjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYBJIjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYBJIjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:39:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:36104 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYBJIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fgKF+ZodOSQ5+8hbr8YYcmHucviCCwVurC2IUOg/Jjcmnetff3ZSctGmx4GLB8LbG8+M0rLsKlGDUzTZt70VemwwZmq8EsSFW3Isty3Wkido3AfX6taI8hYPedu0uFudW6kcwV+QFE6Mccip7JyEEol7Klst4MEpd6FGvplojEM=
Message-ID: <47AEB829.8060104@gmail.com>
Date: Sun, 10 Feb 2008 09:39:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: linux-kernel@vger.kernel.org, dedekind@linutronix.de, haver@vnet.ibm.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Silent compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707
 (UBI: Unsorted Block Images)
References: <200802100537.47634.caglar@pardus.org.tr>
In-Reply-To: <200802100537.47634.caglar@pardus.org.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2008 04:37 AM, S.Çağlar Onur wrote:
> Hi;
> 
> Following patch silents
> 
> drivers/mtd/ubi/vmt.c: In function `ubi_create_volume':
> drivers/mtd/ubi/vmt.c:379: warning: statement with no effect
> 
> compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images)
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
> 
>  drivers/mtd/ubi/vmt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
> index a3ca225..eafeaf0 100644
> --- a/drivers/mtd/ubi/vmt.c
> +++ b/drivers/mtd/ubi/vmt.c
> @@ -376,7 +376,7 @@ out_sysfs:
>  	get_device(&vol->dev);
>  	volume_sysfs_close(vol);
>  out_gluebi:
> -	ubi_destroy_gluebi(vol);
> +	err = ubi_destroy_gluebi(vol);
>  out_cdev:
>  	cdev_del(&vol->cdev);
>  out_mapping:

I think this is not correct. You change the err which caused the failure. You 
change it even to 0 if it doesn't fail and the whole function will seem like 
non-failing.
