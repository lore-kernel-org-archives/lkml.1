Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYAJXbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYAJXbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYAJXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:30:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:49008 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760050AbYAJXaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:30:52 -0500
Date: Fri, 11 Jan 2008 00:30:51 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/16] udf: improve readability of udf_load_partition
Message-ID: <20080110233051.GI17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-17-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-17-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:32, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Jan Kara <jack@suse.cz>
> CC: Christoph Hellwig <hch@infradead.org>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
>  fs/udf/super.c |   59 ++++++++++++++++++++++++++++---------------------------
>  1 files changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 52d2c32..2048351 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1447,44 +1447,45 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  	sbi = UDF_SB(sb);
>  
>  	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
> -		if (sbi->s_anchor[i] &&
> -		    (bh = udf_read_tagged(sb, sbi->s_anchor[i],
> -					  sbi->s_anchor[i], &ident))) {
> -			anchor = (struct anchorVolDescPtr *)bh->b_data;
> -
> -			/* Locate the main sequence */
> -			main_s = le32_to_cpu(
> -					anchor->mainVolDescSeqExt.extLocation);
> -			main_e = le32_to_cpu(
> -					anchor->mainVolDescSeqExt.extLength);
> -			main_e = main_e >> sb->s_blocksize_bits;
> -			main_e += main_s;
> -
> -			/* Locate the reserve sequence */
> -			reserve_s = le32_to_cpu(
> +		if (!sbi->s_anchor[i])
> +			continue;
> +		bh = udf_read_tagged(sb, sbi->s_anchor[i], sbi->s_anchor[i],
> +				     &ident);
> +		if (!bh)
> +			continue;
> +
> +		anchor = (struct anchorVolDescPtr *)bh->b_data;
> +
> +		/* Locate the main sequence */
> +		main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
> +		main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
> +		main_e = main_e >> sb->s_blocksize_bits;
> +		main_e += main_s;
> +
> +		/* Locate the reserve sequence */
> +		reserve_s = le32_to_cpu(
>  				anchor->reserveVolDescSeqExt.extLocation);
> -			reserve_e = le32_to_cpu(
> +		reserve_e = le32_to_cpu(
>  				anchor->reserveVolDescSeqExt.extLength);
> -			reserve_e = reserve_e >> sb->s_blocksize_bits;
> -			reserve_e += reserve_s;
> +		reserve_e = reserve_e >> sb->s_blocksize_bits;
> +		reserve_e += reserve_s;
>  
> -			brelse(bh);
> +		brelse(bh);
>  
> -			/* Process the main & reserve sequences */
> -			/* responsible for finding the PartitionDesc(s) */
> -			if (!(udf_process_sequence(sb, main_s, main_e,
> -						   fileset) &&
> -			      udf_process_sequence(sb, reserve_s, reserve_e,
> -						   fileset)))
> -				break;
> -		}
> +		/* Process the main & reserve sequences */
> +		/* responsible for finding the PartitionDesc(s) */
> +		if (!(udf_process_sequence(sb, main_s, main_e,
> +					   fileset) &&
> +		      udf_process_sequence(sb, reserve_s, reserve_e,
> +					   fileset)))
> +			break;
>  	}
>  
>  	if (i == ARRAY_SIZE(sbi->s_anchor)) {
>  		udf_debug("No Anchor block found\n");
>  		return 1;
> -	} else
> -		udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
> +	}
> +	udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
>  
>  	for (i = 0; i < sbi->s_partitions; i++) {
>  		kernel_lb_addr uninitialized_var(ino);
> -- 
> 1.5.3.7
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
