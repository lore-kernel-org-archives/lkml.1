Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZASTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZASTk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZASTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:40:13 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:43271 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZASTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:40:12 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: coly.li@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/20] fs/fat: return f_fsid for statfs(2)
References: <4974B93F.8080909@suse.de>
Date: Tue, 20 Jan 2009 04:40:06 +0900
In-Reply-To: <4974B93F.8080909@suse.de> (Coly Li's message of "Tue, 20 Jan
	2009 01:32:47 +0800")
Message-ID: <87mydn84q1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li <coly.li@suse.de> writes:

> This patch makes fat return f_fsid info for statfs(2).

Looks good to me.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/inode.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 6b74d09..c093b7f 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -523,7 +523,9 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
>
>  static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> -	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
> +	struct super_block *sb = dentry->d_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
>
>  	/* If the count of free cluster is still unknown, counts it here. */
>  	if (sbi->free_clusters == -1 || !sbi->free_clus_valid) {
> @@ -537,6 +539,8 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_blocks = sbi->max_cluster - FAT_START_ENT;
>  	buf->f_bfree = sbi->free_clusters;
>  	buf->f_bavail = sbi->free_clusters;
> +	buf->f_fsid.val[0] = (u32)id;
> +	buf->f_fsid.val[1] = (u32)(id >> 32);
>  	buf->f_namelen = sbi->options.isvfat ? 260 : 12;
>
>  	return 0;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
