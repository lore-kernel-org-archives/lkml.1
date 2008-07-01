Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYGAVSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYGAVSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbYGAVSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:18:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750700AbYGAVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:18:00 -0400
Date: Tue, 1 Jul 2008 14:17:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] autofs4 - detect invalid direct mount requests
Message-Id: <20080701141715.62a2132b.akpm@linux-foundation.org>
In-Reply-To: <20080620051301.9988.94307.stgit@raven.themaw.net>
References: <20080620051301.9988.94307.stgit@raven.themaw.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 13:13:03 +0800
Ian Kent <raven@themaw.net> wrote:

> autofs v5 dierct and offset mounts within an autofs filesystem are
> triggered by existing autofs triger mounts so the mount point dentry
> must be positive. If the mount point dentry is negative then the
> trigger doesn't exist so we can return fail immediately.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> 
> ---
> 
>  fs/autofs4/waitq.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index cd21fd4..ae637d9 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -307,6 +307,10 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
>  	if (sbi->catatonic)
>  		return -ENOENT;
>  
> +	if (!dentry->d_inode &&
> +	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
> +		return -ENOENT;
> +
>  	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
>  	if (!name)
>  		return -ENOMEM;

A good changelog would allow little old me to determine whether this
patch should be merged into 2.6.25 and/or 2.6.26 and/or 2.6.27.  This
wasn't a good changelog :(

