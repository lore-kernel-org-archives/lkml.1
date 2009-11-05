Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZKELzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZKELzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZKELzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:55:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:56508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZKELzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:55:37 -0500
Date: Thu, 5 Nov 2009 12:55:39 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
       Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 06/27] BKL: Remove BKL from ext3 fill_super()
Message-ID: <20091105115539.GA12770@duck.suse.cz>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-7-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257156307-24175-7-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 02-11-09 11:04:46, Jan Blunck wrote:
> The BKL is protecting nothing than two memory allocations here.
  The patch looks good.
Acked-by: Jan Kara <jack@suse.cz>
  Should I merge it or will you do it with other patches?

									Honza
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/ext3/super.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 38261a5..4b635b7 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1568,19 +1568,14 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	__le32 features;
>  	int err;
>  
> -	lock_kernel();
> -
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
> -	if (!sbi) {
> -		unlock_kernel();
> +	if (!sbi)
>  		return -ENOMEM;
> -	}
>  
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
>  	if (!sbi->s_blockgroup_lock) {
>  		kfree(sbi);
> -		unlock_kernel();
>  		return -ENOMEM;
>  	}
>  	sb->s_fs_info = sbi;
> @@ -1589,8 +1584,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	sbi->s_resgid = EXT3_DEF_RESGID;
>  	sbi->s_sb_block = sb_block;
>  
> -	unlock_kernel();
> -
>  	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
>  	if (!blocksize) {
>  		printk(KERN_ERR "EXT3-fs: unable to set blocksize\n");
> @@ -1996,8 +1989,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
>  		"writeback");
>  
> -	lock_kernel();
> -	unlock_kernel();
>  	return 0;
>  
>  cantfind_ext3:
> @@ -2027,8 +2018,6 @@ out_fail:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> -	lock_kernel();
> -	unlock_kernel();
>  	return ret;
>  }
>  
> -- 
> 1.6.4.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
