Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXK2Cef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXK2Cef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXK2CeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:34:25 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:45125 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXK2CeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:34:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEa0TUdMROHU/2dsb2JhbACBWw
Date: Wed, 28 Nov 2007 21:34:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC PATCH] LTTng instrumentation mm (using page_to_pfn)
Message-ID: <20071129023421.GA711@Krystal>
References: <20071113193349.214098508@polymtl.ca> <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost> <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost> <20071116143019.GA16082@Krystal> <1195495485.27759.115.camel@localhost> <20071128140953.GA8018@Krystal> <1196268856.18851.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1196268856.18851.20.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:32:13 up 25 days,  7:37,  5 users,  load average: 0.87, 0.69,
	0.78
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am adding the rest.. two questions left :

* Dave Hansen (haveblue@us.ibm.com) wrote:
 
> > 
> > Index: linux-2.6-lttng/mm/memory.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/memory.c	2007-11-28 08:42:09.000000000 -0500
> > +++ linux-2.6-lttng/mm/memory.c	2007-11-28 09:02:57.000000000 -0500
> > @@ -2072,6 +2072,7 @@ static int do_swap_page(struct mm_struct
> >  	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
> >  	page = lookup_swap_cache(entry);
> >  	if (!page) {
> > +		trace_mark(mm_swap_in, "pfn %lu", page_to_pfn(page));
> >  		grab_swap_token(); /* Contend for token _before_ read-in */
> >   		swapin_readahead(entry, address, vma);
> >   		page = read_swap_cache_async(entry, vma, address);
> 
> How about putting the swap file number and the offset as well?
> 
[...]
> > Index: linux-2.6-lttng/mm/page_io.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/page_io.c	2007-11-28 08:38:47.000000000 -0500
> > +++ linux-2.6-lttng/mm/page_io.c	2007-11-28 08:52:14.000000000 -0500
> > @@ -114,6 +114,7 @@ int swap_writepage(struct page *page, st
> >  		rw |= (1 << BIO_RW_SYNC);
> >  	count_vm_event(PSWPOUT);
> >  	set_page_writeback(page);
> > +	trace_mark(mm_swap_out, "pfn %lu", page_to_pfn(page));
> >  	unlock_page(page);
> >  	submit_bio(rw, bio);
> 
> I'd also like to see the swap file number and the location in swap for
> this one.  
> 

Before I start digging deeper in checking whether it is already
instrumented by the fs instrumentation (and would therefore be
redundant), is there a particular data structure from mm/ that you
suggest taking the swap file number and location in swap from ?

Mathieu

> -- Dave
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
