Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbXFMTEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbXFMTEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXFMTEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:04:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:43447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbXFMTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:04:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Wed, 13 Jun 2007 21:04:02 +0200
User-Agent: KMail/1.9.6
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
References: <200706090056.49279.ak@suse.de> <466DFD22.5080303@linux.intel.com> <20070613184011.GK11166@waste.org>
In-Reply-To: <20070613184011.GK11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132104.02884.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 20:40:11 Matt Mackall wrote:
> On Mon, Jun 11, 2007 at 06:55:46PM -0700, Arjan van de Ven wrote:
> > Andrew Morton wrote:
> > >On Mon, 11 Jun 2007 18:10:40 -0700 Arjan van de Ven 
> > ><arjan@linux.intel.com> wrote:
> > >
> > >>Andrew Morton wrote:
> > >>>>Where as resource pool is exactly opposite of mempool, where each 
> > >>>>time it looks for an object in the pool and if it exist then we 
> > >>>>return that object else we try to get the memory for OS while 
> > >>>>scheduling the work to grow the pool objects. In fact, the  work
> > >>>>is schedule to grow the pool when the low threshold point is hit.
> > >>>I realise all that.  But I'd have thought that the mempool approach is
> > >>>actually better: use the page allocator and only deplete your reserve 
> > >>>pool
> > >>>when the page allocator fails.
> > >>the problem with that is that if anything downstream from the iommu 
> > >>layer ALSO needs memory, we've now eaten up the last free page and 
> > >>things go splat.
> > >
> > >If that happens, we still have the mempool reserve to fall back to.
> > 
> > we do, except that we just ate the memory the downstream code would 
> > use and get ... so THAT can't get any.
> 
> Then the downstream ought to be using a mempool?

Normally there shouldn't be a downstream. PCI IO tends to be not stacked,
but at the edges  (unless you're talking hypervisors with virtual devices but those 
definitely have separate memory pools). And the drivers I'm familiar with tend to 
first grab whatever resources they need and then map the DMA mappings.

-Andi
