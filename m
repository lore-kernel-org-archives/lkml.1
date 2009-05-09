Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbZEIEXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbZEIEXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 00:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZEIEXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 00:23:21 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33910 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZEIEXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 00:23:20 -0400
Subject: Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Mauelshagen@RedHat.com, dm-devel@RedHat.com, dan.j.williams@gmail.com
In-Reply-To: <1241828002-12742-3-git-send-email-tj@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	 <1241828002-12742-3-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 23:23:19 -0500
Message-Id: <1241842999.6357.2.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 09:13 +0900, Tejun Heo wrote:
> Add scsi_device->alt_capacity and let sd pass it over to genhd.  This
> is to allow SCSI low level drivers to configure alt_capacity via
> slave_configure().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Dan Williams <dan.j.williams@gmail.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/sd.c          |    1 +
>  include/scsi/scsi_device.h |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..f3448bf 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1839,6 +1839,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
>  
>  	set_capacity(disk, sdkp->capacity);
> +	set_alt_capacity(disk, sdp->alt_capacity);
>  	kfree(buffer);
>  
>   out:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 3f566af..b24fdeb 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -92,6 +92,7 @@ struct scsi_device {
>  	unsigned int manufacturer;	/* Manufacturer of device, for using 
>  					 * vendor-specific cmd's */
>  	unsigned sector_size;	/* size in bytes */
> +	size_t alt_capacity;	/* alternative capacity, used by sd */
>  
>  	void *hostdata;		/* available to low-level driver */
>  	char type;

This is done at slightly the wrong level.  Capacity is actually a
property of struct scsi_disk not struct scsi_device ... shouldn't
alt_capacity be at the same level?

James


