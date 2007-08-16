Return-Path: <linux-kernel-owner+w=401wt.eu-S937569AbXHPCvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937569AbXHPCvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763471AbXHPCvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:51:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760089AbXHPCvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:51:01 -0400
Date: Thu, 16 Aug 2007 04:50:58 +0200
From: Nick Piggin <npiggin@suse.de>
To: Adam Litke <agl@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] Fix VM_FAULT flags conversion for hugetlb
Message-ID: <20070816025057.GB16372@wotan.suse.de>
References: <1187120481.14625.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187120481.14625.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 02:41:21PM -0500, Adam Litke wrote:
> It seems a simple mistake was made when converting follow_hugetlb_page()
> over to the VM_FAULT flags bitmask stuff:
> 	(commit  83c54070ee1a2d05c89793884bea1a03f2851ed4).
> 
> By using the wrong bitmask, hugetlb_fault() failures are not being
> recognized.  This results in an infinite loop whenever
> follow_hugetlb_page is involved in a failed fault.
> 
> Signed-off-by: Adam Litke <agl@us.ibm.com>

Thanks Adam. Looks good.

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d7ca59d..de4cf45 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -643,7 +643,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  			spin_unlock(&mm->page_table_lock);
>  			ret = hugetlb_fault(mm, vma, vaddr, 0);
>  			spin_lock(&mm->page_table_lock);
> -			if (!(ret & VM_FAULT_MAJOR))
> +			if (!(ret & VM_FAULT_ERROR))
>  				continue;
>  
>  			remainder = 0;
> 
> -- 
> Adam Litke - (agl at us.ibm.com)
> IBM Linux Technology Center
