Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbXLQQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbXLQQEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbXLQQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:04:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54072 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbXLQQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:04:46 -0500
Date: Mon, 17 Dec 2007 17:04:44 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/6] udf: remove wrong prototype of udf_readdir
Message-ID: <20071217160444.GD6979@atrey.karlin.mff.cuni.cz>
References: <20071216020630.GB26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216020630.GB26986@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sparse generated:
> fs/udf/dir.c:78:5: warning: symbol 'udf_readdir' was not declared. Should it be static?
> there are 2 different prototypes of udf_readdir - remove them and move
> code around to make it still compile
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
  Acked-by: Jan Kara <jack@suse.cz>

> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> ---
>  fs/udf/dir.c |  118 +++++++++++++++++++++++++++------------------------------
>  1 files changed, 56 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index 9e3b9f9..174d2fc 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -36,68 +36,8 @@
>  #include "udf_i.h"
>  #include "udf_sb.h"
> 
> -/* Prototypes for file operations */
> -static int udf_readdir(struct file *, void *, filldir_t);
> -static int do_udf_readdir(struct inode *, struct file *, filldir_t, void *);
> -
> -/* readdir and lookup functions */
> -
> -const struct file_operations udf_dir_operations = {
> -	.read			= generic_read_dir,
> -	.readdir		= udf_readdir,
> -	.ioctl			= udf_ioctl,
> -	.fsync			= udf_fsync_file,
> -};
> -
> -/*
> - * udf_readdir
> - *
> - * PURPOSE
> - *	Read a directory entry.
> - *
> - * DESCRIPTION
> - *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
> - *	available.
> - *
> - *	Refer to sys_getdents() in fs/readdir.c
> - *	sys_getdents() -> .
> - *
> - * PRE-CONDITIONS
> - *	filp			Pointer to directory file.
> - *	buf			Pointer to directory entry buffer.
> - *	filldir			Pointer to filldir function.
> - *
> - * POST-CONDITIONS
> - *	<return>		>=0 on success.
> - *
> - * HISTORY
> - *	July 1, 1997 - Andrew E. Mileski
> - *	Written, tested, and released.
> - */
> -
> -int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
> -{
> -	struct inode *dir = filp->f_path.dentry->d_inode;
> -	int result;
> -
> -	lock_kernel();
> -
> -	if (filp->f_pos == 0) {
> -		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
> -			unlock_kernel();
> -			return 0;
> -		}
> -		filp->f_pos++;
> -	}
> -
> -	result = do_udf_readdir(dir, filp, filldir, dirent);
> -	unlock_kernel();
> - 	return result;
> -}
> -
> -static int
> -do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,
> -	       void *dirent)
> +static int do_udf_readdir(struct inode *dir, struct file *filp,
> +			  filldir_t filldir, void *dirent)
>  {
>  	struct udf_fileident_bh fibh;
>  	struct fileIdentDesc *fi = NULL;
> @@ -244,3 +184,57 @@ do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,
> 
>  	return 0;
>  }
> +
> +/*
> + * udf_readdir
> + *
> + * PURPOSE
> + *	Read a directory entry.
> + *
> + * DESCRIPTION
> + *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
> + *	available.
> + *
> + *	Refer to sys_getdents() in fs/readdir.c
> + *	sys_getdents() -> .
> + *
> + * PRE-CONDITIONS
> + *	filp			Pointer to directory file.
> + *	buf			Pointer to directory entry buffer.
> + *	filldir			Pointer to filldir function.
> + *
> + * POST-CONDITIONS
> + *	<return>		>=0 on success.
> + *
> + * HISTORY
> + *	July 1, 1997 - Andrew E. Mileski
> + *	Written, tested, and released.
> + */
> +
> +static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct inode *dir = filp->f_path.dentry->d_inode;
> +	int result;
> +
> +	lock_kernel();
> +
> +	if (filp->f_pos == 0) {
> +		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
> +			unlock_kernel();
> +			return 0;
> +		}
> +		filp->f_pos++;
> +	}
> +
> +	result = do_udf_readdir(dir, filp, filldir, dirent);
> +	unlock_kernel();
> + 	return result;
> +}
> +
> +/* readdir and lookup functions */
> +const struct file_operations udf_dir_operations = {
> +	.read			= generic_read_dir,
> +	.readdir		= udf_readdir,
> +	.ioctl			= udf_ioctl,
> +	.fsync			= udf_fsync_file,
> +};
> --
> 1.5.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
