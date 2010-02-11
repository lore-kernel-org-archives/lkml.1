Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0BKVjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:39:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:34757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab0BKVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:39:21 -0500
Date: Thu, 11 Feb 2010 13:36:51 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Message-ID: <20100211213651.GA29557@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:32:29PM +0000, Hank Janssen wrote:
> 
> Provide proper versioning information for all HV drivers.
> 
> 
> Cc: Greg Kroah-Hartman         <gregkh@suse.de>
> Signed-off-by: Hank Janssen    <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang   <haiyang@microsoft.com>
> 
> 
>  drivers/staging/hv/VersionInfo.h |   11 ++++++++---
>  drivers/staging/hv/Vmbus.c       |    8 ++++----
>  drivers/staging/hv/blkvsc_drv.c  |    2 ++
>  drivers/staging/hv/netvsc_drv.c  |    5 +++--
>  drivers/staging/hv/storvsc_drv.c |    2 ++
>  drivers/staging/hv/vmbus_drv.c   |    2 ++
>  6 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/hv/VersionInfo.h b/drivers/staging/hv/VersionInfo.h
> index 9c3641d..e729b9e 100644
> --- a/drivers/staging/hv/VersionInfo.h
> +++ b/drivers/staging/hv/VersionInfo.h
> @@ -24,8 +24,13 @@
>  #ifndef __HV_VERSION_INFO
>  #define __HV_VERSION_INFO
>  
> -static const char VersionDate[] = __DATE__;
> -static const char VersionTime[] = __TIME__;
> -static const char VersionDesc[] = "Version 2.0";
> +static const char hv_build_date[] = __DATE__;
> +static const char hv_build_time[] = __TIME__;

This should not be needed at all, as it make absolutely no sense.

> +/*
> + * We use the same version numbering for all Hyper-V modules.
> + */
> +#define HV_DRV_VERSION           "3.0.0"

Is this really needed?  Now that the code is in the kernel tree,
shouldn't you be tracking this based on kernel release version (like 90%
of the drivers are tracked), or is there some requirement for a version
number?

And what decides when this number is changed?  What does it "mean"?
What is it tracking?

thanks,

greg k-h
