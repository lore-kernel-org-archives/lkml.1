Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbYBMJw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbYBMJw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYBMJwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:52:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:39554 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641AbYBMJwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:52:50 -0500
Date: Wed, 13 Feb 2008 10:52:49 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quota: le*_add_cpu conversion
Message-ID: <20080213095249.GD6451@duck.suse.cz>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-15-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202857582-15450-15-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-02-08 00:06:19, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/quota_v2.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/quota_v2.c b/fs/quota_v2.c
> index c519a58..a9f9eef 100644
> --- a/fs/quota_v2.c
> +++ b/fs/quota_v2.c
> @@ -303,7 +303,7 @@ static uint find_free_dqentry(struct dquot *dquot, int *err)
>  			printk(KERN_ERR "VFS: find_free_dqentry(): Can't remove block (%u) from entry free list.\n", blk);
>  			goto out_buf;
>  		}
> -	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)+1);
> +	le16_add_cpu(&dh->dqdh_entries, 1);
>  	memset(&fakedquot, 0, sizeof(struct v2_disk_dqblk));
>  	/* Find free structure in block */
>  	for (i = 0; i < V2_DQSTRINBLK && memcmp(&fakedquot, ddquot+i, sizeof(struct v2_disk_dqblk)); i++);
> @@ -445,7 +445,7 @@ static int free_dqentry(struct dquot *dquot, uint blk)
>  		goto out_buf;
>  	}
>  	dh = (struct v2_disk_dqdbheader *)buf;
> -	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)-1);
> +	le16_add_cpu(&dh->dqdh_entries, -1);
>  	if (!le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
>  		if ((ret = remove_free_dqentry(sb, type, buf, blk)) < 0 ||
>  		    (ret = put_free_dqblk(sb, type, buf, blk)) < 0) {
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
