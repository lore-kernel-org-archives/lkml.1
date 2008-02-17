Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYBQTaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYBQTaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYBQT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:29:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:61640 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYBQT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BTbxwu/0KqPnX7CSwCGE6qbmvUOcmRuZ2rlyi7tKVJ8KOBMM5yl8MRNSI1/PnjUXJJ2fhXk/Cax7VCYY2nDg1RmicgU0AOI35zd849nyy6NDthGLiCykzIyi9vVkczzHu+iB4jPx81AqKtkG7Ilf3UJfF8/CE4UD+XMUfG+55os=
Date: Sun, 17 Feb 2008 20:29:02 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: bfennema@falcon.csc.calpoly.edu, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/7] fs/udf/truncate.c: Use BUG_ON
Message-ID: <20080217192858.GA9162@joi>
References: <Pine.LNX.4.64.0802171855510.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171855510.28055@ask.diku.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:56:18PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.

The same change is in my patch which is waiting for inclusion.

http://lkml.org/lkml/2008/1/30/512

> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @ disable unlikely @ expression E,f; @@
> 
> (
>   if (<... f(...) ...>) { BUG(); }
> |
> - if (unlikely(E)) { BUG(); }
> + BUG_ON(E);
> )
> 
> @@ expression E,f; @@
> 
> (
>   if (<... f(...) ...>) { BUG(); }
> |
> - if (E) { BUG(); }
> + BUG_ON(E);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> 
> diff -u -p a/fs/udf/truncate.c b/fs/udf/truncate.c
> --- a/fs/udf/truncate.c 2008-02-10 22:34:15.000000000 +0100
> +++ b/fs/udf/truncate.c 2008-02-17 16:41:19.000000000 +0100
> @@ -224,8 +224,7 @@ void udf_truncate_extents(struct inode *
>  				if (indirect_ext_len) {
>  					/* We managed to free all extents in the
>  					 * indirect extent - free it too */
> -					if (!epos.bh)
> -						BUG();
> +					BUG_ON(!epos.bh);
>  					udf_free_blocks(sb, inode, epos.block,
>  							0, indirect_ext_len);
>  				} else {
> @@ -272,8 +271,7 @@ void udf_truncate_extents(struct inode *
>  		}
>  
>  		if (indirect_ext_len) {
> -			if (!epos.bh)
> -				BUG();
> +			BUG_ON(!epos.bh);
>  			udf_free_blocks(sb, inode, epos.block, 0,
>  					indirect_ext_len);
>  		} else {
> -
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
