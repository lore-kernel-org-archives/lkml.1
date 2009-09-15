Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZIOX7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZIOX7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZIOX7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:59:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:23707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZIOX7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,393,1249282800"; 
   d="scan'208";a="188060731"
Date: Wed, 16 Sep 2009 07:59:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] hwpoison: fix uninitialized warning
Message-ID: <20090915235901.GB6431@localhost>
References: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 05:19:07AM +0800, Hugh Dickins wrote:
> Fix mmotm build warning, presumably also in linux-next:
> mm/memory.c: In function `do_swap_page':
> mm/memory.c:2498: warning: `pte' may be used uninitialized in this function

Thanks for the fix!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> I've only noticed this warning on one machine, the powerpc: certainly it
> needs CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE to see it, but I thought
> I had one of those set on other machines - just musing in case it's being
> masked elsewhere by some other bug...
> 
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- mmotm/mm/memory.c	2009-09-14 16:34:37.000000000 +0100
> +++ linux/mm/memory.c	2009-09-15 22:00:48.000000000 +0100
> @@ -2495,7 +2495,7 @@ static int do_swap_page(struct mm_struct
>  		} else if (is_hwpoison_entry(entry)) {
>  			ret = VM_FAULT_HWPOISON;
>  		} else {
> -			print_bad_pte(vma, address, pte, NULL);
> +			print_bad_pte(vma, address, orig_pte, NULL);
>  			ret = VM_FAULT_OOM;
>  		}
>  		goto out;
