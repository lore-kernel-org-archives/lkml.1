Return-Path: <linux-kernel-owner+w=401wt.eu-S1763977AbXLQQc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763977AbXLQQc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXLQQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:32:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38165 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbXLQQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:32:19 -0500
Date: Mon, 17 Dec 2007 17:32:17 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 5/6] udf: fix signedness issue
Message-ID: <20071217163216.GI6979@atrey.karlin.mff.cuni.cz>
References: <20071216021556.GF26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216021556.GF26986@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sparse generated:
> fs/udf/namei.c:896:15: originally declared here
> fs/udf/namei.c:1147:41: warning: incorrect type in argument 3 (different signedness)
> fs/udf/namei.c:1147:41:    expected int *offset
> fs/udf/namei.c:1147:41:    got unsigned int *<noident>
> fs/udf/namei.c:1152:78: warning: incorrect type in argument 3 (different signedness)
> fs/udf/namei.c:1152:78:    expected int *offset
> fs/udf/namei.c:1152:78:    got unsigned int *<noident>
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
  I don't think this is right. udf_get_fileident() should take "unsigned
int *" as an offset, not just "int". This means changing struct
udf_fileident_bh to use unsigned int too but that is better anyway.
  And BTW the type shouldn't be uint32_t but really unsigned int in
udf_rename (int needn't have 32 bits on all archs (although I think it
has currently)).

									Honza

> ---
>  fs/udf/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index bec96a6..066153f 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -1131,7 +1131,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		}
>  	}
>  	if (S_ISDIR(old_inode->i_mode)) {
> -		uint32_t offset = udf_ext0_offset(old_inode);
> +		int offset = udf_ext0_offset(old_inode);
> 
>  		if (new_inode) {
>  			retval = -ENOTEMPTY;
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
