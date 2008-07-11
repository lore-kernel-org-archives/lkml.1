Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbYGKTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbYGKTWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbYGKTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:19:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758709AbYGKTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:19:24 -0400
Date: Fri, 11 Jul 2008 12:18:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH] reiserfs: discard prealloc in reiserfs_delete_inode
Message-Id: <20080711121850.dfd60681.akpm@linux-foundation.org>
In-Reply-To: <4873B3D2.1090101@suse.com>
References: <4873B3D2.1090101@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2008 14:37:06 -0400 Jeff Mahoney <jeffm@suse.com> wrote:

>  With the removal of struct file from the xattr code, reiserfs_file_release()
>  isn't used anymore, so the prealloc isn't discarded. This causes hangs
>  later down the line.
> 
>  This patch adds it to reiserfs_delete_inode. In most cases it will be
>  a no-op due to it already having been called, but will avoid hangs with xattrs.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/reiserfs/inode.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode
>  			goto out;
>  		reiserfs_update_inode_transaction(inode);
>  
> +		reiserfs_discard_prealloc(&th, inode);
> +
>  		err = reiserfs_delete_object(&th, inode);
>  
>  		/* Do quota update inside a transaction for journaled quotas. We must do that

Can you please remind us when "the removal of struct file from the xattr
code" happened?

Because hangs aren't good, and 2.6.25 might want this.
