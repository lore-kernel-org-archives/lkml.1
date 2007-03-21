Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXCUPRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXCUPRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXCUPRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:17:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58043 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXCUPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:17:44 -0400
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
	helper macros.
From: Adam Litke <agl@us.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <4600B216.3010505@yahoo.com.au>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
	 <20070319200513.17168.52238.stgit@localhost.localdomain>
	 <4600B216.3010505@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 10:17:40 -0500
Message-Id: <1174490261.21684.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 15:18 +1100, Nick Piggin wrote:
> Adam Litke wrote:
> > Signed-off-by: Adam Litke <agl@us.ibm.com>
> > ---
> > 
> >  include/linux/mm.h |   25 +++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 60e0e4a..7089323 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -98,6 +98,7 @@ struct vm_area_struct {
> >  
> >  	/* Function pointers to deal with this struct. */
> >  	struct vm_operations_struct * vm_ops;
> > +	const struct pagetable_operations_struct * pagetable_ops;
> >  
> >  	/* Information about our backing store: */
> >  	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
> 
> Can you remind me why this isn't in vm_ops?

We didn't want to bloat the size of the vm_ops struct for all of its
users.

> Also, it is going to be hugepage-only, isn't it? So should the naming be
> changed to reflect that? And #ifdef it...

They are doing some interesting things on Cell that could take advantage
of this.

> > @@ -218,6 +219,30 @@ struct vm_operations_struct {
> >  };
> >  
> >  struct mmu_gather;
> > +
> > +struct pagetable_operations_struct {
> > +	int (*fault)(struct mm_struct *mm,
> > +		struct vm_area_struct *vma,
> > +		unsigned long address, int write_access);
> 
> I got dibs on fault ;)
> 
> My callback is a sanitised one that basically abstracts the details of the
> virtual memory mapping away, so it is usable by drivers and filesystems.
> 
> You actually want to bypass the normal fault handling because it doesn't
> know how to deal with your virtual memory mapping. Hmm, the best suggestion
> I can come up with is handle_mm_fault... unless you can think of a better
> name for me to use.

How about I use handle_pte_fault?

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

