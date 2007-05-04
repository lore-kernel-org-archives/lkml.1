Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXEDHCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXEDHCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXEDHCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:02:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXEDHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:02:46 -0400
Date: Fri, 4 May 2007 00:02:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Sipek <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, Trond.Myklebust@netapp.com,
       mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/1] fs: add 4th case to do_path_lookup
Message-Id: <20070504000200.d14bd8d9.akpm@linux-foundation.org>
In-Reply-To: <20070430033012.GB32047@filer.fsl.cs.sunysb.edu>
References: <20070430032624.GA32047@filer.fsl.cs.sunysb.edu>
	<20070430033012.GB32047@filer.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 23:30:12 -0400 Josef Sipek <jsipek@cs.sunysb.edu> wrote:

> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 2995fba..1516a9b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1125,6 +1125,10 @@ static int fastcall do_path_lookup(int dfd, const char *name,
>  		nd->mnt = mntget(fs->rootmnt);
>  		nd->dentry = dget(fs->root);
>  		read_unlock(&fs->lock);
> +	} else if (flags & LOOKUP_ONE) {
> +		/* nd->mnt and nd->dentry already set, just grab references */
> +		mntget(nd->mnt);
> +		dget(nd->dentry);
>  	} else if (dfd == AT_FDCWD) {
>  		read_lock(&fs->lock);
>  		nd->mnt = mntget(fs->pwdmnt);
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 92b422b..aa89d97 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -48,6 +48,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>   *  - internal "there are more path compnents" flag
>   *  - locked when lookup done with dcache_lock held
>   *  - dentry cache is untrusted; force a real lookup
> + *  - lookup path from given dentry/vfsmount pair
>   */
>  #define LOOKUP_FOLLOW		 1
>  #define LOOKUP_DIRECTORY	 2
> @@ -55,6 +56,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>  #define LOOKUP_PARENT		16
>  #define LOOKUP_NOALT		32
>  #define LOOKUP_REVAL		64
> +#define LOOKUP_ONE	       128

Well the patch passes my too-small-to-care-about test ;)

Unless someone objects I'd suggest that you add it to the unionfs tree.
