Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYBOVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYBOVT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbYBOVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:19:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbYBOVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:19:45 -0500
Date: Fri, 15 Feb 2008 13:19:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: rathamahata@php4.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] befs: fix sparse warning in linuxvfs.c
Message-Id: <20080215131922.0d0dcb08.akpm@linux-foundation.org>
In-Reply-To: <1203101164.15275.21.camel@brick>
References: <1203101164.15275.21.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 10:46:04 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use link as the variable name to avoid shadowing the arg.
> 
> fs/befs/linuxvfs.c:492:8: warning: symbol 'p' shadows an earlier one
> fs/befs/linuxvfs.c:488:77: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> This should be checked in case there is a latent bug here.  Should it
> be the arg *p getting freed, or the local var *p that was shadowing
> it?
> 

The code looks OK - the name was allocated in befs_follow_link() and was
saved away with nd_set_link().

> 
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 82123ff..e8717de 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -489,9 +489,9 @@ static void befs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
>  {
>  	befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
>  	if (befs_ino->i_flags & BEFS_LONG_SYMLINK) {
> -		char *p = nd_get_link(nd);
> -		if (!IS_ERR(p))
> -			kfree(p);
> +		char *link = nd_get_link(nd);
> +		if (!IS_ERR(link))
> +			kfree(link);
>  	}
>  }
>  
> -- 
> 1.5.4.1.1278.gc75be
> 
> 
