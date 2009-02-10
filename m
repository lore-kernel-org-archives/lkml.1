Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZBJWou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZBJWou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZBJWol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:44:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36824 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZBJWol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:44:41 -0500
Date: Tue, 10 Feb 2009 22:44:37 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Chris Clayton <chris2553@googlemail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] hugetlbfs: fix build failure with !CONFIG_HUGETLBFS
Message-ID: <20090210224436.GA10019@csn.ul.ie>
References: <c6b1100b0902101353q2c5ad750t2a901de97dc5fe5@mail.gmail.com> <tkrat.a79dcd647f8ae43e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <tkrat.a79dcd647f8ae43e@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 11:27:32PM +0100, Stefan Richter wrote:
> Fix regression due to 5a6fe125950676015f5108fb71b2a67441755003,
> "Do not account for the address space used by hugetlbfs using VM_ACCOUNT"
> which added an argument to the function hugetlb_file_setup() but not to
> the macro hugetlb_file_setup().
> 

/me slaps self

> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Confirmed that it's a problem and this fixes it. Thanks

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
>  include/linux/hugetlb.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index af09660..03be7f2 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -159,9 +159,9 @@ static inline void set_file_hugepages(struct file *file)
>  }
>  #else /* !CONFIG_HUGETLBFS */
>  
> -#define is_file_hugepages(file)		0
> -#define set_file_hugepages(file)	BUG()
> -#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
> +#define is_file_hugepages(file)			0
> +#define set_file_hugepages(file)		BUG()
> +#define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)
>  
>  #endif /* !CONFIG_HUGETLBFS */
>  
> -- 
> 1.6.0.6
> 
> 
> -- 
> Stefan Richter
> -=====-==--= --=- -=-=-
> http://arcgraph.de/sr/
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
