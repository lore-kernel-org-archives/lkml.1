Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbXGJApe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbXGJApe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760572AbXGJApF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:45:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44241 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408AbXGJApD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:45:03 -0400
Date: Mon, 9 Jul 2007 17:44:16 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       rientjes@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] try parent numa_node at first before using default
Message-ID: <20070710004416.GA6905@kroah.com>
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org> <200707031731.02456.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031731.02456.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 05:31:02PM -0700, Yinghai Lu wrote:
> [PATCH 1/4] try parent numa_node at first before using default
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index dd40d78..c344d82 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
>  
>  void device_initialize(struct device *dev)
>  {
> +	int node;
> +
>  	kobj_set_kset_s(dev, devices_subsys);
>  	kobject_init(&dev->kobj);
>  	klist_init(&dev->klist_children, klist_children_get,
> @@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
>  	spin_lock_init(&dev->devres_lock);
>  	INIT_LIST_HEAD(&dev->devres_head);
>  	device_init_wakeup(dev, 0);
> -	set_dev_node(dev, -1);
> +
> +	node = dev->parent ? dev_to_node(dev->parent) : -1;
> +	set_dev_node(dev, node);
>  }

What is this going to give us?

Doesn't it mean that all devices will end up on the same node?

thanks,

greg k-h
