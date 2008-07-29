Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYG2AG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYG2AG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYG2AGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:06:48 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39520 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYG2AGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:06:47 -0400
Date: Tue, 29 Jul 2008 02:06:43 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       dbaryshkov@gmail.com
Subject: Re: [patch 1/4] MFD: Use to_platform_device instead of container_of.
Message-ID: <20080729000642.GD6637@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080709104916.200210922@fluff.org> <20080709104932.475821512@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709104932.475821512@fluff.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:49:17AM +0100, Ben Dooks wrote:
> Convert mfd_remove_devices_fn() to use to_platform_device()
> instead of doing container_of().
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Applied to the MFD tree, thanks.

 
> Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c	2008-07-09 10:13:53.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c	2008-07-09 10:14:26.000000000 +0100
> @@ -99,8 +99,7 @@ EXPORT_SYMBOL(mfd_add_devices);
>  
>  static int mfd_remove_devices_fn(struct device *dev, void *unused)
>  {
> -	platform_device_unregister(
> -			container_of(dev, struct platform_device, dev));
> +	platform_device_unregister(to_platform_device(dev));
>  	return 0;
>  }
>  
> 
> -- 
