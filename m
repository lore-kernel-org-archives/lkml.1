Return-Path: <linux-kernel-owner+w=401wt.eu-S2992572AbXCWVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992572AbXCWVKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992573AbXCWVKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:10:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:54270 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992572AbXCWVKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:10:50 -0400
Subject: Re: [patch] rfc: introduce /dev/hugetlb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ken Chen <kenchen@google.com>
Cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 08:08:54 +1100
Message-Id: <1174684134.10836.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
> -unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
> -		unsigned long len, unsigned long pgoff, unsigned long flags);
> -#else
> -static unsigned long
> +unsigned long
>  hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags)
>  {
> @@ -150,7 +145,6 @@ full_search:
>  		addr = ALIGN(vma->vm_end, HPAGE_SIZE);
>  	}
>  }
> -#endif

WTF ? get_unmapped_area() -has- to be arch in some platforms like
power...

I'm trying to improve the whole get_unmapped_area() to better handle
multiple constraints (cacheability, page size, ...) though I haven't
quite yet settled on an interface I like.

Ben.


