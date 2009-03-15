Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZCOMNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZCOMNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 08:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZCOMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 08:13:42 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37377 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZCOMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 08:13:42 -0400
Date: Sun, 15 Mar 2009 13:13:36 +0100
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/base/platform.c: Add platform_get_irq_flags()
Message-ID: <20090315121336.GD27915@buzzloop.caiaq.de>
References: <1236954582-10143-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236954582-10143-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 03:29:42PM +0100, Daniel Mack wrote:
> For drivers using platform_get_irq(), a function to get the irq flags
> supplied by the platform_device definition would be helpful. This patch
> adds it.

Any oppinion on that? Sorry I didn't Cc: anyone on that post, but I
couldn't figure out who's specifically in charge of maintaining that
code.

Daniel


> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> ---
>  drivers/base/platform.c         |   13 +++++++++++++
>  include/linux/platform_device.h |    1 +
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 349a101..3d6a9f4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -63,6 +63,19 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>  EXPORT_SYMBOL_GPL(platform_get_irq);
>  
>  /**
> + * platform_get_irq_flags - get flags of an IRQ for a device
> + * @dev: platform device
> + * @num: IRQ number index
> + */
> +int platform_get_irq_flags(struct platform_device *dev, unsigned int num)
> +{
> +	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> +
> +	return r ? r->flags : -ENXIO;
> +}
> +EXPORT_SYMBOL_GPL(platform_get_irq_flags);
> +
> +/**
>   * platform_get_resource_byname - get a resource for a device by name
>   * @dev: platform device
>   * @type: resource type
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 9a34269..a2c6c2c 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -31,6 +31,7 @@ extern struct device platform_bus;
>  
>  extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
>  extern int platform_get_irq(struct platform_device *, unsigned int);
> +extern int platform_get_irq_flags(struct platform_device *, unsigned int);
>  extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, char *);
>  extern int platform_get_irq_byname(struct platform_device *, char *);
>  extern int platform_add_devices(struct platform_device **, int);
> -- 
> 1.6.2
