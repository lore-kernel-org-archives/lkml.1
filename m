Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYDDR5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYDDR5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYDDR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:57:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42660 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYDDR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:57:20 -0400
Date: Fri, 4 Apr 2008 13:56:13 -0400
Message-Id: <200804041756.m34HuDmt019747@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] vfs: add path_rename() 
In-reply-to: Your message of "Wed, 02 Apr 2008 22:12:54 +0200."
             <20080402201330.689695350@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080402201330.689695350@szeredi.hu>, Miklos Szeredi writes:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Introduce path_rename().  Make vfs_rename() static.
[...]
> +int path_rename(struct path *old_dir_path, struct dentry *old_dentry,
> +		struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	int error = mnt_want_write(old_dir_path->mnt);
> +
> +	if (!error) {
> +		struct inode *old_dir = old_dir_path->dentry->d_inode;
> +
> +		error = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
> +		mnt_drop_write(old_dir_path->mnt);
> +	}
> +
> +	return error;
> +}
> +EXPORT_SYMBOL(path_rename);

You're grabbing a want_write ref on the source vfsmount only.  Shouldn't
path_rename() call mnt_want_write on *both* the source and destination
vfsmounts?  If so, do we need to order the locks ala lock_rename()?

Erez.
