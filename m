Return-Path: <linux-kernel-owner+w=401wt.eu-S934772AbZLGItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbZLGItA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbZLGIs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:48:58 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50945 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbZLGIs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:48:57 -0500
Date: Mon, 7 Dec 2009 09:49:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20091207084903.GU8742@kernel.dk>
References: <20091207194429.d33903ed.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207194429.d33903ed.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> block/blk-cgroup.c: In function 'blkiocg_create':
> block/blk-cgroup.c:285: error: implicit declaration of function 'ERR_PTR'
> block/blk-cgroup.c:285: warning: return makes pointer from integer without a cast
> block/blk-cgroup.c:289: warning: return makes pointer from integer without a cast
> 
> Caused by commit 31e4c28d95e64f2d5d3c497a3ecf37c62de635b4 ("blkio:
> Introduce blkio controller cgroup interface").
> 
> I applied this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 7 Dec 2009 19:29:39 +1100
> Subject: [PATCH] block: include linux/err.h to use ERR_PTR
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  block/blk-cgroup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 3ad497f..1fa2654 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -14,6 +14,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/kdev_t.h>
>  #include <linux/module.h>
> +#include <linux/err.h>
>  #include "blk-cgroup.h"
>  
>  static DEFINE_SPINLOCK(blkio_list_lock);

Thanks Stephen, I merged your patch and updated the branches.

-- 
Jens Axboe

