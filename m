Return-Path: <linux-kernel-owner+w=401wt.eu-S936978AbXHHR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936978AbXHHR6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbXHHR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:58:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50554 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXHHR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:58:16 -0400
Date: Wed, 8 Aug 2007 13:58:07 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Message-ID: <20070808175807.GA31221@filer.fsl.cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.922193525@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808171643.922193525@suse.de>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:16:26PM +0200, Andreas Gruenbacher wrote:
> Create a temporary struct vfs_lookup in file_permission() instead of
> passing a NULL value.
> 
> Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>
> 
> ---
>  fs/namei.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -292,14 +292,15 @@ int vfs_permission(struct vfs_lookup *lo
>   *
>   * Used to check for read/write/execute permissions on an already opened
>   * file.
> - *
> - * Note:
> - *	Do not use this function in new code.  All access checks should
> - *	be done using vfs_permission().

Should this comment be removed?

>   */
>  int file_permission(struct file *file, int mask)
>  {
> -	return permission(file->f_path.dentry->d_inode, mask, NULL);
> +	struct vfs_lookup lookup;
> +
> +	lookup.path = file->f_path;
> +	lookup.flags = 0;

I tend to find this little bit cleaner:

struct vfs_lookup lookup = {
	.path	= file->f_path,
	.flags	= 0,
};

> +
> +	return permission(file->f_path.dentry->d_inode, mask, &lookup);
>  }
>  
>  /*

-- 
Humans were created by water to transport it upward.
