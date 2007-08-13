Return-Path: <linux-kernel-owner+w=401wt.eu-S939871AbXHMPdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939871AbXHMPdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973180AbXHMNbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:31:06 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2818 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972243AbXHMNbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:31:02 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext3: fix ext34_fill_super group description initialization
Date: Mon, 13 Aug 2007 15:19:38 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, devel@openvz.org
References: <20070813090954.GA25226@dnb.sw.ru>
In-Reply-To: <20070813090954.GA25226@dnb.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131519.38289.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ->s_group_desc have to be zero filled because if sb_read() failed
> we jump to following error path.
> failed_mount2:
> 	for (i = 0; i < db_count; i++)
> 		brelse(sbi->s_group_desc[i]);<< Bad things may happen here
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
> @@ -1718,7 +1718,7 @@ static int ext3_fill_super (struct super_block *sb,
> void *data, int silent) / EXT3_BLOCKS_PER_GROUP(sb)) + 1;
>  	db_count = (sbi->s_groups_count + EXT3_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT3_DESC_PER_BLOCK(sb);
> -	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
> +	sbi->s_group_desc = kzalloc(db_count * sizeof (struct buffer_head *),
>  				    GFP_KERNEL);

kcalloc?

>  	if (sbi->s_group_desc == NULL) {
>  		printk (KERN_ERR "EXT3-fs: not enough memory\n");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8f1d2f6..fefffc0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1830,7 +1830,7 @@ static int ext4_fill_super (struct super_block *sb,
> void *data, int silent) sbi->s_groups_count = blocks_count;
>  	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT4_DESC_PER_BLOCK(sb);
> -	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
> +	sbi->s_group_desc = kzalloc(db_count * sizeof (struct buffer_head *),
>  				    GFP_KERNEL);

kcalloc?

>  	if (sbi->s_group_desc == NULL) {
>  		printk (KERN_ERR "EXT4-fs: not enough memory\n");

Regards,

	Mariusz
