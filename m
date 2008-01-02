Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYABCDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYABCDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYABCC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:02:59 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42345 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYABCC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:02:58 -0500
Date: Wed, 2 Jan 2008 04:02:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] linux/ufs_fs.h: use __u64 for userspace
Message-ID: <20080102020242.GP27566@does.not.exist>
References: <200801012051.41474.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801012051.41474.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 08:51:40PM -0500, Mike Frysinger wrote:
> Fix the ufs_inotofsba macro to use __u64 rather than u64 since this is
> exported to userspace.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/include/linux/ufs_fs.h b/include/linux/ufs_fs.h
> index 10b854d..35b6e59 100644
> --- a/include/linux/ufs_fs.h
> +++ b/include/linux/ufs_fs.h
> @@ -225,7 +225,7 @@ typedef __u16 __bitwise __fs16;
>   */
>  #define	ufs_inotocg(x)		((x) / uspi->s_ipg)
>  #define	ufs_inotocgoff(x)	((x) % uspi->s_ipg)
> -#define	ufs_inotofsba(x)	(((u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
> +#define	ufs_inotofsba(x)	(((__u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
>  #define	ufs_inotofsbo(x)	((x) % uspi->s_inopf)

But userspace anyway can't use them since it doesn't know what "uspi" 
is, so you should better reduce the userspace visibility of this header.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

