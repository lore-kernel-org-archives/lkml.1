Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXJBKGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXJBKGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJBKGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:06:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54777 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXJBKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:06:12 -0400
Date: Tue, 2 Oct 2007 12:06:10 +0200
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/30] IGET: Stop EXT2 from using iget() and read_inode()
Message-ID: <20071002100610.GA25647@atrey.karlin.mff.cuni.cz>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131018.29339.40931.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001131018.29339.40931.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 0079b2c..d8fb795 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
...
> +
> +	raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
>  	if (IS_ERR(raw_inode))
>   		goto bad_inode;
  Hmm, why don't you use the return value from raw_inode? It can be
either -EIO or -EINVAL if 'ino' was invalid...
  Otherwise the patch looks fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
