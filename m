Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYBPNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYBPNMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYBPNMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:12:08 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59845 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYBPNMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:12:07 -0500
Date: Sat, 16 Feb 2008 15:11:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ncpfs: add prototypes to ncp_fs.h
Message-ID: <20080216131144.GI9962@cs181133002.pp.htv.fi>
References: <1203105745.15275.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1203105745.15275.33.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:02:25PM -0800, Harvey Harrison wrote:
> Removes some externs from C files, noticed from the sparse warnings:
> fs/ncpfs/dir.c:90:26: warning: symbol 'ncp_root_dentry_operations' was not declared. Should it be static?
> fs/ncpfs/symlink.c:107:5: warning: symbol 'ncp_symlink' was not declared. Should it be static?
> fs/ncpfs/symlink.c:101:39: warning: symbol 'ncp_symlink_aops' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/ncpfs/inode.c       |    6 ------
>  include/linux/ncp_fs.h |    7 +++++++
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
> index fbbb9f7..2e5ab12 100644
> --- a/fs/ncpfs/inode.c
> +++ b/fs/ncpfs/inode.c
> @@ -107,12 +107,6 @@ static const struct super_operations ncp_sops =
>  	.show_options	= ncp_show_options,
>  };
>  
> -extern struct dentry_operations ncp_root_dentry_operations;
> -#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
> -extern const struct address_space_operations ncp_symlink_aops;
> -extern int ncp_symlink(struct inode*, struct dentry*, const char*);
> -#endif
> -
>  /*
>   * Fill in the ncpfs-specific information in the inode.
>   */
> diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
> index 88766e4..9f2d763 100644
> --- a/include/linux/ncp_fs.h
> +++ b/include/linux/ncp_fs.h
> @@ -204,6 +204,7 @@ void ncp_update_inode2(struct inode *, struct ncp_entry_info *);
>  /* linux/fs/ncpfs/dir.c */
>  extern const struct inode_operations ncp_dir_inode_operations;
>  extern const struct file_operations ncp_dir_operations;
> +extern struct dentry_operations ncp_root_dentry_operations;
>  int ncp_conn_logged_in(struct super_block *);
>  int ncp_date_dos2unix(__le16 time, __le16 date);
>  void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
> @@ -223,6 +224,12 @@ int ncp_disconnect(struct ncp_server *server);
>  void ncp_lock_server(struct ncp_server *server);
>  void ncp_unlock_server(struct ncp_server *server);
>  
> +/* linux/fs/ncpfs/symlink.c */
> +#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
> +extern const struct address_space_operations ncp_symlink_aops;
> +int ncp_symlink(struct inode*, struct dentry*, const char*);
> +#endif
>...

The prototype for ncp_symlink() fom fs/ncpfs/dir.c should also be 
removed and it's NULL dummy added here.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

