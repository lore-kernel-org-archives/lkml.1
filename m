Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZFXLtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZFXLtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZFXLs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:48:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZFXLsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:48:55 -0400
Date: Wed, 24 Jun 2009 13:48:56 +0200
From: Jan Kara <jack@suse.cz>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] udf: remove redundant tests on unsigned
Message-ID: <20090624114856.GA2303@duck.suse.cz>
References: <4A3FF3BD.1040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FF3BD.1040702@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-06-09 23:12:29, Roel Kluin wrote:
> first_block and goal are unsigned. When negative they are wrapped and caught by
> the other test.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
  Thanks for the patch. I've merged it in UDF tree.

									Honza

> ---
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index e48e9a3..1e06853 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -238,7 +238,7 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
>  
>  	mutex_lock(&sbi->s_alloc_mutex);
>  	part_len = sbi->s_partmaps[partition].s_partition_len;
> -	if (first_block < 0 || first_block >= part_len)
> +	if (first_block >= part_len)
>  		goto out;
>  
>  	if (first_block + block_count > part_len)
> @@ -297,7 +297,7 @@ static int udf_bitmap_new_block(struct super_block *sb,
>  	mutex_lock(&sbi->s_alloc_mutex);
>  
>  repeat:
> -	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
> +	if (goal >= sbi->s_partmaps[partition].s_partition_len)
>  		goal = 0;
>  
>  	nr_groups = bitmap->s_nr_groups;
> @@ -666,8 +666,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
>  	int8_t etype = -1;
>  	struct udf_inode_info *iinfo;
>  
> -	if (first_block < 0 ||
> -		first_block >= sbi->s_partmaps[partition].s_partition_len)
> +	if (first_block >= sbi->s_partmaps[partition].s_partition_len)
>  		return 0;
>  
>  	iinfo = UDF_I(table);
> @@ -743,7 +742,7 @@ static int udf_table_new_block(struct super_block *sb,
>  		return newblock;
>  
>  	mutex_lock(&sbi->s_alloc_mutex);
> -	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
> +	if (goal >= sbi->s_partmaps[partition].s_partition_len)
>  		goal = 0;
>  
>  	/* We search for the closest matching block to goal. If we find
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
