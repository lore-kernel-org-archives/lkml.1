Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYFIIGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYFIIGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYFIIGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:06:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42243 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbYFIIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:06:04 -0400
Date: Mon, 9 Jun 2008 11:05:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Adrian Bunk <bunk@kernel.org>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?utf-8?B?S8O8w6fDvGs=?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26 patch] fat_valid_media() isn't for userspace
Message-ID: <20080609080512.GF4048@cs181133002.pp.htv.fi>
References: <200806082116.50355.caglar@pardus.org.tr> <20080608184310.GD4048@cs181133002.pp.htv.fi> <87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org> <87iqwjmekq.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87iqwjmekq.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 01:12:37PM +0900, OGAWA Hirofumi wrote:
> "H. Peter Anvin" <hpa@kernel.org> writes:
> 
> > The other thing about this header that needs to be fixed is the 
> > definition of the following ioctls:
> >
> > #define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
> > #define VFAT_IOCTL_READDIR_SHORT        _IOR('r', 2, struct dirent [2])
> >
> > "struct dirent" is a kernel type here, but is a **different type** in 
> > userspace!  This means both the structure and the IOCTL number is wrong!
> >
> > We need to make this either __kernel_dirent_t[*] or something like 
> > struct __msdos_fs_dirent.
> 
> I see. "struct dirent" in linux/dirent.h has very few users in kernel,
> and probably userland doesn't use it, so it seems it should be renamed.
> 
> Well, the patch is like this (sorry, other cleanup is in this patch)?
>...

I wanted to ask whether it could have had any users at all, but at least 
Wine contains a workaround for our bug...

> Thanks.
> 
> > 	-hpa
>...
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

