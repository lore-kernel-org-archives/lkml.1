Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYH0Oou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYH0Oou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYH0Ook
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:44:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:36225 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbYH0Ooj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:44:39 -0400
Date: Wed, 27 Aug 2008 16:44:37 +0200
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 45/59] CRED: Wrap task credential accesses in the UDF
	filesystem
Message-ID: <20080827144437.GD14046@duck.suse.cz>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134934.19980.69154.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827134934.19980.69154.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-08-08 14:49:34, David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
> 
>  fs/udf/ialloc.c |    4 ++--
>  fs/udf/namei.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
> index a4f2b3c..31fc842 100644
> --- a/fs/udf/ialloc.c
> +++ b/fs/udf/ialloc.c
> @@ -126,13 +126,13 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
>  	}
>  	mutex_unlock(&sbi->s_alloc_mutex);
>  	inode->i_mode = mode;
> -	inode->i_uid = current->fsuid;
> +	inode->i_uid = current_fsuid();
>  	if (dir->i_mode & S_ISGID) {
>  		inode->i_gid = dir->i_gid;
>  		if (S_ISDIR(mode))
>  			mode |= S_ISGID;
>  	} else {
> -		inode->i_gid = current->fsgid;
> +		inode->i_gid = current_fsgid();
>  	}
>  
>  	iinfo->i_location.logicalBlockNum = block;
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 7578fae..869c982 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -605,7 +605,7 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
>  		goto out;
>  
>  	iinfo = UDF_I(inode);
> -	inode->i_uid = current->fsuid;
> +	inode->i_uid = current_fsuid();
>  	init_special_inode(inode, mode, rdev);
>  	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
>  	if (!fi) {
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
