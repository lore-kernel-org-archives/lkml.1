Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYDXRDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYDXRDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYDXRDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:03:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35588 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYDXRC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:02:59 -0400
Date: Thu, 24 Apr 2008 12:56:59 -0400
Message-Id: <200804241656.m3OGuxf5012805@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/13] ecryptfs: add missing lock around notify_change 
In-reply-to: Your message of "Thu, 24 Apr 2008 13:39:51 +0200."
             <20080424114008.353519557@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424114008.353519557@szeredi.hu>, Miklos Szeredi writes:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Caller of notify_change() need to hold i_mutex.
> 
> Compile tested only.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/ecryptfs/inode.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: vfs-2.6/fs/ecryptfs/inode.c
> ===================================================================
> --- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 18:47:17.000000000 +0200
> +++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 18:49:18.000000000 +0200
> @@ -908,7 +908,9 @@ static int ecryptfs_setattr(struct dentr
>  	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
>  		ia->ia_valid &= ~ATTR_MODE;
>  
> +	mutex_lock(&lower_dentry->d_inode->i_mutex);
>  	rc = notify_change(lower_dentry, ia);
> +	mutex_unlock(&lower_dentry->d_inode->i_mutex);
>  out:
>  	fsstack_copy_attr_all(inode, lower_inode, NULL);
>  	return rc;

Mike/Miklos,

Why is this patch part of the r/o bind mount 13-part patchset?  It seems to
me that this could go to akpm/Linus right now (w/o waiting for r/o bind
mount debate to conclude).

Ditto for the next one: [patch 02/13] ecryptfs: clean up (un)lock_parent

Thanks,
Erez.
