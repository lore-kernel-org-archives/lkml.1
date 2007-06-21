Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbXFUGfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbXFUGfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXFUGe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:34:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:34821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXFUGe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,446,1175497200"; 
   d="scan'208";a="259402783"
Date: Wed, 20 Jun 2007 23:30:40 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures	in	dma	map api calls
Message-ID: <20070621063039.GB6771@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213808.798646000@askeshav-devel.jf.intel.com> <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com> <20070620173038.GA25516@linux-os.sc.intel.com> <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com> <1182370132.21117.84.camel@twins> <20070620230337.GA6771@linux-os.sc.intel.com> <1182406212.21117.94.camel@twins> <467A1679.8090202@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467A1679.8090202@linux.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 11:11:05PM -0700, Arjan van de Ven wrote:
> Peter Zijlstra wrote:
> >What I'm saying is that if you do use the reserves, you should ensure
> >the use is bounded. I'm not seeing anything like that.
> 
> each mapping takes at most 3 pages
With 3 pages(3 level page table), IOMMU can map at 
most 2MB and each additional last level page helps
map another 2MB. Again, the IOMMU driver re-uses the
virtual address instead of giving contiguous virtual address
which helps to keep the page table growth and helps
reuse the same page table entries, in that sense we are
bounded, again we are not sure how much IO will be in flight
on a perticular system so as to reserve that many pages for
IOMMU page table setup.

-Anil
