Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZEFUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZEFUcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZEFUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:32:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbZEFUcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:32:06 -0400
Date: Wed, 6 May 2009 17:30:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dereferencing freed in saa5246a.c
Message-ID: <20090506173048.0ad84f85@pedra.chehab.org>
In-Reply-To: <20090506161317.24311.48890.stgit@t61.ukuu.org.uk>
References: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
	<20090506161317.24311.48890.stgit@t61.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 06 May 2009 17:13:33 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> escreveu:

> From: Dan Carpenter <error27@gmail.com>
> 
> I lowered the kfree(t) down a couple lines and removed the superflous
> "t->vdev = NULL;"
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
> 
>  drivers/media/video/saa5246a.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
> index da47b2f..155804b 100644
> --- a/drivers/media/video/saa5246a.c
> +++ b/drivers/media/video/saa5246a.c
> @@ -1092,9 +1092,8 @@ static int saa5246a_probe(struct i2c_client *client,
>  	/* Register it */
>  	err = video_register_device(t->vdev, VFL_TYPE_VTX, -1);
>  	if (err < 0) {
> -		kfree(t);
>  		video_device_release(t->vdev);
> -		t->vdev = NULL;
> +		kfree(t);
>  		return err;
>  	}
>  	return 0;
> 


-- 

Cheers,
Mauro
