Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZHJQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZHJQFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHJQFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:05:38 -0400
Received: from fieldses.org ([174.143.236.118]:59056 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbZHJQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:05:38 -0400
Date: Mon, 10 Aug 2009 12:05:37 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: linux-next: manual merge of the nfsd tree with the nfs tree
Message-ID: <20090810160537.GD3401@fieldses.org>
References: <20090810105851.80333493.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810105851.80333493.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:58:51AM +1000, Stephen Rothwell wrote:
> Hi Bruce,
> 
> Today's linux-next merge of the nfsd tree got a conflict in
> net/sunrpc/cache.c between commit
> 173912a6add00f4715774dcecf9ee53274c5924c ("SUNRPC: Move procfs-specific
> stuff out of the generic sunrpc cache code") from the nfs tree and commit
> f866a8194f7cbabb9135b98b9ac7d26237b88367 ("sunrpc/cache: rename
> queue_loose to cache_dequeue") from the nfsd tree.

OK, thanks.

Looks like there may be some less trivial conflicts now, though.  Trond,
maybe you could rebase the cache stuff against my latest for-2.6.32?

--b.

> 
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc net/sunrpc/cache.c
> index db7720e,d19c075..0000000
> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@@ -884,7 -908,19 +884,7 @@@ static int cache_release(struct inode *
>   
>   
>   
> - static void queue_loose(struct cache_detail *detail, struct cache_head *ch)
>  -static const struct file_operations cache_file_operations = {
>  -	.owner		= THIS_MODULE,
>  -	.llseek		= no_llseek,
>  -	.read		= cache_read,
>  -	.write		= cache_write,
>  -	.poll		= cache_poll,
>  -	.ioctl		= cache_ioctl, /* for FIONREAD */
>  -	.open		= cache_open,
>  -	.release	= cache_release,
>  -};
>  -
>  -
> + static void cache_dequeue(struct cache_detail *detail, struct cache_head *ch)
>   {
>   	struct cache_queue *cq;
>   	spin_lock(&queue_lock);
