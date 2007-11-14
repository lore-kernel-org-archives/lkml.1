Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXKNClK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXKNClK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXKNCk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:40:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:58435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXKNCk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:40:56 -0500
From: Neil Brown <neilb@suse.de>
To: Joe Perches <joe@perches.com>
Date: Wed, 14 Nov 2007 13:40:47 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18234.24623.742782.328651@notabene.brown>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfs@lists.sourceforge.net
Subject: Re: [PATCH] - [7/15] - remove defconfig ptr comparisons to 0 - fs/lockd
In-Reply-To: message from Joe Perches on Tuesday November 13
References: <1195005918.5163.93.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday November 13, joe@perches.com wrote:
> Remove defconfig ptr comparison to 0
> 
> Remove sparse warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
> diff --git a/fs/lockd/svcshare.c b/fs/lockd/svcshare.c
> index 068886d..98548ad 100644
> --- a/fs/lockd/svcshare.c
> +++ b/fs/lockd/svcshare.c
> @@ -71,7 +71,7 @@ nlmsvc_unshare_file(struct nlm_host *host, struct nlm_file *file,
>  	struct nlm_share	*share, **shpp;
>  	struct xdr_netobj	*oh = &argp->lock.oh;
>  
> -	for (shpp = &file->f_shares; (share = *shpp) != 0; shpp = &share->s_next) {
> +	for (shpp = &file->f_shares; (share = *shpp); shpp = &share->s_next) {
>  		if (share->s_host == host && nlm_cmp_owner(share, oh)) {
>  			*shpp = share->s_next;
>  			kfree(share);
> 

I particularly disagree with this change as it now looked like it
could be an '==' comparison that was mistyped.  Making it 
        ....; (share = *shpp) != NULL; ....

makes the intent clear.

NeilBrown
