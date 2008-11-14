Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKNVls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKNVls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbYKNVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:41:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746AbYKNVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:41:20 -0500
Date: Fri, 14 Nov 2008 13:41:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd/physmap: use parse_mtd()
Message-Id: <20081114134116.972fce2f.akpm@linux-foundation.org>
In-Reply-To: <1226533189-8492-1-git-send-email-vapier@gentoo.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	<1226533189-8492-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 18:39:48 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> Call parse_mtd() to handle partition/device registration rather than doing
> it all ourself.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/mtd/maps/physmap.c |   21 +--------------------
>  1 files changed, 1 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index 42d844f..9b87fd8 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -84,9 +84,6 @@ static int physmap_flash_remove(struct platform_device *dev)
>  }
>  
>  static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", "map_rom", NULL };
> -#ifdef CONFIG_MTD_PARTITIONS
> -static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
> -#endif
>  
>  static int physmap_flash_probe(struct platform_device *dev)
>  {
> @@ -170,23 +167,7 @@ static int physmap_flash_probe(struct platform_device *dev)
>  	if (err)
>  		goto err_out;
>  
> -#ifdef CONFIG_MTD_PARTITIONS
> -	err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
> -	if (err > 0) {
> -		add_mtd_partitions(info->cmtd, info->parts, err);
> -		return 0;
> -	}
> -
> -	if (physmap_data->nr_parts) {
> -		printk(KERN_NOTICE "Using physmap partition information\n");
> -		add_mtd_partitions(info->cmtd, physmap_data->parts,
> -				   physmap_data->nr_parts);
> -		return 0;
> -	}
> -#endif
> -
> -	add_mtd_device(info->cmtd);
> -	return 0;
> +	return parse_mtd(info->cmtd, NULL, physmap_data->parts, physmap_data->nr_parts);
>  
>  err_out:
>  	physmap_flash_remove(dev);

This didn't apply due to
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch.  I
just smashed it in anyway.  Should I drop
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
instead?  Your changelog mentioned nothing about leak-fixing?

