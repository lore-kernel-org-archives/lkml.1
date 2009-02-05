Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbZBEBI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbZBEBI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbZBEBHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:07:42 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40140 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbZBEBHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:07:41 -0500
Date: Wed, 4 Feb 2009 19:07:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       sukadev@us.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 4/5] Remove get_init_pts_sb()
Message-ID: <20090205010739.GA18792@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043752.GD26202@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043752.GD26202@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 18:59:28 -0800
> Subject: [v2][PATCH 4/5] Remove get_init_pts_sb()
> 
> With mknod_ptmx() moved to devpts_get_sb(), init_pts_mount() becomes
> a wrapper around get_init_pts_sb(). Remove get_init_pts_sb() and
> fold code into init_pts_mount().
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/devpts/inode.c |   25 ++++++-------------------
>  1 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index f7e887c..c821c9a 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -347,7 +347,11 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
>  }
> 
>  /*
> - * get_init_pts_sb()
> + * init_pts_mount()
> + *
> + *     Mount or remount the initial kernel mount of devpts. This type of
> + *     mount maintains the legacy, single-instance semantics, while the
> + *     kernel still allows multiple-instances.
>   *
>   *     This interface is needed to support multiple namespace semantics in
>   *     devpts while preserving backward compatibility of the current 'single-
> @@ -367,7 +371,7 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
>   *     consistently selects the 'single-namespace' superblock even in the
>   *     presence of the private namespace (i.e 'newinstance') super-blocks.
>   */
> -static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
> +static int init_pts_mount(struct file_system_type *fs_type, int flags,
>  		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
>  {
>  	struct super_block *s;
> @@ -397,23 +401,6 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
>  	return 0;
>  }
> 
> -/*
> - * Mount or remount the initial kernel mount of devpts. This type of
> - * mount maintains the legacy, single-instance semantics, while the
> - * kernel still allows multiple-instances.
> - */
> -static int init_pts_mount(struct file_system_type *fs_type, int flags,
> -		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
> -{
> -	int err;
> -
> -	err = get_init_pts_sb(fs_type, flags, data, opts, mnt);
> -	if (err)
> -		return err;
> -
> -	return err;
> -}
> -
>  static int devpts_get_sb(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -- 
> 1.5.2.5
