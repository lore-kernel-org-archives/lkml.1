Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXJUWTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXJUWTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 18:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXJUWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 18:18:56 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43108 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXJUWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 18:18:55 -0400
Date: Sun, 21 Oct 2007 18:18:22 -0400
Message-Id: <200710212218.l9LMIMgj011206@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, bfields@fieldses.org,
       nfs@lists.sourceforge.net, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: nfsv2 ref leak in 2.6.24? 
In-reply-to: Your message of "Sun, 21 Oct 2007 12:58:12 EDT."
             <1192985892.7505.32.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1192985892.7505.32.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> 
> On Sat, 2007-10-20 at 17:35 -0400, Erez Zadok wrote:
> 
> > Trond, I verified that w/ the above patch the problem is w/ nfs: the client
> > leaves .nfsXXX files behind for every file unlinked while open.  Let me know
> > when you get a fix and I'll test it.
> 
> Doh... Another typo.
> 
> Trond
> -------------------------- CUT HERE --------------------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Sun, 21 Oct 2007 12:02:22 -0400
> NFS: Fix a typo in nfs_call_unlink()
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
> 
>  fs/nfs/unlink.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
> index ce558c2..233ad38 100644
> --- a/fs/nfs/unlink.c
> +++ b/fs/nfs/unlink.c
> @@ -171,7 +171,7 @@ static int nfs_call_unlink(struct dentry *dentry, struct nfs_unlinkdata *data)
>  	if (parent == NULL)
>  		goto out_free;
>  	dir = parent->d_inode;
> -	if (nfs_copy_dname(dentry, data) == 0)
> +	if (nfs_copy_dname(dentry, data) != 0)
>  		goto out_dput;
>  	/* Non-exclusive lock protects against concurrent lookup() calls */
>  	spin_lock(&dir->i_lock);

With this patch, all my nfs2/3/4 tests passed just fine.

Thanks,
Erez.
