Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXKOWQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXKOWQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbXKOWQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:16:30 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50324 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbXKOWQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:16:29 -0500
Subject: Re: [RFC 5/7] LTTng instrumentation mm
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071115215142.GA7825@Krystal>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost>
	 <20071115215142.GA7825@Krystal>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 14:16:17 -0800
Message-Id: <1195164977.27759.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-15 at 16:51 -0500, Mathieu Desnoyers wrote:
> * Dave Hansen (haveblue@us.ibm.com) wrote:
> > > On Tue, 2007-11-13 at 14:33 -0500, Mathieu Desnoyers wrote:
> > >  linux-2.6-lttng/mm/page_io.c        2007-11-13 09:49:35.000000000 -0500
> > > @@ -114,6 +114,7 @@ int swap_writepage(struct page *page, st
> > >                 rw |= (1 << BIO_RW_SYNC);
> > >         count_vm_event(PSWPOUT);
> > >         set_page_writeback(page);
> > > +       trace_mark(mm_swap_out, "address %p", page_address(page));
> > >         unlock_page(page);
> > >         submit_bio(rw, bio);
> > >  out:
> > 
> > I'm not sure all this page_address() stuff makes any sense on highmem
> > systems.  How about page_to_pfn()?
>
> Knowing which page frame number has been swapped out is not always as
> relevant as knowing the page's virtual address (when it has one). Saving
> both the PFN and the page's virtual address could give us useful
> information when the page is not mapped.

For most (all?) architectures, the PFN and the virtual address in the
kernel's linear are interchangeable with pretty trivial arithmetic.  All
pages have a pfn, but not all have a virtual address.  Thus, I suggested
using the pfn.  What kind of virtual addresses are you talking about?

-- Dave

