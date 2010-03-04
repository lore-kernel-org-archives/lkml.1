Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0CDVBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:01:24 -0500
Received: from kroah.org ([198.145.64.141]:50261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab0CDVBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:01:23 -0500
Date: Thu, 4 Mar 2010 13:01:19 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in patch
Message-ID: <20100304210119.GA27873@kroah.com>
References: <Pine.LNX.4.44L0.1003041511070.1305-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003041511070.1305-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 03:22:22PM -0500, Alan Stern wrote:
> Greg:
> 
> In my copy of gregkh-all-2.6.33.patch (which is dated 2010-03-01), 
> there are changes to drivers/base/power/main.c, coming from the 
> gregkh-05-driver-core/driver-core-create-lock-unlock-functions-for-struct-device 
> patch.
> 
> The first weird thing is this.  That file as it currently exists on
> www.kernel.org (dated 2010-03-03) contains the following hunk (it's the
> last hunk for drivers/base/power/main.c):
> 
> @@ -962,7 +962,7 @@ static int device_prepare(struct device
>  		suspend_report_result(dev->class->pm->prepare, error);
>  	}
>   End:
> -	up(&dev->sem);
> +	device_unlock(dev);
>  
>  	return error;
>  }
> 
> But in my copy of gregkh-all-2.6.33.patch, the corresponding hunk is:
> 
> @@ -852,7 +852,7 @@
>  		suspend_report_result(dev->class->pm->prepare, error);
>  	}
>   End:
> -	up(&dev->sem);
> +	device_lock(dev);
>  
>  	return error;
>  }
> 
> The device_unlock() got changed to device_lock()!  That messed up my 
> suspend testing for a while...
> 
> Secondly, none of these changes is present in the 
> gregkh-all-2.6.33.patch file at www.kernel.org.  Isn't that supposed to 
> contain all the patches from the subsystems merged into one?
> 
> What's the story?

Odd, I don't know.  I changed my script to try to handle git ids instead
of -rc only type base versions, and I probably messed something up.  Let
me go verify that the above patch is still correct (I had to merge it by
hand...)

Yes, the original patch is correct, but somehow the -all patches are not
getting generated correctly.  I'll go look into what broke in my
scripts.  Sorry about that, and thanks for letting me know.

greg k-h
