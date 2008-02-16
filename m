Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYBPUQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYBPUQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYBPUP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:15:56 -0500
Received: from fallback.mail.ru ([194.67.57.14]:9511 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbYBPUPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:15:55 -0500
Date: Sat, 16 Feb 2008 23:16:53 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/ufs/util.h 2nd parameter of fs32_to_cpu is not
	boolean
Message-ID: <20080216201650.GA18444@rain>
Mail-Followup-To: Roel Kluin <12o3l@tiscali.nl>,
	lkml <linux-kernel@vger.kernel.org>,
	Mark Fortescue <mark@mtfhpc.demon.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>
References: <47B73BA7.1000004@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B73BA7.1000004@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 08:38:15PM +0100, Roel Kluin wrote:
> from: fs/befs/endian.h +33
> static inline u32
> fs32_to_cpu(const struct super_block *sb, fs32 n)
> {
>         if (BEFS_SB(sb)->byte_order == BEFS_BYTESEX_LE)
>                 return le32_to_cpu((__force __le32)n);
>         else
>                 return be32_to_cpu((__force __be32)n);
> }
> 
> The 2nd parameter is not boolean
> ---
> Test the return value, rather than passing a boolean
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ufs/util.h b/fs/ufs/util.h
> index b26fc4d..23ceed8 100644
> --- a/fs/ufs/util.h
> +++ b/fs/ufs/util.h
> @@ -58,7 +58,7 @@ ufs_set_fs_state(struct super_block *sb, struct ufs_super_block_first *usb1,
>  {
>  	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
>  	case UFS_ST_SUNOS:
> -		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT)) {
> +		if (fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT) {
>  			usb1->fs_u0.fs_sun.fs_state = cpu_to_fs32(sb, value);
>  			break;
>  		}

Yeah, in origin patch, which introduced this code was the similar
misprint. It is sad that after review only one was fixed,
and the second go to mainline.

Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

-- 
/Evgeniy

