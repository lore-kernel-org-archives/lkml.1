Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYBEPaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYBEPaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYBEPaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:30:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:53481 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750875AbYBEPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:30:06 -0500
Date: Tue, 5 Feb 2008 16:30:05 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] udf: udf_get_block, inode_bmap - remove unneeded
	checks
Message-ID: <20080205153005.GF25464@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202063771-18172-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:36:06, marcin.slusarz@gmail.com wrote:
> block cannot be less than 0, because it's sector_t,
> so remove unneeded checks
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/udf/inode.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index c2d0477..531443d 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -323,9 +323,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
>  
>  	lock_kernel();
>  
> -	if (block < 0)
> -		goto abort_negative;
> -
>  	iinfo = UDF_I(inode);
>  	if (block == iinfo->i_next_alloc_block + 1) {
>  		iinfo->i_next_alloc_block++;
> @@ -347,10 +344,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
>  abort:
>  	unlock_kernel();
>  	return err;
> -
> -abort_negative:
> -	udf_warning(inode->i_sb, "udf_get_block", "block < 0");
> -	goto abort;
>  }
>  
>  static struct buffer_head *udf_getblk(struct inode *inode, long block,
> @@ -2081,11 +2074,6 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
>  	int8_t etype;
>  	struct udf_inode_info *iinfo;
>  
> -	if (block < 0) {
> -		printk(KERN_ERR "udf: inode_bmap: block < 0\n");
> -		return -1;
> -	}
> -
>  	iinfo = UDF_I(inode);
>  	pos->offset = 0;
>  	pos->block = iinfo->i_location;
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
