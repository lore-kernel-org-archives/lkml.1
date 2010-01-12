Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245Ab0ALRey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0ALRey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135Ab0ALRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:34:53 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50576 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0ALRew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:34:52 -0500
Date: Tue, 12 Jan 2010 11:34:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 5/7] driver core: Use sysfs_rename_link in device_rename
Message-ID: <20100112173449.GB13506@us.ibm.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
 <1263241315-19499-5-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263241315-19499-5-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Don't open code the renaming of symlinks in sysfs
> instead use the new helper function sysfs_rename_link
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  drivers/base/core.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 2820257..ba66394 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1574,22 +1574,16 @@ int device_rename(struct device *dev, char *new_name)
>  	if (old_class_name) {
>  		new_class_name = make_class_name(dev->class->name, &dev->kobj);
>  		if (new_class_name) {
> -			error = sysfs_create_link_nowarn(&dev->parent->kobj,
> -							 &dev->kobj,
> -							 new_class_name);
> -			if (error)
> -				goto out;
> -			sysfs_remove_link(&dev->parent->kobj, old_class_name);
> +			error = sysfs_rename_link(&dev->parent->kobj,
> +						  &dev->kobj,
> +						  old_class_name,
> +						  new_class_name);
>  		}
>  	}
>  #else
>  	if (dev->class) {
> -		error = sysfs_create_link_nowarn(&dev->class->p->class_subsys.kobj,
> -						 &dev->kobj, dev_name(dev));
> -		if (error)
> -			goto out;
> -		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
> -				  old_device_name);
> +		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
> +					  &dev->kobj, old_device_name, new_name);
>  	}
>  #endif
> 
> -- 
> 1.6.5.2.143.g8cc62
