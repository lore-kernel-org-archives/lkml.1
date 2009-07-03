Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZGCEpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZGCEpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 00:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZGCEpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 00:45:04 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51771 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbZGCEpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 00:45:04 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Message-Id: <E17B1878-B726-4CB6-B80A-9E454158750E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4A4D6E7F.4060204@sandeen.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] un-static xfs_read_agf
Date: Thu, 2 Jul 2009 23:45:02 -0500
References: <20090703100551.e3f21aa0.sfr@canb.auug.org.au> <4A4D6E7F.4060204@sandeen.net>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 2, 2009, at 9:35 PM, Eric Sandeen wrote:

> CONFIG_XFS_DEBUG builds still need xfs_read_agf to be
> non-static, oops.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> Index: linux-2.6/fs/xfs/xfs_ag.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_ag.h
> +++ linux-2.6/fs/xfs/xfs_ag.h
> @@ -91,6 +91,9 @@ typedef struct xfs_agf {
> #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
> #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
>
> +extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
> +			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
> +
> /*
>  * Size of the unlinked inode hash table in the agi.
>  */
> Index: linux-2.6/fs/xfs/xfs_alloc.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_alloc.c
> +++ linux-2.6/fs/xfs/xfs_alloc.c
> @@ -2248,7 +2248,7 @@ xfs_alloc_put_freelist(
> /*
>  * Read in the allocation group header (free/alloc section).
>  */
> -STATIC int				/* error */
> +int					/* error */
> xfs_read_agf(
> 	struct xfs_mount	*mp,	/* mount point structure */
> 	struct xfs_trans	*tp,	/* transaction pointer */
>

