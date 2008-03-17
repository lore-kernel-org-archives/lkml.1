Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYCQUab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYCQUab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYCQUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:30:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38770 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbYCQUaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:30:09 -0400
Subject: Re: [PATCH] [10/18] Factor out new huge page preparation code into
	separate function
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au, agl <agl@linux.vnet.ibm.com>
In-Reply-To: <20080317015824.074A31B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	 <20080317015824.074A31B41E0@basil.firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 17 Mar 2008 15:31:53 -0500
Message-Id: <1205785913.10849.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 02:58 +0100, Andi Kleen wrote:
> Index: linux/mm/hugetlb.c
> ===================================================================
> --- linux.orig/mm/hugetlb.c
> +++ linux/mm/hugetlb.c
> @@ -200,6 +200,17 @@ static int adjust_pool_surplus(struct hs
>  	return ret;
>  }
> 
> +static void huge_new_page(struct hstate *h, struct page *page)
> +{
> +	unsigned nid = pfn_to_nid(page_to_pfn(page));
> +	set_compound_page_dtor(page, free_huge_page);
> +	spin_lock(&hugetlb_lock);
> +	h->nr_huge_pages++;
> +	h->nr_huge_pages_node[nid]++;
> +	spin_unlock(&hugetlb_lock);
> +	put_page(page); /* free it into the hugepage allocator */
> +}
> +
>  static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
>  {
>  	struct page *page;

We do not usually preface functions in mm/hugetlb.c with "huge" and the
name you have chosen doesn't seem that clear to me anyway.  Could we
rename it to prep_new_huge_page() or something similar?

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

