Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYAYFQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYAYFQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYAYFQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:16:08 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55907 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbYAYFQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:16:07 -0500
X-Sasl-enc: D2FUM/YSN8ZujdyAkPzduJ4vZG7+cDmBXnH2Dpssv2XK 1201238165
Subject: Re: [patch 06/26] mount options: fix autofs4
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080124193423.239049229@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193423.239049229@szeredi.hu>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 14:13:04 +0900
Message-Id: <1201237984.3040.62.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 20:33 +0100, Miklos Szeredi wrote:
> plain text document attachment (autofs4_opts.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add uid= and gid= options to /proc/mounts for autofs4 filesystems.

Apologies, I did say I would do this but have been quite busy.

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by Ian Kent <raven@themaw.net>

I haven't tested this yet but it is fairly straight forward.
I will check it out as soon as I get back to some work that I'm doing on
autofs4 (next few days).

> ---
> 
> Index: linux/fs/autofs4/inode.c
> ===================================================================
> --- linux.orig/fs/autofs4/inode.c	2008-01-22 15:52:42.000000000 +0100
> +++ linux/fs/autofs4/inode.c	2008-01-22 23:36:02.000000000 +0100
> @@ -188,11 +188,16 @@ out_kill_sb:
>  static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
>  {
>  	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
> +	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
>  
>  	if (!sbi)
>  		return 0;
>  
>  	seq_printf(m, ",fd=%d", sbi->pipefd);
> +	if (root_inode->i_uid != 0)
> +		seq_printf(m, ",uid=%u", root_inode->i_uid);
> +	if (root_inode->i_gid != 0)
> +		seq_printf(m, ",gid=%u", root_inode->i_gid);
>  	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
>  	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
>  	seq_printf(m, ",minproto=%d", sbi->min_proto);
> 
> --

