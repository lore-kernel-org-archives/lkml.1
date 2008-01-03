Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYACG0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYACG0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 01:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYACG0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 01:26:41 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2426 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbYACG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 01:26:40 -0500
Subject: Re: [PATCH 1/3] Unionfs: use printk KERN_CONT for debugging
	messages
From: Joe Perches <joe@perches.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
In-Reply-To: <1199339862303-git-send-email-ezk@cs.sunysb.edu>
References: <11993398601-git-send-email-ezk@cs.sunysb.edu>
	 <1199339862303-git-send-email-ezk@cs.sunysb.edu>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 22:26:20 -0800
Message-Id: <1199341581.6615.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 00:57 -0500, Erez Zadok wrote:
> diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
> index c2b8b58..5f1d887 100644
> --- a/fs/unionfs/debug.c
> +++ b/fs/unionfs/debug.c
>  void __show_inode_times(const struct inode *inode,
> @@ -472,15 +473,15 @@ void __show_inode_times(const struct inode *inode,
>  		if (unlikely(!lower_inode))
>  			continue;
>  		pr_debug("IT(%lu:%d): ", inode->i_ino, bindex);
> -		pr_debug("%s:%s:%d ", file, fxn, line);
> -		pr_debug("um=%lu/%lu lm=%lu/%lu ",
> -			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
> -			 lower_inode->i_mtime.tv_sec,
> -			 lower_inode->i_mtime.tv_nsec);
> -		pr_debug("uc=%lu/%lu lc=%lu/%lu\n",
> -			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
> -			 lower_inode->i_ctime.tv_sec,
> -			 lower_inode->i_ctime.tv_nsec);
> +		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
> +		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
> +		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
> +		       lower_inode->i_mtime.tv_sec,
> +		       lower_inode->i_mtime.tv_nsec);
> +		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
> +		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
> +		       lower_inode->i_ctime.tv_sec,
> +		       lower_inode->i_ctime.tv_nsec);
>  	}
>  }
>  

I think printks should be single statements and
KERN_CONT should be used as sparingly as possible.

Perhaps:
		pr_debug("IT(%lu:%d): %s:%s:%d "
			 "um=%lu/%lu lm=%lu/%lu "
			 "uc=%lu/%lu lc=%lu/%lu\n",
			 inode->i_ino, bindex, file, fnx, line,
			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
			 lower_inode->i_mtime.tv_sec,
			 lower_inode->i_mtime.tv_nsec
			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
			 lower_inode->i_ctime.tv_sec,
			 lower_inode->i_ctime.tv_nsec);

> @@ -497,15 +498,15 @@ void __show_dinode_times(const struct dentry *dentry,
>  			continue;
>  		pr_debug("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino,
>  			 bindex);
> -		pr_debug("%s:%s:%d ", file, fxn, line);
> -		pr_debug("um=%lu/%lu lm=%lu/%lu ",
> -			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
> -			 lower_inode->i_mtime.tv_sec,
> -			 lower_inode->i_mtime.tv_nsec);
> -		pr_debug("uc=%lu/%lu lc=%lu/%lu\n",
> -			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
> -			 lower_inode->i_ctime.tv_sec,
> -			 lower_inode->i_ctime.tv_nsec);
> +		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
> +		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
> +		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
> +		       lower_inode->i_mtime.tv_sec,
> +		       lower_inode->i_mtime.tv_nsec);
> +		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
> +		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
> +		       lower_inode->i_ctime.tv_sec,
> +		       lower_inode->i_ctime.tv_nsec);
>  	}
>  }
>  

and
		pr_debug("DT(%s:%lu:%d): %s:%s:%d "
			 "um=%lu/%lu lm=%lu/%lu "
			 "uc=%lu/%lu lc=%lu/%lu\n",
			 dentry->d_name.name, inode->i_ino, bindex,
			 file, fnx, line,
			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
			 lower_inode->i_mtime.tv_sec,
			 lower_inode->i_mtime.tv_nsec
			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
			 lower_inode->i_ctime.tv_sec,
			 lower_inode->i_ctime.tv_nsec);

> 
> @@ -524,9 +525,10 @@ void __show_inode_counts(const struct inode *inode,
>  		lower_inode = unionfs_lower_inode_idx(inode, bindex);
>  		if (unlikely(!lower_inode))
>  			continue;
> -		pr_debug("SIC(%lu:%d:%d): ", inode->i_ino, bindex,
> -			 atomic_read(&(inode)->i_count));
> -		pr_debug("lc=%d ", atomic_read(&(lower_inode)->i_count));
> -		pr_debug("%s:%s:%d\n", file, fxn, line);
> +		printk(KERN_CONT "SIC(%lu:%d:%d): ", inode->i_ino, bindex,
> +		       atomic_read(&(inode)->i_count));
> +		printk(KERN_CONT "lc=%d ",
> +		       atomic_read(&(lower_inode)->i_count));
> +		printk(KERN_CONT "%s:%s:%d\n", file, fxn, line);
>  	}
>  }

and
		pr_debug("SIC(%lu:%d:%d): lc=%d %s:%s:%d\n",
			 inode->i_ino, bindex,
			 atomic_read(&(inode)->i_count),
			 atomic_read(&(lower_inode)->i_count),
			 file, fxn, line);

