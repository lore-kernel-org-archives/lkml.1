Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbZDQKlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbZDQKlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbZDQKlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:41:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:50142 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758309AbZDQKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:41:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18YKkpuR6EY2m2cm4gmM2/txSuBFB1LL8RkSKqWNO
	QLWQ5pgnA+iJl4
Date: Fri, 17 Apr 2009 12:41:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ming Lei <tom.leiming@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core:fix driver_match_device
In-Reply-To: <1238161800-4714-1-git-send-email-tom.leiming@gmail.com>
Message-ID: <Pine.LNX.4.64.0904171239540.5119@axis700.grange>
References: <1238161800-4714-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch fixes a bug introduced in commit
> 49b420a13ff95b449947181190b08367348e3e1b.
> 
> If a instance of bus_type doesn't have  .match method,
> all .probe of drivers in the bus should be called, or else
> the .probe have not a chance to be called.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

It looks like this patch is _still_ not in the mainline - now that we are 
past rc2... Unless the problem has been fixed differently (I haven't 
tested recent kernels), can we __please__ get it upstream?

Thanks
Guennadi

> ---
>  drivers/base/base.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index ddc9749..b528145 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -115,7 +115,7 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
>  static inline int driver_match_device(struct device_driver *drv,
>  				      struct device *dev)
>  {
> -	return drv->bus->match && drv->bus->match(dev, drv);
> +	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
>  }
>  
>  extern void sysdev_shutdown(void);
> -- 
> 1.6.0.GIT
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
