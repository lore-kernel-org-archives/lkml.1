Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYJ2UyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYJ2UyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYJ2UyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:54:03 -0400
Received: from www.tglx.de ([62.245.132.106]:58860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYJ2UyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:54:02 -0400
Date: Wed, 29 Oct 2008 21:53:47 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Message-ID: <20081029205347.GC2951@local>
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 01:26:17PM -0400, Mike Frysinger wrote:
> Not all arches support pgprot_noncached (like the Blackfin port). 

These archs have it (just a quick grep, might be incomplete):
x86, sh, alpha, powerpc, ia64, sparc, sparc64, mips, avr32, arm, parisc.

That's 11 archs _with_ pgprot_noncached(). Might be a good idea to add
that macro to blackfin, too.

> Other
> drivers seem to handle this by checking to see if it is defined,

That statement made me curious. I greped around for a while, but the
only driver that does this check is drivers/char/mem.c, while there are
22 drivers that use pgprot_noncached() without checking.

> so let's do that in the UIO driver as well.

Well, your patch is surely OK and will work, but I've got some
difficulties to understand why you prefer patching an ugly #ifdef into up
to 22 drivers instead of just defining that simple macro in your arch,
like many of the others already did. But maybe I missed the point
here, could you please elaborate a bit?

Thanks,
Hans

> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/uio/uio.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index f9b4647..c43dbea 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -529,7 +529,9 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
>  
>  	vma->vm_flags |= VM_IO | VM_RESERVED;
>  
> +#ifdef pgprot_noncached
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +#endif
>  
>  	return remap_pfn_range(vma,
>  			       vma->vm_start,
> -- 
> 1.6.0.2
