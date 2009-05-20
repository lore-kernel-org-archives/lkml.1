Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZETGmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZETGmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZETGmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:42:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37015 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZETGmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:42:37 -0400
Date: Wed, 20 May 2009 08:42:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cdrom: beyond ARRAY_SIZE of viocd_diskinfo
Message-ID: <20090520064237.GB11363@kernel.dk>
References: <4A133AA7.6020508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A133AA7.6020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20 2009, Roel Kluin wrote:
> Do not go beyond ARRAY_SIZE of viocd_diskinfo

Good catch, applied.

> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
> index 1392935..9b1624e 100644
> --- a/drivers/cdrom/viocd.c
> +++ b/drivers/cdrom/viocd.c
> @@ -587,7 +587,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	struct device_node *node = vdev->dev.archdata.of_node;
>  
>  	deviceno = vdev->unit_address;
> -	if (deviceno > VIOCD_MAX_CD)
> +	if (deviceno >= VIOCD_MAX_CD)
>  		return -ENODEV;
>  	if (!node)
>  		return -ENODEV;
> 

-- 
Jens Axboe

