Return-Path: <linux-kernel-owner+w=401wt.eu-S972995AbXHMN1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972995AbXHMN1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbXHMJYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:24:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18295 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936609AbXHMJYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:24:38 -0400
Date: Mon, 13 Aug 2007 13:25:13 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] ext3: fix ext34_fill_super group description
	initialization
Message-ID: <20070813092512.GB25226@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	devel@openvz.org
References: <20070813090954.GA25226@dnb.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813090954.GA25226@dnb.sw.ru>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:09 Mon 13 Aug     , Dmitry Monakhov wrote:
> ->s_group_desc have to be zero filled because if sb_read() failed
> we jump to following error path.
> failed_mount2:
> 	for (i = 0; i < db_count; i++)
> 		brelse(sbi->s_group_desc[i]);<< Bad things may happen here
OOPs i'm sorry. I've lost db_count changing after sb_read() error,
so error path is ok, and this patch is not needed.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/super.c |    2 +-
>  fs/ext4/super.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index f8ac18f..208738e 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1718,7 +1718,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  				       / EXT3_BLOCKS_PER_GROUP(sb)) + 1;
>  	db_count = (sbi->s_groups_count + EXT3_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT3_DESC_PER_BLOCK(sb);
> -	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
> +	sbi->s_group_desc = kzalloc(db_count * sizeof (struct buffer_head *),
>  				    GFP_KERNEL);
>  	if (sbi->s_group_desc == NULL) {
>  		printk (KERN_ERR "EXT3-fs: not enough memory\n");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8f1d2f6..fefffc0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1830,7 +1830,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>  	sbi->s_groups_count = blocks_count;
>  	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT4_DESC_PER_BLOCK(sb);
> -	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
> +	sbi->s_group_desc = kzalloc(db_count * sizeof (struct buffer_head *),
>  				    GFP_KERNEL);
>  	if (sbi->s_group_desc == NULL) {
>  		printk (KERN_ERR "EXT4-fs: not enough memory\n");
> -- 
> 1.5.2.2
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

