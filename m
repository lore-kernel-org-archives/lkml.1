Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZASTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZASTfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZASTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:35:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36909 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbZASTfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:35:10 -0500
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: coly.li@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4974B9A9.10305@suse.de>
References: <4974B9A9.10305@suse.de>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 13:35:08 -0600
Message-Id: <1232393708.5893.45.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 01:34 +0800, Coly Li wrote:
> This patch makes jfs return f_fsid info for statfs(2).
> 
> Signed-off-by: Coly Li <coly.li@suse.de>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/jfs/super.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index b37d1f7..7969c2f 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -143,8 +143,10 @@ static void jfs_destroy_inode(struct inode *inode)
> 
>  static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> -	struct jfs_sb_info *sbi = JFS_SBI(dentry->d_sb);
> +	struct super_block *sb = dentry->d_sb;
> +	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	s64 maxinodes;
> +	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
>  	struct inomap *imap = JFS_IP(sbi->ipimap)->i_imap;
> 
>  	jfs_info("In jfs_statfs");
> @@ -168,6 +170,8 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_files = maxinodes;
>  	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
>  				    atomic_read(&imap->im_numfree));
> +	buf->f_fsid.val[0] = (u32)id;
> +	buf->f_fsid.val[1] = (u32)(id >> 32);
> 
>  	buf->f_namelen = JFS_NAME_MAX;
>  	return 0;
> 
-- 
David Kleikamp
IBM Linux Technology Center

