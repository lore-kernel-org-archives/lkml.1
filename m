Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXFUG3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXFUG3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXFUG3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:29:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXFUG3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:29:39 -0400
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation
	failures	in	dma	map api calls
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
In-Reply-To: <467A1679.8090202@linux.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.798646000@askeshav-devel.jf.intel.com>
	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>
	 <20070620173038.GA25516@linux-os.sc.intel.com>
	 <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com>
	 <1182370132.21117.84.camel@twins>
	 <20070620230337.GA6771@linux-os.sc.intel.com>
	 <1182406212.21117.94.camel@twins>  <467A1679.8090202@linux.intel.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 08:29:34 +0200
Message-Id: <1182407374.21117.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 23:11 -0700, Arjan van de Ven wrote:
> Peter Zijlstra wrote:
> > What I'm saying is that if you do use the reserves, you should ensure
> > the use is bounded. I'm not seeing anything like that.
> 
> each mapping takes at most 3 pages

That is a start, but the thing I'm worried most about is non-reclaim
related devices using the thing when in dire straights.

> > This is a generic API, who is to ensure some other non-swap device will
> > not deplete memory and deadlock the reclaim process?
> 
> that information is not available at this level ;(

Can we bring it there?

> > Also, explain to me how an IOMMU is different from bounce buffers? They
> > both do the same thing, no? They both need memory in order to complete
> > DMA.
> 
> bounce buffers happen in a place where you can sleep.... that makes a 
> lot of difference.

Right, can't you stick part of this work there?

> > 
> > Is it just a broken API you're working against? If so, isn't the Linux
> > way to fix these things, that is why we have the source code after all.
> 
> well yes and no... the other iommu's snuck in as well... it's not 
> entirely fair to hold this one back until a 2 year, 1400 driver 
> project is completed ;(

I understand, but at some point we should stop; we cannot keep taking
crap in deference of such things.

Also, the other iommu code you pointed me to, was happy to fail, it did
not attempt to use the emergency reserves.


But you left out the mempools question again. I have read the earlier
threads, and it was said mempools are no good because they first deplete
GFP_ATOMIC reserves and then down-stream allocs could go splat.
PF_MEMALLOC/GFP_EMERGENCY has exactly the same problem...

So why no mempools?

