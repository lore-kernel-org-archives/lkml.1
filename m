Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYBMJ4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYBMJ4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYBMJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:55:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYBMJz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:55:57 -0500
Subject: Re: [PATCH] gfs2: be*_add_cpu conversion
From: Steven Whitehouse <swhiteho@redhat.com>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com
In-Reply-To: <1202857582-15450-6-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
	 <1202857582-15450-6-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 13 Feb 2008 09:55:33 +0000
Message-Id: <1202896533.3862.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Wed, 2008-02-13 at 00:06 +0100, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/dir.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
> index c347095..6f2e382 100644
> --- a/fs/gfs2/dir.c
> +++ b/fs/gfs2/dir.c
> @@ -1021,13 +1021,13 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
>  
>  			new->de_inum = dent->de_inum; /* No endian worries */
>  			new->de_type = dent->de_type; /* No endian worries */
> -			nleaf->lf_entries = cpu_to_be16(be16_to_cpu(nleaf->lf_entries)+1);
> +			be16_add_cpu(&nleaf->lf_entries, 1);
>  
>  			dirent_del(dip, obh, prev, dent);
>  
>  			if (!oleaf->lf_entries)
>  				gfs2_consist_inode(dip);
> -			oleaf->lf_entries = cpu_to_be16(be16_to_cpu(oleaf->lf_entries)-1);
> +			be16_add_cpu(&oleaf->lf_entries, -1);
>  
>  			if (!prev)
>  				prev = dent;
> @@ -1616,7 +1616,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
>  			dent->de_type = cpu_to_be16(type);
>  			if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
>  				leaf = (struct gfs2_leaf *)bh->b_data;
> -				leaf->lf_entries = cpu_to_be16(be16_to_cpu(leaf->lf_entries) + 1);
> +				be16_add_cpu(&leaf->lf_entries, 1);
>  			}
>  			brelse(bh);
>  			error = gfs2_meta_inode_buffer(ip, &bh);

