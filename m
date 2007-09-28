Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXI1SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXI1SqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXI1SqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:46:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbXI1SqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:46:10 -0400
Date: Fri, 28 Sep 2007 11:45:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] hugetlb: Fix clear_user_highpage arguments
Message-Id: <20070928114526.3398c462.akpm@linux-foundation.org>
In-Reply-To: <20070928163545.GA5933@linux-mips.org>
References: <20070928163545.GA5933@linux-mips.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 17:35:45 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> The virtual address space argument of clear_user_highpage is supposed to
> be the virtual address where the page being cleared will eventually be
> mapped. This allows architectures with virtually indexed caches a few
> clever tricks.  That sort of trick falls over in painful ways if the
> virtual address argument is wrong.

yeah, but only if you're using a weird CPU architecture ;)

> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 84c795e..eab8c42 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -42,7 +42,7 @@ static void clear_huge_page(struct page *page, unsigned long addr)
>  	might_sleep();
>  	for (i = 0; i < (HPAGE_SIZE/PAGE_SIZE); i++) {
>  		cond_resched();
> -		clear_user_highpage(page + i, addr);
> +		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
>  	}
>  }
>  

I'll add this to the 2.6.23 queue.  Is it needed in 2.6.22.x?
