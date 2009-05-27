Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbZE0J7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbZE0J7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbZE0J70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:59:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbZE0J7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:59:25 -0400
Subject: Re: linux-next: manual merge of the vfs tree with the gfs2 tree
From: Steven Whitehouse <swhiteho@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090527115253.37abd576.sfr@canb.auug.org.au>
References: <20090527115253.37abd576.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 27 May 2009 10:58:51 +0100
Message-Id: <1243418331.29604.445.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-05-27 at 11:52 +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/gfs2/ops_super.c between commit
> 9e6e0a128bca0a151d8d3fbd9459b22fc21cfebb ("GFS2: Merge mount.c and
> ops_super.c into super.c") from the gfs2 tree and commits
> 17af8f24a7750ea3d947904f97eb6dfacf9a88aa ("gfs2: remove ->write_super and
> stop maintaining ->s_dirt") and 8123178eb9ca12cde31a95170746e15a79528a62
> ("push BKL down into ->put_super") from the vfs tree.
> 
> The former commit removed the file.  I have mechanically applied the
> changes in the latter two commits to fs/gfs2/super.c (see below) and can
> carry this as a merge fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
Thanks for fixing this up.

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 40bcc37..c8930b3 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -719,6 +719,8 @@ static void gfs2_put_super(struct super_block *sb)
>  	int error;
>  	struct gfs2_jdesc *jd;
>  
> +	lock_kernel();
> +
>  	/*  Unfreeze the filesystem, if we need to  */
>  
>  	mutex_lock(&sdp->sd_freeze_lock);
> @@ -785,17 +787,8 @@ restart:
>  
>  	/*  At this point, we're through participating in the lockspace  */
>  	gfs2_sys_fs_del(sdp);
> -}


Al/Christoph, what is the purpose of the lock_kernel() ? I don't see why
this is required. What is it protecting against?

Steve.


