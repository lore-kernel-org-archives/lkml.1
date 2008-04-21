Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYDUPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYDUPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYDUPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:13:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38615 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYDUPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:13:35 -0400
To: me@bobcopeland.com
CC: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       me@bobcopeland.com
In-reply-to: <1208637457-24969-4-git-send-email-me@bobcopeland.com> (message
	from Bob Copeland on Sat, 19 Apr 2008 16:37:32 -0400)
Subject: Re: [PATCH 3/8] omfs: add inode routines
References: <1208637457-24969-4-git-send-email-me@bobcopeland.com>
Message-Id: <E1Jnxhm-0002we-Tx@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Apr 2008 17:13:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	start = clus_to_blk(sbi, be64_to_cpu(omfs_sb->s_root_block));
> +	bh2 = sb_bread(sb, start);
> +	if (!bh2)
> +		goto out_bh;
> +
> +	omfs_rb = (struct omfs_root_block *)bh2->b_data;
> +
> +	sbi->s_bitmap_ino = be64_to_cpu(omfs_rb->r_bitmap);
> +	sbi->s_clustersize = be32_to_cpu(omfs_rb->r_clustersize);
> +
> +	if (sbi->s_num_blocks != be64_to_cpu(omfs_rb->r_num_blocks)) {
> +		printk(KERN_ERR "omfs: block count discrepancy between "
> +			"super and root blocks (%llx, %llx)\n",
> +			sbi->s_num_blocks, be64_to_cpu(omfs_rb->r_num_blocks));
> +		goto out_bh;

Jump to wrong label.

Also label names are a bit chaotic.  But that's a matter of taste...

Miklos
