Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXFZGdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXFZGdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXFZGdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:33:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXFZGdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:33:14 -0400
Date: Mon, 25 Jun 2007 23:32:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-Id: <20070625233249.c17c41c3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.716432000@askeshav-devel.jf.intel.com>
	<Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 16:32:23 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> > +static inline void *alloc_pgtable_page(void)
> > +{
> > +	return (void *)get_zeroed_page(GFP_ATOMIC);
> > +}
> 
> Need to pass gfp_t parameter. Repeates a couple of times.
> ...
> Is it not possible here to drop the lock and do the alloc with GFP_KERNEL 
> and deal with the resulting race? That is done in other parts of the 
> kernel.
> ...
> This may be able to become a GFP_KERNEL alloc since interrupts are enabled 
> at this point?
> ...
> GFP_KERNEL alloc possible?
> 

Yeah, if there are any callsites at all at which we know that we can
perform a sleeping allocation, Christoph's suggestions should be adopted. 
Because even a bare GFP_NOIO is heaps more robust than GFP_ATOMIC, and it
will also reload the free-pages reserves, making subsequent GFP_ATOMIC
allocations more likely to succeed.

