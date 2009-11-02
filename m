Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZKBLN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZKBLN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZKBLN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:13:57 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:30202
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbZKBLN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:13:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAANO7krLzn0N/2dsb2JhbADaV4Q5BIFidA
X-IronPort-AV: E=Sophos;i="4.44,666,1249228800"; 
   d="scan'208";a="53876496"
Message-ID: <4AEEBEF1.8050807@themaw.net>
Date: Mon, 02 Nov 2009 19:13:53 +0800
From: Ian Kent <raven@themaw.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Jan Blunck <jblunck@suse.de>
CC: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, autofs@linux.kernel.org
Subject: Re: [PATCH 10/27] BKL: Remove BKL from autofs4
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-11-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-11-git-send-email-jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> BKL is only used in fill_super. It is safe to remove it.

Yes, I think so too.
Of course this will make co-coordinating the rename of autofs4 to autofs
a bit more painful, ;)

> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Ian Kent <raven@themaw.net>

> ---
>  fs/autofs4/inode.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
> index 3adaba9..69c8142 100644
> --- a/fs/autofs4/inode.c
> +++ b/fs/autofs4/inode.c
> @@ -323,8 +323,6 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
>  	struct autofs_sb_info *sbi;
>  	struct autofs_info *ino;
>  
> -	lock_kernel();
> -
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		goto fail_unlock;
> @@ -420,7 +418,6 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
>  	 * Success! Install the root dentry now to indicate completion.
>  	 */
>  	s->s_root = root;
> -	unlock_kernel();
>  	return 0;
>  	
>  	/*
> @@ -442,7 +439,6 @@ fail_free:
>  	kfree(sbi);
>  	s->s_fs_info = NULL;
>  fail_unlock:
> -	unlock_kernel();
>  	return -EINVAL;
>  }
>  

