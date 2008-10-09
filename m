Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYJICRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYJICRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYJICRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:17:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55561 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYJICRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:17:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       akpm@linux-foundation.org, dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081008213831.GA23729@x200.localdomain>
References: <1223052415-18956-2-git-send-email-mel@csn.ul.ie> <20081008213831.GA23729@x200.localdomain>
Message-Id: <20081009104014.DEBD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 11:16:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > It is useful to verify a hugepage-aware application is using the expected
> > pagesizes for its memory regions. This patch creates an entry called
> > KernelPageSize in /proc/pid/smaps that is the size of page used by the
> > kernel to back a VMA. The entry is not called PageSize as it is possible
> > the MMU uses a different size. This extension should not break any sensible
> > parser that skips lines containing unrecognised information.
> 
> > +		   "KernelPageSize: %8lu kB\n",
> 
> > +unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> > +{
> > +	struct hstate *hstate;
> > +
> > +	if (!is_vm_hugetlb_page(vma))
> > +		return PAGE_SIZE;
> > +
> > +	hstate = hstate_vma(vma);
> > +	VM_BUG_ON(!hstate);
> > +
> > +	return 1UL << (hstate->order + PAGE_SHIFT);
> 			    ^^^^
> VM_BUG_ON is unneeded because kernel will oops here if hstate is NULL.

yup.


> Also, in /proc/*/maps it's printed only for hugetlb vmas and called
> hpagesize, in smaps it's printed for every vma and called
> KernelPageSize. All of this is inconsistent.

Is this a problem?
/proc/*/maps and /proc/*/smaps are different purpose file.

/proc/*/maps:  summary & suppressed information & easy readable
/proc/*/smaps: verbose output

Already some information output only smaps.


> And app will verify once that hugepages are of right size, so Pss cost
> argument for changing /proc/*/maps seems weak to me.

sorry, I don't understand yet.
Why pss cost changed?



