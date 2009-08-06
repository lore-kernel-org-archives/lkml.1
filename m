Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZHFS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZHFS6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZHFS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:55 -0400
Received: from kroah.org ([198.145.64.141]:36187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbZHFS5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:53 -0400
Date: Thu, 6 Aug 2009 11:56:02 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC PATCH V2 1/2] introduce ALS sysfs class
Message-ID: <20090806185602.GC28664@kroah.com>
References: <1249547498.2670.499.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249547498.2670.499.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:31:38PM +0800, Zhang Rui wrote:
> +#define PREFIX "ALS: "

This is not used.

> +	/* sys I/F */
> +	result = device_create_file(&als->device, &dev_attr_illuminance);
> +	if (result)
> +		goto unregister_device;
> +
> +	result = device_create_file(&als->device, &dev_attr_desc);
> +	if (result)
> +		goto unregister_device;

These should be default attributes for the device, that way they get
created before userspace is told the device is there, removing any race
conditions you will have otherwise.

> +
> +	return als;
> +
> +unregister_device:
> +	device_unregister(&als->device);
> +	return ERR_PTR(result);

And you weren't cleaning up the file if the second one failed.

thanks,

greg k-h
