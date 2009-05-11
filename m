Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZEKVCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZEKVCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZEKVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:02:33 -0400
Received: from gw.goop.org ([64.81.55.164]:45850 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZEKVCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:02:32 -0400
Message-ID: <4A089267.9090409@goop.org>
Date: Mon, 11 May 2009 14:02:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: jeremy@xensource.com, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, lkml <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] xen/blkfront: remove driver_data direct access of struct
 device
References: <4A087630.30802@gmail.com>
In-Reply-To: <4A087630.30802@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> To avoid direct access to the driver_data pointer in struct device, the
> functions dev_get_drvdata() and dev_set_drvdata() should be used.
>   

Are these the same as the ones Greg KH posted last week?

    J

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 8f90508..ff09809 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -755,12 +755,12 @@ static int blkfront_probe(struct xenbus_device *dev,
>  
>  	/* Front end dir is a number, which is used as the id. */
>  	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
> -	dev->dev.driver_data = info;
> +	dev_set_drvdata(&dev->dev, info);
>  
>  	err = talk_to_backend(dev, info);
>  	if (err) {
>  		kfree(info);
> -		dev->dev.driver_data = NULL;
> +		dev_set_drvdata(&dev->dev, NULL);
>  		return err;
>  	}
>  
> @@ -845,7 +845,7 @@ static int blkif_recover(struct blkfront_info *info)
>   */
>  static int blkfront_resume(struct xenbus_device *dev)
>  {
> -	struct blkfront_info *info = dev->dev.driver_data;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  	int err;
>  
>  	dev_dbg(&dev->dev, "blkfront_resume: %s\n", dev->nodename);
> @@ -924,7 +924,7 @@ static void blkfront_connect(struct blkfront_info *info)
>   */
>  static void blkfront_closing(struct xenbus_device *dev)
>  {
> -	struct blkfront_info *info = dev->dev.driver_data;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  	unsigned long flags;
>  
>  	dev_dbg(&dev->dev, "blkfront_closing: %s removed\n", dev->nodename);
> @@ -959,7 +959,7 @@ static void blkfront_closing(struct xenbus_device *dev)
>  static void backend_changed(struct xenbus_device *dev,
>  			    enum xenbus_state backend_state)
>  {
> -	struct blkfront_info *info = dev->dev.driver_data;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  	struct block_device *bd;
>  
>  	dev_dbg(&dev->dev, "blkfront:backend_changed.\n");
> @@ -997,7 +997,7 @@ static void backend_changed(struct xenbus_device *dev,
>  
>  static int blkfront_remove(struct xenbus_device *dev)
>  {
> -	struct blkfront_info *info = dev->dev.driver_data;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  
>  	dev_dbg(&dev->dev, "blkfront_remove: %s removed\n", dev->nodename);
>  
> @@ -1010,7 +1010,7 @@ static int blkfront_remove(struct xenbus_device *dev)
>  
>  static int blkfront_is_ready(struct xenbus_device *dev)
>  {
> -	struct blkfront_info *info = dev->dev.driver_data;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  
>  	return info->is_ready;
>  }
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>   

