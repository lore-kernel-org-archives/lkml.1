Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYB0WhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYB0WhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYB0WhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:37:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43584 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYB0WhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:37:06 -0500
Date: Wed, 27 Feb 2008 14:36:30 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] fs/configfs/ cleanups
Message-ID: <20080227223629.GA19656@mail.oracle.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org
References: <20080227212048.GM29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227212048.GM29269@cs181133002.pp.htv.fi>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:20:48PM +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the needlessly global file.c:configfs_add_file() static
> - #if 0 the unused inode.c:configfs_hash_and_remove()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

I'd also take a patch to remove configfs_hash_and_remove().

Joel

> 
> ---
> 
> This patch has been sent on:
> - 17 Feb 2008
> 
>  fs/configfs/configfs_internal.h |    3 ---
>  fs/configfs/file.c              |    3 ++-
>  fs/configfs/inode.c             |    2 ++
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> 651b7a33c0dce1790230fe8ba9b7445cd69c8bde diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
> index cca9860..378fa36 100644
> --- a/fs/configfs/configfs_internal.h
> +++ b/fs/configfs/configfs_internal.h
> @@ -63,9 +63,6 @@ extern int configfs_create_file(struct config_item *, const struct configfs_attr
>  extern int configfs_make_dirent(struct configfs_dirent *,
>  				struct dentry *, void *, umode_t, int);
>  
> -extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
> -extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
> -
>  extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
>  extern void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent);
>  extern int configfs_setattr(struct dentry *dentry, struct iattr *iattr);
> diff --git a/fs/configfs/file.c b/fs/configfs/file.c
> index 397cb50..f331a40 100644
> --- a/fs/configfs/file.c
> +++ b/fs/configfs/file.c
> @@ -314,7 +314,8 @@ const struct file_operations configfs_file_operations = {
>  };
>  
>  
> -int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type)
> +static int configfs_add_file(struct dentry * dir,
> +			     const struct configfs_attribute * attr, int type)
>  {
>  	struct configfs_dirent * parent_sd = dir->d_fsdata;
>  	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
> diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
> index 4c1ebff..dccff59 100644
> --- a/fs/configfs/inode.c
> +++ b/fs/configfs/inode.c
> @@ -233,6 +233,7 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
>  	}
>  }
>  
> +#if 0
>  void configfs_hash_and_remove(struct dentry * dir, const char * name)
>  {
>  	struct configfs_dirent * sd;
> @@ -255,6 +256,7 @@ void configfs_hash_and_remove(struct dentry * dir, const char * name)
>  	}
>  	mutex_unlock(&dir->d_inode->i_mutex);
>  }
> +#endif  /*  0  */
>  
>  int __init configfs_inode_init(void)
>  {
> 

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
