Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZKBKj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZKBKj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZKBKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:39:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:48671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZKBKj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:39:27 -0500
Message-ID: <4AEEB87C.8060106@suse.de>
Date: Mon, 02 Nov 2009 18:46:20 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David VomLehn <dvomlehn@cisco.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 14/27] BKL: Remove BKL from cramfs
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-15-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-15-git-send-email-jblunck@suse.de>
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
>  fs/cramfs/inode.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index 13e696a..dd3634e 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -227,15 +227,11 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
>  	struct cramfs_sb_info *sbi;
>  	struct inode *root;
>  
> -	lock_kernel();
> -
>  	sb->s_flags |= MS_RDONLY;
>  
>  	sbi = kzalloc(sizeof(struct cramfs_sb_info), GFP_KERNEL);
> -	if (!sbi) {
> -		unlock_kernel();
> +	if (!sbi)
>  		return -ENOMEM;
> -	}
>  	sb->s_fs_info = sbi;
>  
>  	/* Invalidate the read buffers on mount: think disk change.. */
> @@ -312,12 +308,10 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
>  		iput(root);
>  		goto out;
>  	}
> -	unlock_kernel();
>  	return 0;
>  out:
>  	kfree(sbi);
>  	sb->s_fs_info = NULL;
> -	unlock_kernel();
>  	return -EINVAL;
>  }
>  

-- 
Coly Li
SuSE Labs
