Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbXHBRbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbXHBRbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXHBRbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:31:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:25869 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbXHBRbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:31:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,214,1183359600"; 
   d="scan'208";a="258044672"
Date: Thu, 2 Aug 2007 10:25:10 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andi K <ak@suse.de>, arjan <arjan@linux.intel.com>,
       Ashok Raj <ashok.raj@intel.com>, Suresh B <suresh.b.siddha@intel.com>
Subject: Re: [patch -mm][Intel-IOMMU] Optimize sg map/unmap calls
Message-ID: <20070802172509.GA1926@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070801200623.GA20780@linux-os.sc.intel.com> <20070801164554.5d2d157a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801164554.5d2d157a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:45:54PM -0700, Andrew Morton wrote:
> On Wed, 1 Aug 2007 13:06:23 -0700
> "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > +/* Computes the padding size required, to make the
> > + * the start address naturally aligned on its size
> > + */
> > +static int
> > +iova_get_pad_size(int size, unsigned int limit_pfn)
> > +{
> > +	unsigned int pad_size = 0;
> > +	unsigned int order = ilog2(size);
> > +
> > +	if (order)
> > +		pad_size = (limit_pfn + 1) % (1 << order);
> > +
> > +	return pad_size;
> > +}
> 
> This isn't obviously doing the right thing for non-power-of-2 inputs.
> ilog2() rounds down...
Andrew,
	The call chain to iova_get_pad_size() is like this
alloc_iova()--->__alloc_iova_range()--->iova_get_pad_size().

Inside the alloc_iova() we are rounding the size to __roundup_pow_of_two(size)
iff the caller of alloc_iova() request by setting size_aligned bool. And
in every call to iova_get_pad_size() we check the size_aligned bool before calling
iova_get_pad_size.  Hence I don;t see any issues. If you want I can insert a 
BUG_ON() statement inside the above iova_get_pad_size() function. 
Please do let me know.

thanks,
Anil
