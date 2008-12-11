Return-Path: <linux-kernel-owner+w=401wt.eu-S1760507AbYLKTuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbYLKTuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYLKTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:32:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56365 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460AbYLKTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:32:37 -0500
Date: Thu, 11 Dec 2008 13:32:28 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Mike.Halcrow.mhalcrow@us.ibm.com,
       Phillip.Hellewell.phillip@hellewell.homeip.net,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH] eCryptfs: check readlink result was not an error
	before using it
Message-ID: <20081211193228.GA13627@halcrowt61p.lan>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-3-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 07:16:26PM +0000, Duane Griffin wrote:
> The result from readlink is being used to index into the link name
> buffer without checking whether it is a valid length. If readlink
> returns an error this will fault or cause memory corruption.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
>  fs/ecryptfs/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 89209f0..5e78fc1 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct dentry *dentry, struct nameidata *nd)
>  	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
>  			"dentry->d_name.name = [%s]\n", dentry->d_name.name);
>  	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
> -	buf[rc] = '\0';
>  	set_fs(old_fs);
>  	if (rc < 0)
>  		goto out_free;
> +	else
> +		buf[rc] = '\0';
>  	rc = 0;
>  	nd_set_link(nd, buf);
>  	goto out;
