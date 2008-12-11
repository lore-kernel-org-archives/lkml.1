Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYLKTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYLKTsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbYLKTWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:22:01 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51089 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbYLKTV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:21:59 -0500
Date: Thu, 11 Dec 2008 12:21:58 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: ensure link targets are NULL-terminated
Message-ID: <20081211192158.GE26095@parisc-linux.org>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-5-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 07:16:28PM +0000, Duane Griffin wrote:
> Ensure link targets are NULL-terminated, even if corrupted on-disk.

FWIW, that's spelled 'NUL' -- NULL is a pointer value, NUL is an ASCII
code.

> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/ext2/symlink.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
> index 4e2426e..9b164ba 100644
> --- a/fs/ext2/symlink.c
> +++ b/fs/ext2/symlink.c
> @@ -24,7 +24,9 @@
>  static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
> -	nd_set_link(nd, (char *)ei->i_data);
> +	char *link = (char *) ei->i_data;
> +	link[sizeof(ei->i_data) - 1] = '\0';
> +	nd_set_link(nd, link);
>  	return NULL;
>  }
>  
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
