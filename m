Return-Path: <linux-kernel-owner+w=401wt.eu-S1764368AbXGRODK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764368AbXGRODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbXGROC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:02:57 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:55717 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756884AbXGROC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:02:57 -0400
Date: Wed, 18 Jul 2007 16:04:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: make sysfs_init_inode() static
Message-ID: <20070718160403.7a3e8c57@hyperion.delvare>
In-Reply-To: <20070718053028.GH23568@htj.dyndns.org>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718052906.GG23568@htj.dyndns.org>
	<20070718053028.GH23568@htj.dyndns.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 14:30:28 +0900, Tejun Heo wrote:
> With sysfs_fill_super() converted to use sysfs_get_inode(), there is
> no user of sysfs_init_inode() outside of fs/sysfs/inode.c.  Make it
> static.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Looks good.

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  fs/sysfs/inode.c |    2 +-
>  fs/sysfs/sysfs.h |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> Index: work/fs/sysfs/inode.c
> ===================================================================
> --- work.orig/fs/sysfs/inode.c
> +++ work/fs/sysfs/inode.c
> @@ -133,7 +133,7 @@ static inline void set_inode_attr(struct
>   */
>  static struct lock_class_key sysfs_inode_imutex_key;
>  
> -void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
> +static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
>  {
>  	inode->i_blocks = 0;
>  	inode->i_mapping->a_ops = &sysfs_aops;
> Index: work/fs/sysfs/sysfs.h
> ===================================================================
> --- work.orig/fs/sysfs/sysfs.h
> +++ work/fs/sysfs/sysfs.h
> @@ -71,7 +71,6 @@ extern void sysfs_remove_one(struct sysf
>  extern int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
>  
>  extern void sysfs_delete_inode(struct inode *inode);
> -extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
>  extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
>  extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
>  


-- 
Jean Delvare
