Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbXLLAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbXLLAmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbXLLAm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:42:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:51366 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbXLLAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:42:27 -0500
Date: Tue, 11 Dec 2007 16:40:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: michael@ellerman.id.au, Greg KH <greg@kroah.com>, linuxppc-dev@ozlabs.org,
       "Kyle A. Lucke" <klucke@us.ibm.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, David Gibson <dwg@au1.ibm.com>
Subject: Re: [PATCH] Introduce driver_create/remove_dir
Message-Id: <20071211164039.013f4393.randy.dunlap@oracle.com>
In-Reply-To: <20071212105633.725496cb.sfr@canb.auug.org.au>
References: <20071205093054.GA23229@kroah.com>
	<1196853031.6759.7.camel@concordia>
	<20071205214103.GA7074@kroah.com>
	<1196912898.14754.13.camel@concordia>
	<20071212105633.725496cb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 10:56:33 +1100 Stephen Rothwell wrote:

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/base/driver.c      |   24 ++++++++++++++++++++++++
>  drivers/net/iseries_veth.c |   15 +++++++--------
>  include/linux/device.h     |    3 +++
>  3 files changed, 34 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
> index eb11475..6527a91 100644
> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -91,6 +91,30 @@ struct device * driver_find_device(struct device_driver *drv,
>  EXPORT_SYMBOL_GPL(driver_find_device);
>  
>  /**
> + *	driver_create_dir - create a subdirectory for a driver.
> + *	@drv:	driver.
> + *	@kobj:	the kobject we are creating the directory for.
> + */
> +int __must_check driver_create_dir(struct device_driver *drv,
> +			struct kobject *kobj)
> +{
> +	kobj->parent = &drv->kobj;
> +	return kobject_add(kobj);
> +}
> +EXPORT_SYMBOL_GPL(driver_create_dir);
> +
> +/**
> + *	driver_remove_dir - remove a subdirectory for a driver.
> + *	@drv:	driver.
> + *	@attr:	driver attribute descriptor.

Second arg below is @kobj.


> + */
> +void driver_remove_dir(struct device_driver *drv, struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +}
> +EXPORT_SYMBOL_GPL(driver_remove_dir);
> +
> +/**
>   *	driver_create_file - create sysfs file for driver.
>   *	@drv:	driver.
>   *	@attr:	driver attribute descriptor.


---
~Randy
