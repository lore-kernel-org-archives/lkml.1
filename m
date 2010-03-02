Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab0CBFWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:22:51 -0500
Received: from ip-85-161-92-63.eurotel.cz ([85.161.92.63]:37147 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822Ab0CBFWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:22:50 -0500
Date: Tue, 2 Mar 2010 06:22:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: pmem: fix some code style issues
Message-ID: <20100302052244.GC13798@elf.ucw.cz>
References: <1267487415-22061-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267487415-22061-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-01 20:50:15, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like some braces {} deleted becouse
> are not necessary for a single statement blocks and to include KERN_
> facility level in the printk() functions.

Most of patch is good, but...

> @@ -936,8 +934,8 @@ int pmem_remap(struct pmem_region *region, struct file *file,
>  	if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
>  		 !PMEM_IS_PAGE_ALIGNED(region->len))) {
>  #if PMEM_DEBUG
> -		printk("pmem: request for unaligned pmem suballocation "
> -		       "%lx %lx\n", region->offset, region->len);
> +		printk(KERN_ERR "pmem: request for unaligned pmem "
> +			"suballocation %lx %lx\n", region->offset, region->len);
>  #endif
>  		return -EINVAL;
>  	}

This is strange. If it is debuging print, should it be KERN_DEBUG? And
we have nice dev_dbg macros for just that, so that ifdef is not
neccessarry.

> @@ -1087,8 +1085,10 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  				region.offset = pmem_start_addr(id, data);
>  				region.len = pmem_len(id, data);
>  			}
> -			printk(KERN_INFO "pmem: request for physical address of pmem region "
> -					"from process %d.\n", current->pid);
> +			printk(KERN_INFO "pmem: request for physical address "
> +					"of pmem region from process %d.\n",
> +								current->pid);
> +

And this gets code worse, not better.

(Feel free to send all the other hunks with my ACK.)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
