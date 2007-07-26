Return-Path: <linux-kernel-owner+w=401wt.eu-S936438AbXGZWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936438AbXGZWJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934684AbXGZWJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:09:01 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43699 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934549AbXGZWJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:09:00 -0400
Date: Thu, 26 Jul 2007 18:08:53 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH] lockd and nfsd endianness annotation fixes
Message-ID: <20070726220853.GN8125@fieldses.org>
References: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 05:33:49PM +0100, Al Viro wrote:
> 

Oops, thanks; these are my fault.

(How are you finding these?  I was assuming sparse, but running a make
-C2 just now I didn't see anything that would have suggested these
fixes.  I'm using whatever's current in Fedora--it says 0.3-1.fc7.  Do I
need something more recent?)

--b.

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/lockd/svclock.c |    6 +++---
>  fs/nfsd/nfs4xdr.c  |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> index b3efa45..a21e4bc 100644
> --- a/fs/lockd/svclock.c
> +++ b/fs/lockd/svclock.c
> @@ -335,10 +335,10 @@ static void nlmsvc_freegrantargs(struct nlm_rqst *call)
>  /*
>   * Deferred lock request handling for non-blocking lock
>   */
> -static u32
> +static __be32
>  nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
>  {
> -	u32 status = nlm_lck_denied_nolocks;
> +	__be32 status = nlm_lck_denied_nolocks;
>  
>  	block->b_flags |= B_QUEUED;
>  
> @@ -352,7 +352,7 @@ nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
>  			status = nlm_drop_reply;
>  	}
>  	dprintk("lockd: nlmsvc_defer_lock_rqst block %p flags %d status %d\n",
> -		block, block->b_flags, status);
> +		block, block->b_flags, ntohl(status));
>  
>  	return status;
>  }
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index b3d55c6..8ef0964 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -2450,7 +2450,7 @@ nfsd4_encode_rename(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4_
>  }
>  
>  static void
> -nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, int nfserr,
> +nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, __be32 nfserr,
>  		     struct nfsd4_secinfo *secinfo)
>  {
>  	int i = 0;
> -- 
> 1.5.3.GIT
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
