Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYEELO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYEELO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbYEELOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:14:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYEELOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:14:18 -0400
Date: Mon, 5 May 2008 07:14:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 14/15] vfs: utimes immutable fix
Message-ID: <20080505111414.GI20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095530.431609833@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095530.431609833@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:55AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If updating file times to the current time and using a file
> descriptor, then don't check for immutable inode, only if the file is
> opened for write.  In this case immutability has been checked at open
> time.  This is the same as how write() and ftruncate() are handled.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Ulrich Drepper <drepper@redhat.com>
> ---
>  fs/utimes.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-2.6/fs/utimes.c
> ===================================================================
> --- linux-2.6.orig/fs/utimes.c	2008-05-05 11:29:28.000000000 +0200
> +++ linux-2.6/fs/utimes.c	2008-05-05 11:29:28.000000000 +0200
> @@ -110,9 +110,6 @@ static int do_fd_utimes(int fd, struct t
>  		struct inode *inode = file->f_path.dentry->d_inode;
>  
>  		error = -EACCES;
> -		if (IS_IMMUTABLE(inode))
> -			goto out_fput;
> -

Looks good, but please re-order it before the cleanup so we can put it
in for .26.

