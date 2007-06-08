Return-Path: <linux-kernel-owner+w=401wt.eu-S971258AbXFHWay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971258AbXFHWay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032326AbXFHWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:30:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57585 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032319AbXFHWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:30:12 -0400
Date: Fri, 8 Jun 2007 15:30:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 06/10] Intel IOMMU driver
In-Reply-To: <20070607165739.dc437e96.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706081527160.3966@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.823168000@askeshav-devel.jf.intel.com>
 <20070607165739.dc437e96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Andrew Morton wrote:

> > +void *iommu_rpool_alloc(unsigned int size, gfp_t flag)
> > +{
> > +	if (size == PAGE_SIZE_4K)
> > +		return(void *)get_zeroed_page(flag);
> > +	else
> > +		return kzalloc(size, flag);
> > +}
> 
> kmalloc(4k) is pretty efficient and (I think) is guaranteed to return a
> page-aligned address.

Page allocations should be done through the page allocator. 4k 
allocations benefit from the per cpu caches of the page allocator which 
makes the use of the page allocator fastest and best for 4k allocs.

kmalloc allocations are not guaranteed to be aligned to 4k boundaries. 
They usually are but ...


