Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYEOH6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYEOH6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759037AbYEOH6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:58:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59637 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbYEOH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:58:18 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080515074952.GU13907@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 15 May 2008 08:49:52 +0100)
Subject: Re: [patch 10/24] vfs: truncate: append-only checking cleanup
References: <20080506091327.259950960@szeredi.hu> <20080506091418.842237934@szeredi.hu> <20080515074952.GU13907@ZenIV.linux.org.uk>
Message-Id: <E1JwYLp-0006Fw-ND@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 09:58:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	error = -EPERM;
> > -	if (IS_APPEND(inode))
> > -		goto mnt_drop_write_and_out;
> > -
> >  	error = get_write_access(inode);
> >  	if (error)
> >  		goto mnt_drop_write_and_out;
> 
> errno change and worse than that - we
> 	a) get different errno with append-only file mmaped shared
> 	b) break_lease() happening, despite the file being append-only
> 
> > @@ -321,10 +317,6 @@ static long do_sys_ftruncate(unsigned in
> >  	if (small && length > MAX_NON_LFS)
> >  		goto out_putf;
> >  
> > -	error = -EPERM;
> > -	if (IS_APPEND(inode))
> > -		goto out_putf;
> > -
> >  	error = locks_verify_truncate(inode, file, length);
> 
> Again, errno change...
> 
> > @@ -1639,8 +1639,6 @@ int may_open(struct nameidata *nd, int a
> >  	if (IS_APPEND(inode)) {
> >  		if  ((flag & FMODE_WRITE) && !(flag & O_APPEND))
> >  			return -EPERM;
> > -		if (flag & O_TRUNC)
> > -			return -EPERM;
> >  	}
> 
> Bogus break_lease() following that...
> 

OK, I'll drop this patch.  Truncate is weird, it should really have a
separate i_op/f_op.

Miklos
