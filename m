Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXKPOrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXKPOrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXKPOrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:47:47 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:34845 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbXKPOrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:47:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAG48PUdMROHU/2dsb2JhbACBX457
Date: Fri, 16 Nov 2007 09:47:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC 5/7] LTTng instrumentation mm
Message-ID: <20071116144742.GA17255@Krystal>
References: <20071113193349.214098508@polymtl.ca> <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost> <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1195164977.27759.10.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:44:42 up 12 days, 19:50,  6 users,  load average: 0.22, 1.44,
	1.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> On Thu, 2007-11-15 at 16:51 -0500, Mathieu Desnoyers wrote:
> > * Dave Hansen (haveblue@us.ibm.com) wrote:
> > > > On Tue, 2007-11-13 at 14:33 -0500, Mathieu Desnoyers wrote:
> > > >  linux-2.6-lttng/mm/page_io.c        2007-11-13 09:49:35.000000000 -0500
> > > > @@ -114,6 +114,7 @@ int swap_writepage(struct page *page, st
> > > >                 rw |= (1 << BIO_RW_SYNC);
> > > >         count_vm_event(PSWPOUT);
> > > >         set_page_writeback(page);
> > > > +       trace_mark(mm_swap_out, "address %p", page_address(page));
> > > >         unlock_page(page);
> > > >         submit_bio(rw, bio);
> > > >  out:
> > > 
> > > I'm not sure all this page_address() stuff makes any sense on highmem
> > > systems.  How about page_to_pfn()?
> >
> > Knowing which page frame number has been swapped out is not always as
> > relevant as knowing the page's virtual address (when it has one). Saving
> > both the PFN and the page's virtual address could give us useful
> > information when the page is not mapped.
> 
> For most (all?) architectures, the PFN and the virtual address in the
> kernel's linear are interchangeable with pretty trivial arithmetic.  All
> pages have a pfn, but not all have a virtual address.  Thus, I suggested
> using the pfn.  What kind of virtual addresses are you talking about?
> 

Hrm, in asm-generic/memory_model.h, we have various versions of
__page_to_pfn. Normally they all cast the result to (unsigned long),
except for :


#elif defined(CONFIG_SPARSEMEM_VMEMMAP)

/* memmap is virtually contigious.  */
#define __pfn_to_page(pfn)      (vmemmap + (pfn))
#define __page_to_pfn(page)     ((page) - vmemmap)

So I guess the result is a pointer ? Should this be expected ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
