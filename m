Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXFZQdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXFZQdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbXFZQdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:33:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXFZQdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="100311301"
Date: Tue, 26 Jun 2007 09:29:09 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-ID: <20070626162909.GD3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.716432000@askeshav-devel.jf.intel.com> <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com> <20070625233249.c17c41c3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625233249.c17c41c3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:32:49PM -0700, Andrew Morton wrote:
> On Tue, 19 Jun 2007 16:32:23 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:
> > 
> > > +static inline void *alloc_pgtable_page(void)
> > > +{
> > > +	return (void *)get_zeroed_page(GFP_ATOMIC);
> > > +}
> > 
> > Need to pass gfp_t parameter. Repeates a couple of times.
> > ...
> > Is it not possible here to drop the lock and do the alloc with GFP_KERNEL 
> > and deal with the resulting race? That is done in other parts of the 
> > kernel.
> > ...
> > This may be able to become a GFP_KERNEL alloc since interrupts are enabled 
> > at this point?
> > ...
> > GFP_KERNEL alloc possible?
> > 
> 
> Yeah, if there are any callsites at all at which we know that we can
> perform a sleeping allocation, Christoph's suggestions should be adopted. 
> Because even a bare GFP_NOIO is heaps more robust than GFP_ATOMIC, and it
> will also reload the free-pages reserves, making subsequent GFP_ATOMIC
> allocations more likely to succeed.
Yup, will do as part of making this code work for IA64, which is my next
item in my todo list.

-Anil
