Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXKGPDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXKGPDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXKGPCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:02:53 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:55940 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbXKGPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:02:52 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fat: silence warning for 64KB PAGE_SIZE builds
References: <20071107051540.GB24266@lixom.net>
	<87prymqfwa.fsf@duaron.myhome.or.jp> <20071107150120.GA2677@lixom.net>
Date: Thu, 08 Nov 2007 00:02:48 +0900
In-Reply-To: <20071107150120.GA2677@lixom.net> (Olof Johansson's message of
	"Wed, 7 Nov 2007 09:01:20 -0600")
Message-ID: <87d4umqesn.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> writes:

> Annoying gcc warning:
>
> fs/fat/inode.c: In function 'fat_fill_super':
> fs/fat/inode.c:1222: warning: comparison is always false due to limited range of data type
>
> Change it to compare with 4K instead of PAGE_CACHE_SIZE, as suggested
> by OGAWA-san.
>
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
>
> ---
>
> On Wed, Nov 07, 2007 at 11:39:01PM +0900, OGAWA Hirofumi wrote:
>> Olof Johansson <olof@lixom.net> writes:
>> 
>> > logical_sector_size can never be more than 16 bits worth, but switching
>> > it to an int silences gcc. It's a sanity check that can never fail with
>> > 64KB PAGE_SIZE but it seems like it'd still be useful for other page
>> > sizes, so it's worth keeping:
> [...]
>> 
>> Please use 4096 instead of allowing it, at least for now.
>
> Sure. New patch.
>
>
> Thanks,
>
> -Olof
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 920a576..61e2874 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -1219,7 +1219,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
>  		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
>  	if (!is_power_of_2(logical_sector_size)
>  	    || (logical_sector_size < 512)
> -	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
> +	    || (logical_sector_size > 4096)) {
>  		if (!silent)
>  			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
>  			       logical_sector_size);

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks a lot.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
