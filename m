Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYFIXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYFIXMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYFIXMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:12:12 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45687 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYFIXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:12:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Adrian Bunk <bunk@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       =?iso-2022-jp-2?B?Uy4bJChEKi4bKEJh?=
	 =?iso-2022-jp-2?B?GyQoRCs7GyhCbGFy?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?iso-8859-1?Q?K=FC=E7=FCk?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fat/dir.c: switch to struct __fat_fs_dirent
References: <200806082116.50355.caglar@pardus.org.tr>
	<20080608184310.GD4048@cs181133002.pp.htv.fi>
	<87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org>
	<87iqwjmekq.fsf@duaron.myhome.or.jp>
	<20080609222644.GY1987@cs181133002.pp.htv.fi>
Date: Tue, 10 Jun 2008 08:12:01 +0900
In-Reply-To: <20080609222644.GY1987@cs181133002.pp.htv.fi> (Adrian Bunk's
	message of "Tue, 10 Jun 2008 01:26:44 +0300")
Message-ID: <87wskyyzi6.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> Can you apply the patch below after your patch?

Ok.

> Since fat was the only user of struct dirent in the kernel (there's an 
> unused JFS #define I'll also kill) we can then get rid of the 
> conflicting structs.

Sounds good. Thanks.

> <--  snip  -->
>
>
> struct __fat_fs_dirent is what was formerly the kernel struct dirent
> (that was different from the userspace struct dirent).
>
> Converting all fat users to struct __fat_fs_dirent will allow us to get 
> rid of the conflicting struct dirent definition.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  fs/fat/dir.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> b8c595b4b225c2485d8dbc7ff4cbcdc8e6113672 diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 486725e..041a112 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -17,7 +17,6 @@
>  #include <linux/slab.h>
>  #include <linux/time.h>
>  #include <linux/msdos_fs.h>
> -#include <linux/dirent.h>
>  #include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
>  #include <linux/compat.h>
> @@ -715,7 +714,7 @@ efault:									   \
>  	return -EFAULT;							   \
>  }
>  
> -FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, dirent)
> +FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_fs_dirent)
>  
>  static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
>  			     void __user *dirent, filldir_t filldir,
> @@ -741,7 +740,7 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
>  static int fat_dir_ioctl(struct inode *inode, struct file *filp,
>  			 unsigned int cmd, unsigned long arg)
>  {
> -	struct dirent __user *d1 = (struct dirent __user *)arg;
> +	struct __fat_fs_dirent __user *d1 = (struct __fat_fs_dirent __user *)arg;
>  	int short_only, both;
>  
>  	switch (cmd) {
> @@ -757,7 +756,7 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
>  		return fat_generic_ioctl(inode, filp, cmd, arg);
>  	}
>  
> -	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
> +	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_fs_dirent[2])))
>  		return -EFAULT;
>  	/*
>  	 * Yes, we don't need this put_user() absolutely. However old
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
