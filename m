Return-Path: <linux-kernel-owner+w=401wt.eu-S1764559AbYCEHxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764559AbYCEHxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbYCEHxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:53:00 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:45903 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759910AbYCEHw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:52:58 -0500
Message-ID: <47CE5155.5000009@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 13:22:53 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080227)
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, apw@shadowen.org, balbir@linux.vnet.ibm.com
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel bug while running libhugetlbfs
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CDA0F1.9030908@linux.vnet.ibm.com> <20080304115158.505f33eb.akpm@linux-foundation.org> <1204668089.14779.92.camel@localhost.localdomain>
In-Reply-To: <1204668089.14779.92.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
> On Tue, 2008-03-04 at 11:51 -0800, Andrew Morton wrote:
>> hugetlb-correct-page-count-for-surplus-huge-pages.patch adds:
>>
>>         if (page) {
>>                 /*
>>                  * This page is now managed by the hugetlb allocator and has
>>                  * no users -- drop the buddy allocator's reference.
>>                  */
>>                 int page_count = put_page_testzero(page);
>>                 BUG_ON(page_count != 0);
>>
>>
> 
> Ugh I got bitten by put_page_testzero().  When it returns 1, the page
> count is zero (not the page count).
> 
> My initial version had a BUG_ON() with side-effects.  When a reviewer
> pointed it out, I thought I could fix the patch up on its way out the
> door.  I have self-administered my punishment.  This patch will fix it:
Hi Adam,

Thanks the patch fixes the kernel bug while running the libhugetlbfs test.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

> 
> Signed-off-by: Adam Litke <agl@us.ibm.com>
> 
> --- mm/hugetlb.c.orig	2008-03-04 13:36:30.000000000 -0800
> +++ mm/hugetlb.c	2008-03-04 13:39:30.000000000 -0800
> @@ -291,8 +291,8 @@ static struct page *alloc_buddy_huge_pag
>  		 * This page is now managed by the hugetlb allocator and has
>  		 * no users -- drop the buddy allocator's reference.
>  		 */
> -		int page_count = put_page_testzero(page);
> -		BUG_ON(page_count != 0);
> +		put_page_testzero(page);
> +		VM_BUG_ON(page_count(page));
>  		nid = page_to_nid(page);
>  		set_compound_page_dtor(page, free_huge_page);
>  		/*
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
