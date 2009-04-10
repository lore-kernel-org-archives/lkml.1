Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbZDJG2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbZDJG2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbZDJG2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:28:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:43523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbZDJG2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:28:17 -0400
Message-ID: <49DEE70B.9030902@suse.de>
Date: Fri, 10 Apr 2009 14:28:27 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] nilfs2: return f_fsid for statfs2
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1239341281-20249-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1239341281-20249-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack-by: Coly Li <coly.li@suse.de>

Ryusuke Konishi Wrote:
> This follows the change of Coly Li's series ("fs: return f_fsid for
> statfs(2)"), and make nilfs2 return f_fsid info for statfs(2).
> 
> Cc: Coly Li <coly.li@suse.de>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  fs/nilfs2/super.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index e117e1e..8a965f9 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -476,11 +476,12 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct super_block *sb = dentry->d_sb;
>  	struct nilfs_sb_info *sbi = NILFS_SB(sb);
> +	struct the_nilfs *nilfs = sbi->s_nilfs;
> +	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
>  	unsigned long long blocks;
>  	unsigned long overhead;
>  	unsigned long nrsvblocks;
>  	sector_t nfreeblocks;
> -	struct the_nilfs *nilfs = sbi->s_nilfs;
>  	int err;
>  
>  	/*
> @@ -514,6 +515,9 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_files = atomic_read(&sbi->s_inodes_count);
>  	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
>  	buf->f_namelen = NILFS_NAME_LEN;
> +	buf->f_fsid.val[0] = (u32)id;
> +	buf->f_fsid.val[1] = (u32)(id >> 32);
> +
>  	return 0;
>  }
>  

-- 
Coly Li
SuSE Labs
