Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXBTLSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXBTLSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964774AbXBTLSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:18:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:49339 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932882AbXBTLSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:18:14 -0500
Date: Tue, 20 Feb 2007 12:22:07 +0100
From: Jan Kara <jack@suse.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Hellwig <hch@lst.de>, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make remove_inode_dquot_ref() static
Message-ID: <20070220112207.GA5165@duck.suse.cz>
References: <20070220000738.GY13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000738.GY13958@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-02-07 01:07:38, Adrian Bunk wrote:
> remove_inode_dquot_ref() can now become static.
  ACK. I should have noticed it when acking Christophs patch...

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
  Signed-off-by: Jan Kara <jack@suse.cz>

									Honza
> ---
> 
>  fs/dquot.c               |    3 ++-
>  include/linux/quotaops.h |    3 ---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.20-mm2/include/linux/quotaops.h.old	2007-02-18 22:27:48.000000000 +0100
> +++ linux-2.6.20-mm2/include/linux/quotaops.h	2007-02-18 22:27:54.000000000 +0100
> @@ -37,9 +37,6 @@
>  extern int dquot_commit_info(struct super_block *sb, int type);
>  extern int dquot_mark_dquot_dirty(struct dquot *dquot);
>  
> -int remove_inode_dquot_ref(struct inode *inode, int type,
> -			   struct list_head *tofree_head);
> -
>  extern int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path);
>  extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
>  		int format_id, int type);
> --- linux-2.6.20-mm2/fs/dquot.c.old	2007-02-18 22:28:03.000000000 +0100
> +++ linux-2.6.20-mm2/fs/dquot.c	2007-02-18 22:28:16.000000000 +0100
> @@ -721,7 +721,8 @@
>  
>  /* Remove references to dquots from inode - add dquot to list for freeing if needed */
>  /* We can't race with anybody because we hold dqptr_sem for writing... */
> -int remove_inode_dquot_ref(struct inode *inode, int type, struct list_head *tofree_head)
> +static int remove_inode_dquot_ref(struct inode *inode, int type,
> +				  struct list_head *tofree_head)
>  {
>  	struct dquot *dquot = inode->i_dquot[type];
>  
> 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
