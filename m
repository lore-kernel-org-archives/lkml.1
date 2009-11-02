Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZKBKjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZKBKjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZKBKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:39:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZKBKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:39:44 -0500
Message-ID: <4AEEB88E.6000008@suse.de>
Date: Mon, 02 Nov 2009 18:46:38 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 20/27] BKL: Remove BKL from minix
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-21-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-21-git-send-email-jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Coly Li <coly.li@suse.de>

On 2009年11月02日 18:05, Jan Blunck Wrote:
> BKL is only used in fill_super. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/minix/inode.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index b8aa0a6..74ea82d 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -147,13 +147,9 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
>  	struct minix_sb_info *sbi;
>  	int ret = -EINVAL;
>  
> -	lock_kernel();
> -
>  	sbi = kzalloc(sizeof(struct minix_sb_info), GFP_KERNEL);
> -	if (!sbi) {
> -		unlock_kernel();
> +	if (!sbi)
>  		return -ENOMEM;
> -	}
>  	s->s_fs_info = sbi;
>  
>  	BUILD_BUG_ON(32 != sizeof (struct minix_inode));
> @@ -269,7 +265,6 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
>   	else if (sbi->s_mount_state & MINIX_ERROR_FS)
>  		printk("MINIX-fs: mounting file system with errors, "
>  			"running fsck is recommended\n");
> -	unlock_kernel();
>  	return 0;
>  
>  out_iput:
> @@ -319,7 +314,6 @@ out_bad_sb:
>  out:
>  	s->s_fs_info = NULL;
>  	kfree(sbi);
> -	unlock_kernel();
>  	return ret;
>  }
>  

-- 
Coly Li
SuSE Labs
