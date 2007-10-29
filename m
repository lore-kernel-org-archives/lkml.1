Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXJ2SFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXJ2SFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXJ2SF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:05:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758720AbXJ2SF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:05:27 -0400
Date: Mon, 29 Oct 2007 11:07:39 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
Message-ID: <20071029180739.GA17595@kroah.com>
References: <20071029175014.GH7793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029175014.GH7793@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:50:14PM -0400, Dave Jones wrote:
> We've had a number of people reporting that their x86-64s stopped booting
> when they moved to 2.6.23.  It rebooted just after discovering the AGP bridge
> as a result of the IOMMU init.
> 
> Martin tracked this down to the following commit.
> 
> 
> commit 2e1c49db4c640b35df13889b86b9d62215ade4b6
> Author: Zou Nan hai <nanhai.zou@intel.com>
> Date:   Fri Jun 1 00:46:28 2007 -0700
> 
>     x86_64: allocate sparsemem memmap above 4G
>     
>     On systems with huge amount of physical memory, VFS cache and memory memmap
>     may eat all available system memory under 4G, then the system may fail to
>     allocate swiotlb bounce buffer.
>     
>     There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
>     not cover sparsemem model.
>     
>     This patch add fix to sparsemem model by first try to allocate memmap above
>     4G.
>     
>     Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
>     Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Cc: Andi Kleen <ak@suse.de>
>     Cc: <stable@kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> This should be probably be reverted for 2.6.23-stable, and either fixed
> properly in .24, or reverted there too.

I'll be glad to revert it in -stable, if it's also reverted in Linus's
tree first :)

thanks,

greg k-h
