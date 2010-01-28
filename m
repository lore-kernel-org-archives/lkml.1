Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835Ab0A1Xg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab0A1Xg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0A1Xgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:36:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:58143 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab0A1Xgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:36:55 -0500
Date: Fri, 29 Jan 2010 00:36:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH] jfs_dmap.[ch]: trivial typo fix: s/heigth/height/g
In-Reply-To: <1264666381-7770-1-git-send-email-daniel@caiaq.de>
Message-ID: <alpine.LNX.2.00.1001290036010.356@pobox.suse.cz>
References: <1264666381-7770-1-git-send-email-daniel@caiaq.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Daniel Mack wrote:

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: André Goddard Rosa <andre.goddard@gmail.com>
> Cc: jfs-discussion@lists.sourceforge.net
> ---
>  fs/jfs/jfs_dmap.c |   16 ++++++++--------
>  fs/jfs/jfs_dmap.h |    6 +++---
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index d9b031c..7e19d2f 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -195,7 +195,7 @@ int dbMount(struct inode *ipbmap)
>  	bmp->db_maxag = le32_to_cpu(dbmp_le->dn_maxag);
>  	bmp->db_agpref = le32_to_cpu(dbmp_le->dn_agpref);
>  	bmp->db_aglevel = le32_to_cpu(dbmp_le->dn_aglevel);
> -	bmp->db_agheigth = le32_to_cpu(dbmp_le->dn_agheigth);
> +	bmp->db_agheight = le32_to_cpu(dbmp_le->dn_agheight);
>  	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
>  	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
>  	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
> @@ -287,7 +287,7 @@ int dbSync(struct inode *ipbmap)
>  	dbmp_le->dn_maxag = cpu_to_le32(bmp->db_maxag);
>  	dbmp_le->dn_agpref = cpu_to_le32(bmp->db_agpref);
>  	dbmp_le->dn_aglevel = cpu_to_le32(bmp->db_aglevel);
> -	dbmp_le->dn_agheigth = cpu_to_le32(bmp->db_agheigth);
> +	dbmp_le->dn_agheight = cpu_to_le32(bmp->db_agheight);
>  	dbmp_le->dn_agwidth = cpu_to_le32(bmp->db_agwidth);
>  	dbmp_le->dn_agstart = cpu_to_le32(bmp->db_agstart);
>  	dbmp_le->dn_agl2size = cpu_to_le32(bmp->db_agl2size);
> @@ -1440,7 +1440,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
>  	 * tree index of this allocation group within the control page.
>  	 */
>  	agperlev =
> -	    (1 << (L2LPERCTL - (bmp->db_agheigth << 1))) / bmp->db_agwidth;
> +	    (1 << (L2LPERCTL - (bmp->db_agheight << 1))) / bmp->db_agwidth;
>  	ti = bmp->db_agstart + bmp->db_agwidth * (agno & (agperlev - 1));
>  
>  	/* dmap control page trees fan-out by 4 and a single allocation
> @@ -1459,7 +1459,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
>  		 * the subtree to find the leftmost leaf that describes this
>  		 * free space.
>  		 */
> -		for (k = bmp->db_agheigth; k > 0; k--) {
> +		for (k = bmp->db_agheight; k > 0; k--) {
>  			for (n = 0, m = (ti << 2) + 1; n < 4; n++) {
>  				if (l2nb <= dcp->stree[m + n]) {
>  					ti = m + n;
> @@ -3606,7 +3606,7 @@ void dbFinalizeBmap(struct inode *ipbmap)
>  	}
>  
>  	/*
> -	 * compute db_aglevel, db_agheigth, db_width, db_agstart:
> +	 * compute db_aglevel, db_agheight, db_width, db_agstart:
>  	 * an ag is covered in aglevel dmapctl summary tree,
>  	 * at agheight level height (from leaf) with agwidth number of nodes
>  	 * each, which starts at agstart index node of the smmary tree node
> @@ -3615,9 +3615,9 @@ void dbFinalizeBmap(struct inode *ipbmap)
>  	bmp->db_aglevel = BMAPSZTOLEV(bmp->db_agsize);
>  	l2nl =
>  	    bmp->db_agl2size - (L2BPERDMAP + bmp->db_aglevel * L2LPERCTL);
> -	bmp->db_agheigth = l2nl >> 1;
> -	bmp->db_agwidth = 1 << (l2nl - (bmp->db_agheigth << 1));
> -	for (i = 5 - bmp->db_agheigth, bmp->db_agstart = 0, n = 1; i > 0;
> +	bmp->db_agheight = l2nl >> 1;
> +	bmp->db_agwidth = 1 << (l2nl - (bmp->db_agheight << 1));
> +	for (i = 5 - bmp->db_agheight, bmp->db_agstart = 0, n = 1; i > 0;
>  	     i--) {
>  		bmp->db_agstart += n;
>  		n <<= 2;
> diff --git a/fs/jfs/jfs_dmap.h b/fs/jfs/jfs_dmap.h
> index 1a6eb41..6dcb906 100644
> --- a/fs/jfs/jfs_dmap.h
> +++ b/fs/jfs/jfs_dmap.h
> @@ -210,7 +210,7 @@ struct dbmap_disk {
>  	__le32 dn_maxag;	/* 4: max active alloc group number	*/
>  	__le32 dn_agpref;	/* 4: preferred alloc group (hint)	*/
>  	__le32 dn_aglevel;	/* 4: dmapctl level holding the AG	*/
> -	__le32 dn_agheigth;	/* 4: height in dmapctl of the AG	*/
> +	__le32 dn_agheight;	/* 4: height in dmapctl of the AG	*/
>  	__le32 dn_agwidth;	/* 4: width in dmapctl of the AG	*/
>  	__le32 dn_agstart;	/* 4: start tree index at AG height	*/
>  	__le32 dn_agl2size;	/* 4: l2 num of blks per alloc group	*/
> @@ -229,7 +229,7 @@ struct dbmap {
>  	int dn_maxag;		/* max active alloc group number	*/
>  	int dn_agpref;		/* preferred alloc group (hint)		*/
>  	int dn_aglevel;		/* dmapctl level holding the AG		*/
> -	int dn_agheigth;	/* height in dmapctl of the AG		*/
> +	int dn_agheight;	/* height in dmapctl of the AG		*/
>  	int dn_agwidth;		/* width in dmapctl of the AG		*/
>  	int dn_agstart;		/* start tree index at AG height	*/
>  	int dn_agl2size;	/* l2 num of blks per alloc group	*/
> @@ -255,7 +255,7 @@ struct bmap {
>  #define	db_agsize	db_bmap.dn_agsize
>  #define	db_agl2size	db_bmap.dn_agl2size
>  #define	db_agwidth	db_bmap.dn_agwidth
> -#define	db_agheigth	db_bmap.dn_agheigth
> +#define	db_agheight	db_bmap.dn_agheight
>  #define	db_agstart	db_bmap.dn_agstart
>  #define	db_numag	db_bmap.dn_numag
>  #define	db_maxlevel	db_bmap.dn_maxlevel

I have now applied this to my tree.

Dave, if you want to take it through your tree, or just Ack/Nack it, 
please let me know.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
