Return-Path: <linux-kernel-owner+w=401wt.eu-S939548AbXFHWV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939548AbXFHWV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbXFHWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:21:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:3163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbXFHWVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="252454767"
Date: Fri, 8 Jun 2007 15:18:03 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andreas Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608221803.GT17143@linux-os.sc.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org> <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <20070608212054.GB641@linux-os.sc.intel.com> <20070608144207.07341ee7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608144207.07341ee7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:42:07PM -0700, Andrew Morton wrote:
> I'd say just remove the whole thing and use kmem_cache_alloc().

We will try that.

> Put much effort into removing the GFP_ATOMIC and using GFP_NOIO instead:
> there's your problem right there.

As these are called from interrupt handlers, we can't use GFP_NOIO.

> If for some reason you really can't do that (and a requirement for
> allocation-in-interrupt is the only valid reason, really) and if you indeed
> can demonstrate memory allocation failures with certain workloads then
> let's take a look at that.  As I said, attaching a reserve pool to your
> slab cache might be a suitable approach.  But none of these things are

I agree. We are better off with enhancing slab infrastructure for this, if
needed.

> magic: if memory allcoation failures or deadlocks or livelocks are
> demonstrable with the reserves absent, then they'll also be possible with
> the reserves present.
> 
> Unless you use mempools, and can sleep.
