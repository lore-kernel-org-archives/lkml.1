Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbYHUQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbYHUQBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYHUQBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:01:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:37033 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHUQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:01:40 -0400
Date: Thu, 21 Aug 2008 08:58:45 -0700
From: Greg KH <gregkh@suse.de>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix possible kobject reference counter leak in
	kobject_rename()
Message-ID: <20080821155845.GA2424@suse.de>
References: <48AD4414.6080604@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD4414.6080604@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 07:31:48PM +0900, Kenji Kaneshige wrote:
> Hi,
> 
> I found a possible kobject reference counter leak problem in
> kobject_rename(). The following patch will fix it.
> 
> Thanks,
> Kenji Kaneshige
> 
> 
> Fix possible kobject reference counter leak in kobject_rename().
> 
> If kobject_rename() failed because of name collision, we must call
> kobject_put() for specified kobject before return.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  lib/kobject.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.27-rc4/lib/kobject.c
> ===================================================================
> --- linux-2.6.27-rc4.orig/lib/kobject.c
> +++ linux-2.6.27-rc4/lib/kobject.c
> @@ -411,6 +411,7 @@ int kobject_rename(struct kobject *kobj,
>  			       "to '%s' as '%s' is already in existence.\n",
>  			       kobject_name(kobj), new_name, new_name);
>  			kobject_put(temp_kobj);
> +			kobject_put(kobj);
>  			return -EINVAL;
>  		}
>  	}

Thanks, but this is already fixed up with a patch from Eric in my tree
in a different way.

greg k-h
