Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZA1OuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZA1OuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZA1OuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:50:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58933 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZA1OuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:50:09 -0500
Date: Wed, 28 Jan 2009 14:49:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
Message-ID: <20090128144955.GA23089@n2100.arm.linux.org.uk>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com> <20090116082727.17571.87307.stgit@oreo.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116082727.17571.87307.stgit@oreo.research.nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:27:27AM +0200, Hiroshi DOYU wrote:
> @@ -17,6 +17,8 @@
>  #include <mach/mailbox.h>
>  #include <mach/irqs.h>
>  
> +#define DRV_NAME "omap1-mailbox"

I don't see any need for this define - it just adds an additional level of
indirection when trying to find out the name of the driver.  It's only
used in two places as is, so it's value is rather limited:

> @@ -184,9 +184,9 @@ static int omap1_mbox_remove(struct platform_device *pdev)
>  
>  static struct platform_driver omap1_mbox_driver = {
>  	.probe	= omap1_mbox_probe,
> -	.remove	= omap1_mbox_remove,
> +	.remove	= __devexit_p(omap1_mbox_remove),
>  	.driver	= {
> -		.name	= "mailbox",
> +		.name	= DRV_NAME,
>  	},
>  };
>  
> @@ -203,4 +203,7 @@ static void __exit omap1_mbox_exit(void)
>  module_init(omap1_mbox_init);
>  module_exit(omap1_mbox_exit);
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
> +MODULE_AUTHOR("Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>);
> +MODULE_ALIAS("platform:"DRV_NAME);
