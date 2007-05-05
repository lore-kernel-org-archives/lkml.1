Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbXEES5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbXEES5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXEES5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:57:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbXEES5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:57:42 -0400
Date: Sat, 5 May 2007 11:57:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: jsipek@cs.sunysb.edu, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] fix unionfs compilation
Message-Id: <20070505115718.a1a0b61e.akpm@linux-foundation.org>
In-Reply-To: <20070505170012.GF8975@stusta.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<20070505170012.GF8975@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 19:00:12 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc7-mm2:
> >...
> >  git-unionfs.patch
> >...
> >  git trees
> >...
> 
> <--  snip  -->
> 
> ...
>   CC      fs/unionfs/super.o
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c: In function ‘init_once’:
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: for each function it appears in.)
> make[3]: *** [fs/unionfs/super.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.21-mm1/fs/unionfs/super.c.old	2007-05-05 18:45:25.000000000 +0200
> +++ linux-2.6.21-mm1/fs/unionfs/super.c	2007-05-05 18:46:03.000000000 +0200
> @@ -819,8 +819,7 @@
>  {
>  	struct unionfs_inode_info *i = v;
>  
> -	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
> -	    SLAB_CTOR_CONSTRUCTOR)
> +	if (flags & SLAB_CTOR_CONSTRUCTOR)
>  		inode_init_once(&i->vfs_inode);
>  }

Bah, that was hidden from my allmodconfig because CONFIG_UNIONFS is inexplicably
dependent upon CONFIG_SLAB.

How come?
