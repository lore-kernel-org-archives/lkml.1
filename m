Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZALBMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZALBMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZALBMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:12:34 -0500
Received: from mail.fieldses.org ([141.211.133.115]:45861 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZALBMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:12:33 -0500
Date: Sun, 11 Jan 2009 20:12:31 -0500
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFSD: cleanup for nfs3proc.c
Message-ID: <20090112011231.GA31971@fieldses.org>
References: <496a44f7.05636e0a.69b8.6278@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496a44f7.05636e0a.69b8.6278@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:13:53AM +0800, Qinghuang Feng wrote:
> MSDOS_SUPER_MAGIC is defined in <linux/magic.h>,
> so use MSDOS_SUPER_MAGIC directly.

Thanks.  But does anyone know if there's any better way to figure out
whether a filesystem supports links and symlinks than by checking
s_magic == MSDOS_SUPER_MAGIC??

--b.

> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
> index 9dbd2eb..579ce8c 100644
> --- a/fs/nfsd/nfs3proc.c
> +++ b/fs/nfsd/nfs3proc.c
> @@ -18,6 +18,7 @@
>  #include <linux/unistd.h>
>  #include <linux/slab.h>
>  #include <linux/major.h>
> +#include <linux/magic.h>
>  
>  #include <linux/sunrpc/svc.h>
>  #include <linux/nfsd/nfsd.h>
> @@ -569,7 +570,7 @@ nfsd3_proc_fsinfo(struct svc_rqst * rqstp, struct nfsd_fhandle    *argp,
>  		struct super_block *sb = argp->fh.fh_dentry->d_inode->i_sb;
>  
>  		/* Note that we don't care for remote fs's here */
> -		if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
> +		if (sb->s_magic == MSDOS_SUPER_MAGIC) {
>  			resp->f_properties = NFS3_FSF_BILLYBOY;
>  		}
>  		resp->f_maxfilesize = sb->s_maxbytes;
> @@ -610,7 +611,7 @@ nfsd3_proc_pathconf(struct svc_rqst * rqstp, struct nfsd_fhandle      *argp,
>  			resp->p_link_max = EXT2_LINK_MAX;
>  			resp->p_name_max = EXT2_NAME_LEN;
>  			break;
> -		case 0x4d44:	/* MSDOS_SUPER_MAGIC */
> +		case MSDOS_SUPER_MAGIC:
>  			resp->p_case_insensitive = 1;
>  			resp->p_case_preserving  = 0;
>  			break;
> 
