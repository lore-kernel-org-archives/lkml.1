Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZKBKkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZKBKkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZKBKkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:40:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:48691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbZKBKkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:40:03 -0500
Message-ID: <4AEEB8A4.8000700@suse.de>
Date: Mon, 02 Nov 2009 18:47:00 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 16/27] BKL: Remove BKL from efs
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-17-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-17-git-send-email-jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Coly Li <coly.li@suse.de>

On 2009年11月02日 18:04, Jan Blunck Wrote:
> BKL is only used in fill_super. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/efs/super.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/efs/super.c b/fs/efs/super.c
> index 0981141..f049428 100644
> --- a/fs/efs/super.c
> +++ b/fs/efs/super.c
> @@ -249,13 +249,9 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
>  	struct inode *root;
>  	int ret = -EINVAL;
>  
> -	lock_kernel();
> -
> -	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
> -	if (!sb) {
> -		unlock_kernel();
> + 	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
> +	if (!sb)
>  		return -ENOMEM;
> -	}
>  	s->s_fs_info = sb;
>   
>  	s->s_magic		= EFS_SUPER_MAGIC;
> @@ -323,14 +319,12 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
>  		goto out_no_fs;
>  	}
>  
> -	unlock_kernel();
>  	return 0;
>  
>  out_no_fs_ul:
>  out_no_fs:
>  	s->s_fs_info = NULL;
>  	kfree(sb);
> -	unlock_kernel();
>  	return ret;
>  }
>  

-- 
Coly Li
SuSE Labs
