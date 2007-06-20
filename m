Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXFTRfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXFTRfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXFTRfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:35:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:11540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbXFTRfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,443,1175497200"; 
   d="scan'208";a="241351820"
Date: Wed, 20 Jun 2007 10:30:38 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma	map api calls
Message-ID: <20070620173038.GA25516@linux-os.sc.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.798646000@askeshav-devel.jf.intel.com> <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46792586.20706@linux.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 06:03:02AM -0700, Arjan van de Ven wrote:
> Peter Zijlstra wrote:
> >
> >
> >PF_MEMALLOC as is, is meant to salvage the VM from the typical VM
> >deadlock. 
> 
> .. and this IS the typical VM deadlock.. it is your storage driver 
> trying to write out a piece of memory on behalf of the VM, and calls 
> the iommu to map it, which then needs a bit of memory....

Today PF_MEMALLOC doesn't do much in interrupt context. If PF_MEMALLOC
is the right usage model for this, then we need to fix the behavior of
PF_MEMALLOC in the interrupt context(for our usage model, we do most
of the allocations in interrupt context).

I am not very familiar with PF_MEMALLOC. So experts please comment.

thanks,
suresh
