Return-Path: <linux-kernel-owner+w=401wt.eu-S935629AbXLQQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935629AbXLQQTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760070AbXLQQTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:19:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59994 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759875AbXLQQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:19:43 -0500
Date: Mon, 17 Dec 2007 17:19:42 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/6] udf: fix coding style of dir.c
Message-ID: <20071217161942.GG6979@atrey.karlin.mff.cuni.cz>
References: <20071216021246.GD26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216021246.GD26986@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
  Please add a changelog even to changes like these.  From a quick look
it seems like whitespace / coding style cleanups and they look fine so
you can add:
  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/udf/dir.c |   46 +++++++++++++++++++++++++++-------------------
>  1 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index c26e281..c5e38d6 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -65,24 +65,26 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  	if (nf_pos == 0)
>  		nf_pos = (udf_ext0_offset(dir) >> 2);
> 
> -	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
> +	fibh.soffset = fibh.eoffset =
> +		(nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
>  	bits = dir->i_sb->s_blocksize_bits;
> 
> -	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
> +	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
>  		fibh.sbh = fibh.ebh = NULL;
> -	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
> -			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
> +	else if (inode_bmap(dir, nf_pos >> (bits - 2),
> +			    &epos, &eloc, &elen, &offset) ==
> +			(EXT_RECORDED_ALLOCATED >> 30)) {
>  		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
>  		if ((++offset << bits) < elen) {
>  			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
>  				epos.offset -= sizeof(short_ad);
>  			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
>  				epos.offset -= sizeof(long_ad);
> -		} else {
> +		} else
>  			offset = 0;
> -		}
> 
> -		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
> +		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
> +		if (!fibh.sbh) {
>  			brelse(epos.bh);
>  			return -EIO;
>  		}
> @@ -92,9 +94,11 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  			if (i + offset > (elen >> bits))
>  				i = (elen >> bits) - offset;
>  			for (num = 0; i > 0; i--) {
> -				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
> +				block = udf_get_lb_pblock(dir->i_sb, eloc,
> +							  offset + i);
>  				tmp = udf_tgetblk(dir->i_sb, block);
> -				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
> +				if (tmp && !buffer_uptodate(tmp) &&
> +					!buffer_locked(tmp))
>  					bha[num++] = tmp;
>  				else
>  					brelse(tmp);
> @@ -126,16 +130,18 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  		liu = le16_to_cpu(cfi.lengthOfImpUse);
>  		lfi = cfi.lengthFileIdent;
> 
> -		if (fibh.sbh == fibh.ebh) {
> +		if (fibh.sbh == fibh.ebh)
>  			nameptr = fi->fileIdent + liu;
> -		} else {
> +		else {
>  			int poffset;	/* Unpaded ending offset */
> 
> -			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
> +			poffset = fibh.soffset + sizeof(struct fileIdentDesc) +
> +					liu + lfi;
> 
> -			if (poffset >= lfi) {
> -				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
> -			} else {
> +			if (poffset >= lfi)
> +				nameptr = (char *)(fibh.ebh->b_data +
> +						   poffset - lfi);
> +			else {
>  				nameptr = fname;
>  				memcpy(nameptr, fi->fileIdent + liu,
>  				       lfi - poffset);
> @@ -168,12 +174,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  		}
> 
>  		if (flen) {
> -			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0) {
> +			if (filldir(dirent, fname, flen, filp->f_pos, iblock,
> +				    dt_type) < 0) {
>  				if (fibh.sbh != fibh.ebh)
>  					brelse(fibh.ebh);
>  				brelse(fibh.sbh);
>  				brelse(epos.bh);
> -	 			return 0;
> +				return 0;
>  			}
>  		}
>  	} /* end while */
> @@ -222,7 +229,8 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  	lock_kernel();
> 
>  	if (filp->f_pos == 0) {
> -		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
> +		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino,
> +			    DT_DIR) < 0) {
>  			unlock_kernel();
>  			return 0;
>  		}
> @@ -231,7 +239,7 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
> 
>  	result = do_udf_readdir(dir, filp, filldir, dirent);
>  	unlock_kernel();
> - 	return result;
> +	return result;
>  }
> 
>  /* readdir and lookup functions */
> --
> 1.5.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
