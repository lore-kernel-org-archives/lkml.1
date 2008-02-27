Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYB0Mdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYB0Mdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbYB0MdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:33:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:46922 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753606AbYB0MdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:33:04 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+Qi6BaQISQByVxRqpR7GimieTn4oZuQQckehtvRI
	YMu6dUREabhUrW
Date: Wed, 27 Feb 2008 13:33:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0802271328300.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <20080226201619.GA10343@kroah.com> <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
 <20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Cornelia Huck wrote:

> On Wed, 27 Feb 2008 12:24:54 +0100 (CET),
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Ok, result #1: kernel panic 
> > http://home.arcor.de/g.liakhovetski/ap400/imga0045.jpg. If necessary, can 
> > try a serial console, but that would be more difficult.
> 
> Looking at device_add(): Does the following patch make the oops go away?

You mean the kernel panic without CONFIG_SYSFS_DEPRECATED? No, 
unfortunately is doesn't.

Thanks
Guennadi

> 
> ---
>  drivers/base/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -780,7 +780,7 @@ int device_add(struct device *dev)
>  	dev = get_device(dev);
>  	if (!dev || !strlen(dev->bus_id)) {
>  		error = -EINVAL;
> -		goto Error;
> +		goto Done;
>  	}
>  
>  	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
> 

---
Guennadi Liakhovetski
