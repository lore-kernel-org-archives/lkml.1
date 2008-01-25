Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYAYOnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYAYOnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYAYOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:42:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44847 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYAYOm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:42:57 -0500
Date: Fri, 25 Jan 2008 15:42:56 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 18/26] mount options: fix isofs
Message-ID: <20080125144256.GC28856@atrey.karlin.mff.cuni.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193443.306296794@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193443.306296794@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a .show_options super operation to isofs.
> 
> Use generic_show_options() and save the complete option string in
> isofs_fill_super().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/isofs/inode.c
> ===================================================================
> --- linux.orig/fs/isofs/inode.c	2008-01-17 19:00:55.000000000 +0100
> +++ linux/fs/isofs/inode.c	2008-01-23 22:07:51.000000000 +0100
> @@ -110,6 +110,7 @@ static const struct super_operations iso
>  	.put_super	= isofs_put_super,
>  	.statfs		= isofs_statfs,
>  	.remount_fs	= isofs_remount,
> +	.show_options	= generic_show_options,
>  };
>  
>  
> @@ -554,6 +555,8 @@ static int isofs_fill_super(struct super
>  	int table, error = -EINVAL;
>  	unsigned int vol_desc_start;
>  
> +	save_mount_options(s, data);
> +
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		return -ENOMEM;
  Looks, fine.
  Acked-by: Jan Kara <jack@suse.cz>

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
