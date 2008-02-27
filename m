Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYB0SJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYB0SJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYB0SJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:09:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbYB0SJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:09:27 -0500
Subject: Re: [PATCH 1/2] [GFS2] remove gfs2_dev_iops
From: Steven Whitehouse <swhiteho@redhat.com>
To: Denis Cheng <crquan@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1204010704-11842-1-git-send-email-crquan@gmail.com>
References: <1204010704-11842-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 27 Feb 2008 18:08:33 +0000
Message-Id: <1204135713.3323.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Both patches are now in the -nmw git tree. Sorry for the delay. I've
changed the comment on the second one since that commit ID didn't appear
to match up with the right patch.

Steve.

On Tue, 2008-02-26 at 15:25 +0800, Denis Cheng wrote:
> struct inode_operations gfs2_dev_iops is always the same as gfs2_file_iops,
> since Jan 2006, when GFS2 merged into mainstream kernel.
> 
> So one of them could be removed.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/gfs2/inode.c     |    2 +-
>  fs/gfs2/ops_inode.c |   10 ----------
>  fs/gfs2/ops_inode.h |    1 -
>  3 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 37725ad..1069ceb 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -149,7 +149,7 @@ void gfs2_set_iop(struct inode *inode)
>  	} else if (S_ISLNK(mode)) {
>  		inode->i_op = &gfs2_symlink_iops;
>  	} else {
> -		inode->i_op = &gfs2_dev_iops;
> +		inode->i_op = &gfs2_file_iops;
>  	}
>  
>  	unlock_new_inode(inode);
> diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
> index e874129..ab9a073 100644
> --- a/fs/gfs2/ops_inode.c
> +++ b/fs/gfs2/ops_inode.c
> @@ -1148,16 +1148,6 @@ const struct inode_operations gfs2_file_iops = {
>  	.removexattr = gfs2_removexattr,
>  };
>  
> -const struct inode_operations gfs2_dev_iops = {
> -	.permission = gfs2_permission,
> -	.setattr = gfs2_setattr,
> -	.getattr = gfs2_getattr,
> -	.setxattr = gfs2_setxattr,
> -	.getxattr = gfs2_getxattr,
> -	.listxattr = gfs2_listxattr,
> -	.removexattr = gfs2_removexattr,
> -};
> -
>  const struct inode_operations gfs2_dir_iops = {
>  	.create = gfs2_create,
>  	.lookup = gfs2_lookup,
> diff --git a/fs/gfs2/ops_inode.h b/fs/gfs2/ops_inode.h
> index fd8cee2..14b4b79 100644
> --- a/fs/gfs2/ops_inode.h
> +++ b/fs/gfs2/ops_inode.h
> @@ -15,7 +15,6 @@
>  extern const struct inode_operations gfs2_file_iops;
>  extern const struct inode_operations gfs2_dir_iops;
>  extern const struct inode_operations gfs2_symlink_iops;
> -extern const struct inode_operations gfs2_dev_iops;
>  extern const struct file_operations gfs2_file_fops;
>  extern const struct file_operations gfs2_dir_fops;
>  extern const struct file_operations gfs2_file_fops_nolock;

