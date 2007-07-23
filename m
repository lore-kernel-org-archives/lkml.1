Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbXGWPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbXGWPOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXGWPOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:14:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42163 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750977AbXGWPOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:14:25 -0400
Date: Mon, 23 Jul 2007 16:47:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers/scsi/scsi_sysfs.c:718: warning: unused
	variable `rq'
Message-ID: <20070723144752.GJ26212@stusta.de>
References: <20070723143637.GB23448@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070723143637.GB23448@slug>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:36:38PM +0200, Frederik Deweerdt wrote:
> Hi James,
> 
> A compile of the latest git on arm triggers the following warning:
>   CC [M]  drivers/scsi/scsi_sysfs.o
>   drivers/scsi/scsi_sysfs.c: In function `scsi_sysfs_add_sdev':
>   drivers/scsi/scsi_sysfs.c:718: warning: unused variable `rq'
> 
> The following patch kills the intermediary variable.
> 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 34cdce6..9e5cc4f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -715,7 +715,6 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
>  int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  {
>  	int error, i;
> -	struct request_queue *rq = sdev->request_queue;
>  
>  	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
>  		return error;
> @@ -736,7 +735,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	 * released by the sdev_class .release */
>  	get_device(&sdev->sdev_gendev);
>  
> -	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
> +	error = bsg_register_queue(sdev->request_queue,
> +				   &sdev->sdev_gendev, NULL);
>  
>  	if (error)
>  		sdev_printk(KERN_INFO, sdev,

A better solution would be to make the dummy bsg_{,un}register_queue() 
for the CONFIG_BLK_DEV_BSG=n case static inline's.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

