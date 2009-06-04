Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZFDTA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZFDTA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZFDTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:00:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48928 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750951AbZFDTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:00:13 -0400
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, xfs-masters@oss.sgi.com
Message-Id: <E951DADA-CAEF-4C4F-A644-23E14C2DF198@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Artem Bityutskiy <dedekind@infradead.org>
In-Reply-To: <1244112114-23144-17-git-send-email-dedekind@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH v2 16/17] XFS: do not manipulate s_dirt directly
Date: Thu, 4 Jun 2009 14:00:12 -0500
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org> <1244112114-23144-17-git-send-email-dedekind@infradead.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4, 2009, at 5:41 AM, Artem Bityutskiy wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>
> ... use new VFS helpers instead.
>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: xfs-masters@oss.sgi.com
> Cc: Felix Blyakher <felixb@sgi.com>

Acked-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> fs/xfs/linux-2.6/xfs_super.c |    6 +++---
> fs/xfs/xfs_trans.c           |    2 +-
> 2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/ 
> xfs_super.c
> index d29218e..4c25456 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1114,7 +1114,7 @@ xfs_fs_write_super(
> {
> 	if (!(sb->s_flags & MS_RDONLY))
> 		xfs_sync_fsdata(XFS_M(sb), 0);
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
> }
>
> STATIC int
> @@ -1141,7 +1141,7 @@ xfs_fs_sync_super(
> 		error = xfs_quiesce_data(mp);
> 	else
> 		error = xfs_sync_fsdata(mp, 0);
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
>
> 	if (unlikely(laptop_mode)) {
> 		int	prev_sync_seq = mp->m_sync_seq;
> @@ -1447,7 +1447,7 @@ xfs_fs_fill_super(
>
> 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
>
> -	sb->s_dirt = 1;
> +	mark_sb_dirty(sb);
> 	sb->s_magic = XFS_SB_MAGIC;
> 	sb->s_blocksize = mp->m_sb.sb_blocksize;
> 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8570b82..2552bae 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -629,7 +629,7 @@ xfs_trans_apply_sb_deltas(
> 				  offsetof(xfs_dsb_t, sb_frextents) +
> 				  sizeof(sbp->sb_frextents) - 1);
>
> -	tp->t_mountp->m_super->s_dirt = 1;
> +	mark_sb_dirty(tp->t_mountp->m_super);
> }
>
> /*
> -- 
> 1.6.0.6
>

