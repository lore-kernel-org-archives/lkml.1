Return-Path: <linux-kernel-owner+w=401wt.eu-S932945AbXBTNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbXBTNMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbXBTNMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:12:54 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1742 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbXBTNMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:12:53 -0500
X-AuthUser: hirofumi@parknet.jp
To: Vignesh Babu BM <vignesh.babu@wipro.com>
Cc: Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ][PATCH] is_power_of_2 in fat
References: <1171957794.6127.65.camel@wriver-t81fb058.linuxcoe>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Feb 2007 22:12:45 +0900
In-Reply-To: <1171957794.6127.65.camel@wriver-t81fb058.linuxcoe> (Vignesh Babu's message of "Tue\, 20 Feb 2007 13\:19\:54 +0530")
Message-ID: <873b51j7le.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vignesh Babu BM <vignesh.babu@wipro.com> writes:

> Replacing (n & (n-1)) in the context of power of 2 checks
> with is_power_of_2
>
> Signed-off-by: vignesh babu <vignesh.babu@wipro.com>

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

> --- 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index a9e4688..8437190 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -25,6 +25,7 @@
>  #include <linux/parser.h>
>  #include <linux/uio.h>
>  #include <linux/writeback.h>
> +#include <linux/log2.h>
>  #include <asm/unaligned.h>
>  
>  #ifndef CONFIG_FAT_DEFAULT_IOCHARSET
> @@ -1216,8 +1217,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
>  	}
>  	logical_sector_size =
>  		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
> -	if (!logical_sector_size
> -	    || (logical_sector_size & (logical_sector_size - 1))
> +	if (!is_power_of_2(logical_sector_size)
>  	    || (logical_sector_size < 512)
>  	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
>  		if (!silent)
> @@ -1227,8 +1227,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
>  		goto out_invalid;
>  	}
>  	sbi->sec_per_clus = b->sec_per_clus;
> -	if (!sbi->sec_per_clus
> -	    || (sbi->sec_per_clus & (sbi->sec_per_clus - 1))) {
> +	if (!is_power_of_2(sbi->sec_per_clus)) {
>  		if (!silent)
>  			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
>  			       sbi->sec_per_clus);
>
> -- 
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
