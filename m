Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbXEFLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbXEFLLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXEFLLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:11:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbXEFLLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:11:30 -0400
Date: Sun, 6 May 2007 12:11:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: Fix indentation in do_path_lookup
Message-ID: <20070506111124.GA1211@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1178405980972-git-send-email-jsipek@cs.sunysb.edu> <11784059803717-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784059803717-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 06:59:39PM -0400, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  fs/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 0262594..600a4e7 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1159,7 +1159,7 @@ out:
>  	if (likely(retval == 0)) {
>  		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
>  				nd->dentry->d_inode))
> -		audit_inode(name, nd->dentry->d_inode);
> +			audit_inode(name, nd->dentry->d_inode);
>  	}

Actually this area should get some more changes.  There should be no
likely retval == 0 branch because it only contains another branch, and
nd is guaranteed to be zero.

So it should become:

	if (unlikely(!retval && !audit_dummy_context() &&
		     nd->dentry && nd->dentry->d_inode))
		audit_inode(name, nd->dentry->d_inode);

