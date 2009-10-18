Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZJRHQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZJRHQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 03:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZJRHQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 03:16:31 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54244 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJRHQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 03:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iU281l7JD5YCBpsBietS9OM6UVBlEjwPA3TglJqp6S3PvbE0LAPD1FJlNx/OA5aXrJ
         tUidDMcvGkObS70dH1nr4bZVyXuDpW7vx7E0ia2KVGL9mDL8mTK3DMbhsin2BFMe3gHt
         xSIN/TFBi10eMTHt+z+6SQ4BBT7zf4eBFTDDQ=
Date: Sun, 18 Oct 2009 00:16:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091018071630.GC3935@core.coreip.homeip.net>
References: <20091016211323.12126.58457.stgit@bob.kio> <20091016211459.12126.60739.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016211459.12126.60739.stgit@bob.kio>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Fri, Oct 16, 2009 at 03:14:59PM -0600, Alex Chiang wrote:
> As suggested by Dmitry Torokhov, convert the individual sysfs
> attributes into an attribute group.
> 
> This change eliminates quite a bit of copy/paste code in the
> error handling paths.
> 

Looks much better, one more suggestion though:

> +err_unregister:
> +	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);

If you want to print error this it should probably go down, right before
"return ret".

> +	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);

It begs another label right here. There are cases when yo0u already
registered the platform device but haven't added the sysfs group, right?

>  	platform_device_unregister(dock_device);
> +out:
>  	kfree(dock_station);
>  	dock_station = NULL;
>  	return ret;
> @@ -1076,11 +1046,7 @@ static int dock_remove(struct dock_station *dock_station)
>  	    kfree(dd);
>  
>  	/* cleanup sysfs */
> -	device_remove_file(&dock_device->dev, &dev_attr_type);
> -	device_remove_file(&dock_device->dev, &dev_attr_docked);
> -	device_remove_file(&dock_device->dev, &dev_attr_undock);
> -	device_remove_file(&dock_device->dev, &dev_attr_uid);
> -	device_remove_file(&dock_device->dev, &dev_attr_flags);
> +	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
>  	platform_device_unregister(dock_device);
>  
>  	/* free dock station memory */
> 

-- 
Dmitry
