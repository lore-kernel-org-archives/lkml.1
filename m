Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXJMPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXJMPqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXJMPqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:46:40 -0400
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:42857 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXJMPqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:46:40 -0400
Date: Sat, 13 Oct 2007 11:46:42 -0400
From: Steven Toth <stoth@hauppauge.com>
Subject: Re: [PATCH] Double-free in cx23885_initdev [sls][spam-bayes]
In-reply-to: <4710DB10.2000107@gmail.com>
To: Florin Malita <fmalita@gmail.com>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4710E862.9090606@hauppauge.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4710DB10.2000107@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch, much appreciated.

- Steve

Florin Malita wrote:
> Both cx23885_initdev and cx23885_dev_setup free the device in their 
> error path so a failure in the latter causes a double-free. Since 
> cx23885_dev_setup is only called from cx23885_initdev, it should be safe 
> to remove its deallocation and leave the cleanup up to the allocating 
> function.
>
> Coverity CID 1922.
>
> Signed-off-by: Florin Malita <fmalita@gmail.com>
> ---
>
>  drivers/media/video/cx23885/cx23885-core.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
> index af16505..3cdd136 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -793,7 +793,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
>  		       dev->pci->subsystem_device);
>  
>  		cx23885_devcount--;
> -		goto fail_free;
> +		return -ENODEV;
>  	}
>  
>  	/* PCIe stuff */
> @@ -835,10 +835,6 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
>  	}
>  
>  	return 0;
> -
> -fail_free:
> -	kfree(dev);
> -	return -ENODEV;
>  }
>  
>  void cx23885_dev_unregister(struct cx23885_dev *dev)
>
>   

