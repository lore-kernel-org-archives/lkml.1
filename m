Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXKLOl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXKLOl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKLOkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:40:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50837 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXKLOka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:40:30 -0500
Subject: Re: [PATCH] mm/memory.c follow_hugetlb_page compiler error (MMOTM)
From: aglitke <agl@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Ken Chen <kenchen@google.com>, David Gibson <hermes@gibson.dropbear.id.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200711110054.lAB0spwl017395@agora.fsl.cs.sunysb.edu>
References: <200711110054.lAB0spwl017395@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Organization: IBM
Date: Mon, 12 Nov 2007 08:41:55 -0600
Message-Id: <1194878515.14675.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Argh.  Who runs with CONFIG_HUGETLB_PAGE not set anyway ;)

Acked-by: Adam Litke <agl@us.ibm.com>

On Sat, 2007-11-10 at 19:54 -0500, Erez Zadok wrote:
> Using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
> 22:46". CONFIG_HUGETLB_PAGE not set.
> 
> $ make
>   CC      mm/memory.o
> mm/memory.c:1040:29: error: macro "follow_hugetlb_page" passed 8 arguments, but takes just 7
> mm/memory.c: In function 'get_user_pages':
> mm/memory.c:1039: error: 'follow_hugetlb_page' undeclared (first use in this function)
> mm/memory.c:1039: error: (Each undeclared identifier is reported only once
> mm/memory.c:1039: error: for each function it appears in.)
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
> 
> Small patch below fixes compile error.
> 
> Erez.
> 
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index bb03660..2496879 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -106,7 +106,7 @@ static inline unsigned long hugetlb_total_pages(void)
>  	return 0;
>  }
> 
> -#define follow_hugetlb_page(m,v,p,vs,a,b,i)	({ BUG(); 0; })
> +#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
>  #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
>  #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
>  #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
> 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

