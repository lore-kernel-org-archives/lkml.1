Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYBIDE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYBIDE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 22:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYBIDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 22:04:18 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4128 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYBIDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 22:04:17 -0500
Subject: Re: [PATCH] affs: fix shadowed variable sparse warnings
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1202525599.8067.11.camel@brick>
References: <1202525599.8067.11.camel@brick>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 19:01:24 -0800
Message-Id: <1202526084.6113.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 18:53 -0800, Harvey Harrison wrote:
> diff --git a/fs/affs/file.c b/fs/affs/file.c
> index 6e0c939..ac05dc2 100644
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
> @@ -570,11 +570,11 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
>  		bh->b_state &= ~(1UL << BH_New);
>  		mark_buffer_dirty_inode(bh, inode);
>  		if (prev_bh) {
> -			u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
> -			if (tmp)
> -				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, tmp);
> +			u32 _tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);

Perhaps u32 next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);


