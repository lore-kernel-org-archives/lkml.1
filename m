Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXIQRDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXIQRDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXIQRDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:03:46 -0400
Received: from pat.uio.no ([129.240.10.15]:40255 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbXIQRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:03:45 -0400
Subject: Re: [PATCH 5/5][NFS] Cleanup explicit check for mandatory locks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <46EE335C.3010106@openvz.org>
References: <46EE335C.3010106@openvz.org>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 13:03:40 -0400
Message-Id: <1190048620.6700.100.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.094)
X-UiO-Scanned: 7B8188429626CF4228FA956C9274F75256C052F5
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 49 total 3928033 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 11:57 +0400, Pavel Emelyanov wrote:
> The __mandatory_lock(inode) macro makes the same check, but
> makes the code more readable.

Could we please avoid using underscores in macros. Also, why are we
breaking the usual convention of capitalising macro names?

Cheers
  Trond

> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> 
> ---
> 
>  fs/nfs/file.c |    3 +--
>  1 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 73ddd2e..7a07be1 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -605,8 +605,7 @@ static int nfs_lock(struct file *filp, i
>  	nfs_inc_stats(inode, NFSIOS_VFSLOCK);
>  
>  	/* No mandatory locks over NFS */
> -	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
> -	    fl->fl_type != F_UNLCK)
> +	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
>  		return -ENOLCK;
>  
>  	if (IS_GETLK(cmd))
> 

