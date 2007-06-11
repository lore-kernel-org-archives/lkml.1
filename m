Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbXFKNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbXFKNt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXFKNtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:49:49 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:51742 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFKNts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:49:48 -0400
To: adobriyan@gmail.com
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
In-reply-to: <20070610190952.GA5708@martell.zuzino.mipt.ru> (message from
	Alexey Dobriyan on Sun, 10 Jun 2007 23:09:52 +0400)
Subject: Re: [PATCH] fuse: ->fs_flags fixlet
References: <20070610190952.GA5708@martell.zuzino.mipt.ru>
Message-Id: <E1HxkGp-0006eY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 Jun 2007 15:49:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> fs/fuse/inode.c:658:3: error: Initializer entry defined twice
> fs/fuse/inode.c:661:3:   also defined here

Duh, that's a stupid conflict.  I wonder why I don't get this compile
error...

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

Andrew, please send this for 2.6.22.

There's another one, which is -mm only.  I'll post a patch.

Thanks,
Miklos

> ---
> 
>  fs/fuse/inode.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -655,10 +655,9 @@ static int fuse_get_sb_blk(struct file_system_type *fs_type,
>  static struct file_system_type fuseblk_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "fuseblk",
> -	.fs_flags	= FS_HAS_SUBTYPE,
>  	.get_sb		= fuse_get_sb_blk,
>  	.kill_sb	= kill_block_super,
> -	.fs_flags	= FS_REQUIRES_DEV,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
>  };
>  
>  static inline int register_fuseblk(void)
> 
