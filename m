Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYKELgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYKELgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 06:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKELgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 06:36:25 -0500
Received: from www.tglx.de ([62.245.132.106]:48886 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYKELgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:36:24 -0500
Date: Wed, 5 Nov 2008 12:36:11 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Message-ID: <20081105113610.GA6382@local>
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seem to be archs that cannot easily implement a sensible
pgprot_noncached() function, so we should merge this patch. UIO doesn't
compile on these archs right now.

Thanks,
Hans

On Wed, Oct 29, 2008 at 01:26:17PM -0400, Mike Frysinger wrote:
> Not all arches support pgprot_noncached (like the Blackfin port).  Other
> drivers seem to handle this by checking to see if it is defined, so let's
> do that in the UIO driver as well.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

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
