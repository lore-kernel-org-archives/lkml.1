Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbXLCXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbXLCXZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLCXZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:25:41 -0500
Received: from www2.coile-labs.com ([65.14.39.133]:16438 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbXLCXZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:25:41 -0500
Date: Mon, 3 Dec 2007 18:24:28 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-ID: <20071203232428.GF27094@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/> <20071201122302.10dd9c44.akpm@linux-foundation.org> <20071203162137.GB25251@coraid.com> <20071203113459.d36c1a01.akpm@linux-foundation.org> <20071203210005.GB27094@coraid.com> <20071203213837.GE27094@coraid.com> <20071203144722.4188f476.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203144722.4188f476.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 02:47:22PM -0800, Andrew Morton wrote:
> On Mon, 3 Dec 2007 16:38:37 -0500
> "Ed L. Cashin" <ecashin@coraid.com> wrote:
...
> > It appears that the fbc->counters pointer is NULL.
> 
> Does this fix?
> 
> --- a/drivers/block/aoe/aoeblk.c~a
> +++ a/drivers/block/aoe/aoeblk.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/hdreg.h>
>  #include <linux/blkdev.h>
> +#include <linux/backing-dev.h>
>  #include <linux/fs.h>
>  #include <linux/ioctl.h>
>  #include <linux/genhd.h>
> @@ -228,6 +229,7 @@ aoeblk_gdalloc(void *vp)
>  
>  	spin_lock_irqsave(&d->lock, flags);
>  	blk_queue_make_request(&d->blkq, aoeblk_make_request);
> +	bdi_init(&d->blkq.backing_dev_info);
>  	gd->major = AOE_MAJOR;
>  	gd->first_minor = d->sysminor * AOE_PARTITIONS;
>  	gd->fops = &aoe_bdops;
> _
> 
> 
> <wonders whether blk_queue_make_request() should be running bdi_init()?>

No, the behavior doesn't change with this patch applied.

Meanwhile I have started a git bisect, and hopefully that will turn up
a specific patch before I hit an unbootable kernel or get my machine
in a state where it won't boot.

-- 
  Ed L Cashin <ecashin@coraid.com>
