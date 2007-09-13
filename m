Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbXIMITI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbXIMITI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXIMISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:18:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52264 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXIMISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:18:53 -0400
Date: Thu, 13 Sep 2007 02:18:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Blackfin arch: add some missing syscall
Message-ID: <20070913081852.GC17367@parisc-linux.org>
References: <1189670203.30686.15.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189670203.30686.15.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:56:43PM +0800, Bryan Wu wrote:
> +/* Not relevant on no-mmu */

I thought this list seemed a little long, so I investigated a couple
of them.  mbind makes sense (it's only implemented for NUMA ... a NUMA
embedded platform?  not the kind which runs applications that use mbind),
but mremap doesn't -- there's even an implementation in mm/nommu.c.
Could you check the rest of these over to see if they truly don't need
to be implemented for no-mmu?  I think you'll want the *robust_list
syscalls too.

> +#define __IGNORE_swapon
> +#define __IGNORE_swapoff
> +#define __IGNORE_msync
> +#define __IGNORE_mlock
> +#define __IGNORE_munlock
> +#define __IGNORE_mlockall
> +#define __IGNORE_munlockall
> +#define __IGNORE_mremap
> +#define __IGNORE_mincore
> +#define __IGNORE_madvise
> +#define __IGNORE_remap_file_pages
> +#define __IGNORE_mbind
> +#define __IGNORE_get_mempolicy
> +#define __IGNORE_set_mempolicy
> +#define __IGNORE_migrate_pages
> +#define __IGNORE_set_robust_list
> +#define __IGNORE_get_robust_list
> +#define __IGNORE_move_pages
> +#define __IGNORE_getcpu

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
