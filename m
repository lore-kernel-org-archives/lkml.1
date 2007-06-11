Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXFKVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXFKVoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXFKVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:44:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:40813 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbXFKVn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:43:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="253227100"
Date: Mon, 11 Jun 2007 14:40:04 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611214004.GA19162@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com> <Pine.LNX.4.64.0706111428410.20454@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706111428410.20454@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 02:29:56PM -0700, Christoph Lameter wrote:
> On Mon, 11 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> > Hence, can I assume that the conclusion of this 
> > discussion is to use kmem_cache_alloc() functions 
> > to allocate memory in dma_map_{single|sg} API's?
> 
> 
> Use the page allocator for page size allocations. If you need to have 
> specially aligned memory in less than page sized chunks then use 
> kmem_cache_alloc with a specially configured slab.

Okay, will do this change and get back to the list.


> > 
> > Again, if dma_map_{single|sg} API's fails due to 
> > failure to allocate memory, the only thing that can
> > be done is to panic as this is what few of the other 
> > IOMMU implementation is doing today. 
> 
> Why does it have to be so severe? The I/O operation fails right?
Not sure. Also most of the callers today don;t check for failures.

-Anil
