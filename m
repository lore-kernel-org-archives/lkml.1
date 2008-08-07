Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYHGTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYHGTb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYHGTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:31:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbYHGTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:31:50 -0400
Date: Thu, 7 Aug 2008 12:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch][reiser4] compile warning cleanups
Message-Id: <20080807123148.e4fcb4ca.akpm@linux-foundation.org>
In-Reply-To: <489B42DC.9060009@gmail.com>
References: <48f7fe350808010633v3bfbb602x9995b74db323703f@mail.gmail.com>
	<489B42DC.9060009@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 14:45:48 -0400
Ryan Hope <rmh3093@gmail.com> wrote:

> Hopefully this is not wordwrapped this time...

It is.

> From: Ryan Hope <rmh3093@gmail.com>
> Date: Fri, 1 Aug 2008 13:25:28 +0000 (-0400)
> Subject: cleanup reiser4 warnings
> X-Git-Url: 
> http://zen-sources.org/cgi-bin/gitweb.cgi?p=kernel.git;a=commitdiff_plain;h=675342fe83269780f2699f47972d0059e13db0cc
> 
> cleanup reiser4 warnings
> ---
> 
> diff --git a/fs/reiser4/plugin/file/cryptcompress.c 
> b/fs/reiser4/plugin/file/cryptcompress.c
> index 2e64374..7d3061d 100644
> --- a/fs/reiser4/plugin/file/cryptcompress.c
> +++ b/fs/reiser4/plugin/file/cryptcompress.c
> @@ -821,7 +821,7 @@ static int need_cut_or_align(struct inode * inode,
>   static void align_or_cut_overhead(struct inode * inode,
>   				  struct cluster_handle * ch, rw_op rw)
>   {
> -	int oh;
> +	unsigned int oh;
>   	cipher_plugin * cplug = inode_cipher_plugin(inode);
> 
>   	assert("edward-1402", need_cipher(inode));
> diff --git a/fs/reiser4/plugin/inode_ops.c b/fs/reiser4/plugin/inode_ops.c
> index 6ac4d13..945a740 100644
> --- a/fs/reiser4/plugin/inode_ops.c
> +++ b/fs/reiser4/plugin/inode_ops.c
> @@ -418,8 +418,7 @@ void *reiser4_follow_link_common(struct dentry 
> *dentry, struct nameidata *nd)
>    *
>    * Uses generic function to check for rwx permissions.
>    */
> -int reiser4_permission_common(struct inode *inode, int mask,
> -			      struct nameidata *nameidata)
> +int reiser4_permission_common(struct inode *inode, int mask)
>   {
>   	return generic_permission(inode, mask, NULL);
>   }
> diff --git a/fs/reiser4/plugin/object.h b/fs/reiser4/plugin/object.h
> index 63abb07..88a53a5 100644
> --- a/fs/reiser4/plugin/object.h
> +++ b/fs/reiser4/plugin/object.h
> @@ -25,8 +25,7 @@ int reiser4_mknod_common(struct inode *parent, struct 
> dentry *dentry,

here.

>   int reiser4_rename_common(struct inode *old_dir, struct dentry *old_name,
>   			  struct inode *new_dir, struct dentry *new_name);
>   void *reiser4_follow_link_common(struct dentry *, struct nameidata *data);
> -int reiser4_permission_common(struct inode *, int mask,
> -			      struct nameidata *nameidata);
> +int reiser4_permission_common(struct inode *, int mask);

And it is space-stuffed.

Documentation/email-clients.txt has some thunderbird help.

>   int reiser4_setattr_common(struct dentry *, struct iattr *);
>   int reiser4_getattr_common(struct vfsmount *mnt, struct dentry *,
>   			   struct kstat *);

I already fixed up and applied this, didn't I?
