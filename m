Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXFKVaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXFKVaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXFKV36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:29:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47166 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbXFKV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:29:58 -0400
Date: Mon, 11 Jun 2007 14:29:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070611204442.GA4074@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706111428410.20454@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
 <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Keshavamurthy, Anil S wrote:

> Hence, can I assume that the conclusion of this 
> discussion is to use kmem_cache_alloc() functions 
> to allocate memory in dma_map_{single|sg} API's?


Use the page allocator for page size allocations. If you need to have 
specially aligned memory in less than page sized chunks then use 
kmem_cache_alloc with a specially configured slab.
> 
> Again, if dma_map_{single|sg} API's fails due to 
> failure to allocate memory, the only thing that can
> be done is to panic as this is what few of the other 
> IOMMU implementation is doing today. 

Why does it have to be so severe? The I/O operation fails right?

