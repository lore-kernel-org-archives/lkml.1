Return-Path: <linux-kernel-owner+w=401wt.eu-S1032421AbXFHWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032421AbXFHWcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032388AbXFHWbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:31:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:38267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032378AbXFHWbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:31:35 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Sat, 9 Jun 2007 00:31:04 +0200
User-Agent: KMail/1.9.1
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <20070608135555.e580ada3.akpm@linux-foundation.org>
In-Reply-To: <20070608135555.e580ada3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706090031.05531.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2007 22:55, Andrew Morton wrote:
> On Fri, 8 Jun 2007 22:43:10 +0200 (CEST)
>
> Andreas Kleen <ak@suse.de> wrote:
> > > That's what kmem_cache_alloc() is for?!?!
> >
> > Tradtionally that was not allowed in block layer path. Not sure
> > it is fully obsolete with the recent dirty tracking work, probably not.
> >
> > Besides it would need to be GFP_ATOMIC and the default
> > atomic pools are not that big.
>
> That in itself is a problem.  What do we have to do to be able
> to make these allocations use the *much* stronger GFP_NOIO?

That still sleeps.

Allow networking and block drivers (and other device drivers) to
map SGs without holding spinlocks. 

Would be major work. I've been asking for it for years
because it would also avoid other nasty problem, like the panic-on-overflow
issues with swiotlb/AMD GART iommu -- it could just block for free
space instead.

-Andi
