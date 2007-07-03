Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbXGCBis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbXGCBis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 21:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXGCBik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 21:38:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53668 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201AbXGCBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 21:38:40 -0400
Message-ID: <4689A691.9090908@vmware.com>
Date: Mon, 02 Jul 2007 18:29:53 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/5] remove ptep_test_and_clear_dirty and ptep_clear_flush_dirty.
References: <20070629135530.912094590@de.ibm.com> <20070629141528.060235678@de.ibm.com>
In-Reply-To: <20070629141528.060235678@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> Nobody is using ptep_test_and_clear_dirty and ptep_clear_flush_dirty.
> Remove the functions from all architectures.
>
>
> -static inline int
> -ptep_test_and_clear_dirty (struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
> -{
> -#ifdef CONFIG_SMP
> -	if (!pte_dirty(*ptep))
> -		return 0;
> -	return test_and_clear_bit(_PAGE_D_BIT, ptep);
> -#else
> -	pte_t pte = *ptep;
> -	if (!pte_dirty(pte))
> -		return 0;
> -	set_pte_at(vma->vm_mm, addr, ptep, pte_mkclean(pte));
> -	return 1;
> -#endif
> -}

I've not followed all the changes lately - what is the current protocol 
for clearing dirty bit?  Is it simply pte_clear followed by set or is it 
not done at all?  At least for i386 and virtualization, we had several 
optimizations to the test_and_clear path that are not possible with a 
pte_clear / set_pte approach.

Zach
