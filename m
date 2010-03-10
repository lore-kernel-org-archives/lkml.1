Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0CJEyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:54:24 -0500
Received: from tundra.namei.org ([65.99.196.166]:48375 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0CJEyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:54:22 -0500
Date: Wed, 10 Mar 2010 15:53:56 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       torvalds@linux-foundation.org, sds@tycho.nsa.gov,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] anon_inodes: mark the anon inode private
In-Reply-To: <1268191381-26950-1-git-send-email-eparis@redhat.com>
Message-ID: <alpine.LRH.2.00.1003101553400.23261@tundra.namei.org>
References: <1268191381-26950-1-git-send-email-eparis@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Eric Paris wrote:

> Inotify was switched to use anon_inode instead of its own private filesystem
> which only had one inode in commit c44dcc56d2b5c7 "switch inotify_user to
> anon_inode"
> 
> The problem with this is that now the inotify inode is not a distinct inode
> which can be managed by LSMs.  userspace tools which use inotify were allowed
> to use the inotify inode but may not have had permission to do read/write type
> operations on the anon_inode.  After looking at the anon_inode and its users
> it looks like the best solution is to just mark the anon_inode as S_PRIVATE
> so the security system will ignore it.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: James Morris <jmorris@namei.org>

> ---
>  fs/anon_inodes.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 9f0bf13..2de0095 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -209,6 +209,7 @@ static struct inode *anon_inode_mkinode(void)
>  	inode->i_mode = S_IRUSR | S_IWUSR;
>  	inode->i_uid = current_fsuid();
>  	inode->i_gid = current_fsgid();
> +	inode->i_flags |= S_PRIVATE;
>  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  	return inode;
>  }
> -- 
> 1.6.5.3
> 

-- 
James Morris
<jmorris@namei.org>
