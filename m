Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYGALXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYGALXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYGALXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:23:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34473 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYGALXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:23:07 -0400
Date: Tue, 1 Jul 2008 14:22:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for
	userland
Message-ID: <20080701112248.GA17558@cs181140183.pp.htv.fi>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp> <129170883e848699cff211608.ps@mail.parknet.co.jp> <20080701074033.GB30362@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080701074033.GB30362@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:40:33AM -0400, Christoph Hellwig wrote:
> On Tue, Jul 01, 2008 at 11:57:03AM +0900, OGAWA Hirofumi wrote:
> > 
> > "struct dirent" is a kernel type here, but is a **different type** in 
> > userspace!  This means both the structure and the IOCTL number is wrong!
> > 
> > So, this adds new "struct __fat_dirent" to generate correct IOCTL
> > number.  And kernel stuff moves to under __KERNEL__.
> 
> Given that the current version can't actually work without defininig
> it's own dirent and thus ioctl number symbolic name I wonder if these
> ioctls are used at all?  They must have been completely untested for
> a while, and I suspect we'd be better off just removing them.

I had the same thought, but when checking this I noticed that at least 
wine works around this problem:

<--  snip  -->

/* just in case... */
#undef VFAT_IOCTL_READDIR_BOTH
#undef USE_GETDENTS

#ifdef linux

/* We want the real kernel dirent structure, not the libc one */
typedef struct
{
    long d_ino;
    long d_off;
    unsigned short d_reclen;
    char d_name[256];
} KERNEL_DIRENT;

/* Define the VFAT ioctl to get both short and long file names */
#define VFAT_IOCTL_READDIR_BOTH  _IOR('r', 1, KERNEL_DIRENT [2] )

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

