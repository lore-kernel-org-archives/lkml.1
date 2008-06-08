Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYFHSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYFHSzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYFHSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:55:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45904 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYFHSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:55:36 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Adrian Bunk <bunk@kernel.org>
Cc: =?iso-2022-jp-2?B?Uy4bJChEKi4bKEJhGyQoRCs7GyhCbGFy?= Onur 
	<caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?iso-8859-1?Q?K=FC=E7=FCk?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26 patch] fat_valid_media() isn't for userspace
References: <200806082116.50355.caglar@pardus.org.tr>
	<20080608184310.GD4048@cs181133002.pp.htv.fi>
Date: Mon, 09 Jun 2008 03:55:31 +0900
In-Reply-To: <20080608184310.GD4048@cs181133002.pp.htv.fi> (Adrian Bunk's
	message of "Sun, 8 Jun 2008 21:43:10 +0300")
Message-ID: <87prqrn4d8.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp-2
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> This function isn't part of the kernel<->userspace API and therefore 
> shouldn't have been added at this place.
>
> I'd suggest the patch below instead.

Yes. This is new one, so it shouldn't have any users of that.
Looks more better. Thanks.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Commit 73f20e58b1d586e9f6d3ddc3aad872829aca7743
> (FAT_VALID_MEDIA(): remove pointless test)
> wrongly added the new fat_valid_media() function
> to the userspace-visible part of include/linux/msdos_fs.h
>
> Move it to the part of include/linux/msdos_fs.h that is not exported to 
> userspace.
>
> Reported-by: Onur Küçük <onur@pardus.org.tr>
> Reported-by: S.Çağlar Onur <caglar@pardus.org.tr>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  include/linux/msdos_fs.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> 4a56896ef4ef839cdc9d59fd7118c5051231c61e diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index b03b274..81cd36b 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -57,12 +57,6 @@
>  #define MSDOS_DOT	".          "	/* ".", padded to MSDOS_NAME chars */
>  #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
>  
> -/* media of boot sector */
> -static inline int fat_valid_media(u8 media)
> -{
> -	return 0xf8 <= media || media == 0xf0;
> -}
> -
>  #define FAT_FIRST_ENT(s, x)	((MSDOS_SB(s)->fat_bits == 32 ? 0x0FFFFF00 : \
>  	MSDOS_SB(s)->fat_bits == 16 ? 0xFF00 : 0xF00) | (x))
>  
> @@ -334,6 +328,12 @@ static inline void fatwchar_to16(__u8 *dst, const wchar_t *src, size_t len)
>  #endif
>  }
>  
> +/* media of boot sector */
> +static inline int fat_valid_media(u8 media)
> +{
> +	return 0xf8 <= media || media == 0xf0;
> +}
> +
>  /* fat/cache.c */
>  extern void fat_cache_inval_inode(struct inode *inode);
>  extern int fat_get_cluster(struct inode *inode, int cluster,
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
