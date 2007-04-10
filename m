Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXDJIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXDJIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXDJIVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:21:37 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58314 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030470AbXDJIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:21:35 -0400
Date: Tue, 10 Apr 2007 12:20:49 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support implementation.
Message-ID: <20070410082049.GC16621@2ka.mipt.ru>
References: <20070409212723.31670.27976.stgit@gitlost.site> <20070409212841.31670.59366.stgit@gitlost.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070409212841.31670.59366.stgit@gitlost.site>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 10 Apr 2007 12:21:00 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 02:28:41PM -0700, Peter P Waskiewicz Jr (peter.p.waskiewicz.jr@intel.com) wrote:
> + 	alloc_size = (sizeof(struct net_device_subqueue) * queue_count);
> + 
> + 	p = kzalloc(alloc_size, GFP_KERNEL);
> + 	if (!p) {
> + 		printk(KERN_ERR "alloc_netdev: Unable to allocate queues.\n");
> + 		return NULL;

I think you either do not want to print it, or want additional details
about device...

> + 	}
> + 
> + 	dev->egress_subqueue = p;
> + 	dev->egress_subqueue_count = queue_count;
> +
>  	dev->get_stats = maybe_internal_stats;
>  	setup(dev);
>  	strcpy(dev->name, name);
>  	return dev;
>  }
> -EXPORT_SYMBOL(alloc_netdev);
> +EXPORT_SYMBOL(alloc_netdev_mq);
>  
>  /**
>   *	free_netdev - free network device
> @@ -3345,6 +3358,7 @@ void free_netdev(struct net_device *dev)
>  {
>  #ifdef CONFIG_SYSFS
>  	/*  Compatibility with error handling in drivers */
> +	kfree((char *)dev->egress_subqueue);
>  	if (dev->reg_state == NETREG_UNINITIALIZED) {
>  		kfree((char *)dev - dev->padded);
>  		return;
> @@ -3356,6 +3370,7 @@ void free_netdev(struct net_device *dev)
>  	/* will free via device release */
>  	put_device(&dev->dev);
>  #else
> +	kfree((char *)dev->egress_subqueue);

Still casting :)


-- 
	Evgeniy Polyakov
