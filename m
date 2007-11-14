Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbXKNCiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbXKNCiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXKNCiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:38:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:54527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbXKNCiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:38:13 -0500
From: Neil Brown <neilb@suse.de>
To: Joe Perches <joe@perches.com>
Date: Wed, 14 Nov 2007 13:38:05 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18234.24461.192099.360005@notabene.brown>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>, nfs@lists.sourceforge.net
Subject: Re: [PATCH] - [9/15] - remove defconfig ptr comparisons to 0 - fs/nfsd
In-Reply-To: message from Joe Perches on Tuesday November 13
References: <1195005925.5163.95.camel@localhost>
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
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index d019918..07b38cf 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -987,7 +987,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
>  	 * flushing the data to disk is handled separately below.
>  	 */
>  
> -	if (file->f_op->fsync == 0) {/* COMMIT3 cannot work */
> +	if (!file->f_op->fsync) {/* COMMIT3 cannot work */
>  	       stable = 2;
>  	       *stablep = 2; /* FILE_SYNC */
>  	}
> 

Personally, I would much rather these were changed to "== NULL".
Different people have different preferences on whether to use
    ! foo
or
    foo == NULL

and the person who wrote that code is presumably showing a preference
for the later.  Changing it from "== 0" to "== NULL" is clearly a
valuable improvement.  Changing from "== 0" to "! " is a stylistic
change that should not be made lightly.

I personally often use and prefer the explicit comparison to NULL.

NeilBrown
