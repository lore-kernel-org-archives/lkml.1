Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYLENF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYLENF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYLENFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:05:19 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54134 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYLENFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:05:18 -0500
Date: Fri, 5 Dec 2008 13:04:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, dhowells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shmem: remove unused shmem_get_unmapped_area
In-Reply-To: <1228425490.3255.119.camel@calx>
Message-ID: <Pine.LNX.4.64.0812051257470.10157@blonde.anvils>
References: <1228425490.3255.119.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, Matt Mackall wrote:

> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: Hugh Dickins <hugh@veritas.com>

(Really, ramfs_nommu_get_unmapped_area() should be made static
in fs/ramfs/file-nommu.c, and its extern removed from ramfs.h;
but I notice it's used before it's declared, and my current
record at messing up Andrew with build errors is not very good,
so I'd rather leave that to someone who builds with NOMMU.)

> 
> diff -r b4d73844205b -r 8a9f1e9c46e8 include/linux/mm.h
> --- a/include/linux/mm.h	Wed Dec 03 16:45:56 2008 -0800
> +++ b/include/linux/mm.h	Mon Oct 27 17:33:21 2008 -0500
> @@ -717,14 +717,6 @@
>  
>  int shmem_zero_setup(struct vm_area_struct *);
>  
> -#ifndef CONFIG_MMU
> -extern unsigned long shmem_get_unmapped_area(struct file *file,
> -					     unsigned long addr,
> -					     unsigned long len,
> -					     unsigned long pgoff,
> -					     unsigned long flags);
> -#endif
> -
>  extern int can_do_mlock(void);
>  extern int user_shm_lock(size_t, struct user_struct *);
>  extern void user_shm_unlock(size_t, struct user_struct *);
> diff -r b4d73844205b -r 8a9f1e9c46e8 mm/tiny-shmem.c
> --- a/mm/tiny-shmem.c	Wed Dec 03 16:45:56 2008 -0800
> +++ b/mm/tiny-shmem.c	Mon Oct 27 17:33:21 2008 -0500
> @@ -121,14 +121,3 @@
>  {
>  	return 0;
>  }
> -
> -#ifndef CONFIG_MMU
> -unsigned long shmem_get_unmapped_area(struct file *file,
> -				      unsigned long addr,
> -				      unsigned long len,
> -				      unsigned long pgoff,
> -				      unsigned long flags)
> -{
> -	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
> -}
> -#endif
> 
> -- 
> Mathematics is the supreme nostalgia of our time.
