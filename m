Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZI2XtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZI2XtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZI2XtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:49:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:37301 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZI2XtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:49:22 -0400
Date: Wed, 30 Sep 2009 09:48:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message
In-Reply-To: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0909300947572.20949@tundra.namei.org>
References: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Mimi Zohar wrote:

> The underlying files are measured. Update the counters to get rid of
> the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)

Which kernel(s) is this needed for?

> 
> Reported-by: Sachin Garg <ascii79@gmail.com>
> Cc: stable@kernel.org
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  fs/ecryptfs/main.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 9f0aa98..177e61e 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -35,6 +35,7 @@
>  #include <linux/key.h>
>  #include <linux/parser.h>
>  #include <linux/fs_stack.h>
> +#include <linux/ima.h>
>  #include "ecryptfs_kernel.h"
>  
>  /**
> @@ -135,7 +136,8 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
>  			rc = PTR_ERR(inode_info->lower_file);
>  			inode_info->lower_file = NULL;
> -		}
> +		} else
> +			ima_counts_get(inode_info->lower_file);
>  	}
>  	mutex_unlock(&inode_info->lower_file_mutex);
>  	return rc;
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
